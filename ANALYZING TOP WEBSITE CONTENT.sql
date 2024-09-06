use mavenfuzzyfactory;

select * from website_pageviews;

select 
     pageview_url,
     count(distinct website_pageview_id) as pvs
from website_pageviews
where website_pageview_id<1000 
group by pageview_url
order by pvs desc;


create temporary table first_pageview
select 
      website_session_id,
      min(website_pageview_id) as min_pv_id
from website_pageviews
where website_pageview_id< 1000
group by website_session_id;

select * from first_pageview;

select 
--       first_pageview.website_session_id,
      website_pageviews.pageview_url as landing_page,
      count( distinct first_pageview.website_session_id) as session_hitting_this_lander
from first_pageview
left join website_pageviews
          on first_pageview.min_pv_id = website_pageviews.website_pageview_id
group by
     website_pageviews.pageview_url ;
      




select  
     pageview_url,
     count( distinct website_pageview_id) pvs
from website_pageviews
where created_at < '2012-06-09'
group by 
     pageview_url
order by
     pvs desc;
     
     
     

create temporary table first_pv_par_session
select 
      website_session_id,
      min(website_pageview_id) as first_pv
from website_pageviews
where created_at < '2012-06-12'
group by 
website_session_id
;

select * from first_pv_par_session;

select
      pageview_url,
      count( distinct first_pv_par_session.website_session_id) as  hitting_page
from first_pv_par_session
left join website_pageviews
          on first_pv_par_session.first_pv = website_pageviews.website_pageview_id
group by 
	   website_pageviews.pageview_url;


 