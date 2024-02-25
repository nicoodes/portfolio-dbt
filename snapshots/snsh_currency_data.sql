{% snapshot snsh_currency_data %}
{{ 
    config(
        unique_key='CURRENCY_HKEY',
        strategy='check',
        check_cols=['CURRENCY_HDIFF']
    )
     }}
SELECT * FROM {{ ref('stg_currency_data') }}
{% endsnapshot %}