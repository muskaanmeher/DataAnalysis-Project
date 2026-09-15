create database python_sql_powerbi_project;
rename table updated_data to customer;

select*from customer;

-- total revenue male vs female
select gender,sum(purchase_amount) as revenue from customer group by gender;

-- Q2. Which customers used a discount but still spent more than the average purchase amount? 
select customer_id,purchase_amount from customer where discount_applied='yes' and purchase_amount>(select avg(purchase_amount)from customer);

-- Q3. Which are the top 5 products with the highest average review rating?
select  item_purchased,round(avg(review_rating),2) as average_product_rating from customer group by  item_purchased order by round(avg(review_rating),2) desc limit 5;

-- Q4. Compare the average Purchase Amounts between Standard and Express Shipping.
select shipping_type,round(avg(purchase_amount),2) from customer group by shipping_type having shipping_type='standard' or shipping_type='express';


-- Q5. Do subscribed customers spend more? Compare average spend and total revenue 
-- between subscribers and non-subscribers.
select *from customer;
select subscription_status,count(customer_id),sum(purchase_amount)as total_revenue,avg(purchase_amount) as average_spend from customer group by subscription_status ;

-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
#discount percent on each product
select item_purchased,
round(sum(case when discount_applied='yes' then 1 else 0 end)/count(*)*100,2) as discount_rate
from customer group by item_purchased order by discount_rate desc limit 5;


-- Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
 select count(customer_id) as noof_customers,sum(previous_purchases) as total_noof_purchases,case
 when PREVIOUS_purchases=1 then 'New'
 when previous_purchases between 2 and 10 then 'Returning'
 else 'Loyal'
 end as Customer_segment
 from customer group by customer_segment;
 
 -- Q8. What are the top 3 most purchased products within each category? 
 with top3_purchased_products as 
 (
 select category,item_purchased,count(customer_id) as total_orders, row_number() over(partition by category order by count(customer_id) desc)as item_rank 
 from customer group by category,item_purchased
 )
 select item_rank,category,item_purchased,total_orders from top3_purchased_products where item_rank<=3;
 
 -- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
 select subscription_status,count(customer_id) as repeat_buyers from customer where previous_purchases>5 group by subscription_status;
 
 select*from customer;
-- Q10. What is the revenue contribution of each age group? 
select age_group,sum(purchase_amount) as revenue from customer group by age_group order by revenue desc;