#########################################################{
# PURPOSE
# Provides definition of Item and Category dimensions to be extended into:
#   sales_orders__lines
#   sales_invoices__lines
#
# Note these definitions capture dimension values
# so that __lines__item_categories and __lines__item_descriptions
# are not fully unnested in an Explore
#########################################################}

view: otc_derive_common_product_fields_ext {
extension: required

#########################################################
# Item dimensions
#{

  # parameter: parameter_language {
  #   hidden: no
  #   type: string
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Language"
  #   description: "Select language to display for item descriptions. Default is 'US'."
  #   suggest_explore: item_md
  #   suggest_dimension: item_md__item_descriptions.language_code
  #   default_value: "US"
  #   suggest_persist_for: "0 seconds"
  # }

  dimension: item_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: COALESCE((SELECT d.TEXT FROM UNNEST(${item_descriptions}) AS d WHERE d.language = {% parameter otc_common_parameters_xvw.parameter_language %} ), CONCAT("Inventory Item ID: ",CAST(${inventory_item_id} AS STRING))) ;;
    full_suggestions: yes
  }

  dimension: language_code {
    hidden: no
    group_label: "Item Categories & Descriptions"
    description: "Language in which to display item descriptions."
    sql: (SELECT d.LANGUAGE FROM UNNEST(${item_descriptions}) AS d WHERE d.LANGUAGE = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: category_id {
    hidden: no
    type: number
    group_label: "Item Categories & Descriptions"

    sql: @{get_category_set} COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME =  '{{ category_set }}' ), -1 ) ;;
    # sql: COALESCE((SELECT c.ID FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter otc_common_parameters_xvw.parameter_category_set_name %}), -1 ) ;;
    full_suggestions: yes
    value_format_name: id
  }

  dimension: category_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: @{get_category_set} COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = '{{ category_set }}' )
      ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
    # sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter otc_common_parameters_xvw.parameter_category_set_name %} )
    # ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
    full_suggestions: yes
  }

  dimension: category_name_code {
    hidden: no
    group_label: "Item Categories & Descriptions"
    sql: @{get_category_set} COALESCE((SELECT c.CATEGORY_NAME FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = '{{ category_set }}'),"Unknown" ) ;;
    # sql: COALESCE((SELECT c.category_name FROM UNNEST(${item_categories}) AS c WHERE c.CATEGORY_SET_NAME = {% parameter otc_common_parameters_xvw.parameter_category_set_name %}),"Unknown" ) ;;
    full_suggestions: yes
  }



#} end item dimensions


 }