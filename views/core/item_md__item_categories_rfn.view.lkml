#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_categories found in item_md view.
# Provides item category id and description for an item for one or
# more category_set_id values
#
# SOURCES
# Refines View item_md__item_categories
# Extends View:
#   otc_common_item_categories_ext
#
# REFERENCED BY
#   Explore item_md
#
# EXTENDED FIELDS
#    category_id, category_description, category_name_code
#
# NOTES
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/item_md__item_categories.view"
include: "/views/core/otc_common_item_categories_ext.view"


view: +item_md__item_categories {
  fields_hidden_by_default: yes

  extends: [otc_common_item_categories_ext]

  dimension: key {
    primary_key: yes
    sql: CONCAT(${item_md.key},${category_set_id},${category_id}) ;;
  }

  dimension: id {
    primary_key: no
  }

  dimension: category_set_id {
    hidden: no
    value_format_name: id
    full_suggestions: yes
  }

  dimension: category_set_name {
    hidden: no
    full_suggestions: yes
  }



  }
