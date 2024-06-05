#########################################################{
# PURPOSE
# Extend into views that UNNEST __lines__item_categories:
#   sales_orders__lines__item_categories
#   sales_invoices__lines__item_categories
#   item_md__lines__item_categories
#
# Provides consistent defintions and labels for:
#   category_id
#   category_name_code
#   category_description
#########################################################}


view: otc_unnest_item_categories_common_fields_ext {
  extension: required

  # dimension: category_id {
  #   hidden: no
  #   type: number
  #   sql:
  #         {% assign v = _view._name %}
  #         {% if v == "sales_orders_daily_agg__lines" %}{% assign f = "ITEM_CATEGORY_ID"%}
  #           {% elsif v contains "item_categories" %}{% assign f = "ID" %}
  #           {% else %}{% assign f = "subquery" %}
  #         {%endif%}
  #         {% if f == "subquery" %}
  #             @{get_category_set}COALESCE((SELECT c.ID FROM UNNEST(${TABLE}.ITEM_CATEGORIES) AS c WHERE c.CATEGORY_SET_NAME =  '{{ category_set }}' ), -1 )
  #         {% else %}
  #             COALESCE(${TABLE}.{{f}},-1)
  #         {% endif %};;
  #   full_suggestions: yes
  #   value_format_name: id
  # }

  dimension: category_id {
    hidden: no
    type: number
    sql:
          {% if _view._name == "sales_orders_daily_agg__lines" %}{% assign f = "ITEM_CATEGORY_ID"%}
          {% else %}{% assign f = "ID" %}{%endif%}
            COALESCE(${TABLE}.{{f}},-1)
            ;;
    full_suggestions: yes
    value_format_name: id
  }



  dimension: category_name_code {
    hidden: no
    type: string
    sql: {% if _view._name == "sales_orders_daily_agg__lines" %}{% assign f = "ITEM_CATEGORY_NAME"%}{% else %}{% assign f = "CATEGORY_NAME" %}{%endif%}
        COALESCE(${TABLE}.{{f}},"Unknown") ;;
    full_suggestions: yes
  }

  dimension: category_description {
    hidden: no
    sql: {% if _view._name == "sales_orders_daily_agg__lines" %}{% assign f = "ITEM_CATEGORY_DESCRIPTION"%}{% else %}{% assign f = "DESCRIPTION" %}{%endif%}
         COALESCE(${TABLE}.{{f}},COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")) ;;
    full_suggestions: yes
  }

  }
