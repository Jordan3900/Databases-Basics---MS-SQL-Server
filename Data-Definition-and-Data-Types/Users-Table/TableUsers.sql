CREATE TABLE Users(
Id BIGINT PRIMARY KEY IDENTITY,
Username NVARCHAR(30) NOT NULL,
Password NVARCHAR(26) NOT NULL,
ProfilePicture VARBINARY CHECK(DATALENGTH(ProfilePicture) < 900 * 1024),
LastLoginTime DATE,
IsDeleted BIT
)

INSERT INTO Users(Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES 
('Somebody', '123456', NULL, NULL, 0),
('Ivan', '123456', NULL, NULL, 0),
('Peter', '123456', NULL, NULL, 0),
('Heather', '123456', NULL, NULL, 0),
('Verdascu', '123456', NULL, NULL, 0)

ALTER TABLE Users
DROP PK__Users__3214EC0737C1AD4E

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY(Id, Username)

ALTER TABLE Users
ADD CONSTRAINT CHK_Password
CHECK (LEN(Password) >= 5)

UPDATE Users
SET LastLoginTime = GETDATE()

SELECT * FROM Users