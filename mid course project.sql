

/* 1.  Gsearch seems to be the biggest driver of our business. Could you pull monthly 
trends for gsearch sessions and orders so that we can showcase the growth there? 
*/
select * from website_sessions; 
select 
      year(website_sessions.created_at) as yr,
      month(website_sessions.created_at) as mo,
      count(distinct website_sessions.website_session_id) as sessions,
      count( distinct orders.order_id) as orders,
      count( distinct orders.order_id) /count(distinct website_sessions.website_session_id)
from website_sessions
    left join orders
       on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
 and website_sessions.utm_source = 'gsearch'
group by 1,2;




/*
*/
 
select 
      year(website_sessions.created_at) as yr,
      month(website_sessions.created_at) as mo,
      count(distinct case when utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as nonbrand_session,
      count( distinct case when utm_campaign = 'nonbrand' then orders.order_id else null end ) as nonbrand_orders,
	  count( distinct case when utm_campaign = 'brand' then website_sessions.website_session_id else null end) as brand_session,
	  count( distinct case when utm_campaign = 'brand' then orders.order_id else null end ) as  brand_orders

from website_sessions
    left join orders
       on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
 and website_sessions.utm_source = 'gsearch'
group by 1,2;






/*
*/

select 
      year(website_sessions.created_at) as yr,
      month(website_sessions.created_at) as mo,
      count(distinct case when device_type = 'desktop' then website_sessions.website_session_id else null end) as desktop_sesssion,
      count( distinct case when device_type = 'desktop' then orders.order_id else null end ) as desktop_orders,
	  count( distinct case when device_type = 'mobile' then website_sessions.website_session_id else null end) as mobile_session,
	  count( distinct case when device_type = 'mobile' then orders.order_id else null end ) as  mobile_orders

from website_sessions
    left join orders
       on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
 and website_sessions.utm_source = 'gsearch'
 and website_sessions.utm_campaign = 'nonbrand'
group by 1,2;

 
 
 
 /*
 */
 
 -- first ,finding the various utm sources and referers to see the traffice we're getting
 
 select distinct
        utm_source,
        utm_campaign,
        http_referer
from website_sessions
where website_sessions.created_at < '2012-11-27';


select 
      year(website_sessions.created_at) as yr,
      month(website_sessions.created_at) as mo,
      count(distinct case when utm_source = 'gsearch' then website_sessions.website_session_id else null end) as gsearch_paid_session,
      count( distinct case when utm_source = 'bsearch' then website_sessions.website_session_id  else null end ) as bsearch_paid_session,	
	  count( distinct case when utm_source is null and http_referer is not null then website_sessions.website_session_id else null end) as original_serach_session,
	  count( distinct case when utm_source is null and http_referer is null then website_sessions.website_session_id else null end ) as direct_type_in_session

from website_sessions
    left join orders
       on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
group by 1,2;



/*
*/

select 
      year(website_sessions.created_at) as yr,
      month(website_sessions.created_at) as mo,
      count(distinct website_sessions.website_session_id) as sessions,
      count( distinct orders.order_id) as orders,
      count( distinct orders.order_id) /count(distinct website_sessions.website_session_id) as conversion_rate
from website_sessions
    left join orders
       on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
group by 1,2;





/*
*/

-- select * from website_pageviews
-- where website_pageview_id <= 23504 and website_pageview_id >23000;

-- select 
-- min(website_pageview_id) as first_test_pv
-- from website_pageviews
-- where pageview_url = '/lander-1';



/*
*/
create temporary table session_level_made_it_flagged

select 
      website_session_id,
      max(homepage) as saw_homepages,
	  max(custom_lander) as saw_custom_lander,
      max(product_page) as product_made_it,
      max(mrfuzzy_page) as mrfuzzy_made_it,
      max(cart_page) as card_made_it,
      max(shipping_page) as shipping_made_it,
      max(billing_page) as billing_made_it,
      max(thankyou_page) as thankyou_made_it
      
from (
     select 
      website_sessions.website_session_id,
      website_pageviews.pageview_url,
      
      case when pageview_url = '/home' then 1 else 0 end as homepage,
	  case when pageview_url = '/landern-1' then 1 else 0 end as custom_lander,
	  case when pageview_url = '/product' then 1 else 0 end as product_page,
	  case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
	  case when pageview_url = '/cart' then 1 else 0 end as cart_page,
	  case when pageview_url = '/shipping ' then 1 else 0 end as shipping_page,
	  case when pageview_url = '/billing' then 1 else 0 end as billing_page,
 	  case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page

      
     
from website_sessions
    left join website_pageviews
       on  website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
    and website_sessions.created_at <'2012-07-8'
      and website_sessions.created_at > '2012-06-19'
order by
   website_sessions.website_session_id,
	website_pageviews.created_at
) as pageview_level
group by
      website_sessions.website_session_id
      ;
      
      
select * from session_level_made_it_flagged;


SELECT
CASE
WHEN saw_homepages = 1 THEN 'saw homepage'
WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
ELSE 'uh oh. check logic'
END AS segment,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart, 
COUNT(DISTINCT CASE WHEN card_made_it =1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy, 
COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
COUNT(DISTINCT CASE WHEN billing_made_it =1 THEN website_session_id ELSE NULL END) AS to_billing,
COUNT(DISTINCT CASE WHEN thankyou_made_it =1 THEN website_session_id ELSE NULL END) AS to_thankyou FROM session_level_made_it_flagged

GROUP BY
1
;