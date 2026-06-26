# Architecture technique

## Vue d'ensemble RAP

Le projet suit le **ABAP RESTful Application Programming Model (RAP)** en mode **managed avec draft**.

```
Fiori Elements (List Report + Object Page)
        │  OData V4
Service Binding  ──  Service Definition  (ZUI_ExpenseReport_O4)
        │
Projection Layer :  ZC_ExpenseReport / ZC_ExpenseItem  (+ Metadata Extension)
        │
Behavior         :  ZI_ExpenseReport (managed, draft) — Submit / Approve / Reject
        │
Interface Layer  :  ZI_ExpenseReport ─(composition 0..*)─ ZI_ExpenseItem
        │
Persistance      :  ZEXP_REPORT (root) / ZEXP_ITEM (child)
```

## Couches

### 1. Persistance (DDIC)
- `ZEXP_REPORT` : table de l'en-tête. Clé technique `report_uuid` (RAW 16).
- `ZEXP_ITEM` : table des lignes. Clé `item_uuid`, FK `report_uuid`.
- Champs d'administration : `created_by/at`, `last_changed_by/at`, `local_last_changed_at` (etags RAP).
- Tables draft `ZEXP_REPORT_D` / `ZEXP_ITEM_D` générées par le framework.

### 2. Interface Views (CDS)
- `ZI_ExpenseReport` : **root view entity**, `composition [0..*] of ZI_ExpenseItem`.
- `ZI_ExpenseItem` : `association to parent`.
- Annotations sémantiques pour les champs d'administration et les etags.

### 3. Behavior
- Implémentation **managed** dans `ZBP_ZI_ExpenseReport`.
- **Draft** activé (`with draft`).
- **Actions** : `Submit`, `Approve`, `Reject(parameter)`.
- **Validations** : montants > 0, employé renseigné, cohérence du statut.
- **Détermination** : calcul du `TotalAmount` à partir des items.
- **Feature control** : Approve/Reject seulement si statut = *Submitted*.

### 4. Projection & Service
- `ZC_ExpenseReport` / `ZC_ExpenseItem` : projection views.
- `ZUI_ExpenseReport_O4` : *service definition* (expose la projection).
- *Service Binding* de type **OData V4 - UI**.

### 5. UI Fiori Elements
- `ZC_ExpenseReport` enrichie via **Metadata Extension** (`@UI` annotations).
- List Report + Object Page générées automatiquement.

## Machine à états (statut)

```
        Submit            Approve
Draft ─────────► Submitted ─────────► Approved
                   │
                   │ Reject
                   ▼
                Rejected ──(Edit)──► Draft
```
