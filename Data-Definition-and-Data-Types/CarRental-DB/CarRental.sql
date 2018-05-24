CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
CategoryName NVARCHAR(255),
DailyRate INT,
WeeklyRate INT,
MonthlyRate INT,
WeekendRate INT
)

CREATE TABLE Cars(
Id INT PRIMARY KEY IDENTITY,
PlateNumber NVARCHAR UNIQUE,
Manifacturer INT UNIQUE,
Model INT,
CarYear INT,
CategoryId NVARCHAR UNIQUE,
Doors INT,
Picture NVARCHAR,
Condition NVARCHAR NOT NULL,
Available INT NOT NULL
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(255) NOT NULL,
	Notes NVARCHAR(255)
)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	DriverLicenceNumber int NOT NULL UNIQUE,
	FullName NVARCHAR(255) NOT NULL,
	Address NVARCHAR(255),
	City NVARCHAR(255) NOT NULL,
	ZIPCode NVARCHAR(255),
	Notes NVARCHAR(255)
)

CREATE TABLE RentalOrders
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT NOT NULL UNIQUE,
	CustomerId INT NOT NULL UNIQUE,
	CarId INT NOT NULL,
	TankLevel INT,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT,
	StartDate DATE,
	EndDate DATE,
	TotalDays INT,
	RateApplied NVARCHAR(50),
	TaxRate NVARCHAR(50),
	OrderStatus NVARCHAR(255),
	Notes NVARCHAR(255)
)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('Somecategory', NULL, 3, 100, 2)
INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('SomeanotherCategory', 1, NULL, 900, NULL)
INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES('TheLastCategory', 4, 5, 800, 35)

INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('ÑÀ 2258 ÀÑ', 'BMW', 2017, NULL,4,NULL,'New', 10)
INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('RA 2299 CA', 'AUDI', 2017, NULL,2,NULL,'New', 21)
INSERT INTO Cars(Platenumber,Model,CarYear,CategoryId,Doors,Picture,Condition,Available)
VALUES('EG 8888 GA', 'MERCEDES', 2017, NULL,4,NULL,'New', 9)

INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Gosho','Peshov','Software Developer',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Pesho','Goshov','Pilot',NULL)
INSERT INTO Employees(FirstName,LastName,Title,Notes)
VALUES('Mariika','Petrova','Doctor',NULL)

INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(5821596,'Gosho it-to',NULL,'Sofia', NULL, NULL)
INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(123513,'Pesho Peshov Peshov',NULL,'England', 'TN9T4U', NULL)
INSERT INTO Customers(DriverLicenceNumber, FullName, Address,City,ZIPCode,Notes)
VALUES(09834758,'Pesho Goshov Peshov',NULL,'Switzerland', NULL, NULL)

INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(5315351, 1351, 5, NULL, 5000, 2351, 1231245, NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(53453, 643, 3, NULL, 567876, 12323, 3453453, NULL,NULL,NULL,NULL,NULL,NULL,NULL)
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId,TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,StartDate,EndDate,TotalDays,RateApplied,TaxRate,OrderStatus,Notes)
VALUES(7859647, 123, 2, NULL, 12312, 543536, 367787, NULL,NULL,NULL,NULL,NULL,'DELIVERED',NULL)