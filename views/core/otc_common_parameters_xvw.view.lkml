view: otc_common_parameters_xvw {
  label: "@{view_label_for_filters}"

  parameter: parameter_target_currency {
    hidden: no
    type: string
    label: "Target Currency"
    suggest_explore: currency_rate_md
    suggest_dimension: currency_rate_md.to_currency
    default_value: "USD"
  }

  parameter: parameter_category_set_name {
    hidden: yes
    type: string
    label: "Category Set Name"
    suggest_explore: item_md
    suggest_dimension: item_md__item_categories.category_set_name
    default_value: "BE_INV_ITEM_CATEGORY_SET"
  }


  parameter: parameter_language {
    hidden: no
    type: string
    label: "Language"
    description: "Select language to display for item descriptions. Default is 'US'."
    suggest_explore: item_md
    suggest_dimension: item_md__item_descriptions.language_code
    default_value: "US"
    suggest_persist_for: "0 seconds"
  }

 }
