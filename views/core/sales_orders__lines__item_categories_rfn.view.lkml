include: "/views/base/sales_orders__lines__item_categories.view"
include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_orders__lines__item_categories {

  fields_hidden_by_default: yes
  extends: [otc_unnest_item_categories_common_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${category_set_id},${category_id}) ;;
  }

  dimension: id {
    primary_key: no
  }

  dimension: category_set_id {
    sql: COALESCE(${TABLE}.CATEGORY_SET_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: category_set_name {
    sql: COALESCE(${TABLE}.CATEGORY_SET_NAME,"Unknown") ;;
    full_suggestions: yes
  }

  # dimension: category_name {
  #   label: "Item Category Name Group"
  #   full_suggestions: yes
  #   sql: COALESCE(${TABLE}.CATEGORY_NAME,"Unknown") ;;
  # }



  # dimension: description {
  #   label: "Item Category Description"
  #   full_suggestions: yes
  #   sql: COALESCE(${TABLE}.DESCRIPTION,COALESCE(CAST(NULLIF(${id},-1) AS STRING),"Unknown")) ;;
  # }


    dimension: liquid_view_name {
      hidden: no
      view_label: "TEST STUFF"
      sql: {% assign v = _view._name  %}
          {% if v contains "sales_orders_daily_agg" %}{% assign f = "ITEM_CATEGORY_ID"%}
            {% elsif v contains "item_categories" %}{% assign f = "ID" %}
            {% else %}{% assign f = "subquery" %}

          {%endif%} --vn {{v}}
            '{{f}}';;
    }



   }
