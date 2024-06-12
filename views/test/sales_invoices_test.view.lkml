include: "/views/core/sales_invoices_rfn.view"

view: +sales_invoices {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesInvoices` ;;
  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesInvoices` ;;
#########################################################
# TEST STUFF
#
#{
  dimension: test_invoice_month {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_MONTH ;;
  }

  dimension: test_invoice_quarter {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_QUARTER ;;
  }

  dimension: test_invoice_year {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_YEAR ;;
  }

  measure: count_distinct_ledger_id {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${ledger_id},-1) ;;
  }

  dimension: invoice_number_length {
    view_label: "TEST STUFF"
    type: number
    sql: LENGTH(${invoice_number}) ;;
  }

#}

   }
