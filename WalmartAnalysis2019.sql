SELECT Date, Total
FROM WalmartSalesData

------------------------------------------------------------Total sales for each product line----------------------------
SELECT Product_line,SUM(Total) AS TotalSales
FROM WalmartSalesData
GROUP BY Product_line

------------------------------------------Total quantity sold for each branch------------------------------------------
SELECT Branch,  SUM(Quantity) as QuantitySold
FROM WalmartSalesData
GROUP BY Branch

----------------------------------------- Average rating for each product line------------------------------------------
Select Product_line, AVG(Rating) As AverageRatings
FROM WalmartSalesData
GROUP BY Product_line

------------------------------------------Identifying the best selling product line----------------------------------------
SELECT Product_line, SUM(Quantity) AS TotalQuantitySold
FROM WalmartSalesData
GROUP BY Product_line
ORDER BY TotalQuantitySold DESC

--------------------------------Total gross income for each city---------------------------------------------------------
SELECT City, sum(gross_income) as TotalGrossIncome
FROM WalmartSalesData
Group by City

--------------------------------The top 5 highest sales invoices----------------------------------------------------------
SELECT Invoice_ID, Total
FROM WalmartSalesData
ORDER BY Total DESC
-----------------------------------WHICH MONTH HAD THE HIGHEST SALES?-----------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        FORMAT(Date, 'MMMM') AS month_name,
        CASE 
            WHEN MONTH(Date) = 1 THEN 'January'
            WHEN MONTH(Date) = 2 THEN 'February'
            WHEN MONTH(Date) = 3 THEN 'March'
        END AS months, Total
    FROM WalmartSalesData
)
SELECT 
    months,
    SUM(Total) AS total_sales
FROM MonthlySales
GROUP BY months
ORDER BY 1; 

----------------------------------WHICH BRANCH HAS MORE SALES A, B OR C?--------------------------------------------------------

WITH MonthlySales AS (
    SELECT 
        FORMAT(Date, 'MMMM') AS month_name,
        CASE 
            WHEN MONTH(Date) = 1 THEN 'January'
            WHEN MONTH(Date) = 2 THEN 'February'
            WHEN MONTH(Date) = 3 THEN 'March'
        END AS months, Total,Branch
    FROM WalmartSalesData
)
SELECT 
    months,
    Branch,
    SUM(Total) AS total_sales
INTO #BranchSales
FROM MonthlySales
GROUP BY month_name, months, Branch
ORDER BY 1 
    
 SELECT months, Branch, MAX(total_sales)
 FROM #BranchSales
 GROUP BY months, Branch
 Order by 3 DESC



