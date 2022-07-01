--*************************************************************************--
-- Title: Assignment04
-- Author: IMartinez
-- Desc: This file demonstrates how to process data from a database
-- Change Log: When,Who,What
-- 2020-04-27,IMartinez,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_IMartinez')
 Begin 
  Alter Database [Assignment04DB_IMartinez] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_IMartinez;
 End
go

Create Database Assignment04DB_IMartinez;
go

Use Assignment04DB_IMartinez;
go

-- Add Your Code Below ---------------------------------------------------------------------

-- Data Request: 0301
-- Request: I want a list of customer companies and their contact people
Select * From Northwind.dbo.Customers;
go
Select CompanyName, ContactName From Northwind.dbo.Customers;
go

Create View vCustomerContacts
As
Select CompanyName, ContactName -- Select Columns
From Northwind.dbo.Customers;
go

-- Test with this statement --
Select * from vCustomerContacts;



-- Data Request: 0302
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
Select * From Northwind.dbo.Customers;
go
Select CompanyName, ContactName, Country -- Select Columns
From Northwind.dbo.Customers;
go
Select CompanyName, ContactName, Country
From Northwind.dbo.Customers
Where Country = 'USA' Or Country = 'Canada' -- Filter
Order By Country; -- Sort
go

Create View vUSAandCanadaCustomerContacts
As
Select Top 100000
  CompanyName
 ,ContactName
 ,Country
From Northwind.dbo.Customers
Where Country = 'USA' Or Country = 'Canada'
Order By Country;
go

-- Test with this statement --
Select * from vUSAandCanadaCustomerContacts;
  


-- Data Request: 0303
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order.
Select * From Northwind.dbo.Products;
go
Select c.CategoryName, p.ProductName, p.UnitPrice
From Northwind.dbo.Products as p 
Join Northwind.dbo.Categories as c -- Join to get category name
 on p.CategoryID = c.CategoryID;
go
Select c.CategoryName, p.ProductName, p.UnitPrice As [StandardPrice] -- Change name
From Northwind.dbo.Products as p 
Join Northwind.dbo.Categories as c
 on p.CategoryID = c.CategoryID
Order By c.CategoryName, p.ProductName; -- Sort
go

Create View vProductPricesByCategories
As
Select Top 100000
  c.CategoryName
 ,p.ProductName
 ,p.UnitPrice As [StandardPrice]
From Northwind.dbo.Products as p 
 Join Northwind.dbo.Categories as c
  on p.CategoryID = c.CategoryID
Order By c.CategoryName, p.ProductName;
go

-- Test with this statement --
Select * from vProductPricesByCategories;



-- Data Request: 0304
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order but only for the seafood category
Select c.CategoryName, p.ProductName, p.UnitPrice
From Northwind.dbo.Products as p 
Join Northwind.dbo.Categories as c -- Join to get category name
 on p.CategoryID = c.CategoryID;
go

Create Function dbo.[fProductPricesByCategories]
(@CategoryName nvarchar(100))
Returns Table
AS
 Return(
  Select Top 100000
    c.CategoryName
   ,p.ProductName
   ,p.UnitPrice As [StandardPrice]
  From Northwind.dbo.Products as p 
   Join Northwind.dbo.Categories as c
    on p.CategoryID = c.CategoryID
  Where c.CategoryName = @CategoryName
  Order By 
   Case When @CategoryName = 'seafood' Then c.CategoryName End,
   Case When @CategoryName = 'seafood' Then p.ProductName End
);
go
-- Test with this statement --
Select * from dbo.fProductPricesByCategories('seafood');



-- Data Request: 0305
-- Request: I want a list of how many orders our customers have placed each year
Select c.CompanyName, Count(o.OrderID) As [NumberOfOrders], Year(o.OrderDate) As [Order Year] -- columns
From Northwind.dbo.Customers as c
 Join Northwind.dbo.Orders as o -- Join to get OrderID
  on c.CustomerID = o.CustomerID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName; -- sort
go

Create View vCustomerOrderCounts
As
Select Top 100000
  c.CompanyName
 ,Count(o.OrderID) As [NumberOfOrders]
 ,Year(o.OrderDate) As [Order Year]
From Northwind.dbo.Customers as c
 Join Northwind.dbo.Orders as o
  on c.CustomerID = o.CustomerID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName;
go
-- Test with this statement --
Select * from vCustomerOrderCounts



-- Data Request: 0306
-- Request: I want a list of total order dollars our customers have placed each year
Select c.CompanyName, Sum(od.UnitPrice * od.Quantity) as TotalDollars, Year(o.OrderDate) as OrderYear
From Northwind.dbo.[Order Details] as od
 Join Northwind.dbo.Orders as o
  on od.OrderID = o.OrderID
 Join Northwind.dbo.Customers as c -- Join Tables
  on o.CustomerID = c.CustomerID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName; -- Sort
go

Create View vCustomerOrderDollars
As
Select Top 100000
  c.CompanyName
 ,Sum(od.UnitPrice * od.Quantity) as TotalDollars
 ,Year(o.OrderDate) as OrderYear
From Northwind.dbo.[Order Details] as od
 Join Northwind.dbo.Orders as o
  on od.OrderID = o.OrderID
 Join Northwind.dbo.Customers as c
  on o.CustomerID = c.CustomerID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName;
go

-- Test with this statement --
Select * from vCustomerOrderDollars;

