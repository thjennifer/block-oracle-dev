include: "/views/base/item_md.view"

view: +item_md {

  label: "Item MD"

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${inventory_item_id},${organization_id}) ;;
  }



 }
