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
*      out->write( asdas ).
*      out->write( '-----' ).
      DATA(matcher) = cl_abap_matcher=>create( pattern     = '<([!A-Za-z][A-Za-z0-9]*)([^>]*)>|</([A-Za-z][A-Za-z0-9]*)>'
*                                             text        = '<td class=center>1</td><td class=center></td><td>Python</td><td class=right>31.17 %</td><td class=\"right optCol\">+4.3 %</td></tr>\'
                                               text = asdas
                                               ignore_case = abap_true ).

      IF matcher->replace_all( ` ` ) > 0.
*      out->write( matcher->text ).
*        DATA(matcher2) = matcher->text.
        DATA(result) = substring_after( val = matcher->text sub = '\' ).
        REPLACE ALL OCCURRENCES OF REGEX ' %' IN result WITH '%'.

        REPLACE ALL OCCURRENCES OF REGEX ' +' IN result WITH ` `.

        out->write( result ).
      ELSE.
*        out->write( |Keine Tags gefunden.| ).
      ENDIF.


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
