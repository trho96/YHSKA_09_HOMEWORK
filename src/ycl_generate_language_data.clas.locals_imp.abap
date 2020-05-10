*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_http_client DEFINITION
    FINAL
    CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS:
      request_language_data
        IMPORTING im_url         TYPE string
        RETURNING VALUE(lo_response_text) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
          lc_content TYPE string.
ENDCLASS.

CLASS lcl_http_client IMPLEMENTATION.
  METHOD request_language_data.
    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( im_url ).
    DATA(lo_http) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
    DATA(lo_request) = lo_http->get_http_request( ).
    DATA(lo_reponse) = lo_http->execute( i_method = if_web_http_client=>get ).
    lo_response_text = lo_reponse->get_text(  ).
*    SPLIT lo_response_text AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_ctab.

  ENDMETHOD.

ENDCLASS.
