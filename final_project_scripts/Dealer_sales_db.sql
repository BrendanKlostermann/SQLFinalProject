/* 
	Dealership sales database
    Name:	dealer_sales_db
	Author: Brendan Klostermann
    Description: Final project for relational databses and mysql
*/

DROP DATABASE IF EXISTS dealer_sales_db;
CREATE DATABASE dealer_sales_db;
USE dealer_sales_db;

DROP TABLE IF EXISTS PayType;
CREATE TABLE PayType(
	PayTypeID	int			primary key auto_increment,
    PayType		varchar(25) not null
);

DROP TABLE IF EXISTS Vehicle;
CREATE TABLE Vehicle(
	VehicleID	int			primary key auto_increment,
    Make		varchar(25)	not null,
    Model		varchar(25)	not null,
    SubModel	varchar(20)	null,
    ModelYear	char(4)		not null,
    Cost		decimal(9,2)		not null,
    ServiceCost	decimal(9,2)		null,
    Mileage		int			not null,
    Vin			varchar(20)	not null,
    BodyStyle	varchar(20)	not null
);

DROP TABLE IF EXISTS ZipCode;
CREATE TABLE	ZipCode(
	ZipCode		int			primary key,
    City		varchar(30)	not null,
    State		varchar(30)	not null
);

DROP TABLE IF EXISTS Location;
CREATE TABLE	Location(
	LocationID	int			primary key auto_increment,
    ZipCode		int			not null,
    StreetAddress	varchar(30) not null,
    LocationName	varchar(25) not null,
    PhoneNumber		varchar(15) not null,
    
    
    CONSTRAINT fk_Location_ZipCode FOREIGN KEY(ZipCode)
		REFERENCES	ZipCode(ZipCode)
        on delete cascade
);

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
	CustomerID	int			primary key auto_increment,
    FirstName	varchar(30)	not null,
    LastName	varchar(30) not null,
    PhoneNumber	varchar(15) not null,
    EmailAddress	varchar(30) not null,
    ZipCode		int			not null,
    
    CONSTRAINT fk_Customer_ZipCode FOREIGN KEY(ZipCode)
		REFERENCES	ZipCode(ZipCode)
        on delete cascade
);

DROP TABLE IF EXISTS FactoryOptions;
CREATE TABLE FactoryOptions(
	FactoryOptions	int		primary key auto_increment,
    VehicleID		int		not null,
    EngineSize		varchar(5)	not null,
    CylinderCount	int		not null,
    Transmission	varchar(15)	not null,
    DriveLine		varchar(20) not null,
    InteriorMaterial	varchar(20) not null,
    InteriorColor	varchar(20)	not null,
    ExteriorColor	varchar(20) not null,
        
    CONSTRAINT fk_FactoryOptions_VehicleID FOREIGN KEY(VehicleID)
		REFERENCES	Vehicle(VehicleID)
        on delete cascade
);


DROP TABLE IF EXISTS DealerAddedOptions;
CREATE TABLE DealerAddedOptions(
	DealerAddOnsID	int		primary key auto_increment,
    VehicleID		int		not null,
    RustPreventionCost	decimal(9,2)	null,
    ServicePackCost		decimal(9,2)	null,
    InteriorProtectionPack	decimal(9,2)	null,
    OffRoadPackCost		decimal(9,2)	null,
    AccessoriesCost		decimal(9,2)	null,
        
    CONSTRAINT fk_DealerAddedOptions_VehicleID FOREIGN KEY(VehicleID)
		REFERENCES	Vehicle(VehicleID)
        on delete cascade
);

DROP TABLE IF EXISTS Salesman;
CREATE TABLE Salesman(
	SalesmanID		int	primary key auto_increment,
    FirstName		varchar(30) not null,
    LastName		varchar(30) not null,
    PhoneNumber		varchar(15)	not null,
    EmailAddress	varchar(30) not null,
    LocationID		int			not null,
  
	CONSTRAINT fk_Salesman_LocationID FOREIGN KEY(LocationID)
		REFERENCES	Location(LocationID)
        on delete cascade
);

DROP TABLE IF EXISTS SaleRecord;
CREATE TABLE SaleRecord(
	SaleID		int	primary key auto_increment,
    LocationID	int	not null,
    PayTypeID	int not null,
    SalesmanID	int	not null,
    VehicleID	int	not null,
    TradeIn		bool	null,
    SalePrice	decimal(9,2)	not null,
    
    CONSTRAINT fk_SaleRecord_LocationID FOREIGN KEY(LocationID)
		REFERENCES	Location(LocationID)
        on delete cascade,
	CONSTRAINT fk_SaleRecord_PayTypeID FOREIGN KEY(PayTypeID)
		REFERENCES	PayType(PayTypeID)
        on delete cascade,
	CONSTRAINT fk_SaleRecord_SalesmanID FOREIGN KEY(SalesmanID)
		REFERENCES	Salesman(SalesmanID)
        on delete cascade,
	CONSTRAINT fk_SaleRecord_VehicleID FOREIGN KEY(VehicleID)
		REFERENCES	Vehicle(VehicleID)
        on delete cascade
);

DROP TABLE IF EXISTS CustomerSale;
CREATE TABLE CustomerSale(
	CustomerID	int		not null,
    SaleID		int 	not null,
    
    CONSTRAINT pk_CustomerSale PRIMARY KEY(CustomerID, SaleID)
    on delete cascade,
    CONSTRAINT fk_CustomerSale_CustomerID FOREIGN KEY(CustomerID)
		REFERENCES	Customer(CustomerID)
        on delete cascade,
	CONSTRAINT fk_CustomerSale_SaleID FOREIGN KEY(SaleID)
		REFERENCES	SaleRecord(SaleID)
        on delete cascade
);

DROP TABLE IF EXISTS TradeIn;
CREATE TABLE TradeIn(
	TradeInID	int		primary key auto_increment,
    SaleID		int		not null,
    TradeInValue	decimal(9,2) null,
    Make		varchar(15)		not null,
    Model		varchar(25)		not null,
    VIN			char(17)	not null,
    
    CONSTRAINT fk_TradeIn_SaleID FOREIGN KEY(SaleID)
		REFERENCES	SaleRecord(SaleID)
);


Drop table if exists sales_audit;
create table sales_audit(
	saleid		int 		not null,
    vehicleid	int			not null,
    action_type varchar(50)	not null,
    action_date	datetime 	not null,
    action_user	varchar(100)	not null
);

drop table if exists vehicle_audit;
create table vehicle_audit(
	vehicleid	int		not null,
    action_type	varchar(50) not null,
    action_date	datetime	not null,
    action_user	varchar(100) not null
);

drop table if exists customer_audit;
create table customer_audit(
	customerid	int		not null,
    action_type	varchar(50) not null,
    action_date	datetime	not null,
    action_user	varchar(100) not null
);