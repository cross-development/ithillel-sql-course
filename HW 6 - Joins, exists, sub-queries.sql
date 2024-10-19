CREATE DATABASE CarRental
GO

USE CarRental
GO

-- Створення таблиці Cars
CREATE TABLE Cars (
    CarID INT PRIMARY KEY,
    Brand NVARCHAR(50),
    Model NVARCHAR(50),
    Year INT,
    EngineSize INT,
    Price DECIMAL(10, 2),
    OwnerID INT
	-- FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID) - Або через ALTER TABLE (додав команду внизу перед завданнями)
);
GO

-- Створення таблиці Owners
CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY,
    OwnerName NVARCHAR(100)
);
GO

-- Створення таблиці Inspections
CREATE TABLE Inspections (
    InspectionID INT PRIMARY KEY,
    CarID INT,
    InspectionDate DATE,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);
GO

-- Створення таблиці Fines (штрафи)
CREATE TABLE Fines (
    FineID INT PRIMARY KEY,
    CarID INT,
    FineAmount DECIMAL(10, 2),
    FineDate DATE,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);
GO

INSERT INTO Owners (OwnerID, OwnerName)
VALUES 
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Mark Johnson'),
(4, 'Emily Davis'),
(5, 'Michael Brown');
GO

INSERT INTO Cars (CarID, Brand, Model, Year, EngineSize, Price, OwnerID)
VALUES 
(1, 'Toyota', 'Corolla', 2020, 1800, 20000.00, 1),
(2, 'Honda', 'Civic', 2018, 1600, 18000.00, 2),
(3, 'Ford', 'Focus', 2019, 2000, 22000.00, 3),
(4, 'Nissan', 'Altima', 2021, 2500, 25000.00, 1),
(5, 'BMW', 'X5', 2017, 3000, 35000.00, 4);
GO

INSERT INTO Inspections (InspectionID, CarID, InspectionDate)
VALUES 
(1, 1, '2023-01-15'),
(2, 2, '2023-05-22'),
(3, 4, '2022-12-01'),
(4, 5, '2023-03-10');
GO

INSERT INTO Fines (FineID, CarID, FineAmount, FineDate)
VALUES 
(1, 2, 150.00, '2023-04-01'),
(2, 3, 200.00, '2023-07-18'),
(3, 1, 100.00, '2023-02-05'),
(4, 5, 300.00, '2023-06-22');
GO

-- Так як авто не має залежності на власника, нам потрібно додати внести зміни в таблицю Cars та додати foreign key з посиланням на власника (OwnerID).
ALTER TABLE Cars 
ADD CONSTRAINT FK_Cars_To_Owners FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);
GO

-- 1. Знайдіть всі моделі автомобілів та їх власників, які мають об'єм двигуна більше 2000 куб. см.
SELECT c.Model, o.OwnerName
FROM Cars AS c
JOIN Owners AS o ON c.OwnerID = o.OwnerID
WHERE c.EngineSize > 2000;
GO

-- 2. Знайдіть всіх власників, які мають автомобілі старше 2018 року.  
SELECT DISTINCT o.OwnerName
FROM Cars AS c
JOIN Owners AS o ON c.OwnerID = o.OwnerID
WHERE c.Year < 2018;
GO

-- 3. Знайдіть автомобілі, які не проходили технічний огляд (LEFT JOIN).  
SELECT c.CarID, c.Brand, c.Model
FROM Cars AS c
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
WHERE i.InspectionID IS NULL;
GO

-- 4. Знайдіть всіх власників автомобілів разом з інформацією про останні технічні огляди їхніх автомобілів (LEFT JOIN).  
SELECT o.OwnerName, c.Brand, c.Model, MAX(i.InspectionDate) AS LastInpection
FROM Owners AS o
JOIN Cars AS c ON o.OwnerID = c.OwnerID
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
GROUP BY o.OwnerName, c.Brand, c.Model;
GO

-- 5. Знайдіть моделі автомобілів, які мають штрафи більше 100 грн.  
SELECT c.Model, f.FineAmount
FROM Cars AS c
JOIN Fines AS f ON c.CarID = f.CarID
WHERE f.FineAmount > 100;
GO

-- 6. Знайдіть автомобілі, власники яких мають щонайменше один автомобіль, випущений після 2020 року (EXISTS).  
SELECT *
FROM Cars
WHERE EXISTS (
	SELECT 1 
	FROM Owners 
	WHERE Cars.OwnerID = Owners.OwnerID AND Year > 2020
);
GO

-- 7. Знайдіть всі марки автомобілів, що мають штрафи, і об'єднайте їх з автомобілями, які мають техогляди (UNION ALL). 
SELECT DISTINCT c.Brand
FROM Cars AS c
JOIN Fines AS f ON c.CarID = f.CarID
UNION ALL
SELECT DISTINCT c.Brand
FROM Cars AS c
JOIN Inspections AS i ON c.CarID = i.CarID;
GO

-- 8. Знайдіть всі автомобілі, які були оглянуті у 2023 році, разом з інформацією про їхні штрафи (FULL JOIN).  
SELECT c.*, i.InspectionDate, f.FineAmount, f.FineDate
FROM Cars AS c
FULL JOIN Inspections AS i ON c.CarID = i.CarID
FULL JOIN Fines AS f ON c.CarID = f.CarID
WHERE YEAR(i.InspectionDate) = 2023;
GO

-- 9. Знайдіть всіх власників автомобілів, які мають щонайменше один штраф (INNER JOIN).  
SELECT DISTINCT o.OwnerName
FROM Owners AS o
JOIN Cars AS c ON o.OwnerID = c.OwnerID
JOIN Fines AS f ON c.CarID = f.CarID;
GO

-- 10. Знайдіть всі автомобілі, які мають як техогляди, так і штрафи (підзапит з умовою).  
SELECT *
FROM Cars AS c
WHERE EXISTS (
	SELECT 1 
	FROM Inspections AS i 
	WHERE i.CarID = c.CarID
)
  AND EXISTS (
	SELECT 1 
	FROM Fines AS f 
	WHERE f.CarID = c.CarID
);
GO

-- 11. Знайдіть автомобілі, які мають найвищу ціну серед автомобілів тієї ж марки (підзапит).  
SELECT C.Brand, C.Model, C.Price
FROM Cars AS c
WHERE c.Price = (
    SELECT MAX(Price)
    FROM Cars AS c2
    WHERE c2.Brand = c.Brand
);
GO

-- 12. Знайдіть всіх власників автомобілів, які не мають технічного огляду за останній рік (підзапит).  
SELECT o.OwnerName
FROM Owners AS o
JOIN Cars AS c ON o.OwnerID = c.OwnerID
WHERE NOT EXISTS (
    SELECT 1 
    FROM Inspections AS i 
    WHERE i.CarID = c.CarID AND i.InspectionDate >= DATEADD(YEAR, -1, GETDATE())
);
GO

-- 13. Знайдіть всіх власників, які мають автомобілі без штрафів (INNER JOIN і LEFT JOIN).  
SELECT o.OwnerName
FROM Owners AS o
JOIN Cars AS c ON o.OwnerID = c.OwnerID
LEFT JOIN Fines AS f ON c.CarID = f.CarID
WHERE f.FineID IS NULL;
GO

-- 14. Знайдіть автомобілі, які мають штрафи, але не проходили технічний огляд (INNER JOIN і LEFT JOIN).  
SELECT c.*
FROM Cars AS c
JOIN Fines AS f ON c.CarID = f.CarID
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
WHERE i.InspectionID IS NULL;
GO

-- 15. Знайдіть автомобілі, які мають щонайменше один техогляд і хоча б один штраф.  
SELECT c.*
FROM Cars AS c
JOIN Inspections AS i ON c.CarID = i.CarID
JOIN Fines AS f ON c.CarID = f.CarID;
GO

-- або (згідно actual execution plan цей запит спрацює швидше (27% відносної вартості на exists проти 73% відносної вартості на joins))
SELECT *
FROM Cars AS c
WHERE EXISTS (
	SELECT 1 
	FROM Inspections AS i 
	WHERE i.CarID = c.CarID
)
  AND EXISTS (
	SELECT 1 
	FROM Fines AS f 
	WHERE f.CarID = c.CarID
);
GO

-- 16. Знайдіть всі автомобілі, які мають технічний огляд у 2023 році (EXISTS).  
SELECT *
FROM Cars AS c
WHERE EXISTS (
	SELECT 1 
	FROM Inspections AS i
	WHERE i.CarID = c.CarID AND YEAR(i.InspectionDate) = 2023
);
GO

-- 17. Знайдіть моделі автомобілів, які мають штрафи (EXISTS).  
SELECT c.Model
FROM Cars AS c
WHERE EXISTS (
	SELECT 1 
	FROM Fines AS f
	WHERE f.CarID = c.CarID
);
GO

-- 18. Знайдіть автомобілі, які не проходили технічний огляд (NOT EXISTS).  
SELECT *
FROM Cars AS c
WHERE NOT EXISTS (
	SELECT 1 
	FROM Inspections AS i
	WHERE i.CarID = c.CarID
);
GO

-- 19. Знайдіть всі автомобілі разом з інформацією про останній технічний огляд (якщо він є).  
SELECT c.Brand, c.Model, MAX(i.InspectionDate) AS LastInspection
FROM Cars AS c
LEFT JOIN Inspections AS i ON c.CarID = i.CarID
-- або JOIN Inspections AS i ON c.CarID = i.CarID - якщо нам не потрібна інформація про авто, які не мають тех.огляду (трохи двозначно розумію умову)
GROUP BY c.Brand, c.Model;
GO

-- 20. Знайдіть всі автомобілі та їхні штрафи, якщо вони є.
SELECT c.*, f.FineAmount, f.FineDate
FROM Cars AS c
LEFT JOIN Fines AS f ON c.CarID = f.CarID;
-- або JOIN Fines AS f ON c.CarID = f.CarID - якщо нам не потрібна інформація про авто, які не мають штрафів (трохи двозначно розумію умову)
GO