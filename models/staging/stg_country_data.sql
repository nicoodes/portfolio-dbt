{{ config(materialized='ephemeral') }}
with
src_data as (
    select
        COUNTRY_NAME as COUNTRY_NAME
        , COUNTRY_CODE_2_LETTER as COUNTRY_CODE_2_LETTER
        , COUNTRY_CODE_3_LETTER as COUNTRY_CODE_3_LETTER
        , COUNTRY_CODE_NUMERIC as COUNTRY_CODE_NUMERIC
        , ISO_3166_2 as ISO_3166_2
        , REGION as REGION
        , SUB_REGION as SUB_REGION
        , INTERMEDIATE_REGION as INTERMEDIATE_REGION
        , REGION_CODE as REGION_CODE
        , SUB_REGION_CODE as SUB_REGION_CODE
        , INTERMEDIATE_REGION_CODE as INTERMEDIATE_REGION_CODE
        , LOAD_TS as LOAD_TS
        , 'seed.country_data' as RECORD_SOURCE
    from {{ source('seeds', 'country_data') }}
),
default_record as (
    select
        'Missing' as COUNTRY_NAME
        , 'Missing' as COUNTRY_CODE_2_LETTER
        , 'Missing' as COUNTRY_CODE_3_LETTER
        , -'-1' as COUNTRY_CODE_NUMERIC
        , 'Missing' as ISO_3166_2
        , 'Missing' as REGION
        , 'Missing' as SUB_REGION
        , 'Missing' as INTERMEDIATE_REGION
        , '-1' as REGION_CODE
        , -'-1' as SUB_REGION_CODE
        , '-1' as INTERMEDIATE_REGION_CODE
        , '2020-01-01' as LOAD_TS
        , 'System.DefaultKey' as RECORD_SOURCE
),
with_default_key as (
    select * from src_data
    union all
    select * from default_record
),
hashed as (
    select
        concat_ws('|', COUNTRY_CODE_2_LETTER) as COUNTRY_HKEY,
        concat_ws('|', COUNTRY_NAME, COUNTRY_CODE_2_LETTER, COUNTRY_CODE_3_LETTER, COUNTRY_CODE_NUMERIC,
            ISO_3166_2, REGION, SUB_REGION, INTERMEDIATE_REGION,
            REGION_CODE, SUB_REGION_CODE, INTERMEDIATE_REGION_CODE) as COUNTRY_HDIFF,
        * exclude LOAD_TS,
        LOAD_TS  as LOAD_TS_UTC        
    from with_default_key
)
SELECT * FROM hashed