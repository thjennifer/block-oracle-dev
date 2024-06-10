include: "/views/base/sales_invoices__lines__item_descriptions.view"
include: "/views/core/otc_unnest_item_descriptions_common_fields_ext.view"

view: +sales_invoices__lines__item_descriptions {

  fields_hidden_by_default: yes
  extends: [otc_unnest_item_descriptions_common_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: {% if sales_invoices__lines__item_categories._in_query %}
                  CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${language_code},${sales_invoices__lines__item_categories.category_set_id})
          {%else%}CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${language_code})
          {%endif%};;
  }

  measure: count_distinct_description {
    hidden: no
    type: count_distinct
    view_label: "TEST STUFF"
    sql: ${item_description} ;;
  }


   }
