@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Booking Supplement view - CDS data model'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRSLT_I_BookSuppl_M
  as select from /dmo/booksuppl_m as BookingSupplement
  association        to parent ZRSLT_I_Booking_M as _Booking        on  $projection.travel_id  = _Booking.travel_id
                                                                    and $projection.booking_id = _Booking.booking_id

  association [1..1] to ZRSLT_I_TRAVEL_M         as _Travel         on  $projection.travel_id = _Travel.travel_id
  association [1..1] to /DMO/I_Supplement        as _Product        on  $projection.supplement_id = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText    as _SupplementText on  $projection.supplement_id = _SupplementText.SupplementID
{
  key travel_id,
  key booking_id,
  key booking_supplement_id,
      supplement_id,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      currency_code,

      @UI.hidden
      _Travel.last_changed_at,

      /* Associations */
      _Travel,
      _Booking,
      _Product,
      _SupplementText
}
