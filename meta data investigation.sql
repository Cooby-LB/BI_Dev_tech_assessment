
--############################################################
-- investigate meta data customers
--############################################################


select top 10 * from [dbo].[m_customers]

-- check customer ID string length and uniqueness
select 
len([Customer ID]) as character_length, 
count(*) as records,
count(distinct [Customer ID]) as distinct_customer_id
from [dbo].[m_customers]
group by len([Customer ID])


-- check customer name string length
select 
len([Customer Name]) as character_length, 
count(*) as records,
count(distinct [Customer Name]) as distinct_customer_name
from [dbo].[m_customers]
group by len([Customer Name])


-- check customer cell string length and uniqueness
select 
len([Customer Cell]) as character_length, 
count(*) as records,
count(distinct [Customer Cell]) as distinct_customer_name
from [dbo].[m_customers]
group by len([Customer Cell])
-- exception processing for string lengths greater than 9 characters

-- check customer ID string exceptions greater than 9 characters
select 
[Customer Cell]
from [dbo].[m_customers]
where len([Customer Cell]) <> 9
order by len([Customer Cell]) desc



-- check customer ID string exceptions equal to 9 characters
select 
distinct left([Customer Cell],2)
from [dbo].[m_customers]
where len([Customer Cell]) = 9
order by len([Customer Cell]) desc
-- output shows no international code


--############################################################
-- investigate meta data pick up points
--############################################################


select top 10 * from [dbo].[m_pickuppoints]


-- check pickup point id string length and uniqueness
select
len([Pickup Point ID]) as character_length, 
count(*) as records,
count(distinct [Pickup Point ID]) as distinct_pickpoint
from [dbo].[m_pickuppoints]
group by len([Pickup Point ID])


-- check [Suburb] string length and uniqueness
select
len([Suburb]) as character_length, 
count(*) as records,
count(distinct [Suburb]) as distinct_suburb
from [dbo].[m_pickuppoints]
group by len([Suburb])


-- check [Province] string length and uniqueness
select
len([Province]) as character_length, 
count(*) as records,
count(distinct [Province]) as distinct_province
from [dbo].[m_pickuppoints]
group by len([Province])


-- check [Province] string uniqueness
select
[Province] , 
count(*) as records,
count(distinct [Province]) as distinct_province
from [dbo].[m_pickuppoints]
group by [Province]




-- check [Regional] string length and uniqueness
select
len([Regional]) as character_length, 
count(*) as records,
count(distinct [Regional]) as distinct_regional
from [dbo].[m_pickuppoints]
group by len([Regional])


-- check [Regional] string uniqueness
select
[Regional] , 
count(*) as records,
count(distinct [Regional]) as distinct_regional
from [dbo].[m_pickuppoints]
group by [Regional]




--############################################################
-- investigate meta data parcels
--############################################################


-- general feel for data
select top 10 * from [dbo].[m_parcels]
-- order dates not in date format

-- checking parcel kg datatypes 
select 
ISNUMERIC([Parcel KG]), 
count(*) 
from [dbo].[m_parcels]
group by 
ISNUMERIC([Parcel KG])

-- checking exceptions parcel KG
select 
*
from [dbo].[m_parcels]
where ISNUMERIC([Parcel KG]) = 0


-- checking courier charge datatypes 
select 
ISNUMERIC([Courier Charge]), 
count(*) 
from [dbo].[m_parcels]
group by 
ISNUMERIC([Courier Charge])

-- checking exceptions courier charge
select 
*
from [dbo].[m_parcels]
where ISNUMERIC([Courier Charge]) = 0



-- checking [Sales amount] datatypes 
select 
ISNUMERIC([Sales amount]), 
count(*) 
from [dbo].[m_parcels]
group by 
ISNUMERIC([Sales amount])

-- checking exceptions sales amount
select 
*
from [dbo].[m_parcels]
where ISNUMERIC([Sales amount]) = 0


-- check waybill string length and uniqueness
select
len(Waybill) as character_length, 
count(*) as records,
count(distinct Waybill) as distinct_waybill
from [dbo].[m_parcels]
group by len(Waybill)


-- check waybill string uniqueness
select
Waybill , 
len(Waybill) as string_length,
count(*) as records,
count(distinct Waybill) as distinct_waybill
from [dbo].[m_parcels]
where len(Waybill) <> 13
group by Waybill
order by len(Waybill) desc
-- waybill exceptions to be performed based on string length, and/or prefix and suffix
