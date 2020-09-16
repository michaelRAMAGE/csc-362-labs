
/* Create the database, if it does not already exist */
DROP DATABASE IF EXISTS  carpets;
CREATE DATABASE carpets;
USE carpets;

/* CREATE TABLES  */

-- Table for our Customers
CREATE TABLE Customers (
    PRIMARY KEY (customer_id),
    customer_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    street VARCHAR(46) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zipcode CHAR(5) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL
);

-- Table for Rugs we have
CREATE TABLE Rugs (
    PRIMARY KEY (inventory_id),
    inventory_id INT AUTO_INCREMENT NOT NULL,
    descript VARCHAR(100) NOT NULL,
    purchase_price DECIMAL NOT NULL,
    list_price DECIMAL NOT NULL, 
    date_acquired DATE NOT NULL
);

-- Table for purchases customers make
CREATE TABLE Customer_Purchases (
    PRIMARY KEY (purchase_id),
    purchase_id INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    inventory_id INT NOT NULL ,
    FOREIGN KEY (customer_id)
        REFERENCES  Customers(customer_id) ON DELETE NO ACTION,
    FOREIGN KEY (inventory_id)
        REFERENCES Rugs (inventory_id),
    sale_date DATE NOT NULL,
    purchase_return_date DATE DEFAULT NULL
        CHECK (purchase_return_date >= sale_date),
    sale_price DECIMAL NOT NULL
);

-- Table for trials that customers partake in
CREATE TABLE Customer_Trials (
    PRIMARY KEY (trial_id),
    trial_id INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    inventory_id INT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES  Customers(customer_id) ON DELETE NO ACTION,
    FOREIGN KEY (inventory_id)
        REFERENCES Rugs (inventory_id),
    reserve_from DATE NOT NULL,
    reserve_to DATE NOT NULL 
        CHECK (reserve_to >= reserve_from),
    trial_return_date DATE DEFAULT NULL 
        CHECK (trial_return_date >= reserve_from)
);


/* TRIGGERS */

-- THIS IS CORRECT LOGIC AND FOLLOWS
-- guidelines on implementing triggers,
-- but it seems that this results in
-- sql server crashing, which is not usual
-- and might even be a bug in this version.

-- DROP TRIGGER IF EXISTS max_trial; 

-- DELIMITER |
-- CREATE TRIGGER max_trial
-- BEFORE INSERT ON Customer_Trials
-- FOR EACH ROW
-- BEGIN 
--     DECLARE dummy INT DEFAULT 0; 
--     IF NOT (SELECT customer_id 
--         FROM Active_Customers
--         WHERE NEW.customer_id = customer_id)
--     THEN -- send signal to halt insert, otherwise insert as usual
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have maxed out on trials you can redeem';
--     END IF;
-- END |
-- DELIMITER ;



/* VIEWS */
-- Find trials per customer
---- This is used to determine if a user can use another trial
CREATE VIEW Agg_Customer_Trials AS 
    SELECT Customer_Trials.customer_id
        FROM Customer_Trials
        GROUP BY Customer_Trials.customer_id
        HAVING COUNT(Customer_Trials.customer_id) = 4;

-- Outputs customers that have been active in the past year. 
CREATE VIEW Active_Customers AS 
    SELECT DISTINCT Customer_Trials.customer_id
        FROM Customers
        INNER JOIN Customer_Purchases
            ON Customers.customer_id = Customer_Purchases.customer_id
        INNER JOIN Customer_Trials
            ON Customers.customer_id = Customer_Trials.customer_id
        WHERE DATEDIFF(CURDATE(), Customer_Purchases.sale_date) <= 365 ||
              DATEDIFF(CURDATE(), Customer_Trials.reserve_from) <= 365; 

-- Outputs rugs that have been in the inventory for two years or more 
CREATE VIEW OldRugs AS 
    SELECT Rugs.inventory_id as inventory_id, Rugs.date_acquired as date_acquired
        FROM Rugs
        WHERE DATEDIFF(CURDATE(), date_acquired) >= 730;

-- Outputs rugs that a customer can buy or try
---- Returned if purchased, never purchased, and not on trial
---- 5 columns are displayed
------ 1) inventory_id pk, 
------ 2-3) existence of inventory_id as pk in trial and purchases
------ 4-5) If exist, return dates to indicate still in inventory
---- TESTING: Rugs 4,10 returned, correct!
CREATE VIEW Available_Rugs AS
    SELECT DISTINCT Rugs.inventory_id as pk_inventory,
         Customer_Trials.inventory_id as tr_fk_inventory,
         Customer_Purchases.inventory_id as pch_fk_inventory,
         Customer_Trials.trial_return_date,
         Customer_Purchases.purchase_return_date
        FROM Rugs
        LEFT JOIN Customer_Purchases
            ON Rugs.inventory_id = Customer_Purchases.inventory_id
        LEFT JOIN Customer_Trials
            ON Rugs.inventory_id = Customer_Trials.inventory_id
        WHERE ((Customer_Trials.inventory_id IS NULL 
              && Customer_Purchases.inventory_id IS NULL) || 
              (Customer_Trials.trial_return_date IS NOT NULL &&
              Customer_Purchases.purchase_return_date IS NOT NULL));

-- Rugs that have never been sold (and perhaps returned) or loaned
---- These rugs can be deleted from Rugs table
---- TESTING: For test data, returns inventory_id = 4, which is correct. 
---- % Setting != in ON clause gives weird result. Can we use this for set exclusion?
CREATE VIEW Stagnate_Rugs AS
    SELECT DISTINCT Rugs.inventory_id as pk_inventory,
           Customer_Trials.inventory_id as trfk_inventory,
           Customer_Purchases.inventory_id as pchfk_inventory
        FROM Rugs
        LEFT JOIN Customer_Purchases
            ON Rugs.inventory_id = Customer_Purchases.inventory_id
        LEFT JOIN Customer_Trials
            ON Rugs.inventory_id = Customer_Trials.inventory_id
        WHERE Customer_Trials.inventory_id IS NULL 
            && Customer_Purchases.inventory_id IS NULL;

/* Procedures */
DELIMITER //
CREATE PROCEDURE 
    `INSERT_TRIAL`( -- inputs 
        IN _customer_id INT, 
        IN _inventory_id INT, 
        IN _reserve_from DATE, 
        IN _reserve_to DATE, 
        IN _trial_return_date DATE
    )
    BEGIN 
        DECLARE err_mssg CHAR(50); -- local variable
        IF (SELECT COUNT(customer_id) FROM Agg_Customer_Trials WHERE customer_id = _customer_id)<=0 THEN    
            INSERT INTO Customer_Trials(customer_id, 
                                        inventory_id, 
                                        reserve_from, 
                                        reserve_to, 
                                        trial_return_date) 
            VALUES (_customer_id,_inventory_id,_reserve_from,
                    _reserve_to,_trial_return_date);        
        ELSE
            SET err_mssg = 'Customer already has 4 trials';
            SELECT @err_mssg; -- select is almost like return in sql. 
                              -- when calling from application, all select
                              -- statements are returned to application call,
                              -- atleast in nodejs framework. 
        END IF;  
    END; //
DELIMITER ; 


/* INSERT TEST DATA */
/* NOTE: SOME OF THE DATA IS EXPLAINED IN 'test_date.txt' */ 
INSERT INTO Rugs(inventory_id, descript, purchase_price, date_acquired, list_price)
VALUES 
    (1,'ghana x 2007 20x10 cotton',10000,"2018-10-09",20000),
    (2,'china hanfu 2007 15x15 silk',20000,"2020-10-09",40000),
    (3,'unitedstates z 2007 20x50 cotton',100,"2015-10-09",400),
    (4,'kazahkastan a 2004 15x5 cotton',213000,"2007-10-09",413000), -- rug never interacted with
    (5,'russia b 2007 20x10 wool',5000,"2010-10-09",10000),
    (6,'neverneverland c 2010 8x10 chocolate',102033,"2020-10-09",2000000),
    (7,'france eiffel 2008 20x10 wool',5000,"2012-10-09",10000),
    (8,'nepal everest 2009 8x10 silk',102033,"2015-10-09",2000001),
    (9,'germany zombie 2013 20x10 leather',5000,"2014-10-09",10000),
    (10,'wonderland zombie 1962 200x220 leather',5000,"2013-10-08",100000); -- never 

INSERT INTO Customers(customer_id, first_name, last_name, street, city, state, zipcode, phone_number) 
VALUES 
    (1,"Laura","Ortiz","1144  Quiet Valley Lane", "Irvine","CA","92614","818-939-6333"),
    (2,"Nell","Steven","2561  Kelley Road", "Gulfport","MS","39501","228-378-1359"),
    (3,"Donna","Frank","1415  Washington Avenue","Phoenix","AZ","85012","602-221-6555"),
    (4,"Shawn","Browning","4105  Davisson Street", "MANCHESTER CENTER","VT","05255","765-969-4882"),
    (5,"Frank","Ortiz","1144  Quiet Valley Lane", "Irvine","CA","92614","818-939-6322");

INSERT INTO Customer_Purchases(customer_id, inventory_id, sale_date, sale_price, purchase_return_date)
VALUES 
    (1,1,"2018/9/09",9000,null),
    (2,3,"2019/6/05",400,null), 
    (3,5,"2019/9/09",10000,"2019/9/15"), -- returned purchase, but 
                                         -- bought later following on user 2 trial
    (3,6,"2019/7/20",2000000,null),
    (2,2,"2020/9/11",40000,null),
    (2,5,"2019-9-18",10000,null), -- purchased during/after trial
    (2,2,"2020-9-12",40000,null); -- purchased during/after trial

INSERT INTO Customer_Trials(customer_id, inventory_id, reserve_from, reserve_to, trial_return_date) 
VALUES 
    (2,5,"2019-9-16","2019-9-18",null), -- purchased a rug on trial 
                                        -- that someone previously purchased 
                                        -- then returned
    (3,3,"2019-6-10","2019-6-12","2019-6-12"),
    (4,3,"2019-6-12","2019-6-14","2019-6-14"),
    (5,3,"2019-6-07","2019-6-09","2019-6-09"),
    (5,7,"2019-6-08","2019-6-09","2019-6-09"),
    (5,8,"2019-6-06","2019-6-10","2019-6-10"),
    (5,9,"2019-6-07","2019-6-09","2019-6-09"),
    (2,2,"2020-9-10","2020-9-12",null); -- purchased


-- The below call will check if a customer trial exists,
-- if not, then an error is returned, which would be 
-- returned to the call from the application program
CALL INSERT_TRIAL(5,10,"2019-6-08","2019-6-09","2019-6-09");