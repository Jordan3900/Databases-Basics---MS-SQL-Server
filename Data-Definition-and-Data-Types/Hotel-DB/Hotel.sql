CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(255) NOT NULL,
LastName NVARCHAR(255),
Title NVARCHAR(255),
Notes NTEXT,
)

CREATE TABLE Customers(
AccountNumber INT UNIQUE,
FirstName NVARCHAR(255) NOT NULL,
LastName NVARCHAR(255),
PhoneNumber NVARCHAR(255),
EmergencyName NVARCHAR(255),
Notes NTEXT
)

CREATE TABLE RoomStatus(
RoomStatus NVARCHAR(255),
Notes NTEXT
)

CREATE TABLE RoomTypes(
RoomType NVARCHAR(255),
Notes NTEXT
)

CREATE TABLE BedTypes(
BedTypes VARCHAR(255),
Notes TEXT
)

CREATE TABLE Payments(
Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
PaymentDate DATE,
AccountNumber INT UNIQUE,
FirstDateOccupied DATE,
LastDateOccupied DATE, 
TotalDays DATE,
AmountCharged INT,
TaxRate DECIMAL(10,2),
TaxAmount DECIMAL(10,2),
PaymentTotal DECIMAL(10,2),
Notes TEXT
)

CREATE TABLE Occupancies(
Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
AccountNumber INT UNIQUE NOT NULL,
RoomNumber INT NOT NULL,
RateApplied INT,
PhoneCharge DECIMAL(10,2),
Notes NTEXT
)

INSERT INTO Employees(FirstName, LastName, Title, Notes)
VALUES
('Govanni', 'Santos', 'Senior developer', 'Team lead'),
('Stefan', 'Savic', 'Junior developer', Null),
('Juan', 'Riquelme', 'Rocket Launcher', Null)

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, Notes)
VALUES
(12456, 'Leonardo', 'Bonucci', '+539464891', 'Roberto Baggio', NULL),
(1256, 'Ricardo', 'Quaresma', '+53944891', 'Filipo Inzhagi', NULL),
(156, 'Leonardo', 'Di Caprio', '+53464891',  'Verdasco', NULL)

INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES('Free', NULL)
INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES('Reserved', NULL)
INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES('Currently not available', NULL)

INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Luxury', NULL)
INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Standard', NULL)
INSERT INTO RoomTypes(RoomType,Notes)
VALUES('Small', NULL)
SELECT * FROM Occupancies
INSERT INTO Payments(EmployeeId, PaymentDate, FirstDateOccupied, LastDateOccupied, AccountNumber, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal,  Notes)
VALUES 
(1, NULL, NULL, NULL, 124324, NULL, 25 , 2.6, 25, 63, 'SomeText'),
(2, NULL, NULL, NULL, 14324, NULL, 25 , 2.6, 25, 63, 'SomeText'),
(3, NULL, NULL, NULL, 12424, NULL, 25 , 2.6, 25, 63, 'SomeText')

INSERT INTO Occupancies(EmployeeId, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, 1234, 4, 5, 64, NULL),
(2, 134, 4, 5, 64, NULL),
(3, 14, 4, 5, 64, NULL)