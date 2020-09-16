CREATE PROCEDURE 
    `INSERT_TRIAL`(
        IN _customer_id INT, 
        IN _inventory_id INT, 
        IN _reserve_from DATE, 
        IN _reserve_to DATE, 
        IN _trial_return_date DATE
    )
    BEGIN 
        SELECT Agg_Customer_Trials.customer_id 
        FROM  Agg_Customer_Trials
        WHERE Agg_Customer_Trials.customer_id = _customer_id; 
    END