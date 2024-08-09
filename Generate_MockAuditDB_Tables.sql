--------------------------------------------
-- This SQL script creates all the tables for the MockAuditDB
-- NOTE: some columns are created using randomized values. If the script is re-run, new values in each table will be generated
--------------------------------------------

-- Drop tables if they exist
DROP TABLE IF EXISTS FinancialAuditMaster
DROP TABLE IF EXISTS ExpenseClaimAudit; 
DROP TABLE IF EXISTS EmployeeInfo;
DROP TABLE IF EXISTS PortfolioInvestments;
DROP TABLE IF EXISTS VendorDetails;
DROP TABLE IF EXISTS CustomerAccounts;
DROP TABLE IF EXISTS BankInformation;
DROP TABLE IF EXISTS InventoryItems;
DROP TABLE IF EXISTS ProjectTasks;
DROP TABLE IF EXISTS BudgetAllocationAudit;
DROP TABLE IF EXISTS FinancialRiskAudit;
DROP TABLE IF EXISTS FinancialStatementAudit;
DROP TABLE IF EXISTS TaxInformation;
DROP TABLE IF EXISTS LoanRepayments;

--------------------------------------------
--GENERATE DIMENSION TABLES
--------------------------------------------

-- Create EmployeeInfo table

CREATE TABLE EmployeeInfo (
    EmployeeId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Department VARCHAR(100),
    Position VARCHAR(100),
    Salary DECIMAL(18,2),
    HireDate DATE,
    TerminationDate DATE,
    IsActive BIT,
    Address VARCHAR(255),
    EmergencyContact VARCHAR(100)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT EmployeeInfo ON;

-- Insert mock data into EmployeeInfo
DECLARE @employeeCounter INT = 1;
DECLARE @StartDate DATE = '1950-01-01';
DECLARE @EndDate DATE = '2002-12-31';

WHILE @employeeCounter <= 15000
BEGIN
    INSERT INTO EmployeeInfo (
        EmployeeId, FirstName, LastName, DateOfBirth, Department, Position, Salary, HireDate, TerminationDate, IsActive, Address, EmergencyContact
    )
    VALUES (
        @employeeCounter, -- EmployeeId (PK that connects to FK in master)
        'FirstName' + CAST(@employeeCounter AS VARCHAR(10)),
        'LastName' + CAST(@employeeCounter AS VARCHAR(10)),
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, @StartDate, DATEADD(DAY, 1, @EndDate)), @StartDate), -- Random date of birth
        CASE -- Department
            WHEN @employeeCounter % 4 = 0 THEN 'Finance'
            WHEN @employeeCounter % 4 = 1 THEN 'Operations'
            WHEN @employeeCounter % 4 = 2 THEN 'Sales'
            WHEN @employeeCounter % 4 = 3 THEN 'Marketing'
        END,
        'Position' + CAST(@employeeCounter % 5 AS VARCHAR(10)),
        ROUND(RAND() * 150000, 2), -- Random salary
        DATEADD(DAY, -@employeeCounter, GETDATE()), -- Random hire date
        NULL, --termination date
        1, --isactive
        'Address ' + CAST(@employeeCounter AS VARCHAR(10)),
        'EmergencyContact ' + CAST(@employeeCounter AS VARCHAR(10))
    );

    SET @employeeCounter = @employeeCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT EmployeeInfo OFF;

-- Create ExpenseClaimAudit table

CREATE TABLE ExpenseClaimAudit (
    ClaimId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    EmployeeId INT,
    CONSTRAINT FK_ExpenseClaimAudit_EmployeeInfo FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo (EmployeeId),
    ClaimDate DATE,
    ExpenseCategory VARCHAR(100),
    AmountClaimed DECIMAL(18,2),
    ReceiptAttached BIT,
    ApprovalStatus VARCHAR(50),
    Comments VARCHAR(MAX),
    PaymentMethod VARCHAR(50),
    CurrencyCode CHAR(3)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT ExpenseClaimAudit ON;

-- Insert mock data into ExpenseClaimAudit
DECLARE @expenseCounter INT = 1;

WHILE @expenseCounter <= 18000
BEGIN
    INSERT INTO ExpenseClaimAudit (
        ClaimId, EmployeeId, ClaimDate, ExpenseCategory, AmountClaimed, ReceiptAttached, ApprovalStatus, Comments, PaymentMethod, CurrencyCode
    )
    VALUES (
        @expenseCounter, -- ClaimId
        ABS(CHECKSUM(NEWID())) % 15000 + 1, -- Random EmployeeId within the range of existing EmployeeIds
        DATEADD(DAY, -@expenseCounter, GETDATE()), -- Random claim date
        'Category' + CAST(@expenseCounter % 10 AS VARCHAR(10)), -- expense category
        ROUND(RAND() * 1000, 2), -- Random amount claimed
        @expenseCounter % 2,
        'Status' + CAST(@expenseCounter % 3 AS VARCHAR(10)),
        'Comments for claim ' + CAST(@expenseCounter AS VARCHAR(10)),
        'Method' + CAST(@expenseCounter % 5 AS VARCHAR(10)),
        'USD'
    );

    SET @expenseCounter = @expenseCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT ExpenseClaimAudit OFF;

-- Create VendorDetails table

CREATE TABLE VendorDetails (
    VendorId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    VendorName VARCHAR(255),
    ContactPerson VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    PaymentTerms VARCHAR(50),
    IsActive BIT,
    Website VARCHAR(100)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT VendorDetails ON;

-- Insert mock data into VendorDetails
DECLARE @vendorCounter INT = 1;

WHILE @vendorCounter <= 30000
BEGIN
    INSERT INTO VendorDetails (
        VendorId, VendorName, ContactPerson, Email, Phone, Address, PaymentTerms, IsActive, Website
    )
    VALUES (
        @vendorCounter, -- VendorID (PK that connects to FK Id in master)
        'VendorName' + CAST(@vendorCounter AS VARCHAR(10)),
        'ContactPerson' + CAST(@vendorCounter AS VARCHAR(10)),
        'vendor' + CAST(@vendorCounter AS VARCHAR(10)) + '@example.com',
        '555-' + RIGHT('0000' + CAST(@vendorCounter AS VARCHAR(4)), 4),
        'Address ' + CAST(@vendorCounter AS VARCHAR(10)),
        'Net ' + CAST((@vendorCounter % 60) + 1 AS VARCHAR(10)),
        1,
        'https://example.com/vendor' + CAST(@vendorCounter AS VARCHAR(10))
    );

    SET @vendorCounter = @vendorCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT VendorDetails OFF;

-- Create PortfolioInvestments table

CREATE TABLE PortfolioInvestments (
    VendorId INT,
	CONSTRAINT FK_PortfolioInvestments_VendorDetails FOREIGN KEY (VendorId) REFERENCES VendorDetails (VendorId),
    InvestmentId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    InvestmentType VARCHAR(50),
    PurchaseDate DATE,
    CurrentValue DECIMAL(12,2),
    Quantity INT,
    Sector VARCHAR(50),
    DividendYield DECIMAL(5,2),
    MarketValue DECIMAL(12,2),
    InvestmentStatus VARCHAR(20),
    Notes VARCHAR(MAX)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT PortfolioInvestments ON;

-- Insert mock data into PortfolioInvestments
DECLARE @investmentsCounter INT = 1;

WHILE @investmentsCounter <= 30000
BEGIN
    INSERT INTO PortfolioInvestments (
        VendorId, InvestmentId, InvestmentType, PurchaseDate, CurrentValue, Quantity, Sector, DividendYield, MarketValue, InvestmentStatus, Notes
    )
    VALUES (
        CASE --VendorId FK (1-30,000: assign higher prob to lower numbers for variation) that connects to VendorId PK in VendorDetails,
			WHEN RAND() <= 0.65 THEN FLOOR(RAND() * 1000) + 1
			ELSE FLOOR(RAND() * 29000) + 1001
		END,
		@investmentsCounter, -- InvestmentId
        'Type' + CAST(@investmentsCounter % 5 AS VARCHAR(10)),
        DATEADD(DAY, -@investmentsCounter % 365, GETDATE()), -- Random purchase date within the last year
        CAST((RAND() * (100000 - 1000) + 1000) AS DECIMAL(12,2)), -- Random current value between 1,000 and 100,000
        CAST((RAND() * 1000) AS INT), -- Random quantity between 1 and 1,000
        'Sector' + CAST(@investmentsCounter % 10 AS VARCHAR(10)),
        CAST((RAND() * 10) AS DECIMAL(5,2)), -- Random dividend yield between 0 and 10
        CAST((RAND() * (100000 - 1000) + 1000) AS DECIMAL(12,2)), -- Random market value between 1,000 and 100,000
        'Status' + CAST(@investmentsCounter % 3 AS VARCHAR(10)),
        'Notes for investment ' + CAST(@investmentsCounter AS VARCHAR(10))
    );

    SET @investmentsCounter = @investmentsCounter + 1;
END;

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT PortfolioInvestments OFF;

-- Create BankInformation table

CREATE TABLE BankInformation (
    BankId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    BankName VARCHAR(50),
    AccountType VARCHAR(20),
    BranchLocation VARCHAR(100),
    IsRegional BIT
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT BankInformation ON;

-- Insert mock data into BankInformation
DECLARE @bankCounter INT = 1;

WHILE @bankCounter <= 15000
BEGIN
    INSERT INTO BankInformation (
        BankID, BankName, AccountType, BranchLocation, IsRegional
    )
    VALUES (
        @bankCounter, -- BankID PK that connects to FK BankId in CustomerAccounts
        'BankName' + CAST(@bankCounter AS VARCHAR(10)),
        'Type' + CAST(@bankCounter % 5 AS VARCHAR(10)),
        'BranchLocation' + CAST(@bankCounter AS VARCHAR(10)),
        @bankCounter % 2
    );

    SET @bankCounter = @bankCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT BankInformation OFF;

-- Create CustomerAccounts

CREATE TABLE CustomerAccounts (
    AccountId INT,
    AccountNumber VARCHAR(20) NOT NULL PRIMARY KEY,
    BankId INT,
	CONSTRAINT FK_CustomerAccounts_BankInformation FOREIGN KEY (BankId) REFERENCES BankInformation (BankId),
    CustomerName VARCHAR(255),
    Balance DECIMAL(18,2),
    LastTransactionDate DATE,
    IsActive BIT,
    CreditLimit DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    AccountHolder VARCHAR(100),
    OverdraftLimit DECIMAL(12,2)
);

--identity insert not needed for CustomerAccounts since PK is varchar

-- Insert mock data into CustomerAccounts

DECLARE @customerCounter INT = 1;
WHILE @customerCounter <= 10000
BEGIN
    INSERT INTO CustomerAccounts (
        AccountId, AccountNumber, BankId, CustomerName, Balance, LastTransactionDate, IsActive, CreditLimit, InterestRate, AccountHolder, OverdraftLimit
    )
    VALUES (
        @customerCounter,
        'ACC' + RIGHT('00000' + CAST(@customerCounter AS VARCHAR(5)), 5), --PK that connects to FK AcctNumber in master
        CASE -- Random bank ID (1-15,000: assign lower prob to lower numbers for variation)
			WHEN RAND() <= 0.2 THEN FLOOR(RAND() * 1000) + 1
			ELSE FLOOR(RAND() * 14000) + 1001
		END, 
        'CustomerName' + CAST(@customerCounter AS VARCHAR(10)),
        ROUND(RAND() * 500000, 2), -- Random balance
        DATEADD(DAY, -@customerCounter, GETDATE()), -- Random last transaction date
        1,
        ROUND(RAND() * 50000, 2), -- Random credit limit
        ROUND(RAND() * 10, 2), -- Random interest rate
        'AccountHolder' + CAST(@customerCounter AS VARCHAR(10)),
        ROUND(RAND() * 10000, 2) -- Random overdraft limit
    );

    SET @customerCounter = @customerCounter + 1;
END

-- Create InventoryItems table

CREATE TABLE InventoryItems (
    ItemId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    ItemName VARCHAR(100),
    Description VARCHAR(MAX),
    Category VARCHAR(50),
    UnitPrice DECIMAL(18,2),
    StockQuantity INT,
    ReorderLevel INT,
    SupplierId INT,
    Manufacturer VARCHAR(100)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT InventoryItems ON;

-- Insert mock data into InventoryItems
DECLARE @inventoryCounter INT = 1;

WHILE @inventoryCounter <= 10000
BEGIN
    INSERT INTO InventoryItems (
        ItemId, ItemName, Description, Category, UnitPrice, StockQuantity, ReorderLevel, SupplierId, Manufacturer
    )
    VALUES (
        @inventoryCounter, -- ItemId (PK that connects to FK Id in master)
        'ItemName' + CAST(@inventoryCounter AS VARCHAR(10)),
        'Description for item ' + CAST(@inventoryCounter AS VARCHAR(10)),
        'Category' + CAST(@inventoryCounter % 10 AS VARCHAR(10)),
        ROUND(RAND() * 1000, 2), -- Random unit price
        CAST(RAND() * 1000 AS INT), -- Random stock quantity
        CAST(RAND() * 100 AS INT), -- Random reorder level
        @inventoryCounter % 100 + 1, -- Random supplier ID
        'Manufacturer' + CAST(FLOOR(RAND() * 4 + 1) AS VARCHAR(1))
    );

    SET @inventoryCounter = @inventoryCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT InventoryItems OFF;

-- Create ProjectTasks table

CREATE TABLE ProjectTasks (
    ProjectId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	ProjectName VARCHAR(20),
    TaskName VARCHAR(100),
    AssignedTo VARCHAR(255),
    DueDate DATE,
    Status VARCHAR(50),
    Priority VARCHAR(20),
    EstimatedHours DECIMAL(18,2),
	ProjectDescription VARCHAR(MAX)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT ProjectTasks ON;

-- Insert mock data into ProjectTasks
DECLARE @projectCounter INT = 1;

WHILE @projectCounter <= 12000
BEGIN
    INSERT INTO ProjectTasks (
        ProjectId, ProjectName, TaskName, AssignedTo, DueDate, Status, Priority, EstimatedHours, ProjectDescription
    )
    VALUES (
        @projectCounter, -- project ID
		'Project' + CAST(@projectCounter AS VARCHAR(10)), -- ProjectName
        CASE -- TaskName
			WHEN @projectCounter % 10 = 0 THEN 'Financial Performance Metrics Development'
			WHEN @projectCounter % 9 = 0 THEN 'Tax Planning and Strategy'
			WHEN @projectCounter % 8 = 0 THEN 'Cash Flow Management'
			WHEN @projectCounter % 7 = 0 THEN 'Financial Compliance Audit'
			WHEN @projectCounter % 6 = 0 THEN 'Cost-Benefit Analysis'
			WHEN @projectCounter % 5 = 0 THEN 'Investment Portfolio Review'
			WHEN @projectCounter % 4 = 0 THEN 'Revenue Stream Optimization'
			WHEN @projectCounter % 3 = 0 THEN 'Expense Tracking and Reporting'
			WHEN @projectCounter % 2 = 0 THEN 'Financial Risk Assessment'
			ELSE 'Budget Analysis and Forecasting'
		END,
        'AssignedTo' + CAST(@projectCounter AS VARCHAR(10)),
        DATEADD(DAY, @projectCounter, GETDATE()), -- Random due date
        'Status' + CAST(@projectCounter % 5 AS VARCHAR(10)),
        FLOOR(RAND() * 4) + 1, -- Priority
        ROUND(RAND() * 100, 2), -- Random estimated hours
		CASE -- ProjectDescription (assign just to the first few rows for testing)
			WHEN @projectCounter = 1 THEN 'Project Alpha is a comprehensive financial analysis initiative aimed at optimizing the investment portfolio of a mid-sized enterprise. The project involves a detailed examination of current asset allocations, risk assessments, and market trends. By leveraging advanced data analytics and machine learning algorithms, the team aims to identify underperforming assets and recommend strategic reallocations. The project also includes the development of a custom dashboard for real-time monitoring of portfolio performance, enabling stakeholders to make informed decisions swiftly. Additionally, the project will explore opportunities for diversification into emerging markets, ensuring a balanced and resilient investment strategy. The ultimate goal is to enhance overall returns while minimizing risks, thereby securing the financial stability and growth of the enterprise.'
			WHEN @projectCounter = 2 THEN 'Project Beta focuses on the implementation of a new budgeting and forecasting system for a multinational corporation. The project aims to streamline financial planning processes by integrating various data sources into a unified platform. This will enable more accurate and timely forecasts, improving the company’s ability to respond to market changes. Key components of the project include the development of predictive models to anticipate revenue fluctuations, cost management strategies, and scenario analysis tools. The project team will also provide training for finance staff to ensure effective use of the new system. By enhancing the accuracy and efficiency of financial planning, Project Beta aims to support the company’s strategic objectives and drive long-term profitability.'
			WHEN @projectCounter = 3 THEN 'Project Gamma is an initiative to overhaul the financial reporting system of a regional bank. The project’s primary objective is to enhance transparency and compliance with regulatory requirements. This involves the automation of data collection and reporting processes, reducing the risk of errors and ensuring timely submission of reports. The project will also introduce advanced analytics to provide deeper insights into financial performance and risk management. Key deliverables include a user-friendly reporting interface, comprehensive training for finance personnel, and ongoing support to address any issues. By improving the accuracy and efficiency of financial reporting, Project Gamma aims to strengthen the bank’s reputation and regulatory standing.'
			WHEN @projectCounter = 4 THEN 'Project Delta is a strategic initiative to develop a financial risk management framework for a large insurance company. The project involves identifying and assessing various financial risks, including market, credit, and operational risks. The team will develop risk mitigation strategies and implement tools for continuous monitoring and reporting. A key component of the project is the integration of risk management practices into the company’s overall business strategy, ensuring a proactive approach to risk management. The project will also include training programs for staff to enhance their understanding of risk management principles and practices. By establishing a robust risk management framework, Project Delta aims to protect the company’s financial health and support sustainable growth.'
			WHEN @projectCounter = 5 THEN 'Project Epsilon is a financial transformation project for a government agency. The project aims to modernize the agency’s financial systems and processes, improving efficiency and accountability. This includes the implementation of an integrated financial management system, the automation of routine tasks, and the development of performance metrics to track progress. The project will also focus on enhancing data security and compliance with regulatory standards. Key deliverables include a comprehensive project plan, stakeholder engagement strategies, and training programs for finance staff. By modernizing its financial operations, Project Epsilon aims to enhance the agency’s ability to manage public funds effectively and deliver better services to citizens.'
		ELSE NULL END
	);

    SET @projectCounter = @projectCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT ProjectTasks OFF;

-- Create BudgetAllocationAudit table

CREATE TABLE BudgetAllocationAudit (
    BudgetId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    BudgetYear INT,
    Department VARCHAR(100),
    AllocationAmount DECIMAL(18,2),
    AllocationDate DATE,
    ApprovedBy VARCHAR(255),
    Purpose VARCHAR(MAX),
    Status VARCHAR(50),
    CurrencyCode CHAR(3),
    ProjectId INT
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT BudgetAllocationAudit ON;

-- Insert mock data into BudgetAllocationAudit
DECLARE @budgetCounter INT = 1;

WHILE @budgetCounter <= 21000
BEGIN
    INSERT INTO BudgetAllocationAudit (
        BudgetId, BudgetYear, Department, AllocationAmount, AllocationDate, ApprovedBy, Purpose, Status, CurrencyCode, ProjectId
    )
    VALUES (
        @budgetCounter, -- BudgetId
        2024,--BudgetYear
        'Department' + CAST(@budgetCounter % 10 AS VARCHAR(10)),
        ROUND(RAND() * 100000, 2), -- Random allocation amount
        DATEADD(DAY, -@budgetCounter, GETDATE()), -- Random allocation date
        'ApprovedBy' + CAST(@budgetCounter AS VARCHAR(10)),
        'Purpose for allocation ' + CAST(@budgetCounter AS VARCHAR(10)),
        'Status' + CAST(@budgetCounter % 3 AS VARCHAR(10)),
        'USD',
        CAST((RAND() * 12000) AS INT) -- Random project ID (connect to ProjectTasks table)
    );

    SET @budgetCounter = @budgetCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT BudgetAllocationAudit OFF;

-- Create FinancialRiskAudit table

CREATE TABLE FinancialRiskAudit (
    RiskId  INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    RiskDescription VARCHAR(MAX),
    RiskCategory VARCHAR(100),
    Impact VARCHAR(50),
    Likelihood VARCHAR(50),
    MitigationPlan VARCHAR(MAX),
    ResponsiblePerson VARCHAR(255),
    RiskStatus VARCHAR(50),
    RiskAssessmentDate DATE,
    CurrencyCode CHAR(3)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT FinancialRiskAudit ON;

-- Insert mock data into FinancialRiskAudit
DECLARE @riskCounter INT = 1;

WHILE @riskCounter <= 17000
BEGIN
    INSERT INTO FinancialRiskAudit (
       RiskId, RiskDescription, RiskCategory, Impact, Likelihood, MitigationPlan, ResponsiblePerson, RiskStatus, RiskAssessmentDate, CurrencyCode
    )
    VALUES (
        @riskCounter, -- RiskId
        'Description for risk ' + CAST(@riskCounter AS VARCHAR(10)),
        'Category' + CAST(@riskCounter % 10 AS VARCHAR(10)),
        'Impact' + CAST(@riskCounter % 5 AS VARCHAR(10)),
        'Likelihood' + CAST(@riskCounter % 5 AS VARCHAR(10)),
        'Mitigation plan for risk ' + CAST(@riskCounter AS VARCHAR(10)),
        'ResponsiblePerson' + CAST(@riskCounter AS VARCHAR(10)),
        'Status' + CAST(@riskCounter % 3 AS VARCHAR(10)),
        DATEADD(DAY, -@riskCounter, GETDATE()), -- Random risk assessment date
        'USD'
    );

    SET @riskCounter = @riskCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT FinancialRiskAudit OFF;

-- Create FinancialStatementAudit table

CREATE TABLE FinancialStatementAudit (
    StatementId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    StatementType VARCHAR(100),
    PeriodStartDate DATE,
    PeriodEndDate DATE,
    TotalAssets DECIMAL(18,2),
    TotalLiabilities DECIMAL(18,2),
    NetIncome DECIMAL(18,2),
    AuditorName VARCHAR(255),
    AuditOpinion VARCHAR(100),
    CurrencyCode CHAR(3)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT FinancialStatementAudit ON;

-- Insert mock data into FinancialStatementAudit
DECLARE @statementCounter INT = 1;

WHILE @statementCounter <= 24000
BEGIN
    INSERT INTO FinancialStatementAudit (
        StatementId, StatementType, PeriodStartDate, PeriodEndDate, TotalAssets, TotalLiabilities, NetIncome, AuditorName, AuditOpinion, CurrencyCode
    )
    VALUES (
        @statementCounter,
        'Type' + CAST(@statementCounter % 5 AS VARCHAR(10)),
        DATEADD(MONTH, -@statementCounter % 24, GETDATE()), -- Random start date within last two years
        DATEADD(MONTH, -(@statementCounter % 24) + 1, GETDATE()), -- Random end date one month after start date
        CAST((RAND() * (1000000 - 10000) + 10000) AS DECIMAL(18,2)), -- Random total assets between 10k and 1m
        CAST((RAND() * (500000 - 5000) + 5000) AS DECIMAL(18,2)), -- Random total liabilities between 5k and 500k
        CAST((RAND() * (200000 - 2000) + 2000) AS DECIMAL(18,2)), -- Random net income between 2k and 200k
        'Auditor' + CAST(@statementCounter % 50 AS VARCHAR(10)),
        'Opinion' + CAST(@statementCounter % 4 AS VARCHAR(10)),
        'USD'
    );

    SET @statementCounter = @statementCounter + 1;
END;

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT FinancialStatementAudit OFF;

-- Create TaxInformation table

CREATE TABLE TaxInformation (
    TaxId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, 
    StatementType VARCHAR(100),
    TaxAmount DECIMAL(10,2),
	TaxRate DECIMAL(10,2),
    TaxType VARCHAR(50),
    TaxYear INT,
    FilingStatus VARCHAR(20),
    TaxDueDate DATE,
    TaxAgency VARCHAR(100),
    TaxPreparer VARCHAR(100),
    TaxPaymentStatus VARCHAR(20),
    Notes VARCHAR(MAX)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT TaxInformation ON;

-- Insert mock data into TaxInformation
DECLARE @taxCounter INT = 1;

WHILE @taxCounter <= 20000
BEGIN
    INSERT INTO TaxInformation (
        TaxId, StatementType, TaxAmount, TaxRate, TaxType, TaxYear, FilingStatus, TaxDueDate, TaxAgency, TaxPreparer, TaxPaymentStatus, Notes
    )
    VALUES (
        @taxCounter, -- TaxId PK that connects to TaxID FK in master table,
		CASE WHEN RAND() < 0.5 THEN 'Income Statement' ELSE 'Balance Sheet' END, -- StatementType
        CAST((RAND() * (10000 - 100) + 100) AS DECIMAL(10,2)), -- Random tax amount between 100 and 10,000
        ROUND(RAND() * 0.1, 2), -- TaxRate
        'Type' + CAST(@taxCounter % 5 AS VARCHAR(10)),
        2023 + (@taxCounter % 5), -- Random tax year between 2023 and 2027
        'Status' + CAST(@taxCounter % 3 AS VARCHAR(10)),
        DATEADD(DAY, @taxCounter % 365, GETDATE()), -- Random tax due date within the next year
        'Agency' + CAST(@taxCounter % 10 AS VARCHAR(10)),
        'Preparer' + CAST(@taxCounter % 10 AS VARCHAR(10)),
        'Status' + CAST(@taxCounter % 3 AS VARCHAR(10)),
        'Notes for tax ' + CAST(@taxCounter AS VARCHAR(10))
    );

    SET @taxCounter = @taxCounter + 1;
END;

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT TaxInformation OFF;

-- Create LoanRepayments table

CREATE TABLE LoanRepayments (
    LoanId INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, -- does NOT connect to master table (just for variety)
    AccountNumber VARCHAR(20),
    PaymentDueDate DATE,
    PaymentAmount DECIMAL(10,2),
    PrincipalBalance DECIMAL(12,2),
    InterestRate DECIMAL(5,2),
    LoanTerm INT,
    LoanType VARCHAR(50),
    LenderName VARCHAR(100),
    LoanRiskRating INT,
    LoanDescription VARCHAR(MAX)
);

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT LoanRepayments ON;

-- Insert mock data into LoanRepayments
DECLARE @loanCounter INT = 1;
DECLARE @LoanType NVARCHAR(50);

WHILE @loanCounter <= 19000
BEGIN
    SET @LoanType = CASE -- LoanType
        WHEN FLOOR(RAND() * 4) + 1 = 1 THEN 'Post-Audit Improvement Loan'
        WHEN FLOOR(RAND() * 4) + 1 = 2 THEN 'Audit Preparation Loan'
        WHEN FLOOR(RAND() * 4) + 1 = 3 THEN 'The Forensic Audit Loan'
        ELSE 'Audit Compliance Loan' END;

    INSERT INTO LoanRepayments (
        LoanID, AccountNumber, PaymentDueDate, PaymentAmount, PrincipalBalance, InterestRate, LoanTerm, LoanType, LenderName, LoanRiskRating, LoanDescription
    )
    VALUES (
        @loanCounter,-- LoanID (NOT connected to master table, just for variety)
        'ACC' + RIGHT('00000' + CAST(FLOOR(RAND() * 10000) + 1 AS VARCHAR(5)), 5), -- random acct number (connects to customer acct table)
        DATEADD(DAY, @loanCounter % 365, GETDATE()), -- Random payment due date within the next year
        CAST((RAND() * (10000 - 100) + 100) AS DECIMAL(10,2)), -- Random payment amount between 100 and 10,000
        CAST((RAND() * (100000 - 1000) + 1000) AS DECIMAL(12,2)), -- Random principal balance between 1,000 and 100,000
        CAST((RAND() * 10) AS DECIMAL(5,2)), -- Random interest rate between 0 and 10
        CAST((RAND() * 30) AS INT), -- Random loan term between 1 and 30 years
        @LoanType,
        (SELECT TOP 1 LenderName -- select random LenderName
             FROM (
                 SELECT 'PrimeLend Financial' AS LenderName
                 UNION ALL
                 SELECT 'SecureFund Loans'
                 UNION ALL
                 SELECT 'TrustWave Lending'
                 UNION ALL
                 SELECT 'CapitalEase Finance'
                 UNION ALL
                 SELECT 'BrightFuture Loans'
                 UNION ALL
                 SELECT 'EquityBridge Lending'
                 UNION ALL
                 SELECT 'NextGen Finance'
             ) AS lenders
             ORDER BY NEWID()), 
        FLOOR(RAND() * 3) + 1, -- LoanRiskRating
        CASE -- LoanDescription
            WHEN @LoanType = 'Post-Audit Improvement Loan' THEN 'The Post-Audit Improvement Loan is designed for businesses that have recently undergone a financial audit and need to implement recommended improvements. This loan provides the funds necessary to upgrade financial systems, enhance internal controls, and address any deficiencies identified during the audit. It helps businesses strengthen their financial management practices and achieve long-term stability'
            WHEN @LoanType = 'Audit Preparation Loan' THEN 'The Audit Preparation Loan is ideal for small to medium-sized enterprises (SMEs) preparing for their first major financial audit. This loan covers the costs of hiring experienced accountants, purchasing audit-related software, and conducting preliminary internal audits. It ensures that businesses are well-prepared and can present accurate financial statements to auditors.'
            WHEN @LoanType = 'The Forensic Audit Loan' THEN 'The Forensic Audit Loan is tailored for companies that suspect financial irregularities or fraud within their operations. This loan provides the capital needed to conduct a thorough forensic audit, uncover discrepancies, and implement corrective measures. It is an essential tool for businesses aiming to restore financial health and trust'
            ELSE 'The Audit Compliance Loan is designed for businesses that need to ensure their financial records meet regulatory standards. This loan provides the necessary funds to hire external auditors, upgrade accounting software, and train staff on compliance requirements. By securing this loan, businesses can avoid costly penalties and maintain their reputation for financial integrity'
			END
    );
    SET @loanCounter = @loanCounter + 1;
END

-- Disable IDENTITY_INSERT
SET IDENTITY_INSERT LoanRepayments OFF;

--------------------------------------------
--GENERATE FACT TABLE FinancialAuditMaster
--------------------------------------------

-- Create the table with an identity column
--IF OBJECT_ID('FinancialAuditMaster', 'U') IS NOT NULL
    --DROP TABLE FinancialAuditMaster;

CREATE TABLE FinancialAuditMaster (
    Id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    TransactionDate DATE,
    TransactionType VARCHAR(255),
    Amount DECIMAL(18, 2),
    Currency CHAR(3),
	TransactionFlag BIT,
    VendorId INT,
	CONSTRAINT FK_FinancialAuditMaster_VendorDetails FOREIGN KEY (VendorId) REFERENCES VendorDetails (VendorId),
	RiskId INT, 
	CONSTRAINT FK_FinancialAuditMaster_FinancialRiskAudit FOREIGN KEY (RiskId) REFERENCES FinancialRiskAudit (RiskId),
	StatementId INT, 
	CONSTRAINT FK_FinancialAuditMaster_FinancialStatementAudit FOREIGN KEY (StatementId) REFERENCES FinancialStatementAudit (StatementId),
	InvestmentId INT,
	CONSTRAINT FK_FinancialAuditMaster_PortfolioInvestments FOREIGN KEY (InvestmentId) REFERENCES PortfolioInvestments (InvestmentId),
	BudgetId INT, 
	CONSTRAINT FK_FinancialAuditMaster_BudgetAllocationAudit FOREIGN KEY (BudgetId) REFERENCES BudgetAllocationAudit (BudgetId),
    InvoiceNumber VARCHAR(255),
    PaymentStatus VARCHAR(50),
    EmployeeId INT, 
	CONSTRAINT FK_FinancialAuditMaster_EmployeeInfo FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo (EmployeeId),
    TransactionDescription VARCHAR(MAX),
    TransactionCategory VARCHAR(255),
    TransactionStatus VARCHAR(50),
    TransactionReference VARCHAR(255),
    TaxId INT, 
	CONSTRAINT FK_FinancialAuditMaster_TaxInformation FOREIGN KEY (TaxId) REFERENCES TaxInformation (TaxId),
	ProjectId INT, 
	CONSTRAINT FK_FinancialAuditMaster_ProjectTasks FOREIGN KEY (ProjectId) REFERENCES ProjectTasks (ProjectId),
	ClaimId INT, 
	CONSTRAINT FK_FinancialAuditMaster_ExpenseClaimAudit FOREIGN KEY (ClaimId) REFERENCES ExpenseClaimAudit (ClaimId),
    PaymentMethod VARCHAR(50),
    PaymentDate DATE,
    DueDate DATE,
    DiscountAmount DECIMAL(18, 2),
    AccountNumber VARCHAR(20), 
	CONSTRAINT FK_FinancialAuditMaster_CustomerAccounts FOREIGN KEY (AccountNumber) REFERENCES CustomerAccounts (AccountNumber),
    AccountType VARCHAR(50),
    ItemId INT, 
	CONSTRAINT FK_FinancialAuditMaster_InventoryItems FOREIGN KEY (ItemId) REFERENCES InventoryItems (ItemId),
	TransactionLocation VARCHAR(255),
    TransactionNotes VARCHAR(MAX),
    CreatedDate DATETIME,
    ModifiedBy VARCHAR(255),
    ModifiedDate DATETIME,
    ApprovalComments VARCHAR(MAX),
    AttachmentURL VARCHAR(MAX),
	Notes VARCHAR(MAX),
);

-- Insert mock data (excluding 'Id')
DECLARE @counter INT = 1;
DECLARE @CurrentDate DATE = '2014-01-01';
DECLARE @RepeatCount INT; --used for creating realistic, duplicate transaction dates

WHILE @counter <= 25000
BEGIN
    -- Determine how many times the current date should be repeated
    SET @RepeatCount = FLOOR(RAND() * 19) + 2; -- Random number between 2 and 20

    -- Insert the transactions for the current date
    WHILE @RepeatCount > 0 AND @counter <= 25000
    BEGIN
        INSERT INTO FinancialAuditMaster (
			TransactionDate,
			TransactionType,
			Amount,
			Currency,
			TransactionFlag,
			VendorId,
			RiskId,
			StatementId,
			InvestmentId,
			BudgetId,
			InvoiceNumber,
			PaymentStatus,
			EmployeeId,
			TransactionDescription,
			TransactionCategory,
			TransactionStatus,
			TransactionReference,
			TaxId,
			ProjectId,
			ClaimId,
			PaymentMethod,
			PaymentDate,
			DueDate,
			DiscountAmount,
			AccountNumber,
			AccountType,
			ItemId,
			TransactionLocation,
			TransactionNotes,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			ApprovalComments,
			AttachmentURL,
			Notes
		)
		VALUES (
			@CurrentDate, -- TransactionDate
			CASE WHEN @counter % 3 = 0 THEN 'Sale' ELSE 'Purchase' END, -- TransactionType
			ROUND(RAND() * 990 + 10, 2), -- Amount
			'USD', -- Currency
			CASE --TransactionFlag (0-1: assign higher prob to 0)
				WHEN RAND() <= 0.05 THEN 1
				ELSE 0
			END,
			CASE --VendorId (1-30,000: assign higher prob to lower numbers for variation)
				WHEN RAND() <= 0.75 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 29000) + 1001
			END,
			CASE --RiskId (1-17,000: assign lower prob to lower numbers for variation)
				WHEN RAND() <= 0.45 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 16000) + 1001
			END,
			CASE --StatementId (1-24,000: assign higher prob to lower numbers for variation)
				WHEN RAND() <= 0.80 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 23000) + 1001
			END,
			CASE --InvestmentId (1-30,000: assign lower prob to lower numbers for variation)
				WHEN RAND() <= 0.40 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 29000) + 1001
			END,
			CASE --BudgetId (1-21,000: assign higher prob to lower numbers for variation)
				WHEN RAND() <= 0.60 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 20000) + 1001
			END,
			'INV-' + RIGHT('00000' + CAST(@counter AS VARCHAR(5)), 5), -- InvoiceNumber
			CASE WHEN @counter % 5 = 0 THEN 'Paid' ELSE 'Outstanding' END, -- PaymentStatus
			FLOOR(RAND() * 15000) + 1 , -- EmployeeId
			'Transaction description for row ' + CAST(@counter AS VARCHAR(10)), -- TransactionDescription
			CASE WHEN @counter % 2 = 0 THEN 'Expense' ELSE 'Revenue' END, -- TransactionCategory
			CASE WHEN @counter % 6 = 0 THEN 'Completed' ELSE 'Pending' END, -- TransactionStatus
			'REF-' + RIGHT('00000' + CAST(@counter AS VARCHAR(5)), 5), -- TransactionReference
			CASE --TaxId (1-20,000: assign higher prob to higher numbers for variation)
				WHEN RAND() <= 0.75 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 19000) + 1001
			END,
			CASE --ProjectId (1-12,000: assign lower prob to higher numbers for variation)
				WHEN RAND() <= 0.25 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 11000) + 1001
			END,
			CASE --ClaimId (1-18,000: assign lower prob to higher numbers for variation)
				WHEN RAND() <= 0.40 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 17000) + 1001
			END,
			CASE WHEN @counter % 7 = 0 THEN 'Credit Card' ELSE 'Cash' END, -- PaymentMethod
			DATEADD(DAY, FLOOR(RAND() * 8) + 1, @CurrentDate), -- PaymentDate
			DATEADD(DAY, 7, @CurrentDate), -- DueDate
			ROUND(RAND() * 50, 2), -- DiscountAmount
			'ACC' + RIGHT('00000' + CAST(FLOOR(RAND() * 10000) + 1 AS VARCHAR(5)), 5), -- AccountNumber
			CASE WHEN @counter % 8 = 0 THEN 'Checking' ELSE 'Savings' END, -- AccountType
			CASE --ItemId (1-10,000: assign higher prob to lowest numbers for variation)
				WHEN RAND() <= 0.10 THEN FLOOR(RAND() * 1000) + 1
				ELSE FLOOR(RAND() * 9000) + 1001
			END,
			CASE --TransactionLocation
				WHEN RAND() <= 0.25 THEN 'Los Angeles, California'
				WHEN RAND() <= 0.25 THEN 'Dallas, Texas'
				WHEN RAND() <= 0.25 THEN 'Chicago, Illinois'
				WHEN RAND() <= 0.25 THEN 'Phoenix, Arizona'
				WHEN RAND() <= 0.15 THEN 'London, United Kingdom'
				WHEN RAND() <= 0.15 THEN 'Paris, France'
				WHEN RAND() <= 0.15 THEN 'Madrid, Spain'
				WHEN RAND() <= 0.15 THEN 'Amsterdam, Netherlands'
				WHEN RAND() <= 0.10 THEN 'Berlin, Germany'
				ELSE 'New York City, New York'
			END,
			'Notes for transaction ' + CAST(@counter AS VARCHAR(10)), -- TransactionNotes
			DATEADD(DAY, FLOOR(RAND() * 3), @CurrentDate), -- CreatedDate
			'User' + CAST(@counter + 100 AS VARCHAR(10)), -- ModifiedBy
			DATEADD(DAY, @counter + 1, '2024-08-02'), -- ModifiedDate
			'Approval comments for transaction ' + CAST(@counter AS VARCHAR(10)), -- ApprovalComments
			'https://example.com/attachments/' + CAST(@counter AS VARCHAR(50)), --AttachmentURL
			'Notes for row ' + CAST(@counter AS VARCHAR(10)) -- Notes
		);

		SET @counter = @counter + 1;
		SET @RepeatCount = @RepeatCount - 1;
	END

	    -- Move to the next business day
    SET @CurrentDate = CASE 
        WHEN DATEPART(WEEKDAY, @CurrentDate) = 6 THEN DATEADD(DAY, 3, @CurrentDate) -- If Saturday, add 3 days
        WHEN DATEPART(WEEKDAY, @CurrentDate) = 7 THEN DATEADD(DAY, 2, @CurrentDate) -- If Sunday, add 2 days
        ELSE DATEADD(DAY, 1, @CurrentDate) -- Otherwise, add 1 day
    END;
END;