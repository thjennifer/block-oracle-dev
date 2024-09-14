<h1><span style="color:#2d7eea">Google Cloud Cortex Framework for Oracle EBS</span></h1>

<h2><span style="color:#2d7eea">What does this Looker Block do for me?</span></h2>

Jumpstart your Order-to-Cash (aka O2C, or OTC) operational reports journey on BigQuery in a rapid and cost-effective manner. Leverage or customize this Looker model to:
* Identify trends and patterns in your data
* Spot potential problems early on
* Make better decisions faster

<h2><span style="color:#2d7eea">Included Dashboards</span></h2>

<h3> Order to Cash Operational Reports </h3>

| **Dashboard** | **Description**                            |
|---------------|--------------------------------------------|
| **Order Status** | Overview of order-related metrics, including order volume, a breakdown of the order flow status from booking to billing, and an analysis of order status. |
| **Sales Performance** | Insights into top sales performers including items, categories, customers, business units, and order sources. |
| **Order Fulfillment** | Tracks fulfillment performance over time, highlighting items with the longest average order cycle time and those experiencing fulfillment challenges. |
| **Order Line Details** | View details of a subset of sales orders satisfying a set of filter criteria.  For example, see details of all blocked orders in a given time frame. |
| **Billing & Invoicing** | Overview of invoice volume and amounts including monthly trends. Also highlights customers with highest discounts. |
| **Accounts Receivables** | Analyzes current and overdue receivables, identifying customers with highest outstanding amounts and duration of overdue payments. |
| **Invoice Line Details** | View details of a subset of invoices satisfying a set of filter criteria.  For example, see details of all open invoices in a given time frame. |

<h2><span style="color:#2d7eea">Required Data</span></h2>

Get the required BigQuery datasets for this block by following the installation instructions for [Google Cloud Cortex Framework](https://github.com/GoogleCloudPlatform/cortex-data-foundation).

<h2><span style="color:#2d7eea">Installation Instructions</span></h2>

Manually install this LookML Model following one of the options below.

<h4><span style="color:#2d7eea">Option A: Marketplace Install via Git</span></h4>

Refer to the Looker documentation for [Installing a Tool from a Git URL](https://cloud.google.com/looker/docs/marketplace#installing_a_tool_from_a_git_url). Provide values for the required prompts as outlined in next section **Required Parameters**.

<h4><span style="color:#2d7eea">Option B: Manual Install via Fork of this Repository</span></h4>

  * [Fork this GitHub repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository)
  * [Create a blank LookML project](https://cloud.google.com/looker/docs/create-projects#creating_a_blank_project) with any name (e.g., cortex_oracle_ebs)
  * [Connect the new LookML project to the forked repository](https://cloud.google.com/looker/docs/setting-up-git-connection)
  * Update the values of constants in the `manifest.lkml` file as described in the next section **Required Parameters**
  * [Commit and deploy changes to production](https://cloud.google.com/looker/docs/version-control-and-deploying-changes#getting_your_changes_to_production)

With the Looker project based on your forked repository, you can customize the LookML to fit your unique business needs.

<h2><span style="color:#2d7eea"> Required Parameters</span></h2>
> ⚠️ These required values are configured during the Marketplace Installation process, or if this model was installed from a forked Git repository, you will update the values for these constants in the `manifest.lkml` file for the project.

- **CONNECTION NAME**: Name of the BigQuery Connection allowing Looker to query the Cortex Framework REPORTING dataset.

- **GCP PROJECT ID**: The GCP project where the Oracle EBS reporting dataset resides in BigQuery (i.e., GCP project ID). [Identifying Project ID](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects).

- **REPORTING DATASET**: The deployed Cortex Framework REPORTING dataset where the Oracle EBS views reside within the GCP BigQuery project.


<h2><span style="color:#2d7eea"> Persistent Derived Tables Required</span></h2>

The BigQuery connection used for this block must have [Persistent Derived Tables](https://cloud.google.com/looker/docs/derived-tables#persistent_derived_tables) enabled. For more information, see [Enabling PDTs on a Connection](https://cloud.google.com/looker/docs/db-config-google-bigquery#creating_a_temporary_dataset_for_persistent_derived_tables).

<h2><span style="color:#2d7eea"> Required User Attributes</span></h2>

The included dashboards and Explores require these Looker [user attributes](https://cloud.google.com/looker/docs/admin-panel-users-user-attributes) to work properly.

A Looker Admin should create the following user attributes and set their default values.
> ⚠️ Name each user attribute exactly as listed below:

| **Required User Attribute Name** | **Label**                            | **Data Type** | **User Access** | **Hide Value** | **Default Value** |
|----------------------------------|--------------------------------------|---------------|-----------------|----------------|-------------------|
| cortex_oracle_ebs_category_set_name  | Cortex Oracle EBS: Category Set Name      | String        | Edit            | No             | Primary Category Set Name used in your EBS system. If using Cortex Framework test data, the default value equals BE_INV_ITEM_CATEGORY_SET |
| cortex_oracle_ebs_default_language   | Cortex Oracle EBS: Default Language  | String        | Edit            | No             | **US** (or primary language code used in your EBS system). If using Cortex Test data, the available values are US (English) and ES (Spanish) |
| cortex_oracle_ebs_default_currency | Cortex Oracle EBS: Default Target Currency | String | Edit | No | **USD** or desired currency like EUR, CAD or JPY |
| cortex_oracle_ebs_use_test_data | Cortex Oracle EBS: Use Test Data (Yes or No) | String | Edit | No | Enter **Yes** if using Cortex Framework test  data. Otherwise, enter No |

Each dashboard user can personalize these values by following these [instructions](https://cloud.google.com/looker/docs/user-account).

<h2><span style="color:#2d7eea">Test Data</span></h2>
When utilizing the **optional** test data with this block, consider the following key points:

- **Timeframes**: The test data covers Sales Orders from January 1, 2021 to April 4, 2024 and Invoices & Payments from January 2, 2021 to March 31, 2024.
- **Date Adjustment**: When using test data (user attribute `cortex_oracle_ebs_use_test_data` is set to `Yes`), the current date is replaced with March 31, 2024 for calculations. This ensures accurate calculations for dimensions like age of receivables.
- **Category Set**: The only available Category Set ID / Category Set Name is `1100000425 / BE_INV_ITEM_CATEGORY_SET`. The user attribute **cortex_oracle_ebs_category_set_name** should be set to `BE_INV_ITEM_CATEGORY_SET`.
- **Business Unit**: Test data includes only one Business Unit named `BE1 operating unit`.
- **Tax Amount**: In _Sales Invoices_ and _Sales Invoices Daily Agg_, the tax amount is 0 for all records.
- **Intercompany**: For all records `Is_Intercompany` is set to No.
- **Multiple languages and currencies**: To showcase multiple languages and currencies in the test data, during the deployment of [Cortex Framework for Oracle EBS](https://github.com/GoogleCloudPlatform/cortex-data-foundation), include USD and EUR as currency conversion targets and US and ES as languages. The following is a sample snippet from the `config.json` file used in a deployment:

```
"OracleEBS": {
       "itemCategorySetIds": [1100000425],
        "currencyConversionType": "Corporate",
        "currencyConversionTargets": ["USD","EUR"],
        "languages": ["US","ES"],
        "datasets": {
            "cdc": "CORTEX_ORACLE_EBS_CDC",
            "reporting": "CORTEX_ORACLE_EBS_REPORTING"
        }
    },
```

<h2><span style="color:#2d7eea">Other Considerations</span></h2>

- **Liquid Templating Language**: Some constants, views, Explores and dashboard use liquid templating language. For more information, see Looker's [Liquid Variable Reference](https://cloud.google.com/looker/docs/liquid-variable-reference) documentation.

- **(Optional) Unhide additional dimensions and measures**: Many dimensions and measures are hidden for simplicity. If you find anything valuable missing, update the field's `hidden` parameter value **no** in the relevant views.

<h2><span style="color:#2d7eea">Additional Resources</span></h2>

To learn more about LookML and how to develop visit:
- [Looker Best Practices](https://cloud.google.com/looker/docs/best-practices/home)
- [Looker/Google Cloud Training](https://www.cloudskillsboost.google/catalog)
