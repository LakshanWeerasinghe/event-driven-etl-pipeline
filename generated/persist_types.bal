// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type EnrichedLoanRequest record {|
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

public type EnrichedLoanRequestOptionalized record {|
    string loanRequestId?;
    int totalLoans?;
    int currentLoans?;
    int closedLoans?;
    int paymentsOnTime?;
    int latePayments?;
    int defaults?;
    decimal totalDebt?;
    decimal monthlyDebt?;
    int creditScore?;
    float loanRepaymentProbability?;
    decimal dtir?;
|};

public type EnrichedLoanRequestTargetType typedesc<EnrichedLoanRequestOptionalized>;

public type EnrichedLoanRequestInsert EnrichedLoanRequest;

public type EnrichedLoanRequestUpdate record {|
    int totalLoans?;
    int currentLoans?;
    int closedLoans?;
    int paymentsOnTime?;
    int latePayments?;
    int defaults?;
    decimal totalDebt?;
    decimal monthlyDebt?;
    int creditScore?;
    float loanRepaymentProbability?;
    decimal dtir?;
|};

