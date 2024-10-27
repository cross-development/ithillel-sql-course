-- Створення нової бази даних
CREATE DATABASE CarRentalNew;
GO

-- Використання новоствореної бази даних
USE CarRentalNew;
GO

-- Таблиця для автомобілів
CREATE TABLE Cars (
    CarID INT PRIMARY KEY IDENTITY(1,1),
    CarName NVARCHAR(100),
    ManufactureYear INT,
    OwnerID INT
);
GO

-- Таблиця для штрафів
CREATE TABLE Fines (
    FineID INT PRIMARY KEY IDENTITY(1,1),
    CarID INT,
    FineAmount DECIMAL(10,2),
    FineDate DATE,
    Status NVARCHAR(20)
);
GO

-- Таблиця для інспекцій
CREATE TABLE Inspections (
    InspectionID INT PRIMARY KEY IDENTITY(1,1),
    CarID INT,
    InspectionDate DATE,
    InspectionResult NVARCHAR(100)
);
GO

-- Таблиця для власників
CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY IDENTITY(1,1),
    OwnerName NVARCHAR(100),
    ContactInfo NVARCHAR(100)
);
GO

ALTER TABLE Cars
ADD CONSTRAINT FK_Cars_Owners
FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);
GO

ALTER TABLE Fines
ADD CONSTRAINT FK_Fines_Cars
FOREIGN KEY (CarID) REFERENCES Cars(CarID);
GO

ALTER TABLE Inspections
ADD CONSTRAINT FK_Inspections_Cars
FOREIGN KEY (CarID) REFERENCES Cars(CarID);
GO

INSERT INTO Cars (CarName, ManufactureYear, OwnerID)
VALUES
('Toyota Camry', 2015, 1),
('Honda Accord', 2018, 2),
('Ford Focus', 2017, 3),
('BMW X5', 2019, 4),
('Tesla Model 3', 2021, 5),
('Audi A4', 2016, 6),
('Volkswagen Golf', 2020, 7),
('Chevrolet Malibu', 2015, 8),
('Nissan Altima', 2014, 9),
('Hyundai Sonata', 2022, 10),
('Mercedes-Benz C-Class', 2020, 1),
('Kia Sorento', 2019, 2),
('Mazda CX-5', 2017, 3),
('Subaru Outback', 2021, 4),
('Jeep Grand Cherokee', 2016, 5),
('Ford Mustang', 2021, 6),
('Honda Civic', 2018, 7),
('Chevrolet Impala', 2019, 8),
('Toyota Prius', 2020, 9),
('Dodge Charger', 2021, 10);
GO

INSERT INTO Fines (CarID, FineAmount, FineDate, Status)
VALUES
(1, 100.50, '2024-01-05', 'Paid'),
(2, 150.00, '2024-02-10', 'Unpaid'),
(3, 200.75, '2024-03-15', 'Paid'),
(4, 50.25, '2024-04-20', 'Unpaid'),
(5, 300.00, '2024-05-25', 'Paid'),
(6, 75.99, '2024-06-01', 'Unpaid'),
(7, 120.45, '2024-07-10', 'Paid'),
(8, 180.30, '2024-08-15', 'Unpaid'),
(9, 90.10, '2024-09-20', 'Paid'),
(10, 250.99, '2024-10-05', 'Unpaid');
GO

INSERT INTO Inspections (CarID, InspectionDate, InspectionResult)
VALUES
(1, '2024-01-10', 'Passed'),
(2, '2024-02-15', 'Passed'),
(3, '2024-03-20', 'Failed'),
(4, '2024-04-25', 'Passed'),
(5, '2024-05-30', 'Passed'),
(6, '2024-06-05', 'Failed'),
(7, '2024-07-10', 'Passed'),
(8, '2024-08-15', 'Passed'),
(9, '2024-09-20', 'Failed'),
(10, '2024-10-01', 'Passed');
GO

INSERT INTO Owners (OwnerName, ContactInfo)
VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Michael Johnson', 'michael@example.com'),
('Emily Davis', 'emily@example.com'),
('Robert Wilson', 'robert@example.com'),
('Sarah Miller', 'sarah@example.com'),
('David Brown', 'david@example.com'),
('Olivia Harris', 'olivia@example.com'),
('Daniel Moore', 'daniel@example.com'),
('Sophia Clark', 'sophia@example.com');
GO

--1. Створити View, який показує інформацію про автомобілі та їхніх власників.
CREATE VIEW vw_OwnersWithCars AS
SELECT 
	c.CarID, 
	c.CarName, 
	c.ManufactureYear, 
	o.OwnerName, 
	o.ContactInfo
FROM Cars c
JOIN Owners o ON c.OwnerID = o.OwnerID;
GO

SELECT * FROM vw_OwnersWithCars;
GO

--2. Створити View, який показує автомобілі з останньою датою інспекції.
CREATE VIEW vw_CarsWithInspections AS
SELECT
	c.CarID,
	c.CarName,
	c.ManufactureYear,
	MAX(i.InspectionDate) AS LastInspectionDate
FROM Cars AS c
JOIN Inspections AS i ON c.CarID = i.CarID
GROUP BY c.CarID, c.CarName, c.ManufactureYear;
GO

SELECT * FROM vw_CarsWithInspections;
GO

--3. Створити View для показу автомобілів із сумою штрафів.
CREATE VIEW vw_CarsWithTotalFines AS
SELECT 
	c.CarID, 
	c.CarName, 
	c.ManufactureYear,
	SUM(f.FineAmount) AS TotalFines
FROM Cars c
JOIN Fines f ON c.CarID = f.CarID
GROUP BY c.CarID, c.CarName, c.ManufactureYear;
GO

SELECT * FROM vw_CarsWithTotalFines;
GO

--4. Створити Stored Procedure, яка повертає всі автомобілі, зареєстровані після певного року.
CREATE PROCEDURE GetCarsRegisteredAfterYear
(
	@Year INT
)
AS
BEGIN
	SELECT *
	FROM Cars
	WHERE ManufactureYear > @Year;
END;
GO

EXEC GetCarsRegisteredAfterYear 2020;
GO

--5. Створити Stored Procedure, яка оновлює контактну інформацію про власника автомобіля (процедура приймає @OwnerID і @NewContact).
CREATE PROCEDURE UpdateOwnerContactInfo
(
	@OwnerID INT,
	@NewContact NVARCHAR(100)
)
AS
BEGIN
	UPDATE Owners
	SET ContactInfo = @NewContact
	WHERE OwnerID = @OwnerID;
END;
GO

EXEC UpdateOwnerContactInfo 1, 'john_doe@example.com';
GO

--6. Створити Function (скалярну, повертає DECIMAL(10,2)), яка обчислює загальну кількість штрафів для автомобіля.
CREATE FUNCTION dbo.GetTotalFinesForCar 
(
	@CarID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @NumberOfFines DECIMAL(10,2);
	SET @NumberOfFines = (
		SELECT SUM(FineAmount) 
		FROM Fines
		WHERE CarID = @CarID
	);
	RETURN ISNULL(@NumberOfFines, 0);
END;
GO

SELECT dbo.GetTotalFinesForCar(1) AS NumberOfFines;
GO

--7. Створити Function, яка повертає кількість інспекцій для певного автомобіля.
CREATE FUNCTION dbo.GetInspectionCount 
(
	@CarID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @InspectionCount INT;
	SET @InspectionCount = (
		SELECT COUNT(*)
		FROM Inspections
		WHERE CarID = @CarID
	);
	RETURN @InspectionCount;
END;
GO

SELECT dbo.GetInspectionCount(1) AS InspectionCount;
GO

--8. Створити Stored Procedure, яка видаляє інформацію про автомобіль.
CREATE PROCEDURE DeleteCarById
(
	@CarID INT
)
AS
BEGIN
	DELETE 
	FROM Cars
	WHERE CarID = @CarID;
END;
GO

EXEC DeleteCarById 21;
GO

--9. Створити View для показу автомобілів, що мають більше двох штрафів.
CREATE VIEW vw_CarsWithMoreThanTwoFines AS
SELECT
	c.CarID,
	c.CarName
FROM Cars AS c
JOIN Fines AS f ON c.CarID = f.CarID
GROUP BY c.CarID, c.CarName
HAVING COUNT(f.FineID) > 2;
GO

SELECT * FROM vw_CarsWithMoreThanTwoFines;
GO

--10.Створити Function (скалярна), яка повертає кількість автомобілів, що належать одному власнику.
CREATE FUNCTION dbo.GetCarsCountForOwner
(
	@OwnerID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @CarsCount INT;
	SET @CarsCount = (
		SELECT COUNT(*)
		FROM Cars
		WHERE OwnerID = @OwnerID
	);
	RETURN @CarsCount;
END;
GO

SELECT dbo.GetCarsCountForOwner(1) AS NumberOfCars;
GO

--11.Створити Stored Procedure, яка додає новий автомобіль до бази даних.
CREATE PROCEDURE AddNewCar
(
    @CarName NVARCHAR(100),
    @ManufactureYear INT,
    @OwnerID INT
)
AS
BEGIN
	INSERT INTO Cars (CarName, ManufactureYear, OwnerID)
	VALUES (@CarName, @ManufactureYear, @OwnerID);
END;
GO

EXEC AddNewCar 'Honda Accord', 2020, 1;
GO

--12.Створити View для показу всіх автомобілів, які не проходили інспекцію.
CREATE VIEW vw_CarsWithoutInspections AS
SELECT
	c.CarID,
	c.CarName,
	c.ManufactureYear
FROM Cars AS c
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
WHERE i.CarID IS NULL;
GO

SELECT * FROM vw_CarsWithoutInspections;
GO

--13.Створити Function, яка повертає максимальну суму штрафу для автомобіля.
CREATE FUNCTION dbo.GetMaxFineForCar
(
	@CarID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @MaxFine DECIMAL(10,2);
	SET @MaxFine = (
		SELECT MAX(FineAmount)
		FROM Fines
		WHERE CarID = @CarID
	);
	RETURN ISNULL(@MaxFine, 0);
END;
GO

SELECT dbo.GetMaxFineForCar(1) AS MaxFine;
GO

--14.Створити Stored Procedure, яка повертає всі автомобілі, що мають штрафи на певну суму або більше.
CREATE PROCEDURE GetCarsWithFines
(
	@FineAmount DECIMAL(10,2)
)
AS
BEGIN
	SELECT c.CarID, c.CarName, SUM(f.FineAmount) AS TotalFines
	FROM Cars AS c
	JOIN Fines AS f ON c.CarID = f.CarID
	GROUP BY c.CarID, c.CarName
	HAVING SUM(f.FineAmount) >= @FineAmount;
END;
GO

EXEC GetCarsWithFines 100;
GO

--15.Створити View для показу власників, що мають більше одного автомобіля.
CREATE VIEW vw_OwnersWithMoreThanOneCar AS
SELECT
	o.OwnerID,
	o.OwnerName,
	COUNT(c.CarID) AS NumberOfCars
FROM Owners AS o
JOIN Cars AS c ON o.OwnerID = c.OwnerID
GROUP BY o.OwnerID, o.OwnerName
HAVING COUNT(c.CarID) > 1;
GO

SELECT * FROM vw_OwnersWithMoreThanOneCar;
GO

--16.Створити Function, яка повертає загальну кількість автомобілів у базі даних.
CREATE FUNCTION dbo.GetTotalNumberOfCars ()
RETURNS INT
AS
BEGIN
	DECLARE @TotalNumberOfCars INT;
	SET @TotalNumberOfCars = (
		SELECT COUNT(*)
		FROM Cars
	);
	RETURN @TotalNumberOfCars;
END;
GO

SELECT dbo.GetTotalNumberOfCars() AS TotalNumberOfCars;
GO

--17.Створити Stored Procedure, яка змінює статус штрафу (Paid/Unpaid) для певного автомобіля.
CREATE PROCEDURE UpdateFineStatus
(
	@FineID INT,
	@NewStatus NVARCHAR(20)
)
AS
BEGIN
	UPDATE Fines
	SET Status = @NewStatus
	WHERE FineID = @FineID;
END;
GO

EXEC UpdateFineStatus 2, 'Paid';
GO

--18.Створити View, який показує автомобілі та кількість інспекцій для кожного автомобіля.
CREATE VIEW vw_CarsWithInspectionCount AS
SELECT 
	c.CarID,
	c.CarName,
	COUNT(i.InspectionID) AS InspectionCount
FROM Cars AS c
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
GROUP BY c.CarID, c.CarName;
GO

SELECT * FROM vw_CarsWithInspectionCount;
GO

--19.Створити Stored Procedure (без вхідних параметрів), яка повертає інформацію про всі автомобілі, які мають штрафи, і загальну суму штрафів для кожного автомобіля.
CREATE PROCEDURE GetCarsWithTotalFines
AS
BEGIN
	SELECT
		c.CarID,
		c.CarName,
		c.ManufactureYear,
		SUM(f.FineAmount) AS TotalFines
	FROM Cars AS c
	JOIN Fines AS f ON c.CarID = f.CarID
	GROUP BY c.CarID, c.CarName, c.ManufactureYear;
END;
GO

EXEC GetCarsWithTotalFines;
GO

--20.Створити Function, яка повертає середню суму штрафів для певного автомобіля.
CREATE FUNCTION dbo.CalculateAvgFineAount
(
	@CarID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @AvgFine DECIMAL(10,2);
	SET @AvgFine = (
		SELECT AVG(FineAmount)
		FROM Fines
		WHERE CarID = @CarID
	);
	RETURN ISNULL(@AvgFine, 0);
END;
GO

SELECT dbo.CalculateAvgFineAount(1) AS AvgFineAmount;
GO
