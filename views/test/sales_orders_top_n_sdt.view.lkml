view: sales_orders_top_n_sdt {

  derived_table: {
    sql: {% assign d0 = sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
         {% assign m = parameter_rank_by_measure._parameter_value%}{% assign rdim = parameter_rank_dimension._parameter_value %}
         {% assign ic = parameter_display_product_level._parameter_value %}

         {% if d0 == "test" %}{%assign d = 'CORTEX_ORACLE_REPORTING_VISION' %}{% else %}{% assign d = 'CORTEX_ORACLE_REPORTING' %}{% endif %}
         {% if m == "average_sales"%}{% assign t = "SalesOrders" %}
            {% elsif rdim  == "product" and ic == "Item" %}{% assign t = "SalesOrders" %}
            {%else%}{%assign t = "SalesOrdersDailyAgg" %}{%endif%}
        SELECT dense_rank() over (order by rank_metric_amount desc) as rank_number,
              rank_dimension_id,
              rank_dimension_description,
              rank_metric_amount,
              SUM(rank_metric_amount) OVER () as total_rank_metric_amount
        FROM
            (
            SELECT COALESCE(h.business_unit_id,-1) AS rank_dimension_id,
                   COALESCE(h.business_unit_name,COALESCE(CAST(h.business_unit_id AS STRING),'Unknown')) as rank_dimension_description,

                   AVG(( l.ORDERED_AMOUNT * IF(h.CURRENCY_CODE = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}, 1, c.CONVERSION_RATE)   ) ) AS rank_metric_amount
            FROM `@{GCP_PROJECT_ID}.{{d}}.{{t}}` AS h
            LEFT JOIN UNNEST(h.LINES) AS l
            LEFT JOIN ${currency_conversion_sdt.SQL_TABLE_NAME} c ON
                  h.ORDERED_DATE = c.CONVERSION_DATE AND
                  h.CURRENCY_CODE = c.FROM_CURRENCY
            WHERE h.is_cancelled = false
            GROUP BY 1, 2
            ) t

  ;;
  }
  dimension: rank_number {
    primary_key: yes
    type: number
    sql: ${TABLE}.rank_number ;;
  }

  dimension: rank_dimension_id {
    type: number
    sql: ${TABLE}.rank_dimension_id ;;
    value_format_name: id
  }

  dimension: rank_dimension_description {
    type: string
    sql: ${TABLE}.rank_dimension_description ;;
  }

  dimension: rank_metric_amount {
    type: number
    sql: ${TABLE}.rank_metric_amount ;;
  }

  dimension: total_rank_metric_amount {
    type: number
    sql: ${TABLE}.total_rank_metric_amount ;;
  }

  parameter: parameter_top_n {
    type: number
    default_value: "10"
  }

  parameter: parameter_rank_by_measure {
    description: "Specify which metric to rank by"
    type: unquoted
    default_value: "total_sales"
    allowed_value: {
      label: "Total Sales"
      value: "total_sales"
    }
    allowed_value: {
      label: "Average Sales per Order"
      value: "average_sales"
    }
  }

  parameter: parameter_rank_dimension {
    type: unquoted
    allowed_value: {label: "Business Unit" value: "business"}
    allowed_value: {label: "Sold To Customer" value: "sold_to"}
    allowed_value: {label: "Product" value: "product"}
    default_value: "product"
  }

  parameter: parameter_display_product_level {
    hidden: no
    type: unquoted
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Display Categories or Items"
    description: "Select whether to display categories or items in report. Use with dimensions Selected Product Dimension ID and Selected Product Dimension Description."
    allowed_value: {label: "Category" value: "Category"}
    allowed_value: {label: "Item" value: "Item"}
    default_value: "Category"
  }


 }
