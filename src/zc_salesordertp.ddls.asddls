@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSalesorder'
@ObjectModel.semanticKey: [ 'OrderID' ]
@Search.searchable: true
define root view entity ZC_SalesorderTP
  provider contract transactional_query
  as projection on ZR_SalesorderTP
{
  key OrderUUID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  OrderID,
  ExternalID,
  
   @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'ZI_CUSTOMERVH', 
      element: 'CustomerID'
    },
    useForValidation: true
  } ]
   @ObjectModel.text.element: ['CustomerName']
   
  CustomerID,
   _Customer.last_name as CustomerName,
  OrderDate,
  BeginDate,
  EndDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  NetFee,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TotalPrice,
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    },
    useForValidation: true
  } ]
  CurrencyCode,
  Description,
   @Consumption.valueHelpDefinition: [ 
        { entity:  { name:    'ZI_STATUSORDVH',
                     element: 'status' },
    useForValidation: true
        }]
     @ObjectModel.text.element: ['StatusText']     
  OverallStatus,
 
  _STATUS.status_text as StatusText,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  _STATUS,
  _SalesorderItem : redirected to composition child ZC_SalesorderItemTP01
 
}
