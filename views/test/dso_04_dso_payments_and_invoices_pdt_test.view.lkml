include: "/views/core/dso_04_dso_payments_and_invoices_pdt.view"
include: "/views/test/dso_01_dso_days_sdt_test.view"
include: "/views/test/dso_02_dso_invoices_sdt_test.view"
include: "/views/test/dso_03_dso_payments_sdt_test.view"

view: +dso_payments_and_invoices_pdt {

  label: "DSO Payments and Invoices Summary"

  derived_table: {

    sql:  SELECT
          COALESCE(dso_invoices.DSO_DAYS, dso_payments.DSO_DAYS) AS DSO_DAYS,
          COALESCE(dso_invoices.DSO_START_DATE, dso_payments.DSO_START_DATE) AS DSO_START_DATE,
          COALESCE(dso_invoices.DSO_END_DATE, dso_payments.DSO_END_DATE) AS DSO_END_DATE,
          COALESCE(dso_invoices.BILL_TO_SITE_USE_ID, dso_payments.BILL_TO_SITE_USE_ID) AS BILL_TO_SITE_USE_ID,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_NUMBER, dso_payments.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_NAME, dso_payments.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_COUNTRY, dso_payments.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
          COALESCE(dso_invoices.BUSINESS_UNIT_ID, dso_payments.BUSINESS_UNIT_ID) AS BUSINESS_UNIT_ID,
          COALESCE(dso_invoices.BUSINESS_UNIT_NAME, dso_payments.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
          COALESCE(dso_invoices.TARGET_CURRENCY_CODE, dso_payments.TARGET_CURRENCY_CODE) AS TARGET_CURRENCY_CODE,
          IFNULL(dso_invoices.TOTAL_REVENUE,0) AS TOTAL_REVENUE,
          IFNULL(dso_payments.TOTAL_REMAINING,0) AS TOTAL_REMAINING,
          COALESCE(dso_invoices.IS_INCOMPLETE_CONVERSION, dso_payments.IS_INCOMPLETE_CONVERSION) AS IS_INCOMPLETE_CONVERSION
        FROM
          ${dso_invoices_sdt.SQL_TABLE_NAME} AS dso_invoices
        FULL OUTER JOIN
          ${dso_payments_sdt.SQL_TABLE_NAME} AS dso_payments
        USING
          (DSO_DAYS,
            BILL_TO_SITE_USE_ID,
            BUSINESS_UNIT_ID,
            TARGET_CURRENCY_CODE)
    ;;

  }




}
