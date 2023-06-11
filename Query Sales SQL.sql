--Import table order_items ke sql
CREATE TABLE public.order_items
(
    id	integer primary key,
    order_id integer,
    user_id	integer,
    product_id	integer,
    inventory_item_id	integer,
    status	varchar,
    created_at	timestamp,
    shipped_at	timestamp,
    delivered_at	timestamp,
    returned_at	timestamp,
    sale_price numeric
);
SELECT*FROM order_items
ORDER BY id;

--Import table products ke sql
CREATE TABLE public.products
(
    id integer,	
    cost	numeric,
    category varchar,
    name	varchar,
    brand	varchar,
    retail_price	numeric,
    department	varchar,
    sku	varchar,
    distribution_center_id integer
);
SELECT*FROM products

--Import table orders ke sql
CREATE TABLE public.orders(
    order_id integer,	
    user_id	integer,
    status	varchar,
    gender	char,
    created_at	timestamp,
    returned_at	timestamp,
    shipped_at	timestamp,
    delivered_at	timestamp,
    num_of_item integer
);
SELECT*FROM orders    

----------Join tabel order_items dengan table products dan events-------------
SELECT
    oi.id,
    oi.user_id,
    oi.product_id,
    oi.status,
    oi.created_at,	
    oi.shipped_at,	
    oi.delivered_at,	
    oi.returned_at,
    p.cost,
    oi.sale_price,
    e.state,
    e.city
FROM
    order_items as oi
INNER JOIN 
    orders as o
ON 
     oi.order_id = o.order_id
INNER JOIN
    products as p
ON
    oi.product_id = p.id
INNER JOIN
    events as e
ON 
    oi.user_id = e.user_id
GROUP BY
    oi.id,
    oi.user_id,
    oi.product_id,
    oi.status,
    oi.created_at,	
    oi.shipped_at,	
    oi.delivered_at,	
    oi.returned_at,
    p.cost,
    oi.sale_price,
    e.state,
    e.city
ORDER BY oi.id;


-----------------------MEMBUAT TABEL REVENUE -----------------------------
SELECT 
    delivered_at,
    state,
    user_id,
    product_id,
    id,
    sum (sale_price - cost) as revenue
FROM 
    sales2
WHERE 
    status = 'Complete'
GROUP BY
    delivered_at,
    user_id,  
    product_id,
    id,
    state
ORDER BY    
    delivered_at ASC;

    
--------------------------------DATA UNTUK FORECASTING TOTAL SALES--------------------------------------------------
SELECT 
    date_trunc('month', created_at),
    sum (num_of_item) as revenue
FROM 
    orders
GROUP BY
    1 
ORDER BY    
    1; 
select * from orders    

-------------------------------DATA UNTUK FORECASTING PREDIKSI REVENUE--------------------------------------------------
SELECT 
    date_trunc('month', cast((case when created_at != 'null' then created_at end) as date)),
    count (id) as total_sales
FROM 
    sales2
WHERE 
    status = 'Complete'
GROUP BY
    1 
ORDER BY    
    1; 
select * from orders    
    
------------------------------DATA JOIN (VISUALISASI TABLEAU)----------------------------------------    
SELECT 
    oi.id ,
    oi.created_at,
    oi.user_id,
    oi.inventory_item_id,
    e.state,
    oi.product_id,
    p.name,
    oi.status,
    oi.sale_price,
    p.cost
FROM 
    order_items as oi
INNER JOIN
    products as p
ON
    oi.product_id = p.id
INNER JOIN
    events as e
ON 
    oi.user_id = e.user_id
GROUP BY
    oi.id,
    oi.created_at,
    e.city,
    e.state,
    oi.user_id,
    oi.product_id,
    p.name,
    oi.sale_price,
    p.cost,
    oi.status
ORDER BY    
    oi.created_at;
