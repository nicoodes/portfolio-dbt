{{ self_completing_dimension(
    dim_rel = ref('ref_security_info_abc_bank'),
    dim_key_column = 'SECURITY_CODE',
    dim_default_key_value = '-1',
    rel_columns_to_exclude = ['SECURITY_HKEY', 'SECURITY_HDIFF'],
    fact_defs = [ {'model': 'ref_position_abc_bank', 'key': 'SECURITY_CODE'} ]
) }}