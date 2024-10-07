CREATE DATABASE Database_Books
GO

USE Database_Books
GO

CREATE TABLE Books(
	Id		int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name]		nvarchar(250) NULL,
	Pages		int NULL,
	YearPress	int NULL,
	Themes		nvarchar(50) NULL,
	Author		nvarchar(50) NULL,
	Press		nvarchar(50) NULL,
	Comment		nvarchar(50) NULL,
	Quantity	int NULL
) 
GO

INSERT Books ([Name], Pages, YearPress, Themes, Author, Press, Comment, Quantity) 
VALUES 
(N'SQL', 816, 2001, N'Бази даних', N'Грофф', N'BHV', N'2-е видання', 2)
,(N'3D Studio Max 3', 640, 2000, N'Графічні пакети', N'Маров', N'Пітер', N'Навчальний курс', 3)
,(N'100 компонентів загального призначення бібліотеки Delphi 5', 272, 1999, N'Програмування', N'Архангельський', N'Біном', N'Компоненти', 1)
,(N'Курс математичного аналізу', 328, 1990, N'Вища математика', N'Нікольський', N'Наука', N'1-й том', 1)
,(N'Бібліотека C++ Builder 5: 70 компонентів вводу/виводу інформації', 288, 2001, N'Програмування', N'Архангельський', N'Біном', NULL, 1)
,(N'Інтегроване середовище розробки', 272, 2000, N'Програмування', N'Архангельський', N'Біном', N'Середовище розробки', 2)
,(N'Visual Basic 6.0 for Application', 488, 2000, N'Програмування', N'Король', N'DiaSoft', N'Довідник з прикладами', 3)
,(N'Visual Basic 6', 576, 2000, N'Програмування', N'Петрусос', N'BHV', N'Посібник розробника 1-й том', 1)
,(N'Mathcad 2000', 416, 2000, N'Математичні пакети', N'Херхагер', N'BHV', NULL, 1)
,(N'Novell GroupWise 5.5 система електронної пошти та колективної роботи', 480, 2000, N'Мережі', N'Гарбар', N'BHV', N'Мережеві пакети', 2)
,(N'Реєстр Windows 2000', 352, 2000, N'Операційні системи', N'Кокорева', N'BHV', N'Посібник для професіоналів', 4)
,(N'Самовчитель Visual FoxPro 6.0', 512, 1999, N'Бази даних', N'Омельченко', N'BHV', N'Самовчитель', 1)
,(N'Самовчитель FrontPage 2000', 512, 1999, N'Web-дизайн', N'Омельченко', N'BHV', N'Самовчитель', 1)
,(N'Самовчитель Perl', 432, 1999, N'Програмування', N'Матросов', N'BHV', NULL, 2)
,( N'HTML 3.2', 1040, 2000, N'Web-дизайн', N'Браун', N'BHV', N'Посібник', 5)
GO

-- 1. Відобразити список авторів книг без повторень. Відсортувати за зростанням.
SELECT DISTINCT Author
FROM Books
ORDER BY Author ASC;

-- 2. Відобразити книги з програмування видавництв «Наука» і «BHV».
SELECT * 
FROM Books
WHERE Themes = N'Програмування' AND Press IN (N'Наука', N'BHV');

-- 3. Відобразити всі книги, у яких кількість сторінок лежить у межах від 200 до 600.
SELECT *
FROM Books
WHERE Pages BETWEEN 200 AND 600;

-- 4. Відобразити всі книги, імена авторів яких закінчуються на «ський». Відсортувати за зростанням (за авторами).
SELECT * 
FROM Books
WHERE Author LIKE N'%ський'
ORDER BY Author ASC;

-- 5. Вибрати книжки, що належать до програмування або до баз даних, і видавництва яких не 'Наука' і не 'Біном'.
SELECT * 
FROM Books
WHERE Themes IN (N'Програмування', N'Бази даних') AND Press NOT IN (N'Наука', N'Біном');

-- 6. Відобразити всіх авторів та їхні книжки. Авторів впорядкувати за зростанням, а назви книг (за авторами) за спаданням (вторинне сортування).
SELECT Author, [Name]
FROM Books
ORDER BY Author ASC, [Name] DESC;

-- 7. Вибрати з таблиці книги, назви яких закінчуються на чотири цифри (2000).
SELECT *
FROM books
WHERE [Name] LIKE '%[0-9][0-9][0-9][0-9]';
-- або ось цей варіант, якщо ми хочемо вибрати всі кножки, які закінчуються саме на 2000 - WHERE [Name] LIKE N'%2000';

-- 8. Вибрати з таблиці книжки, які є в наявності в єдиному екземплярі. Відсортувати за зростанням по назві книжок.
SELECT *
FROM Books
WHERE Quantity = 1
ORDER BY [Name] ASC;

-- 9. Вибрати з таблиці книги з програмування, що не належать до видавництва «BHV», у назвах яких є слово «Visual».
SELECT * 
FROM Books
WHERE Themes = N'Програмування' AND Press <> N'BHV' AND [Name] LIKE N'%Visual%';

-- 10. Відобразити книги з програмування та Web-дизайну, що належать до видавництв «BHV» і «Біном».
SELECT *
FROM Books
WHERE Themes IN (N'Програмування', N'Web-дизайн') AND Press IN (N'BHV', N'Біном');

-- 11. Вибрати книжки, які є довідниками або посібниками.
SELECT * 
FROM Books
WHERE Comment LIKE N'%довідник%' OR Comment LIKE N'%посібник%';

-- 12. Вивести три стовпця Author, Press, Name + в дужках рік випуску і задати псевдоним, вибрати записи в яких поле Comment не містить значення NULL. 
-- Поле рік випуску додаємо, ось так: +  cast(YearPress as varchar )+ це функція преведення типів int приводимо до типу varhar (це ще будете проходити на наступних уроках).
SELECT Author, Press, [Name] + N' (' + cast(YearPress AS varchar) + N')' AS NameWithPress
FROM Books
WHERE Comment IS NOT NULL;

-- 13. Вивести три стовпця Author, Press, Name + в дужках рік випуску і задати псевдоним, вибрати записи в яких поле Comment містить значення NULL і рік випуску від 2000+
SELECT Author, Press, [Name] + N' (' + cast(YearPress AS varchar) + N')' AS NameWithPress
FROM Books
WHERE YearPress >= 2000 AND Comment IS NULL;

-- 14. Оновіть поле Press новим значенямм "Біном Ко" в усіх записах з редакцією "Біном"
UPDATE Books
SET Press = N'Біном Ко'
WHERE Press = N'Біном';

-- 15. Додайте кількість +2 єкземпляри в усі записи окрім редакції "BHV"
UPDATE Books
SET Quantity = Quantity + 2
WHERE Press <> N'BHV';

-- Доп.завдання
-- 16. Відобразити книги, назви яких починаються на англійську букву або назви яких починаються з цифри.
SELECT *
FROM Books
WHERE [Name] LIKE N'[A-Z]%' OR [Name] LIKE N'[0-9]%';
-- Ще знайшов, що SQL Server не підтримує діапазони символів у виразі LIKE за замовчуванням 
-- і треба використовувати ось так - WHERE [Name] LIKE '[A-Z]%' COLLATE Latin1_General_BIN OR [Name] LIKE '[0-9]%'
-- Це забезпечить, що діапазон [A-Z] буде розглядати тільки латинські букви

-- 17. Виберіть усі книги, які мають більше 250 сторінок і були видані після 1999 року або не мають коментарі.
SELECT *
FROM Books
WHERE (Pages > 250 AND YearPress > 1999) OR Comment IS NULL;

-- 18. Зробить посторінков навігацію по 5 записів на сторінку
SELECT *
FROM Books
ORDER BY Id ASC
OFFSET 0 ROWS
FETCH FIRST 5 ROWS ONLY;

SELECT *
FROM Books
ORDER BY Id ASC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;