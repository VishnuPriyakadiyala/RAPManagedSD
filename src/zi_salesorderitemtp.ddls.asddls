@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forSalesorderItem'
define view entity ZI_SalesorderItemTP
  as projection on ZR_SalesorderItemTP01
{
  key OrderitemUUID,
  OrderUUID,
  OrderID,
  Orderitem,
  Product,
  ProdPrice, 
ProdCurrency,  
  Orderquantity,
  Orderquantityunit,
  Netamount,
  Transactioncurrency,
  Creationdate,
  Createbyuser,
  Creationdatetime,
  Lastchangedbyuser,
  _Salesorder : redirected to parent ZI_SalesorderTP
  
}
