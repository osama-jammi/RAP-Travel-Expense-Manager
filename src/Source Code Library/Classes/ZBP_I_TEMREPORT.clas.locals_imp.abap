*"* Behavior implementation (local handler classes)
*"* Behavior pool : ZBP_I_TEMREPORT  /  FOR BEHAVIOR OF ZI_TemReport

"=====================================================================
"  Handler de l'entite racine : ExpenseReport (table ztem_raport)
"=====================================================================
CLASS lhc_ExpenseReport DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    " Codes statut (champ STATUS = char(4))
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

ENDCLASS.


CLASS lhc_ExpenseReport IMPLEMENTATION.

  " ---- Determination : statut initial a la creation -----------------
  METHOD setInitialStatus.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    " on ne force le statut que s'il est encore vide
    DELETE reports WHERE Status IS NOT INITIAL.
    CHECK reports IS NOT INITIAL.

    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR r IN reports
                      ( %tky   = r-%tky
                        Status = c_status-draft ) ).
  ENDMETHOD.


" --- dans la PRIVATE SECTION de lhc_ExpenseReport ---
METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
  IMPORTING REQUEST requested_authorizations FOR ExpenseReport
  RESULT result.

" --- dans la IMPLEMENTATION ---
METHOD get_global_authorizations.
  " Demo : on autorise tout
  result-%create         = if_abap_behv=>auth-allowed.
  result-%update         = if_abap_behv=>auth-allowed.
  result-%delete         = if_abap_behv=>auth-allowed.
  result-%action-submit  = if_abap_behv=>auth-allowed.
  result-%action-approve = if_abap_behv=>auth-allowed.
  result-%action-reject  = if_abap_behv=>auth-allowed.
ENDMETHOD.


  " ---- Validation : statut autorise --------------------------------
  METHOD validateStatus.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    DATA valid_status TYPE RANGE OF ztem_raport-status.
    valid_status = VALUE #( sign = 'I' option = 'EQ'
                            ( low = c_status-draft )
                            ( low = c_status-submitted )
                            ( low = c_status-approved )
                            ( low = c_status-rejected ) ).

    LOOP AT reports INTO DATA(report).
      IF report-Status NOT IN valid_status.
        APPEND VALUE #( %tky = report-%tky ) TO failed-expensereport.
        APPEND VALUE #( %tky            = report-%tky
                        %element-Status = if_abap_behv=>mk-on
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Statut invalide : { report-Status }| ) )
               TO reported-expensereport.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  " ---- Validation : employe obligatoire ----------------------------
  METHOD validateEmployee.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        FIELDS ( EmployeeID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    LOOP AT reports INTO DATA(report).
      IF report-EmployeeID IS INITIAL.
        APPEND VALUE #( %tky = report-%tky ) TO failed-expensereport.
        APPEND VALUE #( %tky                = report-%tky
                        %element-EmployeeID = if_abap_behv=>mk-on
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'L''employe est obligatoire' ) )
               TO reported-expensereport.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  " ---- Feature control : (de)activer submit/approve/reject ----------
  METHOD get_instance_features.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #(
      FOR report IN reports
      ( %tky            = report-%tky
        %action-submit  = COND #( WHEN report-Status = c_status-draft
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )
        %action-approve = COND #( WHEN report-Status = c_status-submitted
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )
        %action-reject  = COND #( WHEN report-Status = c_status-submitted
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.


  " ---- Action : soumettre ------------------------------------------
  METHOD submit.
    GET TIME STAMP FIELD DATA(now).

    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        UPDATE FIELDS ( Status SubmittedAt )
        WITH VALUE #( FOR key IN keys
                      ( %tky        = key-%tky
                        Status      = c_status-submitted
                        SubmittedAt = now ) ).

    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports
                      ( %tky   = r-%tky
                        %param = CORRESPONDING #( r ) ) ).
  ENDMETHOD.


  " ---- Action : approuver ------------------------------------------
  METHOD approve.
    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        Status = c_status-approved ) ).

    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports
                      ( %tky   = r-%tky
                        %param = CORRESPONDING #( r ) ) ).
  ENDMETHOD.


  " ---- Action : rejeter (avec motif) -------------------------------
  METHOD reject.
    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        Status = c_status-rejected ) ).

    " Le motif saisi est disponible dans keys[ n ]-%param-RejectReason.
    " (Ajoute un champ reject_reason a ztem_raport si tu veux le persister.)

    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    result = VALUE #( FOR r IN reports
                      ( %tky   = r-%tky
                        %param = CORRESPONDING #( r ) ) ).
  ENDMETHOD.

ENDCLASS.


"=====================================================================
"  Handler de l'entite enfant : ExpenseItem (table ztem_item)
"=====================================================================
CLASS lhc_ExpenseItem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calcTotalAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ExpenseItem~calcTotalAmount.

    METHODS validateAmount FOR VALIDATE ON SAVE
      IMPORTING keys FOR ExpenseItem~validateAmount.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ExpenseItem~validateDate.

ENDCLASS.


CLASS lhc_ExpenseItem IMPLEMENTATION.

  " ---- Determination : recalcul du total de l'en-tete ---------------
  METHOD calcTotalAmount.
    " 1) en-tetes parents des lignes modifiees
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseItem BY \_Report
        FIELDS ( ReportUUID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(reports).

    SORT reports BY %tky.
    DELETE ADJACENT DUPLICATES FROM reports COMPARING %tky.
    CHECK reports IS NOT INITIAL.

    DATA updates TYPE TABLE FOR UPDATE zi_temreport\\ExpenseReport.

    " 2) pour chaque en-tete : somme des montants de toutes ses lignes
    LOOP AT reports INTO DATA(report).
      READ ENTITIES OF zi_temreport IN LOCAL MODE
        ENTITY ExpenseReport BY \_Items
          FIELDS ( Amount )
          WITH VALUE #( ( %tky = report-%tky ) )
        RESULT DATA(items).

      DATA(total) = REDUCE ztem_raport-total_amount(
                      INIT s = CONV ztem_raport-total_amount( 0 )
                      FOR item IN items
                      NEXT s = s + item-Amount ).

      APPEND VALUE #( %tky        = report-%tky
                      TotalAmount = total ) TO updates.
    ENDLOOP.

    MODIFY ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseReport
        UPDATE FIELDS ( TotalAmount )
        WITH updates.
  ENDMETHOD.


  " ---- Validation : montant > 0 ------------------------------------
  METHOD validateAmount.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseItem
        FIELDS ( Amount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    LOOP AT items INTO DATA(item).
      IF item-Amount <= 0.
        APPEND VALUE #( %tky = item-%tky ) TO failed-expenseitem.
        APPEND VALUE #( %tky            = item-%tky
                        %element-Amount = if_abap_behv=>mk-on
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Le montant doit etre positif' ) )
               TO reported-expenseitem.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  " ---- Validation : date de depense valide --------------------------
  METHOD validateDate.
    READ ENTITIES OF zi_temreport IN LOCAL MODE
      ENTITY ExpenseItem
        FIELDS ( ExpenseDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT items INTO DATA(item).
      IF item-ExpenseDate IS INITIAL OR item-ExpenseDate > today.
        APPEND VALUE #( %tky = item-%tky ) TO failed-expenseitem.
        APPEND VALUE #( %tky                 = item-%tky
                        %element-ExpenseDate = if_abap_behv=>mk-on
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Date de depense invalide (vide ou future)' ) )
               TO reported-expenseitem.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
