#########################################################{
# PURPOSE
# All items and attributes
#
# SOURCE
#   base view: item_md
#     item_md__item_categories
#     item_md__item_descriptions
#
# REFERENCED BY
#   LookML Dashboards as suggestion for dashboard filter
#     otc_sales_performance
#     otc_order_fulfillment
#     otc_order_line_item_details
#     otc_billing_invoice_line_details
#
#########################################################}

include: "/views/core/item_md_rfn.view"
include: "/views/core/item_md__item_categories_rfn.view"
include: "/views/core/item_md__item_descriptions_rfn.view"

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

}
