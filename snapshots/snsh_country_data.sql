{% snapshot snsh_country_data %}
{{ 
    config(
        unique_key='COUNTRY_HKEY',
        strategy='check',
        check_cols=['COUNTRY_HDIFF']
    )
 }}
select * from {{ ref('stg_country_data') }}
{% endsnapshot %}