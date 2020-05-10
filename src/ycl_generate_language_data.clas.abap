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
*    out->write( lt_html ).

*    DATA: result_tab TYPE match_result_tab.
*    FIND regex '<td class=center>(.)<\/td><td class=center><\/td><td>(.*)<\/td><td class=right>(.*) %<\/td><td class=\\"right optCol\\">(.)(.*) %<\/td><\/tr>\\'
*    IN '<td class=center>1</td><td class=center></td><td>Python</td><td class=right>31.17 %</td><td class=\"right optCol\">+4.3 %</td></tr>\' RESULTS result_tab.
*    out->write( result_tab ).

    DATA(matcher) = cl_abap_matcher=>create( pattern     = '<([!A-Za-z][A-Za-z0-9]*)([^>]*)>|</([A-Za-z][A-Za-z0-9]*)>'
                                             text        = '<td class=center>1</td><td class=center></td><td>Python</td><td class=right>31.17 %</td><td class=\"right optCol\">+4.3 %</td></tr>'
                                             ignore_case = abap_true ).
    IF matcher->replace_all( ` ` ) > 0.
*      out->write( matcher->text ).
    ELSE.
      out->write( |Keine Tags gefunden.| ).
    ENDIF.

    DATA(matcher2) = matcher->text.
    REPLACE ALL OCCURRENCES OF REGEX ' %' IN matcher2 WITH '%'.

    REPLACE ALL OCCURRENCES OF REGEX ' +' IN matcher2 WITH ` `.

*    SPLIT matcher2 AT SPACE INTO ITAB
    out->write( matcher2 ).
  ENDMETHOD.

ENDCLASS.
