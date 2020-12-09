CLASS zcl_generate_dev268_7137 DEFINITION
 PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS main REDEFINITION.
  PRIVATE SECTION.

    DATA package_name  TYPE sxco_package VALUE  'ZRSLT_TECHED_DEV268'.
    DATA unique_number TYPE string VALUE '7139'.
    DATA table_name_inventory  TYPE sxco_dbt_object_name.
    DATA dev_system_environment TYPE REF TO if_xco_cp_gen_env_dev_system.
    DATA transport TYPE sxco_transport .

    METHODS generate_table  IMPORTING io_put_operation        TYPE REF TO if_xco_cp_gen_d_o_put
                                      table_name              TYPE sxco_dbt_object_name
                                      table_short_description TYPE if_xco_cp_gen_tabl_dbt_s_form=>tv_short_description .

    METHODS get_json_string RETURNING VALUE(json_string) TYPE string.

ENDCLASS.

CLASS zcl_generate_dev268_7137 IMPLEMENTATION.
  METHOD main.

    package_name = to_upper( package_name ).

    DATA(lo_package) = xco_cp_abap_repository=>object->devc->for( package_name ).
    DATA(lv_package_software_component) = lo_package->read( )-property-software_component->name.
    DATA(lo_transport_layer) = lo_package->read(  )-property-transport_layer.
    DATA(lo_transport_target) = lo_transport_layer->get_transport_target( ).
    DATA(lv_transport_target) = lo_transport_target->value.
    DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lo_transport_target->value  )->create_request( | create tables |  ).
    DATA(lv_transport) = lo_transport_request->value.
    transport = lv_transport.
    dev_system_environment = xco_cp_generation=>environment->dev_system( lv_transport ).

    IF NOT lo_package->exists( ).

      RAISE EXCEPTION TYPE zcx_rap_generator
        EXPORTING
          textid   = zcx_rap_generator=>package_does_not_exist
          mv_value = CONV #( package_name ).

    ENDIF.

    DATA(lo_objects_put_operation) = dev_system_environment->create_put_operation( ).

    table_name_inventory = |ZRAP_INVEN_{ unique_number }|.

    DATA(json_string) = get_json_string(  ).

    generate_table(
      EXPORTING
        io_put_operation        = lo_objects_put_operation
        table_name              = table_name_inventory
        table_short_description = | Inventory data group { unique_number }|
    ).

    DATA(lo_result) = lo_objects_put_operation->execute( ).

    out->write( 'tables created' ).

    DATA(lo_findings) = lo_result->findings.
    DATA(lt_findings) = lo_findings->get( ).

    IF lt_findings IS NOT INITIAL.
      out->write( lt_findings ).
    ENDIF.

    "create RAP BO

    DATA(xco_api) = NEW zcl_rap_xco_cloud_lib( ).
    DATA(root_node) = NEW zcl_rap_node(  ).
    root_node->set_is_root_node( ).
    root_node->set_xco_lib( xco_api ).
    DATA(rap_bo_visitor) = NEW zcl_rap_xco_json_visitor( root_node ).
    DATA(json_data) = xco_cp_json=>data->from_string( json_string ).
    json_data->traverse( rap_bo_visitor ).
    DATA(rap_bo_generator) = NEW zcl_rap_bo_generator( root_node ).
    DATA(lt_todos) = rap_bo_generator->generate_bo(  ).

    out->write( | RAP BO { root_node->rap_root_node_objects-behavior_definition_i  } generated successfully | ).

  ENDMETHOD.


  METHOD generate_table.

    DATA(lo_specification) = io_put_operation->for-tabl-for-database_table->add_object( table_name
                )->set_package( package_name
                 )->create_form_specification( ).

    lo_specification->set_short_description( table_short_description ).
    lo_specification->set_delivery_class( xco_cp_database_table=>delivery_class->l ).
    lo_specification->set_data_maintenance( xco_cp_database_table=>data_maintenance->allowed ).


    DATA database_table_field  TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field  .

    database_table_field = lo_specification->add_field( 'CLIENT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'MANDT' ) )->set_key_indicator( )->set_not_null( ).

    database_table_field = lo_specification->add_field( 'UUID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYSUUID_X16' ) )->set_key_indicator( )->set_not_null( ).

    database_table_field = lo_specification->add_field( 'INVENTORY_ID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->numc( 6  ) ).

    database_table_field = lo_specification->add_field( 'PRODUCT_ID' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->char( 10  ) ).


    database_table_field = lo_specification->add_field( 'QUANTITY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->quan( iv_length = 13 iv_decimals = 3 ) ).
    database_table_field->currency_quantity->set_reference_table( CONV #( to_upper( table_name ) ) )->set_reference_field( 'QUANTITY_UNIT' ).

    database_table_field = lo_specification->add_field( 'QUANTITY_UNIT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->unit( 3  ) ).

    database_table_field = lo_specification->add_field( 'PRICE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->curr( iv_length = 16 iv_decimals = 2 ) ).
    database_table_field->currency_quantity->set_reference_table( CONV #( to_upper( table_name ) ) )->set_reference_field( 'CURRENCY_CODE' ).

    database_table_field = lo_specification->add_field( 'CURRENCY_CODE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->cuky ).

    database_table_field = lo_specification->add_field( 'REMARK' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>built_in_type->char( 256  ) ).

    database_table_field = lo_specification->add_field( 'NOT_AVAILABLE' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'ABAP_BOOLEAN' ) ).

    database_table_field = lo_specification->add_field( 'CREATED_BY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYUNAME' ) ).

    database_table_field = lo_specification->add_field( 'CREATED_AT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'TIMESTAMPL' ) ).

    database_table_field = lo_specification->add_field( 'LAST_CHANGED_BY' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'SYUNAME' ) ).

    database_table_field = lo_specification->add_field( 'LAST_CHANGED_AT' ).
    database_table_field->set_type( xco_cp_abap_dictionary=>data_element( 'TIMESTAMPL' ) ).

  ENDMETHOD.

  METHOD get_json_string.

    json_string ='{' && |\r\n|  &&
                 '  "implementationType": "managed_uuid",' && |\r\n|  &&
                 '  "namespace": "Z",' && |\r\n|  &&
                 |  "suffix": "_{ unique_number }",| && |\r\n|  &&
                 '  "prefix": "RAP_",' && |\r\n|  &&
                 |  "package": "{ package_name }",| && |\r\n|  &&
                 '  "datasourcetype": "table",' && |\r\n|  &&
*                 '  "bindingtype": "odata_v2_ui",' && |\r\n|  &&
                 '  "hierarchy": {' && |\r\n|  &&
                 '    "entityName": "Inventory",' && |\r\n|  &&
                 |    "dataSource": "zrap_inven_{ unique_number }",| && |\r\n|  &&
                 '    "objectId": "inventory_id"    ' && |\r\n|  &&
                 '    }' && |\r\n|  &&
                 '}'.

  ENDMETHOD.

ENDCLASS.
