select *
from {{ ref('stg_abc_bank_security_info') }}
where security_code='-1' and record_source!='System.DefaultKey'