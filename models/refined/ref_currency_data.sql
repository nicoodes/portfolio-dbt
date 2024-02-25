with
current_snapshot as (
    select * exclude (DBT_SCD_ID, DBT_UPDATED_AT, DBT_VALID_FROM, DBT_VALID_TO)
    from {{ ref('snsh_currency_data') }}
    where DBT_VALID_TO is null
    )
select * from current_snapshot