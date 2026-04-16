select count(*) from clean_zomato;

-- 1. OVERVIEW KPIs
SELECT
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_per_two), 2) AS avg_cost_for_two,
    SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END) AS online_order_available,
    SUM(CASE WHEN book_table = 'Yes' THEN 1 ELSE 0 END) AS table_booking_available
FROM clean_zomato;


-- 2. TOP 10 LOCATIONS BY RESTAURANT COUNT
SELECT
    location,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_per_two), 0) AS avg_cost
FROM clean_zomato
GROUP BY location
ORDER BY total_restaurants DESC
LIMIT 10;


-- 3. BEST RATED LOCATIONS (min 100 restaurants)
SELECT
    location,
    ROUND(AVG(rate), 2) AS avg_rating,
    COUNT(*) AS total_restaurants
FROM clean_zomato
GROUP BY location
HAVING COUNT(*) >= 100
ORDER BY avg_rating DESC
LIMIT 10;


-- 4. ONLINE ORDER IMPACT ON RATING
SELECT
    online_order,
    COUNT(*) AS total,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_per_two ), 0) AS avg_cost
FROM clean_zomato
GROUP BY online_order;


-- 5. TABLE BOOKING IMPACT ON RATING
SELECT
    book_table,
    COUNT(*) AS total,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(votes), 0) AS avg_votes
FROM clean_zomato
GROUP BY book_table;


-- 6. RESTAURANT TYPE PERFORMANCE
SELECT
    rest_type_clean,
    COUNT(*) AS total,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_per_two ), 0) AS avg_cost,
    ROUND(AVG(votes), 0) AS avg_votes
FROM clean_zomato
GROUP BY rest_type_clean
ORDER BY avg_rating DESC;


-- 7. COST CATEGORY BREAKDOWN
SELECT
    CASE
        WHEN cost_per_two  <= 500 THEN 'Low'
        WHEN cost_per_two  <= 1000 THEN 'Medium'
        ELSE 'High'
    END AS cost_category,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(votes), 0) AS avg_votes
FROM clean_zomato
GROUP BY cost_category
ORDER BY avg_rating DESC;


-- 8. TOP 15 MOST VOTED RESTAURANTS
SELECT
    name,
    location,
    rest_type_clean,
    rate,
    votes,
    cost_per_two 
FROM clean_zomato
ORDER BY votes DESC
LIMIT 15;


-- 9. LOCATION + REST TYPE HEATMAP DATA
SELECT
    location,
    rest_type_clean,
    COUNT(*) AS total,
    ROUND(AVG(rate), 2) AS avg_rating
FROM clean_zomato
GROUP BY location, rest_type_clean
HAVING COUNT(*) >= 10
ORDER BY location, total DESC;


-- 10. LISTED TYPE ANALYSIS
SELECT
    listed_type,
    COUNT(*) AS total,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_per_two ), 0) AS avg_cost
FROM clean_zomato
GROUP BY listed_type
ORDER BY total DESC;


-- 11. HIGH VALUE RESTAURANTS
-- (High rated + High cost = Premium segment)
SELECT
    name,
    location,
    rest_type_clean,
    rate,
    cost_per_two ,
    votes
FROM clean_zomato
WHERE rate >= 4.0
  AND cost_per_two  >= 1000
ORDER BY rate DESC, votes DESC
LIMIT 20;


-- 12. HIDDEN GEMS
-- (High rated, low votes = underrated)
SELECT
    name,
    location,
    rate,
    votes,
    cost_per_two ,
    rest_type_clean
FROM clean_zomato
WHERE rate >= 4.0
  AND votes < 100
ORDER BY rate DESC
LIMIT 20;