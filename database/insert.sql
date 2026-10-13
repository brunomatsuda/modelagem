INSTALL spatial;
LOAD spatial;

INSERT INTO dim_customer (
    customer_id_id, 
    customer_id, 
    customer_age, 
    customer_gender, 
    customer_rating, 
    customer_segment, 
    loyalty_member
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_id_id,
    customer_id, 
    customer_age, 
    customer_gender, 
    customer_rating, 
    customer_segment, 
    loyalty_member
FROM read_xlsx('C:\Users\Matsuda\data_modeling\data\raw\bakery_synthetic_dataset.csv (1).xlsx');