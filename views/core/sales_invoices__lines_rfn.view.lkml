include: "/views/base/sales_invoices__lines.view"
include: "/views/core/otc__lines_common_product_dimensions_ext.view"

view: +sales_invoices__lines {
    extends: [otc__lines_common_product_dimensions_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${line_id},${order_line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    sql: COALESCE(${TABLE}.LINE_ID,-1) ;;
  }

  dimension: order_line_id {primary_key: no }

  measure: invoice_line_count {
    type: count
  }


  dimension: is_null_invoice_line {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.LINE_ID is null ;;
  }

  measure: count_distinct_item_part_number {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${item_part_number},'Unknown') ;;
  }

 }
