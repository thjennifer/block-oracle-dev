view: language_codes_sdt {
  derived_table: {
    sql:  SELECT
            DISTINCT d.language as language_code
          FROM
          `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.ItemMD`,
          UNNEST(ITEM_DESCRIPTIONS) AS d ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

}
