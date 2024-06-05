view: otc_unnest_item_descriptions_common_fields_ext {
  extension:required

  # parameter: parameter_language {
  #   hidden: no
  #   type: string
  #   # view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Language"
  #   description: "Select language to display for item descriptions. Default is 'US'."
  #   suggest_explore: item_md
  #   suggest_dimension: item_md__item_descriptions.language_code
  #   default_value: "US"
  #   full_suggestions: yes
  #   suggest_persist_for: "2 seconds"
  # }

  dimension: item_description {
    hidden: no
    type: string
    sql: COALESCE(${TABLE}.TEXT,"Unknown") ;;
    full_suggestions: yes
  }

  dimension: language_code {
    hidden: no
    type: string
    description: "Language in which to display item descriptions."
    sql: COALESCE(${TABLE}.LANGUAGE,"Unknown") ;;
    full_suggestions: yes
  }


  }
