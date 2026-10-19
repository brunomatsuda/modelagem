-- CUSTOMER
INSERT INTO dim_customer (customer_id_id, customer_id, customer_age, customer_gender, customer_rating, customer_segment, loyalty_member) SELECT
ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_id_id,
customer_id,
customer_age,
customer_gender,
customer_rating,
customer_segment,
loyalty_member 
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- EMPLOYEE
INSERT INTO dim_employee (employee_id, employee_code) SELECT
ROW_NUMBER() OVER (ORDER BY employee_id),
employee_id 
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- PAYMENT
INSERT INTO dim_payment (payment_id, payment_method) SELECT
ROW_NUMBER() OVER (ORDER BY "Payment_Method"),
"Payment_Method"
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

--PRODUCT
INSERT INTO dim_product (product_id, product, category, unit_price, shelf_life_days) SELECT
ROW_NUMBER() OVER (ORDER BY product),
product,
category,
unit_price,
shelf_life_days
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- CLIMA
INSERT INTO dim_weather (weather_id, weather, temperature, season) SELECT
ROW_NUMBER() OVER (ORDER BY weather),
weather,
temperature,
season
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- DATA and SCHEDULE
INSERT INTO dim_data (schedule_date, date_sold, day_of_week, weekend, festival) SELECT
ROW_NUMBER() OVER (ORDER BY "date") AS schedule_,
"date",
day_of_week,
weekend,
festival
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- DUE DATE
INSERT INTO dim_due_date (due_date_id, manufacturing_date, due_date, expiry_risk) SELECT
ROW_NUMBER() OVER (ORDER BY manufacturing_date) AS due_date_id,
manufacturing_date,
expiry_date,
expiry_risk
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

--INVENTORY
INSERT INTO dim_inventory (inventory_id, unit_produced, unit_sold, unsold_units, stock_available, store_id, recommended_product) SELECT
ROW_NUMBER() OVER (ORDER BY "Product"),
units_produced,
units_sold,
unsold_units,
stock_available,
store_id,
recommended_product
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- Promotion
INSERT INTO dim_promotion (promotion_id, Discount_Percentage, Discount_Amount, promotion_applied, promotion_type, promotion_score, recommended_discount) SELECT
ROW_NUMBER() OVER (ORDER BY "Product"),
Discount_Percentage,
Discount_Amount,
promotion_applied,
promotion_type,
promotion_score,
recommended_discount
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');

-- TRANSACTION
-- Exemplo de insert fazendo o match correto com os nomes das colunas da planilha e das dimensões:
-- TRANSACTION
INSERT INTO fact_transaction (
    transaction_id, 
    customer_id, 
    employee_id, 
    payment_id, 
    product_id, 
    weather_id,
    schedule_date,
    due_date_id,
    promotion_id,
    quantity,
    selling_price,
    total_bill,
    profit,
    waste_cost
) 
SELECT
    r."Transaction_ID", 
    c.customer_id_id,         -- Conectando com a PK gerada na dimensão de clientes
    e.employee_id,            -- Conectando com a PK gerada na dimensão de funcionários
    p.payment_id,             -- Conectando com a PK gerada na dimensão de pagamentos
    pr.product_id,            -- Conectando com a PK gerada na dimensão de produtos
    w.weather_id,             -- Exemplo fazendo join com clima (caso venha texto)
    d.schedule_date,          -- Exemplo fazendo join com data
    dd.due_date_id,           -- Exemplo fazendo join com due_date
    prm.promotion_id,         -- Exemplo fazendo join com promotion
    r."Quantity",
    r."Selling_Price",
    r."Total_Bill",
    r."Profit",
    r."Waste_Cost"
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx') r
LEFT JOIN dim_customer c ON r."Customer_ID" = c.customer_id
LEFT JOIN dim_employee e ON r."Employee_ID" = e.employee_code
LEFT JOIN dim_payment p ON r."Payment_Method" = p.payment_method
LEFT JOIN dim_product pr ON r."Product" = pr.product
LEFT JOIN dim_weather w ON r."Weather" = w.weather
LEFT JOIN dim_data d ON r."Date" = d.date_sold
LEFT JOIN dim_due_date dd ON r."Manufacturing_Date" = dd.manufacturing_date
LEFT JOIN dim_promotion prm ON r."Promotion_Type" = prm.promotion_type;