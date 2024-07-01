include: "/views/base/sales_applied_receivables_daily_agg.view"
include: "/views/base/sales_applied_receivables_daily_agg__amounts.view"

explore: sales_applied_receivables_daily_agg {
  hidden: no
    join: sales_applied_receivables_daily_agg__amounts {
      view_label: "Sales Applied Receivables Daily Agg: Amounts"
      sql: LEFT JOIN UNNEST(${sales_applied_receivables_daily_agg.amounts}) as sales_applied_receivables_daily_agg__amounts ;;
      relationship: one_to_many
    }
}
