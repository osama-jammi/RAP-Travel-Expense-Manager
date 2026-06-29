@EndUserText.label : 'Draft - En-tete note de frais'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztem_raport_d {

  key client         : abap.clnt not null;
  key reportuuid     : sysuuid_x16 not null;   // = element ReportUUID (PAS report_uuid)
  reporttitle        : abap.char(60);          // = ReportTitle
  employeeid         : syuname;                // = EmployeeID
  status             : abap.char(4);           // = Status
  totalamount        : abap.dec(13,2);         // = TotalAmount
  currency           : waers;                  // = Currency
  submittedat        : timestampl;             // = SubmittedAt
  createdby          : syuname;                // = CreatedBy
  createdat          : timestampl;             // = CreatedAt
  changedby          : syuname;                // = ChangedBy
  changedat          : timestampl;             // = ChangedAt
  locallastchangedat : timestampl;             // = LocalLastChangedAt
  include sych_bdl_draft_admin_inc;            // champs techniques du draft
}
