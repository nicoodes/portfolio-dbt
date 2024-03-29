{{ config(materialized='ephemeral') }}
with
src_data as(
    SELECT
        SECURITY_CODE as SECURITY_CODE -- TEXT
        , SECURITY_NAME as SECURITY_NAME -- TEXT
        , SECTOR as SECTOR_NAME -- TEXT
        , INDUSTRY as INDUSTRY_NAME -- TEXT
        , COUNTRY as COUNTRY_CODE -- TEXT
        , EXCHANGE as EXCHANGE_CODE -- TEXT
        , LOAD_TS as LOAD_TS -- TIMESTAMP_NTZ
        , 'seed.abc_bank_security_info' as RECORD_SOURCE
    from {{ source('seeds', 'abc_bank_security_info') }}
),
default_record as (
    SELECT
        '-1' as SECURITY_CODE
        , 'Missing' as SECURITY_NAME
        , 'Missing' as SECTOR_NAME
        , 'Missing' as INDUSTRY_NAME
        , '-1' as COUNTRY_CODE
        , '-1' as EXCHANGE_CODE
        , '2020-01-01' as LOAD_TS_UTC
        , 'System.DefaultKey' as RECORD_SOURCE
),
with_default_record as(
    select * from src_data
    union all
    select * from default_record
),
hashed as(
    SELECT
        concat_ws('|', SECURITY_CODE) as SECURITY_HKEY
        , concat_ws('|', SECURITY_CODE, SECURITY_NAME, SECTOR_NAME,
        INDUSTRY_NAME, COUNTRY_CODE, EXCHANGE_CODE ) as SECURITY_HDIFF
        , * EXCLUDE LOAD_TS
        , LOAD_TS as LOAD_TS_UTC -- normally defined as '{{ run_started_at }}' as LOAD_TS_UTC, here only to show EXCEPT command from Snowflake
    FROM with_default_record
)
select * from hashed