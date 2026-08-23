@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Catalog Consumption View'
@Metadata.allowExtensions: true

define root view entity ZCJ_C_PRODUCT
  provider contract transactional_query
  as projection on ZCJ_I_PRODUCT
{
  key ProductId,
      ProductName,
      Description,
      Category,
      Price,
      Currency,
      Stock,
      Status,
      RejectionReason,
      CreatedBy,
      CreatedAt,
      SubmittedAt,
      ApprovedBy,
      ApprovedAt,
      LastChangedAt
}
