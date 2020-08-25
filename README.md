### Winter 2021 Shopify Data Science Intern Challenge
### Question 1

#### a. What is wrong with the calculation?
From initial analysis of the dataset, it\'s clear that the calculation of $3145.13 is simply the mean of the order_amount, which refers to the overall total. To begin to analyze what is wrong with this calculation, I calculated the interquartile range and plotted the order amount against the size of the order.

**Interquartile Range:**
* Minimum: 90
* 1st Quartile: 163
* Median: 284
* 3rd Quartile: 390
* Max: 704000

Immediately, we notice that the highest order total is 704000 and that the median of $284 is much lower than $3145.20. This suggests that there are a few outliers in the data that are pulling the more sensitive mean higher.

When we pinpoint these orders, we find that this refers to bulk orders of 2000 pairs of shoes valued at $352 each. This is likely a wholesale buyer that may be buying stock for their own store. Since this is a unique buying behavior and outlier to the data (Outliers fall outside [-64, 617]), for purposes of calculating an average order value that more accurately represents the average consumer, I chose to exclude these rows from the calculation.

I generated another plot without the bulk order amounts and noticed that there were several more shoes that were selling for over the calculated mean of $3145.13. Therefore, I chose to investigate how much a single pair of shoes costs at each shop.

I calculated the price of product by dividing the order_amount by total_items. Again, I started with looking at the interquartile range, noticing that the most expensive single pair of shoes is $25,725, sold by shop 78. This is likely a shop that specializes in luxury sneakers or has some other reasoning for offering such an expensive product. Seeing as there is only one shop with these prices, and this product is an outlier (Outliers fall outside [97, 190]), excluding these rows could be an option.

**Interquartile Range:**
* Minimum: 90
* 1st Quartile: 133
* Median: 153
* 3rd Quartile: 169
* Max: 25725

#### b. What metric would be better to report?

Median would be a much better metric to report. We prefer to avoid removing data as much as possible to retain the size of the sample. Additionally, median is less sensitive to outlier data and provides a better measure of central tendency within a dataset.

If we still want to calculate an **average order value**, another option is to exclude the outliers that are skewing the mean calculation and recalculate with the new sample, understanding that we have removed points of variability within the sample. This would mean excluding all data that has an order_amount greater than $617, using the definition of an outlier as being either greater than Q3+1.5*(Q3-Q1) or less than Q1+1.5*(Q3-Q1)


#### c. What is its value?
In this case, the median order value is **$284**.

The recalculated average order value is **$283**.

### Question 2

#### a. How many orders were shipped by Speedy Express in total?
```sql
SELECT COUNT(DISTINCT OrderID) AS speedy_shipped
	FROM Orders
    JOIN Shippers 
    ON Orders.ShipperID = Shippers.ShipperID
    WHERE Shippers.ShipperName = "Speedy Express"
```
54 unique orders were shipped by Speedy Express in total. 

I joined Orders and Shippers on the common variable of ShipperID. I then utilized the COUNT function and DISTINCT keyword to identify the number of unique orders, using the WHERE command to isolate the query to only consider orders that were shipped by "Speedy Express"

#### b. What is the last name of the employee with the most orders?
```
WITH T AS (SELECT Employees.LastName,
				  COUNT(DISTINCT OrderID) AS num_orders
            FROM Employees
            LEFT JOIN Orders 
            ON Employees.EmployeeID = Orders.EmployeeID
            GROUP BY Employees.EmployeeID
            ORDER BY num_orders DESC)
	SELECT * FROM T
    WHERE num_orders = (SELECT MAX(num_orders) FROM T)
```
The last name of the employee with the most orders is "Peacock." 

#### c. What product was ordered the most by customers in Germany?
```
WITH T as (SELECT OrderDetails.ProductID, 
	   Products.ProductName,
       SUM(Quantity) AS total_ordered
	FROM OrderDetails
    JOIN Orders
    	ON OrderDetails.OrderID = Orders.OrderID
    LEFT JOIN Products
    	ON OrderDetails.ProductID = Products.ProductID
    JOIN Customers
    	ON Customers.CustomerID = Orders.CustomerID
    WHERE Country = "Germany"
    GROUP BY OrderDetails.ProductID
    ORDER BY total_ordered DESC
   )
   SELECT * FROM T 
   WHERE TOTAL_ORDERED = (SELECT MAX(TOTAL_ORDERED) FROM T)
```
Boston Crab Meat (Product ID 40) was ordered the most by customers in Germany.
