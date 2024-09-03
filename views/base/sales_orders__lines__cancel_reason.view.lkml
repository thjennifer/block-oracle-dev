view: sales_orders__lines__cancel_reason {

  dimension: code {
    type: string
    description: "Cancel reason code"
    sql: ${TABLE}.CODE ;;
  }
  dimension: language {
    type: string
    description: "Language code of the cancel reason"
    sql: ${TABLE}.LANGUAGE ;;
  }
  dimension: meaning {
    type: string
    description: "Explanation of the cancel reason code"
    sql: ${TABLE}.MEANING ;;
  }
}
