
view: test_view {

  derived_table: {
    sql:
        SELECT 12 as business_unit_id, CAST(NULL as STRING) as business_unit_name
        UNION ALL
        SELECT 24 as business_unit_id, 'Best Business' as business_unit_name;;
  }

  dimension: business_unit_id {
    type: number
    sql: ${TABLE}.business_unit_id ;;
  }

  dimension: business_unit_name {
    type: string
    sql: ${TABLE}.business_unit_name ;;
  }

  }
