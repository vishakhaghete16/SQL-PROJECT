-- Demo on Building Conversion Funnels

-- BUSINESS CONTEXT
-- we want to build a mini conversion funnel, from /lander-2 to/cart
-- we want to know how many people reach each step, and also dropoff rates
-- for simplicity of the demo, we're looking at /lander-2 traffic only
-- for simplicity of the demo, we're lookign at customers who like Mr Fuzzy only

 -- STEP 1: select all pageviews for relevant sessions
-- STEP 2: identify each relevant pageview as the specific funnel step
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data to assess funnel performance

-- first I will show you all of the pageviews we care about
-- then, I will remove the comments from my flag columns one by one to show you what that lo



select 
      website_pageviews.website_session_id,
      website_pageviews.pageview_url,
      website_pageviews.created_at,
      case when pageview_url = '/products' then 1 else 0 end as prodct_page,
      case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end  as fuzzy_page,
      case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions
       left join website_pageviews
                on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' And  '2014-02-01'
    and website_pageviews.pageview_url in ('/lander-2' , '/products', '/the-original-mr-fuzzy', '/cart')
order by 
    website_pageviews.website_session_id,
      website_pageviews.created_at ;
   

-- next we will put the previous query inside a subquery (similar to temporary tables)
-- we will group by website_session_id, and take the MAX() of each of the flags
-- this MAX() becomes a made_it flag for that session, to show the session made it there
create temporary table session_level_made_it_flags_demo
   select 
      website_session_id,
      max( prodct_page) as product_made_it,
      max( fuzzy_page) as mrfuzzy_made_it,
      max(cart_page) as cart_made_it 
     --  max(shipping_page) as shipping_made_it,
--       max(billing_page) as billing_made_it,
--       max(thankyou_page) as thankyou_made_it
--       
from(
    select 
      website_pageviews.website_session_id,
      website_pageviews.pageview_url,
      website_pageviews.created_at,
      case when pageview_url = '/products' then 1 else 0 end as prodct_page,
      case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end  as fuzzy_page,
      case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions
       left join website_pageviews
                on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' And  '2014-02-01'
    and website_pageviews.pageview_url in ('/lander-2' , '/products', '/the-original-mr-fuzzy', '/cart')
order by 
    website_pageviews.website_session_id,
      website_pageviews.created_at 
      ) as  pageview_level
      group by
      website_session_id
      ;
   
   
   
select * from session_level_made_it_flags_demo   ;


select 
     count( distinct website_session_id) as sessions,
	 count( distinct case when product_made_it  = 1 then website_session_id else null end) as to_product,
	 count( distinct case when mrfuzzy_made_it  = 1 then website_session_id else null end) as to_mrfuzzy,
	 count( distinct case when cart_made_it  = 1 then website_session_id else null end) as to_cart
from session_level_made_it_flags_demo;
   
   
   
   
   
select 
     count( distinct website_session_id) as sessions,
	 count( distinct case when product_made_it  = 1 then website_session_id else null end) /count( distinct website_session_id) as clicked_to_product,
	 count( distinct case when mrfuzzy_made_it  = 1 then website_session_id else null end) / count( distinct website_session_id) as clicked_to_mrfuzzy,
	 count( distinct case when cart_made_it  = 1 then website_session_id else null end) /count( distinct website_session_id) as clicked_to_cart
from session_level_made_it_flags_demo;
   
   
   
   
   