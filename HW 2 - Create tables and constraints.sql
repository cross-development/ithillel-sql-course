--CREATING A DATABASE
--Create the OnlineStore database
CREATE DATABASE OnlineStore
GO


--USING THE DATABASE
--Use the OnlineStore database
USE OnlineStore
GO


--CREATING TABLES.
--Create the Customers table
CREATE TABLE Customers (
	Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName nvarchar(20) NOT NULL,
	LastName nvarchar(20) NOT NULL,
	Email nvarchar(50) UNIQUE NOT NULL,
	RegistrationDate date DEFAULT getdate() NOT NULL,
)
GO

--Create the Categories table
CREATE TABLE Categories (
	Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CategoryName nvarchar(20) NOT NULL,
	Description nvarchar(255) NOT NULL,
)
GO

--Create the Products table
CREATE TABLE Products (
	Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ProductName nvarchar(100) NOT NULL,
	Price decimal(10,2) CHECK (Price > 0) NOT NULL,
	StockQuantity int NOT NULL,
	CategoryId int NOT NULL,
	--CONSTRAINT FK_Products_To_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(id),
)
GO

--Create the Orders table
CREATE TABLE Orders (
	Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	OrderDate date NOT NULL,
	TotalAmount decimal(10,2) NOT NULL,
	CustomerId int NOT NULL,
	--CONSTRAINT FK_Orders_To_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
)
GO

--Create the table OrderDetails
CREATE TABLE OrderDetails (
	OrderId int NOT NULL,
	ProductId int NOT NULL,
	Quantity int CHECK (Quantity > 0) NOT NULL,
	UnitPrice decimal(10,2) NOT NULL,
	PRIMARY KEY (OrderId, ProductId),
	--CONSTRAINT FK_OrderDetails_To_Orders FOREIGN KEY (OrderId) REFERENCES Orders(id),
	--CONSTRAINT FK_OrderDetails_To_Products FOREIGN KEY (ProductId) REFERENCES Products(Id),
)
GO


--ADDING CONSTRAINTS TO TABLES
--Add a foreign key Products.CategoryId -> Categories.Id
ALTER TABLE Products
ADD CONSTRAINT FK_Products_To_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(id)
GO

--Add a foreign key Orders.CustomerId -> Customers.Id
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_To_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
GO

--Add a foreign key OrderDetails.OrderId -> Orders.Id
ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_To_Orders FOREIGN KEY (OrderId) REFERENCES Orders(id)
GO

--Add foreign key OrderDetails.ProductID -> Products.Id
ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_To_Products FOREIGN KEY (ProductId) REFERENCES Products(Id)
GO


--MAKING CHANGES TO THE TABLES
--Add a new column Description to the Products table
ALTER TABLE Products
ADD Description nvarchar(255) NOT NULL
GO

--Delete the Description column from the Products table
ALTER TABLE Products
DROP COLUMN Description
GO


--INSERTING DATA INTO TABLES
--Insert data into the Customers table
INSERT INTO Customers (FirstName, LastName, Email, RegistrationDate)
VALUES	('John', 'Doe', 'john.doe@example.com', '2024-01-01'),
		('Jane', 'Smith', 'jane.smith@example.com', '2024-01-02'),
		('Robert', 'Brown', 'robert.brown@example.com', '2024-01-03')
GO

--Insert data into the Categories table
INSERT INTO Categories (CategoryName, Description)
VALUES	('Electronics', 'Electronic devices and gadgets'),
		('Books', 'Various genres of books'),
		('Clothing', 'Men and women clothing')
GO

--Insert data into the Products table
INSERT INTO Products (ProductName, Price, StockQuantity, CategoryId)
VALUES	('Laptop', 2500.00, 10, 1),
		('Novel', 14.99, 55, 2),
		('T-Shirt', 20.49, 20, 3)
GO

--Insert data into the Orders table
INSERT INTO Orders (OrderDate, TotalAmount, CustomerId)
VALUES	('2024-10-01', 2500.00, 1),
		('2024-10-02', 29.98, 2),
		('2024-10-03', 61.47, 3)
GO

--Insert data into the OrderDetails table
INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice)
VALUES	(1, 1, 1, 2500.00),
		(2, 2, 2, 14.99),
		(3, 3, 3, 20.49)
GO
