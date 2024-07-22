
view: item_md {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.ItemMD` ;;

  dimension: allowed_units_lookup_code {
    type: number
    sql: ${TABLE}.ALLOWED_UNITS_LOOKUP_CODE ;;
  }
  dimension: approval_status {
    type: string
    sql: ${TABLE}.APPROVAL_STATUS ;;
  }
  dimension: attribute1 {
    type: string
    sql: ${TABLE}.ATTRIBUTE1 ;;
  }
  dimension: attribute2 {
    type: string
    sql: ${TABLE}.ATTRIBUTE2 ;;
  }
  dimension: attribute3 {
    type: string
    sql: ${TABLE}.ATTRIBUTE3 ;;
  }
  dimension: attribute4 {
    type: string
    sql: ${TABLE}.ATTRIBUTE4 ;;
  }
  dimension: attribute_category {
    type: string
    sql: ${TABLE}.ATTRIBUTE_CATEGORY ;;
  }
  dimension: base_item_id {
    type: number
    sql: ${TABLE}.BASE_ITEM_ID ;;
  }
  dimension: bom_item_type {
    type: number
    sql: ${TABLE}.BOM_ITEM_TYPE ;;
  }
  dimension: cost_of_sales_account {
    type: number
    sql: ${TABLE}.COST_OF_SALES_ACCOUNT ;;
  }
  dimension: eam_item_type {
    type: number
    sql: ${TABLE}.EAM_ITEM_TYPE ;;
  }
  dimension: fixed_order_quantity {
    type: number
    sql: ${TABLE}.FIXED_ORDER_QUANTITY ;;
  }
  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.INVENTORY_ITEM_ID ;;
  }
  dimension: inventory_item_status_code {
    type: string
    sql: ${TABLE}.INVENTORY_ITEM_STATUS_CODE ;;
  }
  dimension: is_customer_order_enabled {
    type: yesno
    sql: ${TABLE}.IS_CUSTOMER_ORDER_ENABLED ;;
  }
  dimension: is_enabled {
    type: yesno
    sql: ${TABLE}.IS_ENABLED ;;
  }
  dimension: is_purchasing_enabled {
    type: yesno
    sql: ${TABLE}.IS_PURCHASING_ENABLED ;;
  }
  dimension: is_summary {
    type: yesno
    sql: ${TABLE}.IS_SUMMARY ;;
  }
  dimension: item_catalog_group_id {
    type: number
    sql: ${TABLE}.ITEM_CATALOG_GROUP_ID ;;
  }
  dimension: item_categories {
    hidden: yes
    sql: ${TABLE}.ITEM_CATEGORIES ;;
  }
  dimension: item_descriptions {
    hidden: yes
    sql: ${TABLE}.ITEM_DESCRIPTIONS ;;
  }
  dimension: item_part_number {
    type: string
    sql: ${TABLE}.ITEM_PART_NUMBER ;;
  }
  dimension: item_type {
    type: string
    sql: ${TABLE}.ITEM_TYPE ;;
  }
  dimension: list_price_per_unit {
    type: number
    sql: ${TABLE}.LIST_PRICE_PER_UNIT ;;
  }
  dimension: market_price {
    type: number
    sql: ${TABLE}.MARKET_PRICE ;;
  }
  dimension: maximum_order_quantity {
    type: number
    sql: ${TABLE}.MAXIMUM_ORDER_QUANTITY ;;
  }
  dimension: minimum_order_quantity {
    type: number
    sql: ${TABLE}.MINIMUM_ORDER_QUANTITY ;;
  }
  dimension: organization_id {
    type: number
    sql: ${TABLE}.ORGANIZATION_ID ;;
  }
  dimension: price_tolerance_percent {
    type: number
    sql: ${TABLE}.PRICE_TOLERANCE_PERCENT ;;
  }
  dimension: primary_unit_of_measure {
    type: string
    sql: ${TABLE}.PRIMARY_UNIT_OF_MEASURE ;;
  }
  dimension: primary_uom_code {
    type: string
    sql: ${TABLE}.PRIMARY_UOM_CODE ;;
  }
  dimension: qty_rcv_exception_code {
    type: string
    sql: ${TABLE}.QTY_RCV_EXCEPTION_CODE ;;
  }
  dimension: qty_rcv_tolerance {
    type: number
    sql: ${TABLE}.QTY_RCV_TOLERANCE ;;
  }
  dimension: revision_qty_control_code {
    type: number
    sql: ${TABLE}.REVISION_QTY_CONTROL_CODE ;;
  }
  dimension: rounding_factor {
    type: number
    sql: ${TABLE}.ROUNDING_FACTOR ;;
  }
  dimension: sales_account {
    type: number
    sql: ${TABLE}.SALES_ACCOUNT ;;
  }
  dimension: segment2 {
    type: string
    sql: ${TABLE}.SEGMENT2 ;;
  }
  dimension: segment3 {
    type: string
    sql: ${TABLE}.SEGMENT3 ;;
  }
  dimension: segment4 {
    type: string
    sql: ${TABLE}.SEGMENT4 ;;
  }
  dimension: std_lot_size {
    type: number
    sql: ${TABLE}.STD_LOT_SIZE ;;
  }
  dimension: un_number_id {
    type: number
    sql: ${TABLE}.UN_NUMBER_ID ;;
  }
  dimension: unit_volume {
    type: number
    sql: ${TABLE}.UNIT_VOLUME ;;
  }
  dimension: unit_weight {
    type: number
    sql: ${TABLE}.UNIT_WEIGHT ;;
  }
  dimension: volume_uom_code {
    type: string
    sql: ${TABLE}.VOLUME_UOM_CODE ;;
  }
  dimension: weight_uom_code {
    type: string
    sql: ${TABLE}.WEIGHT_UOM_CODE ;;
  }
  measure: count {
    type: count
  }
}

# view: item_md__item_categories {
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ID ;;
#   }
#   dimension: category_name {
#     type: string
#     sql: CATEGORY_NAME ;;
#   }
#   dimension: category_set_id {
#     type: number
#     sql: CATEGORY_SET_ID ;;
#   }
#   dimension: category_set_name {
#     type: string
#     sql: CATEGORY_SET_NAME ;;
#   }
#   dimension: description {
#     type: string
#     sql: DESCRIPTION ;;
#   }
#   dimension: item_md__item_categories {
#     type: string
#     hidden: yes
#     sql: item_md__item_categories ;;
#   }
# }

# view: item_md__item_descriptions {

#   dimension: item_md__item_descriptions {
#     type: string
#     hidden: yes
#     sql: item_md__item_descriptions ;;
#   }
#   dimension: language {
#     type: string
#     sql: LANGUAGE ;;
#   }
#   dimension: text {
#     type: string
#     sql: TEXT ;;
#   }
# }
