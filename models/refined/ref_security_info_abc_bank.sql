with
current_from_history as(
    {{ 
        current_from_history(
            history_rel=ref('hist_abc_bank_security_info'),
            key_column='SECURITY_HKEY'
        )
     }}
)
select *
from current_from_history