@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '(Outbound) Navigation'
@ObjectModel : { resultSet.sizeCategory: #XS }

@Consumption.semanticObject: 'ProductQV'

@UI.headerInfo: {
  typeName: 'Product',
  typeNamePlural: 'Products',
  title.value: 'ProdTxt',
  description.value: 'ProdTxt'
  }

define view entity ZI_PRODUCTQUICKVIEW as select from zsd_product
{

  @UI.facet: [
        {
          type: #FIELDGROUP_REFERENCE,
          label: 'Navigation',
          targetQualifier: 'data',
          purpose: #QUICK_VIEW
        }
//        ,
//        {
//          type: #IDENTIFICATION_REFERENCE,
//          label: 'Navigational Properties'
//        }
      ]
         @UI.fieldGroup: [{ qualifier: 'data', position: 10 }]
  
      @ObjectModel.text.element: ['ProdTxt']
    key id_prod as Product,
      @EndUserText.label : 'Product Family'
     @UI.fieldGroup: [{ qualifier: 'data', position: 20 }]
    
    id_family as IdFamily,
    
     @EndUserText.label : 'Product Text'
      @UI: {
       
        fieldGroup: [{ qualifier: 'data', position: 30 }]
       
      }
    prod_txt as ProdTxt
   
}
