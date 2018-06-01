--1. Find Names of All Employees by First Name
SELECT FirstName, LastName 
  FROM Employees
 WHERE LEFT(FirstName, 2) = 'SA'

--2. Find Names of All employees by Last Name
SELECT FirstName, lastName
  FROM Employees
 WHERE LastName LIKE '%ei%'

--3. Find First Names of All Employess
SELECT FirstName 
  FROM Employees
 WHERE DepartmentID IN(3, 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

--4. Find All Employees Except Engineers
SELECT FirstName, LastName 
  FROM Employees
 WHERE JobTitle  NOT LIKE '%engineer%'

--5. Find Towns with Name Length
SELECT Name 
  FROM Towns
 WHERE LEN(NAME) IN(5,6)
 ORDER BY Name

--6. Find Towns Starting With
SELECT *
  FROM Towns
 WHERE LEFT(Name, 1) IN('M', 'K', 'B', 'E')
 ORDER BY Name

--7. Find Towns Not Starting With
SELECT * 
  FROM Towns
 WHERE LEFT(Name, 1) NOT IN('R', 'B', 'D')
ORDER BY Name

--8. Create View Employees Hired After
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
  FROM Employees
 WHERE YEAR(HireDate) > 2000

--9. Length of Last Name
SELECT FirstName, LastName
  FROM Employees
 WHERE LEN(LastName) = 5

--10. Countries Holding 'A'
SELECT CountryName, IsoCode AS [ISO code] 
  FROM Countries
 WHERE CountryName LIKE '%A%A%A%'
 ORDER BY [ISO code]

--11. Mix of Peak and River Names
SELECT PeakName, 
RiverName, 
LOWER(PeakName + RIGHT(RiverName, LEN(RiverName) -1 )) AS 'Mix' FROM Rivers, Peaks
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix

--12. Games From 2011 and 2012 Year
SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS [Start] 
  FROM Games
 WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY Start

--13. User Email Providers
SELECT Username, RIGHT(Email,LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider]
  FROM Users
ORDER BY [Email Provider], Username

--14. Get Users with IPAddress Like Pattern
SELECT Username, IpAddress 
  FROM Users
 WHERE  IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--15. Show All Games with Duration
SELECT G.Name AS [Game],
  CASE
      WHEN DATEPART(HOUR, G.Start) BETWEEN 0 AND 11 THEN 'Morning'
	  WHEN DATEPART(HOUR, G.Start) BETWEEN 12 AND 17 THEN 'Afternoon'
	  WHEN DATEPART(HOUR, G.START) BETWEEN 18 AND 23 THEN 'Evening'
	  END AS [Part of the Day],
  CASE
      WHEN G.Duration <= 3 THEN 'Extra Short'
	  WHEN G.Duration BETWEEN 4 AND 6 THEN 'Short'
	  WHEN G.Duration > 6 THEN 'Long'
	  ELSE 'Extra Long'
	  END AS [Duration]	   
 FROM Games AS G
ORDER BY G.Name, [Duration], [Part of the Day]

--16. Orders Table
SELECT ProductName, OrderDate,
DATEADD(DAY, 3, OrderDate) AS [Pay Due],
DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders