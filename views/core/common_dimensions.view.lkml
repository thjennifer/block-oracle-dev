view: common_dimensions {
  extension: required

#########################################################
# Business Unit and Order Source Dimensions
#{

  dimension: business_unit_id {hidden: no}
  dimension: business_unit_name {hidden: no}
  dimension: order_source_id {hidden:no}
  dimension: order_source_name {hidden:no}
#} end business unit and order source dimensions

#########################################################
# Customer Dimensions
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
  }
  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
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
  }
  dimension: ship_to_site_use_id {
    hidden: no
    group_label: "Ship to Customer"
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
  }
  dimension: sold_to_site_use_id {
    hidden: no
    group_label: "Sold to Customer"
  }

#} end customer dimensions

 }
