#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_categories found in sales_orders__lines table.
# Provides item category id and description for an ordered item for a given category_set_id
#
# SOURCES
# Refines View sales_orders__lines__item_categories (defined in /views/base folder)
# Extends View:
#   otc_common_item_categories_ext
#
# REFERENCED BY
# not used but could optionally be added to Explore sales_orders
#
# EXTENDED FIELDS
#    category_id, category_description, category_name_code
#
# NOTES
# - Catgory IDs and descriptions for the category_set_name matching the
#   value of user attribute cortex_oracle_ebs_default_category_set_name are
#   pulled into sales_orders__lines so this view is not used.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders__lines__item_categories.view"
include: "/views/core/otc_common_item_categories_ext.view"

view: +sales_orders__lines__item_categories {

  fields_hidden_by_default: yes
  extends: [otc_common_item_categories_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${category_set_id}) ;;
  }

  dimension: id {
    primary_key: no
  }

  dimension: category_set_id {
    sql: COALESCE(${TABLE}.CATEGORY_SET_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: category_set_name {
    sql: COALESCE(${TABLE}.CATEGORY_SET_NAME,"Unknown") ;;
    full_suggestions: yes
  }



   }
