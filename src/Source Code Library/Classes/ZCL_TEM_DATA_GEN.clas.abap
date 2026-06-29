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

    DATA(r1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(r3) = cl_system_uuid=>create_uuid_x16_static( ).

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
        item_pos = 3 expense_type = 'DIVR' description = 'Carburant et peage autoroute'        amount = '320.00' ) ).

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
                         FOR i IN lt_items WHERE ( report_uuid = r3 ) NEXT s = s + i-amount ) ) ).

    INSERT ztem_raport FROM TABLE @lt_reports.
    INSERT ztem_item   FROM TABLE @lt_items.
    COMMIT WORK.

    out->write( |{ lines( lt_reports ) } notes de frais inserees (Casablanca, Rabat, Marrakech).| ).
    out->write( |{ lines( lt_items ) } lignes de depense inserees, devise MAD.| ).

  ENDMETHOD.

ENDCLASS.
