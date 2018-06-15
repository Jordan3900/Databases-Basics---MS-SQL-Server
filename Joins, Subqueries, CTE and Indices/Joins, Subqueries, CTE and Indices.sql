--01. Employee Address
SELECT TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText 
  FROM Employees AS e
 INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY a.AddressID

--02. Addresses with Towns
SELECT TOP(50) e.FirstName, e.LastName, T.Name, a.AddressText FROM Addresses AS a
JOIN Towns AS T ON a.TownID = T.TownID
JOIN Employees AS e ON e.AddressID = a.AddressID
ORDER BY e.FirstName, E.LastName

--03. Sales Employees
SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY EmployeeID

--04. Employee Departments
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE Salary > 15000
ORDER BY d.DepartmentID

--05. Employees Without Projects
SELECT top(3) e.EmployeeID, e.FirstName FROM Employees AS e
LEFT JOIN EmployeesProjects AS eproj 
ON e.EmployeeID = eproj.EmployeeID
WHERE eproj.ProjectID IS NULL
ORDER BY e.EmployeeID

--06. Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.Name FROM Employees AS e
JOIN Departments AS d ON (e.DepartmentID = d.DepartmentID
 AND e.HireDate > '1/1/1999' 
 AND d.Name IN ('Sales', 'Finance'))
 ORDER BY e.HireDate

--07. Employees With Project
SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name FROM Employees AS e
JOIN EmployeesProjects AS pro ON e.EmployeeID = pro.EmployeeID
JOIN Projects AS p ON pro.ProjectID = p.ProjectID
WHERE p.StartDate > '08/13/2002' AND EndDate IS NULL
ORDER BY e.EmployeeID

--08. Employee 24
SELECT e.EmployeeID, e.FirstName, IIF(p.StartDate > '2005-01-01', NULL, p.Name) FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--09. Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, emp.FirstName AS [ManagerName]  FROM Employees AS e
JOIN Employees AS emp ON e.ManagerID = emp.EmployeeID
WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID

--10. Employees Summary
SELECT TOP(50) e.EmployeeID, e.FirstName + ' ' + e.LastName AS [EmployeeName], m.FirstName +' '+ m.LastName AS [ManagerName], d.Name AS [DepartmentName] FROM Employees AS e
LEFT JOIN Employees AS m ON m.EmployeeID = e.ManagerID
LEFT JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--11. Min Average Salary
SELECT MIN(MinSalary.AverageSalary) FROM
(
SELECT AVG(Salary) AS [AverageSalary]
  FROM Employees
GROUP BY DepartmentID
) AS [MinSalary]

--12. Highest Peaks in Bulgaria
SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation FROM Peaks AS p
JOIN MountainsCountries AS mc ON p.MountainId = mc.MountainId
JOIN Mountains AS m ON m.Id = mc.MountainId
WHERE mc.CountryCode = 'BG' AND Elevation > 2835
ORDER BY Elevation DESC

--13. Count Mountain Ranges
SELECT mc.CountryCode, COUNT(M.MountainRange) AS [MountainRanges] FROM MountainsCountries AS mc
JOIN Mountains AS m ON mc.MountainId = m.Id
GROUP BY mc.CountryCode 
HAVING mc.CountryCode IN('BG', 'RU', 'US')

--14. Countries With or Without Rivers
SELECT TOP(5) c.CountryName, r.RiverName FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--15. Continents and Currencies
WITH CTE_CountriesInfo (ContinentCode, CurrencyCode, CurrencyUsage) AS(
SELECT ContinentCode, CurrencyCode, Count(CurrencyCode) AS [CurrencyUsage]
  FROM Countries
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(CurrencyCode) > 1
)

SELECT e.ContinentCode, cci.CurrencyCode, e.MaxCurrency FROM (
SELECT ContinentCode, MAX(CurrencyUsage) AS MaxCurrency FROM CTE_CountriesInfo
GROUP BY ContinentCode ) AS e
JOIN CTE_CountriesInfo AS cci ON cci.ContinentCode = e.ContinentCode AND
cci.CurrencyUsage = e.MaxCurrency

--16. Countries Without any Mountain
SELECT COUNT(*) AS CountryCode FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
WHERE mc.CountryCode IS NULL

--17. Highest Peak and Longest River by Country
SELECT TOP 5 c.CountryName,
  MAX(p.Elevation) AS HighestPeakElevation,
  MAX(r.Length) AS LongestRiverLength
FROM Countries AS c
  LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Peaks AS p ON p.MountainId = mc.MountainId
  LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

--18. Highest Peak Name and Elevation by Country
WITH PeaksMountains_CTE (Country, PeakName, Elevation, Mountain) AS (

  SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange
  FROM Countries AS c
  LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
  LEFT JOIN Peaks AS p ON p.MountainId = m.Id
)

SELECT TOP 5
  TopElevations.Country AS Country,
  ISNULL(pm.PeakName, '(no highest peak)') AS HighestPeakName,
  ISNULL(TopElevations.HighestElevation, 0) AS HighestPeakElevation,	
  ISNULL(pm.Mountain, '(no mountain)') AS Mountain
FROM 
  (SELECT Country, MAX(Elevation) AS HighestElevation
   FROM PeaksMountains_CTE 
   GROUP BY Country) AS TopElevations
LEFT JOIN PeaksMountains_CTE AS pm 
ON (TopElevations.Country = pm.Country AND TopElevations.HighestElevation = pm.Elevation)
ORDER BY Country, HighestPeakName 