Select * from [Indian census Project].dbo.Data1

Select * from [Indian census Project].dbo.Data2

--number of rows into our dataset 
Select count(*) from [Indian census Project].dbo.Data1
Select count(*) from [Indian census Project].dbo.Data2

--dataset for jharkhand and bihar
Select * From [Indian census Project].dbo.Data1 where State in ('Jharkhand','Bihar')

Delete from [Indian census Project].dbo.Data1 where district is null and
state is null and growth is null and sex_ratio is null
--total population of India
Select sum(population)as total_population from [Indian census Project].dbo.data2

--avg growth by 
Select state,avg(growth)*100 as avg_growth from [Indian census Project].dbo.data1 group by state

--avg sex 
Select state,round(avg(sex_ratio),0) as avg_sex_ratio
from [Indian census Project].dbo.Data1 group by state order by avg_sex_ratio desc

--avg literacy
Select state,round(avg(literacy),0) as avg_literacy from 
[Indian census Project].dbo.Data1 group by state having round(avg(Literacy),0)>90
order by avg_literacy desc

--removing null values

Delete from [Indian census Project].dbo.Data1 where district is Null and state is NUll and
growth is null and sex_ratio is null and literacy is Null

--top 3 showing highest growth ratio
Select top(3)* from [Indian census Project].dbo.Data1 order by growth desc

or 

with grop as(
Select*,
row_number()over(order by growth desc)as rn
from [Indian census Project].dbo.Data1 )
Select * from grop where rn in (1,2,3)

--lowest sex ratio(dadraA)
select top(3)* from [Indian census Project].dbo.Data1 order by sex_ratio asc 
Delete from [Indian census Project].dbo.Data1 where
growth is null and sex_ratio is null and literacy is Null

--top and bottom 3 states in literacy rate-----doubt
Select * from 
(Select top(3)* from [Indian census Project].dbo.Data1 order by Literacy desc)a
Union
Select * from 
(select top(3)* from [Indian census Project].dbo.Data1 order by Literacy asc)a

--States starting with letter a
Select distinct state from [Indian census Project].dbo.Data1 where state like 'a%'

--starting with a end with d
Select distinct state from [Indian census Project].dbo.Data1 where state like 'a%d'

--count no of males and female---female/male=sex ratio,population-males=sex_ratio*males--males=population/(sex_ratio+1)
--female+male=population
--females=population-males,females=population-population/(sexratio+1),(population*sex_ratio)/(sex_ratio+1

--total males and females
Select c.District,c.[State ],c.Population/(c.Sex_Ratio+1) males,(--15 mins)
(c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1)females from
(select a.district,a.[State ],a.Sex_Ratio/1000,b.population from [Indian census Project].dbo.Data1 a inner join
[Indian census Project].dbo.Data2 b on a.District=b.District)c

--Total literacy rate and total illiteracy rate
select sum(literacy) as total_literate from [Indian census Project].dbo.Data1

select e.state,sum(e.literate_people) total_literate_popl,sum(e.illiterate_people) total_illiterate_popl from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-literacy_ratio)*population,0) illiterate_people from
(Select a.district,a.state,a.literacy/100 literacy_ratio,b.population from [Indian census Project].dbo.Data1
a inner join [Indian census Project].dbo.Data2 b on a.district=b.district)d)e
group by e.state

--population in previous census
Select sum(m.previous_census_population) previous_census_population ,
sum(m.current_census_population)current_census_population from(
Select e.state,sum(e.previous_census_population) previous_census_population ,
sum(e.current_census_population) current_census_population from
(Select d.district,d.state,round(d.population/(1+d.growth),0)previous_census_population,
d.Population current_census_population from 
(Select a.district,a.state,a.growth growth,b.population from [Indian census Project].dbo.Data1 a inner join
[Indian census Project].dbo.Data2 b on a.district=b.district)d)e
group by e.state)m

--population vs area

--top 3 states having highest literacy ratio
with lit as(
Select district,state,literacy, dense_rank()over(partition by State order by Literacy desc)dn from 
[Indian census Project].dbo.Data1)
Select * from lit where dn in (1,2,3)
