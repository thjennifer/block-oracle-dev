#########################################################{
# PURPOSE
# Provides a template for dynamically creating and formatting HTML links for
# navigation between dashboards including the transfer of filter values.
#
# SOURCE
# none (This template can only be EXTENDED into another view)
#
# STYLES
# This template provides three styles for the html links. Pick which one to use
# with parameter_navigation_style
#   1. Buttons
#          parameter label: "Buttons"
#          parameter value: "buttons"
#   2. tabbed
#          parameter label: "Tabs"
#          parameter value: "tabs"
#   3. small text with links only (no image or unique formatting)
#          parameter label: "Plain Hyperlinks"
#          parameter value:  "plain"
#
# To add or modify styles, edit the Constant  section in the navigation dimension
#
# FILTERS
# This template allows a dasboard to pass up to 20 possible filters. The dimensions are
# named filter1 to filter20 and hidden by default.
# Modify this template if to add more filter dimensions as needed.
#
#
# STEPS TO EXTEND THIS TEMPLATE {
# When extending this template, make the REQUIRED customizations by following these steps:
# 1. create new view
# 2. add "extend: template_dashboard_navigation" parameter (use name of this view)
# 3. edit map_filter_numbers_to_dashboard_filter_names dimension.
#     - Update the "sql" property with the mapping of filter numbers to dashboard filter names.
#     - For each filter that needs to be passed between dashboards, assign a generic filter number 1 to N.
#     - This can be a broad list of filters that do not need to appear on every dashboard but should appear on at least 2 dashboards.
#     - Filters unique to a single dashboard do not need to be included here (as values do not pass to other dashboards).
#     - Use | between number and dashboard filter name
#     - Use || between each filter
#     - Note if dashboard filter name contains a space use + to represent the space (e.g. Order Date should be entered as Order+Date)
#     - You will specifiy the specific set of filters used in a dashboard in the dimension dash_bindings
#     - For example:
#           sql: '1|date||2|business_unit||3|customer_type||4|customer_country' ;;
#
# 4. edit dash_bindings dimension
#    - Update the "sql" property with properties of each dashboard:
#       ID - For UDD dashboards use numeric id. For LookML dashboards use dashboard name with or without model name.
#           131
#           model_name::dashboard_name1
#           dashboard_name1
#
#       Link Text (e.g., Sales Performance)
#
#       Filter Set used on the given dashboard. Use numbers 1 to N as specified separated by comma (e.g., 1,2 or 1,3,4).
#         Use numbers as specified in dimension map_filter_numbers_to_dashboard_filter_names
#
#     - Use | between each dashboard property.
#     - Use || between each dashboard set
#     - For example:
#       sql: '131|Dashboard 1 Link Text|1,2||132|Dashboard 2 Link Text|1,2,3,4' ;;
#       sql: 'dashboard_name1|Dashboard 1|1,2||dashboard_name2|Dashboard 2|1,2,3,4';;
#       sql: 'model_name::dashboard_name1|Dashboard 1|1,2||model_name::dashboard_name2|Dashboard 2|1,2,3,4';;
#
# 5. update parameter_tab_focus with the extra allowed values needed to match the number of dashboards.
#    Note, when extending, allowed values are additive, so only add values beyond 2.
#
# 6. edit filter1 to filterN (up to 20) dimensions to unhide and label. Note if only using in LookML dashboards, dimension can remain hidden.
#
#}
#
# USING IN A DASHBOARD {
# 1. Once the extending view has been created, modified, add to an Explore using a bare join:
#       explore: sales_order {
#           join: otc_dashboard_navigation_ext {
#           view_label: "🔍 Filters & 🛠 Tools"
#           relationship: one_to_one
#           sql:  ;;
#       }
#       }
# 2. Open the Explore and add "navigation" dimension to a Single Value Visualization
# 3. Add the navigation parameters as filters and set to desired values
#           navigation_style = "Hyperlinks - Left Aligned - No Border - Small font"
#           navigation_tab_focus = 1 for Dashboard 1. Set to 2 for Dashboard 2 and so on
# 4. Add Visualization to each of the dashboards and map dashboard filters to pass values
#    to Filters 1 to N accordingly
#
#    LookML example of the dashboard element is below:
#     - title: navigation
#       name: navigation
#       explore: profit_and_loss
#       type: single_value
#       fields: [profit_and_loss_navigation_ext.navigation]
#       filters:
#         profit_and_loss_navigation_ext.navigation_focus_page: '1'
#         profit_and_loss_navigation_ext.navigation_style: 'small'
#       show_single_value_title: false
#       show_comparison: false
#       listen:
#         Hierarchy: profit_and_loss_navigation_ext.filter1
#         Display Timeframe: profit_and_loss_navigation_ext.filter2
#         Select Fiscal Timeframe: profit_and_loss_navigation_ext.filter3
#         Target Currency: profit_and_loss_navigation_ext.filter4
#         Company Code: profit_and_loss_navigation_ext.filter5
#         Ledger Name: profit_and_loss_navigation_ext.filter6
#         Top Hierarchy Level to Display: profit_and_loss_navigation_ext.filter7
#         Combine Selected Timeframes?: profit_and_loss_navigation_ext.filter8
#}
#########################################################}

view: template_dashboard_navigation {
  extension: required

  view_label: "@{view_label_for_dashboard_navigation}"

#########################################################
# Fields *requiring override* in extension
#{

  dimension: map_filter_numbers_to_dashboard_filter_names {
    hidden: yes
    type: string
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country' ;;
  }

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: '131|Dashboard 1||132|Dashboard 2' ;;
  }

#} end required overrides

#########################################################
# Fields *optionally overriden* in extension
#{

  # use parameter to choose navigation style
  parameter: parameter_navigation_style {
    hidden: no
    type: unquoted
    label: "Navigation Style"
    description: "Select dashboard navigation style (e.g., Buttons, Tabs, Plain Hyperlinks)"
    allowed_value: {label: "Buttons" value: "buttons"}
    allowed_value: {label: "Tabs" value: "tabs"}
    allowed_value: {label: "Plain Hyperlinks" value: "plain"}
    default_value: "tabs"
  }

  # use parameter to set focus page until bug with _explore._dashboard_url is fixed
  # update allowed values to match number of dashboards defined in extension
  parameter: parameter_navigation_focus_page {
    hidden: no
    label: "Navigation Focus Page"
    description: "Used in dashboard navigation to set focus on selected dashboard page"
    type: unquoted
    allowed_value: {value:"1"}
    allowed_value: {value:"2"}
    default_value: "1"
  }

  # ** if using to build UDD dashboards, override hidden and label accordingly **
  # ** Add more as required, currently supports 20 **
  filter: filter1 { hidden: yes label: "filter1"}
  filter: filter2 { hidden: yes label: "filter2"}
  filter: filter3 { hidden: yes label: "filter3"}
  filter: filter4 { hidden: yes label: "filter4"}
  filter: filter5 { hidden: yes label: "filter5"}
  filter: filter6 { hidden: yes label: "filter6"}
  filter: filter7 { hidden: yes label: "filter7"}
  filter: filter8 { hidden: yes label: "filter8"}
  filter: filter9 { hidden: yes label: "filter9"}
  filter: filter10 { hidden: yes label: "filter10"}
  filter: filter11 { hidden: yes label: "filter11"}
  filter: filter12 { hidden: yes label: "filter12"}
  filter: filter13 { hidden: yes label: "filter13"}
  filter: filter14 { hidden: yes label: "filter14"}
  filter: filter15 { hidden: yes label: "filter15"}
  filter: filter16 { hidden: yes label: "filter16"}
  filter: filter17 { hidden: yes label: "filter17"}
  filter: filter18 { hidden: yes label: "filter18"}
  filter: filter19 { hidden: yes label: "filter19"}
  filter: filter20 { hidden: yes label: "filter20"}

#} end optional overrides




#########################################################
# Derive navigation links using liquid
#{

  dimension: navigation_links {
    type: string
    hidden: no
    label: "Dashboard Navigation Links"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    sql:  '' ;;
    html:
      <!-- generate page_style and focus_page_style liquid variables used below -->
      @{link_generate_dashboard_nav_style}
      <div style="{{ div_style }}">
      <span style = "{{ span_style }}">

      <!-- initialize variables used in following steps-->
        @{link_generate_variable_defaults}

      <!-- capture the full url of the dashboard including filters -->
        {% assign link = link_generator._link %}
        {% assign counter = 1 %}
        {% assign qualify_filter_names = false %}

      <!-- generate filters_mapping liquid variable passed into next step -->
        @{link_build_mappings_from_dash_bindings}
      <!-- generate dashboard_url liquid variable used below-->
        @{link_generate_dashboard_variable}




      {% assign focus_page = parameter_navigation_focus_page._parameter_value | times: 1 %}

      {% if parameter_navigation_focus_page._in_query and counter == focus_page %}
        <span style="{{ focus_page_style }}">{{ dash_label }}</span>
        {% elsif _explore._dashboard_url == target_dashboard %}
        <span style="{{ focus_page_style }}">{{ dash_label }}</span>
        {% else %}
        <a style="{{ page_style }}" href="{{ dashboard_url }}">{{ dash_label }}</a>
      {% endif %}
      <!-- increment counter by 1 -->
      {% assign counter = counter | plus: 1 %}
      {% endfor %}
      </span>
      </div>

      ;;
  }

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }

#} derive navigation_links
}
