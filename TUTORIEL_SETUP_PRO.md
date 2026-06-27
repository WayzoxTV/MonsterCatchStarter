# Setup pro pour MonsterCatchStarter (Rojo + VSCode)

Objectif : coder dans VSCode comme un vrai projet logiciel (Git, lint, format,
type-checking), avec un sync live vers Roblox Studio. C'est le combo que la
doc officielle de Rojo recommande, et c'est ce qu'utilisent la plupart des
studios sérieux sur Roblox.

Tout se fait en ligne de commande (PowerShell sur Windows). Tu n'as besoin de
rien d'autre que VSCode pour la suite.

---

## 0. Vue d'ensemble de la stack

| Outil | Rôle |
|---|---|
| **Rokit** | Gestionnaire de versions d'outils (équivalent d'un `nvm`/`sdkman` mais pour l'écosystème Roblox) |
| **Rojo** | Sync ton dossier `src/` ↔ Roblox Studio en temps réel |
| **luau-lsp** | Autocomplete + vérification de types dans VSCode |
| **Selene** | Linter (détecte les bugs avant même de tester) |
| **StyLua** | Formatte le code automatiquement à la sauvegarde |
| **Git** | Historique, branches, retour en arrière |

Rokit remplace les anciens Aftman/Foreman — c'est l'outil officiel recommandé
par l'équipe Rojo aujourd'hui.

---

## 1. Installer Rokit

Dans PowerShell (pas besoin des droits admin) :

```powershell
Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression
```

Ferme et rouvre ton terminal, puis vérifie :

```powershell
rokit --version
```

---

## 2. Installer Rojo, Selene et StyLua via Rokit

Place-toi dans le dossier du projet (celui que tu as dézippé) :

```powershell
cd D:\Bureau\MonsterCatchStarter
rokit init
rokit add rojo-rbx/rojo
rokit add Kampfkarren/selene
rokit add JohnnyMorganz/stylua
rokit install
```

- `rokit init` crée un fichier `rokit.toml` (le manifeste du projet)
- `rokit add` ajoute l'outil au manifeste **et** récupère la dernière version stable
- `rokit install` télécharge tout ce qui est listé dans `rokit.toml`

Ce fichier `rokit.toml` part dans Git : comme ça, n'importe qui qui clone le
projet (toi sur un autre PC, un futur dev) tape juste `rokit install` et a
exactement les mêmes versions d'outils que toi. Plus de "ça marche chez moi
mais pas chez toi".

---

## 3. Installer le plugin Rojo dans Roblox Studio

Une fois Rojo installé via Rokit, une seule commande :

```powershell
rojo plugin install
```

Ça installe le plugin Rojo directement dans Roblox Studio. Tu n'as rien à
télécharger à la main.

---

## 4. VSCode : les 4 extensions essentielles

Ouvre VSCode dans le dossier du projet, va dans l'onglet Extensions
(`Ctrl+Shift+X`) et installe :

| Extension | ID exact |
|---|---|
| **Rojo - Roblox Studio Sync** | `evaera.vscode-rojo` |
| **Luau Language Server** | `JohnnyMorganz.luau-lsp` |
| **Selene** | `Kampfkarren.selene-vscode` |
| **StyLua** | `JohnnyMorganz.stylua` |

Le fichier `.vscode/extensions.json` (déjà dans ton projet) te proposera ces 4
extensions automatiquement dans une popup quand tu ouvres le dossier — tu
peux juste cliquer "Installer tout".

---

## 5. Lancer le live-sync

Deux façons de faire, choisis celle que tu préfères :

**Depuis le terminal :**
```powershell
rojo serve
```

**Depuis VSCode (plus pratique au quotidien) :**
Une fois l'extension Rojo installée, une barre de statut en bas de VSCode te
permet de cliquer sur "Start" — ça lance `rojo serve` pour toi.

Ensuite, dans Roblox Studio : ouvre le panneau **Plugins → Rojo → Connect**.
Tant que c'est connecté, tout ce que tu modifies dans VSCode apparaît
instantanément dans Studio (et inversement pour les changements faits dans
l'arbre d'instances de Studio, comme les Parts).

---

## 6. Le sourcemap (pour l'autocomplete Roblox dans VSCode)

`luau-lsp` a besoin de savoir comment ton arbre de fichiers correspond à
l'arbre d'instances Roblox (`game.ReplicatedStorage.Shared...`). Le fichier
`.vscode/settings.json` déjà présent active la régénération automatique :

```json
"luau-lsp.sourcemap.enabled": true,
"luau-lsp.sourcemap.autogenerate": true
```

Tu n'as rien à faire de plus — à chaque sauvegarde, le sourcemap se met à
jour tout seul et l'autocomplete (`game:GetService("Players")`, etc.)
fonctionne directement dans VSCode comme dans Studio.

---

## 7. Linter (Selene) et formatter (StyLua)

Les configs sont déjà dans le projet (`selene.toml`, `stylua.toml`) — rien à
configurer. Pour les utiliser en ligne de commande :

```powershell
selene src      # liste les erreurs/avertissements
stylua src      # reformatte tous les fichiers
```

Avec `.vscode/settings.json`, StyLua tourne **automatiquement à chaque
sauvegarde** (`editor.formatOnSave`). Selene, lui, souligne les problèmes en
direct dans l'éditeur dès que l'extension est installée — pas besoin de lancer
la commande à la main pour ça.

---

## 8. Git

Initialise le repo (si ce n'est pas déjà fait) :

```powershell
git init
git add -A
git commit -m "Setup initial : archi data des créatures + tooling pro"
```

Le `.gitignore` déjà présent exclut les fichiers générés (`sourcemap.json`,
les `.rbxl`) et les binaires d'outils — seul `rokit.toml` (les *versions*)
est versionné, pas les exécutables eux-mêmes.

Crée ensuite un repo sur GitHub et lie-le :

```powershell
git remote add origin https://github.com/TON-PSEUDO/MonsterCatchStarter.git
git branch -M main
git push -u origin main
```

---

## 9. Le geste quotidien, une fois tout en place

1. `rojo serve` (ou clique "Start" dans VSCode) — une fois par session de travail
2. Ouvre Studio → Plugins → Rojo → Connect
3. Code dans VSCode, sauvegarde → ça sync en live dans Studio, formaté
   automatiquement
4. Teste en appuyant sur Play dans Studio
5. `git add -A && git commit -m "..."` — par petits commits, un par feature/fix
6. `git push`

---

## 10. Pour plus tard (pas urgent maintenant)

- **Wally** (`UpliftGames/wally`) : gestionnaire de packages Luau, utile si tu
  veux importer des libs externes (par ex. une lib de state-machine pour le
  combat) au lieu de tout réécrire toi-même.
- **GitHub Actions** : une fois le repo en ligne, on peut automatiser le lint
  (`selene`) et le format-check (`stylua --check`) à chaque push, pour
  bloquer un commit mal formaté avant qu'il arrive sur `main`.

On verra ça quand l'archi du jeu sera plus avancée — pour l'instant, le setup
ci-dessus suffit largement pour avancer "comme un pro" sur le projet actuel.
