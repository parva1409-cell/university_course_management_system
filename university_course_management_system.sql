CREATE DATABASE IF NOT EXISTS UniversityCourseDB;
USE UniversityCourseDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    EnrollmentDate DATE NOT NULL
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments (DepartmentName) VALUES
('Computer Science'),
('Mathematics'),
('Physics');


INSERT INTO Students
(FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
('John', 'Doe', 'john.doe@email.com', '2000-01-15', '2020-08-01'),
('Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
('Robert', 'Johnson', 'robert.j@email.com', '2001-03-10', '2022-08-01'),
('Emily', 'Brown', 'emily.brown@email.com', '2000-07-12', '2019-08-01'),
('Michael', 'Wilson', 'michael.w@email.com', '1999-11-20', '2023-08-01'),
('Sarah', 'Davis', 'sarah.davis@email.com', '2001-02-18', '2020-08-01'),
('David', 'Miller', 'david.miller@email.com', '2000-09-05', '2021-08-01'),
('Laura', 'Taylor', 'laura.taylor@email.com', '2002-04-22', '2023-08-01');


INSERT INTO Courses
(CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 1, 4),
(103, 'Database Management', 1, 3),
(104, 'Calculus', 2, 4),
(105, 'Statistics', 2, 3),
(106, 'Physics Fundamentals', 3, 4);


INSERT INTO Instructors
(FirstName, LastName, Email, DepartmentID, Salary) VALUES
('Alice', 'Johnson', 'alice.johnson@univ.com', 1, 75000.00),
('Bob', 'Lee', 'bob.lee@univ.com', 2, 65000.00),
('David', 'Miller', 'david.miller@univ.com', 3, 60000.00),
('Susan', 'Clark', 'susan.clark@univ.com', 1, 80000.00);


INSERT INTO Enrollments
(StudentID, CourseID, EnrollmentDate) VALUES
(1, 101, '2020-08-05'),
(2, 101, '2021-08-05'),
(3, 101, '2022-08-05'),
(4, 101, '2019-08-05'),
(5, 101, '2023-08-05'),
(6, 101, '2020-08-05'),
(1, 102, '2020-08-06'),
(2, 102, '2021-08-06'),
(3, 102, '2022-08-06'),
(7, 102, '2021-08-06'),
(4, 103, '2019-08-07'),
(5, 103, '2023-08-07'),
(6, 103, '2020-08-07'),
(1, 104, '2020-08-08'),
(2, 104, '2021-08-08'),
(7, 104, '2021-08-08'),
(3, 105, '2022-08-09'),
(5, 105, '2023-08-09'),
(8, 105, '2023-08-09'),
(4, 106, '2019-08-10'),
(6, 106, '2020-08-10');

-- Query 1: Perform CRUD Operations on all tables

-- CREATE / INSERT
INSERT INTO Students
(FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
('Test', 'Student', 'test.student@email.com', '2002-01-01', '2024-08-01');

-- READ / SELECT
SELECT * FROM Students;

-- UPDATE
UPDATE Students
SET Email = 'updated.student@email.com'
WHERE FirstName = 'Test' AND LastName = 'Student';

-- DELETE
DELETE FROM Students
WHERE FirstName = 'Test' AND LastName = 'Student';

-- Query 2: Retrieve students who enrolled after 2022

SELECT StudentID, FirstName, LastName, EnrollmentDate
FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- Query 3: Retrieve courses offered by the Mathematics department with a limit of 5 courses

SELECT Courses.CourseID, Courses.CourseName, Courses.Credits
FROM Courses
INNER JOIN Departments
ON Courses.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Mathematics'
LIMIT 5;

-- Query 4: Get the number of students enrolled in each course, filtering for courses with more than 5 students

SELECT CourseID, COUNT(StudentID) AS NumberOfStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- Query 5: Find students who are enrolled in both Introduction to SQL and Data Structures

SELECT StudentID
FROM Enrollments
WHERE CourseID IN (101, 102)
GROUP BY StudentID
HAVING COUNT(DISTINCT CourseID) = 2;

-- Query 6: Find students who are either enrolled in Introduction to SQL or Data Structures

SELECT DISTINCT Students.StudentID,
       Students.FirstName,
       Students.LastName
FROM Students
INNER JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
WHERE Enrollments.CourseID IN (101, 102);

-- Query 7: Calculate the average number of credits for all courses

SELECT AVG(Credits) AS AverageCredits
FROM Courses;

-- Query 8: Find the maximum salary of instructors in the Computer Science department

SELECT MAX(Instructors.Salary) AS MaximumSalary
FROM Instructors
INNER JOIN Departments
ON Instructors.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Computer Science';

-- Query 9: Count the number of students enrolled in each department

SELECT Departments.DepartmentName,
       COUNT(DISTINCT Enrollments.StudentID) AS NumberOfStudents
FROM Departments
LEFT JOIN Courses
ON Departments.DepartmentID = Courses.DepartmentID
LEFT JOIN Enrollments
ON Courses.CourseID = Enrollments.CourseID
GROUP BY Departments.DepartmentID, Departments.DepartmentName;

-- Query 10: INNER JOIN - Retrieve students and their corresponding courses

SELECT Students.StudentID,
       Students.FirstName,
       Students.LastName,
       Courses.CourseName
FROM Students
INNER JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
INNER JOIN Courses
ON Enrollments.CourseID = Courses.CourseID;

-- Query 11: LEFT JOIN - Retrieve all students and their corresponding courses, if any

SELECT Students.StudentID,
       Students.FirstName,
       Students.LastName,
       Courses.CourseName
FROM Students
LEFT JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
LEFT JOIN Courses
ON Enrollments.CourseID = Courses.CourseID;

-- Query 12: Subquery - Find students in courses that have more than 10 students

SELECT DISTINCT Students.StudentID,
       Students.FirstName,
       Students.LastName
FROM Students
INNER JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
WHERE Enrollments.CourseID IN
(
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);

-- Query 13: Extract the year from the EnrollmentDate of students

SELECT StudentID,
       EnrollmentDate,
       YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;


-- Query 14: Concatenate the instructor's first name and last name

SELECT InstructorID,
       CONCAT(FirstName, ' ', LastName) AS InstructorName
FROM Instructors;


-- Query 15: Calculate the running total of students enrolled in courses

SELECT CourseID,
       COUNT(StudentID) AS NumberOfStudents,
       SUM(COUNT(StudentID)) OVER
       (ORDER BY CourseID) AS RunningTotal
FROM Enrollments
GROUP BY CourseID;

-- Query 16: Label students as 'Senior' or 'Junior' based on their year of enrollment

SELECT StudentID,
       FirstName,
       LastName,
       EnrollmentDate,
       CASE
           WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4
           THEN 'Senior'
           ELSE 'Junior'
       END AS StudentLevel
FROM Students;