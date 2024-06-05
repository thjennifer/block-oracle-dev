include: "/views/base/item_md.view"
include: "/views/core/otc_unnest_item_descriptions_common_fields_ext.view"

view: +item_md__item_descriptions {

  fields_hidden_by_default: yes
  extends: [otc_unnest_item_descriptions_common_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${item_md.key},${language_code}) ;;
  }

  # dimension: language {
  #   label: "Language Code of Item Description"
  #   full_suggestions: yes
  # }

  # dimension: text {
  #   hidden: yes
  #   label: "Item Description"
  #   full_suggestions: yes
  # }

  # dimension: item_description {
  #   hidden: no
  #   sql: ${text} ;;
  #   full_suggestions: yes
  # }

  measure: distinct_language_count {
    type: count_distinct
    sql: ${language} ;;
  }





   }
