with
current_from_snapshot as(
    {{ 
        current_from_snapshot(
            snsh_ref=ref('snsh_abc_bank_security_info')
        )
     }}
)
select *
from current_from_snapshot