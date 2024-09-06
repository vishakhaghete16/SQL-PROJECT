use mavenfuzzyfactory;
select * from website_sessions;

select distinct 
     utm_source,
     utm_campaign 
from website_sessions;

select 
    utm_content,                                    -- column 1 
    count(distinct website_session_id) as sessions   -- column 2
from website_sessions
where website_session_id between 1000 and 2000
group by 
     utm_content            -- we can also write 1 which is column 1
order by sessions            -- we can also write 2 which is column 2
desc ;






select 
    website_sessions.utm_content,                                     
    count(distinct website_sessions.website_session_id) as sessions ,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/ count(distinct website_sessions.website_session_id) as session_to_order_conversion_rate
from website_sessions
     left join orders 
     on orders.website_session_id = website_sessions.website_session_id
where website_sessions.website_session_id between 1000 and 2000
group by 
     utm_content            
order by sessions            
desc ;



select 
     utm_source,
     utm_campaign,
     http_referer,
	 count(distinct website_session_id) as number_of_session
from website_sessions
where created_at < '2012-04-12'
group by
     utm_source,
     utm_campaign,
     http_referer
order by number_of_session 
desc;
     
     
     
     
     
     
     
     
     
select 
    count(distinct website_sessions.website_session_id) as session,
    count(distinct orders.order_id) as orders ,
    count(distinct orders.order_id) /count(distinct website_sessions.website_session_id) as session_to_orders_conversion_rate
from website_sessions
        left join orders
        on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2021-04-14'
      and utm_source = 'gsearch'
      and utm_campaign = 'nonbrand';
      
      
      
      
      
      
-- datetime 
select 
     year(created_at),
     week(created_at),
     min(date(created_at)) as week_start,
     count(distinct website_session_id)
from website_sessions
where website_session_id between 100000 and 115000 
group by 1,2;


-- order table
select * from orders;

select 
     primary_product_id,
     count(distinct case when items_purchased = 1 then order_id else null end) as count_single_item_order,
     count(distinct case when items_purchased = 2 then order_id else null end) as count_double_item_order
from orders
where order_id between 31000 and 32000
group by 1;









select 
      min(date(created_at))as week_started_at,
      count(distinct website_session_id) as sessions
from website_sessions
where created_at < '2012-05-12'
      and utm_source = 'gsearch'
      and utm_campaign = 'nonbrand'
group by
       year(created_at),
       week(created_at) ;





select 
	website_sessions.device_type,
    count(distinct website_sessions.website_session_id ) as sessions,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id ) AS covr_rate
from website_sessions
     left join orders
     on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-05-11'
      and utm_source = 'gsearch'
      and utm_campaign = 'nonbrand'
group by 1;







select 
   -- year( created_at) as yr,
   -- week ( created_at) as wk,
   min(date(created_at)) as week_start_date,
   count(distinct case when device_type = 'desktop' then website_session_id else null end )  as desktop_session,
   count(distinct case when device_type = 'mobile' then website_session_id else null end )  as mobile_session
from website_sessions
where website_sessions.created_at < '2012-06-09'
      and  website_sessions.created_at > '2012-04-15'
      and  utm_source = 'gsearch'
      and  utm_campaign = 'nonbrand'
group by 
      year( created_at) ,
      week ( created_at)