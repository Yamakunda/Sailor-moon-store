DROP DATABASE IF EXISTS SailorMoonStore;
CREATE DATABASE SailorMoonStore;
USE SailorMoonStore;

CREATE TABLE Employee 
(	id 				INT AUTO_INCREMENT	PRIMARY KEY,
	name 			VARCHAR(20) 	NOT NULL, 
	bdate			DATE,
	address			VARCHAR(255),
	start_date		DATE,
	salary			INT,
	region_id 		INT,
	branch_no		INT,
	supervisor_id	INT
);
CREATE TABLE Employee_Email 
(	
	emp_id		INT				NOT NULL,	
	email		VARCHAR(50) 	NOT NULL,
	CONSTRAINT 	pk_emp_email	PRIMARY KEY (emp_id, email),
	CONSTRAINT	fk_emp_email_id FOREIGN KEY (emp_id)
				REFERENCES Employee(id) 
				ON DELETE CASCADE
);
CREATE TABLE Employee_Phone 
(	
	emp_id 		INT				NOT NULL,
	phone		CHAR(12) 		NOT NULL,
	CONSTRAINT 	pk_emp_phone	PRIMARY KEY (emp_id, phone),
	CONSTRAINT 	fk_emp_phone_id 	FOREIGN KEY (emp_id)
				REFERENCES Employee(id) 
				ON DELETE CASCADE

);
CREATE TABLE Manager 
(	
	mgr_id				INT 			PRIMARY KEY,	
	mgr_skill			VARCHAR(50),
	mgr_qualification	VARCHAR(50),
	CONSTRAINT			fk_emp_mgr_id	FOREIGN KEY (mgr_id)
						REFERENCES Employee(id) 
						ON DELETE CASCADE
);
CREATE TABLE Accountant
(	
	acct_id 			INT 			PRIMARY KEY,
	acct_certificate	VARCHAR(50),
	CONSTRAINT			fk_emp_acct_id 	FOREIGN KEY (acct_id)
						REFERENCES Employee(id) 
						ON DELETE CASCADE
);
CREATE TABLE Salesman
(	
	salesman_id			INT 			PRIMARY KEY,
	salesman_mktg_skill	VARCHAR(50),
	CONSTRAINT			fk_emp_salesman_id 		FOREIGN KEY (salesman_id)
						REFERENCES Employee(id) 
						ON DELETE CASCADE
);
CREATE TABLE Shipper
(
	shipper_id		INT 				PRIMARY KEY,
	driver_license	VARCHAR(10),
	CONSTRAINT		fk_emp_shipper_id 	FOREIGN KEY (shipper_id)
					REFERENCES Employee(id) 
					ON DELETE CASCADE
);

CREATE TABLE Region
(
	id 				INT AUTO_INCREMENT 		PRIMARY KEY,
	name			VARCHAR(20),
	area			DECIMAL(10, 2)
);
CREATE TABLE Branch
(	region_id 	INT			NOT NULL,
	number 		INT			NOT NULL,
	mgr_id 		INT,
	name 		VARCHAR(20),
	address		VARCHAR(50),
	phone 		CHAR(12),
	CONSTRAINT 	pk_branch 			PRIMARY KEY (region_id, number),
	CONSTRAINT	fk_branch_region 	FOREIGN KEY (region_id)
				REFERENCES Region(id)
				ON DELETE CASCADE,
	CONSTRAINT	fk_branch_manager	FOREIGN KEY (mgr_id)
				REFERENCES Manager(mgr_id) 
);

CREATE TABLE Supplier
(
	id			INT AUTO_INCREMENT 		PRIMARY KEY,
	name 		VARCHAR(20),
	address		VARCHAR(255),
	phone 		VARCHAR(13)	
);
CREATE TABLE Branch_Supplier
(	region_id 		INT			NOT NULL,
	branch_no 		INT			NOT NULL,
	sup_id			INT			NOT NULL,
	CONSTRAINT 		pk_branch_supplier 	PRIMARY KEY (region_id, branch_no, sup_id),
	CONSTRAINT		fk_brsup_branch		FOREIGN KEY (region_id, branch_no)
					REFERENCES Branch(region_id, number)
					ON DELETE CASCADE,
	CONSTRAINT		fk_brsup_supplier   FOREIGN KEY (sup_id)
					REFERENCES Supplier(id) 
					ON DELETE CASCADE
);

CREATE TABLE Category
(	
	id				INT AUTO_INCREMENT 		PRIMARY KEY,
	name			VARCHAR(20) 	NOT NULL,
	descr			VARCHAR(255)
);
CREATE TABLE Orders
(	
	id				INT AUTO_INCREMENT 		PRIMARY KEY,
	order_time 		DATETIME,
	region_id		INT,
	branch_no		INT,
	salesman_id		INT,
	shipper_id		INT,
	dlvr_start		DATETIME,
	dlvr_end		DATETIME,
	cus_id			INT,
	order_status	VARCHAR(20),
	CONSTRAINT		fk_order_branch		FOREIGN KEY (region_id, branch_no)
					REFERENCES Branch(region_id, number),
	CONSTRAINT		fk_order_saleman 	FOREIGN KEY (salesman_id )
					REFERENCES Salesman(salesman_id),
	CONSTRAINT		fk_order_shipper	FOREIGN KEY (shipper_id)
					REFERENCES Shipper(shipper_id) 
);

CREATE TABLE Product
(	id 			INT AUTO_INCREMENT 		PRIMARY KEY,
	sup_id		INT,
	category_id	INT,
	name		VARCHAR(20)	 	NOT NULL,
	price		INT 			NOT NULL,
	size		VARCHAR(20),
	color		VARCHAR(20),
	material	VARCHAR(20),
	quantity	INT,
	CONSTRAINT 	fk_pro_supplier		FOREIGN KEY (sup_id)			
				REFERENCES Supplier(id),
	CONSTRAINT 	fk_pro_category		FOREIGN KEY (category_id)			
				REFERENCES Category(id)	
		
);
CREATE TABLE Branch_Product 
(
	region_id		INT,
	branch_no		INT,
	product_id		INT,
	CONSTRAINT		pk_branch_product	PRIMARY KEY (region_id, branch_no, product_id),
	CONSTRAINT		fk_brpro_branch		FOREIGN KEY (region_id, branch_no)
					REFERENCES Branch(region_id, number),
	CONSTRAINT		fk_brpro_product	FOREIGN KEY (product_id)
					REFERENCES Product(id)
);

CREATE TABLE Order_Detail
(	
	product_id 		INT,
	order_id 		INT,
	unit_price		INT NOT NULL,
	quantity		INT NOT NULL,
	promo_amount	INT	NOT NULL,
	CONSTRAINT 		pk_order_detail 	PRIMARY KEY (product_id ,order_id ),
	CONSTRAINT		fk_odetail_order 	FOREIGN KEY (order_id )
					REFERENCES Orders (id) 
					ON DELETE CASCADE,
	CONSTRAINT		fk_odetail_product	FOREIGN KEY (product_id)
					REFERENCES Product(id) 
					ON DELETE CASCADE
);
CREATE TABLE Bill
(	id				INT AUTO_INCREMENT 		PRIMARY KEY,
	order_id		INT,
	acct_id 		INT,
	issue_time		DATETIME,
	dlvr_time		DATETIME,
	dlvr_fee		INT,
	dlvr_address_street		VARCHAR(50),
	dlvr_address_district	VARCHAR(50),
	dlvr_address_city		VARCHAR(50),
	CONSTRAINT		fk_bill_order 		FOREIGN KEY (order_id)
					REFERENCES Orders(id),
	CONSTRAINT		fk_bill_accountant	FOREIGN KEY (acct_id)
					REFERENCES Accountant (acct_id) 
);
CREATE TABLE Promotion
(	id			INT AUTO_INCREMENT PRIMARY KEY,
	start_time	DATETIME,
	end_time	DATETIME,
	promo_type	CHAR(1),
	promo_value INT,
	descr 		VARCHAR(50)
);
CREATE TABLE Promotion_Product
(	promo_id		INT,
	product_id		INT,
	CONSTRAINT 		pk_promo_product 		PRIMARY KEY (promo_id, product_id),
	CONSTRAINT		fk_promprod_promotion 	FOREIGN KEY (promo_id)
					REFERENCES Promotion (id) 
					ON DELETE CASCADE,
	CONSTRAINT		fk_promprod_product		FOREIGN KEY (product_id)
					REFERENCES Product(id) 
);

CREATE TABLE Customer
(	
	id 			INT AUTO_INCREMENT 	PRIMARY KEY,
	name		VARCHAR(20) 	NOT NULL
);
CREATE TABLE Customer_Email
(	cus_id		INT 			NOT NULL,
	email		VARCHAR(50)		NOT NULL,
	CONSTRAINT	pk_cus_email	PRIMARY KEY (cus_id, email),
	CONSTRAINT	fk_cus_email	FOREIGN KEY (cus_id)
				REFERENCES	Customer(id)
				ON DELETE CASCADE
);
CREATE TABLE Customer_Address
(	
	cus_id				INT 		 NOT NULL,
	address_street		VARCHAR(255) NOT NULL,
	address_district	VARCHAR(255) NOT NULL,
	address_city		VARCHAR(255) NOT NULL,
	CONSTRAINT	pk_cus_address	PRIMARY KEY (cus_id, address_street, address_district, address_city),
	CONSTRAINT	fk_cus_address	FOREIGN KEY (cus_id)
				REFERENCES		Customer(id)
				ON DELETE CASCADE
);
CREATE TABLE Customer_Phone
(	
	cus_id		INT 			NOT NULL,
	phone		CHAR(12)		NOT NULL,
	CONSTRAINT	pk_cus_phone	PRIMARY KEY (cus_id, phone),
	CONSTRAINT	fk_cus_phone	FOREIGN KEY (cus_id)
				REFERENCES		Customer (id)
				ON DELETE CASCADE
);
CREATE TABLE Membership_Level
(	
	level			VARCHAR(10)	PRIMARY KEY,
	benefit			VARCHAR(20),
	min_point		INT			NOT NULL,	
	max_point		INT			NOT NULL,
	discount_amount	INT			NOT NULL
);
CREATE TABLE Membership_Card
(	
	card_id				INT AUTO_INCREMENT PRIMARY KEY,
	cus_id				INT			NOT NULL,
	card_point			INT			NOT NULL,
	registration_date	DATE,	
	card_level			VARCHAR(10)	NOT NULL,
	CONSTRAINT			fk_memcard_cus		FOREIGN KEY (cus_id)
						REFERENCES			Customer(id)
						ON DELETE CASCADE,
	CONSTRAINT			fk_memcard_level	FOREIGN KEY (card_level)
						REFERENCES			Membership_Level (level)
);
CREATE TABLE Review
(	id				INT AUTO_INCREMENT PRIMARY KEY,
	cus_id			INT			NOT NULL,
	pro_id			INT			NOT NULL,
	time			DATETIME	NOT NULL,
	content			VARCHAR(255) NOT NULL,
	rating			INT			NOT NULL,
	CONSTRAINT		fk_review_cus	FOREIGN KEY (cus_id)
					REFERENCES		Customer(id),
	CONSTRAINT		fk_review_pro	FOREIGN KEY (pro_id)
					REFERENCES		Product(id)
					ON DELETE CASCADE
);
ALTER TABLE Employee 
ADD CONSTRAINT	fk_emp_region_branch	FOREIGN KEY (region_id, branch_no)
				REFERENCES Branch(region_id, number);

ALTER TABLE Employee
ADD CONSTRAINT	fk_emp_super			FOREIGN KEY (supervisor_id) 
				REFERENCES Employee(id);

ALTER TABLE Orders
ADD CONSTRAINT	fk_order_customer	FOREIGN KEY (cus_id)
				REFERENCES Customer(id);
                
DELIMITER $$
CREATE TRIGGER check_bdate
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF YEAR(CURDATE()) - YEAR(NEW.bdate) <= 18 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The employee must be over 18 years old.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_email
BEFORE INSERT ON Employee_Email
FOR EACH ROW
BEGIN
    IF NOT (NEW.email REGEXP '^[^@]+@[^@]+\.[^@]{2,}$') THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The email must be in a valid format.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_customer_email
BEFORE INSERT ON Customer_Email
FOR EACH ROW
BEGIN
    IF NOT (NEW.email REGEXP '^[^@]+@[^@]+\.[^@]{2,}$') THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The email must be in a valid format.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_promotion_date
BEFORE INSERT ON Promotion
FOR EACH ROW
BEGIN
    IF NEW.start_time >= NEW.end_time THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The start time must be less than the end time.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_start_date
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.bdate >= NEW.start_date THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The birth date must be less than the start date.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_delivery_time
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.dlvr_start >= NEW.dlvr_end THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The delivery start time must be less than the delivery end time.';
    END IF;
END$$
DELIMITER ;

