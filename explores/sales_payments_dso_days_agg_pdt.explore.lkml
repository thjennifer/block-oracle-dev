include: "/views/core/sales_payments_dso_days_agg_pdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: sales_payments_dso_days_agg_pdt {
  label: "Sales Payments DSO Days Agg"

 always_filter: {
  filters: [target_currency_code: "{{ _user_attributes['cortex_oracle_ebs_default_currency'] }}"]
}


}
