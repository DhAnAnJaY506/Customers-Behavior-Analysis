CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    item_purchased VARCHAR(50),
    category VARCHAR(50),
    purchase_amount DECIMAL(10,2),
    location VARCHAR(50),
    size VARCHAR(10),
    color VARCHAR(20),
    season VARCHAR(20),
    review_rating DECIMAL(2,1),
    subscription_status VARCHAR(20),
    shipping_type VARCHAR(30),
    discount_applied BOOLEAN,
    promo_code_used BOOLEAN,
    previous_purchases INT,
    payment_method VARCHAR(30),
    frequency_of_purchases VARCHAR(30),
    age_group VARCHAR(20),
    purchase_frequency_day INT
);

SELECT * FROM customers;

-- Q1. What is the total revenue grenerated by male vs. female customers ?
SELECT
	gender,
	SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY 1
ORDER BY 2 DESC;

-- Q2. Which customers used a discount but still spent more than the average purchase amount ?
SELECT
	customer_id,
	purchase_amount
FROM customers
WHERE discount_applied = True AND
	purchase_amount >= (
	SELECT
		AVG(purchase_amount)
	FROM customers
);

-- Q3. Which are the top 5 products with the highest average review rating ?
SELECT
	item_purchased,
	ROUND(AVG(review_rating), 2) AS avg_review_rating
FROM customers
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q4. Compare the average Purchase Amounts betweeen Standard and Express Shipping.
SELECT * FROM customers;
SELECT
	shipping_type,
	AVG(purchase_amount) AS total_revenue
FROM customers
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY 1
ORDER BY 2 DESC;

--Q5. Do subscribed customers spend more? Calculate the avg spent and total revenue
-- between subscriber and non-subscriber
SELECT
	subscription_status,
	COUNT(*) AS total_Customers,
	ROUND(AVG(purchase_amount), 2) AS avg_purchase_amt,
	SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY 1;

--Q6 Which 5 products have the highest percentage of purchase with discounts applied ?
SELECT
	item_purchased,
	round(
		SUM(
			CASE WHEN discount_applied = TRUE THEN 1 ELSE 0	END)
			/COUNT(*) * 100,2)
FROM customers
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q7. Segment customers into New, Returning, and Loyal based on their total
-- number of previous purchases, and show the count of each segment
WITH customer_type AS (
	SELECT
		customer_id,
		previous_purchases,
		CASE
			WHEN previous_purchases = 1 THEN 'New'
			WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
			ELSE 'Loyal'
		END AS customer_segment
	FROM customers
)
SELECT
	customer_segment,
	COUNT(*) AS no_of_customers
FROM customer_type
GROUP BY 1;

-- Q8. What are the top 3 purchased products withthin each category
WITH items_count AS
(
	SELECT
		category,
		item_purchased,
		COUNT(*) AS total_orders,
		ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(*) DESC) AS item_rank
	FROM customers
	GROUP BY 1,2
)
SELECT
	item_rank,
	category,
	item_purchased,
	total_orders
FROM items_count
WHERE item_rank <= 3;

-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe ?
SELECT 
	subscription_status,
	COUNT(*) AS repeat_buyers	
FROM customers
WHERE previous_purchases > 5
GROUP BY 1;

-- Q10. What is the revenue contribution of each group ?
SELECT
	age_group,
	SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY 1
ORDER BY 2 DESC;
	