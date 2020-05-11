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

    LOOP AT lt_html INTO DATA(asdas) WHERE table_line CS 'table = "<!-- begin section All-->\'.
      DATA(matcher) = cl_abap_matcher=>create( pattern     = '<([!A-Za-z][A-Za-z0-9]*)([^>]*)>|</([A-Za-z][A-Za-z0-9]*)>'
                                               text = asdas
                                               ignore_case = abap_true ).

      IF matcher->replace_all( `_` ) > 0.

        DATA(result) = substring_from( val = matcher->text sub = '_1' ).
        REPLACE ALL OCCURRENCES OF REGEX ' %' IN result WITH ''.


        REPLACE ALL OCCURRENCES OF REGEX '\n' IN result WITH ``.

        SPLIT result AT '\' INTO TABLE DATA(itab).


        LOOP AT itab INTO DATA(line).
          out->write( line ).

          DATA(matcherline) = cl_abap_matcher=>create( pattern     = '_+(.+)____(.+)__(.+)__(.+)__.*'
                                               text = line
                                               ignore_case = abap_true ).
          IF abap_true = matcherline->match( ).
            out->write( matcherline->get_submatch( 1 ) ).   "Ranking
            out->write( matcherline->get_submatch( 2 ) ).   "Language
            out->write( matcherline->get_submatch( 3 ) ).   "Share
            out->write( matcherline->get_submatch( 4 ) ).   "Trend
          ENDIF.

        ENDLOOP.
      ELSE.
*        out->write( |Keine Tags gefunden.| ).
      ENDIF.


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
