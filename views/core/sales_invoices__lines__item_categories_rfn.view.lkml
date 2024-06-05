include: "/views/base/sales_invoices__lines__item_categories.view"
include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_invoices__lines__item_categories {
  fields_hidden_by_default: yes
  extends: [otc_unnest_item_categories_common_fields_ext]

   dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${sales_invoices__lines.line_id},${category_set_id},${category_id}) ;;
  }

  dimension: id {
    primary_key: no
  }

  dimension: category_set_id {
    full_suggestions: yes
    sql: COALESCE(${TABLE}.CATEGORY_SET_ID,-1) ;;
  }

  dimension: category_set_name {
    full_suggestions: yes
    sql: COALESCE(${TABLE}.CATEGORY_SET_NAME,"Unknown") ;;
  }


   }
