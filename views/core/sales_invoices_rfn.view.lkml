include: "/views/base/sales_invoices.view"

view: +sales_invoices {

  sql_table_name: {% assign p = sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesInvoices` ;;


  dimension: invoice_id {
    hidden: no
    primary_key: yes
    description: "Distinct ID of invoice."
    value_format_name: id
  }

  dimension: invoice_number {
    description: "Invoice number. Note, this is a string data type and may not be a unique value."
  }

  dimension: invoice_type {
    label: "Invoice Type Code"
  }

  dimension: invoice_type_id {
    value_format_name: id
  }

  dimension: invoice_type_name {
    description: "Name or description of invoice type."
  }

  dimension: invoice_type_id_and_name {
    description: "Combination of ID and Name in form of 'ID: Name' "
    sql: CONCAT(${invoice_type_id},": ",${invoice_type_name}) ;;
  }


 }
