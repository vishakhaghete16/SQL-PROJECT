-- ASSIGNMENT_CALCULATING_BOUNCE_RATES

-- STEP 1: finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces" 
-- STEP 4: summarizing by counting total sessions and bounced sessions



-- step 1
create temporary table first_pageviews
select
      website_session_id,
      min( website_pageview_id) as min_pageview_id
from website_pageviews
where created_at <'2012-06-14'
group by 
     website_session_id;
       
select * from first_pageviews;


-- next, we'll bring in the landing page,but restrict to home only this is redndant in this case, since all is to the homepage 

create temporary table session_w_home_landing_page
select
     first_pageviews.website_session_id,
     website_pageviews.pageview_url as landing_page
from first_pageviews
      left join website_pageviews
          on website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
      where website_pageviews.pageview_url = '/home' ;

select * from session_w_home_landing_page;

-- then a table to have count of pageviews per session 
-- then limit it to just bounced_sessions 


create temporary table bounced_session
select 
      session_w_home_landing_page.website_session_id,
      session_w_home_landing_page.landing_page,
      count(website_pageviews.website_pageview_id) as count_of_home_page
from session_w_home_landing_page
left join website_pageviews
        on website_pageviews.website_session_id = session_w_home_landing_page.website_session_id
group by
       session_w_home_landing_page.website_session_id,
	   session_w_home_landing_page.landing_page
having
     count(website_pageviews.website_pageview_id) = 1;
   
--

select 
      session_w_home_landing_page.website_session_id,
	  bounced_session.website_session_id as bounced_website_session_id
from session_w_home_landing_page
  left join bounced_session
    on session_w_home_landing_page.website_session_id = bounced_session.website_session_id
order by
      session_w_home_landing_page.website_session_id;



 select 
      count( distinct session_w_home_landing_page.website_session_id) as sessions,
	  count( distinct bounced_session.website_session_id ) as bounced_session
from session_w_home_landing_page
  left join bounced_session
    on session_w_home_landing_page.website_session_id = bounced_session.website_session_id;
    

     
     -- bounced rate 
select 
      count( distinct session_w_home_landing_page.website_session_id) as sessions,
	  count( distinct bounced_session.website_session_id ) as bounced_session,
      count( distinct bounced_session.website_session_id ) /  count( distinct session_w_home_landing_page.website_session_id) asbounced_rate
from session_w_home_landing_page
  left join bounced_session
    on session_w_home_landing_page.website_session_id = bounced_session.website_session_id



