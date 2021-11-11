--1.	Number of athletes of each NOC for each discipline
select NOC, discipline, count(name) as number_of_athletes
from athletes
group by NOC, discipline 
order by NOC 

--2.	Discipline with the highest share of female participants, highest share of male participants
select discipline, round(female/total*100,2) as share_of_female, round(male/total*100,2) as share_of_male
from entries_gender 
where (female/total*100) >= (select max(e1.female/ e1.total*100) from entries_gender e1)
union
select discipline, round(female/total*100,2) as share_of_female, round(male/total*100,2) as share_of_male
from entries_gender 
where (male/total*100) >= (select max(e2.male/ e2.total*100) from entries_gender e2)

--3.	Athletes and coaches list
select temp1.NOC, temp1.discipline, temp1.name as athelete_name, temp2.name as coach_name
from 
    (select t.NOC, t.discipline, t.name 
    from athletes t) temp1
join 
    (select c.NOC, c.discipline,  c.name 
    from coaches c) temp2
on temp1.NOC = temp2.NOC and temp1.discipline = temp2.discipline 
order by 1, 2

--4.    Number of athletes, coaches, and the number of athletes per coach of each country
select t1.NOC, t1.number_of_athletes, t2.number_of_coaches, 
    round((cast(t1.number_of_athletes as float)/t2.number_of_coaches),2) as athletes_per_coach 
from 
    (select a.NOC, count(a.name) as number_of_athletes
    from athletes a 
    group by a.NOC) t1
join
    (select c.NOC, count(c.name) as number_of_coaches
    from coaches c
    group by c.NOC) t2
on t1.NOC = t2.NOC 
order by 1

--5.	Performance of each conutry
select a.NOC, a.number_of_athletes, m.total_medals,round(cast(a.number_of_athletes as float)/m.total_medals,2) as athletes_per_medal
from 
    (select NOC, count(name) as number_of_athletes 
    from athletes
    group by NOC) a
join 
    (select team_NOC, total as total_medals
    from medals) m
on a.NOC = m.team_NOC
order by 3 desc

--6.	Countries with most Gold, Silver, and Bronze medals
select concat(Team_NOC, ' claims the most Gold medals with ', Gold, ' medals.' )
from medals
where Gold >= (select max(gold) from medals)
union 
select concat(Team_NOC, ' claims the most Silver medals with ', Silver, ' medals.' )
from medals 
where Silver >= (select max(Silver) from medals)
union
select concat(Team_NOC, ' claims the most Bronze medals with ', Bronze, ' medals.' )
from medals 
where Bronze >= (select max(Bronze) from medals)

--7.	Number of countries, athletes, coaches, and medals claimed of each continent
select coun.continent, coun.number_of_countries, ath.number_of_athletes, coa.number_of_coaches, medal.gold, medal.silver, medal.bronze, medal.total_medal
from 
    (select continent, count(country) as number_of_countries
    from Continent_List
    group by continent) coun
join 
    (select continent, count(name) as number_of_athletes
    from athletes a
    join continent_list cl
    on cl.country = a.NOC
    group by continent) ath
on coun.continent = ath.continent
join 
    (select continent, count(name) as number_of_coaches
    from coaches c 
    join continent_list cl 
    on cl.country = c.NOC
    group by continent) coa
on coun.continent = coa.continent
join
    (select continent, sum(m.gold) as Gold, sum(m.silver) as silver, sum(bronze) as bronze, sum(total) as Total_medal
    from medals m 
    join continent_list 
    on m.team_noc = country 
    group by continent) medal
on coun.continent = medal.continent
order by 8 desc

