{% snapshot snsh_exchange_data %}
{{ 
    config(
        unique_key='EXCHANGE_HKEY',
        strategy='check',
        check_cols=['EXCHANGE_HDIFF']
    )
 }}
 select * from {{ ref('stg_exchange_data') }}
{% endsnapshot %}