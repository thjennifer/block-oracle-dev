#########################################################{
# PURPOSE
# Generate a daily PDT that compute DSO values for each
# Target Currency and DSO # days combination.
#
# Possible DSO days are: 30, 90 or 365 as defined in query below--see line with ARRAY[30,90,365].
#
# DSO Start and End Date are derived based on either:
#     current_date
#     target date if test data set (see constant default_target_date)
#
# SOURCES
#   `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg`
#
# REFERENCED BY
#   Explore sales_payments_dso_days_agg_pdt
#   LookML dashboard otc_billing_accounts_receivable
#
# NOTES
# - Only Invoice rows are used in DSO calc (IS_PAYMENT_TRANSACTION = false)
# - An alternative to using the PDT is defined in view dso_dynamic_days_sdt
#   which calculates DSO dyanmically based on user-provided value for
#   parameter_dso_number_of_days._parameter_value. This view is part of
#   the sales_payments Explore.
#########################################################}

include: "/views/core/dso_days_sdt.view"

view: sales_payments_dso_days_agg_pdt {

    label: "Sales Payments DSO Days Agg"

    derived_table: {
      # datagroup_trigger: once_a_day_at_5

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
      type: number
      label: "DSO Days"
      sql: ${TABLE}.DSO_DAYS ;;
    }

    dimension: dso_days_string {
      hidden: yes
      type: string
      sql: CAST(${dso_days} AS STRING) ;;
    }

    dimension: dso_start_date {
      type: date
      datatype: date
      label: "DSO Start Date"
      sql: ${TABLE}.DSO_START_DATE ;;
    }

    dimension: dso_end_date {
      type: date
      datatype: date
      label: "DSO End Date"
      sql: ${TABLE}.DSO_END_DATE ;;
    }

    dimension: bill_to_site_use_id {
      type: number
      sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
    }

    dimension: bill_to_customer_number {
      type: string
      sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
    }

    dimension: bill_to_customer_name {
      type: string
      sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
    }

    dimension: bill_to_customer_country {
      type: string
      sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
    }

    dimension: business_unit_id {
      type: number
      sql: ${TABLE}.BUSINESS_UNIT_ID ;;
    }

    dimension: business_unit_name {
      type: string
      sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
    }

    dimension: target_currency_code {
      type: string
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
      type: yesno
      sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
    }

    measure: total_amount_original_target_currency {
      hidden: no
      type: sum
      label: "Amount Original (Target Currency)"
      sql: ${total_original} ;;
      value_format_name: decimal_2
    }

    measure: total_amount_due_remaining_target_currency {
      hidden: no
      type: sum
      label: "Amount Due Remaining (Target Currency)"
      sql: ${total_remaining} ;;
      value_format_name: decimal_2
    }

    measure: days_sales_outstanding {
      type: number
      sql: SAFE_DIVIDE(${total_amount_due_remaining_target_currency},${total_amount_original_target_currency}) * ANY_VALUE(${dso_days}) ;;
      value_format_name: decimal_1
      # required_fields: [dso_days,target_currency_code]
      drill_fields: [dso_details*]
    }

    set: dso_details{
      fields: [bill_to_customer_name,bill_to_customer_country,days_sales_outstanding]
    }


    }
