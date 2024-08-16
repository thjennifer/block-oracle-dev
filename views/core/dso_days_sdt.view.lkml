view: dso_days_sdt {

  derived_table: {
    sql:
    SELECT
      DSO_DAYS,
      DATE_SUB(DATE(@{default_target_date}) - 1, INTERVAL DSO_DAYS DAY) AS DSO_START_DATE,
      @{default_target_date} - 1 AS DSO_END_DATE
    FROM
      UNNEST(ARRAY[30,90,365]) AS DSO_DAYS ;;
  }

  dimension: dso_days {
    type: number
    primary_key: yes
    sql: ${TABLE}.DSO_DAYS ;;
  }

  dimension: dso_days_string {
    hidden: yes
    type: string
    sql: CAST(${dso_days} as STRING) ;;
    order_by_field: dso_days
  }

  dimension: dso_start_date {
    type: date
    sql: ${TABLE}.DSO_START_DATE ;;
  }

  dimension: dso_end_date {
    type: date
    sql: ${TABLE}.DSO_END_DATE ;;
  }

}
