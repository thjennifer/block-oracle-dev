connection: "@{CONNECTION_NAME}"

label: "Cortex Oracle EBS"

include: "/explores/*.explore"
include: "/dashboards/*.dashboard"
include: "/components/*.lkml"

#--> default of 12 hours cache
persist_with: default_max_cache
