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
        RETURNING VALUE(lt_ctab) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ls_html TYPE string.
ENDCLASS.

CLASS lcl_http_client IMPLEMENTATION.
  METHOD request_language_data.
    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( im_url ).
    DATA(lo_http) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
    DATA(lo_request) = lo_http->get_http_request( ).
    DATA(lo_reponse) = lo_http->execute( i_method = if_web_http_client=>get ).
    DATA(lo_response_text) = lo_reponse->get_text(  ).
    SPLIT lo_response_text AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_ctab.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_html_parser DEFINITION
FINAL
    CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: ty_hska_language TYPE STANDARD TABLE OF yhska09_language.
    METHODS:
      constructor
        IMPORTING im_html TYPE string_table,
      get_data
        IMPORTING im_region  TYPE string
        CHANGING  ch_cnt     TYPE i
                  ch_lang_db TYPE ty_hska_language.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ls_html TYPE string_table.
ENDCLASS.

CLASS lcl_html_parser IMPLEMENTATION.

  METHOD constructor.
    ls_html = im_html.
  ENDMETHOD.

  METHOD get_data.
    LOOP AT ls_html INTO DATA(data_string) WHERE table_line CS 'table = "<!-- begin section' && ` ` && im_region && '-->\'.
      DATA(matcher) = cl_abap_matcher=>create( pattern     = '<([!A-Za-z][A-Za-z0-9]*)([^>]*)>|</([A-Za-z][A-Za-z0-9]*)>'
                                               text = data_string
                                               ignore_case = abap_true ).

      IF matcher->replace_all( `_` ) > 0.

        DATA(result) = substring_from( val = matcher->text sub = '_1' ).
        REPLACE ALL OCCURRENCES OF REGEX ' %' IN result WITH ''.


        REPLACE ALL OCCURRENCES OF REGEX '\n' IN result WITH ``.

        SPLIT result AT '\' INTO TABLE DATA(itab).

        LOOP AT itab INTO DATA(line).
* out->write( line ).

          DATA(matcherline) = cl_abap_matcher=>create( pattern     = '_+([0-9]+)_+([^_]+)_+([^_]+)_+([^_]+)_+.*'
                                               text = line
                                               ignore_case = abap_true ).
          IF abap_true = matcherline->match( ).
            DATA(lo_lang_data) = VALUE yhska09_language( language_id = ch_cnt
                                                         rank = matcherline->get_submatch( 1 )
                                                         name = matcherline->get_submatch( 2 )
                                                         popularity = matcherline->get_submatch( 3 )
                                                         trend = matcherline->get_submatch( 4 )
                                                         region = im_region ).
            APPEND lo_lang_data TO ch_lang_db.
            ch_cnt = ch_cnt + 1.
          ENDIF.

        ENDLOOP.

      ELSE.
*        out->write( |Keine Tags gefunden.| ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
