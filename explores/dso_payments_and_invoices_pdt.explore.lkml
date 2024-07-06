include: "/views/core/dso_04_dso_payments_and_invoices_pdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: dso_payments_and_invoices_pdt {
  label: "DSO Payments and Invoices Summary"

  sql_always_where: ${target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %};;


  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }
}
