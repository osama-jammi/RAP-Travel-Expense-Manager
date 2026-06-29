CLASS zcl_tem_data_gen DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_tem_data_gen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " --- Reinitialisation : vide les tables avant rechargement ---
    DELETE FROM ztem_item.
    DELETE FROM ztem_raport.

    GET TIME STAMP FIELD DATA(now).
    DATA(today) = cl_abap_context_info=>get_system_date( ).

    DATA lt_reports TYPE STANDARD TABLE OF ztem_raport WITH EMPTY KEY.
    DATA lt_items   TYPE STANDARD TABLE OF ztem_item   WITH EMPTY KEY.

    " UUID des en-tetes
    DATA(r1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r3) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r4) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r5) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r6) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r7) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r8) = cl_system_uuid=>create_uuid_x16_static( ).

    " ============ Lignes de depense (toutes en MAD) ============
    lt_items = VALUE #(
      created_by = sy-uname created_at = now
      changed_by = sy-uname changed_at = now
      local_last_changed_at = now currency = 'MAD' expense_date = today

      " --- Rapport 1 : Mission Casablanca ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r1
        item_pos = 1 expense_type = 'TRSP' description = 'Train Al Boraq Tanger - Casablanca' amount = '209.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r1
        item_pos = 2 expense_type = 'HOTL' description = 'Hotel Barcelo Casablanca - 2 nuits'  amount = '1400.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r1
        item_pos = 3 expense_type = 'REST' description = 'Diner restaurant centre-ville'       amount = '350.00' )

      " --- Rapport 2 : Formation Rabat ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r2
        item_pos = 1 expense_type = 'TRSP' description = 'Taxi aeroport Rabat-Sale'            amount = '150.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r2
        item_pos = 2 expense_type = 'HOTL' description = 'Riad Medina Rabat - 3 nuits'         amount = '2100.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r2
        item_pos = 3 expense_type = 'REST' description = 'Repas pendant la formation'          amount = '480.00' )

      " --- Rapport 3 : Chantier Marrakech ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r3
        item_pos = 1 expense_type = 'TRSP' description = 'Location voiture Marrakech'          amount = '600.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r3
        item_pos = 2 expense_type = 'HOTL' description = 'Hotel Atlas Medina Marrakech'        amount = '950.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r3
        item_pos = 3 expense_type = 'DIVR' description = 'Carburant et peage autoroute'        amount = '320.00' )

      " --- Rapport 4 : Mission commerciale Agadir (rejetee) ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r4
        item_pos = 1 expense_type = 'TRSP' description = 'Vol Casablanca - Agadir A/R'         amount = '1250.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r4
        item_pos = 2 expense_type = 'HOTL' description = 'Hotel front de mer - 2 nuits'        amount = '1600.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r4
        item_pos = 3 expense_type = 'REST' description = 'Diner clients (non justifie)'        amount = '900.00' )

      " --- Rapport 5 : Conference Tanger Tech ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r5
        item_pos = 1 expense_type = 'TRSP' description = 'Train Al Boraq Casablanca - Tanger'  amount = '224.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r5
        item_pos = 2 expense_type = 'HOTL' description = 'Hilton Tanger - 1 nuit'              amount = '1100.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r5
        item_pos = 3 expense_type = 'FORM' description = 'Inscription conference'              amount = '750.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r5
        item_pos = 4 expense_type = 'REST' description = 'Repas midi'                          amount = '180.00' )

      " --- Rapport 6 : Audit interne Fes ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r6
        item_pos = 1 expense_type = 'TRSP' description = 'Train Casablanca - Fes'              amount = '198.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r6
        item_pos = 2 expense_type = 'HOTL' description = 'Hotel Medina Fes - 3 nuits'          amount = '1800.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r6
        item_pos = 3 expense_type = 'DIVR' description = 'Fournitures de bureau'               amount = '260.00' )

      " --- Rapport 7 : Deplacement Oujda (brouillon) ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r7
        item_pos = 1 expense_type = 'TRSP' description = 'Vol Casablanca - Oujda'              amount = '980.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r7
        item_pos = 2 expense_type = 'TAXI' description = 'Taxi centre ville'                   amount = '120.00' )

      " --- Rapport 8 : Salon professionnel Casablanca ---
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r8
        item_pos = 1 expense_type = 'HOTL' description = 'Hotel proche OFEC - 2 nuits'         amount = '1500.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r8
        item_pos = 2 expense_type = 'REST' description = 'Buffet networking'                   amount = '420.00' )
      ( item_uuid = cl_system_uuid=>create_uuid_x16_static( ) report_uuid = r8
        item_pos = 3 expense_type = 'TELE' description = 'Forfait data evenement'              amount = '90.00' ) ).

    " ============ En-tetes des notes de frais ============
    lt_reports = VALUE #(
      created_by = sy-uname created_at = now
      changed_by = sy-uname changed_at = now
      local_last_changed_at = now currency = 'MAD'

      ( report_uuid = r1 report_title = 'Mission commerciale Casablanca' employee_id = 'ELAMRANI'
        status = 'A' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r1 ) NEXT s = s + i-amount ) )

      ( report_uuid = r2 report_title = 'Formation SAP a Rabat' employee_id = 'BENNANI'
        status = 'S' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r2 ) NEXT s = s + i-amount ) )

      ( report_uuid = r3 report_title = 'Visite chantier Marrakech' employee_id = 'TAZI'
        status = 'D'
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r3 ) NEXT s = s + i-amount ) )

      ( report_uuid = r4 report_title = 'Mission commerciale Agadir' employee_id = 'IDRISSI'
        status = 'R' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r4 ) NEXT s = s + i-amount ) )

      ( report_uuid = r5 report_title = 'Conference Tanger Tech' employee_id = 'ALAOUI'
        status = 'S' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r5 ) NEXT s = s + i-amount ) )

      ( report_uuid = r6 report_title = 'Audit interne Fes' employee_id = 'CHRAIBI'
        status = 'A' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r6 ) NEXT s = s + i-amount ) )

      ( report_uuid = r7 report_title = 'Deplacement Oujda' employee_id = 'BERRADA'
        status = 'D'
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r7 ) NEXT s = s + i-amount ) )

      ( report_uuid = r8 report_title = 'Salon professionnel Casablanca' employee_id = 'ELAMRANI'
        status = 'S' submitted_at = now
        total_amount = REDUCE ztem_raport-total_amount(
                         INIT s = CONV ztem_raport-total_amount( 0 )
                         FOR i IN lt_items WHERE ( report_uuid = r8 ) NEXT s = s + i-amount ) ) ).

    INSERT ztem_raport FROM TABLE @lt_reports.
    INSERT ztem_item   FROM TABLE @lt_items.
    COMMIT WORK.

    out->write( |{ lines( lt_reports ) } notes de frais inserees (8 villes du Maroc).| ).
    out->write( |{ lines( lt_items ) } lignes de depense inserees, devise MAD.| ).
    out->write( |Statuts : Brouillon (D), Soumis (S), Approuve (A), Rejete (R).| ).

  ENDMETHOD.

ENDCLASS.
