@EndUserText.label: 'Travel Projection View'
@AccessControl.authorizationCheck: #CHECK

@Metadata.allowExtensions: true

@Search.searchable: true
define root view entity ZRSLT_C_TRAVEL_M
  as projection on ZRSLT_I_TRAVEL_M
{

  key travel_id          as TravelID,


      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency', element: 'AgencyID'  } }]

      @ObjectModel.text.element: ['AgencyName']
      @Search.defaultSearchElement: true
      agency_id          as AgencyID,
      _Agency.Name       as AgencyName,


      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]

      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      customer_id        as CustomerID,
      _Customer.LastName as CustomerName,

      begin_date         as BeginDate,

      end_date           as EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee        as BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price        as TotalPrice,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      currency_code      as CurrencyCode,

      overall_status     as TravelStatus,

      description        as Description,

      last_changed_at    as LastChangedAt,

      /* Associations */
      _Booking : redirected to composition child ZRSLT_C_BOOKING_M,
      _Agency,
      _Customer

}
