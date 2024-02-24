{{ config(materialized='ephemeral') }}

with
src_data as (
    SELECT
        ACCOUNTID           as ACCOUNT_CODE         -- TEXT
        , SYMBOL            as SECURITY_CODE        -- TEXT
        , DESCRIPTION       as SECURITY_NAME        -- TEXT
        , EXCHANGE          as EXCHANGE_CODE        -- TEXT
        , REPORT_DATE       as REPORT_DATE          -- DATE
        , QUANTITY          as QUANTITY             -- NUMBER
        , COST_BASE         as COST_BASE            -- NUMBER
        , POSITION_VALUE    as POSITION_VALUE       -- NUMBER
        , CURRENCY          as CURRENCY_CODE        -- TEXT

        , 'source_data.abc_bank_position' as RECORD_SOURCE

    FROM {{ source('abc_bank', 'abc_bank_position') }}
),
hashed as (
    SELECT
        concat_ws('|', ACCOUNT_CODE, SECURITY_CODE) as POSITION_HKEY
        , concat_ws('|', ACCOUNT_CODE, SECURITY_CODE,
        SECURITY_NAME, EXCHANGE_CODE, REPORT_DATE,
        QUANTITY, COST_BASE, POSITION_VALUE, CURRENCY_CODE )
        as POSITION_HDIFF
        , *
        , '{{ run_started_at }}' as LOAD_TS_UTC
    FROM src_data
)

SELECT * FROM hashed
