-- Створення бази даних StudentGradesDB
CREATE DATABASE StudentGradesDB; --CREATE DATABASE – Створює нову базу даних
GO

-- Використання створеної бази даних
USE StudentGradesDB; -- USE – Вказує, що для наступних команд слід використовувати базу даних
GO

-- Створення таблиці StudentGrades
CREATE TABLE StudentGrades ( -- CREATE TABLE – Створює таблицю
    StudentId INT IDENTITY(1,1) PRIMARY KEY,	-- Унікальний ідентифікатор студента
    FullName NVARCHAR(100) NOT NULL,			-- ПІБ студента
    City NVARCHAR(50),							-- Місто студента
    Country NVARCHAR(50),						-- Країна студента
    Birthdate DATE,								-- Дата народження студента
    Email NVARCHAR(100),						-- Електронна адреса студента
    Phone NVARCHAR(20),							-- Контактний телефон студента
    GroupName NVARCHAR(50),						-- Назва групи студента
    AvgGrade DECIMAL(3, 2),						-- Середня оцінка за рік
    SubjectMinGrade NVARCHAR(50),				-- Предмет з мінімальною середньою оцінкою
    SubjectMaxGrade NVARCHAR(50)				-- Предмет з максимальною середньою оцінкою
);
GO

-- Додавання кількох записів до таблиці StudentGrades
INSERT INTO StudentGrades -- INSERT INTO – Вставляє дані в таблицю
(FullName, City, Country, Birthdate, Email, Phone, GroupName, AvgGrade, SubjectMinGrade, SubjectMaxGrade)
VALUES -- VALUES - Вказує, що далі будуть іти значення, які потрібно вставити в таблицю
('John Doe', 'New York', 'USA', '2000-05-12', 'john.doe@example.com', '555-1234', 'Group A', 3.5, 'Mathematics', 'Physics'),
('Jane Smith', 'Los Angeles', 'USA', '2001-10-24', 'jane.smith@example.com', '555-5678', 'Group B', 4.2, 'History', 'Chemistry'),
('Robert Brown', 'Chicago', 'USA', '2000-03-15', 'robert.brown@example.com', '555-9101', 'Group A', 2.8, 'English', 'Biology');
GO

-- Перевірка даних за допомогою вибірки з таблиці StudentGrades
SELECT * FROM StudentGrades; -- SELECT – Виконує запит вибірки всіх даних з таблиці.
GO