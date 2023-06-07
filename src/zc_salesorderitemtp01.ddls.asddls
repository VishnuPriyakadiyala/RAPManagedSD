@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSalesorderItem'
@ObjectModel.semanticKey: [ 'Orderitem' ]
@Search.searchable: true
define view entity ZC_SalesorderItemTP01
  as projection on ZR_SalesorderItemTP01
{
  key     OrderitemUUID,
          OrderUUID,

          _Salesorder.OrderID as OrderNumb,
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.90
          Orderitem,
          @Consumption.valueHelpDefinition: [ {
            entity: {
              name: 'ZI_PRODUCTVH',
              element: 'IdProd'
            }
          } ]

          @ObjectModel.foreignKey.association: '_ProductQV'
          Product,
          StarsValue,
          @Semantics.quantity.unitOfMeasure: 'Orderquantityunit'
          Orderquantity,
          @Semantics.unitOfMeasure: true
          @Consumption.valueHelpDefinition: [ {
            entity: {
              name: 'I_UnitOfMeasure',
              element: 'UnitOfMeasure'
            }
          } ]
          Orderquantityunit,
          @EndUserText.label: 'Product Price'

          @Semantics.amount.currencyCode: 'ProdCurrency'

          ProdPrice,
          //@Semantics.currencyCode: true
          ProdCurrency,
          //@Semantics.currencyCode: true
          //ProdCurrency,
          @Semantics.amount.currencyCode: 'Transactioncurrency'
          Netamount,
          @Consumption.valueHelpDefinition: [ {
            entity: {
              name: 'I_Currency',
              element: 'Currency'
            }
          } ]
          @Semantics.currencyCode: true
          Transactioncurrency,
          @Semantics.imageUrl: true
          @UI.textArrangement: #TEXT_ONLY
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRODUCT_IMG'
  virtual ProdImageURL : abap.string( 256 ),
          Creationdate,
          Createbyuser,
          Creationdatetime,
          Lastchangedbyuser,

          _Salesorder : redirected to parent ZC_SalesorderTP,
          _ProductQV

}
