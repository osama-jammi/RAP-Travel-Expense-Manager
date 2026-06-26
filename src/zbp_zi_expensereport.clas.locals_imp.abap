"! Local handler class : validations, determinations and custom actions
"! for the ZI_ExpenseReport behavior.
CLASS lhc_Report DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF status,
        draft     TYPE c LENGTH 1 VALUE 'D',
        submitted TYPE c LENGTH 1 VALUE 'S',
        approved  TYPE c LENGTH 1 VALUE 'A',
        rejected  TYPE c LENGTH 1 VALUE 'R',
      END OF status.

    METHODS:
      validateAmounts  FOR VALIDATE ON SAVE IMPORTING keys FOR Report~validateAmounts,
      validateEmployee FOR VALIDATE ON SAVE IMPORTING keys FOR Report~validateEmployee,
      calculateTotal   FOR DETERMINE ON MODIFY IMPORTING keys FOR Report~calculateTotal,

      Submit  FOR MODIFY IMPORTING keys FOR ACTION Report~Submit  RESULT result,
      Approve FOR MODIFY IMPORTING keys FOR ACTION Report~Approve RESULT result,
      Reject  FOR MODIFY IMPORTING keys FOR ACTION Report~Reject  RESULT result,

      get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR Report RESULT result.

ENDCLASS.

CLASS lhc_Report IMPLEMENTATION.

  METHOD validateAmounts.
    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report BY \_Items
        FIELDS ( Amount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item) WHERE Amount <= 0.
      APPEND VALUE #( %tky = CORRESPONDING #( item->%tky ) ) TO failed-report.
      APPEND VALUE #( %tky = CORRESPONDING #( item->%tky )
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'Le montant doit être strictement positif.' ) ) TO reported-report.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmployee.
    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report
        FIELDS ( EmployeeID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    LOOP AT reports INTO DATA(report) WHERE EmployeeID IS INITIAL.
      APPEND VALUE #( %tky = report-%tky ) TO failed-report.
      APPEND VALUE #( %tky = report-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'Le matricule employé est obligatoire.' ) ) TO reported-report.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotal.
    " Recalcule TotalAmount = somme des montants des items.
    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report BY \_Items
        FIELDS ( Amount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    DATA totals TYPE TABLE FOR UPDATE ZI_ExpenseReport.

    LOOP AT items INTO DATA(item) GROUP BY item->ReportUUID INTO DATA(report_key).
      DATA(sum) = REDUCE #( INIT s = 0
                            FOR i IN GROUP report_key
                            NEXT s = s + i-Amount ).
      APPEND VALUE #( %tky        = VALUE #( ReportUUID = report_key )
                      TotalAmount  = sum
                      %control-TotalAmount = if_abap_behv=>mk-on ) TO totals.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report UPDATE FIELDS ( TotalAmount ) WITH totals.
  ENDMETHOD.

  METHOD Submit.
    MODIFY ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report UPDATE
        FIELDS ( Status SubmittedAt )
        WITH VALUE #( FOR key IN keys
                      ( %tky        = key-%tky
                        Status      = status-submitted
                        SubmittedAt = utclong_current( ) ) ).

    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD Approve.
    MODIFY ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = status-approved ) ).

    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD Reject.
    " Le motif de rejet est disponible dans keys-%param-Reason (ZD_RejectReason).
    MODIFY ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = status-rejected ) ).

    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    " Approve / Reject disponibles seulement quand le statut = Submitted.
    READ ENTITIES OF ZI_ExpenseReport IN LOCAL MODE
      ENTITY Report FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports
      ( %tky                 = r-%tky
        %features-%action-Submit  = COND #( WHEN r-Status = status-draft
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
        %features-%action-Approve = COND #( WHEN r-Status = status-submitted
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
        %features-%action-Reject  = COND #( WHEN r-Status = status-submitted
                                            THEN if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

ENDCLASS.
