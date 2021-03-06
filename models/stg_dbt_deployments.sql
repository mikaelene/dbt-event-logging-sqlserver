with events as (

    select * from {{ref('stg_dbt_audit_log')}}

),

aggregated as (

    select 
    
        invocation_id,
    
        min(case 
            when event_name = 'run started' then event_timestamp 
            end) as deployment_started_at,
    
        min(case 
            when event_name = 'run completed' then event_timestamp 
            end) as deployment_completed_at,
            
        count(distinct case 
            when left(event_name,5) = 'model' then event_model 
            end) as models_deployed
    
    from events
    group by invocation_id

)

select * from aggregated