view: issue_field_history_timespent {

  sql_table_name: @{SCHEMA_NAME}.issue_field_history ;;
  sql_always_where: ${field_id} = 'timespent' ;;

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._FIVETRAN_SYNCED ;;
  }

  dimension: issue_id {
    type: number
    sql: ${TABLE}.ISSUE_ID ;;
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
      year
    ]
    sql: ${TABLE}.TIME ;;
  }

  # Create a custom primary key using author_id, issue_id and field_id and time.
  dimension: id {
    primary_key: yes
    type: string
    sql: CONCAT(${author_id}, '-', ${issue_id}, '-', ${field_id}, ${TABLE}.TIME) ;;
  }

  dimension: time_spent {
    type: number
    sql: CASE 
            WHEN ${issue_field_history_timespent.field_id} = 'timespent' 
            THEN CAST(${issue_field_history_timespent.value} as numeric)
            ELSE NULL 
          END ;;
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
