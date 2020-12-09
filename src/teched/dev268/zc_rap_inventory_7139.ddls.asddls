@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forInventory'
@Search.searchable: true
define root view entity ZC_RAP_INVENTORY_7139
  as projection on ZI_RAP_INVENTORY_7139
{
      @Search.defaultSearchElement: true
  key UUID,

      @Search.defaultSearchElement: true
      InventoryID,

      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZCE_RAP_PRODUCTS_7139', element: 'Product' } }]
      ProductID,

      Quantity,

      QuantityUnit,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,

      CurrencyCode,

      Remark,

      NotAvailable,

      CreatedBy,

      CreatedAt,

      LastChangedBy,

      LastChangedAt
}
