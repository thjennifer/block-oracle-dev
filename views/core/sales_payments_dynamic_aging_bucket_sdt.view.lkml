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
    label: "Aging Bucket: Number of Ranges"
    default_value: "4"
  }

  dimension: aging_bucket_number {
    hidden: no
    group_label: "Aging Buckets"
    type: number
    primary_key: yes
    description: "Numerical order of aging bucket derived using Aging Bucket Size and Count parameters."
    sql: ${TABLE}.aging_bucket_number ;;
  }

  dimension: aging_bucket_name {
    hidden: no
    group_label: "Aging Buckets"
    type: string
    description: "The aging bucket's name as derived by the 'Aging Bucket: Number of Days per Bucket' and 'Aging Bucket: Number of Ranges' parameters. For instance, if the aging bucket size is 30 days and the number of ranges is 3, the first bucket will be called '30 Days Past Due' and will include invoices that are between 1 and 30 days old. The following bucket will be called '60 Days Past Due' and will include invoices that are between 31 and 60 days old. And the third bucket will be called '61+ Days Past Due' and will include invoices greater than or equal to 61 days old. Note, a 'Current' bucket is always included and is not impacted by the Aging Bucket Count parameter."
    sql: ${TABLE}.aging_bucket_name ;;
    order_by_field: aging_bucket_number
  }

  dimension: start_days {
    hidden: no
    group_label: "Aging Buckets"
    type: number
    sql: ${TABLE}.start_days ;;
  }

  dimension: end_days {
    hidden: no
    group_label: "Aging Buckets"
    type: number
    sql: ${TABLE}.end_days ;;
  }

  dimension: dummy_bucket_number {
    hidden: yes
    type: number
    sql: 4 ;;
  }

  dimension: dummy_bucket_size {
    hidden: yes
    type: number
    sql: 4 ;;
  }

 }
