@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Catalog Interface View'

define root view entity ZCJ_I_PRODUCT
  as select from zcj_product
{
  key product_id      as ProductId,
      product_name     as ProductName,
      description      as Description,
      category         as Category,
      price             as Price,
      currency          as Currency,
      stock             as Stock,
      status            as Status,
      rejection_reason  as RejectionReason,
      created_by        as CreatedBy,
      created_at        as CreatedAt,
      submitted_at      as SubmittedAt,
      approved_by       as ApprovedBy,
      approved_at       as ApprovedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt
}
