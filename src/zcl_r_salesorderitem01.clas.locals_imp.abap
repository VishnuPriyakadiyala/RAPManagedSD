CLASS lhc_SalesorderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateNetamount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesorderItem~CalculateNetamount.
    METHODS CalculateHeaderNetFee FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesorderItem~CalculateHeaderNetFee.
    METHODS SetInitialValue FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesorderItem~SetInitialValue.
    METHODS CalculateProdPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesorderItem~CalculateProdPrice.

ENDCLASS.

CLASS lhc_SalesorderItem IMPLEMENTATION.



  METHOD CalculateNetamount.
*Read Order Item
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
     ENTITY SalesorderItem
     FIELDS ( OrderID Orderitem Product Orderquantity Netamount )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_salesorderitem)
     FAILED DATA(lt_failed).

    IF lt_salesorderitem IS NOT INITIAL.
      SELECT id_prod,
             price,
             currency
      FROM zsd_product
      FOR ALL ENTRIES IN @lt_salesorderitem
      WHERE id_prod = @lt_salesorderitem-Product
      INTO TABLE @DATA(lt_product).

      IF lt_product IS NOT INITIAL.

        LOOP AT lt_salesorderitem ASSIGNING FIELD-SYMBOL(<ls_salesorderitem>).
          TRY.
              DATA(ls_product) = lt_product[ id_prod = <ls_salesorderitem>-Product ].
              <ls_salesorderitem>-Netamount = ls_product-price * <ls_salesorderitem>-Orderquantity.
*              <ls_salesorderitem>-ProdPrice = ls_product-price.
              <ls_salesorderitem>-Transactioncurrency = ls_product-currency.
*              <ls_salesorderitem>-Orderquantityunit = COND #( WHEN ls_product-price IS NOT INITIAL
*                                                           THEN 'EA' ).
            CATCH cx_sy_itab_line_not_found.
*      failed to determine the product .. Raise a message
          ENDTRY.
        ENDLOOP.
      ENDIF.
      "update involved instances
      MODIFY ENTITIES OF zr_salesordertp IN LOCAL MODE
        ENTITY SalesorderItem
          UPDATE FIELDS ( Netamount Transactioncurrency )
          WITH VALUE #( FOR ls_orderitem IN lt_salesorderitem  (
                             %tky                = ls_orderitem-%tky
                             Transactioncurrency = ls_orderitem-ProdCurrency
                             Netamount           = ls_orderitem-Netamount
                              ) ).
    ENDIF.
  ENDMETHOD.

  METHOD CalculateHeaderNetFee.


    DATA lt_update TYPE TABLE FOR UPDATE ZR_SalesorderTP. "Update
* READ the entity
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
    ENTITY SalesorderItem
    FIELDS  ( OrderUUID OrderitemUUID  Orderitem Netamount )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orderchanged)
     FAILED DATA(lt_failedchang).

    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
    ENTITY SalesorderItem BY \_Salesorder
    FIELDS ( OrderUUID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_salesorder)
    FAILED DATA(lt_failed).
*  Read all the items for the order
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
 ENTITY Salesorder BY \_SalesorderItem
 FIELDS ( OrderUUID OrderitemUUID  Orderitem Netamount )
 WITH  VALUE #( ( %tky = lt_salesorder[ 1 ]-%tky ) )
 RESULT DATA(lt_salesorderitems)
 FAILED DATA(lt_faileditem).

* Process the items to get the header Net Fee
    LOOP AT lt_salesorderitems ASSIGNING FIELD-SYMBOL(<ls_orderitems>). "only one item is received

      IF <ls_orderitems>-Netamount IS NOT INITIAL.

        READ TABLE lt_update ASSIGNING FIELD-SYMBOL(<ls_update>)
        WITH KEY OrderUUID = <ls_orderitems>-OrderUUID.
*          WITH KEY entity COMPONENTS %tky = CORRESPONDING #( <ls_orderitems>-%tky ).
        IF sy-subrc IS NOT INITIAL.
          APPEND VALUE #(  %tky     = VALUE #( %is_draft =   <ls_orderitems>-%is_draft
                                               OrderUUID = <ls_orderitems>-OrderUUID )
                           %control    = VALUE #( TotalPrice   = if_abap_behv=>mk-on
                                                  NetFee       = if_abap_behv=>mk-on
                                                  CurrencyCode = if_abap_behv=>mk-on ) ) TO lt_update ASSIGNING <ls_update>.
        ENDIF.

        READ TABLE lt_orderchanged ASSIGNING FIELD-SYMBOL(<ls_orderchanged>)
                WITH KEY OrderitemUUID = <ls_orderitems>-OrderitemUUID.
        IF sy-subrc IS INITIAL.
          <ls_update>-TotalPrice = <ls_update>-TotalPrice + <ls_orderchanged>-Netamount.
          <ls_update>-NetFee = <ls_update>-NetFee + <ls_orderchanged>-Netamount.
          <ls_update>-CurrencyCode = <ls_orderchanged>-Transactioncurrency.
        ELSE.
          <ls_update>-TotalPrice = <ls_update>-TotalPrice + <ls_orderitems>-Netamount.
          <ls_update>-NetFee = <ls_update>-NetFee + <ls_orderitems>-Netamount.
          <ls_update>-CurrencyCode = <ls_orderitems>-Transactioncurrency.
        ENDIF.

      ENDIF.
    ENDLOOP.

*    "update involved instances
    MODIFY ENTITY IN LOCAL MODE zr_salesordertp
      UPDATE FROM lt_update.
  ENDMETHOD.
*

  METHOD SetInitialValue.


    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
    ENTITY SalesorderItem BY \_Salesorder
    FIELDS ( OrderUUID  )
    WITH  VALUE #( ( %tky = keys[ 1 ]-%tky ) )
    RESULT DATA(lt_salesorder)
    FAILED DATA(lt_failed).
*  Read all the items for the order
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
 ENTITY Salesorder BY \_SalesorderItem
 FIELDS ( OrderitemUUID  Orderitem  )
 WITH  VALUE #( ( %tky = lt_salesorder[ 1 ]-%tky ) )
 RESULT DATA(lt_salesorderitem)
 FAILED DATA(lt_faileditem).

    SELECT MAX( Orderitem )
    FROM @lt_salesorderitem AS ord_item
    INTO @DATA(lv_max_orderitem).

    LOOP AT lt_salesorderitem ASSIGNING FIELD-SYMBOL(<ls_orderitem>) WHERE Orderitem IS INITIAL.
      READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) WITH KEY %tky = <ls_orderitem>-%tky.
      IF sy-subrc IS INITIAL.

        lv_max_orderitem = lv_max_orderitem + 010.

        MODIFY ENTITIES OF zr_salesordertp IN LOCAL MODE
           ENTITY SalesorderItem
              UPDATE  FIELDS ( Orderitem )
                WITH VALUE #( ( %tky = <ls_orderitem>-%tky
                              Orderitem = lv_max_orderitem
                              %control  = VALUE #( Orderitem = if_abap_behv=>mk-on ) ) )
           FAILED DATA(LT_failedmap)
           REPORTED DATA(LT_reported)
           MAPPED DATA(lt_mapped) .
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD CalculateProdPrice.
*  *Read Order Item
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
     ENTITY SalesorderItem
     FIELDS ( OrderID Orderitem Product Orderquantity Netamount )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_salesorderitem)
     FAILED DATA(lt_failed).

    IF lt_salesorderitem IS NOT INITIAL.
      SELECT id_prod,
             price,
             currency
      FROM zsd_product
      FOR ALL ENTRIES IN @lt_salesorderitem
      WHERE id_prod = @lt_salesorderitem-Product
      INTO TABLE @DATA(lt_product).

      IF lt_product IS NOT INITIAL.

        LOOP AT lt_salesorderitem ASSIGNING FIELD-SYMBOL(<ls_salesorderitem>).
          TRY.
              DATA(ls_product) = lt_product[ id_prod = <ls_salesorderitem>-Product ].

              <ls_salesorderitem>-ProdPrice = ls_product-price.
              <ls_salesorderitem>-ProdCurrency = ls_product-currency.
              <ls_salesorderitem>-Orderquantity = 10.
              <ls_salesorderitem>-Orderquantityunit = 'EA'.
            CATCH cx_sy_itab_line_not_found.
*      failed to determine the product .. Raise a message
          ENDTRY.
        ENDLOOP.
      ENDIF.
      "update involved instances
      MODIFY ENTITIES OF zr_salesordertp IN LOCAL MODE
        ENTITY SalesorderItem
          UPDATE FIELDS (
          ProdPrice ProdCurrency Orderquantity Orderquantityunit )
          WITH VALUE #( FOR ls_orderitem IN lt_salesorderitem  (
                             %tky                = ls_orderitem-%tky
                             ProdPrice           = ls_orderitem-ProdPrice
                             ProdCurrency        = ls_orderitem-ProdCurrency
                             Orderquantity       = ls_orderitem-Orderquantity
                             Orderquantityunit   = ls_orderitem-Orderquantityunit ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
