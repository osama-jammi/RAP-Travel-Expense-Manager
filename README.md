<h1 align="center">✈️ RAP Travel &amp; Expense Manager</h1>

<p align="center">
  <i>Gestion des notes de frais de bout en bout, construite avec le ABAP RESTful Application Programming Model (RAP).</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ABAP-0A6ED1?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/RAP-1B6EC2?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/CDS_Views-0FAAFF?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/OData_v4-008FD3?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/Draft-1B6EC2?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/SAP_Fiori-0FAAFF?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/ABAP_Cloud-0A6ED1?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

---

## 🎯 Problème résolu

Beaucoup d'entreprises gèrent encore les **notes de frais** manuellement (Excel, mails) ou avec des outils déconnectés de SAP. Ce projet propose une application **RAP managed (avec draft)** native S/4HANA / BTP qui couvre tout le cycle :

> **Saisie (brouillon) → Soumission → Validation (Approve / Reject) → Suivi du statut**

avec une UI **Fiori Elements** générée par annotations et une API **OData V4**.

## 🔄 Cycle de vie du statut

| Code | Statut | Transition |
|------|--------|------------|
| `D` | Brouillon (Draft) | créé automatiquement → action **Submit** |
| `S` | Soumis (Submitted) | → action **Approve** ou **Reject** |
| `A` | Approuvé (Approved) | état final |
| `R` | Rejeté (Rejected) | état final (avec motif) |

Les actions sont **activées/désactivées dynamiquement** selon le statut (*instance feature control*).

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     SAP Fiori Elements (UI)                    │
│              List Report  +  Object Page (auto)                │
└───────────────────────────────┬──────────────────────────────┘
                                 │ OData V4
┌───────────────────────────────┴──────────────────────────────┐
│  Service Binding  ZUI_TEM_REPORT_04  (OData V4 · UI)          │
│        ◄────────  Service Definition  ZUI_TEM_REPORT          │
├──────────────────────────────────────────────────────────────┤
│  Projection Views  ZC_TemReport / ZC_TemItem                  │
│  (annotations @UI inline : headerInfo, facet, lineItem…)      │
│  Behavior de projection  ZC_TemReport  (use draft + actions)  │
├──────────────────────────────────────────────────────────────┤
│  Behavior Definition (managed, draft)  ZI_TemReport           │
│  Actions: Submit · Approve · Reject(motif)                    │
│  Déterminations · Validations · Feature & Authorization ctrl  │
│  Behavior Pool  ZBP_I_TEMREPORT  (lhc_ExpenseReport / Item)   │
├──────────────────────────────────────────────────────────────┤
│  Interface Views  ZI_TemReport ──(composition)── ZI_TemItem   │
├──────────────────────────────────────────────────────────────┤
│  Tables DDIC  ZTEM_RAPORT (+ _D) / ZTEM_ITEM (+ _D draft)     │
└──────────────────────────────────────────────────────────────┘
```

Voir [`docs/architecture.md`](docs/architecture.md) pour le détail.

## 🧩 Modèle métier

| Objet | Rôle | Champs clés |
|-------|------|-------------|
| **ZI_TemReport** *(root)* | En-tête de la note de frais | titre, employé, statut, montant total, devise, date de soumission |
| **ZI_TemItem** *(child)* | Lignes de dépense — en **composition** du header | position, type, description, montant, devise, date |
| **ztem_reject_param** | Entité abstraite : paramètre de l'action **Reject** | motif du rejet |

## ⚙️ Fonctionnalités RAP

- **Managed + Draft** : sauvegarde intermédiaire (brouillon) via tables draft `_D`.
- **Numérotation managed** : clés `ReportUUID` / `ItemUUID` générées automatiquement (UUID).
- **Déterminations**
  - `setInitialStatus` → statut `D` à la création.
  - `calcTotalAmount` → recalcul du **montant total** de l'en-tête = somme des lignes.
- **Validations** (`on save`) : `validateStatus`, `validateEmployee`, `validateAmount` (> 0), `validateDate` (non vide / non future).
- **Actions métier** : `submit`, `approve`, `reject` *(avec motif)* — résultat `$self`.
- **Feature control d'instance** : `get_instance_features` active/désactive Submit/Approve/Reject selon le statut.
- **Contrôle d'autorisation global** : `get_global_authorizations`.
- **Champs** : `readonly` (zones techniques + total), `mandatory` (titre, employé, devise…), **ETag / lock master** pour la concurrence.

## ⚒️ Stack technique

- **CDS** : interface views + projection views + association / composition
- **Behavior Definition & Implementation** : RAP *managed* avec *draft*
- **OData V4** via *Service Definition* + *Service Binding* (catégorie UI)
- **SAP Fiori Elements** (List Report Object Page) — annotations `@UI` inline
- **ABAP Cloud** / **BTP ABAP Environment** (ABAP for Cloud Development)

## 🗺️ Roadmap

| Phase | Contenu | Branche |
|-------|---------|---------|
| **1** | Modèle de données : tables DDIC (+ draft), interface views, composition | `feature/01-data-model-cds` |
| **2** | Behavior managed + draft : actions, validations, déterminations, feature/auth control, classe de génération de données | `feature/02-behavior-actions` |
| **3** | Projection views + `@UI`, service definition, service binding OData V4, app Fiori | `feature/03-service-fiori` |

Détail des tâches dans les [**Issues**](../../issues) et la [**Roadmap**](docs/roadmap.md).

## 🚀 Démarrage

> Prérequis : un système **SAP BTP ABAP Environment** (ou S/4HANA 2022+) + **ABAP Development Tools (ADT)** dans Eclipse, et **abapGit**.

```text
1. Cloner ce repo dans un package ABAP via abapGit
2. Activer les objets dans l'ordre :
   tables → interface CDS (ZI_*) → behavior def (ZI_TemReport)
   → behavior pool (ZBP_I_TEMREPORT) → projection CDS (ZC_*)
   → behavior de projection → service definition → service binding
3. (Optionnel) Exécuter la classe ZCL_TEM_DATA_GEN (F9) pour insérer
   un jeu de données de démo (notes Casablanca / Rabat / Marrakech, en MAD)
4. Publier le Service Binding ZUI_TEM_REPORT_04, puis « Preview »
   pour ouvrir l'app Fiori Elements
```

## 📂 Structure du dépôt

L'arborescence reproduit l'organisation du **projet ADT** (catégories Eclipse) :

```
src/
├─ Business Services/
│  ├─ Service Bindings/      ZUI_TEM_REPORT_04.srvb.xml        (OData V4 · UI)
│  └─ Service Definitions/   ZUI_TEM_REPORT.srvd.srvdsrv
├─ Core Data Services/
│  ├─ Behavior Definitions/  ZI_TEMREPORT.bdef.asbdef          (managed + draft)
│  │                         ZC_TEMREPORT.bdef.asbdef          (projection)
│  └─ Data Definitions/      ZI_TEMREPORT / ZI_TEMITEM         (interface views)
│                            ZC_TEMREPORT / ZC_TEMITEM         (projection + @UI)
│                            ZTEM_REJECT_PARAM                 (paramètre de rejet)
├─ Dictionary/
│  └─ Database Tables/       ZTEM_RAPORT / ZTEM_RAPORT_D       (en-tête + draft)
│                            ZTEM_ITEM   / ZTEM_ITEM_D         (lignes + draft)
└─ Source Code Library/
   └─ Classes/               ZBP_I_TEMREPORT (+ .locals_imp)   (behavior pool)
                             ZCL_TEM_DATA_GEN                  (données de démo)
docs/                        Architecture & roadmap
.github/                     Templates issues / PR
```

## 🤝 Contribution

Voir [`CONTRIBUTING.md`](CONTRIBUTING.md) — conventions de commit (Conventional Commits), branches et PR.

## 📜 Licence

Distribué sous licence **MIT** — voir [`LICENSE`](LICENSE).

---

<p align="center">Construit par <a href="https://github.com/osama-jammi">@osama-jammi</a> · ENSIASD</p>
