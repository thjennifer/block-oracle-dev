include: "/explores/sales_payments_daily_agg.explore"
include: "/views/test/sales_payments_daily_agg_test.view"
include: "/views/test/sales_payments_daily_agg_test_data_pdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"
include: "/views/test/otc_dashboard_navigation_ext_test.view"

include: "/views/test/sales_invoices_test.view"

explore: +sales_payments_daily_agg {
  label: "Sales Payments Daily Agg TEST"
}