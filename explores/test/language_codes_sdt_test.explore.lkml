include: "/explores/language_codes_sdt.explore"

include: "/views/test/language_codes_sdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

explore: +language_codes_sdt {

  label: "Language Codes TEST"

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  fields: [otc_common_parameters_xvw.parameter_use_demo_or_test_data]
}
}
