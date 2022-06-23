
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
