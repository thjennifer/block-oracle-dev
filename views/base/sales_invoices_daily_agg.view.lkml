view: sales_invoices_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesInvoicesDailyAgg` ;;

  dimension: amounts {
    hidden: yes
    sql: ${TABLE}.AMOUNTS ;;
  }
  dimension: bill_to_customer_country {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: bill_to_customer_name {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
  }
  dimension: bill_to_customer_number {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
  }
  dimension: bill_to_site_use_id {
    type: number
    sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
  }
  dimension: business_unit_id {
    type: number
    sql: ${TABLE}.BUSINESS_UNIT_ID ;;
  }
  dimension: business_unit_name {
    type: string
    sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
  }
  dimension_group: invoice {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.INVOICE_DATE ;;
  }
  dimension: invoice_month_num {
    type: number
    sql: ${TABLE}.INVOICE_MONTH_NUM ;;
  }
  dimension: invoice_quarter_num {
    type: number
    sql: ${TABLE}.INVOICE_QUARTER_NUM ;;
  }
  dimension: invoice_type {
    type: string
    sql: ${TABLE}.INVOICE_TYPE ;;
  }
  dimension: invoice_type_id {
    type: number
    sql: ${TABLE}.INVOICE_TYPE_ID ;;
  }
  dimension: invoice_type_name {
    type: string
    sql: ${TABLE}.INVOICE_TYPE_NAME ;;
  }
  dimension: invoice_year_num {
    type: number
    sql: ${TABLE}.INVOICE_YEAR_NUM ;;
  }
  dimension: item_category_description {
    type: string
    sql: ${TABLE}.ITEM_CATEGORY_DESCRIPTION ;;
  }
  dimension: item_category_id {
    type: number
    sql: ${TABLE}.ITEM_CATEGORY_ID ;;
  }
  dimension: item_category_name {
    type: string
    sql: ${TABLE}.ITEM_CATEGORY_NAME ;;
  }
  dimension: item_category_set_id {
    type: number
    sql: ${TABLE}.ITEM_CATEGORY_SET_ID ;;
  }
  dimension: item_category_set_name {
    type: string
    sql: ${TABLE}.ITEM_CATEGORY_SET_NAME ;;
  }
  dimension: item_organization_id {
    type: number
    sql: ${TABLE}.ITEM_ORGANIZATION_ID ;;
  }
  dimension: item_organization_name {
    type: string
    sql: ${TABLE}.ITEM_ORGANIZATION_NAME ;;
  }
  dimension: order_source_id {
    type: number
    sql: ${TABLE}.ORDER_SOURCE_ID ;;
  }
  dimension: order_source_name {
    type: string
    sql: ${TABLE}.ORDER_SOURCE_NAME ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      item_category_name,
      invoice_type_name,
      item_category_set_name,
      business_unit_name,
      item_organization_name,
      bill_to_customer_name,
      order_source_name
    ]
  }

}

# view: sales_invoices_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_invoices_daily_agg__amounts {
#     type: string
#     hidden: yes
#     sql: sales_invoices_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_discount {
#     type: number
#     sql: TOTAL_DISCOUNT ;;
#   }
#   dimension: total_intercompany_list {
#     type: number
#     sql: TOTAL_INTERCOMPANY_LIST ;;
#   }
#   dimension: total_intercompany_selling {
#     type: number
#     sql: TOTAL_INTERCOMPANY_SELLING ;;
#   }
#   dimension: total_list {
#     type: number
#     sql: TOTAL_LIST ;;
#   }
#   dimension: total_revenue {
#     type: number
#     sql: TOTAL_REVENUE ;;
#   }
#   dimension: total_selling {
#     type: number
#     sql: TOTAL_SELLING ;;
#   }
#   dimension: total_tax {
#     type: number
#     sql: TOTAL_TAX ;;
#   }
#   dimension: total_transaction {
#     type: number
#     sql: TOTAL_TRANSACTION ;;
#   }
# }
