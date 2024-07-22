include: "/views/base/item_md__item_categories.view"
include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +item_md__item_categories {
  fields_hidden_by_default: yes

  extends: [otc_unnest_item_categories_common_fields_ext]

  dimension: key {
    primary_key: yes
    sql: CONCAT(${item_md.key},${category_set_id},${category_id}) ;;
  }

  dimension: id {
    primary_key: no
  }

  dimension: category_set_id {
    full_suggestions: yes
  }
  dimension: category_set_name {
    full_suggestions: yes
  }



  }
