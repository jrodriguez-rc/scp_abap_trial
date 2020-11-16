CLASS zcl_rslt_api_hub_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.

    METHODS get_bank_details
      RETURNING
        VALUE(result) TYPE string.

    METHODS get_ehs_locations
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
      url         TYPE string VALUE 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/',
      http_client TYPE REF TO if_web_http_client.

ENDCLASS.



CLASS ZCL_RSLT_API_HUB_MANAGER IMPLEMENTATION.


  METHOD constructor.

    http_client = cl_web_http_client_manager=>create_by_http_destination(
                i_destination = cl_http_destination_provider=>create_by_url( url ) ).

  ENDMETHOD.


  METHOD get_bank_details.

    DATA(request) = http_client->get_http_request( ).

    request->set_header_fields( VALUE #( ( name = 'Content-Type' value = 'application/json' )
                                         ( name = 'Accept'       value = 'application/json' )
                                         ( name = 'APIKey'       value = 'PINeeImNM356GRdHY4UEHfj8agAwJ0hG') ) ).

    request->set_uri_path( i_uri_path = url && 'API_BANKDETAIL_SRV/A_BankDetail?$top=25&$format=json' ).

    TRY.
        DATA(response) = http_client->execute( i_method = if_web_http_client=>get )->get_text(  ).
      CATCH cx_web_http_client_error.
        CLEAR: response.
    ENDTRY.

    result = response.

  ENDMETHOD.


  METHOD get_ehs_locations.

    DATA(request) = http_client->get_http_request( ).

    request->set_header_fields( VALUE #( ( name = 'Content-Type' value = 'application/json' )
                                         ( name = 'Accept'       value = 'application/json' )
                                         ( name = 'APIKey'       value = 'PINeeImNM356GRdHY4UEHfj8agAwJ0hG') ) ).

    request->set_uri_path( i_uri_path = url && 'API_EHS_REPORT_INCIDENT_SRV/A_Location?$format=json' ).

    TRY.
        DATA(response) = http_client->execute( i_method = if_web_http_client=>get )->get_text(  ).
      CATCH cx_web_http_client_error.
        CLEAR: response.
    ENDTRY.

    result = response.

  ENDMETHOD.
ENDCLASS.
