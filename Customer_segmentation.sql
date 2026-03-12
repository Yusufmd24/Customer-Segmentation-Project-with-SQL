select * from orders

-- Data Cleaning --

-- Check for NULL values
SELECT * FROM orders 
WHERE total_amount > 0;

-- Check for Duplicate values
SELECT order_id, COUNT(*)
FROM orders 
GROUP BY order_id
HAVING COUNT(*) > 1 ;

-- Customer Revenue Analysis
SELECT customer_id, 
	   ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC ;

-- Purchase Frequency Analysis
SELECT customer_id, 
	   COUNT(order_id) AS purchase_frequency
FROM orders
GROUP BY customer_id
ORDER BY purchase_frequency DESC;

-- Recency Analysis
SELECT  customer_id, 
		MAX(order_date) AS last_purchase_date,
		DATEDIFF(day, MAX(order_date), GETDATE()) AS days_since_last_purchase
FROM orders
GROUP BY customer_id
ORDER BY days_since_last_purchase DESC;

-- Average Order Value
SELECT customer_id, 
	   ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY customer_id
ORDER BY avg_order_value DESC;

-- Customer Lifetime Value
SELECT customer_id, 
	   ROUND(SUM(total_amount), 2) AS lifetime_value
FROM orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;

-- Revenue Ranking Using Window Function
SELECT customer_id,
		ROUND(SUM(total_amount),2) AS total_revenue,
		RANK() OVER(ORDER BY SUM(total_amount) DESC) AS revenue_rank
FROM orders
GROUP BY customer_id;

-- Customer Segmentation
WITH customer_metrics AS(
SELECT
	customer_id,
	ROUND(SUM(total_amount),2) AS Monetary,
	COUNT(order_id) AS Frequency,
	DATEDIFF(day, MAX(order_date), GETDATE()) AS Recency
FROM orders
GROUP BY customer_id
)
SELECT *,
CASE 
	WHEN Monetary > 5000 AND Frequency > 10 THEN 'High Value Customers'
	WHEN Frequency > 8 THEN 'Loyal Customers'
	WHEN Recency > 180 THEN 'Churn Risk'
ELSE 'Regular Customers'
END AS customer_segments
From customer_metrics;

-- Pareto Analysis
WITH revenue_table AS (
SELECT customer_id, 
	   ROUND(SUM(total_amount),2) AS revenue
FROM orders
GROUP BY customer_id
),
revenue_calc AS (
SELECT customer_id,
	   revenue,
	   SUM(revenue) OVER() AS total_revenue,
	   revenue * 100.0 / SUM(revenue) OVER() AS revenue_percentage
FROM revenue_table
)
SELECT * FROM revenue_calc
ORDER BY revenue DESC;
