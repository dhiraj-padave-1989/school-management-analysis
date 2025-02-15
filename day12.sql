use zoom;
-- views, cte

/*

1. views
definition: a view is a virtual table in a database that is based on the result of a select query.
it does not store data itself but provides a way to present data from one or more tables in a 
structured format. views can simplify complex queries, enhance security by restricting access to 
specific data, and provide a consistent interface to data.

key features of views
1. simplification: views can simplify complex queries by encapsulating them.
2. security: they can restrict access to specific rows or columns of data.
3. reusability: once created, views can be reused in other queries.

*/

-- example 1: employee management system
-- step 1: create the employee table
create table employee (
	id int auto_increment primary key,
    name varchar(100) not null,
    position varchar(100) not null,
    active boolean not null,
    status varchar(20) not null
    );
    
    -- step 2: insert sample data into employees
    insert into employee (name,position,active,status) values
    ('john doe','manager',true,'active'),
    ('jane smith','developer',true,'active'),
    ('bob johnson','designer',false,'inactive');
    
    -- step 3: create a view for active employees
    create view employeeview as
    select id, name, position
    from employee
    where active = 1;
    
    -- step 4: use the view
    select * from employeeview;
    
    -- step 5: update the view
    create or replace view activeemployees as
    select id,name,position
    from employee
    where status = 'active';
    
    -- step 6: use the updated view
    select * from activeemployees;
    
    -- step 7: delete the view
    drop view if exists employeeviews;
    
    -- optionally, delete the updated view
    drop view if exists activeemployees;
    
    -- example 2: product management system
    -- step 1: create the products table
    create table products (
		id int auto_increment primary key,
        name varchar(100) not null,
        price decimal(10,2) not null,
        stock int not null,
        category varchar(50) not null
	);
    
    -- step 2: insert sample data into products
    insert into products (name,price,stock,category) values
    ('laptop', 999.99, 10, 'electronics'),
    ('smartphone', 499.99, 20, 'electronics'),
    ('desk', 199.99, 15, 'furniture'),
    ('chair', 89.99, 30, 'furniture'),
    ('headphones', 149.99, 25, 'electronics');
    
    -- step 3: create a view for available products
    create view availableproducts as
    select id, name, price, stock
    from products
    where stock > 0;
    
    -- step 4: use the view
    select * from availableproducts;
    
    -- step 5: update the view to include category
    create or replace view availableproductswithcategory as
    select id,name,price,stock,category
    from products
    where stock > 0;
    
    -- step 6: use the updated view
    select * from availableproductswithcategory;
    
    -- step 7: delete the views
    drop view if exists availableproducts;
    drop view if exists availableproductswithcategory;
    
    -- example 3: order management system
    -- step 1: create the orders table
    create table orders (
		id int auto_increment primary key,
        customer_name varchar(100) not null,
        product_id int not null,
        quantity int not null,
        order_date date not null,
        foreign key (product_id) references products(id)
	);
    
    -- step 2: insert sample data into orders
    insert into orders (customer_name,product_id,quantity,order_date) values
    ('alice',1,1,'2023-10-01'),
	('bob',2,2,'2023-10-02'),
    ('charlie',3,1,'2023-10-03'),
    ('david',1,3,'2023-10-04');
    
    -- step 3: create a view for order summary
    create view ordersummary as
    select o.id, o.customer_name, p.name as product_name, o.quantity, o.order_date
    from orders o
    join products p on o.product_id = p.id;
    
    -- step 4: use the view
    select * from ordersummary;
    
    -- step 5: update the view to include total price
    create or replace view ordersummarywithtotal as
    select o.id, o.customer_name, p.name as product_name, o.quantity, o.order_date,
		(o.quantity * p.price) as total_price
	from orders o
    join products p on o.product_id = p.id;
    
    -- step 6: use the updated view
    select * from ordersummarywithtotal;
    
    -- step 7: delete the views
    drop view if exists ordersummary;
    drop view if exists ordersummarywithtotal;
    
    /*
    2. common table expressions (cte)
    definition:
    a cte is a temporary result set that you can reference within a select, insert, update, or delete statement.
    it is defined using the with clause.
    
    key features of ctes
    1. readability: ctes can make complex queries easier to read and maintain.
    2. recursion: ctes can be recursive, allowing for hierarchical data transversal.
    3. modularity: they can be defined once and referenced multiple times within the same query.
    */
    
    -- example 1: employee management system with cte
    -- step 3: use a cte to get active employees
    with activeemployees as (
		select id,name,position
        from employee
        where active = 1
	)
    select * from activeemployees;
    
    -- step 4: use a cte to count active employees by position
    with activeemployeecounts as (
		select position,count(*) as count
        from employee
        where active = 1
        group by position
	)
    select * from activeemployeecounts;
    
    -- step 5: use a cte to get inactive employees
    with inactiveemployees as (
		select id,name,position
        from  employee
        where active = 0
	)
    select * from inactiveemployees;
    
    -- step 6: use a cte to get employees with status counts
    with employeestatuscounts as (
		select status, count(*) as count
        from employee
        group by status
	)
    select * from employeestatuscounts;
    
    -- step 7: use a cte to delete inactive employees
    with inactiveemployees as (
		select id
        from employee
        where active = 0
	)
    delete from employee
    where id in (select id from inactiveemployees);
    
    -- example 2: product management system with cte
    -- step 3: use a cte to get  available products
    with availableproducts as (
		select id,name,price,stock
        from products
        where stock > 0
	)
    select * from availableproducts;
    
    -- step 4: use a cte to calculate total invertory value
    with inventoryvalue as (
		select sum(price * stock) as total_value
        from products
	)
    select * from inventoryvalue;
    
    -- step 5: use a cte to get products below a certain stock level
    with lowstockproducts as (
		select id,name,stock
        from products
        where stock < 5
	)
    select * from lowstockproducts;
    
    -- step 6: use a cte to get products by category
    with productsbycategory as (
		select category,count(*) as count
        from products
        group by category
	)
    select * from productsbycategory;
    set sql_safe_updates = 0;
    -- step 7: use a cte to delete products with zero stock
    with outofstockproducts as (
		select id
        from products
        where stock = 0
	)
    delete from products
    where id in (select id from outofstockproducts);
    
    -- example 3: order management system with cte
    -- step 3: use a cte to get order summary
    with ordersummary as (
		select o.id, o.customer_name, p.name as product_name, o.quantity, o.order_date
        from orders o
        join products p on o.product_id = p.id
	)
    select * from ordersummary;
    
    -- step 4: use a cte to calculate total sales by product
    with totalsales as (
		select p.name as product_name, sum(o.quantity) as total_quantity
        from orders o
        join products p on o.product_id = p.id
        group by p.name
	)
    select * from totalsales;
    
    -- step 5: use a cte to get orders by customer
    with ordersbycustomer as (
		select customer_name,count(*) as order_count
        from orders
        group by customer_name
	)
    select * from ordersbycustomer; 
    
    -- step 6: use a cte to get orders with total amounts
    with orderamounts as (
		select o.id, o.customer_name, sum(p.price * o.quantity) as total_amount
        from orders o
        join products p on o.product_id = p.id
        group by o.id, o.customer_name
	)
    select * from orderamounts;
    
    -- step 7: use a cte to delete orders older than a certain date
    with oldorders as (
		select id 
        from orders
        where order_date < '2023-01-01'
	)
    delete from orders
    where id in (select id from oldorders);
   