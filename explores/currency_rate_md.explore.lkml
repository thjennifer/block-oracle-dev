#########################################################{
# PURPOSE
# Hidden Explore used solely as suggest dimension for paramter_target_currency
#
#########################################################}

include: "/views/core/currency_rate_md_rfn.view"

explore: currency_rate_md {
  hidden: yes
  label: "Currency Rate MD"
}
