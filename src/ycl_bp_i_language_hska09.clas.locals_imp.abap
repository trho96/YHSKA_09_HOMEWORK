CLASS lhc_language DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validatelanguage FOR VALIDATION language~validatelanguage IMPORTING keys FOR language.
    METHODS validatepopularity FOR VALIDATION language~validatepopularity IMPORTING keys FOR language.
    METHODS validatetrend FOR VALIDATION language~validatetrend IMPORTING keys FOR language.

ENDCLASS.


CLASS lhc_language IMPLEMENTATION.

  METHOD validatelanguage.

    READ ENTITY zi_language_hska09\\language FROM VALUE #(
        FOR <root_key> IN keys ( %key     = <root_key>
                                 %control = VALUE #( language_id = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_language).

    DATA lt_languages TYPE SORTED TABLE OF yhska09_language WITH UNIQUE KEY language_id.

*   Extract distinct non-initial language ids
    lt_languages = CORRESPONDING #( lt_language DISCARDING DUPLICATES MAPPING language_id = language_id EXCEPT * ).
    DELETE lt_languages WHERE language_id IS INITIAL.
    CHECK lt_languages IS NOT INITIAL.

*   Check if language ID exist
    SELECT FROM yhska09_language FIELDS language_id
      FOR ALL ENTRIES IN @lt_languages
      WHERE language_id = @lt_languages-language_id
      INTO TABLE @DATA(lt_language_db).

*   Raise msg for non existing language id
    LOOP AT lt_language INTO DATA(ls_language).
      IF ls_language-language_id IS NOT INITIAL AND NOT line_exists( lt_language_db[ language_id = ls_language-language_id ] ).
        APPEND VALUE #(  listing_id = ls_language-listing_id ) TO failed.
        APPEND VALUE #(  listing_id = ls_language-listing_id
                         %msg      = new_message( id       = 'Id '
                                                  number   = '002'
                                                  v1       = ': ' && ls_language-language_id && ' doesnt exists'
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-language_id = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validatepopularity.

    READ ENTITY zi_language_hska09\\language FROM VALUE #(
        FOR <root_key> IN keys ( %key     = <root_key>
                                 %control = VALUE #( popularity = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_language).

*   Raise msg if the value of popularity is not between 0 and 100
    LOOP AT lt_language INTO DATA(ls_language).
      IF ls_language-popularity GT 100 OR ls_language-popularity LT 0.
        APPEND VALUE #(  listing_id = ls_language-listing_id ) TO failed.
        APPEND VALUE #(  listing_id = ls_language-listing_id
                         %msg      = new_message( id       = 'Id '
                                                  number   = '003'
                                                  v1       = ': popularity value should be between 0 and 100'
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-popularity = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validatetrend.

    READ ENTITY zi_language_hska09\\language FROM VALUE #(
        FOR <root_key> IN keys ( %key     = <root_key>
                                 %control = VALUE #( trend = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_language).

*   Raise msg if the value of trend is not between -100 and 100
    LOOP AT lt_language INTO DATA(ls_language).
      IF ls_language-trend > 100 OR ls_language-trend < -100.
        APPEND VALUE #(  listing_id = ls_language-listing_id ) TO failed.
        APPEND VALUE #(  listing_id = ls_language-listing_id
                         %msg      = new_message( id       = 'Id '
                                                  number   = '004'
                                                  v1       = ': trend value should be between -100 and 100'
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-trend = if_abap_behv=>mk-on ) TO reported.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
