--Cube
SELECT DISTINCT
 S.Name "Supplier Name",
 S.City "Supplier City",
 S.State "Supplier State",

 P1.Name "Product Name",
 P1.Product_Packaging "Product Packaging",

 P2.Name,
 P2.Product_Line "Product Line",
 P2.Product_Category "Product Category",

 SUM(Quantity) "Total Offers Quantity",
 SUM(Quantity*Price) "Total Offer Value",
 MAX(Price) "Max Price",
 MIN(Price) "Min Price"
INTO Tb_Offers_Cube
FROM Tb_Supplier S, Tb_Product P1, Tb_Product P2, Tb_Offers O
WHERE
 S.Supp_ID = O.Supp_ID AND
 P1.Prod_ID = O.Prod_ID AND
 P1.Prod_ID = P2.Prod_ID
GROUP BY CUBE(
 (S.State, S.City, S.Name),
 (P1.Product_Packaging, P1.Name),
 (P2.Product_Category, P2.Product_Line, P2.Name)),
  ROLLUP (S.State, S.City, S.Name),
  ROLLUP (P1.Product_Packaging, P1.Name),
  ROLLUP (P2.Product_Category, P2.Product_Line, P2.Name)

--1
SELECT [Supplier Name], [Product Packaging], [Total Offer Value]
FROM Tb_Offers_Cube
WHERE
 "Supplier Name" IS NOT NULL
  AND "Supplier City" IS NOT NULL
  AND "Supplier State" IS NOT NULL
  
  AND "Product Name" IS NULL
  AND "Product Packaging" IS NOT NULL

  AND "Name" IS NULL
  AND "Product Line" IS NULL
  AND "Product Category" IS NULL

--2
SELECT [Supplier Name], [Total Offers Quantity]
FROM Tb_Offers_Cube
WHERE
 "Supplier Name" IS NOT NULL
  AND "Supplier City" IS NOT NULL
  AND "Supplier State" = 'Wisconsin'
  
  AND "Product Name" IS NULL
  AND "Product Packaging" IS NULL

  AND "Name" = 'MILK'
  AND "Product Line" IS NOT NULL
  AND "Product Category" IS NOT NULL

--3
SELECT [Product Name], [Max Price]
FROM Tb_Offers_Cube
WHERE
 "Supplier Name" IS NOT NULL
  AND "Supplier City" IS NOT NULL
  AND "Supplier State" = 'Wisconsin'
  
  AND "Product Name" IS NOT NULL
  AND "Product Packaging" IS NOT NULL

  AND "Name" IS NULL
  AND "Product Line" IS NULL
  AND "Product Category" IS NULL

--4
SELECT "Supplier City", "Product Name"
FROM
(SELECT TOP 100 [Supplier City], [Product Name], [Total Offers Quantity], ROW_NUMBER() OVER (PARTITION BY [Supplier City] ORDER BY [Total Offers Quantity] DESC) AS RowNum
FROM Tb_Offers_Cube
WHERE
 "Supplier Name" IS NULL
  AND "Supplier City" IS NOT NULL
  AND "Supplier State" IS NOT NULL
  
  AND "Product Name" IS NOT NULL
  AND "Product Packaging" IS NOT NULL

  AND "Name" IS NULL
  AND "Product Line" IS NULL
  AND "Product Category" IS NULL
ORDER BY [Total Offers Quantity] DESC) AS SortedTable
WHERE RowNum = 1


--5
SELECT "Product Name", "Supplier City"
FROM
(SELECT TOP 100 [Product Name], [Supplier City], [Min Price], ROW_NUMBER() OVER (PARTITION BY [Product Name] ORDER BY [Min Price]) AS RowNum
FROM Tb_Offers_Cube
WHERE
 "Supplier Name" IS NULL
  AND "Supplier City" IS NOT NULL
  AND "Supplier State" IS NOT NULL
  
  AND "Product Name" IS NOT NULL
  AND "Product Packaging" IS NOT NULL

  AND "Name" IS NULL
  AND "Product Line" IS NULL
  AND "Product Category" IS NULL
ORDER BY [Min Price]) AS SortedTable
WHERE RowNum = 1