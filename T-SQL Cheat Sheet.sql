-- 1. Вибір всіх студентів з певного курсу
SELECT *
FROM Students
WHERE CourseId = 1;

-- 2. Вибір унікальних курсів, на які записані студенти
SELECT DISTINCT CourseId
FROM Students;

-- 3. Підрахунок кількості студентів на кожному курсі
SELECT CourseId, COUNT(StudentId) AS StudentCount
FROM Students
GROUP BY CourseId;

-- 4. Вибір студентів, чий вік більше 18 років і які навчаються на курсі з ID 2
SELECT *
FROM Students
WHERE Age > 18 AND CourseId = 2;

-- 5. Вибір студентів, які не зареєстровані на жоден курс (LEFT JOIN)
SELECT s.*
FROM Students s
LEFT JOIN Courses c ON s.CourseId = c.CourseId
WHERE c.CourseId IS NULL;

-- 6. З’єднання таблиць студентів і курсів з вибором імені студента та назви курсу
SELECT s.StudentName, c.CourseName
FROM Students s
JOIN Courses c ON s.CourseId = c.CourseId;

-- 7. Знайти всіх студентів, які навчаються у певного викладача
SELECT s.StudentName, t.TeacherName
FROM Students s
JOIN Courses c ON s.CourseId = c.CourseId
JOIN Teachers t ON c.TeacherId = t.TeacherId
WHERE t.TeacherId = 3;

-- 8. Підрахунок загальної кількості студентів у системі
SELECT COUNT(*) AS TotalStudents
FROM Students;

-- 9. Вибір студентів, ім'я яких починається на "A"
SELECT *
FROM Students
WHERE StudentName LIKE 'A%';

-- 10. Оновити інформацію про курс для студента
UPDATE Students
SET CourseId = 5
WHERE StudentId = 10;

-- 11. Видалити студентів, чий вік більше 30
DELETE FROM Students
WHERE Age > 30;

-- 12. Знайти всі курси, на які записано більше 50 студентів
SELECT CourseId
FROM Students
GROUP BY CourseId
HAVING COUNT(StudentId) > 50;

-- 13. Вибір студентів з обмеженням кількості результатів (pagination)
SELECT *
FROM Students
ORDER BY StudentId
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 14. Об’єднати таблиці курсів і викладачів з додатковим полем "Назва викладача"
SELECT c.CourseName, t.TeacherName
FROM Courses c
JOIN Teachers t ON c.TeacherId = t.TeacherId;

-- 15. Підрахунок кількості курсів, які веде кожен викладач
SELECT TeacherId, COUNT(CourseId) AS CourseCount
FROM Courses
GROUP BY TeacherId;

-- 16. Знайти студентів, які зареєстровані на два конкретних курси одночасно
SELECT s.StudentName
FROM Students s
JOIN Enrollments e1 ON s.StudentId = e1.StudentId AND e1.CourseId = 1
JOIN Enrollments e2 ON s.StudentId = e2.StudentId AND e2.CourseId = 2;

-- 17. Показати найстаршого студента на кожному курсі
SELECT CourseId, MAX(Age) AS OldestStudent
FROM Students
GROUP BY CourseId;

-- 18. Підрахунок середнього віку студентів для кожного курсу
SELECT CourseId, AVG(Age) AS AverageAge
FROM Students
GROUP BY CourseId;

-- 19. Вибір студентів, які не відвідують жоден курс (без використання JOIN)
SELECT *
FROM Students
WHERE CourseId IS NULL;

-- 20. Вивести студентів, які мають однакове ім'я
SELECT StudentName, COUNT(*)
FROM Students
GROUP BY StudentName
HAVING COUNT(*) > 1;

-- 21. Створити новий курс та вставити запис в таблицю
INSERT INTO Courses (CourseName, TeacherId)
VALUES ('Data Science', 4);

-- 22. Знайти студентів, які мають однакове ім'я і навчаються на одному курсі (використання кількох умов)
SELECT StudentName, CourseId, COUNT(*)
FROM Students
GROUP BY StudentName, CourseId
HAVING COUNT(*) > 1;

-- 23. Оновити всі курси, які викладаються викладачем №2, встановивши нову назву
UPDATE Courses
SET CourseName = 'Advanced Programming'
WHERE TeacherId = 2;

-- 24. Знайти курс з найбільшою кількістю студентів
SELECT TOP 1 CourseId, COUNT(StudentId) AS StudentCount
FROM Students
GROUP BY CourseId
ORDER BY StudentCount DESC;

-- 25. Вивести студентів, які записані на найбільшу кількість курсів
SELECT StudentId, COUNT(CourseId) AS CourseCount
FROM Enrollments
GROUP BY StudentId
ORDER BY CourseCount DESC;

-- Робота з транзакціями — це окрема популярна тема. Наприклад, можна продемонструвати, як використовувати транзакції, щоб забезпечити атомарність кількох операцій:
BEGIN TRANSACTION;

UPDATE Students
SET Age = Age + 1
WHERE StudentId = 1;

DELETE FROM Enrollments
WHERE StudentId = 1 AND CourseId = 2;

COMMIT;