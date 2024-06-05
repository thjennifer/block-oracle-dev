include: "/views/core/item_md_rfn.view"
include: "/views/core/item_md__item_categories_rfn.view"
include: "/views/core/item_md__item_descriptions_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"

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

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
    fields: [otc_common_parameters_xvw.parameter_use_test_or_demo_data]
}


}
