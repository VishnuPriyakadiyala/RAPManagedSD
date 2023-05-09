@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'status text'
@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'status'

define  view entity ZI_STATUSTEXTORD 
as select from zsd_status_text as _statustext
 association[0..1] to I_Language as _Language 
  on   _statustext.langu = _Language.Language
 
{
    key status as Status,
     @Semantics.language
    key  langu as Language,  
    @Semantics.text
    status_text as StatusText,
   _Language
}
