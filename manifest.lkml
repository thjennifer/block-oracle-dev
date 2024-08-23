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

# constant: CONNECTION_NAME {

#   value: "qa-thjennifer1"
#   export: override_required
# }

# constant: GCP_PROJECT_ID {

#   value: "thjennifer1"
#   export: override_required
# }

#########################################################
# CATEGORY SET and DEFAULT TARGET DATE
#{
# define values for category set and default target date based
# on user attribute values

constant: category_set {
  value: "{% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}'{{category_set}}'"
}

# if usng test data set target date to 3/28/2024 to match dates in that dataset otherwise use current date
constant: default_target_date {
  value:  "{%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}
  {%- if test_data == 'YES' -%}
  {%- assign td = '2024-03-28' -%} {%- else -%}
  {%- assign td = 'now' | date: '%Y-%m-%d' -%}{%- endif -%}'{{td}}'"
}

#} end constants for category set and target date

#########################################################
# HTML FORMATS
#{
# formatting values using html property


# html_format_big_numbers
#{
# Formats positive and negative numbers by appending B, M, K, or no suffix based on magnitude.
# example use:
#   measure: sum_ordered_amount {
#     type: sum
#     sql: ${ordered_amount_target_currency} ;;
#     html: @{html_format_big_numbers} ;;
#   }

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
#}

# Use Symbols for yesno type fields
# assign symbol for Yes values only, No values only or both Yes/No values
#{
# For yes/no type fields, displays symbols instead of Yes/No values.
# example use:
#   dimension: is_fulfilled {
#     type: yesno
#     html: @{html_symbols_for_yes_no} ;;
#   }
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
#}

# Warning messages
#{
# For measures in source currency, returns a warning message if currency_code field is missing
# from query.
# example use:
# measure: total_amount_adjusted_in_source_currency {
#   type: sum
#   sql: {%- if currency_code._is_selected -%}${amount_adjusted}{%- else -%}NULL{%- endif -%} ;;
#   html: @{html_message_source_currency} ;;
# }
constant: html_message_source_currency {
  value: "{%- if currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%}"
}
#}
#} end constants for html formats

#########################################################
# LABELS: Views
#{
# define view labels to use in Explores

# View labels
constant: view_label_for_filters {
  value: "🔍 Filters"
}

constant: view_label_for_dashboard_navigation {
  value: "🛠 Dashboard Navigation"
}

#} end constants for view labels

#########################################################
# LABELS: Target Currency Fields
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
# Example use with defaults:
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_defaults}@{label_field_name}@{label_currency_if_selected}
#   }
#   Total Amount Adjusted (USD)
#   Total Amount Adjusted (Target Currency)
#
# Example use with removal of total_ prefix:
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}
#   }
#   Amount Adjusted (USD)
#   Amount Adjusted (Target Currency)
#
# Example use with addition of Formatted to Explore label:
#   measure: total_amount_adjusted_target_currency_formatted {
#     label: @{label_defaults}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}
#   }
#   Total Amount Adjusted (USD)
#   Total Amount Adjusted (Target Currency) Formatted
#
# Example use custom value provided for field_name:
#   measure: total_amount_adjusted_target_currency {
#     label: @{label_defaults}{%- assign field_name = 'Adjusted Amount' -%}@{label_currency_if_selected}
#   }
#   Adjusted Amount (USD)
#   Adjusted Amount (Target Currency)
#}
#
# label_defaults
#   - Initial values for liquid variables that will be used to create the label.
#       currency = value in parameter_target_currency that will be appended to label when field is selected.
#       field_name = blank
#       remove_words = '_target_currency, _formatted' meaning these words will not be in label.
#       remove_total_prefix = false. When true 'total_' will also be removed from label.
#       add_words = ' (Target Currency)' will be appended to field_name and displayed in the Explore
#       add_formatted = false. When true, ' Formatted' will be added to label displayed in the Explore
#   - These defaults can be overridden when defining the label property.
constant: label_defaults {
  value: "{%- assign currency = otc_common_parameters_xvw.parameter_target_currency._parameter_value | remove: \"'\" -%}
  {%- assign field_name = '' -%}
  {%- assign remove_words = '_target_currency,_formatted' -%}
  {%- assign remove_total_prefix = false -%}
  {%- assign add_words = ' (Target Currency)' -%}
  {%- assign add_formatted = false -%}
  "
}

# label_field_name
#   - Creates liquid variable {{ field_name }} for use in 'label' property.
#   - Captures _field._name and removes words defined in liquid variable remove_words and remove_total_prefix.
#   - Capitalizes remaining words.
#   - For example, a dimension named total_ordered_amount_target_currency will return
#     Total Ordered Amount
constant: label_field_name {
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

# label_currency_if_selected
#   - Builds label to use when a field is selected for a chart and when it is listed in Explore.
#   - Derives from field name itself with some unnecessary words removed.
#   - If field is selected for a query, appends the target currency value else appends phrase ' (Target Currency)' to the field
#   - For example, for a dimension named total_ordered_amount_target_currency and a selected currency of USD, you will see:
#       Total Ordered Amount (USD) when shown in chart and
#       Total Ordered Amount (Target Currency) when shown in the Explore
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
# IS_SELECTED or IN_QUERY
#{
# _is_selected returns true if the field you ask for:
#     - is included in the query as a selected field
#     - is included in the query using the required_fields parameter
#
# _in_query returns true if the field you ask for:
#     - is included in the query as a selected field
#     - is included in the query as a filter
#     - is included in the query using the required_fields parameter
#
# These constants check if fields are selected or queried.
# Actions can be taken based on true or false. For example,
# in sales_orders_daily_agg, order counts can't be summed
# across filtered categories. If categories are queried,
# return a warning or null for Order Count measures.
#
# is_agg_category_in_query
# returns true if any of these category fields from
# sales_orders_agg__lines is in the query:
#     category_id, category_description, category_name_code,
#     item_organization_id, item_orgranization_name
# To use this constant, complete the rest of the statement (what to return when true and false).
# For example:
#     measure: order_count {
#       type: sum
#       sql: @{is_agg_category_selected}NULL {%else} ${num_orders} {% endif %} ;;
#     }
constant: is_agg_category_in_query {
  value: "{% if sales_orders_daily_agg__lines.category_id._in_query or
                sales_orders_daily_agg__lines.category_description._in_query or
                sales_orders_daily_agg__lines.category_name_code._in_query or
                sales_orders_daily_agg__lines.item_organization_id._in_query or
                sales_orders_daily_agg__lines.item_organization_name._in_query
                %}"
}


# is_item_or_category_selected
# returns true if any of these item or category fields is selected:
#     category_id, category_description, category_name_code,
#     inventory_item_id, item_part_number, item_description,
#     selected_product_dimension_id, selected_product_dimension_description
# To use this constant, complete the rest of the statement (what to return when true and false).
# For example:
#     measure: average_cycle_time_days {
#       type: average
#       sql: @{is_item_or_category_selected}${cycle_time_days}{%- else -%}NULL{%- endif -%};;
#     }
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


# is_item_selected
# - returns true if any of these item or category fields is selected:
#     inventory_item_id, item_part_number, item_description
# - returns true if Item is displayed usng parameter_display_product_level and
#   either selected_product_dimension_id or selected_product_dimension_description is selected.
# To use this constant, complete the rest of the statement (what to return when true and false).
# For example:
#     measure: total_ordered_quantity_by_item {
#       sql: @{is_item_selected}${ordered_quantity}{%- else -%}NULL {%- endif -%} ;;
#       html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
#     }
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


# measure: average_gross_unit_selling_price_when_discount_target_currency {
# #--> opens Invoice Line Details dashboard with filter is_discounted = Yes
#   link: {
#     label: "Invoice Line Details"
#     icon_url: "/favicon.ico"
#     url: "
#     @{link_generate_variable_defaults}
#     {% assign link = link_generator._link %}
#     {% assign qualify_filter_names = false %}
#     {% assign filters_mapping = '@{link_map_sales_invoices_to_invoice_details}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}
#     {% assign model = _model._name %}
#     {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details' %}
#     {% assign default_filters='is_discounted=Yes'%}
#     {% assign default_filters_override = false %}
#     @{link_generate_dashboard_url}
#     "
#   }
# }

# measure: total_booking_amount_target_currency_formatted {
#   link: {
#     label: "Order Line Details"
#     icon_url: "/favicon.ico"
#     url: "
#     @{link_generate_variable_defaults}
#     {% assign link = link_generator._link %}
#     {% assign qualify_filter_names = false %}
#     {% assign filters_mapping = '@{link_map_sales_orders_to_order_details}'%}

#     {% assign model = _model._name %}
#     {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
#     {% assign default_filters='is_booking=Yes'%}
#     {% assign default_filters_override = false %}
#     @{link_generate_dashboard_url}
#     "
#   }
# }

#########################################################
# LINK_MAP: Map explore fields to dashboard filters
#{
#--> Constants with the link_map prefix are used to create
#    dashboard url links defined in a field's link: property
#    by mapping fields in an explore/view to dashboard filters
#--> Use | between field and filter
#    Use || between each mapped pair
#--> When specifying the field name use view_name.field_name although
#    view name is optional when link build also includes
#    liquid variable qualify_filter_names = false
#--> Example syntanx:
#       value: "invoice_date|date||business_unit_name|business_unit"
#    In this example, any filters for invoice_date will be passed to
#    the dashboard filter named date. Any filters for field business_unit_name
#    will be passed to the dashboard filter named business unit.
#--> Additional fields can be appended to these constants when defining
#    the link property
#--> Example use that will add link to Booking Amount to open the Order Line Details dashboard:
#       measure: total_booking_amount_target_currency_formatted {
#           link: {
#             label: "Order Line Details"
#             icon_url: "/favicon.ico"
#             url: "
#                @{link_generate_variable_defaults}
#               {% assign link = link_generator._link %}
#               {% assign qualify_filter_names = false %}
#               {% assign filters_mapping = '@{link_map_sales_orders_to_order_details}'%}
#               {% assign model = _model._name %}
#               {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
#               {% assign default_filters='is_booking=Yes'%}
#               {% assign default_filters_override = false %}
#               @{link_generate_dashboard_url}
#               "
#             }
#         }

# link_map_sales_invoices_to_invoice_details
#{ Maps fields found in explores sales_invoices and sales_invoices_daily_agg
#  to dashboard filters on dashboard otc_billing_invoice_line_details
constant: link_map_sales_invoices_to_invoice_details {
  value: "invoice_date|date||business_unit_name|business_unit||bill_to_customer_country|customer_country||bill_to_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency"
}
#}

# link_map_sales_orders_to_order_details
#{ Maps fields found in explores sales_orders and sales_orders_daily_agg
#  to dashboard filters on dashboard otc_order_line_item_details
constant: link_map_sales_orders_to_order_details {
  value: "ordered_date|date||business_unit_name|business_unit||parameter_customer_type|customer_type||selected_customer_country|customer_country||selected_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency||parameter_language|item_language||open_closed_cancelled|order_status||order_category_code|order_category_code||line_category_code|line_category_code"
}
#}

# link_map_sales_orders_to_order_details_extra_mapping
#{
#--> The field selected_product_dimension_description can represent either
#    an item_description or a category_description depending on the value
#    in parameter_display_product_level.
#--> This constant will map selected_product_dimension_description to the
#    correct dashboard filter either item_description or item_category.
constant: link_map_sales_orders_to_order_details_extra_mapping {
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
#}

# link_map_invoices_to_order_details
#{ Maps fields found in explores sales_invoices and sales_invoices_daily_agg
#  to dashboard filters on dashboard otc_order_line_item_details
constant: link_map_invoices_to_order_details {
  value: "parameter_target_currency|target_currency||parameter_language|item_language||order_header_number|order_number"
}
#}

#} end constants for link maps






# test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data

constant: link_vis_table {
  value: "{% assign vis_config = '{\"type\":\"looker_grid\"}' | url_encode | prepend: '&vis_config=' %}"
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
#CE642D\
constant: link_line_chart_1_date_1_measure {
  #Required
  #measure
  value: "{% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#468faf\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}"
}



constant: link_generate_variable_defaults {
  value: "
  {% comment %} Variables to default if not created {% endcomment %}
  {% comment %} User Customizable Parameters {% endcomment %}
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
  {% assign qualify_filter_name = true %}

  {% comment %} Default Visualizations Parameters {% endcomment %}
  @{link_vis_table}

  {% comment %} Default Behavior Parameters {% endcomment %}
  {% assign default_filters_override = false %}
  {% assign default_filters = '' %}
  {% assign new_page = false %}
  {% assign different_explore = false %}
  {% assign target_model = '' %}
  {% assign target_explore = '' %}

  {% comment %} Variables to be built in code below {% endcomment %}
  {% assign filters_mapping = '' %}
  {% assign target_content_filters = '' %}
  {% assign target_default_content_filters = '' %}
  {% assign link_host = '' %}
  "
}

constant: link_host {
  #Could assign a user_attribute since it won't be used with the generator
  value: "{% assign link_host = 'https://cortexdev.cloud.looker.com' %}"
}

constant: link_extract_context {
  value: "
  {% assign filters_array = '' %}
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
          {% assign filters_array =  filters_array | append: parameter_clean | append: ',' %}
        {% endif %}
    {% elsif parameter_key == 'dynamic_fields' %}
      {% assign dynamic_fields = parameter_value %}
    {% elsif parameter_key == 'query_timezone' %}
      {% assign query_timezone = parameter_value %}
    {% endif %}
  {% endfor %}
  {% assign size = filters_array | size | minus: 1 | at_least: 0 %}
  {% assign filters_array = filters_array | slice: 0, size %}
  "
}

constant: link_match_filters_to_destination {
  value: "
  {% assign filters_mapping = filters_mapping | split: '||' %}
  {% assign filters_array = filters_array | split: ',' %}
  {% assign filters_array_destination = '' %}


  {% for source_filter in filters_array %}
    {% assign source_filter_key = source_filter | split:'|' | first %}
    {% if qualify_filter_names == false %} {% assign source_filter_key = source_filter_key | split:'.' | last %}{% endif %}
    {% assign source_filter_value = source_filter | split:'|' | last %}

    {% for destination_filter in filters_mapping %}
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

constant: link_build_filter_string {
  value: "
  {% assign filter_string = '' %}
  {% assign filters_array_destination = filters_array_destination | split: ',' %}
  {% for filter in filters_array_destination %}
  {% if filter contains 'EMPTY' %}{%else%}
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
  {% assign size = filter_string | size | minus: 1 %}
  {% if size > 0 %}
    {% assign filter_string = filter_string | slice: 0, size %}
  {% else %}
    {% assign filter_string = '' %}
  {% endif %}
  "
}

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
  {% assign size = default_filter_string | size | minus: 1 %}
  {% if size > 0 %}
  {% assign default_filter_string = default_filter_string | slice: 0, size %}
  {% endif %}
  "
}

constant: link_generate_dashboard_url {
  value: "
  {% assign content = '/dashboards/' %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign target_content_filters = '' %}
  {% assign link_host = '' %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}
  @{link_match_filters_to_destination}
  @{link_build_filter_string}

  {% if default_filters != '' %}
  @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
  {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
  {% elsif default_filters_override == false and default_filters != '' %}
  {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
  {% else %}
  {% assign target_content_filters = filter_string %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  {{ link_host | append:content | append:target_dashboard | append: '?' | append: target_content_filters }}
  "
}


constant: link_generate_dashboard_variable {
  value: "
  {% assign content = '/dashboards/' %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign target_content_filters = '' %}
  {% assign host = '' %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}
  @{link_match_filters_to_destination}
  @{link_build_filter_string}

  {% if default_filters != '' %}
  @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
  {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
  {% elsif default_filters_override == false and default_filters != '' %}
  {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
  {% else %}
  {% assign target_content_filters = filter_string %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  {% assign dashboard_url = host | append:content | append:target_dashboard | append: '?' | append: target_content_filters %}
  "
}



constant: link_build_explore {
  value: "
  {% assign explore_link = '' %}
  {% if link_host != '' %}
    {% assign explore_link = explore_link | append: host %}
  {% endif %}
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
    {% assign total = '&assign=' |append: total %}
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

constant: link_generate_explore_url {
  value: "
  {% assign content = '/explore/' %}
  {% assign link_path =  link | split: '?' | first %}
  {% assign link_path =  link_path | split: '/'  %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign drill_fields = drill_fields | prepend:'fields='%}

  {% if different_explore == false %}
    {% assign target_model = link_path[1] %}
    {% assign target_explore = link_path[2] %}
  {% endif %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}

  {% if different_explore %}
    @{link_match_filters_to_destination}
  {% else %}
    {% assign filters_array_destination = filters_array %}
  {% endif %}

  @{link_build_filter_string}

  {% if default_filters != '' %}
    @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
    {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string | prepend:'&' %}
  {% elsif default_filters_override == false and default_filters != '' %}
   {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string | prepend:'&' %}
  {% else %}
    {% assign target_content_filters = filter_string | prepend:'&' %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  @{link_build_explore}
  {{explore_link}}
  "
}

constant: link_build_mappings_from_dash_bindings {
  value: "{% assign model_name = _model._name %}
    {% if qualify_filter_names == true %}{% assign view_name = _view._name | append: '.' %}{%else%}{% assign view_name = '' %}{%endif%}
    {% assign nav_items = dash_bindings._value | split: '||' %}
    {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}
    {% assign filters_mapping = ''%}
      {% for nav_item in nav_items %}
        {% assign nav_parts = nav_item | split: '|' %}
         {% assign dash_label = nav_parts[1] %}

        {% assign target_dashboard = nav_parts[0] %}
        {% assign check_target_type = target_dashboard | plus: 0 %}

            {% if check_target_type == 0 %}
              {% if target_dashboard contains '::' %}{% else %}
                {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
              {% endif %}
            {% endif %}

          {% assign dash_filter_set = nav_parts[2] | split: ',' %}
          {% for dash_filter in dash_filter_set %}
              {% for map_item in dash_map %}
                  {% assign map_item_key = map_item | split:'|' | first %}
                  {% if dash_filter == map_item_key %}
                    {% assign map_item_value = map_item | split:'|' | last %}
                    {% assign filter_name = view_name | append: 'filter' | append: dash_filter | append: '|' | append: map_item_value | append: '||' %}
                    {% assign filters_mapping = filters_mapping | append: filter_name  %}
                  {% endif %}
              {% endfor %}
          {% endfor %}"
}


constant: link_generate_dashboard_nav_style {
  value: "{% assign nav_style = parameter_navigation_style._parameter_value %}
  {% case nav_style %}
    {% when 'buttons' %}
      {% assign core_style = 'border-collapse: separate; border-radius: 6px; border: 2px solid #dcdcdc; margin-left: 5px; margin-bottom: 5px; padding: 6px 10px; line-height: 1.5; user-select: none; font-size: 12px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 0px; white-space: normal; float: left;' %}
      {% assign page_style = core_style | append: 'background-color: #ffffff; color: #000000; font-weight: normal;' %}
      {% assign focus_page_style = core_style | append: 'background-color: #dbe8fb; color: #000000; font-weight: medium;' %}
      {% assign div_style = 'text-align: center; display: inline-block; height: 40px;' %}
      {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 40px;' %}

    {% when 'tabs' %}
      {% assign core_style = 'font-color: #4285F4; padding: 5px 10px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px;'%}
      {% assign page_style = core_style | append: 'border-width: 1px; border-color: #D3D3D3;' %}
      {% assign focus_page_style = core_style | append: 'border-width: 3px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;' %}
      {% assign div_style = 'border-bottom: solid 2px #808080; padding: 4px 10px 0px 10px; height: 38px;' %}
      {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 38px;' %}

    {% when 'plain' %}
      {% assign page_style = 'color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;' %}
      {% assign focus_page_style = page_style | append: 'font-weight:bold;font-size: 12px;' %}
      {% assign div_style = 'float: left;' %}
      {% assign span_style = 'font-size: 10px; display: table; margin:0 auto;' %}
  {% endcase %}"
}

# test version
constant: link_derive_dashboard_nav_style {
  value: "{% assign nav_style = navigation_style._parameter_value %}
          {% case nav_style %}
              {% when 'buttons' %}
                  {% assign shared_style = 'display: block; border-spacing: 0; border-collapse: separate; border-radius: 6px; border: 1px solid #dcdcdc; margin-left: 0px; margin-bottom: 5px; padding: 6px 10px; line-height: 3; user-select: none; font-size: 14px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 1px; white-space: normal; float: left;' %}
                  {% assign non_focus_page_style = shared_style | append: 'background-color: #ffffff; color: #000000; font-weight: normal;' %}
                  {% assign focus_page_style = shared_style | append: 'background-color: #dbe8fb; color: #000000; font-weight: bold;' %}
                  {% assign div_style = 'text-align: center; display: inline-block; height: 40px;' %}
                  {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 40px;' %}

              {% when 'tabs' %}
                {% assign shared_style = 'font-color: #4285F4; padding: 0px 0px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px; letter-spacing: 0px'%}
                {% assign non_focus_page_style = shared_style | append: 'border-width: 1px; border-color: #D3D3D3;' %}
                {% assign focus_page_style = shared_style | append: 'border-width: 2px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;' %}
                {% assign div_style = 'vertical-align: bottom; border-bottom: solid 2px #808080; padding: 6px 10px 8px 12px; height: 39px;' %}
                {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 39px;' %}


            {% when 'small' %}
              {% assign non_focus_page_style = 'color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;' %}
              {% assign focus_page_style = non_focus_page_style | append: 'font-weight:bold;font-size: 12px;' %}
              {% assign div_style = 'float: left;' %}
              {% assign span_style = 'font-size: 10px; display: table; margin:0 auto;' %}
            {% endcase %}"
}

constant: link_selected_button_style {
  value: "
  display: block;
  border-spacing: 0;
  border-collapse: separate;
  border-radius: 6px;
  border: 1px solid #dcdcdc;
  margin-left: 0px;
  margin-bottom: 5px;
  padding: 6px 10px;
  line-height: 1.5;
  user-select: none
  font-size: 12px;
  font-style: tahoma;
  text-align: center;
  text-decoration: none;
  letter-spacing: 0px;
  white-space: normal;
  float: left;
  background-color: #dbe8fb;
  color: #000000;
  font-weight: medium;"
}

constant: link_unselected_button_style {
  value: "
  display: block;
  border-spacing: 0;
  border-collapse: separate;
  border-radius: 6px;
  border: 1px solid #dcdcdc;
  margin-left: 0px;
  margin-bottom: 5px;
  padding: 6px 10px;
  line-height: 1.5;
  user-select: none;
  font-size: 12px;
  font-style: tahoma;
  text-align: center;
  text-decoration: none;
  letter-spacing: 0px;
  white-space: normal;
  float: left;
  background-color: #ffffff;
  color: #000000;
  font-weight: normal;"
}




#########################################################
# TEST or DEMO DATA SPECIFIC CONSTANTS
#{
# design to toggle between test dataset or demo dataset
# TO BE REMOVED FROM PRODUCTION

constant: category_set_test {
  value: "{%- if otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value == 'test' -%}
  {% assign category_set = 'Purchasing' %}
  {%- else -%}{% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}
  {%- endif -%}'{{category_set}}'"
}


constant: default_target_date_test {
  value: "{% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
  {% if test_data == 'YES' %}
  {% if otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value == 'demo' %}
  {% assign td = '2024-03-28' %} {%else%} {% assign td = '2010-10-12' %}
  {% endif %}
  {%else%}{% assign td = now | date: '%Y-%m-%d' %}{%endif%}'{{td}}'"
}

#} end constants for test or demo data
