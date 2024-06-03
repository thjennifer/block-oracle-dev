view: sales_invoices__lines__item_descriptions {

  dimension: language {
    type: string
    sql: ${TABLE}.LANGUAGE ;;
  }
  dimension: text {
    type: string
    sql: ${TABLE}.TEXT ;;
  }
}
