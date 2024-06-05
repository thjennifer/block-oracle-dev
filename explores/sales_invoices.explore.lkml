include: "/views/core/sales_invoices_rfn.view"
include: "/views/core/sales_invoices__lines_rfn.view"
include: "/views/core/sales_invoices__lines__item_categories_rfn.view"
include: "/views/core/sales_invoices__lines__item_descriptions_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"


explore: sales_invoices {
  hidden: yes
  join: sales_invoices__lines {
    view_label: "Sales Invoices: Lines"
    sql: LEFT JOIN UNNEST(${sales_invoices.lines}) as sales_invoices__lines ;;
    relationship: one_to_many
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


}