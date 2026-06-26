@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Expense Item - Projection View'
@Metadata.allowExtensions: true
define view entity ZC_ExpenseItem
  as projection on ZI_ExpenseItem
{
  key ItemUUID,
      ReportUUID,
      ItemPosition,
      ExpenseType,
      Description,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Amount,
      CurrencyCode,
      ExpenseDate,
      LocalLastChangedAt,

      _Report : redirected to parent ZC_ExpenseReport
}
