view: otc__lines_common_product_dimensions_ext {
extension: required

#########################################################
# Item dimensions
#{

  parameter: parameter_language {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Language"
    description: "Select language to display for item descriptions. Default is 'US'."
    suggest_explore: item_md
    suggest_dimension: item_md__item_descriptions.language
    default_value: "US"
  }


  dimension: item_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: COALESCE((SELECT d.TEXT FROM UNNEST(${item_descriptions}) AS d WHERE d.language = {% parameter parameter_language %} ), CONCAT("Inventory Item ID: ",CAST(${inventory_item_id} AS STRING))) ;;
    full_suggestions: yes
  }

  dimension: item_description_language {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: (SELECT d.LANGUAGE FROM UNNEST(${item_descriptions}) AS d WHERE d.LANGUAGE = {% parameter parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: item_category_id {
    hidden: no
    type: number
    group_label: "Item Categories & Descriptions"

    sql: COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}'), -1 ) ;;
    # sql: COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter sales_orders_common_parameters_xvw.parameter_category_set_name %}), -1 ) ;;
    full_suggestions: yes
    value_format_name: id
  }

  dimension: item_category_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}' )
      ,COALESCE(CAST(NULLIF(${item_category_id},-1) AS STRING),"Unknown")));;
    # sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter sales_orders_common_parameters_xvw.parameter_category_set_name %} )
    # ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
    full_suggestions: yes
  }

  dimension: item_category_name_code {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: COALESCE((SELECT c.CATEGORY_NAME FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = '{{ _user_attributes['cortex_oracle_ebs_category_set_name'] }}'),"Unknown" ) ;;
    # sql: COALESCE((SELECT c.category_name FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter sales_orders_common_parameters_xvw.parameter_category_set_name %}),"Unknown" ) ;;
    full_suggestions: yes
  }



#} end item dimensions


 }
