include: "/explores/sales_invoices_daily_agg.explore"

include: "/views/test/sales_invoices_daily_agg_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"


explore: +sales_invoices_daily_agg {
  label: "Sales Invoices Daily Agg TEST"
}
