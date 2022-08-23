
--- Joins, Aggregate, Window Functions
---Retrieve a query with First_name, Last_name from Person's Table , 
---Job title from Human Resurce Table , Rate from EmplyeePayHistory Table and 
---Derieve a column called 'Average Rate that returns the average of all values in the Rate Column'
SELECT FirstName,
       LastName,
       JobTitle,
         Rate,
        AVG(Rate) OVER() AS Avg_Rate   
FROM AdventureWorks2019.Person.Person t1
JOIN AdventureWorks2019.HumanResources.Employee t2 on t1.BusinessEntityID = t2.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory t3 on t1.BusinessEntityID = t3.BusinessEntityID

--Enhance your query from above by adding a derived column called
--"MaximumRate" that returns the largest of all values in the "Rate" column, in each row
SELECT FirstName,
       LastName,
       JobTitle,
       Rate,
       AVG(Rate) OVER() AS Avg_Rate ,
       MAX(Rate) OVER() AS Max_Rate   
FROM AdventureWorks2019.Person.Person t1
JOIN AdventureWorks2019.HumanResources.Employee t2 on t1.BusinessEntityID = t2.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory t3 on t1.BusinessEntityID = t3.BusinessEntityID

---Enhance your query from above by adding a derived column called
---"DiffFromAvgRate" that returns the result of the following calculation:
---An employees's pay rate, MINUS the average of all values in the "Rate" column.
SELECT FirstName,
       LastName,
       JobTitle,
       Rate,
       AVG(Rate) OVER() AS Avg_Rate ,
       MAX(Rate) OVER() AS Max_Rate,
       Rate - AVG(Rate)  OVER() AS DiffFromAvgRate

FROM AdventureWorks2019.Person.Person t1
JOIN AdventureWorks2019.HumanResources.Employee t2 on t1.BusinessEntityID = t2.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory t3 on t1.BusinessEntityID = t3.BusinessEntityID

--Enhance your query from above by adding a derived column called
--"PercentofMaxRate" that returns the result of the following calculation:
--An employees's pay rate, DIVIDED BY the maximum of all values in the "Rate" column, times 100.
SELECT FirstName,
       LastName,
       JobTitle,
       Rate,
       AVG(Rate) OVER() AS Avg_Rate ,
       MAX(Rate) OVER() AS Max_Rate,
       Rate - AVG(Rate)  OVER() AS DiffFromAvgRate
      (Rate/MAX(Rate)) * 100  OVER() AS PercentofMaxRate

FROM AdventureWorks2019.Person.Person t1
JOIN AdventureWorks2019.HumanResources.Employee t2 on t1.BusinessEntityID = t2.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory t3 on t1.BusinessEntityID = t3.BusinessEntityID

---Partition By 
---Create a query with the following columns:
---“Name” from the Production.Product table, which can be alised as “ProductName”
---“ListPrice” from the Production.Product table
---“Name” from the Production. ProductSubcategory table, which can be alised as “ProductSubcategory”*
---“Name” from the Production. Category table, which can be alised as “ProductCategory”** 
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t1.ProductSubcategoryID = t3.ProductCategoryID

--Enhance your query from above by adding a derived column called
--"AvgPriceByCategory " that returns the average ListPrice for the product category in each given row
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory,
AVG(ListPrice) OVER(PARTITION BY t3.Name) AS AvgPriceByCategory
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t2.ProductSubcategoryID = t3.ProductCategoryID

---Enhance your query from above by adding a derived column called
---"AvgPriceByCategoryAndSubcategory" that returns the average ListPrice for the product category AND subcategory in each given row.
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory,
AVG(ListPrice) OVER(PARTITION BY t3.Name) AS AvgPriceByCategory,
AVG(ListPrice) OVER(PARTITION BY t3.Name, t2.Name) AS AvgPriceByCategoryAndSubcategory
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t2.ProductSubcategoryID = t3.ProductCategoryID

---Enhance your query from above by adding a derived column called
---"ProductVsCategoryDelta" that returns the result of the following calculation:
---A product's list price, MINUS the average ListPrice for that product’s category.
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory,
AVG(ListPrice) OVER(PARTITION BY t3.Name) AS AvgPriceByCategory,
AVG(ListPrice) OVER(PARTITION BY t3.Name, t2.Name) AS AvgPriceByCategoryAndSubcategory,
ListPrice - AVG(ListPrice) OVER(PARTITION BY t3.Name) AS AvgPriceByCategory
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t2.ProductSubcategoryID = t3.ProductCategoryID

---Enhance your main intial query  by adding a derived column called
---"Category Price Rank" that ranks all products by ListPrice – within each category - in descending order. 
---In other words, every product within a given category should be ranked relative to other products in the same category.
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory,
ROW_NUMBER() OVER (ORDER  BY ListPrice DESC) AS Price_Rank,
ROW_NUMBER() OVER (PARTITION BY t3.Name ORDER BY ListPrice DESC) AS CategoryPrice_Rank
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t1.ProductSubcategoryID = t3.ProductCategoryID

--Enhance your main query from above by adding a derived column called
--"Top 5 Price In Category" that returns the string “Yes” if a product has one of the top 5 list prices in its product category, 
--and “No” if it does not. You can try incorporating your logic from Exercise 3 into a CASE statement to make this work.
SELECT
t1.Name AS ProductName,
ListPrice,
t2.Name AS ProductSubcategory,
t3.Name AS ProductCategory,
ROW_NUMBER() OVER (ORDER  BY ListPrice DESC) AS Price_Rank,
ROW_NUMBER() OVER (PARTITION BY t3.Name ORDER BY ListPrice DESC) AS CategoryPrice_Rank,
(CASE WHEN (ROW_NUMBER() OVER (PARTITION BY t3.Name ORDER BY ListPrice DESC) <= 5 ) THEN 'Yes' ELSE 'No' END ) AS Top5
FROM AdventureWorks2019.Production.Product t1
JOIN AdventureWorks2019.Production.ProductSubcategory t2  ON t1.ProductSubcategoryID = t2.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory t3  ON t1.ProductSubcategoryID = t3.ProductCategoryID

---Create a query with the following columns:
---“PurchaseOrderID” from the Purchasing.PurchaseOrderHeader table
---“OrderDate” from the Purchasing.PurchaseOrderHeader table
---“TotalDue” from the Purchasing.PurchaseOrderHeader table
---“Name” from the Purchasing.Vendor table, which can be aliased as “VendorName”*
---*Join Purchasing.Vendor to Purchasing.PurchaseOrderHeader on BusinessEntityID = VendorID
SELECT
PurchaseOrderID,
OrderDate,
TotalDue,
VendorID,
Name AS VendorName
FROM Purchasing.PurchaseOrderHeader t1
JOIN Purchasing.Vendor t2 ON t1.VendorID =  t2.BusinessEntityID 
WHERE OrderDate >= '2013-01-01'
AND TotalDue > 500

--Modify your query from above by adding a derived column called
--"PrevOrderFromVendorAmt", that returns the “previous” TotalDue value 
---(relative to the current row) within the group of all orders with the same vendor ID. 
--We are defining “previous” based on order date.
SELECT
VendorID,
Name AS VendorName,
PurchaseOrderID,
OrderDate,
TotalDue,
LAG(TotalDue, 1) OVER (PARTITION BY VendorID ORDER BY OrderDate) AS PreviousOrderDueAmt

FROM Purchasing.PurchaseOrderHeader t1
JOIN Purchasing.Vendor t2 ON t1.VendorID =  t2.BusinessEntityID 
WHERE OrderDate >= '2013-01-01'
AND TotalDue > 500
ORDER BY VendorID, OrderDate

--Modify your query from above by adding a derived column called
--"NextOrderByEmployeeVendor", that returns the “next” vendor name (the “name” field from Purchasing.Vendor) 
--within the group of all orders that have the same EmployeeID value in Purchasing.PurchaseOrderHeader. 
--Similar to the last exercise, we are defining “next” based on order date.
SELECT
VendorID,
Name AS VendorName,
LEAD(Name, 1) OVER (PARTITION BY EmployeeID ORDER BY OrderDate) AS NextOrderByEmployeeVendor,
PurchaseOrderID,
OrderDate,
TotalDue,
LAG(TotalDue, 1) OVER (PARTITION BY VendorID ORDER BY OrderDate) AS PreviousOrderDueAmt
FROM Purchasing.PurchaseOrderHeader t1
JOIN Purchasing.Vendor t2 ON t1.VendorID =  t2.BusinessEntityID 
WHERE OrderDate >= '2013-01-01'
AND TotalDue > 500
ORDER BY EmployeeID, OrderDate
--Write a query that displays the three most expensive orders, per vendor ID, from the Purchasing.PurchaseOrderHeader 
--table. There should ONLY be three records per Vendor ID, even if some of the total amounts due are identical. 
--"Most expensive" is defined by the amount in the "TotalDue" field.
--Include the following fields in your output: PurchaseOrderID,VendorID, OrderDate, TaxAmt, Freight,TotalDue
SELECT * FROM (SELECT 
PurchaseOrderID,
VendorID,
OrderDate,
SubTotal,
TaxAmt,
Freight,
TotalDue,
ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC) AS Max_TotalAmt
FROM
Purchasing.PurchaseOrderHeader) A1
WHERE Max_TotalAmt <= 3

--Modify your query from the first problem, such that the top three purchase order amounts are returned, 
--regardless of how many records are returned per Vendor Id.
--In other words, if there are multiple orders with the same total due amount, all should be returned as long as the 
--total due amount for these orders is one of the top three.
SELECT * FROM (SELECT 
PurchaseOrderID,
VendorID,
OrderDate,
SubTotal,
TaxAmt,
Freight,
TotalDue,
DENSE_RANK() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC) AS Max_TotalAmt
FROM
Purchasing.PurchaseOrderHeader) A1
WHERE Max_TotalAmt <= 3

---Write a query that outputs all records from the Purchasing.PurchaseOrderHeader table. 
---Include the following columns from the table: PurchaseOrderID, VendorID, OrderDate, TotalDue
---Add a derived column called NonRejectedItems which returns, for each purchase order ID in the query output, 
---the number of line items from the Purchasing.PurchaseOrderDetail table which did not have any rejections (i.e., RejectedQty = 0).
---Use a correlated subquery to do this.
SELECT 
PurchaseOrderID,
VendorID,
OrderDate,
TotalDue,
  (SELECT COUNT(*) FROM Purchasing.PurchaseOrderDetail T2
   WHERE T1.PurchaseOrderID = T2.PurchaseOrderID AND T2.RejectedQty = 0)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader T1

--Modify your query to include a second derived field called MostExpensiveItem.
--This field should return, for each purchase order ID, the UnitPrice of the most expensive item 
--for that order in the Purchasing.PurchaseOrderDetail table.
--Use a correlated subquery to do this as well.

SELECT 
PurchaseOrderID,
VendorID,
OrderDate,
TotalDue,
(SELECT COUNT(*) FROM Purchasing.PurchaseOrderDetail T2 WHERE T1.PurchaseOrderID = T2.PurchaseOrderID AND T2.RejectedQty = 0) AS NonRejectedItems,
(SELECT MAX(UnitPrice) FROM Purchasing.PurchaseOrderDetail T2 WHERE T1.PurchaseOrderID = T2.PurchaseOrderID ) AS MostExpensiveItem
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader T1

---Select all records from the Purchasing.PurchaseOrderHeader table such that 
---there is at least one item in the order with an order quantity greater than 500. 
---The individual items tied to an order can be found in the Purchasing.PurchaseOrderDetail table.
---Select the following columns:PurchaseOrderID, OrderDate, SubTotal, TaxAmt
--- Sort by purchase order ID.
SELECT 
PurchaseOrderID,
OrderDate,
SubTotal,
TaxAmt
FROM  Purchasing.PurchaseOrderHeader t1
WHERE EXISTS 
(SELECT 
1
FROM Purchasing.PurchaseOrderDetail  t2 
WHERE  t1.PurchaseOrderID = t2.PurchaseOrderID
AND OrderQty > 500)
ORDER BY 1

---Create a query that displays all rows from the Production.ProductSubcategory table, and includes the following fields:
---The "Name" field from Production.ProductSubcategory, which should be aliased as "SubcategoryName"
---A derived field called "Products" which displays, for each Subcategory in Production.ProductSubcategory, 
---a semicolon-separated list of all products from Production.Product contained within the given subcategory
SELECT 
A.*,
 STUFF(
(SELECT 
': ' + CAST(Name AS VARCHAR)
FROM  Production.Product  B
WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
FOR XML PATH('')),
1,1,'') AS Product 
FROM Production.ProductSubcategory A
ORDER BY Name

--Using PIVOT, write a query against the HumanResources.Employee table
--that summarizes the average amount of vacation time for Sales Representatives, Buyers, and Janitors.
SELECT * FROM 
(SELECT JobTitle, VacationHours FROM HumanResources.Employee) A
PIVOT(
AVG(VacationHours)
FOR JobTitle IN ([Sales Representative],[Buyer],[Janitor]) 
)B 

--Modify your query from above  such that the results are broken out by Gender. 
--Alias the Gender field as "Employee Gender" in your output.
-- Your output should look like the image below.
SELECT * FROM 
(SELECT Gender AS EmployeeGender, JobTitle, VacationHours FROM HumanResources.Employee) A
PIVOT(
AVG(VacationHours)
FOR JobTitle IN ([Sales Representative],[Buyer],[Janitor]) 
)B 

----Use a recursive CTE to generate a list of all odd numbers between 1 and 100.
WITH OddNumber AS (SELECT 1 AS MyNumber
UNION ALL
SELECT MyNumber + 2
FROM OddNumber
WHERE MyNumber < 99)
SELECT MyNumber FROM OddNumber

---Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.)
--from 1/1/2020 to 12/1/2029.
WITH DateSeries AS (SELECT CAST('01-01-2021' AS DATE) AS MyDate
UNION ALL
SELECT DATEADD(MONTH, 1, MyDate)
FROM DateSeries
WHERE MyDate <  CAST('12-01-2029' AS DATE))
SELECT MyDate FROM DateSeries  OPTION(MAXRECURSION 365)

---User defined Functions
CREATE FUNCTION dbo.ufnElapsedBusinessDays(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS  
BEGIN
	RETURN 
		(
			SELECT
				COUNT(*)
			FROM AdventureWorks2019.dbo.Calendar
			WHERE DateValue BETWEEN @StartDate AND @EndDate
				AND WeekendFlag = 0
				AND HolidayFlag = 0
		)	- 1
END

