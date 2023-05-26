CLASS zcl_business_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_business_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DELETE from ZSD_CUSTOMER.

   INSERT ZSD_CUSTOMER FROM (
        SELECT
          FROM /dmo/customer
          FIELDS
          customer_id,
first_name,
last_name  ,
title       ,
street       ,
postal_code   ,
city           ,
country_code    ,
phone_number     ,
email_address
      ).
    COMMIT WORK.
 out->write( 'customer Inserted').


  DELETE from zsd_status.

data: lt_status TYPE STANDARD TABLE OF zsd_status.
      lt_status = VALUE #(  ( status = 'O' )
                            ( status = 'C' )
                            ( status = 'I' )
                            ( status = 'D' )
                            ( status = 'N' )
                            ( status = 'P' )
                            ( status = 'R' ) ).
   INSERT zsd_status FROM TABLE @lt_status.
    COMMIT WORK.
  out->write( 'Status Inserted').


 DELETE from zsd_status_text.
data: lt_statust TYPE STANDARD TABLE OF zsd_status_text.
      lt_statust = VALUE #(  ( status = 'O'
                               langu  = 'E'
                               status_text = 'Open' )
                            ( status = 'C'
                               langu  = 'E'
                               status_text = 'Completed' )
                            ( status = 'I'
                               langu  = 'E'
                               status_text = 'In Delivery' )
                            ( status = 'D'
                               langu  = 'E'
                               status_text = 'Delivered' )
                            ( status = 'N'
                               langu  = 'E'
                               status_text = 'No Stock' )
                            ( status = 'P'
                               langu  = 'E'
                               status_text = 'Partial Delivery' )
                            ( status = 'R'
                               langu  = 'E'
                               status_text = 'Returned' ) ).
   INSERT zsd_status_text FROM TABLE @lt_statust.
    COMMIT WORK.
  out->write( 'Status Text Inserted').


 DELETE from zsd_product.
data: lt_product TYPE STANDARD TABLE OF zsd_product.

      lt_product = value #(  ( id_prod   = 'TEA'
                               id_family = 'Beverages'
                               prod_txt  = 'Tea'
                               currency  = 'INR'
                               price     = 120 )
                             ( id_prod   = 'COFFEE'
                               id_family = 'Beverages'
                               prod_txt  = 'Coffee'
                               currency  = 'INR'
                               price     = 250 )
                             ( id_prod   = 'GTEA'
                               id_family = 'Beverages'
                               prod_txt  = 'Green Tea'
                               currency  = 'INR'
                               price     = 150 )
                             ( id_prod   = 'SWICH'
                               id_family = 'FOOD'
                               prod_txt  = 'sandwich'
                               currency  = 'INR'
                               price     = 300 )
                             ( id_prod   = 'CCAKE'
                               id_family = 'Dessert'
                               prod_txt  = 'Cup Cake'
                               currency  = 'INR'
                               price     = 230 )  ).

     INSERT zsd_product FROM TABLE @lt_product.
    COMMIT WORK.
  out->write( 'Product Inserted').

  ENDMETHOD.
ENDCLASS.
