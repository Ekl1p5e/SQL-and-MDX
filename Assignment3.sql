SELECT Product_Category, COUNT(Prod_ID) AS Num_of_Products
FROM Tb_Product
GROUP BY Product_Category;

SELECT City
FROM Tb_Consumer
GROUP BY City
HAVING COUNT(Con_ID) >= 3;

SELECT City, COUNT(Product_Category) AS Num_Of_Types
FROM (SELECT City, Product_Category
 FROM Tb_Offers, Tb_Product, Tb_Supplier
 WHERE Tb_Offers.Supp_ID = Tb_Supplier.Supp_ID
  AND Tb_Offers.Prod_ID = Tb_Product.Prod_ID
 GROUP BY City, Product_Category) AS Agg_Table
GROUP BY City;

SELECT State, COUNT(Supp_ID) AS Num_Of_Suppliers
FROM (SELECT Tb_Supplier.Supp_ID, Tb_Supplier.State
	FROM Tb_Product, Tb_Offers, Tb_Supplier
	WHERE Tb_Offers.Prod_ID = Tb_Product.Prod_ID
	 AND Tb_Offers.Supp_ID = Tb_Supplier.Supp_ID
	 AND Tb_Product.Name = 'Auto'
	GROUP BY Tb_Supplier.Supp_ID, Tb_Supplier.State) AS Agg_Table
GROUP BY State;

SELECT Tb_Supplier.City, Tb_Product.Name, SUM(Tb_Offers.Quantity)
FROM Tb_Offers, Tb_Product, Tb_Supplier
WHERE Tb_Offers.Prod_ID = Tb_Product.Prod_ID
 AND Tb_Offers.Supp_ID = Tb_Supplier.Supp_ID
GROUP BY Tb_Product.Name, Tb_Supplier.City;

SELECT Tb_Consumer.City, Tb_Supplier.Name, SUM(Tb_Transactions.Quantity) AS Num_Of_TVs_Sold
FROM Tb_Transactions, Tb_Product, Tb_Supplier, Tb_Consumer
WHERE Tb_Transactions.Prod_ID = Tb_Product.Prod_ID
 AND Tb_Transactions.Supp_ID = Tb_Supplier.Supp_ID
 AND Tb_Transactions.Con_ID = Tb_Consumer.Con_ID
 AND Tb_Product.Name = 'TV'
GROUP BY Tb_Supplier.Name, Tb_Consumer.City;

SELECT Tb_Supplier.Name AS Supp_Name, Tb_Consumer.Name AS Consumer_Name, Tb_Product.Name AS Prod_Name, SUM(Tb_Transactions.Price * Tb_Transactions.Quantity) AS Total_Value
FROM Tb_Supplier, Tb_Consumer, Tb_Product, Tb_Transactions
WHERE Tb_Transactions.Supp_ID = Tb_Supplier.Supp_ID
 AND Tb_Transactions.Con_ID = Tb_Consumer.Con_ID
 AND Tb_Transactions.Prod_ID = Tb_Product.Prod_ID
GROUP BY Tb_Supplier.Name, Tb_Consumer.Name, Tb_Product.Name;

SELECT Tb_Supplier.City AS Supp_City, Tb_Consumer.City AS Consumer_City, Tb_Product.Name AS Prod_Name, SUM(Tb_Transactions.Price * Tb_Transactions.Quantity) AS Total_Value
FROM Tb_Supplier, Tb_Consumer, Tb_Product, Tb_Transactions
WHERE Tb_Transactions.Supp_ID = Tb_Supplier.Supp_ID
 AND Tb_Transactions.Con_ID = Tb_Consumer.Con_ID
 AND Tb_Transactions.Prod_ID = Tb_Product.Prod_ID
GROUP BY Tb_Supplier.City, Tb_Consumer.City, Tb_Product.Name;

SELECT Consumer_Table.State
FROM (SELECT Tb_Consumer.State, COUNT(Tb_Consumer.Name) AS Consumer_Count
		FROM Tb_Consumer
		GROUP BY Tb_Consumer.State) AS Consumer_Table
		INNER JOIN
	 (SELECT Tb_Supplier.State, COUNT(Tb_Supplier.Name) AS Supplier_Count
		FROM Tb_Supplier
		GROUP BY Tb_Supplier.State) AS Supplier_Table
		ON Consumer_Table.State = Supplier_Table.State
WHERE Supplier_Table.Supplier_Count > Consumer_Table.Consumer_Count;

SELECT Tb_Supplier.State,
 Tb_Supplier.City,
 COUNT(DISTINCT Tb_Supplier.Supp_ID) AS NumberOfSuppliers,
 COUNT(DISTINCT Tb_Consumer.Con_ID) AS NumberOfConsumers
FROM Tb_Supplier FULL OUTER JOIN Tb_Consumer
ON Tb_Supplier.City = Tb_Consumer.City
 AND Tb_Supplier.State = Tb_Consumer.State
GROUP BY Tb_Supplier.City, Tb_Supplier.State;