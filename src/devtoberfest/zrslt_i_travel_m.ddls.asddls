@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Travel view'
@AccessControl.authorizationCheck: #CHECK
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZRSLT_I_TRAVEL_M
  as select from /dmo/travel_m as Travel
  composition [0..*] of ZRSLT_I_Booking_M as _Booking

  association [0..1] to /DMO/I_Agency     as _Agency   on $projection.agency_id = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer   as _Customer on $projection.customer_id = _Customer.CustomerID
  association [0..1] to I_Currency        as _Currency on $projection.currency_code = _Currency.Currency
{

  key travel_id,      
    agency_id,         
    customer_id,  
    begin_date,  
    end_date,   
    @Semantics.amount.currencyCode: 'currency_code'
    booking_fee,
    @Semantics.amount.currencyCode: 'currency_code'
    total_price,
    currency_code,  
    overall_status,
    description,   
    @Semantics.user.createdBy: true 
    created_by,
    @Semantics.systemDateTime.createdAt: true       
    created_at,
    @Semantics.user.lastChangedBy: true    
    last_changed_by,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at,                -- used as etag field
    
    /* Associations */
    _Booking,
    _Agency,
    _Customer, 
    _Currency

  }
