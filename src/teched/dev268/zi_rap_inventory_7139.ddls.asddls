@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forInventory'
define root view entity ZI_RAP_INVENTORY_7139
  as select from zrap_inven_7139
{
  key uuid            as UUID,

      inventory_id    as InventoryID,

      product_id      as ProductID,

      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      quantity        as Quantity,

      quantity_unit   as QuantityUnit,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      price           as Price,

      currency_code   as CurrencyCode,

      remark          as Remark,

      not_available   as NotAvailable,

      @Semantics.user.createdBy: true
      created_by      as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt
}
