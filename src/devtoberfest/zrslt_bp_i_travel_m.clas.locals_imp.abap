CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features  FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR travel RESULT result.

    METHODS set_status_completed  FOR MODIFY
      IMPORTING keys FOR ACTION travel~acceptTravel RESULT result.

    METHODS set_status_cancelled  FOR MODIFY
      IMPORTING keys FOR ACTION travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATION travel~validateCustomer
      IMPORTING keys FOR travel.

    METHODS validateDates FOR VALIDATION travel~validateDates
      IMPORTING keys FOR travel.

    METHODS validateOverallStatus FOR VALIDATION travel~validateOverallStatus
      IMPORTING keys FOR travel.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.


  METHOD get_features.

    READ ENTITY ZRSLT_I_Travel_M
         FIELDS ( travel_id overall_status )
           WITH VALUE #( FOR keyval IN keys ( %key = keyval-%key ) )
         RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result
                       ( %key                           = ls_travel-%key
                         %field-travel_id               = if_abap_behv=>fc-f-read_only
                         %features-%action-rejectTravel = COND #( WHEN ls_travel-overall_status = 'X'
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                                      ELSE if_abap_behv=>fc-o-enabled  )
                         %features-%action-acceptTravel = COND #( WHEN ls_travel-overall_status = 'A'
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                                      ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).

  ENDMETHOD.


  METHOD set_status_cancelled.

    MODIFY ENTITIES OF ZRSLT_I_Travel_M  IN LOCAL MODE
           ENTITY travel
              UPDATE FROM VALUE #( FOR key IN keys ( travel_id = key-travel_id
                                                     overall_status = 'X'   " Canceled
                                                     %control-overall_status = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " read changed data for result
    READ ENTITIES OF ZRSLT_I_Travel_M IN LOCAL MODE
     ENTITY travel
       FIELDS ( agency_id
                customer_id
                begin_date
                end_date
                booking_fee
                total_price
                currency_code
                overall_status
                description
                created_by
                created_at
                last_changed_at
                last_changed_by )
         WITH VALUE #( FOR key IN keys ( travel_id = key-travel_id ) )
     RESULT DATA(lt_travel).

    result = VALUE #( FOR travel IN lt_travel ( travel_id = travel-travel_id
                                                %param    = travel
                                              ) ).

  ENDMETHOD.


  METHOD set_status_completed.

    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF ZRSLT_I_Travel_M IN LOCAL MODE
           ENTITY travel
              UPDATE FIELDS ( overall_status )
                 WITH VALUE #( FOR key IN keys ( travel_id      = key-travel_id
                                                 overall_status = 'A' ) ) " Accepted
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF ZRSLT_I_Travel_M IN LOCAL MODE
         ENTITY travel
           FIELDS ( agency_id
                    customer_id
                    begin_date
                    end_date
                    booking_fee
                    total_price
                    currency_code
                    overall_status
                    description
                    created_by
                    created_at
                    last_changed_at
                    last_changed_by )
             WITH VALUE #( FOR key IN keys ( travel_id = key-travel_id ) )
         RESULT DATA(lt_travel).

    result = VALUE #( FOR travel IN lt_travel ( travel_id = travel-travel_id
                                                %param    = travel ) ).

  ENDMETHOD.


  METHOD validateCustomer.

    DATA:
      lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    READ ENTITY ZRSLT_I_Travel_M\\travel FIELDS ( customer_id ) WITH
        VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
        RESULT DATA(lt_travel).

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = customer_id EXCEPT * ).
    DELETE lt_customer WHERE customer_id IS INITIAL.
    CHECK lt_customer IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM /dmo/customer FIELDS customer_id
      FOR ALL ENTRIES IN @lt_customer
      WHERE customer_id = @lt_customer-customer_id
      INTO TABLE @DATA(lt_customer_db).

    " Raise msg for non existing customer id
    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-customer_id IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id = ls_travel-customer_id ] ).
        APPEND VALUE #(  travel_id = ls_travel-travel_id ) TO failed.
        APPEND VALUE #(  travel_id = ls_travel-travel_id
                         %msg      = new_message( id       = '/DMO/CM_FLIGHT_LEGAC'
                                                  number   = '002'
                                                  v1       = ls_travel-customer_id
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-customer_id = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validateDates.

    READ ENTITY ZRSLT_I_Travel_M\\travel FIELDS ( begin_date end_date )  WITH
            VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
            RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).

      IF ls_travel_result-end_date < ls_travel_result-begin_date.  "end_date before begin_date

        APPEND VALUE #( %key        = ls_travel_result-%key
                        travel_id   = ls_travel_result-travel_id ) TO failed.

        APPEND VALUE #( %key     = ls_travel_result-%key
                        %msg     = new_message( id       = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
                                                number   = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
                                                v1       = ls_travel_result-begin_date
                                                v2       = ls_travel_result-end_date
                                                v3       = ls_travel_result-travel_id
                                                severity = if_abap_behv_message=>severity-error )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date   = if_abap_behv=>mk-on ) TO reported.

      ELSEIF ls_travel_result-begin_date < cl_abap_context_info=>get_system_date( ).  "begin_date must be in the future

        APPEND VALUE #( %key        = ls_travel_result-%key
                        travel_id   = ls_travel_result-travel_id ) TO failed.

        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message( id       = /dmo/cx_flight_legacy=>begin_date_before_system_date-msgid
                                            number   = /dmo/cx_flight_legacy=>begin_date_before_system_date-msgno
                                            severity = if_abap_behv_message=>severity-error )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date   = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validateoverallstatus.

    READ ENTITY ZRSLT_I_Travel_M\\travel FIELDS ( overall_status )  WITH
            VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
            RESULT DATA(lt_travel).

    " Raise msg for invalid status
    LOOP AT lt_travel INTO DATA(ls_travel) WHERE NOT overall_status CA 'AX'.

      APPEND VALUE #( travel_id = ls_travel-travel_id ) TO failed.
      APPEND VALUE #( travel_id = ls_travel-travel_id
                      %msg      = new_message( id       = '/DMO/CM_FLIGHT_LEGAC'
                                               number   = '007'
                                               v1       = ls_travel-overall_status
                                               severity = if_abap_behv_message=>severity-error )
                      %element-overall_status = if_abap_behv=>mk-on ) TO reported.

    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
