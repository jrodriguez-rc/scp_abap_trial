CLASS zcl_rslt_hello_world DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS exercise_1_1
      IMPORTING
        request  TYPE REF TO if_web_http_request
        response TYPE REF TO if_web_http_response.

    METHODS exercise_1_2
      IMPORTING
        request  TYPE REF TO if_web_http_request
        response TYPE REF TO if_web_http_response.

ENDCLASS.



CLASS zcl_rslt_hello_world IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    exercise_1_2( request  = request
                  response = response ).

  ENDMETHOD.


  METHOD exercise_1_1.

    response->set_text( |Hello world!| ).

  ENDMETHOD.


  METHOD exercise_1_2.

    DATA(parameters) = request->get_form_fields(  ).

    TRY.
        DATA(parameter) = REF #( parameters[ name = 'cmd' ] ).
      CATCH cx_sy_itab_line_not_found.
        response->set_status( i_code = 400 i_reason = 'Bad request').
        RETURN.
    ENDTRY.

    CASE parameter->value.
      WHEN `hello`.
        response->set_text( |Hello World! | ).

      WHEN `timestamp`.
        response->set_text( |Hello World! application executed by {
                             cl_abap_context_info=>get_user_technical_name( ) } | &&
                              | on { cl_abap_context_info=>get_system_date( ) DATE = ENVIRONMENT } | &&
                              | at { cl_abap_context_info=>get_system_time( ) TIME = ENVIRONMENT } | ).

      WHEN `bankdetails`.
        response->set_text( NEW zcl_rslt_api_hub_manager(  )->get_bank_details( ) ).

      WHEN `ehsLocations`.
        response->set_text( NEW zcl_rslt_api_hub_manager(  )->get_ehs_locations( ) ).

      WHEN OTHERS.
        response->set_status( i_code = 400 i_reason = 'Bad request').

    ENDCASE.

  ENDMETHOD.


ENDCLASS.
