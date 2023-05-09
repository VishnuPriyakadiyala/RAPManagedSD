@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forSalesorder'
define root view entity ZR_SalesorderTP
  as select from zsd_vbak
  composition [0..*] of ZR_SalesorderItemTP01 as _SalesorderItem
  association [0..1] to ZI_STATUSORDVH        as _STATUS   on $projection.OverallStatus = _STATUS.status
  association [0..1] to zsd_customer          as _Customer on $projection.CustomerID = _Customer.customer_id

{
  key order_uuid            as OrderUUID,
      order_id              as OrderID,
      external_id           as ExternalID,
      customer_id           as CustomerID,
      order_date            as OrderDate,
      begin_date            as BeginDate,
      end_date              as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_fee               as NetFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price           as TotalPrice,
      currency_code         as CurrencyCode,
      description           as Description,

      overall_status        as OverallStatus,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt:true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _SalesorderItem,
      _STATUS,
      _Customer

}
