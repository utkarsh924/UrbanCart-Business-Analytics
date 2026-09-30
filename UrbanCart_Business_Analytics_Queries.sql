USE urbancart_db;

-- Q1. What is the overall financial performance of the business?
-- Calculate Total Net Sales, Total Net Profit and Overall Profit Margin.

SELECT
    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN (Quantity * Unit_Price) - Discount
            ELSE 0
        END
    ), 2) AS Total_Net_Sales,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN ((Quantity * Unit_Price) - Discount)
                 - (Quantity * Product_Cost)
            ELSE 0
        END
    ), 2) AS Total_Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status <> 'Cancelled'
                    THEN (Quantity * Unit_Price) - Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent
FROM Orders;

-- BUSINESS INSIGHT:
-- UrbanCart generated ₹68.61 lakh in net sales and ₹16.34 lakh
-- in product profit, resulting in an overall profit margin of 23.81%.










-- Q2. How are sales and profit performing month by month?
-- Calculate monthly Net Sales, Net Profit and Profit Margin
-- to identify strong and weak performance periods.

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN (Quantity * Unit_Price) - Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN ((Quantity * Unit_Price) - Discount)
                 - (Quantity * Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status <> 'Cancelled'
                    THEN (Quantity * Unit_Price) - Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month;

-- BUSINESS INSIGHT:
-- Monthly performance shows noticeable fluctuations in sales and profit.
-- June 2025 recorded the highest monthly sales at ₹4.25 lakh
-- and profit of ₹1.02 lakh. Profit margins ranged from 17.90%
-- to 26.37%, indicating that monthly profitability varies significantly.
-- Management should monitor demand patterns and margin changes
-- to improve consistency in monthly performance.










-- Q3. Which product categories are generating the most sales and profit?
-- Calculate Net Sales, Net Profit and Profit Margin for each category
-- to identify the strongest and weakest performing categories.

SELECT
    p.Category,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID

GROUP BY p.Category
ORDER BY Net_Sales DESC;

-- BUSINESS INSIGHT:
-- Electronics is the strongest category by both Net Sales (₹15.25 lakh)
-- and Net Profit (₹4.17 lakh). Beauty & Personal Care has the highest
-- Profit Margin at 27.47%. Fashion has the lowest margin at 19.01%,
-- despite generating ₹13.85 lakh in Net Sales. Management should
-- protect high-profit categories while reviewing pricing, discounts
-- and costs in lower-margin categories.












-- Q4. Which marketing channels are generating the most sales and profit?
-- Calculate Net Sales, Net Profit and Profit Margin for each marketing channel
-- to identify the strongest and weakest performing acquisition channels.

SELECT
    Marketing_Channel,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN (Quantity * Unit_Price) - Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN ((Quantity * Unit_Price) - Discount)
                 - (Quantity * Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status <> 'Cancelled'
                    THEN (Quantity * Unit_Price) - Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders

GROUP BY Marketing_Channel
ORDER BY Net_Sales DESC;

-- BUSINESS INSIGHT:
-- Organic is the strongest marketing channel by both Net Sales
-- (₹20.50 lakh) and Net Profit (₹5.07 lakh), with a 24.76% margin.
-- Google Ads is the second-largest contributor with ₹13.65 lakh
-- in Net Sales and ₹3.26 lakh in Net Profit. Instagram has the
-- lowest Profit Margin at 21.99%, indicating an opportunity to
-- review its acquisition efficiency and associated costs.











-- Q5. Which products are generating the highest sales and profit?
-- Identify the Top 10 products by Net Sales and compare their
-- Net Sales, Net Profit and Profit Margin to understand
-- whether high-selling products are also highly profitable.

SELECT
    p.Product_Name,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID

GROUP BY p.Product_ID, p.Product_Name

ORDER BY Net_Sales DESC
LIMIT 10;

-- BUSINESS INSIGHT:
-- Power Bank is the highest-selling product with ₹4.20 lakh in Net Sales
-- and ₹1.40 lakh in Net Profit. Smartphone has the highest Profit Margin
-- among the Top 10 products at 38.64%, followed by Bedsheet at 35.65%.
-- In contrast, Sneakers and Jacket have relatively low margins of 13.34%
-- and 14.34%. This shows that high sales volume does not always result
-- in high profitability, so product decisions should consider both
-- profit contribution and margin.











-- Q6. What are the major reasons for product returns and how much
-- refund value is associated with each return reason?
-- Calculate Return Count and Total Refund Amount by Return Reason
-- to identify the major sources of return-related financial impact.

SELECT
    Return_Reason,

    COUNT(*) AS Return_Count,

    ROUND(SUM(Refund_Amount), 2) AS Total_Refund_Amount

FROM Returns

GROUP BY Return_Reason

ORDER BY Total_Refund_Amount DESC;

-- BUSINESS INSIGHT:
-- Size/Fit Issue has the highest refund impact at ₹1.81 lakh,
-- while Damaged Product has the highest return count with 49 returns
-- and ₹1.79 lakh in refunds. Quality Issue also contributes a significant
-- ₹1.55 lakh in refunds. Size/Fit and Damaged Product together account
-- for approximately ₹3.61 lakh in refunds, indicating key areas for
-- return reduction and operational improvement.












-- Q7. How do New and Returning customers compare in terms of
-- Net Sales, Net Profit and Profit Margin?
-- Identify which customer type contributes more to overall business performance.

SELECT
    c.Customer_Type,

    COUNT(DISTINCT o.Customer_ID) AS Customer_Count,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID

GROUP BY c.Customer_Type
ORDER BY Net_Sales DESC;

-- BUSINESS INSIGHT:
-- Returning customers generated ₹40.26 lakh in Net Sales and
-- ₹9.69 lakh in Net Profit, compared with ₹28.36 lakh in Net Sales
-- and ₹6.65 lakh in Net Profit from New customers. Returning
-- customers also recorded a slightly higher Profit Margin of 24.06%
-- versus 23.46% for New customers, highlighting the importance
-- of customer retention for revenue and profitability.













-- Q8. Which payment methods are contributing the most to sales and profit?
-- Calculate Order Count, Net Sales, Net Profit and Profit Margin
-- for each payment method to compare payment-method performance.

SELECT
    Payment_Method,

    COUNT(*) AS Order_Count,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN (Quantity * Unit_Price) - Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN Order_Status <> 'Cancelled'
            THEN ((Quantity * Unit_Price) - Discount)
                 - (Quantity * Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status <> 'Cancelled'
                    THEN (Quantity * Unit_Price) - Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders

GROUP BY Payment_Method
ORDER BY Net_Sales DESC;

-- BUSINESS INSIGHT:
-- UPI is the largest payment method with 840 orders, ₹22.64 lakh
-- in Net Sales and ₹5.58 lakh in Net Profit. Credit Card follows
-- with ₹17.62 lakh in Net Sales and ₹4.25 lakh in Net Profit.
-- UPI also records the highest Profit Margin at 24.66%, while
-- Cash on Delivery has the lowest margin at 22.68%. Payment-method
-- performance can help management understand customer payment
-- preferences and associated profitability.














-- Q9. What is the current delivery performance of UrbanCart?
-- Calculate the number and percentage of orders by delivery status
-- to identify the proportion of Delivered, Delayed and Cancelled orders.

SELECT
    Delivery_Status,

    COUNT(*) AS Order_Count,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS Order_Percentage

FROM Delivery

GROUP BY Delivery_Status
ORDER BY Order_Count DESC;

-- BUSINESS INSIGHT:
-- 1,306 orders (52.24%) are marked as Delivered, while 722 orders
-- (28.88%) are Delayed and 472 orders (18.88%) are Cancelled.
-- The high proportion of delayed and cancelled orders indicates
-- that delivery operations represent an important area for
-- management attention and further investigation.











-- Q10. Which customers generate the highest Net Sales and Net Profit?
-- Identify the Top 10 customers by Net Sales and compare their
-- sales, profit and profit margin to understand high-value customers.

SELECT
    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS Order_Count,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID

GROUP BY c.Customer_ID, c.Customer_Name

ORDER BY Net_Sales DESC
LIMIT 10;

-- BUSINESS INSIGHT:
-- Aman Mishra is the highest-value customer by Net Sales at ₹53,209.40
-- across 9 orders. Nandini Shah generated the highest Net Profit
-- among the Top 10 customers at ₹14,724.80 with a 37.92% margin,
-- while Arjun Sharma recorded a 34.48% margin. The highest-sales
-- customer does not necessarily have the highest profitability,
-- so customer value should be assessed using both revenue and profit.













-- Q11. Which products generate high Net Sales but have relatively low Profit Margins?
-- Identify products with strong sales performance but weak margins
-- to find potential pricing, discount or cost-optimization opportunities.

SELECT
    p.Product_Name,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID

GROUP BY p.Product_ID, p.Product_Name

HAVING Net_Sales >= 100000
   AND Profit_Margin_Percent < 20

ORDER BY Net_Sales DESC;

-- BUSINESS INSIGHT:
-- Sneakers generated ₹1.77 lakh in Net Sales but had only a 13.34%
-- Profit Margin. Running Shoes, Dumbbells and Headphones also generated
-- more than ₹1 lakh in Net Sales while maintaining margins close to 10%.
-- The two Jacket product records also showed low margins of 14.34%
-- and 12.23%. These products should be reviewed for pricing, discount
-- levels and product-cost optimization.














-- Q12. How severe are delivery delays and which delivery partners
-- are associated with the highest average delays?
-- Calculate delayed order count and average delay days by
-- delivery partner to identify operational improvement areas.

SELECT
    Delivery_Partner,

    COUNT(*) AS Delayed_Order_Count,

    ROUND(
        AVG(
            DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)
        ), 2
    ) AS Average_Delay_Days

FROM Delivery

WHERE Delivery_Status = 'Delayed'
  AND Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL

GROUP BY Delivery_Partner

ORDER BY Average_Delay_Days DESC;

-- BUSINESS INSIGHT:
-- Delhivery has the highest number of delayed orders at 194,
-- while Ecom Express has the highest average delay of 1.45 days
-- across 155 delayed orders. Shiprocket follows with an average
-- delay of 1.37 days. Delivery performance should therefore be
-- monitored using both delay volume and average delay duration
-- to identify operational improvement opportunities.















-- Q13. Which products have lower customer ratings but meaningful sales?
-- Compare Average Rating, Review Count, Net Sales and Net Profit
-- to identify products that may require quality or customer-experience improvement.

WITH Product_Performance AS (
    SELECT
        Product_ID,
        ROUND(SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN (Quantity * Unit_Price) - Discount
                ELSE 0
            END
        ), 2) AS Net_Sales,

        ROUND(SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        ), 2) AS Net_Profit

    FROM Orders
    GROUP BY Product_ID
),

Product_Ratings AS (
    SELECT
        Product_ID,
        ROUND(AVG(Rating), 2) AS Average_Rating,
        COUNT(*) AS Review_Count
    FROM Reviews
    GROUP BY Product_ID
)

SELECT
    p.Product_Name,
    r.Average_Rating,
    r.Review_Count,
    pp.Net_Sales,
    pp.Net_Profit

FROM Product_Ratings r
JOIN Product_Performance pp
    ON r.Product_ID = pp.Product_ID
JOIN Products p
    ON r.Product_ID = p.Product_ID

WHERE r.Average_Rating < 3.5
  AND pp.Net_Sales >= 100000

ORDER BY r.Average_Rating ASC;

-- BUSINESS INSIGHT:
-- Running Shoes has the lowest average rating at 3.33 while still
-- generating ₹1.88 lakh in Net Sales. Jeans also has a relatively
-- low rating of 3.42 with ₹1.72 lakh in Net Sales. Bedsheet generates
-- the highest Net Sales among these products at ₹2.58 lakh and
-- ₹91,964 in Net Profit, despite an average rating of only 3.45.
-- These products should be reviewed for product quality, customer
-- expectations and post-purchase experience to protect future sales.















-- Q14. Which states are generating the highest Net Sales and Net Profit?
-- Calculate Net Sales, Net Profit and Profit Margin by State
-- to compare geographical business performance.

SELECT
    c.State,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN (o.Quantity * o.Unit_Price) - o.Discount
            ELSE 0
        END
    ), 2) AS Net_Sales,

    ROUND(SUM(
        CASE
            WHEN o.Order_Status <> 'Cancelled'
            THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                 - (o.Quantity * o.Product_Cost)
            ELSE 0
        END
    ), 2) AS Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN o.Order_Status <> 'Cancelled'
                THEN ((o.Quantity * o.Unit_Price) - o.Discount)
                     - (o.Quantity * o.Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN o.Order_Status <> 'Cancelled'
                    THEN (o.Quantity * o.Unit_Price) - o.Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent

FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID

GROUP BY c.State

ORDER BY Net_Sales DESC;


-- BUSINESS INSIGHT:
-- Uttar Pradesh generated the highest Net Sales at ₹12.83 lakh
-- and the highest Net Profit at ₹2.89 lakh. Gujarat recorded a
-- strong Profit Margin of 26.52%, while West Bengal had the highest
-- margin at 27.69% among the listed states. Delhi recorded a
-- comparatively lower margin of 21.60%, followed by Jharkhand at
-- 20.81%. This indicates that geographical performance differs
-- across both revenue contribution and profitability, so management
-- should consider both sales volume and margin when evaluating states.













-- Q15. What is the overall management summary of UrbanCart?
-- Calculate Total Orders, Delivered Orders, Net Sales, Net Profit,
-- Profit Margin, Return Count and Return Rate to provide a
-- consolidated view of overall business performance.

SELECT
    COUNT(*) AS Total_Orders,

    SUM(
        CASE
            WHEN Order_Status = 'Delivered'
            THEN 1
            ELSE 0
        END
    ) AS Delivered_Orders,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN (Quantity * Unit_Price) - Discount
                ELSE 0
            END
        ), 2
    ) AS Total_Net_Sales,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        ), 2
    ) AS Total_Net_Profit,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status <> 'Cancelled'
                THEN ((Quantity * Unit_Price) - Discount)
                     - (Quantity * Product_Cost)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status <> 'Cancelled'
                    THEN (Quantity * Unit_Price) - Discount
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Profit_Margin_Percent,

    (
        SELECT COUNT(*)
        FROM Returns
    ) AS Return_Count,

    ROUND(
        (
            SELECT COUNT(*)
            FROM Returns
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Order_Status = 'Delivered'
                    THEN 1
                    ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS Return_Rate_Percent

FROM Orders;

-- BUSINESS INSIGHT:
-- UrbanCart processed 2,500 total orders, of which 2,028 were delivered.
-- The business generated ₹68.61 lakh in Net Sales and ₹16.34 lakh
-- in Net Profit, resulting in an overall Profit Margin of 23.81%.
-- A total of 243 returns were recorded, representing an 11.98% Return Rate
-- among delivered orders. Overall, the business is profitable, while
-- delivery performance and return reduction remain important areas
-- for operational improvement.