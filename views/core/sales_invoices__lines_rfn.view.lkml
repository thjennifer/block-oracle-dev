include: "/views/base/sales_invoices__lines.view"
include: "/views/core/otc_derive_common_product_fields_ext.view"

view: +sales_invoices__lines {
    extends: [otc_derive_common_product_fields_ext]

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${line_id},${order_line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    sql: COALESCE(${TABLE}.LINE_ID,-1) ;;
  }

  dimension: description {
    label: "Line Description"
  }

  dimension: order_header_id {
    group_label: "Order Headers & Lines"
  }

  dimension: order_line_id {
    primary_key: no
    group_label: "Order Headers & Lines"
    }

  dimension: order_source_id {
    group_label: "Order Headers & Lines"
  }

  dimension: order_source_name {
    group_label: "Order Headers & Lines"
  }

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

  measure: count_distinct_fiscal_period_set {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${fiscal_period_set_name},'Unknown') ;;
  }

 }