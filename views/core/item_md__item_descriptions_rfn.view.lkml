include: "/views/base/item_md.view"

view: +item_md__item_descriptions {


  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${item_md.key},${language}) ;;
  }

  dimension: language {
    label: "Language Code of Item Description"
    full_suggestions: yes
  }

  dimension: text {
    hidden: yes
    label: "Item Description"
    full_suggestions: yes
  }

  dimension: item_description {
    hidden: no
    sql: ${text} ;;
    full_suggestions: yes
  }

  measure: distinct_language_count {
    type: count_distinct
    sql: ${language} ;;
  }





   }
