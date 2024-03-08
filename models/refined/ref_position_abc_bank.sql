with
position as(
    {{ 
        current_from_history(
            history_rel=ref('hist_abc_bank_position_with_closing'),
            key_column='POSITION_HKEY'
        )
     }}
),
security as (
    select * from {{ ref('ref_security_info_abc_bank') }}
)
-- removes in page 491
-- select
--     p.* exclude (security_code)
--     , coalesce(s.security_code, '-1') as security_code
--     , position_value - cost_base as unrealized_profit
--     , round(div0(unrealized_profit, cost_base), 5)*100 as unrealized_profit_pct
-- from position as p
-- left outer join security as s
--     on(s.security_code=p.security_code)
SELECT
    p.*
    , POSITION_VALUE - COST_BASE as UNREALIZED_PROFIT
    , ROUND(DIV0(UNREALIZED_PROFIT, COST_BASE), 5)*100
    as UNREALIZED_PROFIT_PCT
FROM position as p