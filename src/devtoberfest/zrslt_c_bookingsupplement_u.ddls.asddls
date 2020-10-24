@EndUserText.label: 'Booking Supplement Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

@Search.searchable: true
define view entity ZRSLT_C_BookingSupplement_U
  as projection on ZRSLT_I_BookingSupplement_U

{ ///DMO/I_BookingSupplement_U
      @Search.defaultSearchElement: true
  key TravelID,

      @Search.defaultSearchElement: true
  key BookingID,

  key BookingSupplementID,

      @Consumption.valueHelpDefinition: [ {entity: { name:    '/DMO/I_SUPPLEMENT',
                                                     element: 'SupplementID' },
                                           additionalBinding: [ { localElement: 'Price',        element: 'Price'},
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' } ] } ]
      @ObjectModel.text.element: ['SupplementText']
      SupplementID,
      _SupplementText.Description as SupplementText : localized,

      Price,

      @Consumption.valueHelpDefinition: [ { entity: { name:    'I_Currency',
                                                      element: 'Currency' } } ]
      CurrencyCode,

      //      LastChangedAt,

      /* Associations */
      ///DMO/I_BookingSupplement_U
      _Booking : redirected to parent ZRSLT_C_Booking_U,
      _Travel  : redirected to ZRSLT_C_Travel_U,
      _Product,
      _SupplementText

}
