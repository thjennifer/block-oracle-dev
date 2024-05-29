view: common_dimensions {
  extension: required



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
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CAST(${bill_to_customer_number} AS STRING)) ;;
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
