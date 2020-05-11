CLASS ycl_generate_language_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    DATA:
      cnt        TYPE i,
      lt_lang_db TYPE STANDARD TABLE OF yhska09_language.
  PRIVATE SECTION.
    DATA:
      lv_html_table TYPE string_table.


ENDCLASS.



CLASS ycl_generate_language_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(lv_url) = |http://pypl.github.io/PYPL.html|.
    DATA(lv_http_client) = NEW lcl_http_client(  ).
    DATA(lt_html) = lv_http_client->request_language_data( EXPORTING im_url = lv_url ).
    DATA(lv_html_parser) = NEW lcl_html_parser( im_html = lt_html ).
    cnt = 1.
    lv_html_parser->get_data( EXPORTING im_region = 'ALL'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'DE'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'US'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'IN'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'GB'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'FR'
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).
    DELETE FROM yhska09_language.
    INSERT yhska09_language FROM TABLE @lt_lang_db.

    SELECT * FROM yhska09_language INTO TABLE @lt_lang_db.
    out->write( sy-dbcnt ).
    out->write( 'Programming Language data inserted successfully!').

  ENDMETHOD.

ENDCLASS.
