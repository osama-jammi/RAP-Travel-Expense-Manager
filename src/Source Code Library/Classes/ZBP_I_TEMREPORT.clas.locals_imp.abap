CLASS lhc_ExpenseReport DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF c_status,
        draft     TYPE ztem_raport-status VALUE 'D',
        submitted TYPE ztem_raport-status VALUE 'S',
        approved  TYPE ztem_raport-status VALUE 'A',
        rejected  TYPE ztem_raport-status VALUE 'R',
      END OF c_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ExpenseReport RESULT result.
    
    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ExpenseReport~setInitialStatus.
    
    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR ExpenseReport~validateStatus.
    
    METHODS validateEmployee FOR VALIDATE ON SAVE
      IMPORTING keys FOR ExpenseReport~validateEmployee.
    
    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION ExpenseReport~submit RESULT result.
    
    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION ExpenseReport~approve RESULT result.
    
    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION ExpenseReport~reject RESULT result.
    
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ExpenseReport
      RESULT result.

ENDCLASS.

CLASS lhc_ExpenseReport IMPLEMENTATION.

  METHOD setInitialStatus.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    DELETE reports WHERE Status IS NOT INITIAL.
    CHECK reports IS NOT INITIAL.

    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR r IN reports
                    ( %tky = r-%tky
                      Status = c_status-draft ) ).
  ENDMETHOD.


  METHOD get_global_authorizations.
    result = VALUE #(
      %create         = if_abap_behv=>auth-allowed
      %update         = if_abap_behv=>auth-allowed
      %delete         = if_abap_behv=>auth-allowed
      %action-submit  = if_abap_behv=>auth-allowed
      %action-approve = if_abap_behv=>auth-allowed
      %action-reject  = if_abap_behv=>auth-allowed
    ).
  ENDMETHOD.


  METHOD validateStatus.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    DATA valid_status TYPE RANGE OF ztem_raport-status.
    valid_status = VALUE #(
      ( sign = 'I' option = 'EQ' low = c_status-draft )
      ( sign = 'I' option = 'EQ' low = c_status-submitted )
      ( sign = 'I' option = 'EQ' low = c_status-approved )
      ( sign = 'I' option = 'EQ' low = c_status-rejected )
    ).

    LOOP AT reports INTO DATA(report).
      IF report-Status NOT IN valid_status.
        APPEND VALUE #( %tky = report-%tky ) TO failed-expensereport.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD validateEmployee.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      FIELDS ( EmployeeID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    LOOP AT reports INTO DATA(report).
      IF report-EmployeeID IS INITIAL.
        APPEND VALUE #( %tky = report-%tky ) TO failed-expensereport.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD submit.
    GET TIME STAMP FIELD DATA(now).

    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      UPDATE FIELDS ( Status SubmittedAt )
      WITH VALUE #( FOR key IN keys
                    ( %tky = key-%tky
                      Status = c_status-submitted
                      SubmittedAt = now ) ).
  ENDMETHOD.


  METHOD approve.
    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
                    ( %tky = key-%tky
                      Status = c_status-approved ) ).
  ENDMETHOD.


  METHOD reject.
    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
                    ( %tky = key-%tky
                      Status = c_status-rejected ) ).
  ENDMETHOD.


  METHOD get_instance_features.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #(
      FOR report IN reports
      ( %tky = report-%tky
        %action-submit  = COND #( WHEN report-Status = c_status-draft
                                 THEN if_abap_behv=>fc-o-enabled
                                 ELSE if_abap_behv=>fc-o-disabled )
        %action-approve = COND #( WHEN report-Status = c_status-submitted
                                 THEN if_abap_behv=>fc-o-enabled
                                 ELSE if_abap_behv=>fc-o-disabled )
        %action-reject  = COND #( WHEN report-Status = c_status-submitted
                                 THEN if_abap_behv=>fc-o-enabled
                                 ELSE if_abap_behv=>fc-o-disabled ) )
    ).
  ENDMETHOD.

ENDCLASS.
