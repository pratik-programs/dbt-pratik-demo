update FIVETRAN_DATABASE.BUSINESS_LAYER.CUSTOMERS
set
    CUSTOMER_ID = stg.CUSTOMER_ID,
    EMAIL = stg.EMAIL,
    ZIP_CODE=  stg.ZIP_CODE,
    LAST_NAME = stg.LAST_NAME,
    CITY = stg.CITY,
    PHONE = stg.PHONE,
    FIRST_NAME = stg.FIRST_NAME,
    STATE = stg.STATE,
    STREET = stg.STREET,
    upd_ts = current_timestamp
from ref('customers')--FIVETRAN_DATABASE.AZURE_SQL_DB_RAW_SALES.CUSTOMERS stg
inner join FIVETRAN_DATABASE.BUSINESS_LAYER.CUSTOMERS dim on stg.customer_id = dim.customer_id
;

insert into FIVETRAN_DATABASE.BUSINESS_LAYER.CUSTOMERS (
    CUSTOMER_SK_ID,
    CUSTOMER_ID ,
	EMAIL,
	ZIP_CODE ,
	LAST_NAME,
	CITY ,
	PHONE ,
	FIRST_NAME ,
	STATE ,
	STREET,
    insert_ts,
    upd_ts
)
select
    cust_seq.nextval as CUSTOMER_SK_ID,
    stg.CUSTOMER_ID ,
	stg.EMAIL,
	stg.ZIP_CODE ,
	stg.LAST_NAME,
	stg.CITY ,
	stg.PHONE ,
	stg.FIRST_NAME ,
	stg.STATE ,
	stg.STREET,
    TO_TIMESTAMP_NTZ(stg._FIVETRAN_SYNCED),
    current_timestamp
    from ref('customers') --AZURE_SQL_DB_RAW_SALES.CUSTOMERS stg
    left join FIVETRAN_DATABASE.BUSINESS_LAYER.CUSTOMERS dim on stg.customer_id = dim.customer_id
	where _FIVETRAN_DELETED  = 'FALSE'
    and dim.customer_id is null;