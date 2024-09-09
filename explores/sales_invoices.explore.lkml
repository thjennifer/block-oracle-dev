#########################################################{
# PURPOSE
# Retrieve information about sales invoices, including both
# header-level attributes and line-item details.
#
# SOURCES
# base view: sales_invoices
# other views: see "include" statements
#
# REFERENCED BY
#   LookML dashboards:
#     otc_billing_and_invoicing
#     otc_billing_invoice_line_details
#
# CATEGORY SET NAME
#   - This Explore will show only 1 Category Set Name based on the value in the user attribute
#     cortex_oracle_ebs_category_set_name (see constant category_set in Manifest file).
#       * Users can set the value for the user attribute through Account properties. Or an Admin can set the value for a group of users.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_invoices__lines__item_categories
#     2. in the view sales_invoices__lines for the category_description, category_id and category_name_group dimensions
#
# LANGUAGE
#   - This Explore will show only 1 Language for item descriptions based on the value in
#     parameter parameter_language.
#       * Users can change the parameter value in the provided LookML dashboards or Explore.
#       * In the provided LookML dashboards the, the default value for this parameter is based on the value in
#         the user attribute cortex_oracle_ebs_default_language.
#   - This filter condition is defined in two spots:
#    1. the JOIN properties for optional view sales_invoices__lines__item_descriptions
#    2. in the view sales_invoices__lines for the item_description and language_code dimensions
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the value of the parameter on provided LookML dashboards or Explore.
#       * In the provided LookML dashboards, the default value for this parameter is the value in
#         the user attribute cortex_oracle_ebs_default_currency.
#   - This filter condition is applied in the view currency_conversion_sdt.
#
# OTHER NOTES
#   - The view definitions for sales_invoices and sales_invoices__lines include a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Item descriptions and categories are defined in sales_invoices__lines so the unnested
#     views do not need to be included in the Explore. However, you can optionally include by
#     uncommenting the join statements below.
#
#########################################################}

include: "/views/core/sales_invoices_rfn.view"
include: "/views/core/sales_invoices__lines_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"
#--> optional
#--> joins to these views are defined below for reference but not
#--> included in the Explore as key fields from these are defined
#--> in sales_invoices__lines_rfn.view
include: "/views/core/sales_invoices__lines__item_categories_rfn.view"
include: "/views/core/sales_invoices__lines__item_descriptions_rfn.view"

explore: sales_invoices {
  hidden: no
  description: "Retrieve information about invoices, including both header-level attributes and line-item details"

  join: sales_invoices__lines {
    view_label: "Sales Invoices: Lines"
    sql: LEFT JOIN UNNEST(${sales_invoices.lines}) as sales_invoices__lines ;;
    relationship: one_to_many
  }

  join: currency_conversion_sdt {
    type: left_outer
    sql_on:  ${sales_invoices.exchange_raw} = ${currency_conversion_sdt.conversion_date} AND
             ${sales_invoices.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_invoices
    fields: []
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_invoices__lines__item_categories {
  #   view_label: "Sales Invoices: Lines Item Categories"
  #   sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_categories}) as sales_invoices__lines__item_categories ;;
  #   sql_where: ${sales_invoices__lines__item_categories.category_set_name} in ("Unknown",@{category_set}) ;;
  #   relationship: one_to_many
  # }

  # join: sales_invoices__lines__item_descriptions {
  #   view_label: "Sales Invoices: Lines Item Descriptions"
  #   sql: LEFT JOIN UNNEST(${sales_invoices__lines.item_descriptions}) as sales_invoices__lines__item_descriptions ;;
  #   sql_where: ${sales_invoices__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
  #   relationship: one_to_many
  # }


}
