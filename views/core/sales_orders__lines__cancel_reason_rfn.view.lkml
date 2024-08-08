#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT cancel_reason found in sales_orders__lines table.
# Provides cancel reason for order line items which have been cancelled
#
# SOURCES
# Refines View sales_orders__lines__cancel_reason (defined in /views/base folder)
#
# REFERENCED BY
# View sales_orders__lines
#
# HOW TO USE
# - Single reason where language matches the language selected
#   for parameter_language is pulled into sales_orders__lines
# - could optionally include in Explore Sales Orders
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
  }
  dimension: language {
    type: string
    label: "Language of Cancel Reason"
    sql: ${TABLE}.LANGUAGE ;;
  }
  dimension: meaning {
    type: string
    label: "Cancel Reason"
    sql: ${TABLE}.MEANING ;;
  }

   }
