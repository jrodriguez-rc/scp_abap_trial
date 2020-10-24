@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZRSLT_I_TRAVEL_U
  as select from /dmo/travel as Travel
  composition [0..*] of ZRSLT_I_BOOKING_U as _Booking
  association [0..1] to /DMO/I_Agency     as _Agency   on $projection.AgencyID = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer   as _Customer on $projection.CustomerID = _Customer.CustomerID
  association [0..1] to I_Currency        as _Currency on $projection.CurrencyCode = _Currency.Currency
{
      ///dmo/travel
  key Travel.travel_id     as TravelID,
      Travel.agency_id     as AgencyID,
      Travel.customer_id   as CustomerID,
      Travel.begin_date    as BeginDate,
      Travel.end_date      as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.booking_fee   as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.total_price   as TotalPrice,
      Travel.currency_code as CurrencyCode,
      Travel.description   as Memo,
      Travel.status        as Status,
      Travel.lastchangedat as LastChangedAt,

      /* public associations */
      _Booking,
      _Agency,
      _Customer,
      _Currency

}
