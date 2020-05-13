CLASS lhc_language DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculatelanguageid FOR DETERMINATION LanguageTypes~CalculateLanguageId
      IMPORTING keys FOR LanguageTypes.

ENDCLASS.

CLASS lhc_language IMPLEMENTATION.

  METHOD calculatelanguageid.
    SELECT FROM yhska09_types
        FIELDS MAX( language_id ) INTO @DATA(lv_max_language_id).

    LOOP AT keys INTO DATA(ls_key).
      lv_max_language_id = lv_max_language_id + 1.
      MODIFY ENTITIES OF zi_types_hska09  IN LOCAL MODE
        ENTITY LanguageTypes
          UPDATE SET FIELDS WITH VALUE #( (  language_id = lv_max_language_id ) )
          REPORTED DATA(ls_reported).
      APPEND LINES OF ls_reported-languagetypes TO reported-languagetypes.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
