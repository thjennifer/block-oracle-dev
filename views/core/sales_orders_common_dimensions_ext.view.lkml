view: sales_orders_common_dimensions_ext {
  extension: required



#########################################################
# Customer Dimensions
#{

  parameter: parameter_customer_type {
    hidden: no
    type: unquoted
    view_label: "@{view_label_for_filters}"
    label: "Customer Type"
    description: "Select customer type to use for Customer Name and Country to display and filter by."
    allowed_value: {label: "Bill To" value: "bill" }
    allowed_value: {label: "Sold To" value: "sold" }
    allowed_value: {label: "Ship To" value: "ship" }
    default_value: "bill"
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
  }
  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CAST(${bill_to_customer_number} AS STRING)) ;;
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

  dimension: selected_customer_number {
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
    {% assign cust = parameter_customer_type._parameter_value %}
    {% if cust == 'bill' %}Bill To
    {% elsif cust == 'sold' %}Sold To
    {% elsif cust == 'ship' %}Ship To
    {% endif %}Customer Number
    {%else%}Selected Customer Number{%endif%}"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_number}
        {% elsif cust == 'sold' %}${sold_to_customer_number}
        {% elsif cust == 'ship' %}${ship_to_customer_number}
        {% endif %}
        ;;
  }

  dimension: selected_customer_name {
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
    {% assign cust = parameter_customer_type._parameter_value %}
    {% if cust == 'bill' %}Bill To
    {% elsif cust == 'sold' %}Sold To
    {% elsif cust == 'ship' %}Ship To
    {% endif %}Customer
    {%else%}Selected Customer Name{%endif%}"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_name}
        {% elsif cust == 'sold' %}${sold_to_customer_name}
        {% elsif cust == 'ship' %}${ship_to_customer_name}
        {% endif %}
        ;;
  }

  dimension: selected_customer_country {
    group_label: "Selected Customer Type"
    label: "{% if _field._is_selected %}
    {% assign cust = parameter_customer_type._parameter_value %}
    {% if cust == 'bill' %}Bill To
    {% elsif cust == 'sold' %}Sold To
    {% elsif cust == 'ship' %}Ship To
    {% endif %}Country
    {%else%}Selected Customer Country{%endif%}"
    sql:{% assign cust = parameter_customer_type._parameter_value %}
        {% if cust == 'bill' %}${bill_to_customer_country}
        {% elsif cust == 'sold' %}${sold_to_customer_country}
        {% elsif cust == 'ship' %}${ship_to_customer_country}
        {% endif %}
        ;;
  }

  dimension: selected_customer_type {
    group_label: "Selected Customer Type"
    sql:  {% assign cust = parameter_customer_type._parameter_value %}
      '{{cust}}';;
  }

#} end customer dimensions

 }
