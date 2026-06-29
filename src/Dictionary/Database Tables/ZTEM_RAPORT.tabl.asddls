@EndUserText.label : 'En-tete de la note de frais'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztem_raport {

  key client            : abap.clnt not null;
  key report_uuid       : sysuuid_x16 not null;
  report_title          : abap.char(60);
  employee_id           : syuname;
  status                : abap.char(4);
  total_amount          : abap.dec(13,2);
  currency              : waers;
  submitted_at          : timestampl;
  created_by            : syuname;
  created_at            : timestampl;
  changed_by            : syuname;
  changed_at            : timestampl;
  local_last_changed_at : timestampl;

}
