CLASS lhc_Salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Salesorder RESULT result.

    METHODS CalculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Salesorder~CalculateOrderID.
    METHODS CreateInstance FOR MODIFY
      IMPORTING keys FOR ACTION Salesorder~CreateInstance.
    METHODS CopyOrder FOR MODIFY
      IMPORTING keys FOR ACTION Salesorder~CopyOrder.

ENDCLASS.

CLASS lhc_Salesorder IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CalculateOrderID.

*  Read Order Information from Transaction Buffer
    READ ENTITIES OF zr_salesordertp IN LOCAL MODE
    ENTITY Salesorder
    FIELDS ( OrderID CustomerID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_salesorder)
    FAILED DATA(lt_failed).

*    Process the records
    DATA lt_update TYPE TABLE FOR UPDATE ZR_SalesorderTP\\Salesorder.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
*    Go through each record
      LOOP AT lt_salesorder ASSIGNING FIELD-SYMBOL(<ls_salesorder>) WHERE %tky = <ls_keys>-%tky.
        IF <ls_salesorder>-OrderID IS INITIAL.

* change this to real time numbering
          DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
          DATA(lv_time) = cl_abap_context_info=>get_system_time(  ).

          <ls_salesorder>-OrderID = lv_time && lv_date.

          APPEND VALUE #( %tky    = <ls_salesorder>-%tky
                          OrderID = <ls_salesorder>-OrderID
                          %control-OrderID = if_abap_behv=>mk-on  ) TO lt_update.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

*    Update the data back
    IF  lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_salesordertp IN LOCAL MODE
             ENTITY Salesorder
                UPDATE FROM lt_update
             FAILED LT_failed
             REPORTED DATA(LT_reported).
    ENDIF.


  ENDMETHOD.


  METHOD CreateInstance.

* change this to real time numbering
          DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
          DATA(lv_time) = cl_abap_context_info=>get_system_time(  ).


  MODIFY ENTITIES OF zr_salesordertp IN LOCAL MODE
             ENTITY Salesorder
                CREATE from value #( for <ls_keys> in keys
                ( %cid             = <ls_keys>-%cid
                  %is_draft        = <ls_keys>-%param-%is_draft
                   Description     = 'New Order'
                   overallstatus   = 'O'
                   OrderID         = lv_time && lv_date
                   BeginDate       = lv_date
                   EndDate         = lv_date + 364
                   OrderDate       = lv_date
                   %control        = VALUE #(  Description   = if_abap_behv=>mk-on
                                               OverallStatus = if_abap_behv=>mk-on
                                               OrderID       = if_abap_behv=>mk-on
                                               BeginDate     = if_abap_behv=>mk-on
                                               EndDate       = if_abap_behv=>mk-on
                                               OrderDate     = if_abap_behv=>mk-on
                                              )
                   )

                )
                MAPPED data(lt_mapped)
             FAILED data(LT_failed)
             REPORTED DATA(LT_reported).
             mapped = CORRESPONDING #( deep lt_mapped ).

  ENDMETHOD.

  METHOD CopyOrder.


*    Process the records
    DATA lt_order TYPE TABLE FOR create ZR_SalesorderTP\\Salesorder.



    " Reading selected data from frontend

    READ ENTITIES OF ZR_SalesorderTP IN LOCAL MODE
    ENTITY Salesorder
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_Orders)
    FAILED failed.

    LOOP AT lt_Orders ASSIGNING FIELD-SYMBOL(<ls_orders>).

      APPEND VALUE #( %cid = keys[ KEY entity %key = <ls_orders>-%key ]-%cid
                      %is_draft = keys[ KEY entity %key = <ls_orders>-%key ]-%param-%is_draft
                      %data = CORRESPONDING #( <ls_orders> EXCEPT OrderUUID )

       )  TO lt_order ASSIGNING FIELD-SYMBOL(<ls_neworder>).


* change this to real time numbering
          DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
          DATA(lv_time) = cl_abap_context_info=>get_system_time(  ).

          <ls_neworder>-OrderID = lv_time && lv_date.
          <ls_neworder>-overallstatus = 'O'.
          <ls_neworder>-BeginDate = cl_abap_context_info=>get_system_date(  ).
          <ls_neworder>-CurrencyCode = 'INR'.
    ENDLOOP.

    "Create BO Instance by COpy

    MODIFY ENTITIES OF ZR_SalesorderTP IN LOCAL MODE
    ENTITY Salesorder
    CREATE FIELDS (  OrderID        ExternalID     CustomerID     OrderDate
                     EndDate        NetFee         TotalPrice
                     CurrencyCode   Description     )
    WITH lt_order
    MAPPED DATA(mapped_create).



    mapped-salesorder = mapped_create-salesorder.


*    modify item data

    DATA lt_item TYPE TABLE FOR UPDATE ZR_SalesorderTP\\SalesorderItem.
 READ ENTIties of ZR_SalesorderTP in LOCAL MODE
    ENTITY Salesorder by \_SalesorderItem
       ALL FIELDS WITH  CORRESPONDING #( keys )
    RESULT DATA(lt_SalesorderItem)
    FAILED data(lt_failed).
  ENDMETHOD.

ENDCLASS.
