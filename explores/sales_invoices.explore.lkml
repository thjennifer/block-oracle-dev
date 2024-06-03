include: "/views/core/sales_invoices_rfn.view"
include: "/views/base/sales_invoices__lines.view"
include: "/views/base/sales_invoices__lines__item_categories.view"
include: "/views/base/sales_invoices__lines__item_descriptions.view"
include: "/views/core/sales_orders_common_parameters_xvw.view"


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
    relationship: one_to_many
  }
  join: sales_invoices__lines__item_descriptions {
    view_label: "Sales Invoices: Lines Item Descriptions"
    sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_descriptions}) as sales_invoices__lines__item_descriptions ;;
    relationship: one_to_many
  }

  join: sales_orders_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }


}
