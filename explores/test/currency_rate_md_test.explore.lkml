include: "/explores/currency_rate_md.explore"

include: "/views/test/currency_rate_md_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"


explore: +currency_rate_md {
  hidden: yes
  label: "Currency Rate MD TEST"

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  fields: [otc_common_parameters_xvw.parameter_use_demo_or_test_data]
}
}
