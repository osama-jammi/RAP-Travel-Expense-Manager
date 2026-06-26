# Roadmap

## Phase 1 — Modèle de données (CDS)
Branche : `feature/01-data-model-cds`
- [ ] Table `ZEXP_REPORT` (header)
- [ ] Table `ZEXP_ITEM` (items)
- [ ] Interface view `ZI_ExpenseReport` (root) avec composition
- [ ] Interface view `ZI_ExpenseItem` avec association to parent

## Phase 2 — Behavior
Branche : `feature/02-behavior-actions`
- [ ] Behavior Definition managed + draft
- [ ] CRUD (create / update / delete) + field control
- [ ] Action `Submit`
- [ ] Actions `Approve` / `Reject` (avec paramètre motif)
- [ ] Validations (montants, employé, statut)
- [ ] Détermination du montant total
- [ ] Behavior Implementation (classe ABAP)

## Phase 3 — Service & Fiori
Branche : `feature/03-service-fiori`
- [ ] Projection views `ZC_ExpenseReport` / `ZC_ExpenseItem`
- [ ] Service Definition `ZUI_ExpenseReport_O4`
- [ ] Service Binding OData V4 (UI)
- [ ] Metadata Extension (annotations `@UI`)
- [ ] Test / preview Fiori Elements

## Idées futures (backlog)
- [ ] Pièces jointes (justificatifs) via Stream / MediaResource
- [ ] Workflow d'approbation multi-niveaux
- [ ] Value help (devises, types de dépense)
- [ ] Tests unitaires ABAP Unit sur le behavior
