{{ config(materialized='ephemeral') }}
with
src_data as (
    select
        NAME as EXCHANGE_NAME
        , ID as EXCHANGE_CODE
        , COUNTRY as EXCHANGE_COUNTRY
        , CITY as EXCHANGE_CITY
        , ZONE as ZONE
        , DELTA as DELTA
        , DST_PERIOD as DST_PERIOD
        , OPEN as OPEN
        , CLOSE as CLOSE
        , LUNCH as LUNCH
        , OPEN_UTC as OPEN_UTC
        , CLOSE_UTC as CLOSE_UTC
        , LUNCH_UTC as LUNCH_UTC
        , LOAD_TS as LOAD_TS
        , 'src.exchange_data' as RECORD_SOURCE
    from {{ source('seeds', 'exchange_data') }}
),
default_data as (
    SELECT
        'Missing' as EXCHANGE_NAME
        , 'Missing' as EXCHANGE_CODE
        , 'Missing' as EXCHANGE_COUNTRY
        , 'Missing' as EXCHANGE_CITY
        , 'Missing' as ZONE
        , '-1' as DELTA
        , 'Missing' as DST_PERIOD
        , '00:00' as OPEN
        , '00:00' as CLOSE
        , 'Missing' as LUNCH
        , '00:00' as OPEN_UTC
        , '00:00' as CLOSE_UTC
        , 'Missing' as LUNCH_UTC
        , '2020-01-01' as LOAD_TS
        , 'System.DefaultKey' as RECORD_SOURCE
),
with_default_key as (
    select * from src_data
    union all
    select * from default_data
),
hashed as(
    select
        concat_ws('|', EXCHANGE_CODE) as EXCHANGE_HKEY
        , concat_ws('|', EXCHANGE_NAME, EXCHANGE_CODE, EXCHANGE_COUNTRY, EXCHANGE_CITY, ZONE, DELTA, DST_PERIOD, OPEN, CLOSE, LUNCH, OPEN_UTC, CLOSE_UTC, LUNCH_UTC) as EXCHANGE_HDIFF
        , * exclude LOAD_TS
        , LOAD_TS AS LOAD_TS_UTC
    FROM with_default_key
)
select * from hashed