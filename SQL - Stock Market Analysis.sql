DROP SCHEMA IF EXISTS Assignment;

-- Let's create a new schema 'Assignment' and use the same
CREATE SCHEMA Assignment;
USE Assignment;

SET SQL_SAFE_UPDATES = 0;

-- The data is imported using the Table data import wizard by their initial stock names
-- Only data required for analysis is imported (i.e. Date and Close Price column)


-- CHANGING THE DATETIME FORMAT INTO DATE FORMAT OF ALL IMPORTED TABLES FOLLOWED BY ORDERING BY DATES IN ASCENDING ORDER

# For bajaj auto

ALTER TABLE `bajaj auto`
CHANGE `Date` `Date` DATE;

ALTER TABLE `bajaj auto` ORDER BY DATE;

# For eicher motors

ALTER TABLE `eicher motors`
CHANGE `Date` `Date` DATE;

ALTER TABLE `bajaj auto` ORDER BY DATE;

# For hero motocorp

ALTER TABLE `hero motocorp`
CHANGE `Date` `Date` DATE;

ALTER TABLE `hero motocorp` ORDER BY DATE;

# For infosys

ALTER TABLE infosys
CHANGE `Date` `Date` DATE;

ALTER TABLE infosys ORDER BY DATE;

# For TCS

ALTER TABLE tcs
CHANGE `Date` `Date` DATE;

ALTER TABLE tcs ORDER BY DATE;

# For TVS motors

ALTER TABLE `tvs motors`
CHANGE `Date` `Date` DATE;

ALTER TABLE `tvs motors` ORDER BY DATE;

------------------------------------------------------------------------------------------------------
# TASK 1
-- Let's create new tables for all stocks to get the Moving Averages of 20 and 50 days respectively.
-- Let's use AVERAGE function for calculating the moving averages and rounding upto 2 decimals

# Creating Bajaj1 table

CREATE TABLE bajaj1 AS (
    SELECT Date, `Close Price`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM `bajaj auto`
);

SELECT 
    *
FROM
    BAJAJ1;

# Creating eicher1 table

CREATE TABLE eicher1 AS (
    SELECT Date, `Close Price`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM `eicher motors`
    
);

# Creating hero1 table

CREATE TABLE hero1 AS (
    SELECT Date, `Close Price`,
	ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM `hero motocorp`    
);

# Creating infosys1 table

CREATE TABLE infosys1 AS (
    SELECT Date, `Close Price`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM infosys    
);

# Creating tcs1 table

CREATE TABLE tcs1 AS (
    SELECT Date, `Close Price`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM tcs    
);

# Creating tvs1 table

CREATE TABLE tvs1 AS (
    SELECT Date, `Close Price`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 19 PRECEDING AND CURRENT ROW),2) AS `20 Day MA`,
    ROUND(AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW),2) AS `50 Day MA`
    FROM `tvs motors`    
);

---------------------------------------------------------------------------------------------------------------------------------
-- TASK 2
-- Let's create a master table to contain all the close prices of stocks in single table

# Creating master table

CREATE TABLE `Master` AS (SELECT bajaj1.Date AS DATE,
    bajaj1.`Close Price` AS Bajaj,
    TCS1.`Close Price` AS TCS,
    TVS1.`Close Price` AS TVS,
    Infosys1.`Close Price` AS Infosys,
    Eicher1.`Close Price` AS Eicher,
    hero1.`Close Price` AS Hero FROM
    bajaj1
        INNER JOIN
    eicher1 ON bajaj1.Date = eicher1.Date
        INNER JOIN
    hero1 ON eicher1.Date = hero1.Date
        INNER JOIN
    infosys1 ON hero1.Date = infosys1.Date
        INNER JOIN
    tcs1 ON infosys1.Date = tcs1.Date
        INNER JOIN
    tvs1 ON tcs1.Date = tvs1.Date
ORDER BY bajaj1.Date);

------------------------------------------------------------------------------------------------------------------------------
-- TASK 3
-- By using the moving averages we will now create a signal to determine if we have to HOLD, BUY or SELL the stock w.r.t. Date
-- We will be using the same tables created in Task 1 for creating the table with signals

# Creating bajaj2 table

CREATE TABLE bajaj2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM bajaj1
    WINDOW W AS (ORDER BY DATE)
);

SELECT 
    *
FROM
    bajaj2;


# Creating eicher2 table

CREATE TABLE eicher2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM eicher1
    WINDOW W AS (ORDER BY DATE)
);

# Creating hero2 table

CREATE TABLE hero2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM hero1
    WINDOW W AS (ORDER BY DATE)
);

# Creating infosys2 table

CREATE TABLE infosys2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM infosys1
    WINDOW W AS (ORDER BY DATE)
);

# Creating tcs2 table

CREATE TABLE tcs2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM tcs1
    WINDOW W AS (ORDER BY DATE)
);

# Creating tvs2 table

CREATE TABLE tvs2 AS (
    SELECT Date, `Close Price`,
    CASE
        WHEN ((`20 Day MA` - `50 Day MA`) < 0) AND (LEAD(`20 Day MA` - `50 DAY MA`,1) OVER W > 0) THEN 'BUY'
        WHEN ((`20 Day MA` - `50 Day MA`) > 0) AND (LEAD(`20 Day MA`- `50 DAY MA`,1) OVER W < 0) THEN 'SELL'
        ELSE 'HOLD'
	END
    AS `Signal`
    FROM tvs1
    WINDOW W AS (ORDER BY DATE)
);

---------------------------------------------------------------------------------------------------------------------------------------------
-- TASK 4
-- Let's create a user defined function that will take Date as input and will return the respective signal for that particular date 
-- only for BAJAJ stock

# Creating the function

DELIMITER $$
CREATE FUNCTION GENERATING_SIGNAL(input_date DATE)
	RETURNS VARCHAR(10) 
    DETERMINISTIC
BEGIN 
	RETURN (SELECT `SIGNAL` FROM bajaj2 WHERE input_date = DATE);
END $$
DELIMITER ;

SELECT GENERATING_SIGNAL('2015-05-18');

														
                                                        # THE END
-- -------------------------------------------------------------------------------------------------------------------------------------------------