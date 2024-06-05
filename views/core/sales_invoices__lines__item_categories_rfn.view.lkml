include: "/views/base/sales_invoices__lines__item_categories.view"

view: +sales_invoices__lines__item_categories {

   dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${category_set_id},${id}) ;;
  }

  dimension: id {
    primary_key: no
    label: "Item Category ID"
    sql: COALESCE(${TABLE}.ID,-1) ;;
  }

  dimension: category_name {
    label: "Item Category Name Group"
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
    label: "Item Category Description"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.DESCRIPTION,COALESCE(CAST(NULLIF(${id},-1) AS STRING),"Unknown")) ;;
  }


   }
