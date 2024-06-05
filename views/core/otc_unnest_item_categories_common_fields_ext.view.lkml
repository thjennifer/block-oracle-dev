#########################################################{
# PURPOSE
# Extend into views that UNNEST __lines__item_categories:
#   sales_orders__lines__item_categories
#   sales_invoices__lines__item_categories
#   item_md__lines__item_categories
#
# Provides consistent defintions and labels for:
#   item_category_id
#   item_category_name
#   category_description
#########################################################}


view: otc_unnest_item_categories_common_fields_ext {
  extension: required

  dimension: category_id {
    hidden: no
    type: number
    sql: COALESCE(${TABLE}.ID,-1) ;;
    full_suggestions: yes
    value_format_name: id
  }

  dimension: category_name_code {
    hidden: no
    type: string
    sql: COALESCE(${TABLE}.CATEGORY_NAME,"Unknown") ;;
    full_suggestions: yes
  }

  dimension: category_description {
    hidden: no
    sql: COALESCE(${TABLE}.DESCRIPTION,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")) ;;
    full_suggestions: yes
  }

  }