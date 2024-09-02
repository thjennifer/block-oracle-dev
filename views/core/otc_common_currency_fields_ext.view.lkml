#########################################################{
# PURPOSE
# Provides consistent labels/descriptions/SQL for currency-related
# fields used in:
#   sales_orders
#   sales_orders_daily_agg__lines
#   sales_orders_daily_agg__lines__amounts
#   sales_invoices
#   sales_invoices_daily_agg
#   sales_invoices_daily_agg__amounts
#   sales_payments
#   sales_payments_daily_agg
#   sales_payments_daily_agg__amounts
#   sales_payments_dso_days_agg_pdt
#
# Defines labels & descriptions for all views and SQL for select views for dimensions:
#   target_currency_code
#   is_incomplete_conversion
#
# Defines measure:
#   alert_note_for_incomplete_currency_conversion
#
# NOTE
#   - When a dimension is extended into a view where the SQL property has already been
#     defined, the existing SQL property will not be replaced.
#########################################################}

view: otc_common_currency_fields_ext {
  extension: required

  dimension: target_currency_code {
    hidden: no
    group_label: "{%- assign v = _view._name | split: '_' -%}
                  {%- if v contains 'amounts' or v contains 'dso' or v contains 'agg' -%}{%- else -%}Currency Conversion{%- endif -%}"
    label: "Currency (Target)"
    description:  "Code indicating the target currency into which the source currency is converted"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "{%- assign v = _view._name | split: '_' -%}
                   {%- if v contains 'amounts' or v contains 'dso' or v contains 'agg' -%}{%- else -%}Currency Conversion{%- endif -%}"
    description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD. If yes, should check if CurrencyRateMD table is missing any dates or currencies"
    sql:  {%- assign v = _view._name -%}
          {%- assign group_a = 'sales_orders_daily_agg__lines||sales_invoices_daily_agg||sales_payments_daily_agg||sales_applied_receivables_daily_agg' | split: '||' -%}
          {%- if group_a contains v -%}
             (select MAX(IS_INCOMPLETE_CONVERSION) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code})
          {%- endif -%};;
  }

  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in HTML when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated"
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}<span style='color: red; font-size: 16px;'>&#9888; </span> For time frame and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

}
