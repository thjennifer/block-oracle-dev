#########################################################{
# PURPOSE
# Provides consistent labels/descriptions for Fiscal GL Dates
# based on Ledger Date and used in:
#    sales_invoices__lines
#    sales_payments
#    sales_applied_receivables
#
# Defines labels & dsecriptions for:
#   fiscal_period_name
#   fiscal_period_set_name
#   fiscal_period_type
#   fiscal_gl_period_num
#   fiscal_gl_quarter_num
#   fiscal_gl_year_num
#
# Defines dimension:
#   fiscal_gl_year_period
#
#########################################################}

view: otc_common_fiscal_gl_dates_ext {
  extension: required

  dimension: fiscal_period_name {
    hidden: no
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_set_name {
    hidden: no
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_type {
    hidden: no
    group_label: "Ledger Date"
  }

  dimension: fiscal_gl_period_num {
    hidden: no
    group_label: "Ledger Date"
    label: "Fiscal GL Period Number"
    description: "Fiscal GL period of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter_num {
    hidden: no
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_year_num {
    hidden: no
    group_label: "Ledger Date"
    label: "Fiscal GL Year Number"
    description: "Fiscal GL Year of ledger date as an integer."
    value_format_name: id
  }

  dimension: fiscal_gl_year_period {
    hidden: no
    type: string
    group_label: "Ledger Date"
    label: "Fiscal GL Year-Period (YYYY-PPP)"
    description: "Fiscal GL Year-Period formatted as YYYY-PPP string."
    sql: CONCAT(CAST(${fiscal_gl_year_num} AS STRING),"-",LPAD(CAST(${fiscal_gl_period_num} AS STRING),3,'0'));;
  }



   }
