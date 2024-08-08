#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_categories found in sales_orders__lines table.
# Provides item category id and description for an ordered item for a given category_set_id
#
# SOURCES
# Refines View sales_orders__lines__item_categories (defined in /views/base folder)
# Extends Views:
#   otc_common_item_descriptions_ext
#
# REFERENCED BY
# View sales_orders__lines
#
# EXTENDED FIELDS:
#    category_id, category_description, category_name_code
#
# HOW TO USE
# - Single category_id and description for the category_set_name matching
#   value in user attribute cortex_oracle_ebs_default_category_set_name is
#   pulled into sales_orders__lines.
# - Could optionally include this view in Explore Sales Orders.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
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
