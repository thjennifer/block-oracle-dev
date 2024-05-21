include: "/views/base/sales_orders.view"

view: +sales_orders__lines__item_descriptions {
  fields_hidden_by_default: yes


  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${sales_orders__lines.item_part_number},${language}) ;;
  }

  dimension: item_description {
    hidden: no
    type: string
    sql: ${TABLE}.TEXT ;;
    full_suggestions: yes
  }

  dimension: language {
    hidden: no
    type: string
    sql: ${TABLE}.LANGUAGE ;;
    full_suggestions: yes
  }

  parameter: parameter_language {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Language"
    # suggest_explore: language_codes_sdt
    # suggest_dimension: language_codes_sdt.language_code
    suggest_explore: item_md
    suggest_dimension: item_md__item_descriptions.language
    default_value: "US"
  }

   }
