  # set full suggestions to yes so that filter suggestions populate properly for nested fields
  # value of yes means Looker queries the nest field as part of the full explore rather than a standalone table

include: "/views/base/sales_orders_daily_agg.view"

view: +sales_orders_daily_agg__lines {
  label: "Lines Daily Agg"

  parameter: parameter_target_currency {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Target Currency"
    suggest_explore: currency_rate_md
    suggest_dimension: currency_rate_md.to_currency
    default_value: "USD"
    # full_suggestions: yes
  }

  dimension: total_sales_target_currency {
    type: number
    sql: (select TOTAL_ORDERED FROM sales_orders_daily_agg__lines.amounts WHERE CURRENCY_CODE = {% parameter parameter_target_currency %}) ;;
  }

  dimension: item_category_name {
    full_suggestions: yes
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_SET_NAME,"Unknown") ;;
    }

  dimension: item_category_set_id {
    full_suggestions: yes
    sql:  COALESCE(${TABLE}.ITEM_CATEGORY_SET_ID,-1) ;;
  }


  # dimension: category_set_id {
  #   full_suggestions: yes
  #   sql: COALESCE(${TABLE}.CATEGORY_SET_ID,-1) ;;
  # }

  # dimension: category_set_name {
  #   full_suggestions: yes
  #   sql: COALESCE(${TABLE}.CATEGORY_SET_NAME,"Unknown") ;;
  # }


 }
