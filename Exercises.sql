---Aggregate & Window Functions 
--Retrieve & Compare each Business Entity Sales YTD to Min , Max,   & Best Performer Sales

SELECT BusinessEntityID,
       TerritoryID,
       SalesQuota,
       Bonus,
       CommissionPct,
       SalesYTD,
       SUM(SalesYTD) OVER() AS Total_YTD_Sales,
       MAX(SalesYTD) OVER() AS Max_YTD_Sales,
       SalesYTD/MAX(SalesYTD) OVER()  AS [% of Best Performer] 

FROM AdventureWorks2019.Sales.SalesPerson

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
