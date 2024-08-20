#########################################################{
# PURPOSE
# Hidden Explore used as suggest dimension for
# parameter_target_currency and dashboard filter
#
# SOURCE
#   base view: currency_rate_md
#
# REFERENCED BY
#   View otc_common_parameters_xvw
#   LookML Dashboard otc_template_core
#
#########################################################}

include: "/views/core/currency_rate_md_rfn.view"

explore: currency_rate_md {
  hidden: yes
  label: "Currency Rate MD"
}
