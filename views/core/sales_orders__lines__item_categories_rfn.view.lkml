include: "/views/base/sales_orders.view"

view: +sales_orders__lines__item_categories {

  fields_hidden_by_default: no

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${category_set_id},${id}) ;;
  }

  dimension: id {
    primary_key: no
    label: "Category ID"
    sql: COALESCE(${TABLE}.ID,-1) ;;
  }

  dimension: category_name {
    label: "Category Group"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.CATEGORY_NAME,"Unknown") ;;
  }

  dimension: category_set_id {
    full_suggestions: yes
    sql: COALESCE(${TABLE}.CATEGORY_SET_ID,-1) ;;
  }

  dimension: category_set_name {
    full_suggestions: yes
    sql: COALESCE(${TABLE}.CATEGORY_SET_NAME,"Unknown") ;;
  }

  dimension: description {
    label: "Category Description"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.DESCRIPTION,COALESCE(CAST(NULLIF(${id},-1) AS STRING),"Unknown")) ;;
  }



   }
