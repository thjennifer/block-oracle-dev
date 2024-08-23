include: "/views/core/otc_common_item_categories_ext.view"
view: +otc_common_item_categories_ext {
  extension: required

  dimension: category_id {
    hidden: no
    type: number
    group_label: "{%- assign v = _view._name -%}
    {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}
    {%- if group_c contains v -%}Item Categories & Descriptions{%- endif -%}"
    sql: {%- assign v = _view._name -%}
         {%- assign group_a = 'sales_orders_daily_agg__lines||sales_invoices_daily_agg' | split: '||' -%}
         {%- assign group_b = 'sales_orders__lines__item_categories||sales_invoices__lines__item_categories||item_md__item_categories' | split: '||' -%}
         {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}

      {%- if group_a contains v -%}
      COALESCE(${TABLE}.ITEM_CATEGORY_ID,-1)
      {%- elsif group_b contains v -%}
      COALESCE(${TABLE}.ID,-1)
      {%- elsif group_c contains v -%}
      COALESCE((SELECT c.ID FROM UNNEST(${TABLE}.ITEM_CATEGORIES) AS c WHERE c.CATEGORY_SET_NAME =  @{category_set_test} ), -1 )
      {%- endif -%}
      ;;
    full_suggestions: yes
    value_format_name: id
  }

  dimension: category_name_code {
    hidden: no
    type: string
    group_label: "{%- assign v = _view._name -%}
    {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}
    {%- if group_c contains v -%}Item Categories & Descriptions{%- endif -%}"
    sql: {%- assign v = _view._name -%}
         {%- assign group_a = 'sales_orders_daily_agg__lines||sales_invoices_daily_agg' | split: '||' -%}
         {%- assign group_b = 'sales_orders__lines__item_categories||sales_invoices__lines__item_categories||item_md__item_categories' | split: '||' -%}
         {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}

      {%- if group_a contains v -%}
      COALESCE(${TABLE}.ITEM_CATEGORY_NAME,'Unknown')
      {%- elsif group_b contains v -%}
      COALESCE(${TABLE}.CATEGORY_NAME,'Unknown')
      {%- elsif group_c contains v -%}
      COALESCE((SELECT c.CATEGORY_NAME FROM UNNEST(${TABLE}.ITEM_CATEGORIES) AS c WHERE c.CATEGORY_SET_NAME =  @{category_set_test} ), 'Unknown' )
      {%- endif -%}
      ;;
    full_suggestions: yes
  }

  dimension: category_description {
    hidden: no
    group_label: "{%- assign v = _view._name -%}
    {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}
    {%- if group_c contains v -%}Item Categories & Descriptions{%- endif -%}"
    sql: {%- assign v = _view._name -%}
         {%- assign group_a = 'sales_orders_daily_agg__lines||sales_invoices_daily_agg' | split: '||' -%}
         {%- assign group_b = 'sales_orders__lines__item_categories||sales_invoices__lines__item_categories||item_md__item_categories' | split: '||' -%}
         {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}

      {%- if group_a contains v -%}
      COALESCE(${TABLE}.ITEM_CATEGORY_DESCRIPTION,COALESCE(CAST(${TABLE}.ITEM_CATEGORY_ID AS STRING),'Unknown'))
      {%- elsif group_b contains v -%}
      COALESCE(${TABLE}.DESCRIPTION,COALESCE(CAST(${TABLE}.ID AS STRING),'Unknown'))
      {%- elsif group_c contains v -%}
      COALESCE((SELECT c.DESCRIPTION FROM UNNEST(${TABLE}.ITEM_CATEGORIES) AS c WHERE c.CATEGORY_SET_NAME =  @{category_set_test} ),
      COALESCE(CAST((SELECT c.ID FROM UNNEST(${TABLE}.ITEM_CATEGORIES) AS c WHERE c.CATEGORY_SET_NAME =  @{category_set_test} ) AS STRING),'Unknown'))
      {%- endif -%}
      ;;
    full_suggestions: yes
  }

}
