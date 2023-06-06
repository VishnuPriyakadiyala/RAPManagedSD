@EndUserText.label: 'Add Discount'
@Metadata.allowExtensions: true
define abstract entity ZI_AddDiscount
 // with parameters parameter_name : parameter_type
{

 
 @Semantics.amount.currencyCode : 'currency_code'
 discount_fee : /dmo/total_price; 
 @Consumption.valueHelpDefinition: [{ entity.name: 'I_CurrencyStdVH', entity.element: 'Currency' }]
 currency_code : /dmo/currency_code;  
}
