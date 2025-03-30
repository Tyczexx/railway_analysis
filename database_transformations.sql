RENAME TABLE railway.railway TO railway.railway_stats;

select * from railway.railway_stats 

alter table railway.railway_stats 
rename column `Date of Purchase` 	to `Date_of_Purchase`,
rename column `Time of Purchase` 	to `Time_of_Purchase`,
rename column `Purchase Type`	 	to `Purchase_Type`,
rename column `Date of Purchase` 	to `Date_of_Purchase`,
rename column `Payment Method` 	 	to `Payment_Method`,
rename column `Ticket Class`	 	to `Ticket_Class`,
rename column `Ticket Type` 	 	to `Ticket_Type`,
rename column `Payment Method` 	 	to `Payment_Method`,
rename column `Departure Station` 	to `Departure_Station`,
rename column `Arrival Destination`	to `Arrival_Destination`,
rename column `Date of Journey`	 	to `Date_of_Journey`,
rename column `Departure Time` 	 	to `Departure_Time`,
rename column `Arrival Time`		to `Arrival_Time`,
rename column `Actual Arrival Time`	to `Actual_Arrival_Time`,
rename column `Journey Status`		to `Journey_Status`,
rename column `Reason for Delay`	to `Reason_for_Delay`,
rename column `Refund Request`	 	to `Refund_Request`;
commit;
