with session_src as (

    select
        SESSION_ID,
        USER_ID,
        BROWSER,
        DEVICE_TYPE,
        b.country_name as country_name,
        b.continent as continent,
        b.currency as currency,
        COUNTRY_CODE,
        START_TIME,
        END_TIME,
        PAGES_VISITED,
        CURRENT_TIMESTAMP as INSERT_DTS
    from {{source('country', 'SESSION_SRC')}} a
    left join DBT_DB.PUBLIC.COUNTRY_CODE B
    USING(COUNTRY_CODE)
)

SELECT * FROM session_src
