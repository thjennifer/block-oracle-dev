include: "/views/core/language_codes_sdt.view"
# field-only views
include: "/views/core/otc_common_parameters_xvw.view"

explore: language_codes_sdt {
  hidden: yes

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
    fields: [otc_common_parameters_xvw.parameter_use_test_or_demo_data]
}
}
