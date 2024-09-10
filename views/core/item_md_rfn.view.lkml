#########################################################{
# PURPOSE
# Provides Item IDs and attributes including multiple
# category sets and languages
#
# SOURCES
# Refines View item_md
#
# REFERENCED BY
# Explore item_md
#
# REPEATED STRUCTS
#   - Includes Repeated Struct for ITEM_DESCRIPTIONS as
#     an item may have multiple descriptions in different languages.
#   - Includes Repeated Struct for ITEM_CATEGORIES as
#     an item may be part of one or more category sets
#   - These defined in separate views to allow UNNESTING:
#       item_md__item_descriptions
#       item_md__item_categories
#
# NOTE
#   - Select dimensions are edited for labels and/or value formats
#   - Full set of fields available can be found in base view
#       /views/base/item_md.view
#########################################################}

include: "/views/base/item_md.view"

view: +item_md {

  label: "Item MD"

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${inventory_item_id},${organization_id}) ;;
  }

  dimension: base_item_id {value_format_name: id}

  dimension: bom_item_type {
    label: "BOM Item Type"
  }

  dimension: eam_item_type {
    label: "EAM Item Type"
  }

  dimension: inventory_item_id {value_format_name: id}

  dimension: item_catalog_group_id {value_format_name: id}

  dimension: list_price_per_unit {value_format_name: decimal_2}

  dimension: market_price {value_format_name: decimal_2}

  dimension: organization_id {value_format_name: id}

  dimension: price_tolerance_percent {value_format_name: decimal_2}

  dimension: primary_uom_code {
    label: "Primary UoM Code"
  }

  dimension: qty_rcv_exception_code {
    label: "Quantity Received Exception Code"
  }

  dimension: qty_rcv_tolerance {
    label: "Quantity Received Tolerance"
  }

  dimension: sales_account {value_format_name: id}

  dimension: un_number_id {
    label: "UN Number ID"
    value_format_name: id
  }

  dimension: unit_volume {value_format_name: decimal_2}

  dimension: unit_weight {value_format_name: decimal_2}

  dimension: volume_uom_code {
    label: "Volume UoM Code"
  }

  dimension: weight_uom_code {
    label: "Weight UoM Code"
  }

  measure: count {
    label: "Item Count"
  }




 }
