-- 1) Remove the CONSTRAINT 
DECLARE
    v_constraint_name_learning_to VARCHAR2(255);
    v_constraint_name_learned VARCHAR2(255);
BEGIN
    -- Delete the constraint from the LEARNING_TO table
    BEGIN
        SELECT uc.constraint_name
        INTO v_constraint_name_learning_to
        FROM user_constraints uc
        JOIN user_constraints ruc ON uc.r_constraint_name = ruc.constraint_name
        WHERE uc.table_name = 'LEARNING_TO'
          AND uc.constraint_type = 'R'
          AND ruc.table_name = 'STUDENT';

        EXECUTE IMMEDIATE 'ALTER TABLE LEARNING_TO DROP CONSTRAINT ' || v_constraint_name_learning_to;
        DBMS_OUTPUT.PUT_LINE('Constraint ' || v_constraint_name_learning_to || ' was dropped successfully from LEARNING_TO.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No matching constraint found in LEARNING_TO.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred while dropping constraint from LEARNING_TO: ' || SQLERRM);
    END;

    -- Delete the constraint from the LEARNED table
    BEGIN
        SELECT uc.constraint_name
        INTO v_constraint_name_learned
        FROM user_constraints uc
        JOIN user_constraints ruc ON uc.r_constraint_name = ruc.constraint_name
        WHERE uc.table_name = 'LEARNED'
          AND uc.constraint_type = 'R'
          AND ruc.table_name = 'STUDENT';

        EXECUTE IMMEDIATE 'ALTER TABLE LEARNED DROP CONSTRAINT ' || v_constraint_name_learned;
        DBMS_OUTPUT.PUT_LINE('Constraint ' || v_constraint_name_learned || ' was dropped successfully from LEARNED.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No matching constraint found in LEARNED.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred while dropping constraint from LEARNED: ' || SQLERRM);
    END;
END;
/

COMMIT;

-- Delete the CHECK constraints from the STUDENTS And Librarians tables (from task 2):
-- Remove phone format constraints
ALTER TABLE Students
DROP CONSTRAINT check_student_phone_format;

ALTER TABLE Librarians
DROP CONSTRAINT check_librarian_phone_format;

-- Remove email validation constraints
ALTER TABLE Students
DROP CONSTRAINT check_student_email_validity;

ALTER TABLE Librarians
DROP CONSTRAINT check_librarian_email_validity;

COMMIT;

-- 2) Insert the degree to the learning_to table
INSERT INTO learning_to (s_id, type_ba_or_ma, dep_name)
SELECT 
    Student_id AS s_id, 
    SUBSTR(Degree, 1, INSTR(Degree, ' ') - 1) AS type_ba_or_ma, -- the part before the first space
    SUBSTR(Degree, INSTR(Degree, 'in') + 3) AS dep_name -- the part after the 'in' word
FROM Students;

COMMIT;

-- remove the degree column from the students table:
ALTER TABLE students
DROP COLUMN Degree;

COMMIT;


-- 3) Clean the students and the lacturer names from the "student" and "lecturer" tables:

-- in the student table, all new column: student_first_name, student_last_name
ALTER TABLE student
ADD student_first_name VARCHAR(50);

ALTER TABLE student
ADD student_last_name VARCHAR(50);

-- in the students table, add column named dormitories_name with constraint to the dormitories table:
ALTER TABLE students
ADD dormitories_name VARCHAR(50);

COMMIT;

-- remove the dot from the s_name column in the student table.
update student
set s_name = replace(s_name, '.', '')
where s_name like '%.%';

COMMIT;

-- remove the extra words from the s_name column in the student table.
UPDATE student
SET s_name = TRIM(
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      s_name,
      '( MD| DDS| DVM| PhD| Jr| Dr| Miss| Mr| Mrs| Ms)$',
      ''
    ),
    '^.*? (\S+ \S+)$',
    '\1'
  )
)
WHERE (LENGTH(TRIM(s_name)) - LENGTH(REPLACE(TRIM(s_name), ' ', '')) + 1) > 2;

COMMIT;

-- insert the student_first_name and student_last_name columns in the student table from the s_name column:
UPDATE student
SET student_first_name = REGEXP_REPLACE(s_name, '^(.*?) .*$', '\1'),
    student_last_name = REGEXP_REPLACE(s_name, '^.*? (.*)$', '\1');

COMMIT;

-- remove the dot from the l_name column in the lecturer table.
update lecturer
set l_name = replace(l_name, '.', '')
where l_name like '%.%';

COMMIT;

-- remove the extra words from the l_name column in the lecturer table.
UPDATE lecturer
SET l_name = TRIM(
  REGEXP_REPLACE(
    REGEXP_REPLACE(
      l_name,
      '( MD| DDS| DVM| PhD| Jr| Dr| Miss| Mr| Mrs| Ms)$',
      ''
    ),
    '^.*? (\S+ \S+)$',
    '\1'
  )
)
WHERE (LENGTH(TRIM(l_name)) - LENGTH(REPLACE(TRIM(l_name), ' ', '')) + 1) > 2;

COMMIT;

-- create lecturer_first_name and lecturer_last_name columns in the lecturer table:
ALTER TABLE lecturer
ADD lecturer_first_name VARCHAR(50);

ALTER TABLE lecturer
ADD lecturer_last_name VARCHAR(50);

COMMIT;

-- insert the lecturer_first_name and lecturer_last_name columns in the lecturer table from the l_name column:
UPDATE lecturer
SET lecturer_first_name = REGEXP_REPLACE(l_name, '^(.*?) .*$', '\1'),
    lecturer_last_name = REGEXP_REPLACE(l_name, '^.*? (.*)$', '\1');

COMMIT;


-- 4) copy all the students from student table to sudents table:
INSERT INTO students (student_id, student_first_name, student_last_name, email, phone, birth_date, start_date, dormitories_name)
SELECT s_id, student_first_name, student_last_name, email, phone_number, birth_date, TO_DATE('14/10/' || (2024 - learning_year + 1), 'DD/MM/YYYY'), d_name
FROM student;

COMMIT;

--5) add the constraint to the students table:
ALTER TABLE students
ADD CONSTRAINT fk_dormitories_name
FOREIGN KEY (dormitories_name)
REFERENCES dormitories(d_name);

COMMIT;

-- ADD CONSTRAINT
ALTER TABLE learning_to
ADD CONSTRAINT fk_s_id_lt
FOREIGN KEY (s_id)
REFERENCES students(student_id);

COMMIT;

-- ADD CONSTRAINT
ALTER TABLE learned
ADD CONSTRAINT fk_s_id_l
FOREIGN KEY (s_id)
REFERENCES students(student_id);

COMMIT;


-- 6) delete the student table:
DROP TABLE student;

COMMIT;


-- 7) change table for inherited tables:
--===============================================
-- ADDING INHERITANCE TO THE DATABASE
--===============================================

--           
--          |--> BookAuthors               
-- Person --|  
--          |                   |---> Students
--          |  Comunacation     |
--          |-->  _Person ------|               |--> Librarians
--                              |---> Workers --|
--                                              |--> Lecturers

CREATE TABLE Workers (
    Worker_id INT PRIMARY KEY, 
    Hire_date DATE NOT NULL, 
    Salary_per_month INT NOT NULL
);

COMMIT;

-- all all the librarians to the workers table:
-- the libarians has no salary, so we will give random salary of 7000-15000
INSERT INTO Workers (Worker_id, Hire_date, Salary_per_month)
SELECT Librarian_id, Hire_date, FLOOR(DBMS_RANDOM.VALUE(7000, 15000))
FROM Librarians;

COMMIT;


-- all all the lecturers to the workers table:
-- the lecturers has no hire date, so we will give random hire date between 1/1/1980 and 1/1/2002:
INSERT INTO Workers (Worker_id, Hire_date, Salary_per_month)
SELECT l_id, TO_DATE('01/01/' || FLOOR(DBMS_RANDOM.VALUE(1980, 2002)), 'DD/MM/YYYY'), salary_per_month
FROM lecturer;

COMMIT;


-- remove the columns from the original tables:

ALTER TABLE Librarians
DROP COLUMN Hire_date;

ALTER TABLE lecturer
DROP COLUMN salary_per_month;

--  add fk to the librarians table:
ALTER TABLE Librarians
ADD CONSTRAINT fk_librarians
FOREIGN KEY (Librarian_id)
REFERENCES Workers(Worker_id)
ON DELETE CASCADE;

--  add fk to the lecturers table:
ALTER TABLE lecturer
ADD CONSTRAINT fk_lecturers
FOREIGN KEY (l_id)
REFERENCES Workers(Worker_id)
ON DELETE CASCADE;

COMMIT;

-----------------------------------------------------------------------------------------------------------------

-- create table comunicationPerson: c_person_id, email, phone_number

CREATE TABLE ComunicationPerson (
    c_person_id INT PRIMARY KEY, 
    email VARCHAR2(100) NOT NULL, 
    phone_number VARCHAR2(40) NOT NULL
);

COMMIT;

-- transfer the data from the students table to the comunicationPerson table:
INSERT INTO ComunicationPerson (c_person_id, email, phone_number)
SELECT Student_id, Email, Phone
FROM Students;

COMMIT;

-- remove the columns from the original table:
ALTER TABLE Students
DROP COLUMN Email;

ALTER TABLE Students
DROP COLUMN Phone;

-- add fk to the students table:
ALTER TABLE Students
ADD CONSTRAINT fk_students
FOREIGN KEY (Student_id)
REFERENCES ComunicationPerson(c_person_id)
ON DELETE CASCADE;

COMMIT;

-- transfer the data from the librarians table to the comunicationPerson table:
INSERT INTO ComunicationPerson (c_person_id, email, phone_number)
SELECT Librarian_id, Email, Phone
FROM Librarians;

COMMIT;

-- remove the columns from the original table:
ALTER TABLE Librarians
DROP COLUMN Email;

ALTER TABLE Librarians
DROP COLUMN Phone;

COMMIT;

-- transfer the data from the lecturer table to the comunicationPerson table:
INSERT INTO ComunicationPerson (c_person_id, email, phone_number)
SELECT l_id, email, phone_number
FROM lecturer;

COMMIT;

-- remove the columns from the original table:
ALTER TABLE lecturer
DROP COLUMN email;

ALTER TABLE lecturer
DROP COLUMN phone_number;

-- add fk to the workers table:
ALTER TABLE Workers
ADD CONSTRAINT fk_workers
FOREIGN KEY (Worker_id)
REFERENCES ComunicationPerson(c_person_id)
ON DELETE CASCADE;

COMMIT;

--  some emails has 2 rows, so we will add '.co.il' instead of the domain name in the first row of each email
UPDATE ComunicationPerson
SET email = REPLACE(email, SUBSTR(email, INSTR(email, '@')), '@example.co.il')
WHERE ROWID IN (
    SELECT MIN(ROWID)
    FROM ComunicationPerson
    WHERE email IN (
        SELECT email
        FROM ComunicationPerson
        GROUP BY email
        HAVING COUNT(*) > 1
    )
    GROUP BY email
);

COMMIT;


-- Add UNIQUE constraint to email in ComunicationPerson table
ALTER TABLE ComunicationPerson
ADD CONSTRAINT unique_email UNIQUE (email);

-- Add UNIQUE constraint to phone_number in ComunicationPerson table
ALTER TABLE ComunicationPerson
ADD CONSTRAINT unique_phone_number UNIQUE (phone_number);

COMMIT;

-----------------------------------------------------------------------------------------------------------------


-- create table parson: person_id, first_name, last_name, birth_date

CREATE TABLE Person (
    person_id INT PRIMARY KEY, 
    first_name VARCHAR2(100) NOT NULL, 
    last_name VARCHAR2(100) NOT NULL, 
    birth_date DATE NOT NULL
);

COMMIT;

-- transfer the data from the bookAuthors table to the person table:
INSERT INTO Person (person_id, first_name, last_name, birth_date)
SELECT Author_id, Author_first_name, Author_last_name, Author_birth_date
FROM BookAuthors;

COMMIT;

-- remove the columns from the original table:
ALTER TABLE BookAuthors
DROP COLUMN Author_first_name;

ALTER TABLE BookAuthors
DROP COLUMN Author_last_name;

ALTER TABLE BookAuthors
DROP COLUMN Author_birth_date;

-- add fk to the bookAuthors table:
ALTER TABLE BookAuthors
ADD CONSTRAINT fk_bookAuthors
FOREIGN KEY (Author_id)
REFERENCES Person(person_id)
ON DELETE CASCADE;

COMMIT;

-- transfer the data from the students, librarians, and lecturer tables to the person table:
INSERT INTO Person (person_id, first_name, last_name, birth_date)
SELECT Student_id, Student_first_name, Student_last_name, Birth_date
FROM Students;

COMMIT;

INSERT INTO Person (person_id, first_name, last_name, birth_date)
SELECT Librarian_id, Librarian_first_name, Librarian_last_name, Librarian_birth_date
FROM Librarians;

COMMIT;

INSERT INTO Person (person_id, first_name, last_name, birth_date)
SELECT l_id, lecturer_first_name, lecturer_last_name, TO_DATE('01/01/' || FLOOR(DBMS_RANDOM.VALUE(1950, 1990)), 'DD/MM/YYYY')
FROM lecturer;

COMMIT;

-- remove the columns from the original tables:
ALTER TABLE Students
DROP COLUMN Student_first_name;

ALTER TABLE Students
DROP COLUMN Student_last_name;

ALTER TABLE Students
DROP COLUMN Birth_date;

ALTER TABLE Librarians
DROP COLUMN Librarian_first_name;

ALTER TABLE Librarians
DROP COLUMN Librarian_last_name;

ALTER TABLE Librarians
DROP COLUMN Librarian_birth_date;

ALTER TABLE lecturer
DROP COLUMN l_name;

-- add fk to the comunicationPerson table:
ALTER TABLE ComunicationPerson
ADD CONSTRAINT fk_comunicationPerson
FOREIGN KEY (c_person_id)
REFERENCES Person(person_id)
ON DELETE CASCADE;

COMMIT;

