// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.
import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/persist.sql as psql;

const ENRICHED_LOAN_REQUEST = "enrichedloanrequests";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final mysql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [ENRICHED_LOAN_REQUEST] : {
            entityName: "EnrichedLoanRequest",
            tableName: "EnrichedLoanRequest",
            fieldMetadata: {
                loanRequestId: {columnName: "loanRequestId"},
                totalLoans: {columnName: "totalLoans"},
                currentLoans: {columnName: "currentLoans"},
                closedLoans: {columnName: "closedLoans"},
                paymentsOnTime: {columnName: "paymentsOnTime"},
                latePayments: {columnName: "latePayments"},
                defaults: {columnName: "defaults"},
                totalDebt: {columnName: "totalDebt"},
                monthlyDebt: {columnName: "monthlyDebt"},
                creditScore: {columnName: "creditScore"},
                loanRepaymentProbability: {columnName: "loanRepaymentProbability"},
                dtir: {columnName: "dtir"}
            },
            keyFields: ["loanRequestId"]
        }
    };

    public isolated function init() returns persist:Error? {
        mysql:Client|error dbClient = new (host = host, user = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {[ENRICHED_LOAN_REQUEST] : check new (dbClient, self.metadata.get(ENRICHED_LOAN_REQUEST), psql:MYSQL_SPECIFICS)};
    }

    isolated resource function get enrichedloanrequests(EnrichedLoanRequestTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get enrichedloanrequests/[string loanRequestId](EnrichedLoanRequestTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post enrichedloanrequests(EnrichedLoanRequestInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ENRICHED_LOAN_REQUEST);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from EnrichedLoanRequestInsert inserted in data
            select inserted.loanRequestId;
    }

    isolated resource function put enrichedloanrequests/[string loanRequestId](EnrichedLoanRequestUpdate value) returns EnrichedLoanRequest|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ENRICHED_LOAN_REQUEST);
        }
        _ = check sqlClient.runUpdateQuery(loanRequestId, value);
        return self->/enrichedloanrequests/[loanRequestId].get();
    }

    isolated resource function delete enrichedloanrequests/[string loanRequestId]() returns EnrichedLoanRequest|persist:Error {
        EnrichedLoanRequest result = check self->/enrichedloanrequests/[loanRequestId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ENRICHED_LOAN_REQUEST);
        }
        _ = check sqlClient.runDeleteQuery(loanRequestId);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

