include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: currency_conversion_sdt {
  hidden: yes

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
    fields: [otc_common_parameters_xvw.parameter_use_test_or_demo_data,otc_common_parameters_xvw.parameter_target_currency]
   }
}
