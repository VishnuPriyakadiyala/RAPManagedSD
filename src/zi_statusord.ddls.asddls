@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Text value help'
@ObjectModel.representativeKey: 'status'
define view entity ZI_STATUSORD 
as select from zsd_status
association[0..*] to zsd_status_text as _StatusText 
on $projection.status = _StatusText.status
{


    @ObjectModel.text.association: '_StatusText'
    key status,
    _StatusText[1:langu=$session.system_language].status_text,
        _StatusText  // Make association public
}

