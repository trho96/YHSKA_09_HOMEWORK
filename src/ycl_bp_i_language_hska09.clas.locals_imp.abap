"* use this source file for the definition and implementation of
"* local helper classes, interface definitions and type
"* declarations

CLASS lhc_language DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS validateLanguage          FOR VALIDATION language~validatelanguage IMPORTING keys FOR language.

ENDCLASS.

CLASS lhc_language IMPLEMENTATION.

  METHOD validateLanguage.

    READ ENTITY zi_language_hska09\\Language FROM VALUE #(
        FOR <root_key> IN keys ( %key     = <root_key>
                                 %control = VALUE #( language_id = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_language).

    DATA lt_languages TYPE SORTED TABLE OF yhska09_language WITH UNIQUE KEY language_id.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_languages = CORRESPONDING #( lt_language DISCARDING DUPLICATES MAPPING language_id = language_id EXCEPT * ).
    DELETE lt_languages WHERE language_id IS INITIAL.
    CHECK lt_languages IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM yhska09_language FIELDS language_id
      FOR ALL ENTRIES IN @lt_languages
      WHERE language_id = @lt_languages-language_id
      INTO TABLE @DATA(lt_language_db).

    " Raise msg for non existing customer id
    LOOP AT lt_language INTO DATA(ls_language).
      IF ls_language-language_id IS NOT INITIAL AND NOT line_exists( lt_language_db[ language_id = ls_language-language_id ] ).
        APPEND VALUE #(  listing_id = ls_language-listing_id ) TO failed.
        APPEND VALUE #(  listing_id = ls_language-listing_id
                         %msg      = new_message( id       = 'id not found'
                                                  number   = '002'
                                                  v1       = ls_language-language_id
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-language_id = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
