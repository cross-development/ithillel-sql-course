CREATE DATABASE CarRental;
GO

USE CarRental;
GO

CREATE TABLE Cars (
    CarID INT PRIMARY KEY,
    Brand NVARCHAR(50),
    Model NVARCHAR(50),
    Year INT,
    Price DECIMAL(10, 2),
    Mileage INT,		-- пробіг автомобіля
    EngineType NVARCHAR(20),	-- тип двигуна
    Color NVARCHAR(20)
);

INSERT INTO Cars (CarID, Brand, Model, Year, Price, Mileage, EngineType, Color)
VALUES
(1, 'Toyota', 'Corolla', 2015, 15000, 80000, 'Petrol', 'Red'),
(2, 'Honda', 'Civic', 2018, 18000, 60000, 'Diesel', 'Blue'),
(3, 'Ford', 'Fiesta', 2016, 12000, 70000, 'Petrol', 'Green'),
(4, 'BMW', 'X5', 2019, 50000, 30000, 'Diesel', 'Black'),
(5, 'Mercedes', 'C-Class', 2020, 40000, 25000, 'Petrol', 'White'),
(6, 'Audi', 'A4', 2017, 35000, 45000, 'Diesel', 'Grey'),
(7, 'Toyota', 'Camry', 2016, 22000, 50000, 'Hybrid', 'Black'),
(8, 'Honda', 'Accord', 2021, 27000, 10000, 'Petrol', 'Red'),
(9, 'Ford', 'Focus', 2018, 16000, 55000, 'Diesel', 'White'),
(10, 'BMW', '3 Series', 2019, 45000, 20000, 'Petrol', 'Blue'),
(11, 'Mercedes', 'E-Class', 2015, 35000, 95000, 'Diesel', 'Silver'),
(12, 'Audi', 'Q7', 2020, 60000, 15000, 'Diesel', 'Black'),
(13, 'Toyota', 'RAV4', 2019, 30000, 25000, 'Hybrid', 'Grey'),
(14, 'Honda', 'CR-V', 2017, 24000, 40000, 'Diesel', 'Red'),
(15, 'Ford', 'Escape', 2021, 26000, 15000, 'Petrol', 'White'),
(16, 'BMW', 'X3', 2018, 48000, 35000, 'Diesel', 'Black'),
(17, 'Mercedes', 'GLA', 2020, 38000, 30000, 'Petrol', 'Blue'),
(18, 'Audi', 'A3', 2015, 20000, 80000, 'Diesel', 'Green'),
(19, 'Toyota', 'Yaris', 2017, 14000, 60000, 'Petrol', 'Yellow'),
(20, 'Honda', 'Jazz', 2016, 13000, 70000, 'Diesel', 'Orange'),
(21, 'Ford', 'Mustang', 2019, 55000, 20000, 'Petrol', 'Black'),
(22, 'BMW', 'M5', 2020, 75000, 15000, 'Petrol', 'Red'),
(23, 'Mercedes', 'S-Class', 2018, 90000, 35000, 'Diesel', 'White'),
(24, 'Audi', 'A6', 2019, 50000, 40000, 'Diesel', 'Grey'),
(25, 'Toyota', 'Highlander', 2021, 45000, 10000, 'Hybrid', 'Blue');

-- 1. Загальна кількість автомобілів кожного бренду:
SELECT [Brand], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [Brand];

-- 2. Середня ціна автомобілів кожного року випуску:
SELECT [Year], FORMAT(AVG([Price]), 'C', 'en-US') AS [AvgPrice]
FROM [Cars]
GROUP BY [Year];

-- 3. Кількість автомобілів з різними типами двигунів:
SELECT [EngineType], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [EngineType];

-- 4. Кількість автомобілів кожного кольору, де їх більше ніж 2:
SELECT [Color], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [Color]
HAVING COUNT(*) > 2;

-- 5. Середня пробіг автомобілів кожного бренду:
SELECT [Brand], AVG([Mileage]) AS [AvgMileage]
FROM [Cars]
GROUP BY [Brand];

-- 6. Сумарна ціна автомобілів для кожного типу двигуна:
SELECT [EngineType], FORMAT(SUM([Price]), 'C', 'en-US') AS [TotalPrice]
FROM [Cars]
GROUP BY [EngineType]

-- 7. Максимальна і мінімальна ціна автомобілів для кожного року випуску:
SELECT [Year], FORMAT(MAX([Price]), 'C', 'en-US') AS [MaxPrice], FORMAT(MIN([Price]), 'C', 'en-US') AS [MinPrice]
FROM [Cars]
GROUP BY [Year];

-- 8. Кількість автомобілів кожного бренду, де середній пробіг більше 25,000:
SELECT [Brand], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [Brand]
HAVING AVG([Mileage]) > 25000

-- 9. Вивести назву бренду та ціну автомобілів, де ціна більша за 30,000 або автомобіль має пробіг менше 20,000:
SELECT [Brand], FORMAT([Price], 'C', 'en-US') AS [Price]
FROM [Cars]
WHERE [Price] > 30000 OR [Mileage] < 20000;

-- 10. Вивести автомобілі з пробігом більше 60,000 і ціною менше 20,000 --> 'Good Deal' ішне -->'Expensive' з використанням CASE або IIF:
SELECT [Brand], [Model], [Mileage], FORMAT([Price], 'C', 'en-US') AS [Price], 
    IIF([Mileage] > 60000 AND [Price] < 20000, 'Good Deal', 'Expensive') AS [DealStatus]
FROM [Cars];

-- 11. Вивести кількість автомобілів кожного кольору для автомобілів дорожче за 25,000:
SELECT [Color], COUNT(*) AS [CarsCount]
FROM [Cars]
WHERE [Price] > 25000
GROUP BY [Color];

-- 12. Вивести середню ціну та середній пробіг для кожного типу двигуна:
SELECT [EngineType], FORMAT(AVG([Price]), 'C', 'en-US') AS [AvgPrice], AVG([Mileage]) AS [AvgMileage]
FROM [Cars]
GROUP BY [EngineType];

-- 13. Вивести автомобілі з типом двигуна "Hybrid"-->'Eco Friendly'  або "Petrol"--> 'Standard' з використанням CASE:
SELECT [Brand], [Model], [EngineType], 
    CASE 
        WHEN [EngineType] = 'Hybrid' THEN 'Eco Friendly'
        ELSE 'Standard'
    END AS [EngineCategory]
FROM [Cars]
WHERE [EngineType] IN ('Hybrid', 'Petrol');

-- 14. Сумарна кількість автомобілів кожного року, де кількість автомобілів більше ніж 2:
SELECT [Year], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [Year]
HAVING COUNT(*) > 2;

-- 15. Вивести кількість автомобілів кожного бренду, де середня ціна більше 30,000 з використанням HAVING:
SELECT [Brand], COUNT(*) AS [CarsCount]
FROM [Cars]
GROUP BY [Brand]
HAVING AVG([Price]) > 30000;

-- 16. Вивести автомобілі та визначити категорію ціни: "Дешевий", "Середній", або "Дорогий" на основі ціни автомобіля:
SELECT [Brand], [Model], FORMAT([Price], 'C', 'en-US') AS [Price], 
    CASE 
        WHEN [Price] < 20000 THEN N'Дешевий'
        WHEN [Price] BETWEEN 20000 AND 50000 THEN N'Середній'
        ELSE N'Дорогий'
    END AS [PriceCategory]
FROM [Cars];

-- 17. Вивести автомобілі та вказати, чи є двигун екологічним (Hybrid), або неекологічним (Petrol, Diesel):
SELECT [Brand], [Model], [EngineType], 
    CASE 
        WHEN [EngineType] = 'Hybrid' THEN N'Екологічний'
        ELSE N'Неекологічний'
    END AS [EcoStatus]
FROM [Cars];