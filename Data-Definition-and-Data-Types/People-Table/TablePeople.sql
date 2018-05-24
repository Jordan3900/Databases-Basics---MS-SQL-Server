CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
Picture VARBINARY CHECK(DATALENGTH(Picture) < 900 * 1024),
Height DECIMAL(10, 2),
[Weight] DECIMAL(10, 2),
Gender VARCHAR(1) NOT NULL CHECK(Gender = 'm' OR Gender = 'f'),
Birthdate INT NOT NULL,
Biography NVARCHAR(255)
)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
('Christiano', NULL, 187, 80, 'm', 25, 'Footballer'),
('Greg Popovic', NULL, 175, 90, 'm', 12, 'Manager'),
('Florentino', NULL, 170, 85, 'm', 23, 'CEO'),
('Zhenya', NULL, 176, 60, 'f', 22, 'Model'),
('Govanni', NULL, 190, 110, 'm', 30, 'Mobile operator')