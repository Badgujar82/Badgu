connection: "thelook"

# include all the views
include: "/views/**/*.view"

datagroup: jb_thelook_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: jb_thelook_project_default_datagroup

explore: distribution_centers {}

#explore: etl_jobs {}

explore: events {
  join: users {
    type: inner
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  persist_for: "4 hours"
  sql_always_where: ${created_date} >= '2018-01-01' ;; #Filter to restrict order created in and after 2018
  always_filter: {
    filters: {
      field: order_items.created_date
      value: "1 year" # Default Filter for current year orders
    }
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    fields: [distribution_centers.name,distribution_centers.latitude,distribution_centers.longitude]
    relationship: many_to_one
  }
}

explore: users {}
