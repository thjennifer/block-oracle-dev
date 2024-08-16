view: otc_common_currency_ext {
  extension: required

#--> sales_orders
  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "Currency of the order."
  }

#--> sales_invoices
  # dimension: currency_code {
  #   hidden: no
  #   group_label: "Currency Conversion"
  #   label: "Currency (Source)"
  #   description: "Currency of the invoice transaction."
  # }

#--> sales_orders & sales_orders_daily_agg__lines
  dimension: target_currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Target)"
    description: "Converted target currency of the order from the source currency."
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  # try new description:  The target currency code represents the currency into which the order's source currency is converted."

#--> sales_invoices & sales_invoices_daily_agg
  # dimension: target_currency_code {
  #   hidden: no
  #   group_label: "Currency Conversion"
  #   label: "Currency (Target)"
  #   description: "Converted target currency of the invoice from the source currency."
  #   sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  # }

#--> sales_orders_daily_agg__lines__amounts, sales_invoices_daily_agg__amounts, sales_payments_daily_agg__amounts
  # dimension: target_currency_code {
  #   hidden: no
  #   label: "Currency (Target)"
  #   full_suggestions: yes
  #   sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  # }

#--> sales_payments
  # dimension: target_currency_code {
  #   hidden: no
  #   type: string
  #   group_label: "Currency Conversion"
  #   label: "Currency (Target)"
  #   sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  # }


#--> sales_orders, sales_invoices, sales_payments
  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Currency Conversion"
    description: "Exchange rate between source and target currency for a specific date."
    sql: IF(${currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }



#--> sales_orders, sales_invoices, sales_payments
  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Currency Conversion"
    sql: ${currency_code} <> ${target_currency_code} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

#--> sales_orders_daily_agg__lines
  # dimension: is_incomplete_conversion {
  #   hidden: no
  #   type: yesno
  #   # group_label: "Amounts"
  #   sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  # }

#--> sales_invoices_daily_agg
  # dimension: is_incomplete_conversion {
  #   hidden: no
  #   type: yesno
  #   group_label: "Currency Conversion"
  #   sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM sales_invoices_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  # }

#--> sales_payments_daily_agg
  # dimension: is_incomplete_conversion {
  #   hidden: no
  #   type: yesno
  #   group_label: "Currency Conversion"
  #   description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
  #   sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  # }

#--> sales_orders_daily_agg__lines__amounts, sales_invoics_daily_agg__amounts
  # dimension: is_incomplete_conversion {
  #   hidden: no
  #   description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
  #   sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
  #   }

  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in html when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated."
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}<span style='color: red; font-size: 16px;'>&#9888; </span> For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

}
