@EndUserText.label: 'Booking Supplement Projection View'
@AccessControl.authorizationCheck: #CHECK

@Metadata.allowExtensions: true

@Search.searchable: true
define view entity ZRSLT_C_BOOKSUPPL_M
  as projection on ZRSLT_I_BOOKSUPPL_M
{

      @Search.defaultSearchElement: true
  key travel_id                   as TravelID,

      @Search.defaultSearchElement: true
  key booking_id                  as BookingID,

  key booking_supplement_id       as BookingSupplementID,

      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_SUPPLEMENT', element: 'SupplementID' } ,
                                           additionalBinding: [ { localElement: 'Price',  element: 'Price' },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' }] }]
      @ObjectModel.text.element: ['SupplementDescription']
      supplement_id               as SupplementID,
      _SupplementText.Description as SupplementDescription : localized,


      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                       as Price,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      currency_code               as CurrencyCode,

      last_changed_at             as LastChangedAt,

      /* Associations */
      _Booking : redirected to parent ZRSLT_C_Booking_M,
      _SupplementText
}
