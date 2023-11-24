USE mavenfuzzyfactory;

SELECT 
    UTM_SOURCE,
    UTM_CAMPAIGN,
    HTTP_REFERER,
    COUNT(DISTINCT WEBSITE_SESSION_ID) AS SESSIONS
FROM
    WEBSITE_SESSIONS
WHERE
    CAST(CREATED_AT AS DATE) < '2012-04-12'
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC;

-- Calculate the conversion rate (CVR) from session to order
SELECT 
    COUNT(DISTINCT W.WEBSITE_SESSION_ID),
    COUNT(DISTINCT ORDER_ID),
    COUNT(DISTINCT ORDER_ID) / COUNT(DISTINCT W.WEBSITE_SESSION_ID) AS CONVERSION_RATE
FROM
    WEBSITE_SESSIONS W
        LEFT JOIN
    ORDERS O ON W.WEBSITE_SESSION_ID = O.WEBSITE_SESSION_ID
WHERE
    CAST(W.CREATED_AT AS DATE) < '2012-04-14'
        AND UTM_SOURCE = 'gsearch'
        AND UTM_CAMPAIGN = 'nonbrand';

-- Can you pull gsearch nonbrand trended session volume, by week, to see if the bid changes have caused volume to drop at all?
SELECT 
    MIN(DATE(CREATED_AT)) AS WEEK_STARTED_AT,
    COUNT(DISTINCT WEBSITE_SESSION_ID) AS SESSIONS
FROM
    WEBSITE_SESSIONS
WHERE
    CAST(CREATED_AT AS DATE) < '2012-05-10'
        AND UTM_SOURCE = 'gsearch'
        AND UTM_CAMPAIGN = 'nonbrand'
GROUP BY 
	YEAR(CREATED_AT),
    WEEK(CREATED_AT);
    
-- Could you pull conversion rates from session to order, by device type?
SELECT 
	W.DEVICE_TYPE,
	COUNT(DISTINCT W.WEBSITE_SESSION_ID),
	COUNT(DISTINCT ORDER_ID),
    (COUNT(DISTINCT ORDER_ID) / COUNT(DISTINCT W.WEBSITE_SESSION_ID))*100 AS CONVERSION_RATE
FROM
    WEBSITE_SESSIONS W
        LEFT JOIN
    ORDERS O ON W.WEBSITE_SESSION_ID = O.WEBSITE_SESSION_ID
WHERE
    CAST(W.CREATED_AT AS DATE) < '2012-05-11'
		AND UTM_SOURCE = 'gsearch'
        AND UTM_CAMPAIGN = 'nonbrand'
GROUP BY 1
ORDER BY 4;

-- Could you pull weekly trends for both desktop and mobile so we can see the impact on volumn?
SELECT
	MIN(DATE(CREATED_AT)) AS WEEK_START_DATE,
    COUNT(CASE WHEN DEVICE_TYPE = 'desktop' THEN WEBSITE_SESSION_ID ELSE NULL END) AS DTOP_SESSIONS,
    COUNT(CASE WHEN DEVICE_TYPE = 'mobile' THEN WEBSITE_SESSION_ID ELSE NULL END) AS MOB_SESSIONS
FROM
	WEBSITE_SESSIONS
WHERE
	CAST(CREATED_AT AS DATE) BETWEEN '2012-04-15' AND '2012-06-09'
		AND UTM_SOURCE = 'gsearch'
        AND UTM_CAMPAIGN = 'nonbrand'
GROUP BY
	YEAR(CREATED_AT),
    WEEK(CREATED_AT)