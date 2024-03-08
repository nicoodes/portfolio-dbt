{{ save_history(
    input_rel=ref('stg_abc_bank_security_info'),
    key_column='SECURITY_HKEY',
    diff_column='SECURITY_HDIFF'
) }}