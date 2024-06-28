include: "/views/core/sales_payments_daily_agg_sample_pdt.view"

view: +sales_payments_daily_agg_sample_pdt {

    derived_table: {
      sql:
      {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
      {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
      {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}
        SELECT
        TRANSACTION_DATE,
        ANY_VALUE(TRANSACTION_MONTH_NUM) AS TRANSACTION_MONTH_NUM,
        ANY_VALUE(TRANSACTION_QUARTER_NUM) AS TRANSACTION_QUARTER_NUM,
        ANY_VALUE(TRANSACTION_YEAR_NUM) AS TRANSACTION_YEAR_NUM,
        BILL_TO_SITE_USE_ID,
        ANY_VALUE(BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
        ANY_VALUE(BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
        ANY_VALUE(BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
        BUSINESS_UNIT_ID,
        ANY_VALUE(BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
        PAYMENT_CLASS_CODE,
        ANY_VALUE(IS_PAYMENT_TRANSACTION) AS IS_PAYMENT_TRANSACTION,
        -- These measures use ANY_VALUE because this block is only aggregating the currency amounts
        -- into an array, so non-amount measures should not be re-aggregated to avoid over counting.
        ANY_VALUE(NUM_PAYMENTS) AS NUM_PAYMENTS,
        ANY_VALUE(NUM_CLOSED_PAYMENTS) AS NUM_CLOSED_PAYMENTS,
        ANY_VALUE(TOTAL_DAYS_TO_PAYMENT) AS TOTAL_DAYS_TO_PAYMENT,
        ARRAY_AGG( STRUCT( TARGET_CURRENCY_CODE,
            TOTAL_ORIGINAL,
            TOTAL_REMAINING,
            TOTAL_OVERDUE_REMAINING,
            TOTAL_DOUBTFUL_REMAINING,
            TOTAL_DISCOUNTED,
            TOTAL_APPLIED,
            TOTAL_CREDITED,
            TOTAL_ADJUSTED,
            TOTAL_TAX_ORIGINAL,
            TOTAL_TAX_REMAINING,
            IS_INCOMPLETE_CONVERSION ) ) AS AMOUNTS
      FROM (
        SELECT
          PaymentsAgg.TRANSACTION_DATE,
          ANY_VALUE(PaymentsAgg.TRANSACTION_MONTH_NUM) AS TRANSACTION_MONTH_NUM,
          ANY_VALUE(PaymentsAgg.TRANSACTION_QUARTER_NUM) AS TRANSACTION_QUARTER_NUM,
          ANY_VALUE(PaymentsAgg.TRANSACTION_YEAR_NUM) AS TRANSACTION_YEAR_NUM,
          PaymentsAgg.BILL_TO_SITE_USE_ID,
          ANY_VALUE(PaymentsAgg.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
          ANY_VALUE(PaymentsAgg.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
          ANY_VALUE(PaymentsAgg.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
          PaymentsAgg.BUSINESS_UNIT_ID,
          ANY_VALUE(PaymentsAgg.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
          PaymentsAgg.PAYMENT_CLASS_CODE,
          ANY_VALUE(PaymentsAgg.IS_PAYMENT_TRANSACTION) AS IS_PAYMENT_TRANSACTION,
          SUM(PaymentsAgg.NUM_PAYMENTS) AS NUM_PAYMENTS,
          SUM(PaymentsAgg.NUM_CLOSED_PAYMENTS) AS NUM_CLOSED_PAYMENTS,
          SUM(PaymentsAgg.TOTAL_DAYS_TO_PAYMENT) AS TOTAL_DAYS_TO_PAYMENT,
          TargetCurrs AS TARGET_CURRENCY_CODE,
          SUM( PaymentsAgg.TOTAL_ORIGINAL *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_ORIGINAL,
          SUM( PaymentsAgg.TOTAL_REMAINING *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_REMAINING,
          SUM( PaymentsAgg.TOTAL_OVERDUE_REMAINING *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_OVERDUE_REMAINING,
          SUM( PaymentsAgg.TOTAL_DOUBTFUL_REMAINING *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_DOUBTFUL_REMAINING,
          SUM( PaymentsAgg.TOTAL_DISCOUNTED *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_DISCOUNTED,
          SUM( PaymentsAgg.TOTAL_APPLIED *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_APPLIED,
          SUM( PaymentsAgg.TOTAL_CREDITED *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_CREDITED,
          SUM( PaymentsAgg.TOTAL_ADJUSTED *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_ADJUSTED,
          SUM( PaymentsAgg.TOTAL_TAX_ORIGINAL *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_TAX_ORIGINAL,
          SUM( PaymentsAgg.TOTAL_TAX_REMAINING *
          IF
            (PaymentsAgg.CURRENCY_CODE = TargetCurrs, 1, CurrRates.CONVERSION_RATE)) AS TOTAL_TAX_REMAINING,
          LOGICAL_OR(PaymentsAgg.CURRENCY_CODE != TargetCurrs
            AND CurrRates.CONVERSION_RATE IS NULL) AS IS_INCOMPLETE_CONVERSION
        FROM (
          SELECT
            TRANSACTION_DATE,
            ANY_VALUE(TRANSACTION_MONTH_NUM) AS TRANSACTION_MONTH_NUM,
            ANY_VALUE(TRANSACTION_QUARTER_NUM) AS TRANSACTION_QUARTER_NUM,
            ANY_VALUE(TRANSACTION_YEAR_NUM) AS TRANSACTION_YEAR_NUM,
            BILL_TO_SITE_USE_ID,
            ANY_VALUE(BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
            ANY_VALUE(BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
            ANY_VALUE(BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
            BUSINESS_UNIT_ID,
            ANY_VALUE(BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
            PAYMENT_CLASS_CODE,
            ANY_VALUE(IS_PAYMENT_TRANSACTION) AS IS_PAYMENT_TRANSACTION,
            EXCHANGE_DATE,
            CURRENCY_CODE,
            COUNT(PAYMENT_SCHEDULE_ID) AS NUM_PAYMENTS,
            COUNTIF(PAYMENT_STATUS_CODE = 'CL') AS NUM_CLOSED_PAYMENTS,
            SUM(DAYS_TO_PAYMENT) AS TOTAL_DAYS_TO_PAYMENT,
            SUM(AMOUNT_DUE_ORIGINAL) AS TOTAL_ORIGINAL,
            SUM(AMOUNT_DUE_REMAINING) AS TOTAL_REMAINING,
            SUM(
            IF
              --(IS_OPEN_AND_OVERDUE, AMOUNT_DUE_REMAINING, 0)) AS TOTAL_OVERDUE_REMAINING,
              (DUE_DATE < DATE(@{sample_target_date_test}) AND AMOUNT_DUE_REMAINING > 0, AMOUNT_DUE_REMAINING, 0)) AS TOTAL_OVERDUE_REMAINING,
            SUM(
            IF
              --(IS_DOUBTFUL, AMOUNT_DUE_REMAINING, 0)) AS TOTAL_DOUBTFUL_REMAINING,
              (DUE_DATE < DATE(@{sample_target_date_test}) AND AMOUNT_DUE_REMAINING > 0 AND DATE_DIFF(DATE(@{sample_target_date_test}), DUE_DATE, DAY) > 90, AMOUNT_DUE_REMAINING, 0)) AS TOTAL_DOUBTFUL_REMAINING,
            SUM(AMOUNT_DISCOUNTED) AS TOTAL_DISCOUNTED,
            SUM(AMOUNT_APPLIED) AS TOTAL_APPLIED,
            SUM(AMOUNT_CREDITED) AS TOTAL_CREDITED,
            SUM(AMOUNT_ADJUSTED) AS TOTAL_ADJUSTED,
            SUM(TAX_ORIGINAL) AS TOTAL_TAX_ORIGINAL,
            SUM(TAX_REMAINING) AS TOTAL_TAX_REMAINING
          FROM
            `@{GCP_PROJECT_ID}.{{t}}.SalesPayments`
          GROUP BY
            TRANSACTION_DATE,
            BILL_TO_SITE_USE_ID,
            BUSINESS_UNIT_ID,
            PAYMENT_CLASS_CODE,
            EXCHANGE_DATE,
            CURRENCY_CODE ) AS PaymentsAgg
        CROSS JOIN

        UNNEST( (
        SELECT
        ARRAY_AGG(STRUCT(TargetCurrs)) AS TargetCurrs
        FROM (
        SELECT
        DISTINCT TO_CURRENCY AS TargetCurrs
        FROM
        `@{GCP_PROJECT_ID}.{{t}}.CurrencyRateMD`) ) )
        LEFT JOIN
        `@{GCP_PROJECT_ID}.{{t}}.CurrencyRateMD` AS CurrRates
        ON
        ( COALESCE(PaymentsAgg.EXCHANGE_DATE, PaymentsAgg.TRANSACTION_DATE) = CurrRates.CONVERSION_DATE )
        AND PaymentsAgg.CURRENCY_CODE = CurrRates.FROM_CURRENCY
        AND TargetCurrs = CurrRates.TO_CURRENCY
        GROUP BY
        TRANSACTION_DATE,
        BILL_TO_SITE_USE_ID,
        BUSINESS_UNIT_ID,
        PAYMENT_CLASS_CODE,
        TARGET_CURRENCY_CODE ) ConvertedAgg
        GROUP BY
        TRANSACTION_DATE,
        BILL_TO_SITE_USE_ID,
        BUSINESS_UNIT_ID,
        PAYMENT_CLASS_CODE

        ;;
    }


 }
