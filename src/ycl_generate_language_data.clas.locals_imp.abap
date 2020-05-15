CLASS lcl_http_client DEFINITION
    FINAL
    CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS:
      request_language_data
        IMPORTING im_url         TYPE string
        RETURNING VALUE(lt_ctab) TYPE string_table
        RAISING
                  cx_http_dest_provider_error
                  cx_web_http_client_error.
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
    TYPES: ty_hska_language TYPE STANDARD TABLE OF yhska09_language,
           ty_hska_types    TYPE STANDARD TABLE OF yhska09_types.
    METHODS:
      constructor
        IMPORTING im_html TYPE string_table,
      get_data
        IMPORTING im_region   TYPE string
                  im_types_db TYPE ty_hska_types
        CHANGING  ch_cnt      TYPE i
                  ch_lang_db  TYPE ty_hska_language.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ls_html        TYPE string_table,
      lc_language_id TYPE yhska09_types.
ENDCLASS.

CLASS lcl_html_parser IMPLEMENTATION.

  METHOD constructor.
    ls_html = im_html.
  ENDMETHOD.

* Local function to get data of ranking of programming languages from an external website
* Parse the html site to extract the relevant data
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

*       Get language name, popularity, trend and region from the parsed data
        LOOP AT itab INTO DATA(line).

          DATA(matcherline) = cl_abap_matcher=>create( pattern     = '_+([0-9]+)_+([^_]+)_+([^_]+)_+([^_]+)_+.*'
                                               text = line
                                               ignore_case = abap_true ).


          IF abap_true = matcherline->match( ).
            LOOP AT im_types_db INTO lc_language_id WHERE name = matcherline->get_submatch( 2 ).
            ENDLOOP.

            DATA(lo_lang_data) = VALUE yhska09_language( listing_id = ch_cnt
                                                         language_id = lc_language_id-language_id
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
