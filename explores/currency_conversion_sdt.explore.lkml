include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/shared_parameters_xvw.view"

explore: currency_conversion_sdt {
  hidden: yes

  join: shared_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
   }
}
