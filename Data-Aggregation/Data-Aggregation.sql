--1. Records Count
SELECT COUNT(*) AS [Count] FROM WizzardDeposits

--2. Longest Magic Wand
SELECT MAX(MagicWandSize) AS [LogestMagicWand] FROM WizzardDeposits

--3. Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand 
  FROM WizzardDeposits
GROUP BY DepositGroup

--4. Smallest Deposit Group per Magic Wand Size
SELECT  DepositGroup 
FROM WizzardDeposits
GROUP BY DepositGroup
HAVING AVG(MagicWandSize) = (
							 SELECT Min(WizzardWandSizes.AverageMagicWandSize) FROM (
		             SELECT DepositGroup, AVG(MagicWandSize) AS AverageMagicWandSize FROM WizzardDeposits
			     GROUP BY DepositGroup
			   ) AS [WizzardWandSizes]
							)

--5. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount)
  FROM WizzardDeposits
GROUP BY DepositGroup
SELECT * FROM WizzardDeposits
--6. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--7. Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
 WHERE  MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC

--8. Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
  FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator

--9. Age Groups
SELECT AgeGroups.AgeGroup, COUNT(*) AS [WizzardCount] FROM
(
 SELECT 
 CASE
 WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
 WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
 WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
 WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
 WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
 WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
 WHEN Age > 60 THEN '[61+]'
 END AS AgeGroup
 FROM WizzardDeposits
) AS AgeGroups
GROUP BY AgeGroups.AgeGroup

--10. First Letter
SELECT DISTINCT LEFT(FirstName, 1) AS [FirstLetter] 
  FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
ORDER BY FirstLetter

--11. Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS [AverageInterest]
  FROM WizzardDeposits
 WHERE year(DepositStartDate) >= '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12. Rich Wizard, Poor Wizard
SELECT SUM(wizzardDeposits.Difference) AS SumDifference FROM
(
SELECT FirstName, DepositAmount, 
LEAD(FirstName) OVER (ORDER BY Id) AS GuestWizzard,
LEAD(DepositAmount) OVER (ORDER BY Id) AS GuestDeposit,
DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [Difference]
FROM WizzardDeposits
) AS wizzardDeposits

--13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS [TotalSumOfSalaries]
  FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS [MinimumSalary] 
  FROM Employees
 WHERE YEAR(HireDate) >= 2000
GROUP BY DepartmentID
HAVING DepartmentID IN(2, 5, 7)

--15. Employees Average Salaries
SELECT * INTO EmployeesAVG
  FROM Employees
 WHERE Salary > 30000

DELETE FROM EmployeesAVG
WHERE ManagerID = 42

UPDATE EmployeesAVG
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary] 
  FROM EmployeesAVG
GROUP BY DepartmentID

--16. Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
  FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries
SELECT COUNT(Salary)  AS [Count]
  FROM Employees
 WHERE ManagerID IS NULL

--18. 3rd Highest Salary
SELECT Salaries.DepartmentID, Salaries.Salary FROM 
(
SELECT DepartmentId,
MAX(Salary) AS [Salary],
DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS RANK
FROM Employees
GROUP BY DepartmentID, Salary
)AS Salaries
WHERE RANK = 3

--19. Salary Challenge
SELECT TOP 10 FirstName, LastName, DepartmentID FROM Employees AS emp1
WHERE Salary >
(SELECT AVG(Salary) FROM Employees AS emp2
WHERE emp1.DepartmentID = emp2.DepartmentID
GROUP BY DepartmentID)
ORDER BY DepartmentID