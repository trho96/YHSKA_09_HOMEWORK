*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_language DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_language_update TYPE TABLE FOR UPDATE zi_language_hska09.

    METHODS set_status_completed       FOR MODIFY IMPORTING   keys FOR ACTION language~acceptBlacklisted              RESULT result.
*    METHODS get_features               FOR FEATURES IMPORTING keys REQUEST    requested_features FOR language    RESULT result.

*    METHODS CalculateLanguageKey FOR DETERMINATION Language~CalculateLanguageKey IMPORTING keys FOR Language.
ENDCLASS.

CLASS lhc_language IMPLEMENTATION.


********************************************************************************
*
* Implements travel action (in our case: for setting travel overall_status to completed)
*
********************************************************************************
  METHOD set_status_completed.

    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF zi_language_hska09 IN LOCAL MODE
           ENTITY Language
              UPDATE FROM VALUE #( FOR key IN keys ( listing_id = key-listing_id
                                                     Blacklisted = 'Y' " Accepted
                                                     %control-Blacklisted = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zi_language_hska09 IN LOCAL MODE
         ENTITY Language
         FROM VALUE #( FOR key IN keys (  listing_id = key-listing_id
                                          %control = VALUE #(
                                            language_id       = if_abap_behv=>mk-on
                                            name     = if_abap_behv=>mk-on
                                            popularity      = if_abap_behv=>mk-on
                                            trend        = if_abap_behv=>mk-on
                                            region     = if_abap_behv=>mk-on
                                            Blacklisted     = if_abap_behv=>mk-on
                                            Rating   = if_abap_behv=>mk-on
                                            Developer  = if_abap_behv=>mk-on
                                            Publishing_Year     = if_abap_behv=>mk-on
                                          ) ) )
         RESULT DATA(lt_language).

    result = VALUE #( FOR language IN lt_language ( listing_id = language-listing_id
                                                %param    = language
                                              ) ).

  ENDMETHOD.

*********************************************************************************
**
** Implements the dynamic feature handling for travel instances
**
*********************************************************************************
*  METHOD get_features.
*
*    "%control-<fieldname> specifies which fields are read from the entities
*
*    READ ENTITY zi_language_hska09 FROM VALUE #( FOR keyval IN keys
*                                                      (  %key                    = keyval-%key
*                                                         %control-language_id      = if_abap_behv=>mk-on
*                                                         %control-Blacklisted = if_abap_behv=>mk-on
*                                                        ) )
*                                RESULT DATA(lt_language_result).
*
*
*    result = VALUE #( FOR ls_language IN lt_language_result
*                       ( %key                           = ls_language-%key
*                         %features-%action-acceptBlacklisted = COND #( WHEN ls_language-Blacklisted = 'Y'
*                                                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
*                      ) ).
*
*  ENDMETHOD.
*
*
*  METHOD calculatelanguagekey.
*    SELECT FROM yhska09_language
*        FIELDS MAX( language_id ) INTO @DATA(lv_max_language_id).
*
*    LOOP AT keys INTO DATA(ls_key).
*      lv_max_language_id = lv_max_language_id + 1.
*      MODIFY ENTITIES OF zi_language_hska09  IN LOCAL MODE
*        ENTITY Language
*          UPDATE SET FIELDS WITH VALUE #( ( listing_id     = ls_key-listing_id
*                                            language_id = lv_max_language_id ) )
*          REPORTED DATA(ls_reported).
*      APPEND LINES OF ls_reported-language TO reported-language.
*    ENDLOOP.
*
*  ENDMETHOD.


ENDCLASS.
