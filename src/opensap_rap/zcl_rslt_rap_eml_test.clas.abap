CLASS zcl_rslt_rap_eml_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS:
      test_travel_uuid TYPE sysuuid_x16 VALUE 'B33217D08BB6924D170009027659A94B' ##NO_TEXT.

    DATA:
      out TYPE REF TO if_oo_adt_classrun_out.

    METHODS step1.

    METHODS step2.

    METHODS step3.

    METHODS step4.

    METHODS step5.

    METHODS step6.

    METHODS step7.

    METHODS step8.

    METHODS write
      IMPORTING
        data          TYPE any
        name          TYPE string OPTIONAL
      RETURNING
        VALUE(output) TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_rslt_rap_eml_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    step1( ).
*    step2( ).
*    step3( ).
*    step4( ).
*    step5( ).
*    step6( ).
*    step7( ).
*    step8( ).

  ENDMETHOD.


  METHOD write.

    output = out->write( data = data name = name ).

  ENDMETHOD.


  METHOD step1.

    " Step 1 - Read
    READ ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY Travel
        FROM VALUE #( ( TravelUUID = test_travel_uuid ) )
      RESULT DATA(travels).

    write( travels ).

  ENDMETHOD.


  METHOD step2.

    " Step 2 - Read with fields
    READ ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY Travel
        FIELDS ( AgencyID CustomerID )
        WITH VALUE #( ( TravelUUID = test_travel_uuid ) )
      RESULT DATA(travels).

    write( travels ).

  ENDMETHOD.


  METHOD step3.

    " Step 3 - Read with all fields
    READ ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY Travel
        ALL FIELDS
        WITH VALUE #( ( TravelUUID = test_travel_uuid ) )
      RESULT DATA(travels).

    write( travels ).

  ENDMETHOD.


  METHOD step4.

    " Step 4 - Read by association
    READ ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY Travel BY \_Booking
        ALL FIELDS
        WITH VALUE #( ( TravelUUID = test_travel_uuid ) )
      RESULT DATA(bookings).

    write( bookings ).

  ENDMETHOD.


  METHOD step5.

    " Step 5 - Unsuccessful READ
    READ ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY travel
        ALL FIELDS WITH VALUE #( ( TravelUUID = '11111111111111111111111111111111' ) )
      RESULT DATA(travels)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    write( travels ).
    write( failed ).    " complex structures not supported by the console output
    write( reported ).  " complex structures not supported by the console output

  ENDMETHOD.


  METHOD step6.

    " Step 6 - MODIFY Update
    MODIFY ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY travel
        UPDATE
          SET FIELDS WITH VALUE
            #( ( TravelUUID  = test_travel_uuid
                 Description = 'I like RAP@openSAP' ) )
     FAILED DATA(failed)
     REPORTED DATA(reported).

    write( 'Update done' ).

    " Step 6b - Commit Entities
    COMMIT ENTITIES
      RESPONSE OF ZI_RSLT_RAP_Travel
      FAILED     DATA(failed_commit)
      REPORTED   DATA(reported_commit).

  ENDMETHOD.


  METHOD step7.

    " Step 7 - MODIFY Create
    MODIFY ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY travel
        CREATE
          SET FIELDS WITH VALUE
            #( ( %cid        = 'MyContentID_1'
                 AgencyID    = '70012'
                 CustomerID  = '14'
                 BeginDate   = cl_abap_context_info=>get_system_date( )
                 EndDate     = cl_abap_context_info=>get_system_date( ) + 10
                 Description = 'I like RAP@openSAP' ) )
     MAPPED DATA(mapped)
     FAILED DATA(failed)
     REPORTED DATA(reported).

    out->write( mapped-travel ).

    COMMIT ENTITIES
      RESPONSE OF ZI_RSLT_RAP_Travel
      FAILED     DATA(failed_commit)
      REPORTED   DATA(reported_commit).

    write( 'Create done' ).

  ENDMETHOD.


  METHOD step8.

    " Step 8 - MODIFY Delete
    MODIFY ENTITIES OF ZI_RSLT_RAP_Travel
      ENTITY travel
        DELETE FROM
          VALUE
            #( ( TravelUUID  = '024DEF08E9B61EEB87A069F94BD3574B' ) )
     FAILED DATA(failed)
     REPORTED DATA(reported).

    COMMIT ENTITIES
      RESPONSE OF ZI_RSLT_RAP_Travel
      FAILED     DATA(failed_commit)
      REPORTED   DATA(reported_commit).

    write( 'Delete done' ).

  ENDMETHOD.


ENDCLASS.
