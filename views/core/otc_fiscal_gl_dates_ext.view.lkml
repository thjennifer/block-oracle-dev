view: otc_fiscal_gl_dates_ext {
  extension: required

  dimension: fiscal_gl_period_num {
    group_label: "Ledger Date"
    label: "Fiscal GL Period Number"
    description: "Fiscal GL period of the ledger date as an integer."
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

  dimension: fiscal_gl_year_period {
    type: string
    group_label: "Ledger Date"
    label: "Fiscal GL Year-Period (YYYY-PPP)"
    description: "Fiscal GL Year-Period formatted as YYYY-PPP string."
    sql: CONCAT(CAST(${fiscal_gl_year_num} AS STRING),"-",LPAD(CAST(${fiscal_gl_period_num} AS STRING),3,'0'));;
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
