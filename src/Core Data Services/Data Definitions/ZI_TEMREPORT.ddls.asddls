@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Expense Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TemReport
  as select from ztem_raport
  composition [0..*] of ZI_TemItem as _Items
{
  key report_uuid           as ReportUUID,
      report_title          as ReportTitle,
      employee_id           as EmployeeID,
      status                as Status,

      @Semantics.amount.currencyCode: 'Currency'
      total_amount          as TotalAmount,
      @Semantics.currencyCode: true
      currency              as Currency,

      submitted_at          as SubmittedAt,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by            as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at            as ChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Items
}
