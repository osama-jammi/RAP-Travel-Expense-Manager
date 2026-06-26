@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Expense Item - Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_ExpenseItem
  as select from zexp_item
  association to parent ZI_ExpenseReport as _Report on $projection.ReportUUID = _Report.ReportUUID
{
  key item_uuid                       as ItemUUID,
      report_uuid                     as ReportUUID,
      item_pos                        as ItemPosition,
      expense_type                    as ExpenseType,
      description                     as Description,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      amount                          as Amount,
      currency_code                   as CurrencyCode,
      expense_date                    as ExpenseDate,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at           as LocalLastChangedAt,

      // Associations
      _Report
}
