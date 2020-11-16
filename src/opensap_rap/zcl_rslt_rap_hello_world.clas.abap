CLASS zcl_rslt_rap_hello_world DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_RSLT_RAP_HELLO_WORLD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |Hello World! ({ cl_abap_context_info=>get_user_alias( ) })| ).

  ENDMETHOD.
ENDCLASS.
