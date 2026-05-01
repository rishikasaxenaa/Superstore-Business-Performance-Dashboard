select*
from [portfolio 3]..cleaned_superstore

--Which Category is MOST Profitable (not just sales)

SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit)) / NULLIF(SUM(sales), 0), 
        2
    ) AS profit_margin_pct
FROM [portfolio 3]..cleaned_superstore
GROUP BY category
ORDER BY profit_margin_pct DESC

--Impact of Discount on Profit

SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit
FROM [portfolio 3]..cleaned_superstore
GROUP BY discount
ORDER BY discount

--Customer Segments Performance

SELECT 
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM [portfolio 3]..cleaned_superstore
GROUP BY segment
ORDER BY total_sales DESC

--Region-wise Profitability

SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM  [portfolio 3]..cleaned_superstore
GROUP BY region
ORDER BY total_profit DESC

--Top Loss-Making Products

SELECT 
    [Product Name],
    SUM(profit) AS total_loss
FROM [portfolio 3]..cleaned_superstore
GROUP BY [Product Name]
HAVING SUM(profit) < 0
ORDER BY total_loss ASC;


--Yearly Growth Analysis

SELECT 
    year,
    SUM(sales) AS yearly_sales,
    SUM(profit) AS yearly_profit
FROM [portfolio 3]..cleaned_superstore
GROUP BY year
ORDER BY year

--Delivery Performance Analysis

SELECT 
    [Ship Mode],
    AVG([Delivery Days]) AS avg_delivery_time
FROM [portfolio 3]..cleaned_superstore
GROUP BY [Ship Mode]
ORDER BY avg_delivery_time;

--High Sales but Low Profit Products

SELECT 
    [Product Name],
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM [portfolio 3]..cleaned_superstore
GROUP BY [Product Name]
HAVING SUM(sales) > 10000 AND SUM(profit) < 1000
ORDER BY total_sales DESC;

--Top Customers Contribution (CTE)

WITH customer_sales AS (
    SELECT 
        [Customer Name],
        SUM(sales) AS total_sales
    FROM [portfolio 3]..cleaned_superstore
    GROUP BY [Customer Name]
)

SELECT TOP 10 *,
    ROUND(total_sales * 100.0 / (SELECT SUM(total_sales) FROM customer_sales), 2) AS contribution_pct
FROM customer_sales
ORDER BY total_sales DESC

--Monthly Growth (CTE + Window Function)

WITH monthly_sales AS (
    SELECT 
        year,
        month,
        SUM(sales) AS total_sales
    FROM [portfolio 3]..cleaned_superstore
    GROUP BY year, month
)

SELECT 
    year,
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year, month) AS prev_month_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY year, month)) AS growth
FROM monthly_sales;

