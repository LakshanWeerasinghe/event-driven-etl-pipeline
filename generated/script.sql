-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS `EnrichedLoanRequest`;

CREATE TABLE `EnrichedLoanRequest` (
	`loanRequestId` VARCHAR(191) NOT NULL,
	`totalLoans` INT NOT NULL,
	`currentLoans` INT NOT NULL,
	`closedLoans` INT NOT NULL,
	`paymentsOnTime` INT NOT NULL,
	`latePayments` INT NOT NULL,
	`defaults` INT NOT NULL,
	`totalDebt` DECIMAL(65,30) NOT NULL,
	`monthlyDebt` DECIMAL(65,30) NOT NULL,
	`creditScore` INT NOT NULL,
	`loanRepaymentProbability` DOUBLE NOT NULL,
	`dtir` DECIMAL(65,30) NOT NULL,
	PRIMARY KEY(`loanRequestId`)
);
