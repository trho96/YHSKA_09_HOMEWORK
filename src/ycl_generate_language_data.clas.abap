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
      cnt          TYPE i,
      itab_lang   TYPE STANDARD TABLE OF yhska09_language,
      itab_types   TYPE TABLE OF yhska09_types,
      itab_regions TYPE TABLE OF yhska09_regions.

ENDCLASS.


CLASS ycl_generate_language_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*   Filling internal table of programming language types
    itab_types = VALUE #(
                         ( language_id = '00000000000000000000000000000001' name = 'Python' rating = 5 publishing_year = 1991 developer = 'Guido van Rossum' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000002' name = 'Java' rating = 4 publishing_year = 1995 developer = 'Sun Microsystems' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000003' name = 'C#' rating = 3 publishing_year = 2000 developer = 'Microsoft' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000004' name = 'Javascript' rating = 3 publishing_year = 1995 developer = 'Brendan Eich' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000005' name = 'PHP' rating = 0 publishing_year = 1997 developer = 'Rasmus Lerdorf' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000006' name = 'C/C++' rating = 3 publishing_year = 1972 developer = 'Dennis Ritchie/Bjarne Stroustrup (1985)' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000007' name = 'R' rating = 1 publishing_year = 1993 developer = 'Ross Ihaka, Robert Gentleman' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000008' name = 'Objective-C' rating = 1 publishing_year = 1983 developer = 'Brad Cox' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000009' name = 'TypeScript' rating = 4 publishing_year = 2012 developer = 'Microsoft' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000010' name = 'VBA' rating = 1 publishing_year = 1996 developer = 'Microsoft' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000011' name = 'Swift' rating = 2  publishing_year = 2014 developer = 'Apple' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000012' name = 'Matlab' rating = 3 publishing_year = 1977 developer = 'Cleve Moler' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000013' name = 'Go' rating = 4 publishing_year = 2009 developer = 'Google Inc., Robert Griesemer, Rob Pike, Ken Thompson' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000014' name = 'Kotlin' rating = 4  publishing_year = 2011 developer = 'JetBrains' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000015' name = 'Rust' rating = 2 publishing_year = 2010 developer = 'Graydon Hoare, Mozilla' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000016' name = 'Abap' rating = 5 publishing_year = 1983 developer = 'SAP SE' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000017' name = 'Delphi' rating = 0  publishing_year = 1995 developer = 'Borland' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000018' name = 'Ruby' rating = 0 publishing_year = 1995 developer = 'Yukihiro Matsumoto' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000019' name = 'Visual Basic' rating = 1 publishing_year = 2012 developer = 'Microsoft' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000020' name = 'Scala' rating = 0 publishing_year = 2001 developer = 'Martin Odersky' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000021' name = 'Haskell' rating = 1 publishing_year = 1990 developer = 'Simon Peyton Jones, Paul Hudak, Philip Wadler' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000022' name = 'Lua' rating = 1 publishing_year = 1993 developer = 'Roberto Ierusalimschy' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000023' name = 'Dart' rating = 0 publishing_year = 2011 developer = 'Google Inc., The Dart Team' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000024' name = 'Julia' rating = 1 publishing_year = 2012 developer = 'Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000025' name = 'Cobol' rating = 0 publishing_year = 1960 developer = 'Grace Hopper, CODASYL' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000026' name = 'Groovy' rating = 1 publishing_year = 2003 developer = 'James Strachan' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000027' name = 'Perl' rating = 0 publishing_year = 1987 developer = 'Larry Wall' blacklisted = 'N' )
                         ( language_id = '00000000000000000000000000000028' name = 'Ada' rating = 0 publishing_year = 1980 developer = 'Jean Ichbiah' blacklisted = 'N' )
     ).

    DELETE FROM yhska09_types.
    INSERT yhska09_types FROM TABLE @itab_types.

*   Filling internal table with regions
    itab_regions = VALUE #(
                           ( region_key = '00000000000000000000000000000001' region =  'ALL')
                           ( region_key = '00000000000000000000000000000002' region =  'DE')
                           ( region_key = '00000000000000000000000000000003' region =  'US')
                           ( region_key = '00000000000000000000000000000004' region =  'IN')
                           ( region_key = '00000000000000000000000000000005' region =  'GB')
                           ( region_key = '00000000000000000000000000000006' region =  'FR')
     ).

    DELETE FROM yhska09_regions.
    INSERT yhska09_regions FROM TABLE @itab_regions.

*   Filling table with data from a http requests (ranking of programming languages in different regions)
    DATA(lv_url) = |http://pypl.github.io/PYPL.html|.
    DATA(lv_http_client) = NEW lcl_http_client(  ).
    DATA(lt_html) = lv_http_client->request_language_data( EXPORTING im_url = lv_url ).
    DATA(lv_html_parser) = NEW lcl_html_parser( im_html = lt_html ).
    cnt = 1.
    lv_html_parser->get_data( EXPORTING im_region = 'ALL'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).

    lv_html_parser->get_data( EXPORTING im_region = 'DE'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).

    lv_html_parser->get_data( EXPORTING im_region = 'US'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).

    lv_html_parser->get_data( EXPORTING im_region = 'IN'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).

    lv_html_parser->get_data( EXPORTING im_region = 'GB'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).

    lv_html_parser->get_data( EXPORTING im_region = 'FR'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = itab_lang ).
    DELETE FROM yhska09_language.
    INSERT yhska09_language FROM TABLE @itab_lang.

    SELECT * FROM yhska09_language INTO TABLE @itab_lang.
    out->write( sy-dbcnt ).
    out->write( 'Programming Language data inserted successfully!').

  ENDMETHOD.

ENDCLASS.
