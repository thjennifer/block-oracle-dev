include: "/views/base/sales_orders.view"

view: +sales_orders__lines__item_categories {

  dimension: id {
    primary_key: no
    label: "Category ID"
    sql: ${TABLE}.ID ;;
  }
  dimension: category_name {
    full_suggestions: yes
  }
  dimension: category_set_id {
    full_suggestions: yes
  }
  dimension: category_set_name {
    full_suggestions: yes
  }
  dimension: description {
    label: "Category Description"
    full_suggestions: yes
  }

  parameter: parameter_category_set_name {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Category Set Name"
    # suggest_explore: language_codes_sdt
    # suggest_dimension: language_codes_sdt.language_code
    suggest_explore: item_md
    suggest_dimension: item_md__item_categories.category_set_name
    default_value: "Purchasing"
  }

   }
