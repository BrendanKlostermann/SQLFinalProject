/* 
	Dealership sales database
    Name:	insert_dealer_sales_db
	Author: Brendan Klostermann
    Description: Final project for relational databses and mysql
    insert statements for the dealer_sales_db
*/

use dealer_sales_db;

insert into PayType
	(paytype)
values
	('cash'),
    ('bank loan'),
    ('manufacturer finance')
;

insert into Vehicle
	(make, model, submodel, modelyear, cost, servicecost, mileage, vin, bodystyle)
values
	('Chevy','Camaro','SS','2017',25000.00,350.00,45321,'8dj2lajd93nahd73k','Coupe'),
    ('GMC','Sierra','SLT','2002',5000.00,1375,00,135423,'1jd93l2ka92hakdlw','Truck'),
    ('Ford','Mustange','GT','2015',20000.00,1500.00,64921,'9djahsue832la72na','Coupe'),
    ('Pontiac','Vibe',null,'2005',2325.65,1200.00,178234,'8sh2ial4ba8dl2j37','HatchBack'),
    ('Toyota','Celica','GT','2001',2200.00,1754,32,145823,'8shblsh73la72nf93','Coupe'),
    ('Honda','Civic','SI','2011',5675.00,1243.84,127345,'8dhfa54n928akld62','Coupe')
;

insert into ZipCode
	(zipcode, city, state)
values
	(52302,'Marion','Iowa'),
    (52402,'Cedar Rapids','Iowa'),
    (52240,'Iowa City','Iowa'),
    (52317,'North Liberty','Iowa'),
    (52328,'Robins','Iowa'),
    (60007,'Chicago','Illinois')
;

insert into Location
	(ZipCode,StreetAddress,LocationName,PhoneNumber)
values
	(52402,'123 c ave ne','Chevy Sales', '319-377-5554'),
    (52302,'543 b street','Marion auto sales','319-555-2345'),
    (52402,'8675 northern st se','Rapid auto sales','319-327-4654'),
    (60007,'1246 27th St', 'Chicago auto sales','319-285-2940'),
    (52328,'987 south lane', '1A Auto sales','319-129-2947')
;

insert into Customer
	(FirstName,LastName,PhoneNumber,EmailAddress,ZipCode)
values
	('Brendan','Klostermann','319-720-5011','brendan.klostermann@gmail.com',52402),
    ('Dale','Smith','319-543-2893','dale.smith@yahoo.com',52302),
    ('Sarah','Stark','319-623-1984','sarah.stark@hotmail.com',60007),
    ('Jesus','Christ','319-656-2095','jesus.christ@gmail.com',52302),
    ('Jeremiah','Clark','319-029-3829','jeremiah_clark@gmail.com',52402)
;

insert into FactoryOptions
	(VehicleID,EngineSize,CylinderCount,Transmission,DriveLine,InteriorMaterial,InteriorColor,ExteriorColor)
values
	(1,'6.2',8,'Manual','RWD','Cloth','Gray','Gray'),
    (2,'5.3',8,'Automatic','4x4','Cloth','Gray','Green'),
    (3,'5.0',8,'Automatic','RWD','Leather','Gray','White'),
    (4,'2.4',4,'Automatic','FWD','Cloth','Black','Red'),
    (5,'1.8',4,'Automatic','FWD','Leather','Gray','Yellow'),
    (6,'2.0',4,'Manual','FWD','Cloth','Red','Red')
;

insert into DealerAddedOptions
	(VehicleID,RustPreventionCost,ServicePackCost,InteriorProtectionPack,OffRoadPackCost,AccessoriesCost)
values
	(1,0.00,225.00,0.00,0.00,0.00),
    (2,350.00,225.00,0.00,0.00,0.00),
    (3,0.00,175.00,0.00,0.00,0.00),
    (4,210.00,0.00,0.00,0.00,0.00),
    (5,0.00,0.00,375.00,0.00,125.00),
    (6,0.00,300.00,0.00,0.00,0.00)
;

insert into Salesman
	(FirstName,LastName,PhoneNumber,EmailAddress,LocationID)
values
	('Sam','Smith','319-284-7283','sam.smith@yahoo.com',3),
    ('Tim','Willmsen','319-823-6728','tim.willmsen@hotmail.com',2),
    ('Terry','Johnson','319-827-4392','terryisthebest@gmail.com',1),
    ('Jebodiah','Casey','319-029-3058','Jebodiah.casey@gmail.com',5),
    ('Clark','Kent','319-482-2093','clark.kent@supermail.com',4),
    ('Jimmy','Wallace','319-203-2058','jimmywallace@yahoo.comm',2),
    ('William','Shakespeare','291-203-2038','greatest.writer@aol.com',3)
;

insert into SaleRecord
	(LocationID,PayTypeID,SalesmanID,VehicleID,TradeIn,SalePrice)
values
	(1,2,5,1,false,27532.54),
    (1,1,3,2,true,7500.23),
    (4,3,2,6,false,11300.98),
    (2,2,6,3,false,24560,87)
;

insert into CustomerSale
	(CustomerID,SaleID)
values
	(1,1),
    (4,2),
    (2,3),
    (3,4)
;

insert into TradeIn
	(SaleID,TradeInValue,Make,Model,VIN)
values
	(2,2453.67,'Subaru','Outback','8d74ksh263jvnskd9')
;




