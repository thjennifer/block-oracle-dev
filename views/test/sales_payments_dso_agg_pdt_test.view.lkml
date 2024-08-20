include: "/views/core/sales_payments_dso_days_agg_pdt.view"

view: +sales_payments_dso_days_agg_pdt {
   derived_table: {
      # datagroup_trigger: once_a_day_at_5

      sql:
        {% assign p = "demo" %}
        {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
        {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}
        SELECT
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
          `@{GCP_PROJECT_ID}.{{t}}.SalesPaymentsDailyAgg` hdr
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
    }
