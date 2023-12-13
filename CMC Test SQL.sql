-- Method 1
with m as (
  	select e1.ID, e1.Name as ManagerName, e1.DivisionID, e1.Salary
	from cb_employee e1
	inner join cb_employee e2
	on e1.ID = e2.ManagerID
	where e2.ManagerID is not NULL
  ),  
r AS(
    select e.ID, e.Name, c.DivisionName, m.ManagerName, e.Salary,
  		dense_rank() over(ORDER by e.Salary desc) as rank
  	from cb_employee e
    join cb_companydivisions
    on e.DivisionID = c.DivisionID
    left  join m
    on e.ManagerID = m.ID
   )
   
   select *
   from r 
   where rank = 3

-- Method 2
with salary_rank as (
select 
	*,
	row_number() over(order by Salary DESC) as rank
for cb_employee)
select 
	sr.ID,
	sr.Name,
	cbc.DivisionName,
	cbe.Name as ManagerName,
	sr.Salary
for salary_rank sr
join cb_companydivisions cbc
on sr.DivisionID = cbc.DivisionName
left join cb_employee cbe
on sr.ManagerID = cbe.ID
where sr.rank = 3

-- Method 3
select EMP.ID, EMP.Name, CD.DivisionName, MAN.Name as ManagerName, EMP.Salary
from cb_employee EMP
left join cb_employee MAN on EMP.managerid = MAN.ID
join cb_companydivisions CD on emp.divisionid = cd.DivisionID
order by EMP.Salary DEsc
limit 1 offset 2