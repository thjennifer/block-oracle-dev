include: "/views/test/dso_01_dso_days_sdt_test.view"
include: "/views/core/dso_02_dso_invoices_sdt.view"

view: +dso_invoices_sdt {

  derived_table: {
    sql:
    {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
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
      SUM(TOTAL_REVENUE) AS TOTAL_REVENUE,
      MAX(IS_INCOMPLETE_CONVERSION) AS IS_INCOMPLETE_CONVERSION
    FROM ${dso_01_dso_days_sdt.SQL_TABLE_NAME} dso
     JOIN
      `@{GCP_PROJECT_ID}.{{t}}.SalesInvoicesDailyAgg` hdr
       ON
      hdr.INVOICE_DATE BETWEEN dso.DSO_START_DATE
      AND dso.DSO_END_DATE
    LEFT JOIN
      UNNEST(AMOUNTS) AS amt
    GROUP BY
      DSO_DAYS,
      BILL_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID,
      TARGET_CURRENCY_CODE ;;
  }

}
