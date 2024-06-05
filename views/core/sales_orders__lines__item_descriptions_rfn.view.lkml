include: "/views/base/sales_orders__lines__item_descriptions.view"
include: "/views/core/otc_unnest_item_descriptions_common_fields_ext.view"

view: +sales_orders__lines__item_descriptions {
  fields_hidden_by_default: yes
  extends: [otc_unnest_item_descriptions_common_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${sales_orders__lines.inventory_item_id},${sales_orders__lines.item_part_number},${language_code}) ;;
  }



  measure: count_distinct_description {
    hidden: no
    type: count_distinct
    view_label: "TEST STUFF"
    sql: ${item_description} ;;
  }


   }
