<h1 align="center">✈️ RAP Travel &amp; Expense Manager</h1>

<p align="center">
  <i>Gestion des notes de frais de bout en bout, construite avec le ABAP RESTful Application Programming Model (RAP).</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ABAP-0A6ED1?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/RAP-1B6EC2?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/CDS_Views-0FAAFF?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/OData_v4-008FD3?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/SAP_Fiori-0FAAFF?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/ABAP_Cloud-0A6ED1?style=for-the-badge&logo=sap&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

---

## 🎯 Problème résolu

Beaucoup d'entreprises gèrent encore les **notes de frais** manuellement (Excel, mails) ou avec des outils déconnectés de SAP. Ce projet propose une application **RAP managed** native S/4HANA / BTP qui couvre tout le cycle :

> **Saisie → Soumission → Validation (Approve / Reject) → Suivi du statut**

avec une UI **Fiori Elements** générée automatiquement et une API **OData V4**.

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     SAP Fiori Elements (UI)                    │
│              List Report  +  Object Page (auto)                │
└───────────────────────────────┬──────────────────────────────┘
                                 │ OData V4
┌───────────────────────────────┴──────────────────────────────┐
│  Service Binding (UI_V4)  ◄──  Service Definition             │
├──────────────────────────────────────────────────────────────┤
│  Projection Views  ZC_ExpenseReport / ZC_ExpenseItem          │
│  + Metadata Extension (annotations UI)                         │
├──────────────────────────────────────────────────────────────┤
│  Behavior Definition (managed, draft)                         │
│  Actions: Submit · Approve · Reject   |  Validations          │
│  Behavior Implementation (classe ABAP)                        │
├──────────────────────────────────────────────────────────────┤
│  Interface Views  ZI_ExpenseReport ──(composition)── ZI_ExpenseItem │
├──────────────────────────────────────────────────────────────┤
│  Tables DDIC   ZEXP_REPORT (header)  /  ZEXP_ITEM (items)      │
└──────────────────────────────────────────────────────────────┘
```

Voir [`docs/architecture.md`](docs/architecture.md) pour le détail.

## 🧩 Modèle métier

| Objet | Description |
|-------|-------------|
| **ZI_ExpenseReport** (root) | En-tête de la note de frais : titre, employé, statut, montant total, devise |
| **ZI_ExpenseItem** (child) | Lignes de dépense : type, description, montant, date — en *composition* du header |

**Actions personnalisées** : `Submit`, `Approve`, `Reject` (avec motif) · **Draft enabling** activé (sauvegarde intermédiaire).

## ⚒️ Stack technique

- **CDS Views** : interface views + projection views + associations / composition
- **Behavior Definition & Implementation** : RAP *managed* avec *draft*
- **OData V4** exposé via *Service Definition* + *Service Binding*
- **SAP Fiori Elements** (List Report Object Page)
- **ABAP Cloud** / **BTP ABAP Environment** (ABAP for Cloud Development)

## 🗺️ Roadmap

| Phase | Contenu | Branche |
|-------|---------|---------|
| **1** | Modèle de données : tables, interface views, associations | `feature/01-data-model-cds` |
| **2** | Behavior : CRUD managed, actions, validations, déterminations | `feature/02-behavior-actions` |
| **3** | Service binding + test Fiori + metadata extension | `feature/03-service-fiori` |

Détail des tâches dans les [**Issues**](../../issues) et la [**Roadmap**](docs/roadmap.md).

## 🚀 Démarrage

> Prérequis : un système **SAP BTP ABAP Environment** (ou S/4HANA 2022+) + **ABAP Development Tools (ADT)** dans Eclipse, et **abapGit**.

```text
1. Cloner ce repo dans un package ABAP via abapGit
2. Activer les objets dans l'ordre : tables → CDS → behavior → classe → service
3. Créer/activer le Service Binding (UI_V4)
4. « Preview » sur le binding pour ouvrir l'app Fiori Elements
```

## 📂 Structure du dépôt

```
src/                 Objets ABAP (conventions abapGit)
  *.tabl / tables/   Tables DDIC (documentées)
  *.ddls.asddls      CDS Views (interface & projection)
  *.bdef.asbdef      Behavior Definitions
  *.clas.abap        Behavior Implementation
  *.srvd.srvdll      Service Definition
  *.ddlx.asddlxs     Metadata Extension (UI)
docs/                Architecture & roadmap
.github/             Templates issues / PR
```

## 🤝 Contribution

Voir [`CONTRIBUTING.md`](CONTRIBUTING.md) — conventions de commit (Conventional Commits), branches et PR.

## 📜 Licence

Distribué sous licence **MIT** — voir [`LICENSE`](LICENSE).

---

<p align="center">Construit par <a href="https://github.com/osama-jammi">@osama-jammi</a> · ENSIASD</p>
