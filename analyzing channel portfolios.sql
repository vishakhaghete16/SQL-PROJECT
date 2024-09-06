use mavenfuzzyfactory;
select 
     min(date(created_at)) as week_start_date,
     count( distinct website_session_id) as total_session,
     count( distinct case when utm_source = 'gsearch' then website_session_id else null end ) as gsearch,
     count( distinct case when utm_source = 'bsearch' then website_session_id else null end ) as bsearch
     
from website_sessions
where created_at > '2012-08-22'
           and created_at <'2012-11-29'
           and utm_campaign = 'nonbrand'
           
	group by yearweek (created_at)
    order by total_session asc ;

/*
2. pull the percentage of traffic coming on Mobile, and compare that to gsearch?
*/

select 
    utm_source,
    count( distinct website_sessions.website_session_id) as session
from website_sessions
where created_at >'2012-08-22'
       and created_at <'2012-11-30'
       and utm_campaign ='nonbrand'
       
group by 
    utm_source
