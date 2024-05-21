include: "/views/base/item_md.view"

explore: item_md {
  hidden: yes
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
