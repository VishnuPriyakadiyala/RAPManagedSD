@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Status'

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.representativeKey: 'status' 
@Search.searchable: true
define view entity ZI_STATUSORDVH 
as select from ZI_STATUSORD 

{
 @Search.defaultSearchElement: true
 @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: [ 'status_text' ]
    key status,
     @UI.hidden:true
    status_text,
    /* Associations */
    _StatusText
}
