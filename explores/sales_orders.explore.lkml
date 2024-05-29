include: "/views/core/sales_orders_rfn.view"
include: "/views/core/sales_orders__lines_rfn.view"
include: "/views/core/sales_orders__lines__return_line_ids_rfn.view"

include: "/views/core/currency_conversion_sdt.view"
# include: "/views/core/currency_rate_md_rfn.view"

# field-only views
include: "/views/core/apply_currency_conversion_to_sales_xvw.view"
include: "/views/core/shared_parameters_xvw.view"

explore: sales_orders {
  hidden: no

  join: sales_orders__lines {
    view_label: "Sales Orders: Lines"
    sql: CROSS JOIN UNNEST(${sales_orders.lines}) as sales_orders__lines ;;
    relationship: one_to_many
  }

  join: currency_conversion_sdt {
    type: left_outer
    sql_on:  ${sales_orders.ordered_raw} = ${currency_conversion_sdt.conversion_date} AND
              ${sales_orders.currency_code} = ${currency_conversion_sdt.from_currency}
              ;;
    relationship: many_to_one
  }

  # join: currency_rate_md {
  #   type: left_outer
  #   relationship: many_to_one
  #   sql_on:  ${sales_orders.ordered_raw} = ${currency_rate_md.conversion_raw} AND
  #             ${sales_orders.currency_code} = ${currency_rate_md.from_currency} AND
  #             ${currency_rate_md.to_currency} = {% parameter parameter_target_currency %} ;;
  # }


  join: sales_orders__lines__return_line_ids {
    view_label: "Sales Orders: Lines Return Line Ids"
    sql: CROSs JOIN UNNEST(${sales_orders__lines.return_line_ids}) as sales_orders__lines__return_line_ids ;;
    relationship: one_to_many
  }

  join: apply_currency_conversion_to_sales_xvw {
    view_label: "Sales Orders: Lines"
    relationship: one_to_one
    sql:  ;;
  }

  join: shared_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_orders__lines__item_categories {
  #   view_label: "Sales Orders: Lines Item Categories"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_categories}) as sales_orders__lines__item_categories ;;
  #   sql_where: ${sales_orders__lines__item_categories.category_set_name} in ("Unknown",{% parameter sales_orders__lines.parameter_category_set_name %}) ;;
  #   relationship: one_to_many
  # }
  # join: sales_orders__lines__item_descriptions {
  #   view_label: "Sales Orders: Lines Item Descriptions"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_descriptions}) as sales_orders__lines__item_descriptions ;;
  #   sql_where: ${sales_orders__lines__item_descriptions.language} in ("Unknown", {% parameter sales_orders__lines.parameter_language %}) ;;
  #   relationship: one_to_many
  # }
}
