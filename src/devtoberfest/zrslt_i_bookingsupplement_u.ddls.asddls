@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Booking Supplement view - CDS data model'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRSLT_I_BOOKINGSUPPLEMENT_U
  as select from /dmo/book_suppl as BookingSupplement
  association        to parent ZRSLT_I_BOOKING_U as _Booking        on  $projection.TravelID  = _Booking.TravelID
                                                                    and $projection.BookingID = _Booking.BookingID
  association [1..1] to ZRSLT_I_TRAVEL_U         as _Travel         on  $projection.TravelID = _Travel.TravelID
  association [1..1] to /DMO/I_Supplement        as _Product        on  $projection.SupplementID = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText    as _SupplementText on  $projection.SupplementID = _SupplementText.SupplementID

{
  key travel_id             as TravelID,
  key booking_id            as BookingID,
  key booking_supplement_id as BookingSupplementID,
      supplement_id         as SupplementID,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,

      //      _Booking.LastChangedAt                  as LastChangedAt,

      /* Associations */
      _Booking,
      _Travel,
      _Product,
      _SupplementText
}
