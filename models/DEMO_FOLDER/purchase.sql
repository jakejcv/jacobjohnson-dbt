{{
  config(
      materialized='incremental',
      incremental_strategy='merge',
      unique_key='PURCHASE_ID',
      merge_exclude_columns=['INSERT_DTS']
  )
}}

with purchase_src as (

    select
        purchase_id,
        purchase_date,
        purchase_status,
        created_at,
        current_timestamp as insert_dts,
        current_timestamp as update_dts
    from {{ source('purchase', 'PURCHASE_SRC') }}

    {% if is_incremental() %}
    where created_at > coalesce(
        (select max(created_at) from {{ this }}),
        '1900-01-01'::timestamp
    )
    {% endif %}

    qualify row_number() over (
        partition by purchase_id
        order by created_at desc
    ) = 1

)

select *
from purchase_src
