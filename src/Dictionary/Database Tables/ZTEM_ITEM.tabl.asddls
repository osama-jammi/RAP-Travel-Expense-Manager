@EndUserText.label : 'Ligne de depense'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztem_item {

  key client            : abap.clnt not null;
  key item_uuid         : sysuuid_x16 not null;
  report_uuid           : sysuuid_x16 not null;
  item_pos              : abap.int2;
  expense_type          : abap.char(4);
  description           : abap.char(60);
  amount                : abap.dec(13,2);
  currency              : waers;
  expense_date          : abap.dats;
  created_by            : syuname;
  created_at            : timestampl;
  changed_by            : syuname;
  changed_at            : timestampl;
  local_last_changed_at : timestampl;

}
