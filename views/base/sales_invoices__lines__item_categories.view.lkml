# modified to comment out auto-generated drill_fields
view: sales_invoices__lines__item_categories {
  # drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    description: "Foreign key identifying item categories"
    sql: ${TABLE}.ID ;;
  }
  dimension: category_name {
    type: string
    description: "Item category name"
    sql: ${TABLE}.CATEGORY_NAME ;;
  }
  dimension: category_set_id {
    type: number
    description: "Foreign key identifying item category sets"
    sql: ${TABLE}.CATEGORY_SET_ID ;;
  }
  dimension: category_set_name {
    type: string
    description: "Item category set name"
    sql: ${TABLE}.CATEGORY_SET_NAME ;;
  }
  dimension: description {
    type: string
    description: "Item category description"
    sql: ${TABLE}.DESCRIPTION ;;
  }
}
