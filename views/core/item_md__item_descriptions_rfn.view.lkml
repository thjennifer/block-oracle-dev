#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_descriptions found in item_md view.
# Provides item descriptions in different languages
#
# SOURCES
# Refines View item_md__item_descriptions
# Extends View:
#   otc_common_item_descriptions_ext
#
# REFERENCED BY
#   Explore item_md
#
# EXTENDED FIELDS
#    item_description, language_code
#
# NOTES
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

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

#--> hidden and used in coalesce if missing item description
  dimension: item_part_number {
    hidden: yes
    sql: ${item_md.item_part_number} ;;
  }

  measure: distinct_language_count {
    hidden: no
    type: count_distinct
    sql: ${language} ;;
  }

}
