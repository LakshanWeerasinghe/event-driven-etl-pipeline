import ballerina/time;

type EmployementStatus UN_EMPLOYED|SELF_EMPLOYED|PERMENET|CONTRACT|PART_TIME;

type LoanRequest record {|
    string loanId;
    decimal amount;
    int loanDuration;
    string pourpose;
    Customer customer;
|};

type Customer record {|
    string customerId;
    string firstName;
    string lastName;
    time:Date dob;
    string ssn;
    decimal income;
    EmployementStatus employementStatus;
    string address;
|};

type CreditScoreResponse record {|
    string ssn;
    int score;
|};

type CreditHistoryResponse record {|
    string ssn;
    CreditHistory creditHistory;
|};

type CreditHistory record {|
    int totalLoans;
    int currentLoans;
    int closedLoans;
    int paymentsOnTime;
    int latePayments;
    int defaults;
    decimal totalDebt;
    decimal monthlyDebt;
|};

type ChatGptResponse record {|
    float probability;
|};
