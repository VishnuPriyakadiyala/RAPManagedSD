@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forSalesorder'
define root view entity ZI_SalesorderTP
  provider contract transactional_interface
  as projection on ZR_SalesorderTP
{
  key OrderUUID,
  @EndUserText.label: 'Order Number'
  OrderID,
  ExternalID,
  CustomerID,
  OrderDate,
  BeginDate,
  EndDate,
  NetFee,
  TotalPrice,
  CurrencyCode,
  Description,
  OverallStatus,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  _SalesorderItem : redirected to composition child ZI_SalesorderItemTP
  
}
