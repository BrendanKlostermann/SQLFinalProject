/* 
	Dealership sales database
    Name:	stored_procedures_dealer_sales_db
	Author: Brendan Klostermann
    Description: Final project for relational databses and mysql
    stored procedures for the dealer_sales_db
*/

use dealer_sales_db;

Drop view if exists view_all_customers;
Create view view_all_customers as
	Select 	CustomerID, FirstName, LastName, PhoneNumber, EmailAddress, Customer.ZipCode, ZipCode.City,ZipCode.State
    From	Customer	Join	ZipCode
		On		Customer.ZipCode = ZipCode.ZipCode
    Order By LastName, FirstName
;



Drop view if exists sales_by_SalePrice;
create view sales_by_SalePrice as
	select saleid, locationid,paytypeid, salesmanid, tradein, saleprice
	from	SaleRecord
	Order by salePrice DESC
;


Drop view if exists view_all_sales;
create view view_all_sales as
	select saleid, locationid,paytypeid, salesmanid, tradein, saleprice
	from	SaleRecord
;


drop view if exists view_all_vehicles;
create view view_all_vehicles as
	select vehicleid, make, model, submodel, modelyear, cost, servicecost, mileage, vin, bodystyle
    from vehicle
;




drop trigger if exists sale_audit;
Delimiter $$
create trigger sale_audit
	after insert on salerecord
		for each row
        begin
			insert into sales_audit
				(saleid,vehicleid, action_type, action_date, action_user)
			values
				(new.saleid,new.vehicleid,'inserted',now(),current_user());
end $$
delimiter ;

drop trigger if exists vehicle_audit_insert;
Delimiter $$
create trigger vehicle_audit_insert
	after insert on vehicle
		for each row
        begin
			insert into vehicle_audit
				(vehicleid, action_type, action_date, action_user)
			values
				(new.vehicleid,'inserted',now(),current_user());
end $$
delimiter ;


drop trigger if exists vehicle_audit_update;
Delimiter $$
create trigger vehicle_audit_update
	after update on vehicle
		for each row
        begin
			insert into vehicle_audit
				(vehicleid, action_type, action_date, action_user)
			values
				(new.vehicleid,'updated',now(),current_user());
end $$
delimiter ;


drop trigger if exists vehicle_audit_delete;
Delimiter $$
create trigger vehicle_audit_delete
	after delete on vehicle
		for each row
        begin
			insert into vehicle_audit
				(vehicleid, action_type, action_date, action_user)
			values
				(new.vehicleid,'deleted',now(),current_user());
end $$
delimiter ;


drop trigger if exists customer_audit_add;
Delimiter $$
create trigger customer_audit_add
	after insert on customer
		for each row
        begin
			insert into customer_audit
				(customerid, action_type, action_date, action_user)
			values
				(new.customerid,'inserted',now(),current_user());
end $$
delimiter ;


drop trigger if exists customer_audit_update;
Delimiter $$
create trigger customer_audit_update
	after update on customer
		for each row
        begin
			insert into customer_audit
				(customerid, action_type, action_date, action_user)
			values
				(new.customerid,'updated',now(),current_user());
end $$
delimiter ;


drop trigger if exists customer_audit_delete;
Delimiter $$
create trigger customer_audit_delete
	after delete on customer
		for each row
        begin
			insert into customer_audit
				(customerid, action_type, action_date, action_user)
			values
				(new.customerid,'deleted',now(),current_user());
end $$
delimiter ;




DROP PROCEDURE IF EXISTS view_a_customer;
DELIMITER $$
CREATE PROCEDURE view_a_customer
(
		CustID	int
)
COMMENT 'View customer information based off given customer ID.'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	Select 	FirstName, LastName, PhoneNumber, EmailAddress, Customer.ZipCode, ZipCode.City,ZipCode.State
    From	Customer	Join	ZipCode
		On		Customer.ZipCode = ZipCode.ZipCode
	where CustomerID = CustID
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS update_customer;
DELIMITER $$
CREATE PROCEDURE update_customer
(
			custid		int,
            fname		varchar(30),
            lname		varchar(30),
            phone		varchar(15),
            email		varchar(30),
            zip			int
)
COMMENT 'add a vehicle dealer add ons'
sp: BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    update	customer
    set		firstname = fname,
			lastname = lname,
            phonenumber = phone,
            emailaddress = email,
            zipcode = zip
            
	where	customerid = custid
;
	select 'vehicle has been updated' as message;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS view_a_vehicle;
DELIMITER $$
CREATE PROCEDURE view_a_vehicle
(
		vehid	int
)
COMMENT 'View customer information based off given customer ID.'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	Select 	make, model, submodel, modelyear, cost, servicecost, mileage, vin, bodystyle
    From	vehicle
	where vehicleid = vehid
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS view_a_sale;
DELIMITER $$
CREATE PROCEDURE view_a_sale
(
		Sale_id	int
)
COMMENT 'View a sale information based off the given sale id.'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	select saleid, locationid,paytypeid, salesmanid, tradein, saleprice
	from	SaleRecord
	where saleid = sale_id
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS add_a_sale;
DELIMITER $$
CREATE PROCEDURE add_a_sale
(
			location	int,
            paytype		int,
            vehicle		int,
            trade		boolean,
            price		decimal,
            primarycustomerid	int,
            secondarycustomerid	int
)
COMMENT 'creates a new sale record with user given data.'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	insert into SaleRecord
		(LocationID,PayTypeID,SalesmanID,VehicleID,TradeIn,SalePrice)
	values
		(location,paytype,vehicle,trade,price)
    ;
    insert into customersale
		(customerid,saleid)
	values(primarycustomerid,last_insert_id())
    ;
    if (secondarycustomerid is not null) then
		insert into customersale
			(customerid,saleid)
		values
			(secondarycustomerid,saleid)
		;
	end if;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS add_a_customer;
DELIMITER $$
CREATE PROCEDURE add_a_customer
(
			FName	varchar(30),
            LName	varchar(30),
            PNumber	varchar(15),
            Email	varchar(30),
            Zip		int
)
COMMENT 'creates a new sale record with user given data.'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	insert into SaleRecord
		(FirstName,LastName,PhoneNumber,EmailAddress,ZipCode)
	values
		(FName,LName,PNumber,Email,Zip)
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS view_vehicle_options;
DELIMITER $$
CREATE PROCEDURE view_vehicle_options
(
			vehicle		int
)
COMMENT 'view the facotry options for a vehicle based off the given vehicle id'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	select 	VehicleID,EngineSize,CylinderCount,Transmission,DriveLine,InteriorMaterial,InteriorColor,ExteriorColor
    from	factoryoptions
    where	vehicleid = vehicle
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS view_vehicle_add_ons;
DELIMITER $$
CREATE PROCEDURE view_vehicle_add_ons
(
			vehicle		int
)
COMMENT 'view the facotry options for a vehicle based off the given vehicle id'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	select VehicleID,RustPreventionCost,ServicePackCost,InteriorProtectionPack,OffRoadPackCost,AccessoriesCost,
			(RustPreventionCost + ServicePackCost + InteriorProtectionPack + OffRoadPackCost + AccessoriesCost) as total_cost
    from	dealeraddedoptions
    where	vehicleid = vehicle
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS add_a_vehicle;
DELIMITER $$
CREATE PROCEDURE add_a_vehicle
(
			mk	varchar(25),
            mdl	varchar(25),
            smodel	varchar(20),
            myear	char(4),
            vehiclecost	decimal(9,2),
            servcost	decimal(9,2),
            miles	int,
            vin		varchar(20),
            body	varchar(20)
)
COMMENT 'add a new vehicle into the database'
BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    
	insert into vehicle
		(make, model, submodel, modelyear, cost, servicecost, mileage, vin, bodystyle)	
	values
		(mk, mdl, smodel, myear, vehiclecost, servcost, miles, vin, body)
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS add_vehicle_options;
DELIMITER $$
CREATE PROCEDURE add_vehicle_options
(
			vehid		int,
            engsize		varchar(5),
            cylcount	int,
            trans		varchar(15),
            driveln		varchar(20),
            interiormat	varchar(20),
            intcolor	varchar(20),
            extcolor	varchar(20)
)
COMMENT 'add vehicle facotry options'
sp:BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    if exists(select vehicleid from factoryoptions where vehicleid = vehid) then
		select 'That vehicle already exists' as message;
        leave sp;
    end if;
    
	insert into vehicle
		(VehicleID,EngineSize,CylinderCount,Transmission,DriveLine,InteriorMaterial,InteriorColor,ExteriorColor)	
	values
		(vehid, engsize, cylcount, trans, driveln, interiormat, intcolor, extcolor)
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS update_vehicle_options;
DELIMITER $$
CREATE PROCEDURE update_vehicle_options
(
			vehid		int,
            engsize		varchar(5),
            cylcount	int,
            trans		varchar(15),
            driveln		varchar(20),
            interiormat	varchar(20),
            intcolor	varchar(20),
            extcolor	varchar(20)
)
COMMENT 'add vehicle facotry options'
sp:BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    update	factoryoptions
    set		EngineSize = engsize,
			CylinderCount = cylcount,
			Transmission = trans,
			DriveLine = driveln,
			InteriorMaterial = interiormat,
			InteriorColor = intcolor,
			ExteriorColor = extcolor
	where	vehicleid = vehid
;
	select 'vehicle has been updated' as message;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS add_vehicle_add_ons;
DELIMITER $$
CREATE PROCEDURE add_vehicle_add_ons
(
			vehid		int,
            rustcost	decimal(9,2),
            servicecost	decimal(9,2),
            interiorcost		decimal(9,2),
            offroadcost		decimal(9,2),
            accessorycost	decimal(9,2)
)
COMMENT 'add a vehicle dealer add ons'
sp: BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    if exists(select vehicleid from dealeraddedoptions where vehicleid = vehid) then
		select 'That vehicle already exists' as message;
        leave sp;
    end if;
    
	insert into dealeraddedoptions
		(VehicleID,RustPreventionCost,ServicePackCost,InteriorProtectionPack,OffRoadPackCost,AccessoriesCost)	
	values
		(vehid, rustcost, servicecost, interiorcost, offroadcost, accessorycost)
    ;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS update_vehicle_add_ons;
DELIMITER $$
CREATE PROCEDURE update_vehicle_add_ons
(
			vehid		int,
            rustcost	decimal(9,2),
            servicecost	decimal(9,2),
            interiorcost		decimal(9,2),
            offroadcost		decimal(9,2),
            accessorycost	decimal(9,2)
)
COMMENT 'update a vehicle dealer add ons'
sp: BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    update	dealeraddedoptions
    set		RustPreventionCost = rustcost,
			ServicePackCost = servicecost,
            InteriorProtectionPack = interiorcost,
            OffRoadPackCost = offroadcost,
            AccessoriesCost = accessorycost
	where	vehicleid = vehid
;
	select 'vehicle has been updated' as message;
	
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_vehicle;
DELIMITER $$
CREATE PROCEDURE delete_vehicle
(
			vehid	int
)
COMMENT 'delete a vehicle and any records related'
sp: BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    delete from vehicle
    where vehicleid = vehid
;
	select 'vehicle and all related records deleted' as message;
	
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_customer;
DELIMITER $$
CREATE PROCEDURE delete_customer
(
			custid	int
)
COMMENT 'delete a vehicle and any records related'
sp: BEGIN
	/*
		Author: Brendan Klostermann
		File:	stored_procedures_dealer_sales_db
		
		Modification History
		
		2022-05-02	Brendan Klostermann			Initial Creation
		
	*/
    delete from customer
    where customerid = custid
;
	select 'customer and all related records deleted' as message;
	
END$$
DELIMITER ;