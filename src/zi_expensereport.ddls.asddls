@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Expense Report - Interface View (root)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_ExpenseReport
  as select from zexp_report
  composition [0..*] of ZI_ExpenseItem as _Items
{
  key report_uuid                     as ReportUUID,
      report_id                       as ReportID,
      title                           as Title,
      employee_id                     as EmployeeID,
      status                          as Status,
      total_amount                    as TotalAmount,
      currency_code                   as CurrencyCode,
      submitted_at                    as SubmittedAt,

      @Semantics.user.createdBy: true
      created_by                      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                 as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                 as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at           as LocalLastChangedAt,

      // Associations
      _Items
}
