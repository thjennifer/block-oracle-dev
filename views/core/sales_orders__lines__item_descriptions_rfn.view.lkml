#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_descriptions found in sales_orders__lines table.
# Provides item description for ordered item.
#
# SOURCES
# Refines View sales_orders__lines__item_descriptions (defined in /views/base folder)
# Extends Views:
#   otc_common_item_descriptions_ext
#
# REFERENCED BY
# View sales_orders__lines
#
# EXTENDED FIELDS:
#    item_description, language_code
#
# HOW TO USE
# - Single description where language_code matches the language
#   selected for parameter_language is pulled into sales_orders__lines.
# - Could optionally include in Explore Sales Orders.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
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
