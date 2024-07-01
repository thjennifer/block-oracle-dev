include: "/views/base/sales_invoices_daily_agg.view"
include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_invoices_daily_agg {

  fields_hidden_by_default: yes

  extends: [otc_unnest_item_categories_common_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${invoice_raw},${business_unit_id},${bill_to_site_use_id},${invoice_type_id},${order_source_id}D,${item_category_set_id},${item_category_id}) ;;
 }

#########################################################
# Key Dimensions
#{
  dimension: business_unit_id {
    hidden: no
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ",${business_unit_id})) ;;
  }

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
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill To Customer Number: ",${bill_to_customer_number})) ;;
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

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
    description: "Name or description of invoice type."
  }

  dimension: invoice_type_id_and_name {
    hidden: no
    group_label: "Invoice Type"
    description: "Combination of ID and Name in form of 'ID: Name' "
    sql: CONCAT(${invoice_type_id},": ",${invoice_type_name}) ;;
  }

#TEMPORARILY hide until available in table
  dimension: category_description {
    hidden: yes
  }


#} end key dimensions

#########################################################
# Dates
#{

  dimension_group: invoice {
    hidden: no
  }

  dimension: invoice_month_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Month Num"
    description: "Invoice Month as Number 1 to 12"
  }

  dimension: invoice_quarter_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Quarter Num"
    description: "Invoice Quarter as Number 1 to 4"
  }

  dimension: invoice_year_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Year Num"
    description: "Invoice Year as Integer"
    value_format_name: id
  }


#} end dates


measure: row_count {
  type: count
}

   }
