select * from railway_stats

-- 1) What are the most popular railway routes?
select
	departure_station
	,arrival_destination
	,count(*) as nb_transfers
from railway_stats
group by 1,2
order by 3 desc
limit 5;

/* The result: most popular railway routes are:
1) Manchester Piccadilly - Liverpool Lime Street
2) London Euston - Birmingham new Street
3) London Kings Cross - York 
4) London Paddington - Reading
5) London St Pancras - Birmingham new Street 
*/ 


-- 2) What are the rush hours for train journey? 
with passengers_by_hour as
(select
	hour(Departure_Time) as dep_hour
	,hour(Actual_Arrival_Time) as arr_hour
	,count(*) as nb_passengers
from railway_stats
where Journey_Status not in ('Cancelled')
group by 1,2
),
avg_passengers as
(select 
	avg(nb_passengers) as avg_ps 
	from passengers_by_hour 
)
select 
	ph.dep_hour
	,ph.arr_hour
	,ph.nb_passengers
from passengers_by_hour ph
cross join avg_passengers ap
where ph.nb_passengers > ap.avg_ps * 1.5
order by ph.nb_passengers desc;

/* The result: Based on number of passengers, there can determined busiest or rush hours: 
 	- in the morning: 6:00 - 7:00 am (1669 passengers) 
 	- in the afternoon: 6:00 - 7:00 pm (1792 passengers) 
 	
Knowing that, it can help in planning train schedules and reducing overcrowding in the future.

In this query, I compared each of hour's passenger count to the average number. 
That's why I used CROSS JOIN which combines every row from first CTE with the single value as a result from second CTE. 
In order to find the busiest hours during a day, I've applied a condition that a time slot had 1.5 times more passengers than the average - then I marked it as a rush hour.
*/


-- 3) How do ticket type and class impact total revenue?
select
	sum(price) as total_profit
	,ticket_class
	,ticket_type
from railway_stats
group by 2,3
order by 1 desc;

/* The result:
Standard Advance tickets generate the highest revenue (242,388 £) - passengers prefer booking in advance in standard class for lower fares.
Both Off-Peak and Anytime ticket types generate similar revenue in each class, with a preference to Off-Peak tickets - there are usually cheaper than Anytime ones.
*/

-- 4) Punctuality analysis - are train journeys on-time?
select 
	journey_status
	,count(*) as nb_transfers
	,round((count(*) / sum(count(*)) over () ) * 100, 2) as percentage
from railway_stats
group by 1;

/* The result: an overall situation looks very good - almost 87% of all the transfers were on time. Delayed transfers are 7.24 %. 
   Here, to calculate a percentage, I've compared sum of each journey status with total number of transfers ( SUM(COUNT(*)) OVER () ) 
 */
	
-- reasons for delay
select
	count(*) as nb_transfers
	,journey_status
	,reason_for_delay
from railway_stats
where Journey_Status not in ('Cancelled') and Arrival_Time <> Actual_Arrival_Time -- unpopular way to define delayed transfers
group by 2,3
order by 1 desc;

/* the result: The top 3 causes of delays are:
- Weather conditions
- Technical issues
- Signal failures 

Attention - during analysis I noticed that in the column reason_for_delay, there are two values: weather conditions and weather, which would be combined. 
Nevertheless, it doesn't change the result.
*/
