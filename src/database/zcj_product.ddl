@EndUserText.label : 'Product Catalog Persistence Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED

define table zcj_product {
  key client       : abap.clnt not null;
  key product_id   : abap.char(10) not null;

  product_name     : abap.char(60);
  description      : abap.char(255);
  category         : abap.char(40);
  price            : abap.dec(13,2);
  currency         : abap.char(5);
  stock            : abap.int4;
  status           : abap.char(10);
  rejection_reason : abap.char(255);
  created_by       : abap.char(12);
  created_at       : abap.utclong;
  submitted_at     : abap.utclong;
  approved_by      : abap.char(12);
  approved_at      : abap.utclong;
  last_changed_at  : abap.utclong;
}
