use mavenfuzzyfactory;

select  * from orders;
select 
      primary_product_id,
      count(order_id) as orders,
      sum(price_usd) as revenu,
      sum(price_usd - cogs_usd) as margin,
      avg( price_usd) as AOV
      
      from orders
      where order_id between 10000 and 11000
      group by 1
      order by 2 desc;
      
      
      
      
/* 
want to know how much of our order volume comes from each product, 
and the overall revenue and margin generated
*/

Select 
      year(created_at) as yr,
      month(created_at) as mo,
      count(distinct order_id) as number_of_sale,
      sum(price_usd)as totoal_revenue,
      sum( price_usd - cogs_usd) as total_margin
      
      from orders
      where created_at< '2013-01-04'
      group by
      1,2;
      
      
      
      
/*
like to see monthly oredr volume,overrall conversion rates,revenue per sessoion
and brakdown of sales by product all for the time perode since april 1 2012.
*/


select
      year(website_sessions.created_at) as yr ,
      month(website_sessions.created_at) as mo,
      count(distinct website_sessions.website_session_id) as sessions,
      count( distinct orders.order_id) as orders,
      count( distinct orders.order_id)/ count(distinct website_sessions.website_session_id) as con_rate,
      sum(orders.price_usd) / count( distinct website_sessions.website_session_id) as  revenue_per_session,
      count( distinct case when primary_product_id = 1 then order_id else null end) as product_one_order,
       count( distinct case when primary_product_id = 2 then order_id else null end) as product_two_order
from website_sessions
    left join orders
            on website_sessions.website_session_id = orders.website_session_id
	where website_sessions.created_at < '2013-04-05'
      and website_sessions.created_at < '2012-07-01'
group by 1,2
;
    
    
    
    
    
-- product level website pathing

/*
Product-focused website analysis is about learning how customers interact
with each of your products, and how well each product converts customers
*/
select 
     website_pageviews.pageview_url,
     count( distinct website_pageviews.website_session_id) as session ,
     count( distinct orders.order_id ) as orders,
     count( distinct orders.order_id ) / count( distinct website_pageviews.website_session_id)
from website_pageviews
  left join orders 
         on orders.website_session_id = website_pageviews.website_session_id
  where website_pageviews.created_at between ' 2013-02-01' and '2013-03-01'
       and website_pageviews.pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear')
group by 1;
     
     
 
     
 








