{% test not_empty(model, column_name) %}
with
validation_errors as (
    select {{column_name}}
    from {{model}}
    where len({{column_name}}) = 0
)
select * from validation_errors
{% endtest %} 