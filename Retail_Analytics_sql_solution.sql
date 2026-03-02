#Data Loading

create schema retail_data;
use retail_data;

alter table marketingcampaign_1763915947648 rename to retail_customer_data;
select * from retail_customer_data;
select Dt_customer from retail_customer_data limit 10;
describe retail_customer_data;

alter table retail_customer_data add column ct_customer_date date;
set sql_safe_updates = 0;
update retail_customer_data set ct_customer_date = str_to_date(Dt_customer, '%d-%m-%Y');
describe retail_customer_data;

Select Dt_Customer, ct_customer_date from retail_customer_data limit 10;


#Data Preprocessing
select * from retail_customer_data;
select count(ID) from retail_customer_data;
#Calculate the total number of customer encounters in the marketing campaign dataset.
select sum(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 +AcceptedCmp4 + AcceptedCmp5) as total_cmp_encounters from retail_customer_data;

#Identify the top 10 most purchased products in the dataset, such as Wines, Meat Products, etc.
select 'Wines' as product, sum(mntWines) as Total_amt from retail_customer_data union all 
select 'Fruits', sum(mntFruits) from retail_customer_data union all select 'Meat Products', sum(mntMeatProducts) from retail_customer_data
union all select 'Fish Products', sum(mntFishProducts) from retail_customer_data union all select 'Sweet Products', sum(mntSweetProducts) 
from retail_customer_data union all select 'Gold Prods', sum(mntGoldProds) from retail_customer_data order by Total_amt DESC limit 10;

#Find the count of response values.
select count(Response) as Responders from retail_customer_data where Response = 1;
select count(Response) as non_responders from retail_customer_data where Response = 0;

#OR
select Response, count(*) as count from retail_customer_data group by Response;

#Determine the distribution of customers based on their education level and marital status.
select Education, count(*) as total_customer from retail_customer_data group by Education;
select Marital_status, count(*) as total_customer from retail_customer_data group by Marital_status;

#Identify the average income of customers who participated in the marketing campaign.

select round(avg(Income),2) as avg_income_participants from retail_customer_data where (AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + 
AcceptedCmp4 + AcceptedCmp5 + Response) > 0;

#Calculate the total number of promotions accepted by customers in each campaign.
select * from retail_customer_data;

select sum(AcceptedCmp1) as Campaign1_Accepted, sum(AcceptedCmp2) as Campaign2_Accepted, sum(AcceptedCmp3) as Campaign3_Accepted,
sum(AcceptedCmp4) as Campaign4_Accepted,sum(AcceptedCmp5) as Campaign5_Accepted, sum(Response) as FinalCampaign_Accepted
from retail_customer_data;

#Identify the distribution of customers' responses to the last campaign.
select Response, count(*) as Last_campaign from retail_customer_data group by Response;

#Calculate the average number of children and teenagers in customers' households.
select avg(Kidhome) as avg_no_of_Kids, avg(Teenhome) as avg_no_of_Teens from retail_customer_data;

#Create an Age column by subtracting year_birth from the current year.
alter table retail_customer_data add column age_final int;
update retail_customer_data set age_final = year(curdate())- Year_Birth;

select age_final, Year_Birth from retail_customer_data limit 10;

#Create Age_group columns based on the below condition:
#WHEN Age BETWEEN 18 AND 25 THEN '18-25'
#WHEN Age BETWEEN 26 AND 35 THEN '26-35'
#WHEN Age BETWEEN 36 AND 45 THEN '36-45'
#WHEN Age BETWEEN 46 AND 55 THEN '46-55'
#ELSE '56+'

alter table retail_customer_data add column age_group varchar(10);
update retail_customer_data set age_group = 
case WHEN age_final BETWEEN 18 AND 25 THEN '18-25'
WHEN age_final BETWEEN 26 AND 35 THEN '26-35'
WHEN age_final BETWEEN 36 AND 45 THEN '36-45'
WHEN age_final BETWEEN 46 AND 55 THEN '46-55'
ELSE '56+' end;

select age_final, age_group from retail_customer_data;

#Determine the average number of visits per month for customers in each age group.
select * from retail_customer_data;

select age_group, round(avg(NumWebVisitsMonth),2) as avg_no_of_visits from retail_customer_data group by age_group;






















