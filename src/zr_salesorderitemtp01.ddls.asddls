@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forSalesorderItem'
define view entity ZR_SalesorderItemTP01
  as select from zsd_vbap
  association to parent ZR_SalesorderTP as _Salesorder on $projection.OrderUUID = _Salesorder.OrderUUID
  
  association [0..1] to ZI_PRODUCTVH      as _product on $projection.Product = _product.IdProd
{
  key orderitem_uuid as OrderitemUUID,
  order_uuid as OrderUUID,
  order_id as OrderID,
  orderitem as Orderitem,
  product as Product,
  @Semantics.quantity.unitOfMeasure: 'Orderquantityunit'
  orderquantity as Orderquantity,
  orderquantityunit as Orderquantityunit,
////   @Semantics.amount.currencyCode: 'Transactioncurrency'
//  cast( _product.prod_Price as abap.char( 30 ) ) as ProdPrice,

  @Semantics.amount.currencyCode: 'ProdCurrency'
prod_price  as ProdPrice,
prod_currency as ProdCurrency,
//  _product.Currency as ProdCurrency,
  @Semantics.amount.currencyCode: 'Transactioncurrency'
  netamount as Netamount,
  transactioncurrency as Transactioncurrency,
  creationdate as Creationdate,
  createbyuser as Createbyuser,
  creationdatetime as Creationdatetime,
  lastchangedbyuser as Lastchangedbyuser,
  _Salesorder,
  _product
}
