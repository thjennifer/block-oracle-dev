#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_descriptions found in sales_orders__lines table.
# Provides item description for ordered item.
#
# SOURCES
# Refines View sales_orders__lines__item_descriptions (defined in /views/base folder)
# Extends View:
#   otc_common_item_descriptions_ext
#
# REFERENCED BY
# not used but could optionally be added to Explore sales_orders
#
# EXTENDED FIELDS
#    item_description, language_code
#
# NOTES
# - Item descriptions where language_code matches the value
#   of parameter_language are pulled into sales_orders__lines
#   so this view is not used.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders__lines__item_descriptions.view"
include: "/views/core/otc_common_item_descriptions_ext.view"

view: +sales_orders__lines__item_descriptions {
  fields_hidden_by_default: yes
  extends: [otc_common_item_descriptions_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${language_code}) ;;
  }

#--> hidden and referenced in item_description defintion to COALESCE Item Part if description missing
  dimension: item_part_number {
    hidden: yes
    sql: ${sales_orders__lines.item_part_number} ;;
  }

}
