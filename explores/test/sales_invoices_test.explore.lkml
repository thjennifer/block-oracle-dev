include: "/explores/sales_invoices.explore"

include: "/views/test/sales_invoices_test.view"
include: "/views/test/sales_invoices__lines_test.view"
include: "/views/test/currency_conversion_sdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"
include: "/views/test/otc_dashboard_navigation_ext_test.view"

include: "/views/core/sales_invoices__lines__item_categories_rfn.view"
include: "/views/core/sales_invoices__lines__item_descriptions_rfn.view"


explore: +sales_invoices {
  label: "Sales Invoices TEST"


  join: sales_invoices__lines__item_categories {
    view_label: "Sales Invoices: Lines Item Categories"
    sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_categories}) as sales_invoices__lines__item_categories ;;
    sql_where: ${sales_invoices__lines__item_categories.category_set_name} in ("Unknown",@{category_set_test}) ;;
    relationship: one_to_many
  }

  join: sales_invoices__lines__item_descriptions {
    view_label: "Sales Invoices: Lines Item Descriptions"
    sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_descriptions}) as sales_invoices__lines__item_descriptions ;;
    sql_where: ${sales_invoices__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
    relationship: one_to_many
  }
}
