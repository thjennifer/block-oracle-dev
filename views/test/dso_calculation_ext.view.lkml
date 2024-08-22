# view: dso_calculation_ext {
#   extension: required

#   measure: dso_period_receivables {
#     hidden: yes
#     type: sum
#     label: "DSO Period Total Receivables (Target Currency)"
#     sql: ${amount_due_remaining_target_currency};;
#     filters: [dso_dynamic_days_sdt.dso_days: ">0",payment_class_code: "-PMT"]
#   }

#   measure: dso_period_amount_original {
#     hidden: yes
#     type: sum
#     label: "DSO Period Total Amount Original (Target Currency)"
#     sql: ${amount_due_original_target_currency};;
#     filters: [dso_dynamic_days_sdt.dso_days: ">0",payment_class_code: "-PMT"]
#   }

#   measure: days_sales_outstanding {
#     hidden: no
#     type: number

#     sql: SAFE_DIVIDE(${dso_period_receivables},${dso_period_amount_original}) * ANY_VALUE(${dso_dynamic_days_sdt.dso_days}) ;;
#     value_format_name: decimal_1
#     drill_fields: [dso_details*]
#   }

#   set: dso_details {
#     fields: [bill_to_customer_name,bill_to_customer_country,days_sales_outstanding]
#   }

# }
