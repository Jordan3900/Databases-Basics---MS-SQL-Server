--01. Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName FROM Employees
WHERE Salary > 35000

--02.Employees with Salary Above Number
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@Salary DECIMAL(18, 4))
AS
SELECT FirstName, LastName FROM Employees
WHERE Salary>=@Salary

EXEC usp_GetEmployeesSalaryAboveNumber 48100

--03. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith (@Param VARCHAR(MAX))
AS
SELECT Name AS [Town] FROM Towns
WHERE Name LIKE CONCAT(@Param, '%')

EXEC usp_GetTownsStartingWith 'b'

--04. Employees from Town
CREATE PROC usp_GetEmployeesFromTown (@TownName VARCHAR(MAX))
AS
SELECT e.FirstName, e.LastName FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
WHERE t.Name = @TownName

EXEC usp_GetEmployeesFromTown 'Sofia'

--05. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
BEGIN
	DECLARE @salaryLevel VARCHAR(10)
	IF(@Salary < 30000)
		SET @salaryLevel = 'Low'
	ELSE IF(@Salary BETWEEN 30000 AND 50000)
		SET @salaryLevel = 'Average'
	ELSE
		SET @salaryLevel = 'High'
RETURN @salaryLevel
END

SELECT Salary, dbo.unf_GetSalaryLevel(Salary) AS 'Salary Level'
FROM Employees
ORDER BY Salary
DESC

--06. Employees by Salary Level
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS
SELECT FirstName, LastName FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

EXEC dbo.usp_EmployeesBySalaryLevel 'High'

--07. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	DECLARE @isComprised BIT = 0;
	DECLARE @currentIndex INT = 1;
	DECLARE @currentChar CHAR;

	WHILE(@currentIndex <= LEN(@word))
	 BEGIN
		SET @currentChar  = SUBSTRING(@word, @currentIndex, 1);
		IF(CHARINDEX(@currentChar, @setLetters) = 0)
		RETURN @isComprised;
		SET @currentIndex += 1
	END

	RETURN @isComprised + 1
END

---08. Delete Employees and Departments
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) AS
BEGIN

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

ALTER TABLE Departments
ALTER COLUMN ManagerID INT

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

DELETE FROM Employees
WHERE DepartmentID = @departmentId

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT * 
  FROM Employees
 WHERE DepartmentID = @departmentId

SELECT COUNT(*)
  FROM Employees
 WHERE DepartmentID = @departmentId
END

--09. Find full name
CREATE PROCEDURE usp_GetHoldersFullName AS
BEGIN
	SELECT CONCAT(FirstName, ' ',LastName) AS [Full Name] FROM AccountHolders
END

EXECUTE usp_GetHoldersFullName

--10. People with Balance Higher Than
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(14, 2) ) AS
BEGIN
	SELECT ah.FirstName, ah.LastName FROM Accounts AS a
	JOIN AccountHolders AS ah ON ah.Id = a.AccountHolderId
	GROUP BY FirstName, LastName
	HAVING SUM(a.Balance) > @number
END

EXECUTE usp_GetHoldersWithBalanceHigherThan 7000

--11. Future Value Function
GO
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(15,4), @yearlyInterestRate FLOAT, @numOfYear INT)
RETURNS DECIMAL(15,4)
BEGIN
	DECLARE @futureValue DECIMAL(15,4)

	SET @futureValue = @sum * POWER((1 + @yearlyInterestRate), @numOfYear)

	RETURN @futureValue
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--12. Calculating Interest
GO
CREATE PROCEDURE usp_CalculateFutureValueForAccount @accountID INT, @interestRate FLOAT AS
BEGIN
	SELECT a.Id, ah.FirstName, ah.LastName, a.Balance, dbo.ufn_CalculateFutureValue(Balance, @interestRate, 5) AS [Balance in 5 year] FROM Accounts AS a
	JOIN AccountHolders AS ah ON ah.Id = a.Id
	WHERE a.Id = @accountID
END

EXECUTE usp_CalculateFutureValueForAccount 1, 0.1

--13. Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50))
RETURNS TABLE
AS
RETURN(
SELECT SUM(e.Cash) AS [SumCash]
  FROM (
	SELECT g.Id, ug.Cash, ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS [RowNumber]
      FROM Games AS g
      JOIN UsersGames AS ug ON ug.GameId = g.Id 
     WHERE g.Name = @gameName) AS e
     WHERE e.RowNumber % 2 = 1
  )

  SELECT * FROM dbo.ufn_CashInUsersGames('Lily Stargazer')

-- 14. Create Table Logs
CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
OldSum DECIMAL(15, 4),
NewSum DECIMAL(15, 4)
)

GO
CREATE TRIGGER tr_logsUpdates ON Accounts
FOR UPDATE AS 
BEGIN
	DECLARE	
	        @AccountID INT, 
		    @OldSum DECIMAL(15,4), 
			@NewSum DECIMAL(15,4)

	SET @AccountID = (SELECT Id FROM deleted)
	SET @OldSum = (SELECT Balance FROM deleted WHERE Id = @AccountID)
	SET @NewSum = (SELECT Balance FROM inserted WHERE Id = @AccountID)

	INSERT INTO Logs(AccountId, OldSum, NewSum)
	VALUES
	(@AccountID, @OldSum, @NewSum)

END

--15. Create Table Emails
CREATE TABLE Emails(
Id INT PRIMARY KEY IDENTITY,
Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
[Subject] VARCHAR(255),
Body VARCHAR(255)
)

GO
DROP TRIGGER tr_EmailsUpdate
CREATE TRIGGER tr_EmailsUpdate ON Logs
FOR INSERT AS
BEGIN
	DECLARE
			@AccountId INT,
			@Date DATETIME,
			@Old DECIMAL(15,2),
			@New DECIMAL(15,2)
    
	SET @AccountId = (SELECT LogId FROM Logs)
	SET @Date = GETDATE()
	SET @Old = (SELECT OldSum FROM Logs)
	SET @New = (SELECT NewSum FROM Logs)

	INSERT INTO NotificationEmails (Recipient, Subject, Body)
	VALUES
	(@AccountId, CONCAT('Balance change for account: ', @AccountId), CONCAT('On ', @Date,' your balance was changed from ',@Old,' to ', @New,'.'))
END

SELECT * FROM Emails

UPDATE Accounts
SET Balance -= 10
WHERE Id = 2

--16. Deposit Money
GO
CREATE PROCEDURE usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(15, 4)) AS
BEGIN
	BEGIN TRANSACTION
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE Id = @AccountId

	IF (@MoneyAmount < 0)
		BEGIN
			ROLLBACK;
			
		END

	COMMIT

END

--17. Withdraw Money Procedure
GO
CREATE PROCEDURE usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(15, 4)) AS
BEGIN
	BEGIN TRANSACTION
	UPDATE Accounts
	SET Balance -= @MoneyAmount
	WHERE Id = @AccountId

	IF (@MoneyAmount < 0)
		BEGIN
			ROLLBACK;
			
		END

	COMMIT

END

EXECUTE usp_WithdrawMoney 5, 25

--18. Money Transfer
GO
CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4)) AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @SenderId

		IF(@Amount > (SELECT Balance FROM Accounts WHERE Id = @SenderId) OR @Amount < 0)
		BEGIN
			ROLLBACK
		END

		UPDATE Accounts
		SET Balance += @Amount
		WHERE Id = @ReceiverId

		COMMIT

	END