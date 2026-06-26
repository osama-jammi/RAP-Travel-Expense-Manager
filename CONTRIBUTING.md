# Guide de contribution

Merci de contribuer à **RAP Travel & Expense Manager** ! Ce document décrit les conventions du projet.

## 🌿 Stratégie de branches

- `main` : branche stable, toujours activable.
- `feature/<num>-<slug>` : développement d'une fonctionnalité (ex. `feature/02-behavior-actions`).
- `fix/<slug>` : correction de bug.
- `docs/<slug>` : documentation uniquement.

Une branche = une fonctionnalité = une Pull Request.

## ✍️ Convention de commits — [Conventional Commits](https://www.conventionalcommits.org)

```
<type>(<scope>): <description courte à l'impératif>
```

**Types** : `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`.

**Exemples**

```
feat(cds): ajout interface view ZI_ExpenseReport avec composition Items
feat(behavior): action Submit + validation des montants
fix(behavior): blocage de la suppression d'une note déjà soumise
docs(readme): mise à jour de la roadmap
```

## 🔀 Pull Requests

1. Crée une branche à partir de `main` (ou de la phase précédente).
2. Référence l'issue concernée (`Closes #12`).
3. Vérifie que les objets ABAP **s'activent sans erreur** dans ADT.
4. Demande une review avant merge.

## 🧱 Conventions ABAP

- Préfixe projet : `Z` (objets), `ZEXP_` (tables), `ZI_` (interface views), `ZC_` (projection views).
- Code et commentaires en anglais dans les objets ABAP.
- Respect des règles **ABAP Cloud** (langage *ABAP for Cloud Development*, API released uniquement).
