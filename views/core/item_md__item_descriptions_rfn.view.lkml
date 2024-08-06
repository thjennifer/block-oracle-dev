# language_code and item_description from otc_common_item_descriptions

include: "/views/base/item_md__item_descriptions.view"
include: "/views/core/otc_common_item_descriptions_ext.view"

view: +item_md__item_descriptions {

  fields_hidden_by_default: yes
  extends: [otc_common_item_descriptions_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${item_md.key},${language_code}) ;;
  }

  dimension: item_part_number {
    hidden: yes
    sql: ${item_md.item_part_number} ;;
  }

  measure: distinct_language_count {
    type: count_distinct
    sql: ${language} ;;
  }

}
