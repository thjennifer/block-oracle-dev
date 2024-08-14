include: "/views/base/sales_applied_receivables.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"

view: +sales_applied_receivables {

  extends: [otc_common_fiscal_gl_dates_ext]

  # dimension: key {
  #   hidden: yes
  #   primary_key: yes
  #   sql: CONCAT(${receivable_application_id},${cash_receipt_id}) ;;
  # }

  dimension: receivable_application_id {
    primary_key: yes
    value_format_name: id
  }

  measure: count {hidden: yes}

  measure: application_count {
    type: count
    drill_fields: [application_details*]
  }

  set: application_details {
    fields: [receivable_application_id,cash_receipt_id,application_type,invoice_id,amount_applied,event_date,ledger_date,cash_receipt__deposit_date,cash_receipt__amount]
  }

   }