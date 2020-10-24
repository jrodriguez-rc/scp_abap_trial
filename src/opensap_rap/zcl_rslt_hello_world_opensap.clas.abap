CLASS zcl_rslt_hello_world_opensap DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rslt_hello_world_opensap IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |Hello World! ({ cl_abap_context_info=>get_user_alias( ) })| ).

  ENDMETHOD.


ENDCLASS.
