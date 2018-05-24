CREATE DATABASE SoftUni

CREATE TABLE Towns(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(69) NOT NULL
)

CREATE TABLE Adresses(
Id INT PRIMARY KEY IDENTITY,
AdressText NVARCHAR(255), 
TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(69) NOT NULL
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(69) NOT NULL,
MiddleName NVARCHAR(69),
LastName NVARCHAR(69),
JobTitle NVARCHAR(69),
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
HireDate DATE,
Salary DECIMAL(15,2),
AdressId INT FOREIGN KEY REFERENCES Adresses(Id)
)

INSERT INTO Towns([Name])
VALUES
('Yambol'),
('Sofia'),
('Varna'),
('Burgas'),
('Plovdiv')

INSERT INTO Departments ([Name])
VALUES
('Engineering'), ('Sales'), ('Marketing'), ('Software Development'), ('Quality Assurance')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov','.NET Developer', 4,	CONVERT(datetime,'01/02/2013',103), 3500.00),
('Maria', 'Petrova', 'Ivanova','Intern', 2,	CONVERT(datetime,'28/08/2016',103), 525.25),
('Petar', 'Petrov', 'Petrov','Senior Engineer', 1,	CONVERT(datetime,'02/03/2004',103), 4000.00),
('Georgi', 'Teziev', 'Ivanov','CEO', 2,	CONVERT(datetime,'09/12/2007',103), 3000.00),
('Peter', 'Pan', 'Pan','Intern',3,	CONVERT(datetime,'28/08/2016', 103), 599.88)

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

SELECT * FROM Towns
ORDER BY Name

SELECT * FROM Departments
ORDER BY Name

SELECT * FROM Employees
ORDER BY Salary DESC

SELECT [Name] FROM Towns
ORDER BY Name

SELECT [Name] FROM Departments
ORDER BY Name

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC

UPDATE Employees
SET Salary = Salary * 1.1
SELECT Salary FROM Employees

