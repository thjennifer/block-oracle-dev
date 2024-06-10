include: "/views/test/test_view.view"
include: "/views/test/test_view_to_extend.view"
view: test_view_ext {
  extends: [test_view]

  dimension: business_unit_name {
    label: "BUSINESS NAME"
    sql: COALESCE(${TABLE}.business_unit_name,CAST(${TABLE}.business_unit_id as STRING)) ;;
  }
 }
