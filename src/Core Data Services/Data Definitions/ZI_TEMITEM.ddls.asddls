@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Expense Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TemItem
  as select from ztem_item
  association to parent ZI_TemReport as _Report
    on $projection.ReportUUID = _Report.ReportUUID
{
  key item_uuid             as ItemUUID,
      report_uuid           as ReportUUID,
      item_pos              as ItemPos,
      expense_type          as ExpenseType,
      description           as Description,

      @Semantics.amount.currencyCode: 'Currency'
      amount                as Amount,
      @Semantics.currencyCode: true
      currency              as Currency,

      expense_date          as ExpenseDate,

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

      _Report
}
