view: sales_orders__lines__cancel_reason {

  dimension: code {
    type: string
    sql: ${TABLE}.CODE ;;
  }
  dimension: language {
    type: string
    sql: ${TABLE}.LANGUAGE ;;
  }
  dimension: meaning {
    type: string
    sql: ${TABLE}.MEANING ;;
  }
}
