select
    *
    , position_value - cost_base as unrealized_profit
    , round(unrealized_profit / cost_base, 5) as unrealized_profit_pct
from {{ source('abc_bank', 'abc_bank_position') }}