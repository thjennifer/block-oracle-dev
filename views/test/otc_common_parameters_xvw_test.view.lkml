include: "/views/core/otc_common_parameters_xvw.view"

view: +otc_common_parameters_xvw {

    parameter: parameter_use_test_or_demo_data {
      hidden: yes
      # type: unquoted
      # label: "Use Test or Demo Data"
      # allowed_value: {label: "test" value:"CORTEX_ORACLE_EBS_REPORTING_VISION"}
      # allowed_value: {label: "demo" value: "CORTEX_ORACLE_EBS_REPORTING"}
      # default_value: "demo"
    }

    parameter: parameter_use_demo_or_test_data {
      label: "Use Test or Demo Data"
      type: unquoted
      allowed_value: {label: "test" value:"test"}
      allowed_value: {label: "demo" value: "demo"}
      default_value: "demo"
    }


   }
