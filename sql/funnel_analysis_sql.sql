use funnel_analysis;

select * from user_activities;

#Task-1 : Data Exploration

#1. Total rows in dataset
select count(*) as Total_rows from user_activities;

#2. Unique users
select count(distinct `User ID`) as Unique_users from user_activities;

#3. Unique sessions
select count(distinct `Session ID`) as Unique_sessions from user_activities;

#4. List all event types
select distinct Event from user_activities;

#Task 2: Funnel Stage Analysis

#1. Count total events by type
select Event,count(*) as Total_events 
from user_activities
group by Event
order by Total_events desc;

#2. Count users per event type
select Event,count(distinct `User ID`) as Total_users
from user_activities
group by Event
order by Total_users desc;

#3. Calculate conversion rate from Browse to Purchase.
SELECT ROUND(COUNT(DISTINCT CASE WHEN Event = 'Purchase' THEN `User ID` END) * 100.0 /
        COUNT(DISTINCT CASE WHEN Event = 'Browse' THEN `User ID` END),2) AS conversion_rate
FROM user_activities;

#Task 3: Revenue Analysis

#1. Total revenue
SELECT ROUND(SUM(Revenue), 2) AS total_revenue FROM user_activities;

#2. Revenue by region
SELECT Region,ROUND(SUM(Revenue), 2) AS total_revenue FROM user_activities
group by Region;

#3. Revenue by channel
SELECT Channel,ROUND(SUM(Revenue), 2) AS total_revenue FROM user_activities
group by Channel;

#4. Revenue by device
SELECT Device,ROUND(SUM(Revenue), 2) AS total_revenue FROM user_activities
group by Device;

#Task 4: Business Insights Queries

-- 1. Top 5 users by revenue
SELECT `User ID`,ROUND(SUM(Revenue), 2) AS total_revenue
FROM user_activities
WHERE Event = 'Purchase'
GROUP BY `User ID`
ORDER BY total_revenue DESC
LIMIT 5;

-- 2. Best performing channel
SELECT Channel,ROUND(SUM(Revenue), 2) AS total_revenue
FROM user_activities
WHERE Event = 'Purchase'
GROUP BY Channel
ORDER BY total_revenue DESC
LIMIT 1;

-- 3. Highest revenue region
SELECT Region,ROUND(SUM(Revenue), 2) AS total_revenue
FROM user_activities
WHERE Event = 'Purchase'
GROUP BY Region
ORDER BY total_revenue DESC
LIMIT 1;

-- 4. Device with highest conversion rate
SELECT
    Device,COUNT(DISTINCT CASE WHEN Event = 'Browse' THEN `User ID` END) AS total_browsers,
    COUNT(DISTINCT CASE WHEN Event = 'Purchase' THEN `User ID` END) AS total_purchasers,
    ROUND(COUNT(DISTINCT CASE WHEN Event = 'Purchase' THEN `User ID` END) * 100.0 / (COUNT(DISTINCT CASE WHEN Event = 'Browse' THEN `User ID` END)),2) AS conversion_rate
FROM user_activities
GROUP BY Device
ORDER BY conversion_rate DESC;

#Task 5: Drop-off Analysis

#1. Where users drop the most in funnel
SELECT 10000 - 6949 AS browse_to_cart_dropoff,
    6949 - 3456 AS cart_to_checkout_dropoff,
    3456 - 1004 AS checkout_to_purchase_dropoff;

#2. Event type with lowest conversion
SELECT
    ROUND(6949 * 100.0 / 10000, 2)
        AS browse_to_cart,
    ROUND(3456 * 100.0 / 6949, 2)
        AS cart_to_checkout,
    ROUND(1004 * 100.0 / 3456, 2)
        AS checkout_to_purchase;


