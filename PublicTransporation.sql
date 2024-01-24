use projects

select * from Public_transportation

-- To display the columns name in the table
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Public_transportation'

--Checking Null Values within the columns
select count(payCardID)  from Public_Transportation where payCardID is null
select count(payCardName)  from Public_Transportation where payCardName is null
select count(corridorID)  from Public_Transportation where corridorID is null
select count(payCardID)  from Public_Transportation where payCardID is null

-- Intial Exploration to alter the columns 
select * from Public_transportation where transID IS NULL
select * from Public_transportation where payCardID IS NULL
select MAX(LEN(payCardBank)) from Public_transportation
select MAX(LEN(payCardName)) from Public_transportation
select distinct(payCardSex) from Public_transportation
select MAX(LEN(corridorID)) from Public_transportation
select MAX(LEN(corridorName)) from Public_transportation
select distinct(direction) from Public_transportation
select MAX(LEN(tapInStops)) from Public_transportation
select MAX(LEN(tapInStopsName)) from Public_transportation
select MAX(LEN(tapOutStops)) from Public_transportation
select MAX(LEN(tapOutStopsName)) from Public_transportation
select MAX(LEN(stopStartSeq)) from Public_transportation
select datediff(Hour,tapInTime,tapOutTime) as 'time for travel' from  Public_transportation
Select stopEndSeq-stopStartSeq as 'Travelled stops' from Public_transportation


--Altering All the columns with suitable data types and memory allocation
alter table Public_transportation alter column transID varchar(20) not null
alter table Public_transportation add constraint pk_transID primary key(transID)
alter table Public_transportation alter column payCardID bigint 
alter table Public_transportation alter column payCardBank varchar(7) 
alter table Public_transportation alter column payCardName varchar(35)
alter table Public_transportation alter column payCardSex varchar(7) 
alter table Public_transportation alter column payCardBirthDate date
alter table Public_transportation alter column corridorID varchar(9)
alter table Public_transportation alter column corridorName varchar(52)
alter table Public_transportation alter column direction varchar(5)
alter table Public_transportation alter column tapInStops varchar(8)
alter table Public_transportation alter column tapInStopsName varchar(43)
alter table Public_transportation alter column tapOutStops varchar(8)
alter table Public_transportation alter column tapOutStopsName varchar(43)
alter table Public_transportation alter column stopStartSeq int
alter table Public_transportation alter column stopEndSeq int
alter table Public_transportation alter column PayAmount Money
alter table Public_transportation add  BirthYear int
alter table Public_Transportation add TravelTime int
alter Table Public_transportation add travelledStops int
--Creating Fare column Based on Travel Time as Payamount column was inaccurate 
--alter table Public_Transportation drop Column payAmount
alter table Public_Transportation add Fareamount money



-- Updating data in some columns for further analysis
update  Public_transportation set  direction='East' where direction=0
update  Public_transportation set  direction='West' where direction=1
update  Public_transportation set  payCardSex='Male' where payCardSex='M'
update  Public_transportation set  payCardSex='Female' where payCardSex='F'
update  Public_transportation set  BirthYear=YEAR(payCardBirthDate)
update Public_Transportation set TravelTime=datediff(MINUTE,tapInTime,tapOutTime)
update Public_transportation set travelledStops = stopEndSeq-stopStartSeq=
--sometimes conversion from int to string gives error so another type of query to update it
UPDATE Public_transportation                                                                   
SET direction = CASE WHEN ISNUMERIC(direction) = 1 AND direction = 1 THEN 'West' ELSE direction END
select distinct direction from Public_transportation
select count(distinct travelledStops) from Public_transportation
--Updating Fare column Based on Travel time
update  Public_Transportation set Fareamount=
case 
when TravelTime<=60 then 3
when TravelTime>60 and TravelTime<=120 then 5 
else 10
end

--Analysis:
select distinct corridorID from Public_transportation 
select distinct corridorName from Public_transportation 
select AVG(Fareamount) as 'Average Fare Amount' from Public_transportation 
select distinct tapInStopsName from Public_transportation
select distinct tapOutStopsName from Public_transportation
select sum(Fareamount) as 'Total Sales' from Public_transportation
select avg(TravelTime) from Public_transportation

select payCardSex,sum(Fareamount) as Sales from Public_transportation 
Group by payCardSex

select payCardBank,sum(Fareamount) as Sales from Public_transportation 
Group by payCardBank

select direction,sum(Fareamount) as Sales from Public_transportation 
Group by direction

select payCardBank,payCardSex,sum(Fareamount) as Sales from Public_transportation 
Group by payCardBank,payCardSex


--Analyze data for patterns in usage, delays, and passenger satisfaction.
--Analyzing Usage Patterns
--Bussiest Corridor
select corridorName, count(*) as Count  from Public_transportation where corridorName is not null
Group by corridorName
Order By Count desc
offset 0 rows
fetch first 10 rows only

--Analyzing Busiest Corridor by Direction:
select top 10 corridorName,direction, count(*) as Count  from Public_transportation where corridorName is not null
Group by direction,corridorName
Order By Count desc

--Bussiest Tap In Stop
select tapInStops,tapInStopsName, count(*) as Count  from Public_transportation 
Group by tapInStops,tapInStopsName
Order By Count desc
offset 0 rows
fetch first 10 rows only

--Bussiest Tapout  Stop
select tapOutStops,tapOutStopsName, count(*) as Count  from Public_transportation where tapOutStopsName is not null
Group by tapOutStops,tapOutStopsName
Order By Count desc
offset 0 rows
fetch first 10 rows only

--Most Common Start and End Stops:
select tapInStopsName,tapOutStopsName, count(*) as Count  from Public_transportation 
Group by tapInStopsName,tapOutStopsName
Order By Count desc
offset 0 rows
fetch first 10 rows only

-- Analyzing Travel time 
select top 10 corridorName, max(TravelTime) AS maxTravelTime from Public_transportation
Group by corridorName
order by maxTravelTime desc

--Most Used PaycardBank
select payCardBank,count(*) as count from Public_transportation
group by payCardBank
order by count desc

--gender usage
select payCardSex,count(*) as count from Public_transportation
group by payCardSex
order by count desc

-- No of stops mostly travelled
select Top 10 travelledStops,count(*) as count  from Public_transportation 
Group by  travelledStops
order by count desc

--With Tap in stop names
select Top 10 travelledStops,tapInStopsName,count(travelledStops) as count from Public_transportation
group by travelledStops,tapInStopsName
order by count desc

--With Tap outstop names
select Top 10 travelledStops,tapOutStopsName,count(travelledStops) as count from Public_transportation
group by travelledStops,tapOutStopsName
order by count desc


--Most Travlled with tap in and tap outstop names
select Top 10 travelledStops,tapInStopsName,tapOutStopsName,count(travelledStops) as count from Public_transportation
group by travelledStops,tapInStopsName,tapOutStopsName
order by count desc

--Adding Satisfaction column for analysis
alter table Public_transportation add SatisfactionScore int
update Public_transportation set SatisfactionScore =
case
when Fareamount<=3 then 1
when Fareamount>3 and Fareamount<=5 then 2
else 3
end

--Analyzing Passenger Satisfaction Patterns
select SatisfactionScore, count(*) as count from Public_transportation
group by SatisfactionScore
order by count desc

--Analyzing Day-of-Week Patterns:
select datename(weekday, tapInTime) AS DayOfWeek, count(*) AS TripsCount from Public_transportation
group by datename(weekday, tapInTime)
order by TripsCount desc

--Analyzing Peak Hours:
select datename(hour, tapInTime) AS DayOfWeek,count(*) AS TripsCount from Public_transportation
group by datename(hour, tapInTime)
order by TripsCount desc






