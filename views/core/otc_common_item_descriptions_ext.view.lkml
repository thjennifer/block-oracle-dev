#########################################################{
# PURPOSE
# Provides consistent definitions and labels for:
#   item_description
#   language_code
#
# Extend into views using item descriptions:
#   sales_orders__lines
#   sales_orders__lines__item_descriptions
#   sales_invoices__lines
#   sales_invoices__lines__item_descriptions
#   item_md__lines__item_descriptions
#
#########################################################}

view: otc_common_item_descriptions_ext {
  extension: required

  dimension: item_description {
    hidden: no
    type: string
    group_label: "{%- assign v = _view._name -%}
                  {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}
                  {%- if group_c contains v -%}Item Categories & Descriptions{%- endif -%}"
    description: "Item description text"
    sql: {%- assign v = _view._name -%}
         {%- assign group_b = 'sales_orders__lines__item_descriptions||sales_invoices__lines__item_descriptions||item_md__item_descriptions' | split: '||' -%}
         {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}

      {%- if group_b contains v -%}
        COALESCE(${TABLE}.TEXT,'Unknown')
      {%- elsif group_c contains v -%}
        COALESCE((SELECT d.TEXT FROM UNNEST(${TABLE}.ITEM_DESCRIPTIONS) AS d WHERE d.LANGUAGE =  {% parameter otc_common_parameters_xvw.parameter_language %} ), CONCAT("Item Part Number: ",CAST(${item_part_number} AS STRING))  )
      {%- endif -%}
      ;;
    full_suggestions: yes
    value_format_name: id
  }

  dimension: language_code {
    hidden: no
    type: string
    group_label: "{%- assign v = _view._name -%}
                  {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}
                  {%- if group_c contains v -%}Item Categories & Descriptions{%- endif -%}"
    description: "Language code of the item description"
    sql: {%- assign v = _view._name -%}
         {%- assign group_b = 'sales_orders__lines__item_descriptions||sales_invoices__lines__item_descriptions||item_md__item_descriptions' | split: '||' -%}
         {%- assign group_c = 'sales_orders__lines||sales_invoices__lines' | split: '||' -%}

      {%- if group_b contains v -%}
        COALESCE(${TABLE}.LANGUAGE,'Unknown')
      {%- elsif group_c contains v -%}
        COALESCE((SELECT d.LANGUAGE FROM UNNEST(${TABLE}.ITEM_DESCRIPTIONS) AS d WHERE d.LANGUAGE =  {% parameter otc_common_parameters_xvw.parameter_language %} ), 'Unknown')
      {%- endif -%}
      ;;
    full_suggestions: yes
    value_format_name: id
  }

   }
