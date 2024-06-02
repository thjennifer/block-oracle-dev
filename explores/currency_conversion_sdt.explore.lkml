include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/sales_orders_common_parameters_xvw.view"

explore: currency_conversion_sdt {
  hidden: yes

  join: sales_orders_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
   }
}