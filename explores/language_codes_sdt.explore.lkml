include: "/views/core/language_codes_sdt.view"
# field-only views
include: "/views/core/sales_orders_common_parameters_xvw.view"

explore: language_codes_sdt {
  hidden: yes

  join: sales_orders_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
