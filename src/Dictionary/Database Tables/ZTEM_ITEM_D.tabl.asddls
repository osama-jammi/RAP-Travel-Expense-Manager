@EndUserText.label : 'Draft - Ligne de depense'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztem_item_d {

  key client         : abap.clnt not null;
  key itemuuid       : sysuuid_x16 not null;   // = element ItemUUID (PAS item_uuid)
  reportuuid         : sysuuid_x16 not null;   // = ReportUUID (NON cle dans le draft)
  itempos            : abap.int2;              // = ItemPos
  expensetype        : abap.char(4);           // = ExpenseType
  description        : abap.char(60);          // = Description
  amount             : abap.dec(13,2);         // = Amount
  currency           : waers;                  // = Currency
  expensedate        : abap.dats;              // = ExpenseDate
  createdby          : syuname;                // = CreatedBy
  createdat          : timestampl;             // = CreatedAt
  changedby          : syuname;                // = ChangedBy
  changedat          : timestampl;             // = ChangedAt
  locallastchangedat : timestampl;             // = LocalLastChangedAt
  include sych_bdl_draft_admin_inc;
}
