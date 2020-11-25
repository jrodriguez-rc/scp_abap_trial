CLASS zcl_rslt_redirect DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rslt_redirect IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

*    response->set_text( |{ request->get_header_field( '~path' ) }| ).

    response->set_text(
        REDUCE #(
            INIT text TYPE string
            FOR header IN request->get_header_fields( )
*            FOR header IN request->get_form_fields_cs( )
            NEXT text =
                COND #(
                    LET header_field = |{ header-name }: { header-value }|
                        IN WHEN text IS INITIAL
                               THEN header_field
                               ELSE |{ text }<br>{ header_field }| ) ) ).

*    response->set_status( 302 ).
*
*    response->set_header_field(
*        i_name  = 'Location'
*        i_value = '/sap/bc/http/sap/zrslt_hello_world/?sap-client=100' ).

  ENDMETHOD.


ENDCLASS.
