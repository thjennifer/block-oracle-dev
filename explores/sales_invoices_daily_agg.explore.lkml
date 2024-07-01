include: "/views/core/sales_invoices_daily_agg_rfn.view"
include: "/views/core/sales_invoices_daily_agg__amounts_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"


explore: sales_invoices_daily_agg {
  hidden: no

  sql_always_where: @{get_category_set} ITEM_CATEGORY_SET_NAME in ("Unknown",'{{ category_set }}') ;;

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: sales_invoices_daily_agg__amounts {
    view_label: "Sales Invoices Daily Agg: Amounts"
    sql: LEFT JOIN UNNEST(${sales_invoices_daily_agg.amounts}) as sales_invoices_daily_agg__amounts ;;
    sql_where: ${sales_invoices_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;

    relationship: one_to_many
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
