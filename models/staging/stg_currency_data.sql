{{ config(materialized='ephemeral') }}
with
src_data as (

    select
        ALPHABETICCODE as ALPHABETICCODE
        , NUMERICCODE as NUMERICCODE
        , DECIMALDIGITS as DECIMALDIGITS
        , CURRENCYNAME as CURRENCYNAME
        , LOCATIONS as LOCATIONS
        , LOAD_TS as LOAD_TS
        , 'src.currency_data' as RECORD_SOURCE
    from {{ source('seeds', 'currency_data') }}

),
default_data as (
    select
        'Missing' as ALPHABETICCODE
        , '-1' as NUMERICCODE
        , '-1' as DECIMALDIGITS
        , 'Missing' as CURRENCYNAME
        , 'Missing' as LOCATIONS
        , '2020-01-01' as LOAD_TS
        , 'System.DefaultKey' as RECORD_SOURCE
),
with_default_key as (
    select * from src_data
    union all
    select * from default_data
),
hashed as (
    select
        concat_ws('|', ALPHABETICCODE) as CURRENCY_HKEY,
        concat_ws('|', ALPHABETICCODE, NUMERICCODE, DECIMALDIGITS, CURRENCYNAME, LOCATIONS) as CURRENCY_HDIFF,
        * EXCLUDE LOAD_TS,
        LOAD_TS AS LOAD_TS_UTC
    from with_default_key
)
select * from hashed