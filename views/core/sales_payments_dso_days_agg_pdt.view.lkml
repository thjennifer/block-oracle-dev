#########################################################{
# PURPOSE
# Generate a daily PDT that computes DSO values for each
# Target Currency and DSO # days combination.
#
# Possible DSO days are: 30, 90 or 365 as defined in the query below.
# To change this, edit the SQL line containing ARRAY[30,90,365].
#
# DSO Start and End Date are derived based on either:
#     current_date
#     target date if test data set (see constant default_target_date)
#
# SOURCES
#   `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg`
#   Extends view otc_common_currency_fields_ext.view
#
# REFERENCED BY
#   Explore sales_payments_dso_days_agg_pdt
#   LookML dashboard otc_billing_accounts_receivable
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#
# NOTES
# - Only Invoice rows are used in DSO calc (IS_PAYMENT_TRANSACTION = false)
# - The dimensions dso_days and target_currency_code will be included in days_sales_outstanding calculation
#   even if not included in the query. If query returns more rows than expected, add these two dimensions
#   to the query or filter to a single value for each.
#########################################################}
include: "/views/core/otc_common_currency_fields_ext.view"

view: sales_payments_dso_days_agg_pdt {

  label: "Sales Payments DSO Days Agg"

  extends: [otc_common_currency_fields_ext]

  derived_table: {
      datagroup_trigger: sales_payments_daily_agg_change

      sql: SELECT
              DSO_DAYS,
              ANY_VALUE(dso.DSO_START_DATE) AS DSO_START_DATE,
              ANY_VALUE(dso.DSO_END_DATE) AS DSO_END_DATE,
              hdr.BILL_TO_SITE_USE_ID,
              ANY_VALUE(hdr.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
              ANY_VALUE(hdr.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
              ANY_VALUE(hdr.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
              hdr.BUSINESS_UNIT_ID,
              ANY_VALUE(hdr.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
              amt.TARGET_CURRENCY_CODE,
              SUM(TOTAL_ORIGINAL) AS TOTAL_ORIGINAL,
              SUM(TOTAL_REMAINING) AS TOTAL_REMAINING,
              MAX(IS_INCOMPLETE_CONVERSION) AS IS_INCOMPLETE_CONVERSION
            FROM (
                  SELECT
                    DSO_DAYS,
                    DATE_SUB(DATE(@{default_target_date}) - 1, INTERVAL DSO_DAYS DAY) AS DSO_START_DATE,
                    @{default_target_date} - 1 AS DSO_END_DATE
                  FROM
                  --update with additional DSO days as necessary
                    UNNEST(ARRAY[30,90,365]) AS DSO_DAYS
                  ) dso
             JOIN
              `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg` hdr
               ON
              hdr.TRANSACTION_DATE BETWEEN dso.DSO_START_DATE
              AND dso.DSO_END_DATE
            LEFT JOIN
              UNNEST(AMOUNTS) AS amt
            WHERE IS_PAYMENT_TRANSACTION = FALSE
            GROUP BY
              DSO_DAYS,
              BILL_TO_SITE_USE_ID,
              BUSINESS_UNIT_ID,
              TARGET_CURRENCY_CODE  ;;
    }

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${dso_days},${bill_to_site_use_id},${business_unit_id},${target_currency_code} ) ;;
  }

  dimension: dso_days {
    hidden: yes
    type: number
    label: "DSO Days"
    sql: ${TABLE}.DSO_DAYS ;;
  }

  dimension: dso_days_string {
    hidden: no
    label: "DSO Days"
    description: "Number of days used to calculate Days Sales Outstanding"
    type: string
    sql: CAST(${dso_days} AS STRING) ;;
    order_by_field: dso_days
  }

  dimension: dso_start_date {
    type: date
    datatype: date
    label: "DSO Start Date"
    description: "Start date of the period used to calculate Days Sales Outstanding"
    sql: ${TABLE}.DSO_START_DATE ;;
  }

  dimension: dso_end_date {
    type: date
    datatype: date
    label: "DSO End Date"
    description: "End date of the period used to calculate Days Sales Outstanding"
    sql: ${TABLE}.DSO_END_DATE ;;
  }

  dimension: bill_to_customer_country {
    type: string
    group_label: "Bill to Customer"
    description: "Billed customer country name"
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: bill_to_customer_name {
    type: string
    group_label: "Bill to Customer"
    description: "Billed customer account name"
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
  }
  dimension: bill_to_customer_number {
    type: string
    group_label: "Bill to Customer"
    description: "Billed customer account number"
    sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
  }
  dimension: bill_to_site_use_id {
    type: number
    group_label: "Bill to Customer"
    description: "Foreign key identifying the Site Use entity that was billed to"
    sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
  }
  dimension: business_unit_id {
    type: number
    description: "Foreign key identifying the business unit that performed this transaction"
    sql: ${TABLE}.BUSINESS_UNIT_ID ;;
  }
  dimension: business_unit_name {
    type: string
    description: "Business unit name"
    sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
  }

  dimension: target_currency_code {
    #type, label and description defined in otc_common_currency_fields_ext
    sql: ${TABLE}.TARGET_CURRENCY_CODE ;;
  }

  dimension: total_original {
    hidden: yes
    type: number
    sql: ${TABLE}.TOTAL_ORIGINAL ;;
  }

  dimension: total_remaining {
    hidden: yes
    type: number
    sql: ${TABLE}.TOTAL_REMAINING ;;
  }

  dimension: is_incomplete_conversion {
    #type, label and description defined in otc_common_currency_fields_ext
    sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
  }

  measure: total_amount_original_target_currency {
    hidden: no
    type: sum
    label: "Amount Original (Target Currency)"
    description: "Total amount due originally in target currency where payment class code <> 'PMT'"
    sql: ${total_original} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "Amount Due Remaining (Target Currency)"
    description: "Total amount due remaining in target currency where payment class code <> 'PMT'"
    sql: ${total_remaining} ;;
    value_format_name: decimal_2
  }

#--> The dimensions dso_days and target_currency_code will be included in days_sales_outstanding calculation even
#--> if not included in the query. If query returns more rows than expected, add these two dimensions to the query
#--> or filter to a single value for each.
  measure: days_sales_outstanding {
    type: number
    description: "Average time, in days, for which the receivables are outstanding. Calculated as: (Ending Receivables Balance / Credit Sales) * N where N is the number of days in the period. Choose 30, 90 or 365 days for the calculation."
    sql: SAFE_DIVIDE(${total_amount_due_remaining_target_currency},${total_amount_original_target_currency}) * ANY_VALUE(${dso_days}) ;;
    value_format_name: decimal_1
    required_fields: [dso_days,target_currency_code]
    drill_fields: [dso_details*]
  }

  set: dso_details{
    fields: [dso_days, bill_to_customer_name,bill_to_customer_country,days_sales_outstanding]
  }

}
