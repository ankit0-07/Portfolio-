create database assignments

--Assignment 01

--1. Insert a new record in your Orders table.
CREATE TABLE Salesman (
    SalesmanId INT,
    Name VARCHAR(255),
    Commission DECIMAL(10, 2),
    City VARCHAR(255),
    Age INT
);
 INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES
    (101, 'Joe', 50, 'California', 17),
    (102, 'Simon', 75, 'Texas', 25),
    (103, 'Jessie', 105, 'Florida', 35),
    (104, 'Danny', 100, 'Texas', 22),
    (105, 'Lia', 65, 'New Jersey', 30)

	CREATE TABLE Customer (
    SalesmanId INT,
    CustomerId INT,
    CustomerName VARCHAR(255),
    PurchaseAmount INT,
    ); 
INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);

	CREATE TABLE Orders (OrderId int, CustomerId int, SalesmanId int, Orderdate Date, Amount money)
 INSERT INTO Orders Values 
(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500)

select * from Salesman
select * from Customer
select * from Orders

insert into orders values
(5004,3412,106,'2024-04-04',2000)

--2. Add Primary key constraint for SalesmanId column in Salesman table. Add default
--constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId
--column in Customer table. Add not null constraint in Customer_name column for the
--Customer table.

alter table salesman
alter column salesmanid int not null
alter table salesman
add constraint pk_salesmanid primary key (salesmanid),constraint df_city default'delhi' for city

insert into salesman values (107,'name',300,'city',90),(110,'name',500,'city',100)

alter table customer
add foreign key (salesmanid)
references salesman(salesmanid)

alter table customer
alter column customername varchar(50) not null

--3. Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase
--amount value greater than 500.

select * from Customer
where CustomerName='%n' and PurchaseAmount>500

--4. Using SET operators, retrieve the first result with unique SalesmanId values from two
--tables, and the other result containing SalesmanId with duplicates from two tables.

-- first result
select salesmanid
from salesman

UNION

select salesmanid
from customer
--second result
select salesmanid
from salesman

union all

select salesmanid
from customer
 
--5. Display the below columns which has the matching data.
--Orderdate, Salesman Name, Customer Name, Commission, and City which has the
--range of Purchase Amount between 500 to 1500.

select o.orderdate,s.name,c.customername,s.commission,s.city,c.PurchaseAmount
from Salesman s
inner join
Customer c
on s.SalesmanId=c.SalesmanId
inner join
Orders o
on c.CustomerId=o.CustomerId
where PurchaseAmount between 500 and 1500

--6. Using right join fetch all the results from saleman and orders table

select * from Salesman s
right join
Orders o
on s.SalesmanId=o.SalesmanId



--Assignment 02


select * from jomato
--1. Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick
--Chicken Bites’.

create function stuff_chicken()
returns table
as
return
(select REPLACE(RestaurantType,'quick bites','quick chicken bites')as 'RestaurantType' from jomato)
go
select * from dbo.stuff_chicken()

--2. Use the function to display the restaurant name and cuisine type which has the
--maximum number of rating.

create function 
max_rating()
returns table
as
return
(select restaurantname,cuisinestype 
from Jomato
where max(no_of_rating))
go

--3. Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4
--start rating, ‘Good’ if it has above 3.5 and below 4 star rating, ‘Average’ if it is above 3
--and below 3.5 and ‘Bad’ if it is below 3 star rating and

alter table jomato
add RatingStatus varchar(20)
update Jomato
set RatingStatus='Excellent' where Rating>4
update Jomato
set RatingStatus='Good' where Rating between 3.5 and 4
update Jomato
set RatingStatus='Average' where Rating between 3 and 3.5 
update Jomato
set RatingStatus='Bad' where Rating<3

--4. Find the Ceil, floor and absolute values of the rating column and display the current
--date and separately display the year, month_name and day.

select Rating,
floor(rating)as floor_rating,
ceiling(rating)as ceil_rating,
ABS(rating)as absolute_rating,
getdate() AS currentdate,
year(getdate()) as year,
datename(month, getdate()) as monthname,
day(getdate()) as day
from Jomato


--5. Display the restaurant type and total average cost using rollup

select coalesce(restauranttype,'Grand Total')as RestaurantType,sum(averagecost)as Total_Average_Cost
from Jomato
group by rollup (RestaurantType)

--Assignment 03

--1. Create a stored procedure to display the restaurant name, type and cuisine where the
--table booking is not zero.

create procedure not_zero
as
begin
select restaurantname,restauranttype,cuisinestype,TableBooking from jomato
where tablebooking>0
end
exec not_zero

--2. Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result
--and rollback it.

begin transaction

update jomato
set CuisinesType = REPLACE(CuisinesType, 'Cafe', 'Cafeteria')
where CuisinesType like '%Cafe%'

select * from jomato
where CuisinesType like '%Cafeteria%'

rollback transaction

select * from jomato
where CuisinesType like '%Cafe%'

--3. Generate a row number column and find the top 5 areas with the highest rating of
--restaurants.

select row_number() over(order by (select null)) as RowNumber,*
into #jomatowithrownumber
from jomato

select Area,AVG(Rating) as AverageRating
into #AverageRatingPerArea
from #jomatowithrownumber
group by Area

select top 5 Area,AverageRating
from #AverageRatingPerArea
order by AverageRating desc

--4. Use the while loop to display the 1 to 50.

declare @counter int=1
while @counter<=50
begin print @counter set @counter = @counter + 1
end

--5. Write a query to Create a Top rating view to store the generated top 5 highest rating of
--restaurants.

create view
top_rating_view
as
select top 5 RestaurantName,Rating,RestaurantType,Area,CuisinesType,LocalAddress
from jomato
order by Rating desc

select * from top_rating_view

--6. Create a trigger that give a message whenever a new record is inserted.create trigger trig on jomato for insert
as
begin
	print 'INSERT STATEMENT EXECUTED'
end
