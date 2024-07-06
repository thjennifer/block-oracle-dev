include: "/views/core/sales_payments_dso_days_agg_pdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: sales_payments_dso_days_agg_pdt {
  label: "Sales Payments DSO Days Agg"

  sql_always_where: ${target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %};;


  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
