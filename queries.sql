use education;
select * from apprdstr limit 100;
select * from apprsch limit 100;
select * from apprstate limit 100;

select s.School_NAME from apprsch s
inner join apprstate r on s.educator_id = r.educator_id limit 100;

select d.district_NAME from apprdstr d
inner join apprstate r on d.educator_id = r.educator_id limit 100;

select count(*) from apprdstr d
left join apprsch s on  d.district_beds = s.district_beds;

select d.educator_id as EducatorD_ID, d.DISTRICT_NAME, s.Educator_id as EducatorS_ID, s.School_name, district_needs_category, per_pupil_expenditure,
d.overall_score, d.overall_rating, s.growth_rating from apprdstr d
inner join apprsch s on  d.district_beds = s.district_beds limit 1000000;

select * from apprstate v 
inner join apprsch s on s.educator_id = v.educator_id limit 100;


 

