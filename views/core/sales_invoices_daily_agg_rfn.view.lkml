#########################################################{
# PURPOSE
# The SalesInvoicesDailyAgg table and its corresponding Looker view sales_invoices_daily_agg reflect
# an aggregation of invoices by the following dimensions:
#   Invoice Date
#   Business Unit ID
#   Bill To Site ID
#   Invoice Type Code
#   Order Source ID
#   Item Category Set ID
#   Category ID
#
# SOURCES
#   Refines base view sales_invoices_daily_agg
#   Extends view otc_common_item_categories_ext
#   Extends view otc_common_currency_fields_ext
#   Extends view sales_invoices_common_amount_fields_ext
#
# REFERENCED BY
#   Explore sales_invoices_daily_agg
#
# EXTENDED FIELDS
#    category_id, category_description, category_name_code
#    target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion
#    total_transaction_amount_target_currency, total_tax_amount_target_currency, and other amounts
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_invoices_daily_agg__amounts - provides Total Amounts converted to Target Currencies by Item Categories & Item Organization
#
# NOTES
# - Amounts where target_currency matches the value in parameter_target_currency are defined in this view.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
#########################################################}

include: "/views/base/sales_invoices_daily_agg.view"
include: "/views/core/otc_common_item_categories_ext.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_invoices_common_amount_fields_ext.view"

view: +sales_invoices_daily_agg {

  fields_hidden_by_default: yes

  extends: [otc_common_item_categories_ext,otc_common_currency_fields_ext,sales_invoices_common_amount_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${invoice_raw},${business_unit_id},${bill_to_site_use_id},${invoice_type_id},${order_source_id},${category_set_id},${category_id}) ;;
  }

  dimension: business_unit_id {
    hidden: no
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ",${business_unit_id})) ;;
  }

  dimension: order_source_id {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_ID,-1) ;;
    value_format_name: id
  }

  dimension: order_source_name {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,"Unknown") ;;
  }

#########################################################
# DIMENSIONS: Customer
#{

  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_number {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end customer dimensions

#########################################################
# DIMENSIONS: Invoice Type & Status
#{

  dimension: invoice_type_id {
    hidden: no
    group_label: "Invoice Type"
    value_format_name: id
  }

  dimension: invoice_type {
    hidden: no
    group_label: "Invoice Type"
    label: "Invoice Type Code"
  }

  dimension: invoice_type_name {
    hidden: no
    group_label: "Invoice Type"
    description: "Name or description of invoice type"
  }

  dimension: invoice_type_id_and_name {
    hidden: no
    group_label: "Invoice Type"
    description: "Combination of ID and Name in form of 'ID: Name' "
    sql: CONCAT(${invoice_type_id},": ",${invoice_type_name}) ;;
  }

#} end invoice type dimensions

#########################################################
# DIMENSION: Item Categories
#{
# category_id, category_description and category_name_code extended from otc_common_item_categories_ext

  dimension: category_set_id {
    sql:  COALESCE(${TABLE}.ITEM_CATEGORY_SET_ID,-1) ;;
    value_format_name:  id
  }

  dimension: category_set_name {
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_SET_NAME,"Unknown") ;;
  }

  dimension: item_organization_id {
    hidden: no
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
  }
#} end item categories

#########################################################
# DIMENSIONS: Dates
#{

  dimension_group: invoice {
    hidden: no
  }

  dimension: invoice_month_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Month Number"
    description: "Invoice month as number 1 to 12"
  }

  dimension: invoice_quarter_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Quarter Number"
    description: "Invoice quarter as number 1 to 4"
  }

  dimension: invoice_year_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Year Number"
    description: "Invoice year as integer"
    value_format_name: id
  }


#} end dates

#########################################################
# DIMENSIONS: Amounts in Target Currency
#{
# amounts hidden as measures are shown instead
# other field properties extended from sales_invoices_common_amount_fields_ext

  dimension: revenue_amount_target_currency {
    sql: (select SUM(TOTAL_REVENUE) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: transaction_amount_target_currency {
    sql: (select SUM(TOTAL_REVENUE) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: tax_amount_target_currency {
    sql: (select SUM(TOTAL_TAX) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: discount_amount_target_currency {
    sql: (select SUM(TOTAL_DISCOUNT) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: list_price_target_currency {
    description: "Sum of post-tax list amounts across all lines"
    sql: (select SUM(TOTAL_LIST) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: selling_price_target_currency {
    description: "Sum of pre-tax selling amounts across all lines"
    sql: (select SUM(TOTAL_SELLING) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: intercompany_list_price_target_currency {
    description: "Sum of post-tax list amounts across all intercompany lines"
    sql: (select SUM(TOTAL_LIST) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

  dimension: intercompany_selling_price_target_currency {
    description: "Sum of pre-tax selling amounts across all intercompany lines"
    sql: (select SUM(TOTAL_SELLING) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Average list and selling prices
#{
#
  measure: total_list_price_target_currency  {
    type: sum
    sql:  ${list_price_target_currency};;
  }

  measure: total_selling_price_target_currency  {
    type: sum
    sql:  ${selling_price_target_currency};;
  }

  measure: total_intercompany_list_price_target_currency  {
    type: sum
    sql:  ${list_price_target_currency};;
  }

  measure: total_intercompany_selling_price_target_currency  {
    type: sum
    sql:  ${selling_price_target_currency};;
  }

  measure: total_invoice_lines {
    type: sum
    sql: ${num_invoice_lines} ;;
  }

  measure: total_intercompany_invoice_lines {
    type: sum
    sql: ${num_intercompany_lines} ;;
  }

  measure: average_list_price_target_currency {
    hidden: no
    type: number
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average list price target currency"
    sql: SAFE_DIVIDE(${total_list_price_target_currency},${total_invoice_lines}) ;;
    value_format_name: decimal_2
  }

  measure: average_selling_price_target_currency {
    hidden: no
    type: number
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average selling price target currency"
    sql: SAFE_DIVIDE(${total_selling_price_target_currency},${total_invoice_lines}) ;;
    value_format_name: decimal_2
  }

  measure: average_intercompany_list_price_target_currency {
    hidden: no
    type: number
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average list price target currency for intercompany lines"
    sql: SAFE_DIVIDE(${total_list_price_target_currency},${total_invoice_lines}) ;;
    value_format_name: decimal_2
  }

  measure: average_intercompany_selling_price_target_currency {
    hidden: no
    type: number
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average selling price target currency for intercompany lines"
    sql: SAFE_DIVIDE(${total_selling_price_target_currency},${total_invoice_lines}) ;;
    value_format_name: decimal_2
  }


#} end average price measures
}
