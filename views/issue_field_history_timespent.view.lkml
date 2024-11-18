view: issue_field_history_timespent {
  derived_table: {
    sql:
      select
        * replace(cast(value as float64) as value),
        cast(value as float64) - coalesce(
          lag(cast(value as float64)) over (partition by issue_id order by time), 0
        ) as time_spent
      from @{SCHEMA_NAME}.issue_field_history
      where field_id = 'timespent' and value is not null
    ;;
  }

  dimension: issue_id {
    type: number
    sql: ${TABLE}.issue_id ;;
  }

  dimension: field_id {
    type: string
    sql: ${TABLE}.field_id ;;
  }

  dimension: author_id {
    type: string
    sql: ${TABLE}.author_id ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

  dimension_group: time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
    ]
    sql: ${TABLE}.time ;;
  }

  # Create a custom primary key using author_id, issue_id and field_id and time.
  dimension: id {
    primary_key: yes
    type: string
    sql:
      ${author_id}
      || ${issue_id}
      || ${field_id}
      || ${TABLE}.time
    ;;
  }

  dimension: time_spent {
    type: number
    sql: ${TABLE}.time_spent ;;
  }


  measure: number_of_issues {
    type: count_distinct
    sql: ${TABLE}.issue_id ;;
  }

  measure: total_time_spent {
    type: sum
    sql: ${time_spent} ;;
  }
}
