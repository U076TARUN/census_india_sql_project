 select * from d2;
  select * from d1;
-- order by district asc;

-- no. of rows in both table

select count(*) as Numberofrows from d1 ;
select count(*) as Numberofrows from d2 ;

-- data set for jharkhand and bihar 

select * from d1 
where state in ('jharkhand' ,'bihar')
order by district asc;

-- Total population of India

select sum(Population) AS population  from d2;

-- avg growth of country

select avg(growth) as avg_growth from d1 ;

-- avg growth of state 
select state , avg(growth) from d1 
group by state
order by avg(growth) asc ;

-- avg sex ratio of states
select state , round(avg(Sex_Ratio),0) as Avg_sex_ratio from d1 
group by state
order by Avg_sex_ratio desc ;

-- avg litreracy ratio of states
select state , round(avg(literacy),0) as Avg_literacy_ratio from d1 
group by state
having Avg_literacy_ratio > 90
order by Avg_literacy_ratio  desc ;

-- top 3 states with highest sex ratio
select state , round(avg(Sex_Ratio),0) as Avg_sex_ratio from d1 
group by state 
order by Avg_sex_ratio desc
limit 3 ;

-- bottom 3 state with lowest literacy 
select state , round(avg(literacy),0) as Avg_literacy_ratio from d1 
group by state
order by Avg_literacy_ratio  asc 
limit 3;

-- create table
drop table if exists top3states; 
create table top3states 
( states varchar(255),
topstates float ) ;
insert into top3states
select state , round(avg(literacy),0) as Avg_literacy_ratio from d1 
group by state
order by Avg_literacy_ratio  desc
limit 3 ;
-- select * from top3states;

drop table if exists bottom3states; 
create table bottom3states 
( states varchar(255),
bottomstates float ) ;
insert into bottom3states
select state , round(avg(literacy),0) as Avg_literacy_ratio from d1 
group by state
order by Avg_literacy_ratio  asc
limit 3 ;
 select * from bottom3states;
 
 -- union
  select * from bottom3states
  union
  select * from top3states;

-- distinct states starts with letter a
select distinct state
 from d1 
 where state like 'a%' or state like '%a'
 order by state asc;
 
 -- total no. of males and females in a state
  select * from d2;
  select * from d1;
select d.state , sum(d.males) as total_males,sum(d.female) as total_female from
( select c.state ,c.district , c.population , c.sex_ratio, 
  (c.population/(c.sex_ratio + 1 )) as males 
  ,(c.population -(c.population/(c.sex_ratio + 1 ))  ) as female 
  from
(select d2.state ,d2.District, d2.population,d1.Sex_Ratio/1000 as sex_ratio
from 
d2 inner join d1
on d1.District = d2.District 
order by d2.state asc) as c) as d 
group by d.state;

-- literacy rate of states 
select d.state , round(sum(d.total_illiterate_pop),0) as total_illiterate_pop,round(sum(d.total_litterate_pop),0) as total_litterate_pop from
( select c.state ,c.district , c.population , 
c.Literacy_ratio*c.Population as total_litterate_pop ,
(1-c.Literacy_ratio)*c.Population as total_illiterate_pop
  from
(select d2.state ,d2.District, d2.population,d1.Literacy/100 as literacy_ratio
from 
d2 inner join d1
on d1.District = d2.District 
) as c) as d 
group by d.state
order by d.state;

-- previos census population of states 
drop table if exists previous_census;
create table previous_census
(state varchar(255) , pcp int , ccp int );
 insert into previous_census select * from
(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) as current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) as previous_census_population,d.population as current_census_population from
(select a.district,a.state,a.growth as growth,b.population from d1 as a inner join d2 as b on a.district=b.district) as d) as e
group by e.state) as f;

-- conclusion every derived table must have its own alias ... like f

-- population vs area

select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from d1 as a inner join d2 as b on a.district=b.district) as d) as e
group by e.state) as m) as n) as q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from d2) as z) as r on q.keyy=r.keyy) as g











 