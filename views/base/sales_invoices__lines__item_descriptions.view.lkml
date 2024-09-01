view: sales_invoices__lines__item_descriptions {

  dimension: language {
    type: string
    description: "Language code of the item description"
    sql: ${TABLE}.LANGUAGE ;;
  }
  dimension: text {
    type: string
    description: "Item description text"
    sql: ${TABLE}.TEXT ;;
  }
}
