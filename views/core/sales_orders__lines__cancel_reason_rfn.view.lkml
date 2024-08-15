#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT cancel_reason found in sales_orders__lines table.
# Provides cancel reason for order line items which have been cancelled
#
# SOURCES
# Refines View sales_orders__lines__cancel_reason (defined in /views/base folder)
#
# REFERENCED BY
# not used but could optionally be added to Explore sales_orders
#
# NOTES
# - Cancel Reasons where language matches value of parameter_language are pulled into sales_orders__lines
#   so this view is not used.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders__lines__cancel_reason.view"

view: +sales_orders__lines__cancel_reason {

  dimension: key {
    type: string
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${language}) ;;
  }

  dimension: code {
    label: "Cancel Reason Code"
    full_suggestions: yes
  }
  dimension: language {
    type: string
    label: "Language of Cancel Reason"
    sql: ${TABLE}.LANGUAGE ;;
    full_suggestions: yes
  }
  dimension: meaning {
    type: string
    label: "Cancel Reason"
    sql: ${TABLE}.MEANING ;;
    full_suggestions: yes
  }

   }
