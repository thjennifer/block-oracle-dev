#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT item_descriptions found in sales_invoices__lines table.
# Provides item description for invoiced item.
#
# SOURCES
# Refines View sales_invoices__lines__item_descriptions
# Extends View otc_common_item_descriptions_ext
#
# REFERENCED BY
# not used but could optionally be added to Explore sales_invoices
#
# EXTENDED FIELDS
#    item_description, language_code
#
# NOTES
# - Item descriptions where language_code matches the value of parameter_language
#   are pulled into sales_invoices__lines so this view is not used.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_invoices__lines__item_descriptions.view"
include: "/views/core/otc_common_item_descriptions_ext.view"

view: +sales_invoices__lines__item_descriptions {

  fields_hidden_by_default: yes
  extends: [otc_common_item_descriptions_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: {% if sales_invoices__lines__item_categories._in_query %}
                  CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${language_code},${sales_invoices__lines__item_categories.category_set_id})
          {%else%}CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${language_code})
          {%endif%};;
  }

#--> hidden and used when item description is missing
  dimension: item_part_number {
    hidden: yes
    sql: ${sales_invoices__lines.item_part_number} ;;
  }

}
