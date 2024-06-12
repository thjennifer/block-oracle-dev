include: "/views/core/sales_invoices__lines_rfn.view"

view: +sales_invoices__lines {

  dimension: is_null_invoice_line {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.LINE_ID is null ;;
  }

  dimension: is_null_order_header_id {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDER_HEADER_ID is null ;;
  }

  dimension: is_null_tax_amount {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.TAX_AMOUNT is null ;;
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

  dimension: is_difference_invoice_date_and_ledger_date {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.LEDGER_DATE <> ${sales_invoices.invoice_raw} ;;
  }

  dimension: list_price_times_invoice_quantity {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${unit_list_price} *  ${invoiced_quantity} ;;
    value_format_name: decimal_2
  }

  dimension: selling_price_times_invoice_quantity {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${unit_selling_price} *  ${invoiced_quantity} ;;
    value_format_name: decimal_2
  }

  dimension: is_different_list_and_selling_price {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${unit_list_price}<> ${unit_selling_price};;
  }

  dimension: is_different_revenue_and_txn_amount {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${revenue_amount}<> ${transaction_amount};;
  }

  dimension: has_invoiced_and_credited_quantity_on_same_line {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${credited_quantity} is not null AND ${invoiced_quantity} is not null;;
  }


   }
