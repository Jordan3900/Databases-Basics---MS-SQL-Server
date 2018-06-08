--01. One-To-One Relationship
CREATE TABLE Passports(
PassportID INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
PassportNumber CHAR(8)
)

CREATE TABLE Persons (
PersonID INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(64) NOT NULL,
Salary DECIMAL(10, 2),
PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports
VALUES ('N34FG21B'), ('K65LO4R7'), ('ZE657QP2')

INSERT INTO Persons
VALUES 
('Roberto', 43300.00, 102), ('Tom', 56100.00, 103), ('Yana', 60200.00, 101)

--02. One-To-Many Relationship
CREATE TABLE Manufacturers (
ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(64) NOT NULL,
EstablishedOn DATE NOT NULL
)

CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY(101, 1),
[Name] NVARCHAR(64) NOT NULL,
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers
VALUES ('BMW', '07/03/1916'), ('Tesla', '01/01/2003'), ('Lada', '01/05/1966')

INSERT INTO Models
VALUES ('X1',1), ('i6',1), ('Model S',2), ('Model X',2), ('Model 3',2), ('Nova',3)

--03. Many-To-Many RelXationship
CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(64) NOT NULL
)

CREATE TABLE Exams(
ExamID INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
[Name] NVARCHAR(64) NOT NULL
)

CREATE TABLE StudentsExams(
StudentID INT  NOT NULL,
ExamID INT  NOT NULL,
CONSTRAINT PK_Student_Exam PRIMARY KEY(StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_ExamID FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students
VALUES ('Mila'), ('Toni'), ('Ron')

INSERT INTO Exams
VALUES ('springMVC'), ('Neo4j'), ('Oracle 11g')
SELECT * FROM StudentsExams
INSERT INTO StudentsExams
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103)

--04. Self-Referencing
CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(64) NOT NULL,
ManagerID INT

CONSTRAINT FK_Manger_Teacher FOREIGN KEY(ManagerID) REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES (101, 'John', NULL), (102, 'Maya', 106), (103, 'Silvia', 106), (104, 'Ted', 105), (105, 'Mark', 101), (106, 'Greta', 101)

--05. Online Store Database
CREATE DATABASE OnlineStoreDB
CREATE TABLE Cities(
CityID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE ItemTypes(
Item“ypeID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Birthday DATE,
CityID INT  FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Items(
ItemID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(Item“ypeID)
)

CREATE TABLE Orders(
OrderID INT PRIMARY KEY IDENTITY NOT NULL,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems(
OrderID INT NOT NULL,
ItemID INT NOT NULL

CONSTRAINT PK_Orders_Items PRIMARY KEY(OrderID, ItemID),
CONSTRAINT FK_OrdersItems_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
CONSTRAINT FK_OrdersItems_ItemID FOREIGN KEY(ItemID) REFERENCES Items(ItemID)
)

--06. University Database
CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY IDENTITY,
SubjectName VARCHAR(64)
)

CREATE TABLE Majors(
MajorID INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(64) NOT NULL,
)

CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber VARCHAR(64),
StudentName VARCHAR(64),
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Agenda(
StudentID INT NOT NULL,
SubjectID INT NOT NULL

CONSTRAINT PK_StudentID_SubjectID PRIMARY KEY(StudentID, SubjectID),
CONSTRAINT FK_Agenda_StudentID FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_Agenda_SubjectID FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
)

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY IDENTITY,
PaymentDate DATE NOT NULL,
PaymentAmount DECIMAL(10,2),
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

--09.  Peaks in Rila
SELECT m.MountainRange, p.PeakName, p.Elevation FROM Mountains AS m
JOIN Peaks AS p ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC