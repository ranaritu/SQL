-----------------------------RITU RANA------------------------------------------



------------------------create tables-------------------------------------------
--drop table customers;
CREATE TABLE Customers (
   c_id NUMBER,
   c_name VARCHAR2(50),
   credit_limit NUMBER,
   income_level VARCHAR2(4),
   gender VARCHAR2(4),
   PRIMARY KEY(c_id)
   );


--drop table warehouse;
CREATE TABLE Warehouse (
   Warehouse_id  NUMBER,
   Location VARCHAR2(30),
   Ouantity_in_stock NUMBER,
   PRIMARY KEY(Warehouse_id)
   );



--drop table book;
CREATE TABLE Book (
   Book_id  NUMBER,
   Book_name VARCHAR2(50),
   Warehouse_id NUMBER,
   Quantity_On_Hand NUMBER,
   Warranty_Period NUMBER,
   Purchase_Price NUMBER,
   PRIMARY KEY(Book_id),
   constraint book_pk
   FOREIGN KEY (Warehouse_id) references Warehouse(Warehouse_id)
   ON DELETE CASCADE
   );



--drop table orders;
CREATE TABLE Orders (
   Order_id  NUMBER,
   Order_data DATE,
   C_id NUMBER,
   Order_Status VARCHAR2(10),
   PRIMARY KEY(Order_id),
   constraint orders_pk
   FOREIGN KEY (C_id) references Customers(C_id)
   ON DELETE CASCADE
   );

--drop table orderitems;
CREATE TABLE Orderitems (
   Order_id  NUMBER,
   Book_id  NUMBER,
   Unit_Price NUMBER,
   Quantity NUMBER,
   constraint orderitems_pk 
   FOREIGN KEY (Order_id) references Orders(Order_id)
   ON DELETE CASCADE,
   constraint orderitems_pk1
  FOREIGN KEY (Book_id) references Book(Book_id)
  ON DELETE CASCADE
     );



--------------------------add data to tables----------------------------------


INSERT INTO Customers VALUES (1,'Jone',140 ,'L','F');

INSERT INTO Customers VALUES (2,'Chris',230 ,'M','M');

INSERT INTO Customers VALUES (3,'Saywer',480,'H','F');

INSERT INTO Customers VALUES (4,'Kropy',500,'H','M');

INSERT INTO Customers VALUES (5,'Lucy',220, 'M','M');

INSERT INTO Customers VALUES (6,'Mando',100, 'L','F');

INSERT INTO Customers VALUES (7,'Bunny',300, 'M','F');




INSERT INTO Warehouse VALUES(1,'Los Angeles',1100);

INSERT INTO Warehouse VALUES(2,'Chicago',800);

INSERT INTO Warehouse VALUES(3,'New York',700);




INSERT INTO Book VALUES (1,'Life with dog',1,18,90,6);

INSERT INTO Book VALUES (2,'Inferno',1,25,180,8);

INSERT INTO Book VALUES (3,'Doctor sleep',3,9,365,10);

INSERT INTO Book VALUES (4,'Disappear',2,60,30,15);

INSERT INTO Book VALUES (5,'Six years',2,50,365,7);

INSERT INTO Book VALUES (6,'The lowland',1,5,120,25);

INSERT INTO Book VALUES (7,'Wave',3,11,60,20);

INSERT INTO Book VALUES (8,'Lost World',2,20,30,15);

INSERT INTO Book VALUES (9,'Whiskey beach',3,33,150,10);







INSERT INTO Orders VALUES (1,to_date('01-08-2016','dd-mm-yyyy'),1,'P');

INSERT INTO Orders VALUES (2,to_date('27-08-2016','dd-mm-yyyy'),2,'C');

INSERT INTO Orders VALUES (3,to_date('20-06-2016','dd-mm-yyyy'),3,'C');

INSERT INTO Orders VALUES (4,to_date('01-08-2016','dd-mm-yyyy'),4,'C');

INSERT INTO Orders VALUES (5,to_date('31-08-2016','dd-mm-yyyy'),1,'P');

INSERT INTO Orders VALUES (6,to_date('01-09-2016','dd-mm-yyyy'),4,'P');

INSERT INTO Orders VALUES (7,to_date('20-07-2016','dd-mm-yyyy'),6,'C');

INSERT INTO Orders VALUES (8,to_date('11-08-2016','dd-mm-yyyy'),2,'C');









INSERT INTO Orderitems VALUES(1,1,19,2);

INSERT INTO Orderitems VALUES(1,2,20,1);

INSERT INTO Orderitems VALUES(2,1,17,1);

INSERT INTO Orderitems VALUES(3,4,20,2);

INSERT INTO Orderitems VALUES(3,2,25,3);

INSERT INTO Orderitems VALUES(3,8,16,1);

INSERT INTO Orderitems VALUES(4,4,21,10);

INSERT INTO Orderitems VALUES(5,2,10,2);

INSERT INTO Orderitems VALUES(5,8,28,1);

INSERT INTO Orderitems VALUES(6,9,16,10);

INSERT INTO Orderitems VALUES(7,5,12,3);

INSERT INTO Orderitems VALUES(7,7,25,1);

INSERT INTO Orderitems VALUES(8,4,30,2);





----------------------query 1 done--------------------------

SELECT COUNT(case when Gender='M'
                  then 1 end ) as Male,
       COUNT(case when Gender='F' 
                  then 1 end ) as Female
FROM customers ;





-----------------------query 2 done--------------------------

select c_name, avg(credit_limit) as Average_Credit_Limit
from CUSTOMERS
where INCOME_LEVEL='M'
group by Customers.C_name;

select avg(credit_limit) as Average_Credit_Limit
from CUSTOMERS
where INCOME_LEVEL='M';




-----------------------query 3 done--------------------------
select c_name,ORDER_STATUS from customers,ORDERS
where ORDERS.ORDER_STATUS ='C' and customers.income_level ='H';




-----------------------query 4 done--------------------------

                               
 select c_name from customers  
 where c_id in(
 SELECT c_id
  FROM orders
 WHERE order_id in  
 (SELECT order_id
                   FROM orderitems 
                  WHERE quantity = (select max(quantity) 
                                from orderitems)) ) ;                             






-----------------------query 5 done--------------------------

select c_name from customers  
 where c_id in(
              SELECT c_id
              FROM orders
              WHERE order_id in (
                                select order_id from ORDERitems
                                where order_id IN 
                                ( select order_id from ORDERITEMS
                                  where quantity>=3))) and INCOME_LEVEL != 'H';






-----------------------query 6 done--------------------------


--drop view profitearned;
create view profitearned(Order_id,sales_rev,Profit) AS
select oi.book_id,sum(OI.quantity*OI.unit_price),sum(OI.quantity*OI.unit_price - b.purchase_price*OI.quantity) 
from ORDERITEMS OI,book B,orders o
where B.book_ID = OI.book_ID AND o.order_id=OI.ORDER_ID AND O.ORDER_STATUS='C'
group by oi.book_id ;

select sum(sales_rev) as sales_revenue,sum(profit) as Profit
from profitearned ;







-----------------------query 7 done---------------------------


--drop view view7;
create view view7 (orderID, cid, orderstatus)
AS
select orders.order_id, orders.C_id, orders.order_status 
from orders
where ORDER_STATUS ='P';

--drop view view71;
create view view71 (cid,orderID, totalprice)
as
select view7.CID, view7.orderID, sum(orderitems.unit_price* quantity)
from view7, orderitems
group by view7.cid, view7.orderID ;


select distinct customers.c_name as Value_morethan_half_CL
from customers, view71
where customers.c_id = view71.cid and view71.totalprice>customers.CREDIT_LIMIT/2;




-----------------------query 8 done--------------------------

select  oi.order_id,B.book_name,O.order_data,B.warranty_period
from orders O, book B, orderitems OI
where O.order_id=OI.ORDER_ID AND OI.book_id=B.book_id AND
        O.ORDER_STATUS='C' AND B.quantity_on_hand>10 AND B.warranty_period< sysdate-O.order_data ;






-----------------------query 9 done--------------------------

select c_name from CUSTOMERS 
where c_id in(
            select c_id from 
            ORDERS where order_id in(
                              select order_id from ORDERITEMS 
                              where quantity>=2
                              and order_id in(
                              select order_id from orders
                              where
order_data between to_date('2016-08-01','YYYY-MM-DD') and to_date('2016-09-01','YYYY-MM-DD'))));




-----------------------query 10 done--------------------------


--drop view view10;

create view view10(oid,warehouses) AS
(
select O.order_id,count( DISTINCT B.warehouse_id )
      from orderitems O,book B
      where O.book_id=B.BOOK_ID 
      GROUP BY O.order_id);


select C.c_name
  from orders O,view10,customers C
  where O.order_id=view10.OID AND O.c_id=C.c_id AND view10.warehouses>=2 ;






-----------------------query 11 done--------------------------
select c_name from customers where c_id in(
select c_id from ORDERS where
order_data NOT between to_date('31-07-2016','DD-MM-YYYY') and to_date('31-08-2016','DD-MM-YYYY')) and GENDER ='M';




-----------------------query 12 done--------------------------

select book_name
    from book where book_name NOT IN(
                    select book_name from book where book_id in(
                            select book_id from orderitems where order_id in(
                                  select order_id from ORDERS where c_id in(
                                        select c_id from customers where income_level = 'H'))));



-----------------------query 13 done--------------------------


--drop view view13;
create view view13 ( gender1, bookID, Quantity2)
AS
select customers.gender, orderitems.book_id, orderitems.quantity
from customers, orders, orderitems
where customers.c_id = orders.c_id and orders.ORDER_ID = orderitems.ORDER_ID;


--DROP VIEW males;
create view Males(bookID,TotalQuantity) AS
select bookID, sum(Quantity2)
from view13
where gender1='M' 
group by bookID;


--drop view females;
create view Females(bookID,TotalQuantity) AS
select bookID, sum(Quantity2)
from view13
where gender1='F' 
group by bookID;


select Males.bookID as Largest_MALE_Sel_Vol, Females.bookID as Largest_FEMALE_Sel_Vol
from Males,Females
where Males.TOTALQUANTITY in
                  (select max(Males2.TotalQuantity)
                   from Males Males2)
AND Females.TOTALQUANTITY in
                  (select max(Females2.TotalQuantity)
                   from Females Females2);




-----------------------query 14 done--------------------------

select order_id from orderitems
order by UNIT_PRICE desc;



-----------------------query 15 done--------------------------

--drop view view15;
create view view15(bookID,quantity2) 
AS
select book_id, sum(quantity)from orderitems 
group by BOOK_ID;

select book_name from book 
where book_id in(select BOOKID from view15 
              where quantity2 = (select max(quantity2) from view15));


----------------------query 16------------------------------------

select book.book_name, avg((orderitems.unit_price*orderitems.quantity)-(book.purchase_price*orderitems.quantity)) as Difference
from orderitems,book
where orderitems.BOOK_ID=book.BOOK_ID
group by book_name, book.book_name;



--drop view view16;

create view view16(book_name,profit) AS
select book.book_name,sum((orderitems.unit_price*orderitems.quantity)-(book.purchase_price*orderitems.quantity))
from orderitems,book 
where orderitems.BOOK_ID=book.BOOK_ID
group by book.book_name;


select view16.book_name as Book_with_max_profit
    from view16
    where PROFIT = ( select max(PROFIT) 
    from view16) ;
    
    select view16.book_name as Book_with_min_profit
    from view16
    where PROFIT = ( select min(PROFIT)
    from view16) ;

-----------------------------END OF QUERIES-------------------------------------


---------------------------TABLE UPDATE PART------------------------------------

----------------------------update 1--------------------------------------------
update customers
set credit_limit = 0.30*credit_limit
where customers.gender = 'F';


--drop view viewT1;
create view viewT1 (orderID, total)
AS
select ORDER_ID, sum(unit_price*quantity) from orderitems 
group by orderitems.order_id;

delete from ORDERS where ORDER_ID IN
          (select distinct orders.ORDER_ID
            From customers ,orders ,VIEWT1
              where 
              orders.ORDER_ID=ViewT1.ORDERID AND orders.order_status='P' AND orders.c_id=customers.C_ID AND
              ViewT1.total>(customers.CREDIT_LIMIT) );


---------------------------------update 2---------------------------------------

--drop view viewT2;
create view viewT2 (bookid, totalSold)
AS
select orderitems.book_id, sum(orderitems.quantity)
from orderitems, orders
where orders.order_status ='P' and orders.order_id = orderitems.order_id
group by orderitems.book_id;

--drop view viewT22;
create view viewT22 ( bookid, quantityOnHand2)
AS
select book.book_id,book.quantity_on_hand-viewT2.totalSold
from book,ViewT2
where book.book_id=viewT2.bookid ;

update orders 
set ORDER_STATUS ='C' 
where ORDER_STATUS ='P';


update book 
set quantity_on_hand = (select quantityOnHand2 from viewT22
                          
                          where book.book_id=viewT22.bookid );
                          
                          
 -------------------------------update 3----------------------------------------
 
 delete from customers
 where c_name = 'Kropy' and c_id = 4;


---------------------------------update 4---------------------------------------

update book set WARRANTY_PERIOD=WARRANTY_PERIOD+30 
where WAREHOUSE_ID=( select warehouse_id
                     from warehouse
                     where Location='Chicago' ) ;
                     
update book set WARRANTY_PERIOD = 365 where WARRANTY_PERIOD >365;




------------------------------Drop Tables and Views-----------------------------


drop table orderitems;
drop table book;
drop table warehouse;
drop table orders;
drop table customers;



drop view profitearned;
drop view view7;
drop view view71;
drop view view10;
drop view view13;
DROP VIEW males;
drop view females;
drop view view15;
drop view view16;
drop view viewT1;
drop view viewT2;
drop view viewT22;
