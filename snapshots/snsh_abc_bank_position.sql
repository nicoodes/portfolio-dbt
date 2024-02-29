{% snapshot snsh_abc_bank_position %}
{{ 
    config(
        unique_key='POSITION_HKEY',
        strategy= 'check',
        check_cols= ['POSITION_HDIFF'],
        invalidate_hard_deletes=True
    ) 
    }}
select * from {{ ref('stg_abc_bank_position') }}
{% endsnapshot %}