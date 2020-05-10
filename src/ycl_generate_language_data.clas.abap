CLASS ycl_generate_language_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
            lv_html_table TYPE string_table.
ENDCLASS.



CLASS ycl_generate_language_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(lv_url) = |http://pypl.github.io/PYPL.html|.
    DATA(lv_http_client) = NEW lcl_http_client(  ).
    DATA(lt_html) = lv_http_client->request_language_data( EXPORTING im_url = lv_url ).
    out->write( lt_html ).
  ENDMETHOD.

ENDCLASS.
