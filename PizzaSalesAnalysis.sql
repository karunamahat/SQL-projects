SELECT *
FROM pizza_sales
------------------------------------Total Revenue------------------------------------------------------------------
SELECT SUM(total_price) AS TotalRevenue
FROM pizza_sales

-----------------------------------Average Order Value-------------------------------------------------------------
SELECT SUM(total_price)/count(DISTINCT order_id) AS AverageOrderValue
FROM pizza_sales

-----------------------------------Total Pizza sold--------------------------------------------------------------
SELECT SUM(quantity) AS TotalSold
FROM pizza_sales

-----------------------------------Total Orders------------------------------------------------------------------
SELECT COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales

-----------------------------------Average Pizzas Per Order------------------------------------------------------
SELECT CAST(SUM(quantity) AS DECIMAL(10,2))/CAST(COUNT(distinct order_id) AS DECIMAL(10,2)) AS Average
FROM pizza_sales

----------------------------------Daily Trend for Orders---------------------------------------------------------
SELECT  DATENAME(DW,order_date) AS order_day, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW,order_date)

-------------------------------Monthly Trend Of Orders-----------------------------------------------------------
SELECT DATENAME(Month,order_date) As MonthsName, COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales
GROUP BY DATENAME(Month,order_date)

-------------------------------------Sales Percentage by Pizza category-------------------------------------------
SELECT pizza_category, sum(total_price)*100/(SELECT SUM(total_price) FROM pizza_sales) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_category

-------------------------------------Sales Percentage By Pizza Size on the Second month of the year----------------------------------------------
SELECT pizza_size, sum(total_price)*100/(SELECT SUM(total_price) FROM pizza_sales WHERE Month(order_date)=2) AS Sales_Percentage
FROM pizza_sales
WHERE Month(order_date)=2
GROUP BY pizza_size

------------------------------------Top 5 AND Bottom 5 Best Sellers-----------------------------------------------------------
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Sales DESC

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Sales 