view: item_md__item_categories {
  # drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ID ;;
  }
  dimension: category_name {
    type: string
    sql: CATEGORY_NAME ;;
  }
  dimension: category_set_id {
    type: number
    sql: CATEGORY_SET_ID ;;
  }
  dimension: category_set_name {
    type: string
    sql: CATEGORY_SET_NAME ;;
  }
  dimension: description {
    type: string
    sql: DESCRIPTION ;;
  }
  dimension: item_md__item_categories {
    type: string
    hidden: yes
    sql: item_md__item_categories ;;
  }
}
