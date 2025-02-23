CLASS lcl_buffer DEFINITION.
* define the data buffer
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE yhska09_types AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer,

           tt_lang TYPE SORTED TABLE OF ty_buffer WITH UNIQUE KEY language_id.

    CLASS-DATA mt_buffer TYPE tt_lang.

ENDCLASS.

CLASS lcl_handler DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS modify FOR BEHAVIOR IMPORTING
                                  roots_to_create FOR CREATE languagetypes
                                  roots_to_update FOR UPDATE languagetypes
                                  roots_to_delete FOR DELETE languagetypes.

    METHODS read FOR BEHAVIOR IMPORTING
                                it_lang_id FOR READ languagetypes RESULT et_type.

    METHODS lock FOR BEHAVIOR IMPORTING it_lang_id FOR LOCK languagetypes.

    METHODS set_status_completed FOR MODIFY IMPORTING keys FOR ACTION languagetypes~acceptblacklisted.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD modify.

*   %cid = control field
*   delete an entry with the given language_id
    LOOP AT roots_to_delete INTO DATA(ls_delete).

      IF ls_delete-language_id IS INITIAL.
        ls_delete-language_id = mapped-languagetypes[ %cid = ls_delete-%cid_ref ]-language_id.
      ENDIF.

      READ TABLE lcl_buffer=>mt_buffer WITH KEY language_id = ls_delete-language_id ASSIGNING FIELD-SYMBOL(<ls_buffer>).

*     Set a flag to delete(D) the action from the buffer
*     If there is an action in the buffer with create(C) before, delete it
*     Else set a flag with delete(D) and the language_id into the buffer
      IF sy-subrc = 0.
        IF <ls_buffer>-flag = 'C'.
          DELETE TABLE lcl_buffer=>mt_buffer WITH TABLE KEY language_id = ls_delete-language_id.
        ELSE.
          <ls_buffer>-flag = 'D'.
        ENDIF.
      ELSE.
        INSERT VALUE #( flag = 'D' language_id = ls_delete-language_id ) INTO TABLE lcl_buffer=>mt_buffer.
      ENDIF.

    ENDLOOP.

*   create an entry with a language_id
*   Get the max language_id
    IF roots_to_create IS NOT INITIAL.

      SELECT SINGLE MAX( language_id ) FROM yhska09_types INTO @DATA(lv_max_lang_id).

    ENDIF.

*   Create a new entry with a new language_id and a create(C) flag into the buffer
    LOOP AT roots_to_create INTO DATA(ls_create).

*     Count up the max language_id to get a new unique id
      lv_max_lang_id = lv_max_lang_id + 1.
      ls_create-%data-language_id = lv_max_lang_id.

      INSERT VALUE #( flag = 'C' data = CORRESPONDING #( ls_create-%data ) ) INTO TABLE lcl_buffer=>mt_buffer.

      IF ls_create-%cid IS NOT INITIAL.
        INSERT VALUE #( %cid = ls_create-%cid  language_id = ls_create-language_id ) INTO TABLE mapped-languagetypes.
      ENDIF.

    ENDLOOP.

*   Update an entry with a given language_id and an update(U) flag into the buffer
    IF roots_to_update IS NOT INITIAL.
      LOOP AT roots_to_update INTO DATA(ls_update).

*       Check if the language_id exists
        IF ls_update-language_id IS INITIAL.
          ls_update-language_id = mapped-languagetypes[ %cid = ls_update-%cid_ref ]-language_id.
        ENDIF.

        READ TABLE lcl_buffer=>mt_buffer WITH KEY language_id = ls_update-language_id ASSIGNING <ls_buffer>.

*       Set an update(U) flag for the given language_id
        IF sy-subrc <> 0.
          SELECT SINGLE * FROM yhska09_types WHERE language_id = @ls_update-language_id INTO @DATA(ls_db).
          INSERT VALUE #( flag = 'U' data = ls_db ) INTO TABLE lcl_buffer=>mt_buffer ASSIGNING <ls_buffer>.
        ENDIF.

*       Update the fields
        IF ls_update-%control-blacklisted IS NOT INITIAL..
          <ls_buffer>-blacklisted = ls_update-blacklisted.
        ENDIF.
        IF ls_update-%control-developer  IS NOT INITIAL..
          <ls_buffer>-developer = ls_update-developer.
        ENDIF.
        IF ls_update-%control-name   IS NOT INITIAL..
          <ls_buffer>-name  = ls_update-name .
        ENDIF.
        IF ls_update-%control-publishing_year  IS NOT INITIAL..
          <ls_buffer>-publishing_year = ls_update-publishing_year.
        ENDIF.
        IF ls_update-%control-rating  IS NOT INITIAL..
          <ls_buffer>-rating = ls_update-rating.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

* Method to read the table
  METHOD read.

    LOOP AT it_lang_id INTO DATA(ls_lang_id).
*     Check if it is in buffer (and not deleted).
      READ TABLE lcl_buffer=>mt_buffer WITH KEY language_id = ls_lang_id-language_id INTO DATA(ls_lang).

      IF sy-subrc = 0 AND ls_lang-flag <> 'U'.
        INSERT CORRESPONDING #( ls_lang-data ) INTO TABLE et_type.
      ELSE.
        SELECT SINGLE * FROM yhska09_types WHERE language_id = @ls_lang_id-language_id INTO @DATA(ls_db).

        IF sy-subrc = 0.
          INSERT CORRESPONDING #( ls_db ) INTO TABLE et_type.
        ELSE.
          INSERT VALUE #( language_id = ls_lang_id-language_id ) INTO TABLE failed-languagetypes.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD lock.
    "provide the appropriate lock handling if required
  ENDMETHOD.

* Method to change the Blacklisted value with a button / Y = Yes, N = No
  METHOD set_status_completed.

    LOOP AT keys INTO DATA(ls_update).

      IF ls_update-language_id IS INITIAL.
        ls_update-language_id = mapped-languagetypes[ %cid = ls_update-%cid_ref ]-language_id.
      ENDIF.

      READ TABLE lcl_buffer=>mt_buffer WITH KEY language_id = ls_update-language_id ASSIGNING FIELD-SYMBOL(<ls_buffer>).

      IF sy-subrc <> 0.
        SELECT SINGLE * FROM yhska09_types WHERE language_id = @ls_update-language_id INTO @DATA(ls_db).
        INSERT VALUE #( flag = 'U' data = ls_db ) INTO TABLE lcl_buffer=>mt_buffer ASSIGNING <ls_buffer>.
      ENDIF.

*     Toggle the Blacklisted value
      IF <ls_buffer>-blacklisted = 'N'.
        <ls_buffer>-blacklisted = 'Y'.
      ELSE.
        <ls_buffer>-blacklisted = 'N'.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION .
    METHODS save              REDEFINITION.
ENDCLASS.


CLASS lcl_saver IMPLEMENTATION.

* Depending on the flag a different action is used
  METHOD save.

    DATA lt_data TYPE STANDARD TABLE OF yhska09_types.

*   Create flag
    lt_data = VALUE #(  FOR row IN lcl_buffer=>mt_buffer WHERE  ( flag = 'C' ) (  row-data ) ).

    IF lt_data IS NOT INITIAL.
      INSERT yhska09_types FROM TABLE @lt_data.
    ENDIF.

*   Update flag
    lt_data = VALUE #(  FOR row IN lcl_buffer=>mt_buffer WHERE  ( flag = 'U' ) (  row-data ) ).

    IF lt_data IS NOT INITIAL.
      UPDATE yhska09_types FROM TABLE @lt_data.
    ENDIF.

*   Delete flag
    lt_data = VALUE #(  FOR row IN lcl_buffer=>mt_buffer WHERE  ( flag = 'D' ) (  row-data ) ).

    IF lt_data IS NOT INITIAL.
      DELETE yhska09_types FROM TABLE @lt_data.
    ENDIF.

  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

ENDCLASS.
