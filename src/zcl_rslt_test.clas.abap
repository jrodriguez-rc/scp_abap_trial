CLASS zcl_rslt_test DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.

  PROTECTED SECTION.
    METHODS execute ABSTRACT
      RAISING
        cx_static_check
        cx_dynamic_check.

    METHODS write FINAL
      IMPORTING
        ig_data TYPE any
        iv_name TYPE csequence OPTIONAL.

  PRIVATE SECTION.
    DATA classrun_out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_rslt_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    classrun_out = out.

    TRY.
        execute( ).
      CATCH cx_root INTO DATA(lx_exception).
        write( lx_exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD write.
    classrun_out->write( data = ig_data name = CONV string( iv_name ) ).
  ENDMETHOD.


ENDCLASS.
