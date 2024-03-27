import ballerina/persist as _;

type EnrichedLoanRequest record {|
    readonly string loanRequestId;
    int totalLoans;
    int currentLoans;
    int closedLoans;
    int paymentsOnTime;
    int latePayments;
    int defaults;
    decimal totalDebt;
    decimal monthlyDebt;
    int creditScore;
    float loanRepaymentProbability;
    decimal dtir;
|};

