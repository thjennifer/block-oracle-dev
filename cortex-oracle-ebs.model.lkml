connection: "@{CONNECTION_NAME}"

label: "Cortex Oracle EBS"

include: "/explores/*.explore"
include: "/dashboards/*.dashboard"
include: "/components/*.lkml"

#--> The cache is invalidated when either the maximum cache age surpasses 12 hours or
#    when the maximum value for the Last Update Timestamp in Sales Orders changes.
persist_with: oracle_ebs_default_datagroup
