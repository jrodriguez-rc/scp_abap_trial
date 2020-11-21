@EndUserText.label: 'Travel BO projection view'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_RSLT_RAP_TRAVEL
  as projection on ZI_RSLT_RAP_Travel as Travel
{
  key TravelUUID,
      @Search.defaultSearchElement: true
      TravelID,
//      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency', element: 'AgencyID'} }] // From week 5
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCE_RSLT_RAP_AGENCY', element: 'AgencyId'} }] // From week 5
//      @ObjectModel.text.element: ['AgencyName'] // From week 5
      @Search.defaultSearchElement: true
      AgencyID,
//      _Agency.Name       as AgencyName, // From week 5
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID'} }]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      CustomerID,
      _Customer.LastName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      CurrencyCode,
      Description,
      TravelStatus,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZC_RSLT_RAP_BOOKING,
      _Currency,
      _Customer
}
