## when column is duplicate of another in header (like is_open) then restate sql using ${TABLE}. reference
include: "/views/base/sales_orders__lines.view"
include: "/views/core/sales_orders__lines_common_fields_ext.view"
include: "/views/core/otc_derive_common_product_fields_ext.view"
# include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_orders__lines {

  fields_hidden_by_default: yes
  extends: [sales_orders__lines_common_fields_ext,otc_derive_common_product_fields_ext]
  # extends: [sales_orders__lines_common_fields_ext,otc_unnest_item_categories_common_fields_ext]
  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    sql: COALESCE(${TABLE}.LINE_ID,-1) ;;
  }

  dimension: line_number {
    hidden: no
  }

  dimension: return_line_ids {
    primary_key: no
  }


#########################################################
# Parameters
# parameter_language to select the display language for item descriptions
# parameter_category_set_name to select category set to use for item categories
# parameter_target_currency to choose the desired currency into which the order currency should be converted
#{

  # parameter: parameter_language {
  #   hidden: no
  #   type: string
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Language"
  #   description: "Select language to display for item descriptions. Default is 'US'."
  #   suggest_explore: item_md
  #   suggest_dimension: item_md__item_descriptions.language
  #   default_value: "US"
  # }

  # parameter: parameter_category_set_name {
  #   hidden: no
  #   type: string
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Category Set Name"
  #   suggest_explore: item_md
  #   suggest_dimension: item_md__item_categories.category_set_name
  #   default_value: "Purchasing"
  # }

  parameter: parameter_display_product_level {
    hidden: no
    type: unquoted
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Display Categories or Items"
    description: "Select whether to display categories or items in report. Use with dimensions Selected Product Dimension ID and Selected Product Dimension Description."
    allowed_value: {label: "Category" value: "Category"}
    allowed_value: {label: "Item" value: "Item"}
    default_value: "Category"
  }

#} end parameters

#########################################################
# Item dimensions
#{

  dimension: inventory_item_id {
    hidden: no
    value_format_name: id
  }

  dimension: item_part_number {
    hidden: no
    value_format_name: id
  }

  dimension: item_organization_id {
    hidden:no
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
  }

  # dimension: item_description {
  #   hidden: no
  #   group_label: "Item Categories & Descriptions"
  #   sql: COALESCE((SELECT d.TEXT FROM UNNEST(${item_descriptions}) AS d WHERE d.language = {% parameter sales_orders__lines.parameter_language %} ), CAST(${inventory_item_id} AS STRING)) ;;
  #   full_suggestions: yes
  # }

  # dimension: item_description_language {
  #   hidden: no
  #   group_label: "Item Categories & Descriptions"
  #   sql: (SELECT d.LANGUAGE FROM UNNEST(${item_descriptions}) AS d WHERE d.LANGUAGE = {% parameter sales_orders__lines.parameter_language %} ) ;;
  #   full_suggestions: yes
  # }

  # dimension: category_id {
  #   hidden: no
  #   type: number
  #   group_label: "Item Categories & Descriptions"
  #   label: "Item Category ID"
  #   sql: COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}'), -1 ) ;;
  #   # sql: COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter otc_common_parameters_xvw.parameter_category_set_name %}), -1 ) ;;
  #   full_suggestions: yes
  #   value_format_name: id
  # }

  # dimension: category_description {
  #   hidden: no
  #   group_label: "Item Categories & Descriptions"
  #   label: "Item Category Description"
  #   sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}' )
  #       ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
  #   # sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter otc_common_parameters_xvw.parameter_category_set_name %} )
  #   # ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
  #   full_suggestions: yes
  # }

  # dimension: category_name {
  #   hidden: no
  #   group_label: "Item Categories & Descriptions"
  #   label: "Item Category Name Group"
  #   sql: COALESCE((SELECT c.CATEGORY_NAME FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}'),"Unknown" ) ;;
  #   # sql: COALESCE((SELECT c.category_name FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter otc_common_parameters_xvw.parameter_category_set_name %}),"Unknown" ) ;;
  #   full_suggestions: yes
  # }

  dimension: selected_product_dimension_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
                {% if parameter_display_product_level._parameter_value == 'Item' %}Item{%else%}Category{%endif%}
            {%else%}Selected Product Dimenstion Description{%endif%}"
    description: "Values are either Item Description or Item Category Description based on user selection for Parameter Display Categories or Items."
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${item_description}{%else%}${category_description}{%endif%} ;;
    can_filter: no
  }

  dimension: selected_product_dimension_id {
    hidden: no
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
    {% if parameter_display_product_level._parameter_value == 'Item' %}Inventory Item ID{%else%}Category ID{%endif%}
    {%else%}Selected Product Dimenstion ID{%endif%}"
    description: "Values are either Item Inventory ID or Item Category ID based on user selection for Parameter Display Categories or Items."
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${inventory_item_id}{%else%}${category_id}{%endif%} ;;
    can_filter: no
  }


#} end item dimensions


#########################################################
# Dates
#{

  dimension_group: fulfillment {
    hidden: no
    timeframes: [raw,date,week,month,quarter,year,yesno]
    sql: ${TABLE}.FULFILLMENT_DATE ;;
  }

  dimension_group: request_date {
    hidden: no
    label: "Request"
    description: "Requested delivery date for the order line."
    timeframes: [raw,date,week,month,quarter,year,yesno]
    sql:${TABLE}.REQUEST_DATE ;;
  }

  dimension_group: promise_date {
    hidden: no
    label: "Promise"
    description: "Promised delivery date."
    timeframes: [raw,date,week,month,quarter,year,yesno]
  }

  dimension_group: actual_ship {
    hidden: no
    description: "Actual ship date of order line."
    timeframes: [raw,date,week,month,quarter,year,yesno]
  }

  dimension_group: schedule_ship {
    hidden: no
    description: "Scheduled ship date of order line."
    timeframes: [raw,date,week,month,quarter,year,yesno]
  }

  dimension_group: creation {
    hidden: no
    timeframes: [raw, date, time]
    description: "Creation date of record in Oracle source table."
  }

  dimension_group: last_update {
    hidden: no
    timeframes: [raw, date, time]
    description: "Last update date of record in Oracle source table."
  }


#} end dates

#########################################################
# Line Status
#{


  dimension: line_status {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: line_category_code {
    hidden: no
  }

  dimension: is_backlog {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is not in ENTERED, BOOKED, CLOSED, OR CANCELLED statuses."
    full_suggestions: yes
  }

  dimension: is_backordered {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line cannot be fulfilled with the current inventory."
    full_suggestions: yes
    sql: ${TABLE}.IS_BACKORDERED ;;
  }

  dimension: is_booked {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is in or past the BOOKED phase."
    full_suggestions: yes
    sql: ${TABLE}.IS_BOOKED ;;
  }

  dimension: is_booking {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is in ENTERED or BOOKED statuses. Unlike IS_BOOKED, this will be No once it passes the booking phase."
    full_suggestions: yes
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_CANCELLED ;;
  }

  dimension: cancel_reason {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

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
    sql: ${TABLE}.HAS_RETURN ;;
  }


  dimension: is_fulfilled {
    hidden: no
    type: yesno
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_FULFILLED ;;
  }

  dimension: is_fulfilled_by_promise_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_promise_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Line Status"
    label: "Is Fulfilled by Promise Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_request_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Line Status"
    label: "Is Fulfilled by Request Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

#} end  line status

#########################################################
# Fulfillment Cycle Days Dimensions
# dimensions hidden and shown in Explore as average measure
#{

# shown in Explore as measure average_days_from_promise_to_fulfillment
  dimension: fulfillment_days_after_promise_date {
    hidden: yes
    label: "Fulfillment Days after Promise Date"
    description: "Number of days between Fulfillment Date and Delivery Promise Date."
  }

# shown in Explore as measure average_days_from_request_to_fulfillment
  dimension: fulfillment_days_after_request_date {
    hidden: yes
    label: "Fulfillment Days after Request Date"
    description: "Number of days between Fulfillment Date and Delivery Request Date."
  }

# shown in Explore as measure average_cycle_time_days
  dimension: cycle_time_days {
    hidden: yes
    description: "Number of Days between Ordered Date and Fulfillment Date"
  }

#} end fulfillment cycle days dimensions


#########################################################
# Item quantities and weights as dimensions
#{
  dimension: quantity_uom {
    hidden: no
    group_label: "Quantities"
    label: "Quantity UoM"
    description: "Unit of Measure for the Line Quantity"
    sql: UPPER(${TABLE}.QUANTITY_UOM) ;;
  }

  dimension: ordered_quantity {
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
    # required_fields: [item_part_number]
  }

  dimension: weight_uom {
    hidden: no
    group_label: "Weights"
    label: "Weight UoM"
    description: "Unit of Measure for the Line Weight"
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
# Item prices and cost
#{



  dimension: unit_cost {
    hidden: no
    value_format_name: decimal_2
  }

  dimension: unit_list_price {
    hidden: no
    value_format_name: decimal_2
  }

  dimension: unit_selling_price {
    hidden: no
    value_format_name: decimal_2
  }

#} end item prices and cost

#########################################################
# Amounts as dimensions including Currency Conversions
#{
  dimension: ordered_amount {
    hidden: no
    group_label: "Amounts"
    label: "Ordered Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: shipped_amount {
    hidden: no
    group_label: "Amounts"
    label: "Shipped Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: currency_source {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the order header."
    sql: ${sales_orders.currency_code} ;;
  }

  dimension: currency_target {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Amounts"
    sql: IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: ${sales_orders.currency_code} <> {% parameter otc_common_parameters_xvw.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Ordered Amount ({{currency}}){%else%}Ordered Amount (Target Currency){%endif%}"
    sql: ${ordered_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Shipped Amount ({{currency}}){%else%}Shipped Amount (Target Currency){%endif%}"
    sql: ${shipped_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

  measure: count_order_lines {
    hidden: no
    type: count
    drill_fields: [order_line_details*]
  }

  measure: total_sales_amount_by_source_currency {
    hidden: no
    type: sum
    description: "Sum of sales for order lines in source currency. Currency Code is required field to avoid summing across multiple currencies."
    required_fields: [sales_orders.currency_code]

    sql: ${ordered_amount} ;;
    value_format_name: decimal_0
  }

  measure: total_ordered_quantity_by_item {
    hidden: no
    type: sum
    description: "Sum of order quantity by item. Inventory Item ID is required field to avoid summing across multiple Unit of Measures."
    sql: ${ordered_quantity} ;;
    required_fields: [inventory_item_id]
    value_format_name: format_large_numbers_d1
  }

  measure: total_fulfilled_quantity_by_item {
    hidden: no
    type: sum
    description: "Sum of fulfilled quantity by item. Inventory Item ID is required field to avoid summing across multiple Unit of Measures."
    sql: ${fulfilled_quantity} ;;
    required_fields: [inventory_item_id]
    value_format_name: format_large_numbers_d1
  }

  measure: difference_ordered_fulfilled_quantity_by_item {
    hidden: no
    type: number
    description: "Ordered minus fulfilled quantity by item. Inventory Item ID is required field to avoid reporting quantitites across multiple Unit of Measures."
    sql: ${total_ordered_quantity_by_item} - ${total_fulfilled_quantity_by_item} ;;
    required_fields: [inventory_item_id]
    value_format_name: decimal_0
  }

  measure: count_inventory_item {
    type: count_distinct
    description: "Distinct Count of Inventory Item ID"
    sql: ${inventory_item_id} ;;
  }



  measure: average_fulfillment_days_after_promise_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and promised delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date."
    sql: ${fulfillment_days_after_promise_date} ;;
  }

  measure: average_fulfillment_days_after_request_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and requested delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date. "
    sql: ${fulfillment_days_after_request_date} ;;
  }

  measure: average_cycle_time_days {
    hidden: no
    type: average
    description: "Average number of days from order to fulfillment per order line. Item Category or ID must be in query or compution will return null."
    sql: {% if inventory_item_id._is_selected or item_part_number._is_selected or item_description._is_selected or category_id._is_selected or category_description._is_selected or selected_product_dimension_id._is_selected or selected_product_dimension_description._is_selected%}${cycle_time_days}{% else %}null{%endif%};;
    value_format_name: decimal_2
    filters: [is_cancelled: "No"]
    # required_fields: [category_description]
  }

#########################################################
# Amounts in Target Currency measures
#{



  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    #label defined in sales_orders__lines_common_fields_ext
    #description defined in sales_orders__lines_common_fields_ext
    sql: ${ordered_amount_target_currency} ;;
    filters: [sales_orders.order_category_code: "-RETURN"]
    # value_format defined in sales_orders__lines_common_fields_ext
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders__lines_common_fields_ext
    #description defined in sales_orders__lines_common_fields_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},${sales_orders.non_cancelled_sales_order_count})  ;;
    # value_format defined in sales_orders__lines_common_fields_ext
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Fulfilled Amount ({{currency}}){%else%}Total Fulfilled Amount (Target Currency){%endif%}"
    sql: ${ordered_amount_target_currency} ;;
    filters: [sales_orders__lines.is_fulfilled: "Yes", sales_orders.order_category_code: "-RETURN"]
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Shipped Amount ({{currency}}){%else%}Total Shipped Amount (Target Currency){%endif%}"
    sql: ${shipped_amount_target_currency} ;;
    filters: [sales_orders.order_category_code: "-RETURN"]
    value_format_name: format_large_numbers_d1
  }

#} end target currency dimensions and measures

  set: order_line_details {
    fields: [sales_orders.header_id, sales_orders.order_number, sales_orders.ordered_date, line_id, line_number, line_status, inventory_item_id, sales_orders__lines__item_descriptions.item_description, ordered_quantity, ordered_amount]
  }






   }
