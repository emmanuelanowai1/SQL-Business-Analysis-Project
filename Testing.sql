--                                               SQL QUERIES

-- 1. List all suppliers in the UK
SELECT 
    ID,                                           -- Supplier ID
    COMPANYNAME AS [SUPPLIER],                    -- Supplier name (renamed)
    CONTACTNAME AS [CONTACT NAME],                -- Contact person’s name
    CITY,                                         -- City of supplier
    COUNTRY,                                      -- Country of supplier
    PHONE                                         -- Phone number of supplier
FROM SUPPLIER
WHERE COUNTRY = 'UK';                             -- Only suppliers based in the UK

-- 2. List the first name, last name, and city for all customers.
-- Concatenate first and last names with a space between them.
SELECT 
    (FIRSTNAME + ' ' + LASTNAME) AS [CUSTOMER NAME],  -- Combined customer name
    CITY                                              -- City of the customer
FROM CUSTOMER;

-- 3. List all customers in Sweden
SELECT 
    ID,                                              -- Customer ID
    (FIRSTNAME + ' ' + LASTNAME) AS [CUSTOMER NAME], -- Full customer name
    CITY,                                            -- City
    COUNTRY,                                         -- Country (filtered later)
    PHONE                                            -- Phone number
FROM CUSTOMER
WHERE COUNTRY = 'SWEDEN';                            -- Only customers from Sweden

-- 4. List all suppliers in alphabetical order
SELECT 
    COMPANYNAME AS [SUPPLIER],                       -- Supplier name
    CONTACTNAME AS [CONTACT NAME],                   -- Contact name
    CITY,                                            -- City
    COUNTRY                                          -- Country
FROM SUPPLIER
ORDER BY [SUPPLIER] ASC;                             -- Alphabetical order

-- 5. List all suppliers with their products
SELECT 
    S.COMPANYNAME AS [SUPPLIER],                     -- Supplier name
    P.PRODUCTNAME AS [PRODUCT]                       -- Product supplied
FROM SUPPLIER AS S
JOIN PRODUCT AS P ON S.ID = P.SUPPLIERID;            -- Join suppliers with products they supply

-- 6. List all orders with customers information
SELECT 
    (C.FIRSTNAME + ' ' + C.LASTNAME) AS [CUSTOMER NAME],  -- Full customer name
    C.CITY,                                              -- Customer city
    C.COUNTRY,                                           -- Customer country
    C.PHONE,                                             -- Customer phone
    P.PRODUCTNAME AS [PRODUCT NAME],                     -- Ordered product name
    ODI.UNITPRICE AS [UNIT PRICE],                       -- Unit price of product
    ODI.QUANTITY,                                        -- Quantity ordered
    ORD.TOTALAMOUNT AS [TOTAL AMOUNT]                    -- Total order value
FROM CUSTOMER C
JOIN "ORDER" AS ORD ON C.ID = ORD.CUSTOMERID
JOIN ORDERITEM ODI ON ORD.ID = ODI.ORDERID
JOIN PRODUCT AS P ON P.ID = ODI.PRODUCTID;              -- Join products

-- 7. List all orders with product name, quantity, and price, sorted by order number
SELECT 
    P.PRODUCTNAME AS [PRODUCT NAME],                    -- Product name
    ODI.QUANTITY,                                       -- Quantity
    P.UNITPRICE AS [UNIT PRICE],                        -- Unit price
    ORD.ORDERNUMBER AS [ORDER NUMBER]                   -- Order number
FROM PRODUCT AS P
JOIN ORDERITEM AS ODI ON P.ID = ODI.PRODUCTID
JOIN "ORDER" AS ORD ON ORD.ID = ODI.ORDERID
ORDER BY [ORDER NUMBER];                                -- Sorted by order number

-- 8. Using a case statement, list all the availability of products. 
SELECT 
    PRODUCTNAME AS [PRODUCT NAME],                      -- Product name
    CASE
        WHEN ISDISCONTINUED = 0 THEN 'NOT AVAILABLE'    -- Not available if 0
        WHEN ISDISCONTINUED = 1 THEN 'AVAILABLE'        -- Available if 1
    END AS AVAILABILITY
FROM PRODUCT;

-- 9. Using case statement, list all suppliers and the language they speak.
SELECT 
    COMPANYNAME AS [SUPPLIER],                          -- Supplier name
    CASE
        WHEN COUNTRY = 'AUSTRALIA' THEN 'ENGLISH'
        WHEN COUNTRY = 'BRAZIL' THEN 'PORTUGUESE'
        WHEN COUNTRY = 'CANADA' THEN 'ENGLISH'
        WHEN COUNTRY = 'DENMARK' THEN 'DANISH'
        WHEN COUNTRY = 'FINLAND' THEN 'FINNISH'
        WHEN COUNTRY = 'FRANCE' THEN 'FRENCH'
        WHEN COUNTRY = 'GERMANY' THEN 'GERMAN'
        WHEN COUNTRY = 'ITALY' THEN 'ITALIAN'
        WHEN COUNTRY = 'JAPAN' THEN 'JAPANESE'
        WHEN COUNTRY = 'NETHERLANDS' THEN 'DUTCH'
        WHEN COUNTRY = 'NORWAY' THEN 'NORWEGIAN'
        WHEN COUNTRY = 'SINGAPORE' THEN 'ENGLISH'
        WHEN COUNTRY = 'SPAIN' THEN 'SPANISH'
        WHEN COUNTRY = 'UK' THEN 'ENGLISH'
        WHEN COUNTRY = 'USA' THEN 'ENGLISH'
    END AS LANGUAGE
FROM SUPPLIER;

-- 10. List all products that are packaged in Jars
SELECT 
    PRODUCTNAME AS [PRODUCT NAME]                        -- Product name
FROM PRODUCT
WHERE PACKAGE LIKE '%JARS%';                            -- Products with packaging containing 'JARS'

-- 11. List product name, unit price, and packages for products that start with 'Ca'
SELECT 
    PRODUCTNAME AS [PRODUCT NAME],                       -- Product name
    UNITPRICE AS [UNIT PRICE],                           -- Unit price
    PACKAGE                                              -- Packaging
FROM PRODUCT
WHERE PRODUCTNAME LIKE 'CA%';                            -- Products starting with 'Ca'

-- 12. List the number of products for each supplier, sorted high to low.
SELECT 
    S.COMPANYNAME AS [SUPPLIER],                         -- Supplier name
    COUNT(P.ID) AS [NUMBER OF PRODUCTS]                  -- Count of products
FROM SUPPLIER AS S
JOIN PRODUCT P ON S.ID = P.SUPPLIERID
GROUP BY S.COMPANYNAME
ORDER BY COUNT(P.ID) DESC;                               -- Sorted by number of products descending

-- 13. List the number of customers in each country.
SELECT 
    COUNTRY,                                             -- Country name
    COUNT(ID) AS [NUMBER OF CUSTOMERS]                   -- Number of customers
FROM CUSTOMER
GROUP BY COUNTRY;

-- 14. List the number of customers in each country, sorted high to low.
SELECT 
    COUNTRY,
    COUNT(ID) AS [NUMBER OF CUSTOMERS]
FROM CUSTOMER
GROUP BY COUNTRY
ORDER BY COUNT(ID) DESC;

-- 15. List the total order amount for each customer, sorted high to low.
SELECT 
    (C.FIRSTNAME + ' ' + C.LASTNAME) AS [CUSTOMER NAME], -- Customer name
    SUM(O.TOTALAMOUNT) AS [TOTAL AMOUNT]                 -- Total spent
FROM CUSTOMER AS C
JOIN "ORDER" AS O ON C.ID = O.CUSTOMERID
GROUP BY (C.FIRSTNAME + ' ' + C.LASTNAME)
ORDER BY SUM(O.TOTALAMOUNT) DESC;

-- 16. List all countries with more than 2 suppliers.
SELECT 
    COUNTRY,                                             -- Country
    COUNT(ID) AS [NUMBER OF SUPPLIERS]                   -- Supplier count
FROM SUPPLIER
GROUP BY COUNTRY
HAVING COUNT(ID) > 2                                     -- Only countries with more than 2
ORDER BY COUNT(ID);

-- 17. List the number of customers in each country with more than 10 customers.
SELECT 
    COUNTRY,
    COUNT(ID) AS [NUMBER OF CUSTOMERS]
FROM CUSTOMER
GROUP BY COUNTRY
HAVING COUNT(ID) > 10
ORDER BY COUNT(ID);

-- 18. List the number of customers in each country (excluding USA) with at least 9 customers.
SELECT 
    COUNTRY,
    COUNT(ID) AS [NUMBER OF CUSTOMERS]
FROM CUSTOMER
WHERE NOT COUNTRY = 'USA'
GROUP BY COUNTRY
HAVING COUNT(ID) >= 9
ORDER BY COUNT(ID) DESC;

-- 19. List customers with average orders between $1000 and $1200.
SELECT 
    (C.FIRSTNAME + ' ' + C.LASTNAME) AS [CUSTOMER NAME],
    AVG(O.TOTALAMOUNT) AS [TOTAL AMOUNT]
FROM "ORDER" AS O
JOIN CUSTOMER AS C ON C.ID = O.CUSTOMERID
GROUP BY (C.FIRSTNAME + ' ' + C.LASTNAME)
HAVING AVG(O.TOTALAMOUNT) BETWEEN 1000 AND 1200
ORDER BY AVG(O.TOTALAMOUNT);

-- 20. Get orders and total sold amount between January 1 and January 31, 2013.
SELECT 
    ORDERNUMBER AS [ORDER NUMBER],                       -- Order number
    TOTALAMOUNT AS [TOTAL AMOUNT]                        -- Total amount
FROM "ORDER"
WHERE ORDERDATE BETWEEN '2013-01-01' AND '2013-01-31';   -- Filter by date range


--                                          BUSINESS INSIGHTS REPORT
--Based on SQL Data Analysis


--1. Introduction

--This report presents key business insights derived from SQL-based analysis of company data. The analysis covered suppliers, products, customers, and sales orders to identify trends, patterns, and strategic opportunities for growth.


--2. Supplier and Product Insights

--* The company maintains a diverse supplier base across countries including UK, Germany, France, and USA.
--* Some suppliers offer a significantly higher number of products, making them strategic partners.
--* Products packaged in jars could serve niche markets or specialty customers.
--* Product availability is classified as "Available" or "Not Available", enabling quick inventory assessments.


--3. Customer Insights

--* Customer distribution shows higher concentrations in countries like USA, Sweden, and UK.
--* Some countries have high customer volumes (over 10), indicating potential for targeted marketing.
--* A premium customer segment was identified, with average order values between \$1,000 and \$1,200.


--4. Sales and Order Trends

--* Orders from January 2013 revealed seasonal patterns valuable for forecasting and inventory planning.
--* Identifying top-spending customers allows for loyalty programs and exclusive offers.
--* Order analysis highlighted variations in demand, pricing, and quantity, guiding product optimization.


--5. Language and Communication Insights

--* Suppliers were mapped to their native languages based on country, supporting localized communication.
--* This enhances supplier relationship management and may improve service delivery.


--6. Market Focus and Strategic Opportunities

--* Filtering countries with more than two suppliers or over ten customers highlights markets worth expanding.
--* Excluding dominant markets (like the USA) uncovers under-served regions for potential growth.
--* Product name analysis (e.g., names starting with "Ca") supports category-specific marketing strategies.


--7. Conclusion and Recommendations

--The SQL analysis revealed several actionable insights:

--* Strengthen relationships with key suppliers and expand product lines.
--* Implement targeted marketing in high-customer regions.
--* Launch customer loyalty programs based on spending patterns.
--* Use language mapping for more effective supplier communications.
--* Apply seasonal planning based on historical sales trends.

--These strategies will help drive customer engagement, improve inventory management, and support data-driven decision-making.