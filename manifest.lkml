constant: CONNECTION_NAME {
  value: "cortex-oracle-dev"
  export: override_required
}

constant: GCP_PROJECT_ID {
  value: "kittycorn-dev"
  export: override_required
}

constant: REPORTING_DATASET {
  value: "CORTEX_ORACLE_REPORTING_VISION"
  export: override_required
}

# constant: CONNECTION_NAME {

#   value: "qa-thjennifer1"
#   export: override_required
# }

# constant: GCP_PROJECT_ID {

#   value: "thjennifer1"
#   export: override_required
# }

# Constant derive_currency_label
# captures and formats selected Target Currency for use in 'labels' property
# example use:
#   measure: sum_ordered_amount {
#     type: sum
#     label: "@{derive_currency_label}Total Sales ({{currency}})"
#     sql: ${ordered_amount_target_currency} ;;
#     }
#
constant: derive_currency_label {
  value: "{% assign currency = currency_conversion_sdt.parameter_target_currency._parameter_value | remove: \"'\" %}"
}
