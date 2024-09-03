#########################################################{
# PURPOSE
# UNNESTED view of Repeated Struct LINES found in SalesOrders table.
# Captures order lines details by header_id (labeled Order ID)
#
# SOURCES
# Refines View sales_orders__lines (defined in /views/base folder)
# Extends Views:
#   otc_common_item_descriptions_ext
#   otc_common_item_categories_ext
#   sales_orders_common_amount_fields_ext
#
# REFERENCED BY
# Explore sales_orders
#
# EXTENDED FIELDS
#    item_description, language_code
#    category_id, category_description, category_name_code
#    total_sales_amount_target_currency, total_booking_amount_target_currency, and other amounts
#
# REPEATED STRUCTS
# - Also includes Repeated Structs for Cancel Reasons, Item Categories and Item Descriptions. Select fields from
#   these Repeated Structs have been defined here so these do not have to be unnested. See each related view which
#   could be added to Explore if needed:
#     sales_orders__lines__item_descriptions
#     sales_orders__lines__item_categories
#     sales_orders__lines__cancel_reasons
# - Also includes Repeated INT for Return Line IDs. See:
#     sales_orders__lines__return_line_ids
#
# NOTES
# - This view includes both ORDER and RETURN lines. Use line_category_code to pick which to include.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - When field name is duplicated in header (like is_open), the sql property is restated to use the ${TABLE} reference.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders__lines.view"
include: "/views/core/otc_common_item_descriptions_ext.view"
include: "/views/core/otc_common_item_categories_ext.view"
include: "/views/core/sales_orders_common_amount_fields_ext.view"

view: +sales_orders__lines {

  fields_hidden_by_default: yes
  extends: [otc_common_item_descriptions_ext,otc_common_item_categories_ext,sales_orders_common_amount_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    sql: COALESCE(${TABLE}.LINE_ID,-1) ;;
    value_format_name: id
  }

  dimension: line_category_code {
    hidden: no
    full_suggestions: yes
  }

  dimension: line_number {
    hidden: no
  }

  dimension: return_line_ids {
    primary_key: no
    description: "Array of IDs of all return lines that reference this order line. An order line may have multiple returns"
  }


#########################################################
# PARAMETERS
#{
# parameter_display_product_level to show either Item or Categories in visualization
#    used in dimensions selected_product_dimension_id and selected_product_dimension_description

  parameter: parameter_display_product_level {
    hidden: no
    type: unquoted
    view_label: "@{label_view_for_filters}"
    label: "Display Categories or Items"
    description: "Select whether to display categories or items in report. Use with dimensions Selected Product Dimension ID and Selected Product Dimension Description"
    allowed_value: {label: "Category" value: "Category"}
    allowed_value: {label: "Item" value: "Item"}
    default_value: "Category"
  }

#} end parameters

#########################################################
# DIMENSIONS: Item
#{
# values for item_description, language_code, category_description, category_id, category_name_code are:
# - extended into this view from otc_common_item_descriptions_ext and otc_common_item_categories
# - pulled from the Repeated Struct fields ITEM_CATEGORIES and ITEM_DESCRIPTIONS

  dimension: inventory_item_id {
    hidden: no
    label: "Item ID"
    value_format_name: id
    full_suggestions: yes
  }

  dimension: item_part_number {
    hidden: no
    value_format_name: id
    full_suggestions: yes
  }

  dimension: item_organization_id {
    hidden: no
    value_format_name: id
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
  }

  dimension: selected_product_dimension_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
                {% if parameter_display_product_level._parameter_value == 'Item' %}Item{%else%}Category{%endif%}
            {%else%}Selected Product Dimension Description{%endif%}"
    description: "Values are either Item Description or Item Category Description based on user selection for Parameter Display Categories or Items"
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${item_description}{%else%}${category_description}{%endif%} ;;
    can_filter: yes
  }

  dimension: selected_product_dimension_id {
    hidden: no
    type: number
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
              {% if parameter_display_product_level._parameter_value == 'Item' %}Inventory Item ID{%else%}Category ID{%endif%}
            {%else%}Selected Product Dimension ID{%endif%}"
    description: "Values are either Item Inventory ID or Item Category ID based on user selection for Parameter Display Categories or Items"
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${inventory_item_id}{%else%}${category_id}{%endif%} ;;
    can_filter: yes
    value_format_name: id
  }

#} end item dimensions

#########################################################
# DIMENSIONS: Date
#{

#--> also in sales_orders so adding ${TABLE} reference
  dimension_group: fulfillment {
    hidden: no
    sql: ${TABLE}.FULFILLMENT_DATE ;;
  }

#--> adding label to avoid _date_date
  dimension_group: request_date {
    hidden: no
    label: "Request"
    sql:${TABLE}.REQUEST_DATE ;;
  }

#--> adding label to avoid _date_date
  dimension_group: promise_date {
    hidden: no
    label: "Promise"
  }

  dimension_group: actual_ship {
    hidden: no
  }

  dimension_group: schedule_ship {
    hidden: no
  }

#--> limiting timeframe options for this timestamp
#--> also in sales_orders so adding ${TABLE} reference
  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    sql: ${TABLE}.CREATION_TS ;;
  }

#--> limiting timeframe options for this timestamp
#--> also in sales_orders so adding ${TABLE} reference
  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    sql: ${TABLE}.LAST_UPDATE_TS ;;
  }

#} end dates

#########################################################
# DIMENSIONS: Line Status
#{
# overall line status code along with flags like is_backlog, is_cancelled, etc...
# also includes _with_symbols version of select flags that displays a symbol like ✅
# instead of Yes/No

  dimension: line_status {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_backlog {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_backlog_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    description: "✅ if line is not in ENTERED, BOOKED, CLOSED or CANCELLED statuses"
    sql: COALESCE(${is_backlog},false) ;;
    can_filter: no
    html: @{html_symbols_for_yes} ;;
  }

  dimension: is_backordered {
    hidden: no
    group_label: "Line Status"
    sql: ${TABLE}.IS_BACKORDERED ;;
    full_suggestions: yes
  }

  dimension: is_backordered_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    description: "✅ if line cannot be fulfilled with the current inventory"
    sql: COALESCE(${is_backordered},false) ;;
    can_filter: no
    html: @{html_symbols_for_yes} ;;
  }

#--> also in sales_orders so adding ${TABLE} reference
  dimension: is_booked {
    hidden: no
    group_label: "Line Status"
    sql: ${TABLE}.IS_BOOKED ;;
    full_suggestions: yes
  }

  dimension: is_booking {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_booking_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    description: "✅ if line is in ENTERED or BOOKED statuses"
    sql: COALESCE(${is_booking},false) ;;
    can_filter: no
    html: @{html_symbols_for_yes} ;;
  }

#--> also in sales_orders so adding ${TABLE} reference
  dimension: is_cancelled {
    hidden: no
    group_label: "Line Status"
    sql: ${TABLE}.IS_CANCELLED ;;
    full_suggestions: yes
  }

#--> also in sales_orders so adding ${TABLE} reference
  dimension: is_open {
    hidden: no
    type: yesno
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_OPEN ;;
  }

  dimension: has_return {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: has_return_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    description: "✅ iif the line is referenced by any return order lines"
    sql: COALESCE(${has_return},false) ;;
    can_filter: no
    html: @{html_symbols_for_yes} ;;
  }

  dimension: is_sales_order {
    hidden: yes
    type: yesno
    description: "Indicates whether Line Category Code equals ORDER"
    sql: ${line_category_code} = 'ORDER' ;;
    full_suggestions: yes
  }

#--> also in sales_orders so adding ${TABLE} reference
  dimension: is_fulfilled {
    hidden: no
    type: yesno
    group_label: "Line Status"
    sql: ${TABLE}.IS_FULFILLED ;;
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_promise_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_shipped {
    hidden: no
    type: yesno
    group_label: "Line Status"
    description: "Indicates if shipped quantity > 0"
    sql: ${shipped_quantity} > 0 ;;
    full_suggestions: yes
  }

  dimension: is_invoiced {
    hidden: no
    type: yesno
    group_label: "Line Status"
    description: "Indicates if invoiced quantity <> 0"
    sql: ${invoiced_quantity} <> 0 ;;
    full_suggestions: yes
  }

#} end  line status

#########################################################
# DIMENSIONS: Cancel Reason
#{
# pulled from CANCEL_REASON Repeated Struct
# Cancel Reason provided in multiple languages and parameter_language used to
# limit reason to only one language

  dimension: cancel_reason_code {
    hidden: no
    type: string
    group_label: "Cancel Reasons"
    description: "Cancel reason code"
    sql: (SELECT d.CODE FROM UNNEST(CANCEL_REASON) AS d WHERE d.language = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: cancel_reason_description {
    hidden: no
    type: string
    group_label: "Cancel Reasons"
    label: "Cancel Reason"
    description: "Explanation of the cancel reason code"
    sql: (SELECT d.MEANING FROM UNNEST(CANCEL_REASON) AS d WHERE d.language = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: cancel_reason_language_code {
    hidden: no
    group_label: "Cancel Reasons"
    description: "Language code of the cancel reason"
    sql: (SELECT d.LANGUAGE FROM UNNEST(CANCEL_REASON) AS d WHERE d.LANGUAGE = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }
#} end cancel reasons

#########################################################
# DIMENSIONS: Fulfillment Cycle Days
#{
# dimensions hidden and shown in Explore as average measure

# shown in Explore as measure average_days_from_promise_to_fulfillment
  dimension: fulfillment_days_after_promise_date {
    hidden: yes
    label: "Fulfillment Days after Promise Date"
  }

# shown in Explore as measure average_days_from_request_to_fulfillment
  dimension: fulfillment_days_after_request_date {
    hidden: yes
    label: "Fulfillment Days after Request Date"
  }

# shown in Explore as measure average_cycle_time_days
  dimension: cycle_time_days {
    hidden: yes
  }

#} end fulfillment cycle days dimensions

#########################################################
# DIMENSIONS: Item quantities and weights
#{
  dimension: quantity_uom {
    hidden: no
    group_label: "Quantities"
    label: "Quantity UoM"
    sql: UPPER(${TABLE}.QUANTITY_UOM) ;;
  }

  dimension: ordered_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: booking_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: backlog_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: fulfilled_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: shipped_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: invoiced_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: cancelled_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: difference_ordered_fulfilled_quantity {
    hidden: yes
    group_label: "Quantities"
    label: "Difference between Ordered and Fulfilled Quantities"
    sql: ${ordered_quantity} - COALESCE(${fulfilled_quantity},0) ;;
  }

  dimension: weight_uom {
    hidden: no
    group_label: "Weights"
    label: "Weight UoM"
  }

  dimension: unit_weight {
    hidden: no
    group_label: "Weights"
  }

  dimension: ordered_weight {
    hidden: no
    group_label: "Weights"
    }

  dimension: shipped_weight {
    hidden: no
    group_label: "Weights"
  }

#} end item quantities and weights

#########################################################
# DIMENSIONS: Item price and cost
#{

  dimension: unit_cost {
    hidden: no
    group_label: "Item Prices and Cost"
    label: "Unit Cost (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_list_price {
    hidden: no
    group_label: "Item Prices and Cost"
    label: "Unit List Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_selling_price {
    hidden: no
    group_label: "Item Prices and Cost"
    label: "Unit Selling Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_cost_target_currency {
    hidden: no
    group_label: "Item Prices and Cost"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Unit Cost for the gross margin analysis converted to target currency"
    sql: ${unit_cost} * ${sales_orders.currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: unit_list_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Cost"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "List price for the item converted to target currency"
    sql: ${unit_list_price} * ${sales_orders.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: unit_selling_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Cost"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Actual price charged to customer converted to target currency"
    sql: ${unit_selling_price} * ${sales_orders.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: unit_discount_amount_target_currency {
    hidden: no
    group_label: "Item Prices and Cost"
    description: "Pre-tax unit list price minus pre-tax unit selling price. Reported in target currency"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${unit_list_price_target_currency} - ${unit_selling_price_target_currency} ;;
    value_format_name: decimal_2
  }


#} end item prices and cost

#########################################################
# DIMENSIONS: Amounts
#{
# amounts hidden as measures are shown instead
# other field properties for _target_currency extended from sales_orders_common_amount_fields_ext

  dimension: ordered_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Ordered Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: booking_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Booking Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: backlog_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Backlog Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Fulfilled Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: shipped_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Shipped Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: invoiced_amount {
    hidden: yes
    group_label: "Amounts"
    label: "Billed Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: ordered_amount_target_currency {
    sql: ${ordered_amount} * ${sales_orders.currency_conversion_rate}  ;;
  }

  dimension: booking_amount_target_currency {
    sql: ${booking_amount} * ${sales_orders.currency_conversion_rate}  ;;
  }

  dimension: backlog_amount_target_currency {
    sql: ${backlog_amount} * ${sales_orders.currency_conversion_rate}  ;;
  }

  dimension: fulfilled_amount_target_currency {
    sql: ${fulfilled_amount} * ${sales_orders.currency_conversion_rate}  ;;
  }

  dimension: shipped_amount_target_currency {
    sql: ${shipped_amount} * ${sales_orders.currency_conversion_rate} ;;
  }

  dimension: invoiced_amount_target_currency {
    sql: ${invoiced_amount} * ${sales_orders.currency_conversion_rate}  ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amount measures
#{

  measure: count_order_lines {
    hidden: no
    type: count
    label: "Order Lines Count"
    description: "Distinct count of order lines"
    drill_fields: [order_line_details*]
  }

  measure: total_ordered_quantity_by_item {
    hidden: no
    type: sum
    label: "Total Ordered Quantity by Item"
    description: "Sum of order quantity by item. Item ID, Part Number or Description must be included as dimension in query to avoid summing across multiple Unit of Measures. If item is not included, a warning message is returned"
    sql: @{is_item_selected}${ordered_quantity}{%- else -%}NULL {%- endif -%} ;;
    html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
    value_format_name: decimal_0
  }

  measure: total_ordered_quantity_by_item_formatted {
    hidden: yes
    type: number
    label: "Total Ordered Quantity by Item Formatted"
    description: "Sum of order quantity by item formatted as large number. Item ID, Part Number or Description must be included as dimension in query to avoid summing across multiple Unit of Measures. If item is not included, a warning message is returned"
    sql: ${total_ordered_quantity_by_item} ;;
    html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
    value_format_name: format_large_numbers_d1
  }

  measure: total_fulfilled_quantity_by_item {
    hidden: no
    type: sum
    label: "Total Fulfilled Quantity by Item"
    description: "Sum of fulfilled quantity by item. Item ID, Part Number or Description must be included as dimension in query to avoid summing across multiple Unit of Measures. If item is not included, a warning message is returned"
    sql: @{is_item_selected}${fulfilled_quantity}{%- else -%}NULL {%- endif -%} ;;
    html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
    value_format_name: decimal_0
  }

  measure: total_fulfilled_quantity_by_item_formatted {
    hidden: yes
    type: number
    label: "Total Fulfilled Quantity by Item Formatted"
    description: "Sum of fulfilled quantity by item formatted as large number. Item ID, Part Number or Description must be included as dimension in query to avoid summing across multiple Unit of Measures. If item is not included, a warning message is returned"
    sql: ${total_fulfilled_quantity_by_item} ;;
    html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
    value_format_name: format_large_numbers_d1
  }

  measure: difference_ordered_fulfilled_quantity_by_item {
    hidden: no
    type: number
    label: "Difference between Ordered and Fulfilled Quantity by Item"
    description: "Ordered minus fulfilled quantity by item. Item ID, Part Number or Description must be included as dimension in query to avoid summing across multiple Unit of Measures. If item is not included, a warning message is returned"
    sql: ${total_ordered_quantity_by_item} - ${total_fulfilled_quantity_by_item} ;;
    value_format_name: decimal_0
    html:  @{is_item_selected}{{rendered_value}}{%- else -%}Add item to query as a dimension.{%- endif -%};;
#--> returns a table listing order lines sorted in descending order by difference between ordered and fulfilled quantity, ordered amount and ordered date
    link: {
      label: "Show Order Line Details"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign header_drill = 'sales_orders.order_number, sales_orders.ordered_date' %}
      {% assign line_drill = 'sales_orders__lines.line_id, sales_orders__lines.line_number, sales_orders__lines.line_status, sales_orders__lines.item_part_number, sales_orders__lines.item_description, sales_orders__lines.ordered_quantity, sales_orders__lines.ordered_amount_target_currency' %}
      {% assign cycle_drill = 'sales_orders__lines.fulfilled_quantity, sales_orders__lines.difference_ordered_fulfilled_quantity, sales_orders__lines.fulfilled_amount_target_currency, sales_orders__lines.fulfillment_date,sales_orders__lines.cycle_time_days' %}
      {% assign drill_fields = header_drill | append: ',' | append: line_drill | append: ',' | append: cycle_drill %}
      {% assign default_filters = 'sales_orders__lines.is_cancelled=No' %}
      {% assign sorts = 'sales_orders__lines.difference_ordered_fulfilled_quantity+desc,sales_orders__lines.ordered_amount_target_currency+desc,sales_orders.ordered_date+desc' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
  }

  measure: count_inventory_item {
    type: count_distinct
    description: "Distinct Count of Inventory Item ID"
    sql: ${inventory_item_id} ;;
  }

  measure: average_fulfillment_days_after_promise_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and promised delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date"
    sql: ${fulfillment_days_after_promise_date} ;;
    value_format_name: decimal_2
  }

  measure: average_fulfillment_days_after_request_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and requested delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date. "
    sql: ${fulfillment_days_after_request_date} ;;
    value_format_name: decimal_2
  }

  measure: average_cycle_time_days {
    hidden: no
    type: average
    description: "Average number of days from order to fulfillment per order line. Item Category or ID must be in query or computation will return null"
    sql: @{is_item_or_category_selected}${cycle_time_days}{%- else -%}NULL{%- endif -%};;
    value_format_name: decimal_2
    filters: [is_cancelled: "No", is_fulfilled: "Yes"]
#--> returns a table listing fulfilled order lines sorted in descending order by cycle_time_days
    link: {
      label: "Show Fulfillment Details"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign header_drill = 'sales_orders.order_number, sales_orders.ordered_date' %}
      {% assign line_drill = 'sales_orders__lines.line_id, sales_orders__lines.line_number, sales_orders__lines.line_status, sales_orders__lines.item_part_number, sales_orders__lines.item_description, sales_orders__lines.ordered_quantity, sales_orders__lines.ordered_amount_target_currency' %}
      {% assign cycle_drill = 'sales_orders__lines.fulfilled_quantity, sales_orders__lines.difference_ordered_fulfilled_quantity, sales_orders__lines.fulfilled_amount_target_currency, sales_orders__lines.fulfillment_date,sales_orders__lines.cycle_time_days' %}
      {% assign drill_fields = header_drill | append: ',' | append: line_drill | append: ',' | append: cycle_drill %}
      {% assign default_filters = 'sales_orders__lines.is_cancelled=No, sales_orders__lines.is_fulfilled=Yes' %}
      {% assign sorts = 'sales_orders__lines.cycle_time_days+desc' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
  }

#} end non-amount measures

#########################################################
# MEASURES: Amounts in Source Currency
#{

  measure: total_ordered_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Ordered Amount in Source Currency"
    description: "Sum of ordered amount in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${ordered_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_sales_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Sales Amount in Source Currency"
    description: "Sum of ordered amount where line_category_code = 'ORDER' in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${ordered_amount}{%- else -%}NULL{%- endif -%} ;;
    filters: [line_category_code: "ORDER"]
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_booking_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Booking Amount in Source Currency"
    description: "Sum of booking amounts in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${booking_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_backlog_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Backlog Amount in Source Currency"
    description: "Sum of backlog amounts in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${backlog_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_fulfilled_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Fulfilled Amount in Source Currency"
    description: "Sum of fulfilled amounts in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${fulfilled_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_shipped_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Shipped Amount in Source Currency"
    description: "Sum of shipped amounts in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: {%- if sales_orders.currency_code._is_selected -%}${shipped_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_invoiced_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Billed Amount in Source Currency"
    description: "Sum of invoiced amounts in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned"
    sql: ${invoiced_amount} ;;
    value_format_name: decimal_2
    html: {%- if sales_orders.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

#} end amounts source currency

#########################################################
# MEASURES: Amounts in Target Currency
#{
# updates to measures extended from sales_orders_common_amount_fields_ext
# and/or new measures

  measure: average_ordered_amount_per_order_target_currency {
    hidden: no
    type: number
    #labels & description defined in sales_orders_common_amount_fields_ext
    sql: SAFE_DIVIDE(${total_ordered_amount_target_currency},${sales_orders.non_cancelled_order_count})  ;;
    # value_format defined in sales_orders_common_amount_fields_ext
  }

  measure: total_backordered_amount_target_currency {
    type: sum
    sql: ${ordered_amount_target_currency} ;;
    filters: [is_backordered: "Yes"]
  }

  measure: total_backordered_amount_target_currency_formatted {
    type: number
    sql: ${total_backordered_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
#--> returns table of 50 items including category sorted in descending order by total backordered amount
    link: {
      label: "Show Top 50 Items with Highest Amount on Backorder"
      url: "
          @{link_build_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign drill_fields = 'sales_orders__lines.item_part_number, sales_orders__lines.item_description, sales_orders__lines.category_description, sales_orders__lines.total_backordered_amount_target_currency' %}
          {% assign limit = 50 %}
          {% assign default_filters = 'sales_orders__lines.line_category_code=ORDER,sales_orders__lines.is_backordered=Yes' %}
          @{link_vis_table}
          @{link_build_explore_url}
      "
    }
  }

#} end amounts target currency

#########################################################
# SETS
#{

  set: order_line_details {
    fields: [sales_orders.order_number, sales_orders.ordered_date, line_id, line_number, line_status, item_part_number, sales_orders__lines.item_description, ordered_quantity, ordered_amount_target_currency]
  }

#}


}
