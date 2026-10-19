--INSTALL spatial;
--LOAD spatial;

--ATTACH 'C:/Users/Matsuda/data_modeling/data/meu_banco.duckdb' AS store;
--USE store;
select * from read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx') limit 10;

-- CUSTOMER
CREATE OR REPLACE TABLE dim_customer  (
    customer_id_id INT PRIMARY KEY,
    customer_id varchar(10),
    customer_age INT,
    customer_gender VARCHAR(10),
    customer_rating INT,
    customer_segment VARCHAR(20),
    loyalty_member VARCHAR(5)
);

-- Employee
CREATE OR REPLACE TABLE dim_employee(
    employee_id INT PRIMARY KEY,
    employee_code VARCHAR(10)
);

-- PAYMENT
CREATE OR REPLACE TABLE dim_payment ( 
    payment_id int PRIMARY KEY,
    payment_method VARCHAR(20)
);

-- PRODUCT
CREATE OR REPLACE TABLE dim_product (
        product_id INT PRIMARY KEY,
        product VARCHAR(100),
        category VARCHAR(50),
        unit_price DECIMAL(10, 2),
        shelf_life_days INT
);
-- CLIMA
CREATE OR REPLACE TABLE dim_weather (
    weather_id INT PRIMARY KEY,
    weather varchar(10),
    temperature decimal(5, 2),
    season varchar(10)
);
-- DATA and SCHEDULE
CREATE OR REPLACE TABLE dim_data (
    schedule_date INT PRIMARY KEY,
    date_sold DATETIME,
    day_of_week VARCHAR(10),
    weekend BOOLEAN,
    festival varchar(15)
);
-- DUE DATE
CREATE OR REPLACE TABLE dim_due_date (
    due_date_id INT PRIMARY KEY,
    manufacturing_date DATETIME,
    due_date DATETIME, -- expiry_date
    expiry_risk varchar(10)
);
-- Inventory
CREATE OR REPLACE TABLE dim_inventory (
    inventory_id INT PRIMARY KEY,
    unit_produced INT,
    unit_sold INT,
    unsold_units INT,
    stock_available INT,
    store_id varchar(10),
    recommended_product VARCHAR(100)
);
-- Promotion
CREATE OR REPLACE TABLE dim_promotion (
    promotion_id INT PRIMARY KEY,
    Discount_Percentage DECIMAL(5, 2),
    Discount_Amount DECIMAL(10, 2),
    promotion_applied BOOLEAN,
    promotion_type VARCHAR(20),
    promotion_score DECIMAL(5, 2),
    recommended_discount DECIMAL(5, 2)
);

-- Transaction
CREATE OR REPLACE TABLE fact_transaction (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id INT REFERENCES dim_customer(customer_id_id),
    employee_id INT REFERENCES dim_employee(employee_id),
    payment_id INT REFERENCES dim_payment(payment_id),
    product_id INT REFERENCES dim_product(product_id),
    weather_id INT REFERENCES dim_weather(weather_id),
    schedule_date INT REFERENCES dim_data(schedule_date),
    due_date_id INT REFERENCES dim_due_date(due_date_id),
    promotion_id INT REFERENCES dim_promotion(promotion_id),
    quantity INT,
    selling_price DECIMAL(10, 2),
    total_bill DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    waste_cost DECIMAL(10, 2)
);
