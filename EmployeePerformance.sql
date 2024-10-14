/*

Career Simulation: Employee Performance Mapping

Situation 

ScienceQtech is a startup that works in the Data Science field. ScienceQtech has worked on fraud detection, market basket, self-driving cars, supply chain, 
algorithmic early detection of lung cancer, customer sentiment, and the drug discovery field. With the annual appraisal cycle around the corner, the HR 
department has asked you (Junior Database Administrator) to generate reports on employee details, their performance, and on the project that the employees have 
undertaken, to analyze the employee database and extract specific data based on different requirements. 

Task 

To facilitate a better understanding, managers have provided ratings for each employee which will help the HR department to finalize the employee performance mapping. 
As a DBA, you should find the maximum salary of the employees and ensure that all jobs meet the organization's profile standard. You also need to calculate bonuses to 
find extra costs for expenses. This will improve the organization's overall performance by ensuring all the employees required receive training.

*/


--Action   

-- 1. Create tables then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database 
--from the given resources.

-- Create emp_record_table
CREATE TABLE emp_record_table (
    EMP_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(10),
    ROLE VARCHAR(50),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50),
    SALARY DECIMAL(10, 2),
    EMP_RATING DECIMAL(2, 1),
    MANAGER_ID INT,
    PROJ_ID INT
);

-- Create proj_table
CREATE TABLE proj_table (
    PROJECT_ID INT PRIMARY KEY,
    PROJ_NAME VARCHAR(100),
    DOMAIN VARCHAR(50),
    START_DATE DATE,
    CLOSURE_DATE DATE,
    DEV_QTR VARCHAR(10),
    STATUS VARCHAR(20)
);

-- Create data_science_team
CREATE TABLE data_science_team (
    EMP_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(10),
    ROLE VARCHAR(50),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50)
);

--•	Downloaded files by right clicking on”FinalSQLProject”
--•	Import the downloaded files by right clicking on ”EmployeePerformance”
--•	Select the CSV file->choose the 3 CSV file->next and import


-- 2. Create an ER diagram for the given employee database.
--Solution: In the Project-General tab, right click on the Diagrams-> select->create new ER diagram-> Select the Database and enter the name->create

-- 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT 
--from the employee record table, and make a list of employees and details of their department.
SELECT 
	e.EMP_ID , 
	concat (e.FIRST_NAME ,	e.LAST_NAME) as Emp_Name, 
	e.GENDER , 
	e.DEPT as Department
FROM emp_record_table e ;


--4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
--less than two, greater than four, and between two and four

SELECT 
    e.EMP_ID, 
    concat (e.FIRST_NAME, e.LAST_NAME) as Employee_Name, 
    GENDER, 
    DEPT AS DEPARTMENT, 
    EMP_RATING,
    CASE 
        WHEN EMP_RATING < 2 THEN 'Low Rating'
        WHEN EMP_RATING BETWEEN 2 AND 4 THEN 'Medium Rating'
        WHEN EMP_RATING > 4 THEN 'High Rating'
        ELSE 'No Rating'
    END AS RATING_CATEGORY
FROM emp_record_table e;

--5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table 
--and then give the resultant column alias as NAME.

SELECT 
	CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME,
	e.dept as Department
FROM emp_record_table e 
WHERE DEPT = 'FINANCE';

-- 6. Write a query to list only those employees who have someone reporting to them. 
--Also, show the number of reporters (including the President).
SELECT 
    e.EMP_ID, 
    e.FIRST_NAME, 
    e.LAST_NAME, 
    e.ROLE, 
    COUNT(r.EMP_ID) AS NUM_REPORTERS
FROM emp_record_table e
JOIN emp_record_table r ON e.EMP_ID = r.MANAGER_ID
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE;

-- 7. Write a query to list all the employees from the healthcare and finance departments using union. 
--Take data from the employee record table.
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
FROM emp_record_table 
WHERE DEPT = 'HEALTHCARE'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
FROM emp_record_table 
WHERE DEPT = 'FINANCE';

-- 8. Write a query to list employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
--Also include the respective employee rating along with the max emp rating for the department.

SELECT 
    e.EMP_ID, 
    e.FIRST_NAME, 
    e.LAST_NAME, 
    e.ROLE, 
    e.DEPT AS DEPARTMENT, 
    e.EMP_RATING, 
    MAX(e.EMP_RATING) OVER (PARTITION BY e.DEPT) AS MAX_DEPT_RATING
FROM emp_record_table e
ORDER BY e.DEPT;

-- 9. Write a query to calculate the minimum and the maximum salary of the employees in each role. 
--Take data from the employee record table. 
SELECT 
    ROLE, 
    MIN(SALARY) AS MIN_SALARY, 
    MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;


-- 10 .Write a query to assign ranks to each employee based on their experience. 
--Take data from the employee record table. 
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    EXP, 
    RANK() OVER (ORDER BY EXP DESC) AS EXPERIENCE_RANK
FROM emp_record_table;


-- 11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
--Take data from the employee record table. 
CREATE VIEW high_salary_employees AS
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    COUNTRY, 
    SALARY
FROM emp_record_table
WHERE SALARY > 6000;

--12.Write a nested query to find employees with experience of more than ten years. 
--Take data from the employee record table.
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP 
FROM emp_record_table 
WHERE EXP > (
    SELECT AVG(EXP) FROM emp_record_table
    WHERE EXP > 10
);

-- 13. Write a query to check whether the job profile assigned to each employee in the data science team matches 
--the organization’s set standard.The standard being: 
--For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
--For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
--For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
--For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
--For an employee with the experience of 12 to 16 years assign 'MANAGER'.
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    ROLE, 
    EXP, 
    CASE 
        WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
        WHEN EXP > 2 AND EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
        WHEN EXP > 5 AND EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
        WHEN EXP > 10 AND EXP <= 12 THEN 'LEAD DATA SCIENTIST'
        WHEN EXP > 12 AND EXP <= 16 THEN 'MANAGER'
        ELSE 'INVALID ROLE'
    END AS EXPECTED_ROLE,
    CASE 
        WHEN ROLE = 
            CASE 
                WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
                WHEN EXP > 2 AND EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
                WHEN EXP > 5 AND EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
                WHEN EXP > 10 AND EXP <= 12 THEN 'LEAD DATA SCIENTIST'
                WHEN EXP > 12 AND EXP <= 16 THEN 'MANAGER'
                ELSE 'INVALID ROLE'
            END 
        THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS ROLE_MATCH
FROM data_science_team;


-- 14. Write a query to calculate the bonus for all the employees, based on their ratings and 
--salaries (Use the formula: 5% of salary * employee rating). 
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    SALARY, 
    EMP_RATING, 
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM emp_record_table;


-- 15. Write a query to calculate the average salary distribution based on the continent and country. 
--Take data from the employee record table.
SELECT 
    CONTINENT, 
    COUNTRY, 
    AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;




