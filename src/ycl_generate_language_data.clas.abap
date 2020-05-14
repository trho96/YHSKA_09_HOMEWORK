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

  ENDMETHOD.
ENDCLASS.
