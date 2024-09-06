-- Analyzing Business Patterns & Seasonality
select 
  website_session_id,
  created_at,
  hour(created_at) as hr,
  weekday(created_at) as wkday,
  case when weekday(created_at) = 0 then 'Monday'
       when weekday(created_at) = 1 then 'tuesday' 
       when weekday(created_at) = 2 then 'wednesday'
       when weekday(created_at) = 3 then 'thursday'
       when weekday(created_at) = 4 then 'friday'
       when weekday(created_at) = 5 then 'satureday'
       else 'Sunday'
       end as clean_weekday,
   quarter(created_at) as qtr,
   month(created_at) as mo,
   date(created_at) as da,
   week(created_at) as wk
   
from website_sessions
where website_session_id between 150000 and 155000;






/*  take the look at 2012 monthly and weekly volume pattern to see
    if we can find any seasonal treds we should plan for in 2013
 */   
 
 select 
       year(website_sessions.created_at ) as yr,
       week(website_sessions.created_at) as wk ,
       min(date(website_sessions.created_at)) as start_week,
       count( distinct website_sessions.website_session_id) as session,
       count( distinct orders.order_id) as ordres
from website_sessions
     left join orders
            on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2013-01-01'
group by 1,2 ;




/*  analyze the average website session volume ,
 by hour of day and by day week
 */
 
 select 
      hr,
      round(avg(case when wkday = 0 then website_sessions else null end),1) as mon, 
      round(avg(case when wkday = 1 then website_sessions else null end),1) as tue,
      round(avg(case when wkday = 2 then website_sessions else null end),1) as wed,
      round(avg(case when wkday = 3 then website_sessions else null end),1) as thus,
      round(avg(case when wkday = 4 then website_sessions else null end),1) as fri,
      round(avg(case when wkday = 5 then website_sessions else null end),1) as sta,
      round(avg(case when wkday = 6 then website_sessions else null end),1) as sun
from (
 select 
       date(created_at) as created_date,
       weekday(created_at) as wkday,
       hour( created_at) as hr,
       count( distinct website_session_id) as website_sessions
from website_sessions
where created_at between '2012-09-15' and '2012-11-15'
group by 1,2,3) as daily_hour_session
group by 1
order by 1

;