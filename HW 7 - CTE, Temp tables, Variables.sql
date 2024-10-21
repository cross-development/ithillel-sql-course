USE CarRental;
GO

-- 1. Створити локальну змінну number, створити цикл, який перевіряє числа від 1 до 20.
-- Якщо число кратне 3, виводьте "Fizz", якщо кратне 5 — "Buzz", в іншому випадку просто виводимо число
-- Пояснення: Кратне число це коли число %(ділеться) на 3 без остатку, 11 % 3 = 1 (не кратне 3), 21 % 3= 0 (кратне 3)
-- Використовуемо WHILE IF PRINT
DECLARE @number int = 1;

WHILE @number <= 20
BEGIN
    IF @number % 3 = 0
        PRINT 'Fizz';
    ELSE IF @number % 5 = 0
        PRINT 'Buzz';
    ELSE
        PRINT @number;

    SET @number = @number + 1;
END;
GO

-- 2. Створіть запит, який використовує локальну змінну для обчислення середньої ціни з таблиці Cars і виводить всі автомобілі, ціна яких вища за середнє.
-- таблиця Cars у нас в ДЗ до 6 уроку.
DECLARE @averagePrice decimal(10, 2);

SELECT @averagePrice = AVG(Price) 
FROM Cars;

SELECT * 
FROM Cars 
WHERE Price > @averagePrice;
GO

-- 3. Створіть табличну змінну для зберігання інформації про нові автомобілі та виконайте вибірку.
-- Додавати записи можно вільно або взяти з таблиці Cars
DECLARE @NewCars TABLE (
    CarID int,
    Brand nvarchar(50),
    Model nvarchar(50),
    Year int,
    Price decimal(10, 2)
);

INSERT INTO @NewCars (CarID, Brand, Model, Year, Price)
VALUES 
(6, 'Kia', 'Sportage', 2022, 27000.00),
(7, 'Hyundai', 'Tucson', 2021, 25000.00);

SELECT * 
FROM @NewCars;
GO

-- 4. Створіть тимчасову таблицю, додайте до неї автомобілі, а потім виконайте вибірку за ціною понад $20,000.
CREATE TABLE #TempCars (
    CarID int,
    Brand nvarchar(50),
    Model nvarchar(50),
    Year int,
    Price decimal(10, 2)
);

INSERT INTO #TempCars
SELECT CarID, Brand, Model, Year, Price FROM Cars;

SELECT * 
FROM #TempCars 
WHERE Price > 20000;

DROP TABLE #TempCars;
GO

-- 5. Використовуйте IF для перевірки кількості автомобілів у таблиці Cars.
-- Якщо > 10 'Достатньо автомобілів', в іншому випадку 'Потрібно більше автомобілів'
DECLARE @carCount int;

SELECT @carCount = COUNT(*) FROM Cars;

IF @carCount > 10
    PRINT N'Достатньо автомобілів';
ELSE
    PRINT N'Потрібно більше автомобілів';
GO

-- Додатково:
-- 1. Обчисліть факторіал числа з допомогою рекурсивного CTE.
DECLARE @number int = 5;

WITH FactorialCTE (n, fact) AS (
    -- Базовий випадок: факторіал від 1 = 1
    SELECT 1 AS n, 1 AS fact
    UNION ALL
    -- Рекурсивний випадок: n * (n-1)!
    SELECT n + 1, fact * (n + 1)
    FROM FactorialCTE
    WHERE n < @number
)
SELECT fact AS Factorial
FROM FactorialCTE
WHERE n = @number;
GO

-- 2. Створіть цикл для додавання записів у тимчасову таблицю. Назву машин додавати Car1, Car2....дивлячись скільки циклів обираете
CREATE TABLE #CarNames (
    CarID int,
    CarName nvarchar(50)
);

DECLARE @currentIteration int = 1;
DECLARE @maxIteration int = 5;

WHILE @currentIteration <= @maxIteration
BEGIN
    INSERT INTO #CarNames (CarID, CarName)
    VALUES (@currentIteration, CONCAT('Car', @currentIteration));
    SET @currentIteration = @currentIteration + 1;
END;

SELECT * 
FROM #CarNames;

DROP TABLE #CarNames;
GO
