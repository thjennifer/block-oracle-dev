view: item_md__item_descriptions {

  dimension: item_md__item_descriptions {
    type: string
    description: "Nested repeated field containing item descriptions in all enabled language translations"
    hidden: yes
    sql: item_md__item_descriptions ;;
  }
  dimension: language {
    type: string
    description: "Language code of the item description"
    sql: LANGUAGE ;;
  }
  dimension: text {
    type: string
    description: "Item description text"
    sql: TEXT ;;
  }
}
