view: item_md {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.ItemMD` ;;

  dimension: allowed_units_lookup_code {
    type: number
    description: "Allowed unit of measure conversion type"
    sql: ${TABLE}.ALLOWED_UNITS_LOOKUP_CODE ;;
  }
  dimension: approval_status {
    type: string
    description: "Approval status"
    sql: ${TABLE}.APPROVAL_STATUS ;;
  }
  dimension: attribute1 {
    type: string
    description: "Descriptive flexfield segment"
    sql: ${TABLE}.ATTRIBUTE1 ;;
  }
  dimension: attribute2 {
    type: string
    description: "Descriptive flexfield segment"
    sql: ${TABLE}.ATTRIBUTE2 ;;
  }
  dimension: attribute3 {
    type: string
    description: "Descriptive flexfield segment"
    sql: ${TABLE}.ATTRIBUTE3 ;;
  }
  dimension: attribute4 {
    type: string
    description: "Descriptive flexfield segment"
    sql: ${TABLE}.ATTRIBUTE4 ;;
  }
  dimension: attribute_category {
    type: string
    description: "Descriptive flexfield structure defining column"
    sql: ${TABLE}.ATTRIBUTE_CATEGORY ;;
  }
  dimension: base_item_id {
    type: number
    description: "Base item ID"
    sql: ${TABLE}.BASE_ITEM_ID ;;
  }
  dimension: bom_item_type {
    type: number
    description: "Type of item"
    sql: ${TABLE}.BOM_ITEM_TYPE ;;
  }
  dimension: cost_of_sales_account {
    type: number
    description: "Cost of sales account"
    sql: ${TABLE}.COST_OF_SALES_ACCOUNT ;;
  }
  dimension: eam_item_type {
    type: number
    description: "Asset item type"
    sql: ${TABLE}.EAM_ITEM_TYPE ;;
  }
  dimension: fixed_order_quantity {
    type: number
    description: "Fixed order quantity"
    sql: ${TABLE}.FIXED_ORDER_QUANTITY ;;
  }
  dimension: inventory_item_id {
    type: number
    description: "Primary key component identifying an item"
    sql: ${TABLE}.INVENTORY_ITEM_ID ;;
  }
  dimension: inventory_item_status_code {
    type: string
    description: "Material status code"
    sql: ${TABLE}.INVENTORY_ITEM_STATUS_CODE ;;
  }
  dimension: is_customer_order_enabled {
    type: yesno
    description: "Indicates item is customer orderable"
    sql: ${TABLE}.IS_CUSTOMER_ORDER_ENABLED ;;
  }
  dimension: is_enabled {
    type: yesno
    description: "Flexfield segment enabled indicator"
    sql: ${TABLE}.IS_ENABLED ;;
  }
  dimension: is_purchasing_enabled {
    type: yesno
    description: "Indicates item is purchasable"
    sql: ${TABLE}.IS_PURCHASING_ENABLED ;;
  }
  dimension: is_summary {
    type: yesno
    description: "Flexfield summary indicator"
    sql: ${TABLE}.IS_SUMMARY ;;
  }
  dimension: item_catalog_group_id {
    type: number
    description: "Item catalog group ID"
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
    description: "Item part number"
    sql: ${TABLE}.ITEM_PART_NUMBER ;;
  }
  dimension: item_type {
    type: string
    description: "Item type"
    sql: ${TABLE}.ITEM_TYPE ;;
  }
  dimension: list_price_per_unit {
    type: number
    description: "Purchasing unit list price"
    sql: ${TABLE}.LIST_PRICE_PER_UNIT ;;
  }
  dimension: market_price {
    type: number
    description: "Purchasing market price"
    sql: ${TABLE}.MARKET_PRICE ;;
  }
  dimension: maximum_order_quantity {
    type: number
    description: "Maximum order quantity"
    sql: ${TABLE}.MAXIMUM_ORDER_QUANTITY ;;
  }
  dimension: minimum_order_quantity {
    type: number
    description: "Minimum order quantity"
    sql: ${TABLE}.MINIMUM_ORDER_QUANTITY ;;
  }
  dimension: organization_id {
    type: number
    description: "Primary key component identifying an item's organization"
    sql: ${TABLE}.ORGANIZATION_ID ;;
  }
  dimension: price_tolerance_percent {
    type: number
    description: "Purchase price tolerance percentage"
    sql: ${TABLE}.PRICE_TOLERANCE_PERCENT ;;
  }
  dimension: primary_unit_of_measure {
    type: string
    description: "Primary stocking unit of measure for the item"
    sql: ${TABLE}.PRIMARY_UNIT_OF_MEASURE ;;
  }
  dimension: primary_uom_code {
    type: string
    description: "Primary unit of measure code"
    sql: ${TABLE}.PRIMARY_UOM_CODE ;;
  }
  dimension: qty_rcv_exception_code {
    type: string
    description: "Over tolerance receipts processing method code"
    sql: ${TABLE}.QTY_RCV_EXCEPTION_CODE ;;
  }
  dimension: qty_rcv_tolerance {
    type: number
    description: "Maximum acceptable over-receipt percentage"
    sql: ${TABLE}.QTY_RCV_TOLERANCE ;;
  }
  dimension: revision_qty_control_code {
    type: number
    description: "Revision quantity control code"
    sql: ${TABLE}.REVISION_QTY_CONTROL_CODE ;;
  }
  dimension: rounding_factor {
    type: number
    description: "Rounding factor used to determine order quantity"
    sql: ${TABLE}.ROUNDING_FACTOR ;;
  }
  dimension: sales_account {
    type: number
    description: "Sales account"
    sql: ${TABLE}.SALES_ACCOUNT ;;
  }
  dimension: segment2 {
    type: string
    description: "Key flexfield segment"
    sql: ${TABLE}.SEGMENT2 ;;
  }
  dimension: segment3 {
    type: string
    description: "Key flexfield segment"
    sql: ${TABLE}.SEGMENT3 ;;
  }
  dimension: segment4 {
    type: string
    description: "Key flexfield segment"
    sql: ${TABLE}.SEGMENT4 ;;
  }
  dimension: std_lot_size {
    type: number
    description: "Standard lot size"
    sql: ${TABLE}.STD_LOT_SIZE ;;
  }
  dimension: un_number_id {
    type: number
    description: "Purchasing UN (United Nations) number"
    sql: ${TABLE}.UN_NUMBER_ID ;;
  }
  dimension: unit_volume {
    type: number
    description: "Conversion between volume unit of measure and base unit of measure"
    sql: ${TABLE}.UNIT_VOLUME ;;
  }
  dimension: unit_weight {
    type: number
    description: "Conversion between weight unit of measure and base unit of measure"
    sql: ${TABLE}.UNIT_WEIGHT ;;
  }
  dimension: volume_uom_code {
    type: string
    description: "Volume unit of measure code"
    sql: ${TABLE}.VOLUME_UOM_CODE ;;
  }
  dimension: weight_uom_code {
    type: string
    description: "Weight unit of measure code"
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
#     description: "Foreign key identifying item categories"
#     sql: ID ;;
#   }
#   dimension: category_name {
#     type: string
#     description: "Item category name"
#     sql: CATEGORY_NAME ;;
#   }
#   dimension: category_set_id {
#     type: number
#     description: "Foreign key identifying item category sets"
#     sql: CATEGORY_SET_ID ;;
#   }
#   dimension: category_set_name {
#     type: string
#     description: "Item category set name"
#     sql: CATEGORY_SET_NAME ;;
#   }
#   dimension: description {
#     type: string
#     description: "Item category description"
#     sql: DESCRIPTION ;;
#   }
#   dimension: item_md__item_categories {
#     type: string
#     description: "Nested repeated field containing item categories in all enabled category sets"
#     hidden: yes
#     sql: item_md__item_categories ;;
#   }
# }

# view: item_md__item_descriptions {

#   dimension: item_md__item_descriptions {
#     type: string
#     description: "Nested repeated field containing item descriptions in all enabled language translations"
#     hidden: yes
#     sql: item_md__item_descriptions ;;
#   }
#   dimension: language {
#     type: string
#     description: "Language code of the item description"
#     sql: LANGUAGE ;;
#   }
#   dimension: text {
#     type: string
#     description: "Item description text"
#     sql: TEXT ;;
#   }
# }
