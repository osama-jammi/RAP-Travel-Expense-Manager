@EndUserText.label: 'Consumption View - Expense Report Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
  typeName:       'Expense Report',
  typeNamePlural: 'Expense Reports',
  title:          { type: #STANDARD, value: 'ReportTitle' },
  description:    { type: #STANDARD, value: 'Status' }
}
define root view entity ZC_TemReport
  as projection on ZI_TemReport
{
      @UI.facet: [
        { id:       'HeaderFacet',
          type:     #IDENTIFICATION_REFERENCE,
          label:    'General Information',
          position: 10 },
        { id:           'ItemsFacet',
          type:           #LINEITEM_REFERENCE,
          label:          'Expense Items',
          position:       20,
          targetElement:  '_Items' }
      ]
  key ReportUUID,
      @UI.lineItem:       [{ position: 10, label: 'Title' }]
      @UI.identification: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      ReportTitle,
      @UI.lineItem:       [{ position: 20, label: 'Employee' }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 20 }]
      EmployeeID,
      @UI.lineItem: [
        { position: 30, label: 'Status' },
        { type: #FOR_ACTION, dataAction: 'submit',  label: 'Submit',  position: 10 },
        { type: #FOR_ACTION, dataAction: 'approve', label: 'Approve', position: 20 },
        { type: #FOR_ACTION, dataAction: 'reject',  label: 'Reject',  position: 30 }
      ]
      @UI.identification: [{ position: 30 }]
      @UI.selectionField: [{ position: 30 }]
      Status,
      @UI.lineItem:       [{ position: 40, label: 'Total Amount' }]
      @UI.identification: [{ position: 40 }]
      TotalAmount,
      Currency,
      SubmittedAt,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      LocalLastChangedAt,
      _Items : redirected to composition child ZC_TemItem
}
