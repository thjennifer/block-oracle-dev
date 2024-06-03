view: sales_invoices__lines__item_categories {
  # drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }
  dimension: category_name {
    type: string
    sql: ${TABLE}.CATEGORY_NAME ;;
  }
  dimension: category_set_id {
    type: number
    sql: ${TABLE}.CATEGORY_SET_ID ;;
  }
  dimension: category_set_name {
    type: string
    sql: ${TABLE}.CATEGORY_SET_NAME ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }
}
