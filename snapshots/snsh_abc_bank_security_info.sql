{% snapshot snsh_abc_bank_security_info %}
{{ 
    config(
        unique_key='SECURITY_HKEY',
        strategy='check',
        check_cols=['SECURITY_HDIFF']
    )
     }}
select * from {{ ref('stg_abc_bank_security_info') }}
{% endsnapshot %}