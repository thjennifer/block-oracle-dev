include: "/views/base/sales_orders__lines__return_line_ids.view"

view: +sales_orders__lines__return_line_ids {

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${return_line_id}) ;;
  }

  dimension: sales_orders__lines__return_line_ids {
    hidden: yes
  }

  dimension: return_line_id {
    type: number
    value_format_name: id
    sql: COALESCE(sales_orders__lines__return_line_ids,-1) ;;
  }

   }
