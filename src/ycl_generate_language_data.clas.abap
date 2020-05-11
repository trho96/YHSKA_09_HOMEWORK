CLASS ycl_generate_language_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      lv_html_table TYPE string_table,
      lt_lang_db    TYPE STANDARD TABLE OF yhska09_language.

ENDCLASS.



CLASS ycl_generate_language_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(lv_url) = |http://pypl.github.io/PYPL.html|.
    DATA(lv_http_client) = NEW lcl_http_client(  ).
    DATA(lt_html) = lv_http_client->request_language_data( EXPORTING im_url = lv_url ).

    LOOP AT lt_html INTO DATA(asdas) WHERE table_line CS 'table = "<!-- begin section All-->\'.
      DATA(matcher) = cl_abap_matcher=>create( pattern     = '<([!A-Za-z][A-Za-z0-9]*)([^>]*)>|</([A-Za-z][A-Za-z0-9]*)>'
                                               text = asdas
                                               ignore_case = abap_true ).

      IF matcher->replace_all( `_` ) > 0.

        DATA(result) = substring_from( val = matcher->text sub = '_1' ).
        REPLACE ALL OCCURRENCES OF REGEX ' %' IN result WITH ''.


        REPLACE ALL OCCURRENCES OF REGEX '\n' IN result WITH ``.

        SPLIT result AT '\' INTO TABLE DATA(itab).

        DATA: lv_cnt TYPE i.
        lv_cnt = 1.
        LOOP AT itab INTO DATA(line).
* out->write( line ).

          DATA(matcherline) = cl_abap_matcher=>create( pattern     = '_+([0-9]+)_+([^_]+)_+([^_]+)_+([^_]+)_+.*'
                                               text = line
                                               ignore_case = abap_true ).
          IF abap_true = matcherline->match( ).
            DATA(lo_lang_data) = VALUE yhska09_language( language_id = lv_cnt
                                                         rank = matcherline->get_submatch( 1 )
                                                         name = matcherline->get_submatch( 2 )
                                                         popularity = matcherline->get_submatch( 3 )
                                                         trend = matcherline->get_submatch( 4 )
                                                         region = 'All').
            APPEND lo_lang_data TO lt_lang_db.
            lv_cnt = lv_cnt + 1.
          ENDIF.

        ENDLOOP.
      ELSE.
*        out->write( |Keine Tags gefunden.| ).
      ENDIF.

    ENDLOOP.
    DELETE FROM yhska09_language.
    INSERT yhska09_language FROM TABLE @lt_lang_db.

    SELECT * FROM yhska09_language INTO TABLE @lt_lang_db.
    out->write( sy-dbcnt ).
    out->write( 'Programming Language data inserted successfully!').

  ENDMETHOD.

ENDCLASS.
