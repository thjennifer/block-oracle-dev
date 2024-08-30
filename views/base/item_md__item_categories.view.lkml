# modified to comment out auto-generated drill_fields

view: item_md__item_categories {
  # drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    description: "Foreign key identifying item categories"
    sql: ID ;;
  }
  dimension: category_name {
    type: string
    description: "Item category name"
    sql: CATEGORY_NAME ;;
  }
  dimension: category_set_id {
    type: number
    description: "Foreign key identifying item category sets"
    sql: CATEGORY_SET_ID ;;
  }
  dimension: category_set_name {
    type: string
    description: "Item category set name"
    sql: CATEGORY_SET_NAME ;;
  }
  dimension: description {
    type: string
    description: "Item category description"
    sql: DESCRIPTION ;;
  }
  dimension: item_md__item_categories {
    type: string
    description: "Nested repeated field containing item categories in all enabled category sets"
    hidden: yes
    sql: item_md__item_categories ;;
  }
}
