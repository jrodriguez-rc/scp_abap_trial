@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRSLT_I_BOOKING_U
  as select from /dmo/booking as Booking
  association        to parent ZRSLT_I_TRAVEL_U     as _Travel     on  $projection.TravelID = _Travel.TravelID
  composition [0..*] of ZRSLT_I_BOOKINGSUPPLEMENT_U as _BookSupplement

  association [1..1] to /DMO/I_Customer             as _Customer   on  $projection.CustomerID = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier              as _Carrier    on  $projection.AirlineID = _Carrier.AirlineID
  association [1..1] to /DMO/I_Connection           as _Connection on  $projection.AirlineID    = _Connection.AirlineID
                                                                   and $projection.ConnectionID = _Connection.ConnectionID
{
  key travel_id     as TravelID,
  key booking_id    as BookingID,
      booking_date  as BookingDate,
      customer_id   as CustomerID,
      carrier_id    as AirlineID,
      connection_id as ConnectionID,
      flight_date   as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price  as FlightPrice,
      currency_code as CurrencyCode,
      //    _Travel.LastChangedAt as LastChangedAt, -- Take over ETag from parent

      /* public associations */
      _Travel,
      _BookSupplement,
      _Customer,
      _Carrier,
      _Connection

}
