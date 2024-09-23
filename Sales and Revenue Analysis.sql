
--Create a Sample Sales Database

CREATE DATABASE SalesNRevenue;

USE SalesNRevenue;

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Create Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

--Insert Sample Data

-- Insert data into Customers Table
INSERT INTO Customers (CustomerID, CustomerName, Country)
VALUES
(1, 'John Doe', 'USA'),
(2, 'Jane Smith', 'Canada'),
(3, 'Ali Ahmad', 'UK'),
(4, 'Prateek Jhulena', 'India'),
(5, 'Kaushik Anand', 'India');

-- Insert data into Products Table
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 1500.00),
(2, 'Smartphone', 700.00),
(3, 'Tablet', 300.00),
(4, 'SmartWatch', 800.00),
(5, 'TV', 1300.00);

-- Insert data into Sales Table
INSERT INTO Sales (SaleID, CustomerID, ProductID, SaleDate, Quantity)
VALUES
(1, 1, 1, '2024-09-01', 2),
(2, 2, 2, '2024-09-02', 3),
(3, 3, 3, '2024-09-03', 5),
(4, 1, 2, '2024-09-04', 1),
(5, 2, 2, '2024-09-04', 1);

--SQL Queries for Sales and Revenue Analysis

--Total Revenue by Product
SELECT P.ProductName, SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName;

--Revenue by Country
SELECT C.Country, SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.Country;

--Monthly Sales Trends
SELECT MONTH(S.SaleDate) AS SaleMonth, SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY MONTH(S.SaleDate)
ORDER BY SaleMonth;

--Top Customers by Revenue
SELECT C.CustomerName, SUM(S.Quantity * P.Price) AS CustomerRevenue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.CustomerName
ORDER BY CustomerRevenue DESC;

--What is the Average Order Value (AOV) by Customer?
SELECT C.CustomerName, AVG(S.Quantity * P.Price) AS AverageOrderValue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.CustomerName;

--Which Products Have the Highest Sales Volume (Units Sold)?
SELECT P.ProductName, SUM(S.Quantity) AS TotalUnitsSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalUnitsSold DESC;

--What are the Sales Trends by Country Over Time?
SELECT C.Country, MONTH(S.SaleDate) AS SaleMonth, SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.Country, MONTH(S.SaleDate)
ORDER BY C.Country, SaleMonth;

--What is the Revenue Growth Rate Over Time?
WITH RevenueByMonth AS (
    SELECT MONTH(S.SaleDate) AS SaleMonth, SUM(S.Quantity * P.Price) AS MonthlyRevenue
    FROM Sales S
    JOIN Products P ON S.ProductID = P.ProductID
    GROUP BY MONTH(S.SaleDate)
)
SELECT SaleMonth, 
       MonthlyRevenue,
       (MonthlyRevenue - LAG(MonthlyRevenue) OVER (ORDER BY SaleMonth)) / LAG(MonthlyRevenue) OVER (ORDER BY SaleMonth) * 100 AS GrowthRate
FROM RevenueByMonth;

--Which Time Periods Show the Highest Sales Activity?

SELECT DATENAME(WEEKDAY, S.SaleDate) AS SaleDay, COUNT(S.SaleID) AS TotalSales
FROM Sales S
GROUP BY DATENAME(WEEKDAY, S.SaleDate)
ORDER BY TotalSales DESC;


