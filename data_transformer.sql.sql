CREATE DATABASE data_transformer_db;
USE data_transformer_db;

-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) NOT NULL
);

-- ============================================================
-- 2. INSERT SAMPLE DATA
-- ============================================================
-- The first records match the sample data provided in the
-- assignment. Additional records are included so that JOIN,
-- ranking, discount, and CASE examples produce useful results.

INSERT INTO Customers
(CustomerID, FirstName, LastName, Email, RegistrationDate)
VALUES
(1, 'John',  'Doe',    'john.doe@email.com',     '2022-03-15'),
(2, 'Jane',  'Smith',  'jane.smith@email.com',   '2021-11-02'),
(3, 'Michael','Brown', 'michael.brown@email.com','2023-01-10'),
(4, 'Emily', 'Davis',  'emily.davis@email.com',  '2022-08-25'),
(5, 'Daniel','Wilson', 'daniel.wilson@email.com','2023-04-18'),
(6, 'Sophia','Taylor', 'sophia.taylor@email.com','2021-06-30'),
(7, 'David', 'Miller', 'david.miller@email.com', '2024-02-12'),
(8, 'Olivia','Anderson','olivia.anderson@email.com','2024-05-20');

INSERT INTO Orders
(OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75),
(103, 1, '2023-08-12', 650.00),
(104, 3, '2023-09-05', 1250.00),
(105, 4, '2023-10-11', 875.25),
(106, 5, '2023-11-20', 1500.00),
(107, 2, '2024-01-15', 550.00),
(108, 6, '2024-02-28', 2500.00),
(109, 3, '2024-03-10', 720.00),
(110, 7, '2024-04-22', 300.00),
(111, 8, '2024-06-18', 1100.00),
(112, 5, '2024-07-05', 450.00);

INSERT INTO Employees
(EmployeeID, FirstName, LastName, Department, HireDate, Salary)
VALUES
(1, 'Mark',   'Johnson', 'Sales',      '2020-01-15', 50000.00),
(2, 'Susan',  'Lee',     'HR',         '2021-03-20', 55000.00),
(3, 'Robert', 'Clark',   'IT',         '2019-07-10', 85000.00),
(4, 'Linda',  'Walker',  'Finance',    '2022-05-18', 72000.00),
(5, 'James',  'Hall',    'Marketing',  '2023-02-01', 48000.00),
(6, 'Karen',  'Young',   'IT',         '2020-11-25', 95000.00);

-- ============================================================
-- 3. VERIFY TABLES / DATA
-- ============================================================

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Employees;


-- ============================================================
-- 4. QUERIES TO PERFORM
-- ============================================================

-- 1. INNER JOIN:
-- Retrieve all orders and customer details where orders exist.
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- 2. LEFT JOIN:
-- Retrieve all customers and their corresponding orders (if any).
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderID;

-- 3. RIGHT JOIN:
-- Retrieve all orders and their corresponding customers (if any).
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID;

-- 4. FULL OUTER JOIN:
-- MySQL does not support FULL OUTER JOIN directly.
-- UNION of LEFT JOIN and unmatched RIGHT JOIN gives the result.
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID

UNION

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL
ORDER BY CustomerID, OrderID;

-- 5. SUBQUERY:
-- Find customers who have placed orders worth more than
-- the average order amount.
SELECT DISTINCT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > (
    SELECT AVG(TotalAmount)
    FROM Orders
)
ORDER BY c.CustomerID;

-- 6. SUBQUERY:
-- Find employees with salaries above the average salary.
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
)
ORDER BY Salary DESC;

-- 7. DATE FUNCTION:
-- Extract the year and month from OrderDate.
SELECT
    OrderID,
    OrderDate,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth
FROM Orders
ORDER BY OrderID;

-- 8. DATE DIFFERENCE:
-- Calculate the difference in days between OrderDate and
-- the current date.
SELECT
    OrderID,
    OrderDate,
    DATEDIFF(CURDATE(), OrderDate) AS DaysSinceOrder
FROM Orders
ORDER BY OrderID;

-- 9. DATE FORMATTING:
-- Format OrderDate as DD-MMM-YYYY.
SELECT
    OrderID,
    OrderDate,
    DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedOrderDate
FROM Orders
ORDER BY OrderID;

-- 10. STRING CONCATENATION:
-- Concatenate FirstName and LastName to form a full name.
SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers
ORDER BY CustomerID;

-- 11. STRING REPLACEMENT:
-- Replace 'John' with 'Jonathan'.
SELECT
    CustomerID,
    FirstName,
    REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName
FROM Customers
ORDER BY CustomerID;

-- 12. UPPERCASE / LOWERCASE:
-- Convert FirstName to uppercase and LastName to lowercase.
SELECT
    CustomerID,
    UPPER(FirstName) AS FirstNameUpper,
    LOWER(LastName) AS LastNameLower
FROM Customers
ORDER BY CustomerID;

-- 13. TRIM:
-- Remove extra spaces from the Email field.
-- TRIM removes leading and trailing spaces.
SELECT
    CustomerID,
    Email,
    TRIM(Email) AS TrimmedEmail
FROM Customers
ORDER BY CustomerID;

-- 14. WINDOW FUNCTION:
-- Calculate the running total of TotalAmount for each order.
SELECT
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Orders
ORDER BY OrderDate, OrderID;

-- 15. WINDOW FUNCTION:
-- Rank orders based on TotalAmount using RANK().
SELECT
    OrderID,
    TotalAmount,
    RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders
ORDER BY AmountRank, OrderID;

- 16. CASE EXPRESSION:
-- Assign a discount based on TotalAmount:
-- More than 1000 = 10%
-- More than 500  = 5%
-- Otherwise       = 0%
SELECT
    OrderID,
    TotalAmount,
    CASE
        WHEN TotalAmount > 1000 THEN '10% Off'
        WHEN TotalAmount > 500 THEN '5% Off'
        ELSE 'No Discount'
    END AS Discount
FROM Orders
ORDER BY OrderID;

-- 17. CASE EXPRESSION:
-- Categorize employee salaries as High, Medium, or Low.
-- Assumption for this project:
-- 80000 or more = High
-- 50000 or more = Medium
-- Otherwise     = Low
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    CASE
        WHEN Salary >= 80000 THEN 'High'
        WHEN Salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees
ORDER BY Salary DESC;

-- ============================================================
-- 5. ADDITIONAL SUMMARY QUERIES
-- ============================================================

-- Total sales amount
SELECT SUM(TotalAmount) AS TotalSales
FROM Orders;

-- Average order amount
SELECT ROUND(AVG(TotalAmount), 2) AS AverageOrderAmount
FROM Orders;

-- Number of orders per customer
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY c.CustomerID;

-- Highest order amount
SELECT
    OrderID,
    TotalAmount
FROM Orders
WHERE TotalAmount = (SELECT MAX(TotalAmount) FROM Orders);

-- Department-wise employee count and average salary
SELECT
    Department,
    COUNT(*) AS EmployeeCount,
    ROUND(AVG(Salary), 2) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY Department;