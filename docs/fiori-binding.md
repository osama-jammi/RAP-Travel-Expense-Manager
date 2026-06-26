# Service Binding & test Fiori Elements

## 1. Créer le Service Binding (dans ADT)
1. Clic droit sur la *Service Definition* `ZUI_ExpenseReport_O4` → **New Service Binding**.
2. Nom : `ZUI_EXPENSEREPORT_O4` · **Binding Type : OData V4 - UI**.
3. Activer le binding, puis cliquer **Activate** sur l'entité `ExpenseReport`.

## 2. Prévisualiser l'application
- Sélectionner l'entité `ExpenseReport` → bouton **Preview**.
- L'app **Fiori Elements (List Report + Object Page)** s'ouvre dans le navigateur.

## 3. Scénario de test
1. **Create** → saisir Titre + Employé + Devise (brouillon = draft).
2. Ajouter des **lignes de dépense** (type, montant, date).
3. **Save** → le `TotalAmount` se calcule (détermination).
4. **Submit** → statut passe à *Submitted* ; Approve/Reject deviennent actifs.
5. **Approve** ou **Reject** (avec motif).

## 4. Points de contrôle
- La validation bloque un montant ≤ 0 et un employé vide.
- Approve/Reject sont grisés tant que le statut n'est pas *Submitted* (feature control).
- Le draft permet de reprendre une saisie non terminée.
