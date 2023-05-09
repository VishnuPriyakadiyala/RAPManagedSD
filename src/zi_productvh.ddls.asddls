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
  key id_prod   as IdProd,
      id_family as IdFamily,
      @Semantics.text: true
      prod_txt  as ProdTxt,
//      @Consumption.valueHelpDefinition: [{entity: { name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      currency  as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      price     as prod_Price
}
