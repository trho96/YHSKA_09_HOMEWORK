CLASS ycl_generate_language_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    DATA:
      cnt        TYPE i,
      lt_lang_db TYPE STANDARD TABLE OF yhska09_language,
      itab_types TYPE TABLE OF yhska09_types.

  PRIVATE SECTION.
    DATA:
      lv_html_table TYPE string_table.
ENDCLASS.



CLASS ycl_generate_language_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*  filling internal programming language types table
    itab_types = VALUE #(
                         ( language_id = '00000000000000000000000000000001' name = 'Python' rating = 0 publishing_year = 1991 developer = 'Guido van Rossum' )
                         ( language_id = '00000000000000000000000000000002' name = 'Java' rating = 0 publishing_year = 1995 developer = 'Sun Microsystems' )
                         ( language_id = '00000000000000000000000000000003' name = 'C#' rating = 0 publishing_year = 2000 developer = 'Microsoft' )
                         ( language_id = '00000000000000000000000000000004' name = 'Javascript' rating = 0 publishing_year = 1995 developer = 'Brendan Eich' )
                         ( language_id = '00000000000000000000000000000005' name = 'PHP' rating = 0 publishing_year = 1997 developer = 'Rasmus Lerdorf' )
                         ( language_id = '00000000000000000000000000000006' name = 'C/C++' rating = 0 publishing_year = 1972 developer = 'Dennis Ritchie/Bjarne Stroustrup (1985)' )
                         ( language_id = '00000000000000000000000000000007' name = 'R' rating = 0 publishing_year = 1993 developer = 'Ross Ihaka, Robert Gentleman' )
                         ( language_id = '00000000000000000000000000000008' name = 'Objective-C' rating = 0 publishing_year = 1983 developer = 'Brad Cox' )
                         ( language_id = '00000000000000000000000000000009' name = 'Typescript' rating = 0 publishing_year = 2012 developer = 'Microsoft' )
                         ( language_id = '00000000000000000000000000000010' name = 'VBA' rating = 0 publishing_year = 1996 developer = 'Microsoft' )
                         ( language_id = '00000000000000000000000000000011' name = 'Swift' rating = 0  publishing_year = 2014 developer = 'Apple' )
                         ( language_id = '00000000000000000000000000000012' name = 'Matlab' rating = 0 publishing_year = 1977 developer = 'Cleve Moler' )
                         ( language_id = '00000000000000000000000000000013' name = 'Go' rating = 0 publishing_year = 2009 developer = 'Google Inc., Robert Griesemer, Rob Pike, Ken Thompson' )
                         ( language_id = '00000000000000000000000000000014' name = 'Kotlin' rating = 0  publishing_year = 2011 developer = 'JetBrains' )
                         ( language_id = '00000000000000000000000000000015' name = 'Rust' rating = 0 publishing_year = 2010 developer = 'Graydon Hoare, Mozilla' )
                         ( language_id = '00000000000000000000000000000016' name = 'Abap' rating = 0 publishing_year = 1983 developer = 'SAP SE' )
                         ( language_id = '00000000000000000000000000000017' name = 'Delphi' rating = 0  publishing_year = 1995 developer = 'Borland' )
                         ( language_id = '00000000000000000000000000000018' name = 'Ruby' rating = 0 publishing_year = 1995 developer = 'Yukihiro Matsumoto' )
                         ( language_id = '00000000000000000000000000000019' name = 'Visual Basic' rating = 0 publishing_year = 2012 developer = 'Microsoft' )
                         ( language_id = '00000000000000000000000000000020' name = 'Scala' rating = 0 publishing_year = 2001 developer = 'Martin Odersky' )
                         ( language_id = '00000000000000000000000000000021' name = 'Haskell' rating = 0 publishing_year = 1990 developer = 'Simon Peyton Jones, Paul Hudak, Philip Wadler' )
                         ( language_id = '00000000000000000000000000000022' name = 'Lua' rating = 0 publishing_year = 1993 developer = 'Roberto Ierusalimschy' )
                         ( language_id = '00000000000000000000000000000023' name = 'Dart' rating = 0 publishing_year = 2011 developer = 'Google Inc., The Dart Team' )
                         ( language_id = '00000000000000000000000000000024' name = 'Julia' rating = 0 publishing_year = 2012 developer = 'Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman' )
                         ( language_id = '00000000000000000000000000000025' name = 'Cobol' rating = 0 publishing_year = 1960 developer = 'Grace Hopper, CODASYL' )
                         ( language_id = '00000000000000000000000000000026' name = 'Groovy' rating = 0 publishing_year = 2003 developer = 'James Strachan' )
                         ( language_id = '00000000000000000000000000000027' name = 'Perl' rating = 0 publishing_year = 1987 developer = 'Larry Wall' )
     ).

    DELETE FROM yhska09_types.
    INSERT yhska09_types FROM TABLE @itab_types.

    DATA(lv_url) = |http://pypl.github.io/PYPL.html|.
    DATA(lv_http_client) = NEW lcl_http_client(  ).
    DATA(lt_html) = lv_http_client->request_language_data( EXPORTING im_url = lv_url ).
    DATA(lv_html_parser) = NEW lcl_html_parser( im_html = lt_html ).
    cnt = 1.
    lv_html_parser->get_data( EXPORTING im_region = 'ALL'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'DE'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'US'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'IN'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'GB'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).

    lv_html_parser->get_data( EXPORTING im_region = 'FR'
                                        im_types_db = itab_types
                              CHANGING  ch_cnt = cnt
                                        ch_lang_db = lt_lang_db ).
    DELETE FROM yhska09_language.
    INSERT yhska09_language FROM TABLE @lt_lang_db.

    SELECT * FROM yhska09_language INTO TABLE @lt_lang_db.
    out->write( sy-dbcnt ).
    out->write( 'Programming Language data inserted successfully!').



  ENDMETHOD.
ENDCLASS.
