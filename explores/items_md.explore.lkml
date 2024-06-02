include: "/views/core/item_md_rfn.view"
include: "/views/core/item_md__item_categories_rfn.view"
include: "/views/core/item_md__item_descriptions_rfn.view"
include: "/views/core/sales_orders_common_parameters_xvw.view"

explore: item_md {
  hidden: yes
  label: "Item MD"

  join: item_md__item_categories {
    view_label: "Item Categories"
    sql: CROSS JOIN UNNEST(${item_md.item_categories}) as item_md__item_categories ;;
    relationship: one_to_many
  }
  join: item_md__item_descriptions {
    view_label: "Item Descriptions"
    sql: CROSS JOIN UNNEST(${item_md.item_descriptions}) as item_md__item_descriptions ;;
    relationship: one_to_many
  }

  join: sales_orders_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}


}