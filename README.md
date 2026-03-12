# Customer-Segmentation-Project-with-SQL

## Project Overview

Businesses often have thousands of customers, but not all customers contribute equally to revenue. Identifying high-value customers helps companies design targeted marketing strategies, improve retention, and increase profitability.

This project analyzes customer purchasing behavior using SQL to segment customers based on **recency, frequency, and spending patterns**.

The analysis helps answer key business questions such as:

* Who are the most valuable customers?
* Which customers purchase most frequently?
* Which customers are at risk of churn?
* How can customers be segmented for targeted marketing strategies?

---

# Business Problem

The company wants to better understand customer purchasing behavior in order to optimize marketing strategies and improve retention.

Key questions include:

* Which customers generate the highest revenue?
* Which customers purchase most frequently?
* Which customers have stopped purchasing?
* How can customers be segmented for personalized marketing campaigns?

By answering these questions, the company can focus resources on the **most valuable customer segments**.

---

# Dataset Description

The dataset contains **transaction-level sales data**.

| Column       | Description                         |
| ------------ | ----------------------------------- |
| order_id     | Unique identifier for each order    |
| customer_id  | Unique identifier for each customer |
| order_date   | Date of purchase                    |
| product_id   | Product identifier                  |
| quantity     | Number of items purchased           |
| price        | Price per unit                      |
| total_amount | Total value of the order            |

Example dataset size:

* 150,000 transactions
* 5,000 customers
* 2 years of sales data

---

# Tools & Technologies

* SQL Server
* T-SQL
* Window Functions
* Aggregations
* Common Table Expressions (CTEs)
* Power BI (optional dashboard)

---

# Project Workflow

The analysis was conducted in the following stages:

1. Data Cleaning
2. Duplicate and NULL value checks
3. Customer Revenue Analysis
4. Purchase Frequency Analysis
5. Recency Analysis
6. Average Order Value Calculation
7. Customer Lifetime Value Analysis
8. Revenue Ranking with Window Functions
9. Customer Segmentation (RFM Model)
10. Pareto Analysis (80/20 Rule)
11. Business Insights and Recommendations

---

# Key SQL Analyses

## Customer Revenue Analysis

Identify customers generating the highest revenue.

```sql
SELECT customer_id,
       ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC;
```

---

## Purchase Frequency Analysis

Determine how frequently each customer places orders.

```sql
SELECT customer_id,
       COUNT(order_id) AS purchase_frequency
FROM orders
GROUP BY customer_id
ORDER BY purchase_frequency DESC;
```

---

## Recency Analysis

Identify how recently customers made purchases.

```sql
SELECT customer_id,
       MAX(order_date) AS last_purchase_date,
       DATEDIFF(day, MAX(order_date), GETDATE()) AS days_since_last_purchase
FROM orders
GROUP BY customer_id
ORDER BY days_since_last_purchase DESC;
```

---

# Customer Segmentation (RFM Analysis)

Customers are segmented based on:

* **Recency** → How recently a customer purchased
* **Frequency** → How often they purchase
* **Monetary Value** → How much they spend

Example segmentation query:

```sql
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
END AS customer_segment
FROM customer_metrics;
```

---

# Pareto Analysis (80/20 Rule)

Analyze revenue contribution across customers to identify revenue concentration.

```sql
WITH revenue_table AS (
SELECT customer_id,
       SUM(total_amount) AS revenue
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

SELECT *
FROM revenue_calc
ORDER BY revenue DESC;
```

This analysis helps determine whether a **small percentage of customers contribute the majority of revenue**.

---

# Key Insights

* A small percentage of customers generate a large portion of total revenue.
* High-frequency customers represent the most loyal segment.
* Some customers have not purchased in over 6 months, indicating potential churn risk.
* Customer segmentation enables targeted marketing strategies.

---

# Business Recommendations

Based on the analysis:

* Provide **loyalty rewards** for high-value customers.
* Launch **re-engagement campaigns** for inactive customers.
* Offer **personalized product recommendations** to frequent buyers.
* Focus marketing budgets on segments with the **highest revenue potential**.

---

# Skills Demonstrated

* SQL Data Analysis
* Window Functions and CTEs
* Customer Segmentation (RFM Analysis)
* Business Analytics
* Data Cleaning
* Marketing Insight Generation

---

# Author

**Yusuf M**

Aspiring Data Analyst focused on data-driven business insights using SQL, Python, and visualization tools.
