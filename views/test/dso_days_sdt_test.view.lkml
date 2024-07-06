include: "/views/core/dso_days_sdt.view"

view: +dso_days_sdt {

    derived_table: {
            sql:
      SELECT
      DSO_DAYS,
      DATE_SUB(DATE(@{default_target_date_test}) - 1, INTERVAL DSO_DAYS DAY) AS DSO_START_DATE,
      @{default_target_date_test} - 1 AS DSO_END_DATE
      FROM
      UNNEST(ARRAY[30,90,365]) AS DSO_DAYS ;;
   }
}
