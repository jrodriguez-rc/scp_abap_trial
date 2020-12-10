CLASS zcl_rslt_test_select DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM zcl_rslt_test.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS: execute REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rslt_test_select IMPLEMENTATION.


  METHOD execute.

    SELECT
      FROM /dmo/travel
      FIELDS
        uuid(  )      AS travel_uuid           ,
        travel_id     AS travel_id             ,
        agency_id     AS agency_id             ,
        customer_id   AS customer_id           ,
        begin_date    AS begin_date            ,
        end_date      AS end_date              ,
        booking_fee   AS booking_fee           ,
        total_price   AS total_price           ,
        currency_code AS currency_code         ,
        description   AS description           ,
        CASE status
          WHEN 'B' THEN 'A' " accepted
          WHEN 'X' THEN 'X' " cancelled
          ELSE 'O'          " open
        END           AS overall_status        ,
        createdby     AS created_by            ,
        createdat     AS created_at            ,
        lastchangedby AS last_changed_by       ,
        lastchangedat AS last_changed_at       ,
        lastchangedat AS local_last_changed_at
        INTO TABLE @DATA(selection).

  ENDMETHOD.


ENDCLASS.
