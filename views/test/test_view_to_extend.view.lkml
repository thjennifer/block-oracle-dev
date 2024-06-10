view: test_view_to_extend {

extension: required

dimension: business_unit_id {
  label: "BUSINESS ID"
}

dimension: business_unit_name {
  label: "BUSINESS NAME"
  sql: COALESCE(${TABLE}.business_unit_name,'Unknown')) ;;
}
 }
