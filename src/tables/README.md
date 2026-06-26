# Tables DDIC

> Les tables sont créées dans ADT (DDIC). Ci-dessous la définition de référence des champs.

## ZEXP_REPORT — En-tête de la note de frais

| Champ | Type | Description |
|-------|------|-------------|
| `client` | `mandt` | Mandant |
| `report_uuid` | `sysuuid_x16` | **Clé** — UUID technique |
| `report_id` | `abap.char(10)` | Identifiant lisible (numérotation) |
| `title` | `abap.char(80)` | Titre de la note |
| `employee_id` | `abap.char(12)` | Matricule employé |
| `status` | `abap.char(1)` | Statut : `D`raft / `S`ubmitted / `A`pproved / `R`ejected |
| `total_amount` | `abap.curr(15,2)` | Montant total (calculé) |
| `currency_code` | `abap.cuky` | Devise |
| `submitted_at` | `abp_creation_tstmpl` | Date/heure de soumission |
| `created_by` | `abp_creation_user` | Admin |
| `created_at` | `abp_creation_tstmpl` | Admin |
| `last_changed_by` | `abp_lastchange_user` | Admin |
| `last_changed_at` | `abp_lastchange_tstmpl` | **Total etag** |
| `local_last_changed_at` | `abp_locinst_lastchange_tstmpl` | **Etag instance locale** |

## ZEXP_ITEM — Ligne de dépense

| Champ | Type | Description |
|-------|------|-------------|
| `client` | `mandt` | Mandant |
| `item_uuid` | `sysuuid_x16` | **Clé** — UUID technique |
| `report_uuid` | `sysuuid_x16` | **FK** vers ZEXP_REPORT |
| `item_pos` | `abap.numc(4)` | Numéro de ligne |
| `expense_type` | `abap.char(4)` | Type (TRSP, HOTL, MEAL, ...) |
| `description` | `abap.char(120)` | Libellé |
| `amount` | `abap.curr(15,2)` | Montant |
| `currency_code` | `abap.cuky` | Devise |
| `expense_date` | `abap.dats` | Date de la dépense |
| `local_last_changed_at` | `abp_locinst_lastchange_tstmpl` | Etag instance locale |

> Le framework RAP génère automatiquement les tables draft `ZEXP_REPORT_D` et `ZEXP_ITEM_D`.
