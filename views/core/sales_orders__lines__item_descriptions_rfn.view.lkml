include: "/views/base/sales_orders__lines__item_descriptions.view"
include: "/views/core/otc_unnest_item_descriptions_common_fields_ext.view"

view: +sales_orders__lines__item_descriptions {
  fields_hidden_by_default: yes
  extends: [otc_unnest_item_descriptions_common_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${language_code}) ;;
  }


   }
