include: "/views/core/sales_invoices_rfn.view"
include: "/views/core/sales_invoices__lines_rfn.view"
include: "/views/core/sales_invoices__lines__item_categories_rfn.view"
include: "/views/core/sales_invoices__lines__item_descriptions_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_billing_dashboard_navigation_ext.view"


explore: sales_invoices {
  hidden: no
  join: sales_invoices__lines {
    view_label: "Sales Invoices: Lines"
    sql: LEFT JOIN UNNEST(${sales_invoices.lines}) as sales_invoices__lines ;;
    relationship: one_to_many
  }

  join: currency_conversion_sdt {
    view_label: "Sales Invoices: Lines Currency Conversion"
    type: left_outer
    sql_on:  COALESCE(${sales_invoices.exchange_raw},${sales_invoices.invoice_raw}) = ${currency_conversion_sdt.conversion_date} AND
            ${sales_invoices.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_invoices__lines
    fields: []
  }

  join: sales_invoices__lines__item_categories {
    view_label: "Sales Invoices: Lines Item Categories"
    sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_categories}) as sales_invoices__lines__item_categories ;;
    sql_where: ${sales_invoices__lines__item_categories.category_set_name} in ("Unknown",'{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}') ;;
    relationship: one_to_many
  }

  join: sales_invoices__lines__item_descriptions {
    view_label: "Sales Invoices: Lines Item Descriptions"
    sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_descriptions}) as sales_invoices__lines__item_descriptions ;;
    sql_where: ${sales_invoices__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
    relationship: one_to_many
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_billing_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
}


}
