include: "/views/base/sales_invoices__lines__item_descriptions.view"

view: +sales_invoices__lines__item_descriptions {

  fields_hidden_by_default: yes

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${sales_invoices__lines.inventory_item_id},${sales_invoices__lines.item_part_number},${language}) ;;
  }

  dimension: item_description {
    hidden: no
    type: string
    sql: COALESCE(${TABLE}.TEXT,CONCAT("Inventory Item ID: ",CAST(${sales_invoices__lines.inventory_item_id} AS STRING))) ;;
    full_suggestions: yes
  }

  dimension: language {
    hidden: no
    type: string
    label: "Item Description Language"
    sql: COALESCE(${TABLE}.LANGUAGE,"Unknown") ;;
    full_suggestions: yes
  }

  measure: count_distinct_description {
    hidden: no
    type: count_distinct
    view_label: "TEST STUFF"
    sql: ${item_description} ;;
  }


   }
