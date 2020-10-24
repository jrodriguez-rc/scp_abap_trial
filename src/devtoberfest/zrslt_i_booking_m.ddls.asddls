@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Booking View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRSLT_I_Booking_M
  as select from /dmo/booking_m as Booking
  association        to parent ZRSLT_I_TRAVEL_M as _Travel     on  $projection.travel_id = _Travel.travel_id
  composition [0..*] of ZRSLT_I_BookSuppl_M     as _BookSupplement

  association [1..1] to /DMO/I_Customer         as _Customer   on  $projection.customer_id = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier          as _Carrier    on  $projection.carrier_id = _Carrier.AirlineID
  association [1..1] to /DMO/I_Connection       as _Connection on  $projection.carrier_id    = _Connection.AirlineID
                                                               and $projection.connection_id = _Connection.ConnectionID
{
      ///dmo/booking_m
  key travel_id,
  key booking_id,

      booking_date,
      customer_id,
      carrier_id,
      connection_id,
      flight_date,
      @Semantics.amount.currencyCode: 'currency_code'
      flight_price,
      currency_code,
      booking_status,
      @UI.hidden: true
      _Travel.last_changed_at,

      /* Associations */
      _Travel,
      _BookSupplement,
      _Customer,
      _Carrier,
      _Connection

}
