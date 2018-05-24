--1
CREATE DATABASE Minions
USE Minions

--2
CREATE TABLE Minions(
Id INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL,
Age INT
)

CREATE TABLE Towns(
Id INT PRIMARY KEY,
[Name] NVARCHAR(50)
)

--3
ALTER TABLE Minions
ADD TownsId INT

ALTER TABLE Minions
ADD CONSTRAINT FK_MinionsTown
FOREIGN KEY (TownsId)
REFERENCES Towns(Id)

--4
INSERT INTO Towns
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions(Id, Name, Age, TownsId)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', Null, 2)

--5
TRUNCATE TABLE Minions

--6
DROP TABLE Minions
DROP TABLE Towns