#########################################################{
# PURPOSE
# Hidden Explore used solely as suggest dimension for paramter_target_currency
#
#########################################################}

include: "/views/core/currency_rate_md_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: currency_rate_md {
  hidden: yes
  label: "Currency Rate MD"

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
    fields: [otc_common_parameters_xvw.parameter_use_test_or_demo_data]
}

}
