include: "/views/core/sales_orders_rfn.view"

explore: sales_orders {
  hidden: no

  join: sales_orders__lines {
    view_label: "Sales Orders: Lines"
    sql: CROSS JOIN UNNEST(${sales_orders.lines}) as sales_orders__lines ;;
    relationship: one_to_many
  }
  join: sales_orders__lines__return_line_ids {
    view_label: "Sales Orders: Lines Return Line Ids"
    sql: CROSs JOIN UNNEST(${sales_orders__lines.return_line_ids}) as sales_orders__lines__return_line_ids ;;
    relationship: one_to_many
  }
  join: sales_orders__lines__item_categories {
    view_label: "Sales Orders: Lines Item Categories"
    sql: CROSS JOIN UNNEST(${sales_orders__lines.item_categories}) as sales_orders__lines__item_categories ;;
    sql_where: ${sales_orders__lines__item_categories.category_set_name} = {% parameter parameter_category_set_name %} ;;
    relationship: one_to_many
  }
  join: sales_orders__lines__item_descriptions {
    view_label: "Sales Orders: Lines Item Descriptions"
    sql: CROSS JOIN UNNEST(${sales_orders__lines.item_descriptions}) as sales_orders__lines__item_descriptions ;;
    sql_where: sales_orders__lines__item_descriptions.language = {% parameter parameter_language %} ;;
    relationship: one_to_many
  }
}
