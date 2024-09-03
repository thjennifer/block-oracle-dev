#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions
# for customer-related dimensions used in both
# sales_orders and sales_orders_daily_agg
#
# To use, extend into the desired view.
#
# Defines labels/descriptions for:
#   bill_to_customer_country
#   bill_to_customer_name
#   bill_to_customer_number
#   bill_to_site_use_id
#   ship_to_customer_country
#   ship_to_customer_name
#   ship_to_customer_number
#   ship_to_site_use_id
#   sold_to_customer_country
#   sold_to_customer_name
#   sold_to_customer_number
#   sold_to_site_use_id
#
# Fully defines these parameters & dimensions including sql: property:
#   parameter_customer_type
#   selected_customer_number
#   selected_customer_country
#   selected_customer_type
#########################################################}


view: sales_orders_common_dimensions_ext {
  extension: required

#########################################################
# Label Existing Customer Dimensions
#{
  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
  }
  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
  }
  dimension: bill_to_customer_number {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }
  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }
  dimension: ship_to_customer_country {
    hidden: no
    group_label: "Ship to Customer"
  }
  dimension: ship_to_customer_name {
    hidden: no
    group_label: "Ship to Customer"
  }
  dimension: ship_to_customer_number {
    hidden: no
    group_label: "Ship to Customer"
    value_format_name: id
  }
  dimension: ship_to_site_use_id {
    hidden: no
    group_label: "Ship to Customer"
    value_format_name: id
  }
  dimension: sold_to_customer_country {
    hidden: no
    group_label: "Sold to Customer"
  }
  dimension: sold_to_customer_name {
    hidden: no
    group_label: "Sold to Customer"
  }
  dimension: sold_to_customer_number {
    hidden: no
    group_label: "Sold to Customer"
    value_format_name: id
  }
  dimension: sold_to_site_use_id {
    hidden: no
    group_label: "Sold to Customer"
    value_format_name: id
  }

  #} end label existing dimensions

#########################################################
# New Customer Parameter & Dimensions
#{

  parameter: parameter_customer_type {
    hidden: no
    type: unquoted
    view_label: "@{label_view_for_filters}"
    label: "Customer Type"
    description: "Select customer type to use for Customer Name and Country to display and filter by"
    allowed_value: {label: "Bill To" value: "bill" }
    allowed_value: {label: "Sold To" value: "sold" }
    allowed_value: {label: "Ship To" value: "ship" }
    default_value: "bill"
  }



  dimension: selected_customer_number {
    hidden: no
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
    {% assign cust = parameter_customer_type._parameter_value %}
    {% if cust == 'bill' %}Bill To
    {% elsif cust == 'sold' %}Sold To
    {% elsif cust == 'ship' %}Ship To
    {% endif %}Customer Number
    {%else%}Selected Customer Number{%endif%}"
    description: "Customer number reflecting selected customer type"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_number}
        {% elsif cust == 'sold' %}${sold_to_customer_number}
        {% elsif cust == 'ship' %}${ship_to_customer_number}
        {% endif %}
        ;;
  }

  dimension: selected_customer_name {
    hidden: no
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
            {% assign cust = parameter_customer_type._parameter_value %}
            {% if cust == 'bill' %}Bill To
              {% elsif cust == 'sold' %}Sold To
              {% elsif cust == 'ship' %}Ship To
            {% endif %}Customer
            {%else%}Selected Customer Name{%endif%}"
    description: "Customer name reflecting selected customer type"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_name}
          {% elsif cust == 'sold' %}${sold_to_customer_name}
          {% elsif cust == 'ship' %}${ship_to_customer_name}
        {% endif %}
        ;;
  }

  dimension: selected_customer_country {
    hidden: no
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
    {% assign cust = parameter_customer_type._parameter_value %}
    {% if cust == 'bill' %}Bill To
    {% elsif cust == 'sold' %}Sold To
    {% elsif cust == 'ship' %}Ship To
    {% endif %}Country
    {%else%}Selected Customer Country{%endif%}"
    description: "Customer country reflecting selected customer type"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_country}
        {% elsif cust == 'sold' %}${sold_to_customer_country}
        {% elsif cust == 'ship' %}${ship_to_customer_country}
        {% endif %}
        ;;
  }

  dimension: selected_customer_type {
    hidden: no
    group_label: "Selected Customer Type"
    description: "Customer type selected with parameter Customer Type"
    sql:  {% assign cust = parameter_customer_type._parameter_value %}
      '{{cust | capitalize | append: " To"}}';;
  }

#} end new customer dimensions



 }
