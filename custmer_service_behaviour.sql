create database customer_shopping_behavior ;

use  customer_shopping_behavior ;

show tables;

select * from customer;
desc customer;



drop table customer;

# Q1 What is the total rvenue genrated by male vs. female customers ? 
select gender , sum(purchase_amount) revenue
from customer
group by gender;

# Q2 which customers used a discount but still spent more than the average purchase amoount ?
select customer_id, purchase_amount
from customer 
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

# Q3 Which are the top 5 products with the highest averge review rating ? 
select item_purchased,round(avg(review_rating),2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc 
limit 5 ;

#Q4 Compare the average purchase Amounts between Standard and Express Shipping .
select shipping_type,
avg(purchase_amount)
from customer 
where shipping_type in ('Standard', 'Express')
group by shipping_type;

# Q5 Do Subscribed Customers spend more ? Compare average spend and total revenue betweeen subscribers and non-subscriber.
select subscription_status, 
count(customer_id) as total_customers, 
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue 
from customer 
group by subscription_status 
order by total_revenue, avg_spend desc;

# Q6. which 5 products have the highest percetage of purchase with discounts applied? 
SELECT  item_purchased, 
ROUND(100 * sum(case when discount_applied = 'Yes' Then 1 ELSE 0 END) / COUNT(*),2) as discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

#Q7. segement customerinto new, returning, and loyal based on their total number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id, previous_purchases, 
case 
	when previous_purchases = 1 then 'New' 
    when previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    else 'Loyal'
    END As customer_segment 
from customer 
) 
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment ;

#Q8. What are  the top 3 most purchased products within eah category ? 
with item_counts as (
select category, 
item_purchased, 
count(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) DESC) as item_rank
from customer 
group by category, item_purchased 
)

select item_rank, category, item_purchased, total_orders 
from item_counts 
where item_rank <= 3;

#Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe ? 
select subscription_status, 
count(customer_id) as repeat_buyers 
from customer
where previous_purchases > 5 
group by subscription_status;

#Q10. What is the revenue contribution of each age group? 
select age_group, 
sum(purchase_amount) as total_revenue 
from customer
group by age_group 
order by total_revenue desc;


