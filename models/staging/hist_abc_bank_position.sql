{{ save_history(
    input_rel=ref('stg_abc_bank_position'),
    key_column='POSITION_HKEY',
    diff_column='POSITION_HDIFF'
) }}