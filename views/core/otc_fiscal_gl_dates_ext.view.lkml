view: otc_fiscal_gl_dates_ext {
  extension: required

  dimension: fiscal_gl_month_num {
    group_label: "Ledger Date"
    label: "Fiscal GL Month Number"
    description: "Fiscal GL month of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter_num {
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_year_num {
    group_label: "Ledger Date"
    label: "Fiscal GL Year Number"
    description: "Fiscal GL Year of ledger date as an integer."
    value_format_name: id
  }

  dimension: fiscal_gl_year_month_num {
    group_label: "Ledger Date"
    label: "Fiscal GL YYYY-MM"
    description: "Fiscal GL Year-Month formatted as YYYY-MM string."
    sql: CONCAT(CAST(${fiscal_gl_year_num} AS STRING),"-",LPAD(CAST(${fiscal_gl_month_num} AS STRING),2,'0'));;
  }

  dimension: fiscal_period_name {
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_set_name {
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_type {
    group_label: "Ledger Date"
  }

   }
