#########################################################{
# PURPOSE
# Hidden Explore used solely as suggest dimension for paramter_target_currency
#
#########################################################}

include: "/views/core/currency_rate_md_rfn.view"
include: "/views/core/shared_parameters_xvw.view"

explore: currency_rate_md {
  hidden: yes

  label: "Currency Rate MD"

  join: shared_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}

}
