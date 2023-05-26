@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZI_PRODUCTVH
  as select from zsd_product
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['ProdTxt']
      @EndUserText.label: 'Product'
  key id_prod   as IdProd,
   @EndUserText.label: 'Product Family'
      id_family as IdFamily,
      @Semantics.text: true
       @EndUserText.label: 'Product Text'
      prod_txt  as ProdTxt,
//      @Consumption.valueHelpDefinition: [{entity: { name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
 @EndUserText.label: 'Currency'
      currency  as Currency,
      @Semantics.amount.currencyCode: 'Currency'
       @EndUserText.label: 'Product Price'
      price     as prod_Price
}
