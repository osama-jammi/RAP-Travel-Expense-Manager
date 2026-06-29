@EndUserText.label: 'Consumption View - Expense Report Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
  typeName:       'Expense Item',
  typeNamePlural: 'Expense Items',
  title:          { type: #STANDARD, value: 'Description' },
  description:    { type: #STANDARD, value: 'ExpenseType' }
}
define view entity ZC_TemItem
  as projection on ZI_TemItem
{
  key ItemUUID,
      @UI.lineItem:       [{ position: 10, label: 'Position' }]
      @UI.identification: [{ position: 10 }]
      ItemPos,
      @UI.lineItem:       [{ position: 20, label: 'Expense Type' }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      ExpenseType,
      @UI.lineItem:       [{ position: 30, label: 'Description' }]
      @UI.identification: [{ position: 30 }]
      Description,
      @UI.lineItem:       [{ position: 40, label: 'Amount' }]
      @UI.identification: [{ position: 40 }]
      Amount,
      Currency,
      @UI.lineItem:       [{ position: 50, label: 'Date' }]
      @UI.identification: [{ position: 50 }]
      ExpenseDate,
      ReportUUID,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocalLastChangedAt,
      _Report : redirected to parent ZC_TemReport
}
