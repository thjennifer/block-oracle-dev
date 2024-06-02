view: sales_orders_common_parameters_xvw {


  parameter: parameter_target_currency {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Target Currency"
    suggest_explore: currency_rate_md
    suggest_dimension: currency_rate_md.to_currency
    default_value: "USD"
  }

  parameter: parameter_category_set_name {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Category Set Name"
    suggest_explore: item_md
    suggest_dimension: item_md__item_categories.category_set_name
    default_value: "Purchasing"
  }

  parameter: parameter_use_test_or_demo_data {
    hidden: no
    type: unquoted
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Use Test or Demo Data"
    allowed_value: {label: "test" value:"test"}
    allowed_value: {label: "demo" value: "demo"}
    default_value: "test"
  }

 }
