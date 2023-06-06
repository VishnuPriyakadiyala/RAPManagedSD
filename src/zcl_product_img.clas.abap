CLASS zcl_product_img DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_product_img IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
  data: lt_item TYPE STANDARD TABLE OF ZC_SalesorderItemTP01.

        lt_item = CORRESPONDING #(  it_original_data ).
          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
          <ls_item>-ProdImageURL =
          switch #( <ls_item>-Product
          when 'COFFEE' THEN 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Latte_and_dark_coffee.jpg/1280px-Latte_and_dark_coffee.jpg'
          when 'CCAKE'  THEN 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Cupcakes%2C_chocolate_and_strawberry_flavour.jpg/1280px-Cupcakes%2C_chocolate_and_strawberry_flavour.jpg'
          when 'SWICH'  then 'https://upload.wikimedia.org/wikipedia/commons/2/24/Bologna_sandwich.jpg'
          when 'TEA' OR 'GTEA'
          THEN 'https://upload.wikimedia.org/wikipedia/commons/0/07/Green_Tea_Color.jpg' ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_item ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
