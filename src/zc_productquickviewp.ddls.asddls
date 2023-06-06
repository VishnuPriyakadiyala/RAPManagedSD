@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Quick View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_PRODUCTQUICKVIEWP as select from ZI_PRODUCTQUICKVIEW
{
        @UI.facet: [ {
                     purpose:    #QUICK_VIEW,
                     type:       #FIELDGROUP_REFERENCE,
                     targetQualifier: 'ProductQV',
                     label: 'Additional Details'
                   }
                 ]

      @UI.fieldGroup: [{ qualifier:'ProductQV', position: 10}]
      @EndUserText.label:'Product Id'
  key Product,
      @UI.fieldGroup: [{ qualifier:'ProductQV', position: 20}]
      @EndUserText.label: 'Product Family'
      IdFamily,
      @UI.fieldGroup: [{ qualifier:'ProductQV', position: 30}]
      @Semantics: {
       text: true

       }
      @EndUserText.label: 'Product Text'
      ProdTxt
}
