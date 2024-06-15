view: sales_payments_dynamic_aging_bucket_sdt {

  derived_table: {
    sql: {% assign bucket_size = parameter_aging_bucket_size._parameter_value %}{%assign bucket_count = parameter_aging_bucket_count._parameter_value | minus: 1 %}
         {% assign max = bucket_size | times: bucket_count %}{% assign tag = ' Days Past Due' %}
        SELECT
          aging_bucket_number,
          --IF(end_days = 0,'CURRENT',CONCAT(end_days," PAST DUE" )) AS aging_bucket_name,
          IF(end_days = 0,'CURRENT',CONCAT(end_days,"{{tag}}" )) AS aging_bucket_name,
          IF(end_days = 0,-9999999,LAG(end_days) OVER(ORDER BY end_days)+1) AS start_days,
          end_days
        FROM
          UNNEST(GENERATE_ARRAY(0,{{max}},{{bucket_size}})) AS end_days
        WITH OFFSET AS aging_bucket_number
        UNION ALL
          SELECT
          {{bucket_count | plus: 1 }} AS aging_bucket_number,
          '{{max | plus: 1 | append:'+ ' | append: tag}}' as aging_bucket_name,
         -- '121+ PAST DUE' AS aging_bucket_name,
          {{max | plus: 1}} AS start_days,
          9999999 AS end_days

    ;;
  }

  parameter: parameter_aging_bucket_size {
    type: number
    view_label: "@{view_label_for_filters}"
    label: "Aging Bucket: Number Days per Bucket"
    default_value: "30"
  }

  parameter: parameter_aging_bucket_count {
    type: number
    view_label: "@{view_label_for_filters}"
    label: "Aging Bucket: Number of Buckets"
    default_value: "4"
  }

  dimension: aging_bucket_number {
    type: number
    primary_key: yes
    sql: ${TABLE}.aging_bucket_number ;;
  }

  dimension: aging_bucket_name {
    type: string
    sql: ${TABLE}.aging_bucket_name ;;
    order_by_field: aging_bucket_number
  }

  dimension: start_days {
    type: number
    sql: ${TABLE}.start_days ;;
  }

  dimension: end_days {
    type: number
    sql: ${TABLE}.end_days ;;
  }

  dimension: dummy_bucket_number {
    type: number
    hidden: no
    sql: 4 ;;
  }

  dimension: dummy_bucket_size {
    type: number
    hidden: no
    sql: 4 ;;
  }

 }
