include: "/explores/item_md.explore"

include: "/views/test/item_md_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

include: "/views/core/item_md__item_categories_rfn.view"
include: "/views/core/item_md__item_descriptions_rfn.view"


explore: +item_md {
  hidden: yes
  label: "Item MD TEST"

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  fields: [otc_common_parameters_xvw.parameter_use_demo_or_test_data]
}


}
