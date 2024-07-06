# used for dashboard filter suggestions

include: "/views/core/dso_days_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: dso_days_sdt {
  hidden: no
  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]
  view_name: dso_days_sdt

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
