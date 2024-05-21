include: "/views/base/item_md.view"

view: +item_md__item_categories {

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

  }
