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
