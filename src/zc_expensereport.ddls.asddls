@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Expense Report - Projection View'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_ExpenseReport
  provider contract transactional_query
  as projection on ZI_ExpenseReport
{
  key ReportUUID,
      ReportID,
      @Search.defaultSearchElement: true
      Title,
      EmployeeID,
      Status,
      TotalAmount,
      CurrencyCode,
      SubmittedAt,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items : redirected to composition child ZC_ExpenseItem
}
