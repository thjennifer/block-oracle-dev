constant: CONNECTION_NAME {
  value: "cortex-oracle-dev"
  export: override_required
}

constant: GCP_PROJECT_ID {
  value: "kittycorn-dev-incorta"
  export: override_required
}

constant: REPORTING_DATASET {
  value: "CORTEX_ORACLE_EBS_REPORTING"
  export: override_required
}


#########################################################
# CATEGORY SET and DEFAULT TARGET DATE
#{
# Define values for category set and default target date based on user attribute values.
constant: category_set {
  value: "{% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}'{{category_set}}'"
}

# If using test data, set target date to 3/28/2024 to match dates in that dataset otherwise use current date.
constant: default_target_date {
  value:  "{%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}
  {%- if test_data == 'YES' -%}
  {%- assign td = '2024-03-31' -%} {%- else -%}
  {%- assign td = 'now' | date: '%Y-%m-%d' -%}{%- endif -%}'{{td}}'"
}

#} end constants for category set and target date

#########################################################
# HTML FORMATS
#{
# Format values using a field's html property.

#--> html_format_big_numbers
#{
# Formats positive and negative numbers by appending B, M, K, or no suffix based on magnitude.
# Example use:
#   measure: sum_ordered_amount {
#     type: sum
#     sql: ${ordered_amount_target_currency} ;;
#     html: @{html_format_big_numbers} ;;
#   }
#}
constant: html_format_big_numbers {
  value: "
  {%- if value < 0 -%}
    {%- assign abs_value = value | times: -1.0 -%}
    {%- assign pos_neg = '-' -%}
  {%- else -%}
    {%- assign abs_value = value | times: 1.0 -%}
    {%- assign pos_neg = '' -%}
  {%- endif -%}
  {%- if abs_value >=1000000000 -%}
    {{pos_neg}}{{ abs_value | divided_by: 1000000000.0 | round: 1 }}B
  {%- elsif abs_value >=1000000 -%}
    {{pos_neg}}{{ abs_value | divided_by: 1000000.0 | round: 1 }}M
  {%- elsif abs_value >=1000 -%}
    {{pos_neg}}{{ abs_value | divided_by: 1000.0 | round: 1 }}K
  {%- else -%}
    {{pos_neg}}{{ abs_value }}
  {%- endif -%}

  "
}

#--> symbols for yesno type fields
#{
# For yes/no type fields, displays a symbol for Yes values only, No values only or both Yes/No values.
# Example use:
#   dimension: is_fulfilled {
#     type: yesno
#     html: @{html_symbols_for_yes_no} ;;
#   }
#}
constant: html_symbols_for_yes_no {
  value: "{% if value == true %}✅ {% else %}❌{% endif %}"
}

constant: html_symbols_for_yes {
  value: "{% if value == true %}✅
  {% else %}  {% endif %}"
}

constant: html_symbols_for_no {
  value: "{% if value == false %}❌{% else %}  {% endif %}"
}

#--> warning messages
#{
# For measures reported in source currency, returns a warning message if currency_code field is missing from the query.
# Example use:
#   measure: total_amount_adjusted_in_source_currency {
#     type: sum
#     sql: {%- if currency_code._is_selected -%}${amount_adjusted}{%- else -%}NULL{%- endif -%} ;;
#     html: @{html_message_source_currency} ;;
#   }
#}
constant: html_message_source_currency {
  value: "{%- if currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%}"
}

#} end constants for html formats

#########################################################
# IS_SELECTED or IN_QUERY
#{
# These constants check if fields are selected or queried. Actions can be taken based on true or false.
# For example, in sales_orders_daily_agg, order counts can't be summed across filtered categories.
# If categories are queried, return a warning or null for Order Count measures.
#
# The liquid parameter _is_selected returns true if the field you ask for:
#     - is included in the query as a selected field
#     - is included in the query using the required_fields parameter
#
# The liquid parameter _in_query returns true if the field you ask for:
#     - is included in the query as a selected field
#     - is included in the query as a filter
#     - is included in the query using the required_fields parameter
#

#--> is_agg_category_in_query
#{
# Returns true if any of these category fields from
# sales_orders_daily_agg__lines are in the query:
#     category_id, category_description, category_name_code,
#     item_organization_id, item_orgranization_name
# To use this constant, complete the rest of the statement (what to do when true and false).
# For example:
#     measure: order_count {
#       type: sum
#       sql: @{is_agg_category_in_query}NULL {% else %} ${num_orders} {% endif %} ;;
#     }
#}
constant: is_agg_category_in_query {
  value: "{% if sales_orders_daily_agg__lines.category_id._in_query or
  sales_orders_daily_agg__lines.category_description._in_query or
  sales_orders_daily_agg__lines.category_name_code._in_query or
  sales_orders_daily_agg__lines.item_organization_id._in_query or
  sales_orders_daily_agg__lines.item_organization_name._in_query
  %}"
}

#--> is_item_or_category_selected
#{
# Returns true if any of these item or category fields is selected:
#     category_id, category_description, category_name_code,
#     inventory_item_id, item_part_number, item_description,
#     selected_product_dimension_id, selected_product_dimension_description
# To use this constant, complete the rest of the statement (what to return when true and false).
# For example:
#     measure: average_cycle_time_days {
#       type: average
#       sql: @{is_item_or_category_selected}${cycle_time_days}{%- else -%}NULL{%- endif -%};;
#     }
#}
constant: is_item_or_category_selected {
  value: "{%- if inventory_item_id._is_selected or
  item_part_number._is_selected or
  item_description._is_selected or
  category_id._is_selected or
  category_description._is_selected or
  category_name_code._is_selected or
  selected_product_dimension_description._is_selected or
  selected_product_dimension_id._is_selected
  -%}"
}

#--> is_item_selected
#{
# - Returns true if any of these item or category fields is selected:
#     inventory_item_id, item_part_number, item_description
# - Returns true if Item is displayed using parameter_display_product_level and
#   either selected_product_dimension_id or selected_product_dimension_description is selected.
# - To use this constant, complete the rest of the statement (what to return when true and false).
# - For example:
#     measure: total_ordered_quantity_by_item {
#       sql: @{is_item_selected}${ordered_quantity}{%- else -%}NULL {%- endif -%} ;;
#       html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
#     }
#}
constant: is_item_selected {
  value: "{%- if inventory_item_id._is_selected or
  item_part_number._is_selected or
  item_description._is_selected or
  (
  parameter_display_product_level._parameter_value == 'Item' and
  (selected_product_dimension_description._is_selected or selected_product_dimension_id._is_selected)
  )
  -%}"
}

#} end constants for is_selected or in_query

#########################################################
# LABEL: View
#{
# Defines view labels which impact Explore readability.

constant: label_view_for_filters {
  value: "🔍 Filters"
}

constant: label_view_for_dashboard_navigation {
  value: "🛠 Dashboard Navigation"
}

#} end constants for view labels

#########################################################
# LABEL: Currency
#{
# For fields using target currency, derive the label to use
# when the field is selected in a chart and when the field is shown
# in the Explore.
#
# For example, for a dimension named total_ordered_amount_target_currency
# and selected currency of USD, you will see:
#     Total Ordered Amount (USD) in a table/chart
#     Total Ordered Amount (Target Currency) when listed in the Explore
#
# Assumes the target_currency fields follow a specific naming convention.
#
# Example Use Cases:
#{
# Example use case: defaults
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}
#   }
#     Total Amount Adjusted (USD)
#     Total Amount Adjusted (Target Currency)
#
# Example use case: remove 'total_' prefix:
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}
#   }
#     Amount Adjusted (USD)
#     Amount Adjusted (Target Currency)
#
# Example use case: keep 'Formatted' in Explore label:
#   measure: total_amount_adjusted_target_currency_formatted {
#     label: @{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}
#   }
#     Total Amount Adjusted (USD)
#     Total Amount Adjusted (Target Currency) Formatted
#
# Example use case: provide custom value for field_name:
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_currency_defaults}{%- assign field_name = 'Adjusted Amount' -%}@{label_currency_if_selected}
#   }
#     Adjusted Amount (USD)
#     Adjusted Amount (Target Currency)
#}

#--> label_currency_defaults
#   - Used to set initial values for liquid variables that will be used to create the dynamic label measures based on target currency.
#       currency = value in parameter_target_currency that will be appended to the label when the field is selected.
#       field_name = blank
#       remove_words = '_target_currency, _formatted' meaning these words will not be in the label.
#       remove_total_prefix = false. When true 'total_' will also be removed from the label.
#       add_words = ' (Target Currency)' will be appended to field_name and displayed in the Explore
#       add_formatted = false. When true, ' Formatted' will be added to label displayed in the Explore
#   - These defaults can be overridden when defining the label property.
constant: label_currency_defaults {
  value: "{%- assign currency = otc_common_parameters_xvw.parameter_target_currency._parameter_value | remove: \"'\" -%}
  {%- assign field_name = '' -%}
  {%- assign remove_words = '_target_currency,_formatted' -%}
  {%- assign remove_total_prefix = false -%}
  {%- assign add_words = ' (Target Currency)' -%}
  {%- assign add_formatted = false -%}
  "
}

#--> label_currency_field_name
#{
# Creates a liquid variable called field_name for use in 'label' property.
# Derived by:
#   - Capturing name of field with liquid parameter _field._name and removing any words defined in liquid variable remove_words.
#   - Removing the word "total_", if remove_total_prefix == true.
#   - Replacing '_' with spaces and capitalizing remaining words.
#   - For example, a dimension named total_ordered_amount_target_currency will return
#     Total Ordered Amount for field_name
#}
constant: label_currency_field_name {
  value: "{%- assign fname = _field._name | split: '.' | last -%}
  {%- if remove_total_prefix == true -%}{% assign remove_words = remove_words | append: ',total_'-%}{%- endif -%}
  {%- assign remove_words = remove_words | split: ','%}
  {%- for remove_word in remove_words -%}
    {%- assign fname = fname | remove: remove_word -%}
  {%- endfor -%}
  {%- assign fname_array = fname | split: '_' -%}
  {%- for word in fname_array -%}
    {%- assign cap = word | capitalize -%}
    {%- assign field_name = field_name | append: cap -%}
    {%- unless forloop.last -%}{%- assign field_name = field_name | append: ' ' -%}{%- endunless -%}
  {%- endfor -%}
  "
}

#--> label_currency_if_selected
#{
# Appends one of the following to field_name to complete the label:
#   - Phrase  '  (Target Currency)' or the phrase in the liquid variable add_words if _field._is_selected is false
#   - Target currency value in parentheses if _field._is_selected is true.
#}
constant: label_currency_if_selected {
  value: "
  {%- if add_formatted == true -%}{%- assign add_words = add_words | append: ' Formatted' -%}{%- endif -%}
  {%- if _field._is_selected -%}
  {{field_name}} ({{currency}})
  {%- else -%}{{field_name | append: add_words}}
  {%- endif -%}"
}

#} end constants for target currency labels

#########################################################
# LINK
#{
# The next set of constants with the link_ prefix support the building of url links whether tied to a
# field's link property or designed to display in a single value visualization.
#
# There are constants defined to support defining styles, mapping Explore fields to dashboard filters,
# capturing and parsing urls plus generating filter strings and a new url path.
#
# Liquid has a parameter called {{link}}. This parameter is most useful
# on measures because it actually contains the full URL (including pivots) of
# where the user clicked in the data/visualization pane.
#
# Using a dummy measure called link_generator, these constants will capture the full url
# when a user clicks on a measure in an Explore or Dashboard. They will parse full url
# to get the applied filters and then build a new url link to desired target:
#   - a drill modal with table or visualization
#   - an Explore page with a new visualization
#   - another Dashboard


#########################################################
# LINK_STYLE
#{
# Defines different display styles for a url link.

#--> link_style_dashboard_navigation
#{
# Defines the multiple styles available for dashboard links:
#     buttons, tabs or plain
# These options should match the allowed values in parameter_navigation_style
# found in template_dashboard_navigation_ext and any extension of this template.
#
# Generates liquid variables for click_style and non_click_style.
# These styles will be applied when displaying the dashboard urls in a single value visualization.
# See the html property of the dimension template_dashboard_navigation_ext.navigation_links.
#}
constant: link_style_dashboard_navigation {
  value: "{% assign nav_style = parameter_navigation_style._parameter_value %}
  {% case nav_style %}
    {% when 'buttons' %}
        {% assign core_style = 'border-collapse: separate; border-radius: 6px; border: 2px solid #dcdcdc; margin-left: 5px; margin-bottom: 5px; padding: 6px 10px; line-height: 1.5; user-select: none; font-size: 12px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 0px; white-space: normal; float: left;' %}
        {% assign non_click_style = core_style | append: 'background-color: #FFFFFF; color: #000000; font-weight: normal;' %}
        {% assign click_style = core_style | append: 'background-color: #dbe8fb; color: #000000; font-weight: medium;' %}
        {% assign div_style = 'text-align: center; display: inline-block; height: 40px;' %}
        {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 40px;' %}
    {% when 'tabs' %}
        {% assign core_style = 'font-color: #4285F4; padding: 5px 10px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px;'%}
        {% assign non_click_style = core_style | append: 'border-width: 1px; border-color: #D3D3D3;' %}
        {% assign click_style = core_style | append: 'border-width: 3px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;' %}
        {% assign div_style = 'border-bottom: solid 2px #808080; padding: 4px 10px 0px 10px; height: 38px;' %}
        {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 38px;' %}
    {% when 'plain' %}
        {% assign non_click_style = 'color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;' %}
        {% assign click_style = non_click_style | append: 'font-weight:bold;font-size: 12px;' %}
        {% assign div_style = 'float: left;' %}
        {% assign span_style = 'font-size: 10px; display: table; margin:0 auto;' %}
  {% endcase %}"
}

#} end constants for link style

#########################################################
# LINK_MAP: Map explore fields to filters
#{
# The constants with the link_map_ prefix are used to map fields in an Explore/view to either:
# 1. dashboard filter names
# 2. fields in a different Explore
#
# To define the mapping:
# - Use | between field and filter
# - Use || between each mapped pair
# - When the link property also includes the liquid variable use_qualified_filter_names set to false, specifying the view name is optional.
#   This is particularly useful when dealing with multiple Explores containing common fields that require mapping to dashboard filters.
# - Example mapping syntax:
#       value: "invoice_date|date||business_unit_name|business_unit"
#    In this example, any filters for invoice_date will be passed to the dashboard filter named date.
#    Any filters for field business_unit_name will be passed to the dashboard filter named business unit.
# - Additional mapping pairs can be appended to these constants when defining the link property.
# - Example measure which opens a dashboard using the constant
#   link_map_otc_sales_orders_to_order_details to define the source_to_destination_filters_mapping:
#       measure: total_booking_amount_target_currency_formatted {
#           link: {
#             label: "Order Line Details"
#             icon_url: "/favicon.ico"
#             url: "
#                @{link_build_variable_defaults}
#               {% assign link = link_generator._link %}
#               {% assign use_qualified_filter_names = false %}
#               {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
#               {% assign model = _model._name %}
#               {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
#               {% assign default_filters='is_booking=Yes'%}
#               {% assign use_default_filters_to_override = false %}
#               @{link_build_dashboard_url}
#               "
#             }
#         }

#--> link_map_otc_sales_invoices_to_invoice_details
#{ Maps fields found in Explores sales_invoices and sales_invoices_daily_agg
#  to filters on dashboard otc_billing_invoice_line_details
#}
constant: link_map_otc_sales_invoices_to_invoice_details {
  value: "invoice_date|date||business_unit_name|business_unit||bill_to_customer_country|customer_country||bill_to_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency"
}

#--> link_map_otc_sales_orders_to_order_details
#{ Maps fields found in Explores sales_orders and sales_orders_daily_agg
#  to filters on dashboard otc_order_line_item_details
#}
constant: link_map_otc_sales_orders_to_order_details {
  value: "ordered_date|date||business_unit_name|business_unit||parameter_customer_type|customer_type||selected_customer_country|customer_country||selected_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency||parameter_language|item_language||open_closed_cancelled|order_status||order_category_code|order_category_code||line_category_code|line_category_code"
}

#--> link_map_otc_sales_orders_to_order_details_extra_mapping
#{
# - To accommodate the dual purpose of the selected_product_dimension_description field, which can represent either an item description
#   or a category description based on the parameter_display_product_level parameter,
#   additional logic is required to ensure the correct mapping to the corresponding dashboard filter--either item_description or item_category.
# - Returns a liquid variable called extra_mapping which can be appended to the source_to_destination_filters_mapping variable.
#}
constant: link_map_otc_sales_orders_to_order_details_extra_mapping {
  value: "{%- assign extra_mapping = '' -%}
          {%- if sales_orders__lines.selected_product_dimension_description._in_query -%}
              {%- assign append_extra_mapping = true -%}
              {%- assign pl = sales_orders__lines.parameter_display_product_level._parameter_value -%}
              {%- if pl == 'Category' -%}
                    {%- assign target_filter = 'item_category' -%}
              {%- elsif pl == 'Item' -%}
                    {%- assign target_filter = 'item_description' -%}
              {%- endif -%}
          {%- assign extra_mapping = '||selected_product_dimension_description|' | append: target_filter -%}
          {%- else -%}
              {%- assign append_extra_mapping = false -%}
          {%- endif -%}"
}

#--> link_map_otc_invoices_to_order_details
#{ Maps fields found in explores sales_invoices and sales_invoices_daily_agg
#  to dashboard filters on dashboard otc_order_line_item_details
#}
constant: link_map_otc_invoices_to_order_details {
  value: "parameter_target_currency|target_currency||parameter_language|item_language||order_header_number|order_number"
}

constant: link_map_otc_order_details_id {
  value: "{% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}"
  # value: "{% assign target_dashboard = '153' %}"
}

constant: link_map_otc_invoice_details_id {
  value: "{% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details' %}"
  # value: "{% assign target_dashboard = '156' %}"
}


#--> link_map_filters_from_navigation_dash_bindings
#{
# - Generates liquid variable source_to_destination_filters_mapping used in building a dashboard url.
# - For dashboard navigation defined using an extension of template_dashboard_navigation_ext,
#   the LookML developer uses the dash_bindings and map_filter_numbers_to_dashboard_filter_names dimensions
#   to map filters 1 to N to filters of one or more dashboards.
# - This constant reads the value of this dimension and the dash_bindings dimension to
#   generate the liquid variable source_to_destination_filters_mapping in the required syntax.
# - See template_dashboard_navigation_ext.navigation_links dimension for example of how this constant is used.
#}
constant: link_map_filters_from_navigation_dash_bindings {
value: "{% assign source_to_destination_filters_mapping = ''%}

    <!-- Capture model_name and view_name (if needed to qualify field name) -->
        {% assign model_name = _model._name %}
        {% if use_qualified_filter_names == true %}
          {% assign view_name = _view._name | append: '.' %}
        {%else%}
          {% assign view_name = '' %}
        {%endif%}

    <!-- Create nav_items array from dash_bindings and dash_map from map_filter_numbers_to_dashboard_filter_names. -->
        {% assign nav_items = dash_bindings._value | split: '||' %}
        {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}

    <!-- Begin loop through the array of dashboards. -->
    <!-- Note this for loop ends outside of this constant in the navigation_links html property -->
        {% for nav_item in nav_items %}
            {% assign nav_parts = nav_item | split: '|' %}
            {% assign dash_label = nav_parts[1] %}

    <!-- Assign target_dashboard name and ensure any LookML dashboard names provided follow proper naming syntax. -->
        {% assign target_dashboard = nav_parts[0] %}
        {% assign check_target_type = target_dashboard | plus: 0 %}
        <!-- If check_target_type == 0 then dashboard name is a string and not a user-defined dashboard. -->
           {% if check_target_type == 0 %}
        <!-- For dashboards with '::', keep the name as is. Otherwise, add the model name and '::' to ensure proper reference to the LookML dashboard. -->
              {% if target_dashboard contains '::' %}{% else %}
                {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
              {% endif %}
            {% endif %}

    <!-- Create source_to_destination_filters_mapping variable by looping through the mapped pairs -->
        {% assign dash_filter_set = nav_parts[2] | split: ',' %}
        {% for dash_filter in dash_filter_set %}
            {% for map_item in dash_map %}
                {% assign map_item_key = map_item | split:'|' | first %}
                {% if dash_filter == map_item_key %}
                    {% assign map_item_value = map_item | split:'|' | last %}
                    {% assign filter_name = view_name | append: 'filter' | append: dash_filter | append: '|' | append: map_item_value | append: '||' %}
                    {% assign source_to_destination_filters_mapping = source_to_destination_filters_mapping | append: filter_name  %}
                  {% endif %}
              {% endfor %}
          {% endfor %}"
}


#} end constants for link maps

#########################################################
# LINK_VIS: Set config properties
#{
# Constants with the link_vis prefix define configuration values for
# common visualization types and patterns. When defining a field's link property,
# use one of these constants to pass the desired viz configuration to the url.
#
# Each of these generates a liquid variable called {{vis_config}} and you can
# append additional parameters to this as needed once you add the constant to the
# link property.
#
# Every link_vis_ constant requires the liquid variable drill_fields as a minimum input.
# Additionally, some functions may require other inputs.
#
# Example measure that opens a drill modal with a line chart for sales by month
# with the reference to link_vis_line_chart_1_date_1_measure.
#
#   measure: total_sales_amount_target_currency_formatted {
#     link: {
#           label: "Show Sales by Month"
#           url: "@{link_build_variable_defaults}
#                   {% assign link = link_generator._link %}
#                   {% assign view_header = _explore._name | append: '.' %}
#                   {% assign view_detail = _view._name | append: '.' %}
#                   {% assign measure = 'total_sales_amount_target_currency' | prepend: view_detail %}
#                   {% assign date_dimension = 'ordered_month' | prepend: view_header %}
#                   {% assign drill_fields =  date_dimension | append: ',' | append: measure %}
#                 @{link_vis_line_chart_1_date_1_measure}
#                 @{link_build_explore_url}"
#           }
#       }

constant: link_vis_table {
  value: "{% assign vis_config = '{\"type\":\"looker_grid\"}' | url_encode | prepend: '&vis_config=' %}"
}

#--> link_viz_table_no_cell_visualization
# Creates table and cell visualization for measures is disabled
constant: link_vis_table_no_cell_visualization {
  value: "{% assign vis_config = '{\"type\":\"looker_grid\",\"series_cell_visualizations\":{}}' | url_encode | prepend: '&vis_config=' %}"
}

#--> link_vis_table_assign_cell_visualization
# Creates table with developer-provided cell visualization in the form of:
# {% assign cell_visualization = '\"sales_orders__lines.total_sales_amount_target_currency\":{\"is_active\":true},\"sales_orders__lines.total_shipped_amount_target_currency\":{\"is_active\":true}' %}
constant: link_vis_table_assign_cell_visualization {
  value: "{% assign vis_config = '{\"type\":\"looker_grid\",\"series_cell_visualizations\":{' | append: cell_visualization | append: '}}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_column {
  value: "{% assign vis_config = '{\"type\":\"looker_column\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_bar {
  value: "{% assign vis_config = '{\"type\":\"looker_bar\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_area {
  value: "{% assign vis_config = '{\"type\":\"looker_area\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_line {
  value: "{% assign vis_config = '{\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_map {
  value: "{% assign vis_config = '{\"type\":\"looker_map\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_pie {
  value: "{% assign vis_config = '{\"type\":\"looker_pie\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_single {
  value: "{% assign vis_config = '{\"type\":\"single_value\"}' | url_encode | prepend: '&vis_config=' %}"
}

#--> link_vis_line_chart_1_date_1_measure
# Creates a line chart for a given measure. The liquid variable measure must be defined before calling the constant.
# For example:
#   {% assign measure = sales_orders__lines.total_sales_amount_target_currency %}
#   @{link_vis_line_chart_1_date_1_measure}
constant: link_vis_line_chart_1_date_1_measure {
  value: "{% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#468FAF\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}"
}

#} end constants for link vis

#########################################################
# LINK_BUILD: Steps building link url
#{
# The constants with the link_build_ prefix take a specific step or action in creating
# a final URL. Steps like defining defaults, extracting context, matching
# filters to destination, etc...

#-->link_build_variable_defaults
#{
# Set default values for liquid variables used to build the url.
# Always add this constant to the link property first to establish the defaults.
# Then you can customize any of these as needed.
#}
constant: link_build_variable_defaults {
  value: "
  {% comment %} Default Parameters for Explores Only {% endcomment %}
  {% comment %} Customizable by LookML Developer {% endcomment %}
    {% assign drill_fields = '' %}
    {% assign pivots = '' %}
    {% assign subtotals = '' %}
    {% assign sorts = '' %}
    {% assign limit = '500' %}
    {% assign column_limit = '50' %}
    {% assign total = '' %}
    {% assign row_total = '' %}
    {% assign query_timezone = '' %}
    {% assign dynamic_fields = '' %}
    {% assign use_different_explore = false %}
    {% assign target_model = '' %}
    {% assign target_explore = '' %}

  {% comment %} Default visualization config parameter {% endcomment %}
    @{link_vis_table}

  {% comment %} Default parameters for either Explore or Dashboard {% endcomment %}
  {% comment %} Customizable by LookML Developer {% endcomment %}
    {% assign use_default_filters_to_override = false %}
    {% assign default_filters = '' %}
    {% assign use_qualified_filter_names = true %}
    {% assign use_url_variable = false %}

  {% comment %} Variables to be built in other link_build_ constants {% endcomment %}
    {% assign source_to_destination_filters_mapping = '' %}
    {% assign target_content_filters = '' %}
  "
}

#-->link_build_context
#{
# Extracts the context from the URL captured when the business user clicks on the measure's link in either an Explore or dashboard.
#
# Requires the link variable to be included in the link url property:
#     {% assign link = link_generator._link %}
#
# Is called from either:
#   link_build_dashboard_url
#   link_build_explore_url
#
# This constant loops through array link_query_parameters and generates these liquid variables if found:
#   filters_array
#   dynamic_fields
#   query_timezone
#}
constant: link_build_context {
  value: "
  {% assign filters_array_source = '' %}
  {% for parameter in link_query_parameters %}
    {% assign parameter_key = parameter | split:'=' | first %}
    {% assign parameter_value = parameter | split:'=' | last %}
    {% assign parameter_test = parameter_key | slice: 0,2 %}
    {% if parameter_test == 'f[' %}
        {% comment %} Link contains multiple parameters, need to test if filter {% endcomment %}
        {% if parameter_key != parameter_value %}
          {% comment %} Tests if the filter value is is filled in, if not it skips  {% endcomment %}
          {% assign parameter_key_size = parameter_key | size %}
          {% assign slice_start = 2 %}
          {% assign slice_end = parameter_key_size | minus: slice_start | minus: 1 %}
          {% assign parameter_key = parameter_key | slice: slice_start, slice_end %}
          {% assign parameter_clean = parameter_key | append:'|' |append: parameter_value %}
          {% assign filters_array_source =  filters_array_source | append: parameter_clean | append: ',' %}
        {% endif %}
    {% elsif parameter_key == 'dynamic_fields' %}
      {% assign dynamic_fields = parameter_value %}
    {% elsif parameter_key == 'query_timezone' %}
      {% assign query_timezone = parameter_value %}
    {% endif %}
  {% endfor %}
  {% assign size = filters_array_source | size | minus: 1 | at_least: 0 %}
  {% assign filters_array_source = filters_array_source | slice: 0, size %}
  "
}

#-->link_build_match_filters_to_destination
#{
# Builds the filters_array_destination variable with the destination filter names and the source filter values.
# Requires these inputs:
#   1. source_to_destination_filters_mapping variable from a measure's link property.
#      The mapping indicates how a source field maps to a dashboard filter or a field in a different Explore.
#      The mapping pairs are defined in the form of:
#         view_name.field_name|destination filter1||view_name.field_name2|destination filter2
#      See constant link_map_otc_sales_invoices_to_invoice_details for an example mapping.
#   2. filters_array_source generated with constant link_build_context
#
# Is called from either:
#   link_build_dashboard_url
#   link_build_explore_url

# Loops through each destination filter and checks to see if the field named in the source to
# destination mapping has filter values captured.
#
# For example, a destination dashboard has 3 filters: date, business_name and country and these are mapped
# to Explore fields:
#   sales_orders.ordered_date|date||
#   sales_orders.business_org_name|business_name||
#   sales_orders.country_name|country
#
# The filters_array_source variable captured two filters with these values:
#     sales_orders.ordered_date = last 1 year
#     sales_orders.country_name = USA
#
# The filters_array_destination variable is defined as:
#         date|last 1 year,country|USA
#}
constant: link_build_match_filters_to_destination {
  value: "
  {% assign source_to_destination_filters_mapping = source_to_destination_filters_mapping | split: '||' %}
  {% assign filters_array_source = filters_array_source | split: ',' %}
  {% assign filters_array_destination = '' %}

  {% for source_filter in filters_array_source %}
    {% assign source_filter_key = source_filter | split:'|' | first %}
    {% if use_qualified_filter_names == false %}
        {% comment %} Ignore view name and return field names only {% endcomment %}
        {% assign source_filter_key = source_filter_key | split: '.' | last %}
    {% endif %}
    {% assign source_filter_value = source_filter | split:'|' | last %}

    {% for destination_filter in source_to_destination_filters_mapping %}
      {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
        {% assign destination_filter_key = destination_filter | split:'|' | first %}
        {% assign destination_filter_value = destination_filter | split:'|' | last %}
        {% if source_filter_key == destination_filter_key %}
          {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
          {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
        {% endif %}
    {% endfor %}
  {% endfor %}
  {% assign size = filters_array_destination | size | minus: 1 | at_least: 0 %}
  {% assign filters_array_destination = filters_array_destination | slice: 0, size %}
  "
}

#-->link_build_filter_string
#{
# Creates the liquid variable filter_string as url-encoded string formatted for Explore or dashboard.
#
# Requires filters_array_destination from constant link_build_match_filters_to_destination.
#
# Is called from:
#     link_build_dashboard_url
#     link_build_explore_url
#}
constant: link_build_filter_string {
  value: "
  {% assign filter_string = '' %}
  {% assign filters_array_destination = filters_array_destination | split: ',' %}
  {% for filter in filters_array_destination %}
    {% if filter contains 'EMPTY' %}
    {%else%}
        {% if filter != blank %}
          {% assign filter_key = filter | split:'|' | first %}
          {% assign filter_value = filter | split:'|' | last %}
            {% if content == '/explore/' %}
              {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
            {% else %}
              {% assign filter_value = filter_value | encode_url %}
              {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
            {% endif %}
          {% assign filter_string = filter_string | append: filter_compile | append:'&' %}
        {% endif %}
    {% endif %}
  {% endfor %}
  {% assign size = filter_string | size | minus: 1 | at_least: 0 %}
  {% assign filter_string = filter_string | slice: 0, size %}
  "
}

#-->link_build_default_filter_string
#{
# Creates the liquid variable default_filter_string as url-encoded string formatted for an Explore or dashboard.
#
# Requires input of default_filters defined by LookML developer in the link property
#
# Is called by these link_ constants if default_filters is not blank:
#     link_build_dashboard_url
#     link_build_explore_url
#}
constant: link_build_default_filter_string {
  value: "
  {% assign default_filter_string = '' %}
  {% assign default_filters = default_filters | split: ',' %}
  {% for filter in default_filters %}
    {% assign filter_key = filter | split:'=' | first %}
    {% assign filter_value = filter | split:'=' | last %}
    {% if content == '/explore/' %}
      {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
    {% else %}
      {% assign filter_value = filter_value | encode_url %}
      {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
    {% endif %}
    {% assign default_filter_string = default_filter_string | append: filter_compile | append:'&' %}
  {% endfor %}
  {% assign size = default_filter_string | size | minus: 1 | at_least: 0 %}
  {% assign default_filter_string = default_filter_string | slice: 0, size %}
  "
}

#-->link_build_dashboard_url
#{
# Generates the final dashboard url and returns either:
#     a. the url opened in the frontend UI when use_url_variable == false (which is the default)
#     b. a liquid variable named dashboard_url which can be referenced in a field's html property when use_url_variable == true
#
# See navigation_links dimension in template_dashboard_navigation_ext for an example of using the dashboard_url variable.
#
# Requires these to be added to a measure's link property::
#   - @{link_build_variable_defaults}
#   - the link variable to be included in the measure's link url property:
#            {% assign link = link_generator._link %}
#   - name of target_dashboard:
#       {% assign model = _model._name %}
#       {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
#   - @{link_build_dashboard_url}
#
# Optional Inputs (see link_build_variable_defaults for default values) :
#   - filters_mapping
#   - use_qualified_filter_names
#   - default_filters
#   - use_default_filters_to_override
#   - use_url_variable

# Steps Taken:
#   1. Assigns values to these liquid variables:
#         content is set to '/dashboards/'
#         link_path as derived from {{link}} which the LookML Developer adds when setting the field's link property
#         link_query_parameters
#   2. Calls link_build_context
#   3. Calls link_build_match_filters_to_destination
#   4. Calls link_build_filter_string
#   5. If default_filters is not blank calls link_build_default_filter_string
#   6. Builds target_content_filter based on value for use_default_filters_to_override
#   7. If use_url_variable == false returns url that opens a dashboard in UI
#      else returns a liquid variable called dashboard_url which can be referenced in a field's html property.
#}
constant: link_build_dashboard_url {
  value: "
  {% assign content = '/dashboards/' %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}

  @{link_build_context}
  @{link_build_match_filters_to_destination}
  @{link_build_filter_string}

  {% if default_filters != '' %}
    @{link_build_default_filter_string}
  {% endif %}

  {% if use_default_filters_to_override == true and default_filters != '' %}
    {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
  {% elsif use_default_filters_to_override == false and default_filters != '' %}
    {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
  {% else %}
    {% assign target_content_filters = filter_string %}
  {% endif %}

  {% comment %} Builds final link to be presented as either a url in frontend or a liquid variable {% endcomment %}
  {% assign dashboard_url = content | append: target_dashboard | append: '?' | append: target_content_filters %}
  {% if use_url_variable == false %}
    {{ dashboard_url }}
  {% endif %}
  "
}

#-->link_build_explore_link_variable
#{ Generates the liquid variable explore_link by appending
#  each of these liquid variables when not blank:
#    liquid variable                 source
#    ---------------                 -----------
#    content                         set to 'explore' in link_build_explore_url
#    target_model, target_explore    default '' or when use_different_explore==true set by LookML Developer
#                                    else derived in link_build_explore_url based on captured link value
#    drill_fields                    default '' or set by LookML Developer
#    target_content_filters          default '' or compiled in link_build_explore_url from filter_string (see link_build_filter_string)
#                                    and default_filter_string (see link_build_default_filter_string)
#    vis_config                      default link_vis_table or set by LookML Developer with any of the link_vis_ constants or a custom value
#    pivots                          default '' or set to specific fields by LookML Developer
#    subtotals                       default '' or set to specific fields by LookML Developer
#    sorts                           default '' or set to specific fields by LookML Developer
#    limit                           row limit default of 500 or set by LookML Developer
#    column_limit                    row limit default of 50 or set by LookML Developer
#    total                           column total default '' or set to 'on' by LookML Developer
#    row_total                       default '' or set to 'right' by LookML Developer
#    query_timezone                  default '' or set by LookML Developer
#    dynamic_fields                  default '' or set by LookML Developer
#
#}
constant: link_build_explore_link_variable {
  value: "
  {% assign explore_link = '' %}

  {% if content != '' %}
    {% assign explore_link = explore_link | append: content %}
  {% endif %}
  {% if target_model != '' %}
    {% assign explore_link = explore_link | append: target_model | append: '/' %}
  {% endif %}
  {% if target_explore != '' %}
    {% assign explore_link = explore_link | append: target_explore | append: '?'  %}
  {% endif %}
  {% if drill_fields != '' %}
    {% assign explore_link = explore_link | append: drill_fields %}
  {% endif %}
  {% if target_content_filters != '' %}
    {% assign explore_link = explore_link | append: target_content_filters %}
  {% endif %}
  {% if vis_config != '' %}
    {% assign explore_link = explore_link | append: vis_config %}
  {% endif %}
  {% if pivots != '' %}
    {% assign pivots = '&pivots=' |append: pivots %}
    {% assign explore_link = explore_link | append: pivots %}
  {% endif %}

  {% if subtotals != '' %}
    {% assign subtotals = '&subtotals=' |append: subtotals %}
    {% assign explore_link = explore_link | append: subtotals %}
  {% endif %}

  {% if sorts != '' %}
    {% assign sorts = '&sorts=' |append: sorts %}
    {% assign explore_link = explore_link | append: sorts %}
  {% endif %}

  {% if limit != '' %}
    {% assign limit = '&limit=' |append: limit %}
    {% assign explore_link = explore_link | append: limit %}
  {% endif %}

  {% if column_limit != '' %}
    {% assign column_limit = '&column_limit=' |append: column_limit %}
    {% assign explore_link = explore_link | append: column_limit %}
  {% endif %}

  {% if total != '' %}
    {% assign total = '&total=' |append: total %}
    {% assign explore_link = explore_link | append: total %}
  {% endif %}

  {% if row_total != '' %}
    {% assign row_total = '&row_total=' |append: row_total %}
    {% assign explore_link = explore_link | append: row_total %}
  {% endif %}

  {% if query_timezone != '' %}
    {% assign query_timezone = '&query_timezone=' |append: query_timezone %}
    {% assign explore_link = explore_link | append: query_timezone %}
  {% endif %}

  {% if dynamic_fields != '' %}
    {% assign dynamic_fields = '&dynamic_fields=' |append: dynamic_fields %}
    {% assign explore_link = explore_link | append: dynamic_fields %}
  {% endif %}
  "
}

#-->link_build_explore_url
#{
# Generates an Explore url and returns it as either:
#   a. the Explore url opened as a drill modal in the frontend UI when use_url_variable == false (which is the default)
#   b. a liquid variable named explore_link which can be referenced in a field's html property when use_url_variable == true
#
# Requires these to be added to a measure's link property::
#     - @{link_build_variable_defaults}
#     - the link variable to be included in the measure's link url property:
#             {% assign link = link_generator._link %}
#     - one or more drill_fields:
#         {% assign drill_fields = sales_orders.ordered_date,sales_orders__lines.tootal_sales_amount_target_currency %}
#     - settings for vis_config. Pass as one of the look_vis_ constants or define directly.
#         @{link_vis_line_chart_1_date_1_measure}
#         OR
#         {% assign vis_config = '{\"type\":\"looker_grid\",\"series_cell_visualizations\":{}}' | url_encode | prepend: '&vis_config=' %}
#     - @{link_build_explore_url}
#
# Optional Inputs (see link_build_variable_defaults for default values) :
#   use_different_explore
#   target_model
#   target_explore
#   filters_mapping
#   use_qualified_filter_names
#   default_filters
#   use_default_filters_to_override
#   use_url_variable
#   pivots
#   subtotals
#   sorts
#   limit
#   column_limit
#   total
#   row_total
#   query_timezone
#   dynamic_fields
#
# Steps Taken:
#   1. Assigns values to these liquid variables:
#         content is set to explore
#         link_path as derived from {{link}} which the LookML Developer adds when setting the field's link property
#         link_query_parameters
#         drill_fields
#         target_model and target_explore if use_different_explore == false
#   2. Calls link_build_context
#   3. If use_different_explore == true calls link_build_match_filters_to_destination else assigns
#      filters_array_destination to match filters_array_source
#   4. Calls link_build_filter_string
#   5. If default_filters is not blank calls link_build_default_filter_string
#   6. Assigns value to target_content_filter based on true or false value for use_default_filters_to_override
#   7. Calls link_build_explore_link_variable
#   8. If use_url_variable == false returns final Explore url which opens a drill modal
#      else returns a liquid variable called explore_link which can be referenced in a field's html property.
#}
constant: link_build_explore_url {
  value: "
  {% assign content = '/explore/' %}
  {% assign link_path =  link | split: '?' | first %}
  {% assign link_path =  link_path | split: '/'  %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign drill_fields = drill_fields | prepend:'fields='%}

  {% if use_different_explore == false %}
    {% assign target_model = link_path[1] %}
    {% assign target_explore = link_path[2] %}
  {% endif %}

  @{link_build_context}

  {% if use_different_explore %}
    @{link_build_match_filters_to_destination}
  {% else %}
    {% assign filters_array_destination = filters_array_source %}
  {% endif %}

  @{link_build_filter_string}

  {% if default_filters != '' %}
    @{link_build_default_filter_string}
  {% endif %}

  {% if use_default_filters_to_override == true and default_filters != '' %}
    {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string | prepend:'&' %}
  {% elsif use_default_filters_to_override == false and default_filters != '' %}
   {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string | prepend:'&' %}
  {% else %}
    {% assign target_content_filters = filter_string | prepend:'&' %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  @{link_build_explore_link_variable}
  {% if use_url_variable == false %}
    {{explore_link}}
  {% endif %}
  "
}

#} end constants for link build

#} end constants for links
