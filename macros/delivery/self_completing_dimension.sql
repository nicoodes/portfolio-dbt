{%- macro self_completing_dimension(
    dim_rel,
    dim_key_column,
    dim_default_key_value = '-1',
    rel_columns_to_exclude = [],
    fact_defs = []
) -%}
{% do rel_columns_to_exclude.append(dim_key_column) -%}
WITH
dim_base as (
    SELECT
        {{ dim_key_column }}
        , d.* EXCLUDE( {{rel_columns_to_exclude|join(', ')}} )
    FROM {{ dim_rel }} as d
),
fact_key_list as (
    {% if fact_defs|length > 0 %} -- If some FACT passed
        {%- for fact_model_key in fact_defs %}
            SELECT DISTINCT
                {{fact_model_key['key']}} as FOREIGN_KEY
            FROM {{ ref(fact_model_key['model']) }}
            WHERE {{fact_model_key['key']}} is not null
            {% if not loop.last %} union {% endif %}
        {%- endfor -%}
    {%- else %} -- If NO FACT, list is empty.
        select null as FOREIGN_KEY WHERE false
    {%- endif%}
),
missing_keys as (
    SELECT fkl.FOREIGN_KEY
    FROM fact_key_list fkl
    LEFT OUTER JOIN dim_base
        ON dim_base.{{dim_key_column}} = fkl.FOREIGN_KEY
    WHERE dim_base.{{dim_key_column}} is null
),
default_record as (
    SELECT *
    FROM dim_base
    WHERE {{dim_key_column}} = '{{dim_default_key_value}}'
    LIMIT 1
),
dim_missing_entries as (
    SELECT
        mk.FOREIGN_KEY,
        dr.* EXCLUDE( {{ dim_key_column }} )
    FROM missing_keys as mk
    JOIN default_record dr
),
dim as (
    SELECT * FROM dim_base
    UNION ALL
    SELECT * FROM dim_missing_entries
)
SELECT * FROM dim
{% endmacro %}