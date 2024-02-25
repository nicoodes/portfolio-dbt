with
current_from_snapshot as(
    select * exclude (DBT_SCD_ID, DBT_UPDATED_AT, DBT_VALID_FROM, DBT_VALID_TO)
    from {{ ref('snsh_abc_bank_security_info') }}
    where dbt_valid_to is null
)
select *
from current_from_snapshot