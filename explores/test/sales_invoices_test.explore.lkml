include: "/explores/sales_invoices.explore"

include: "/views/test/sales_invoices_test.view"
include: "/views/test/sales_invoices__lines_test.view"
include: "/views/test/currency_conversion_sdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

include: "/views/core/sales_invoices__lines__item_categories_rfn.view"
include: "/views/core/sales_invoices__lines__item_descriptions_rfn.view"


explore: +sales_invoices {
  label: "Sales Invoices TEST"
}
