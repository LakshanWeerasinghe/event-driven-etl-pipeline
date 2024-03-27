import ballerina/http;
import ballerina/lang.value;
import ballerina/log;
import ballerina/uuid;
import ballerinax/kafka;
import ballerinax/openai.chat;

final http:Client loanClient = check new (loanAPIUrl);
final http:Client creditUnionEp = check new (creditUnionAPI);
final Client dbClient = check new;
final chat:Client openAiChat = check new ({auth: {token: openAIKey}});

listener kafka:Listener eventListener = check new (kafkaUrl, {
    groupId: "personal" + uuid:createType1AsString(),
    topics: "personal",
    auth: {username: kafkaUsername, password: kafkaPassword},
    secureSocket: {cert: "./resources/ca-certificate.crt", protocol: {name: kafka:SSL}},
    securityProtocol: kafka:PROTOCOL_SASL_SSL
});

service on eventListener {

    remote function onConsumerRecord(string[] loanRequestIds) {
        foreach string loanRequestId in loanRequestIds {
            do {
                log:printInfo(string `START: Process loan request id: ${loanRequestId}`);

                // extract the loan request data
                LoanRequest loanRequest = check loanClient->/loan/request(id = loanRequestId);

                // transform
                var {ssn, income} = loanRequest.customer;

                CreditScoreResponse creditScore = check creditUnionEp->/credit\-score(ssn = ssn);
                CreditHistoryResponse creditHistory = check creditUnionEp->/credit\-history(ssn = ssn);

                // debt to income (DTI) ratio
                decimal dtir = creditHistory.creditHistory.monthlyDebt / income;
                float loanRepaymentProbability = getLoanRepaymentProbability(loanRequest, creditHistory.creditHistory, dtir, creditScore.score);

                EnrichedLoanRequest enrichedLoanRequest = {
                    ...creditHistory.creditHistory,
                    creditScore: creditScore.score,
                    loanRequestId,
                    dtir,
                    loanRepaymentProbability
                };
                _ = check dbClient->/enrichedloanrequests.post([enrichedLoanRequest]);
                log:printInfo(string `END: Process loan request id: ${loanRequestId}`);
            } on fail error err {
                log:printError(string `Loan request processing failed with error: ${err.message()}`);
            }
        }
    }
}

function getLoanRepaymentProbability(LoanRequest loanRequest, CreditHistory creditHistory,
        decimal dtir, int creditScore) returns float {
    do {
        chat:CreateChatCompletionRequest request = {
            model: "gpt-3.5-turbo",
            messages: [
                {
                    role: "user",
                    content: string `I want to know loan repayment probablity of this customer.
                    The loan amount and credit history is given below.
                    {
                        totalLoans: ${creditHistory.totalLoans},
                        loanAmount: ${loanRequest.amount},
                        currentLoans: ${creditHistory.currentLoans},
                        closedLoans: ${creditHistory.closedLoans},
                        paymentsOnTime: ${creditHistory.paymentsOnTime},
                        latePayments: ${creditHistory.latePayments},
                        defaults: ${creditHistory.defaults},
                        totalDebt: ${creditHistory.totalDebt},
                        monthlyDebt: ${creditHistory.monthlyDebt},
                        debtToIncomeRatio: ${dtir},
                        creditScore: ${creditScore},
                        annualIncome: ${loanRequest.customer.income}
                    }
                    Calculate the loan repayment probability. Return the result in below JSON format.
                    {probability: float}
                    `
                }
            ]

        };
        chat:CreateChatCompletionResponse summary = check openAiChat->/chat/completions.post(request);
        if summary.choices.length() > 0 {
            string? content = summary.choices[0]?.message.content;
            if content is string {
                ChatGptResponse response = check value:fromJsonStringWithType(content);
                return response.probability;
            }
        }
        check error("Error while parsing the LLM response");
    } on fail error err {
        log:printError(string `Error in loan repayment probability error: ${err.message()}`);
        return 0.5;
    }
    return 0.5;
}
