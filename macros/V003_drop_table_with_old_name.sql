{% macro V003_drop_view(
    database=target.database,
    schema_prefix=target.schema
) %}
drop view if exists {{database}}.{{schema_prefix}}_refined.ref_abc_bank_security_info;
{% endmacro %}