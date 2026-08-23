@EndUserText.label : 'Draft table for entity ZCJ_I_PRODUCT'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED

define table zcj_product_d {
  key mandt       : mandt not null;
  key productid   : abap.char(10) not null;

  productname     : abap.char(60);
  description     : abap.char(255);
  category        : abap.char(40);
  price           : abap.dec(13,2);
  currency        : abap.char(5);
  stock           : abap.int4;
  status          : abap.char(10);
  rejectionreason : abap.char(255);
  createdby       : abap.char(12);
  createdat       : abap.utclong;
  submittedat     : abap.utclong;
  approvedby      : abap.char(12);
  approvedat      : abap.utclong;
  lastchangedat   : abap.utclong;

  "%admin"        : include sych_bdl_draft_admin_inc;
}
