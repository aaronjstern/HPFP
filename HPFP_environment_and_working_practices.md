# Haskell Programming from First Principles
## Environment and Working Practices

_Last updated: 2026-10-08 (moved from `~/HPFP` to `~/dev/HPFP`)_

This file records the Haskell environment being used for **Haskell Programming from First Principles (HPFP)**, the editor settings chosen for it, and the reasons for those choices.

The guiding principle is:

> Keep the environment faithful to the book while keeping the editor mechanically predictable. Type and format the Haskell manually; let GHC and GHCi provide feedback.

---

## 1. HPFP toolchain

The book specifies:

- Stack snapshot: `lts-13.24`
- GHC: `8.6.5`

The HPFP directory is therefore configured as its own Stack environment.

### `~/dev/HPFP/stack.yaml`

```yaml
snapshot: lts-13.24
packages: []
```

### Why

`lts-13.24` is the Stack snapshot specified by the book and selects GHC 8.6.5.

`packages: []` is deliberate. The chapter directories currently contain small standalone `.hs` files rather than a Cabal/Stack package. Stack is being used here primarily to reproduce the book's compiler environment.

This configuration lives at `~/dev/HPFP`, so chapter directories such as `~/dev/HPFP/03` inherit it automatically.

### Verification

From anywhere below `~/dev/HPFP`:

```bash
stack path --project-root
stack ghc -- --version
```

Expected results include:

```text
/Users/aaron/dev/HPFP
The Glorious Glasgow Haskell Compilation System, version 8.6.5
```

---

## 2. Important distinction: global GHC vs. HPFP GHC

The machine has multiple GHC versions available, but two compiler contexts matter for this work: the globally selected GHC 9.6.7 and the HPFP-specific GHC 8.6.5 selected by Stack.

Plain shell commands currently resolve independently of the HPFP Stack project:

```bash
ghc --version
ghci --version
```

These resolve to GHC 9.6.7.

Inside HPFP, Stack deliberately selects GHC 8.6.5:

```bash
stack ghc -- --version
```

Therefore, while working through HPFP, prefer Stack-controlled commands rather than plain `ghci` or `ghc`.

This keeps the book environment local to the book rather than making an old compiler the machine-wide default.

---

## 3. Installed Haskell tools

Observed environment:

- GHCup: `0.2.6.2`
- Cabal: `3.14.2.0`
- Stack: `3.7.1`
- Global GHC/GHCi on PATH: `9.6.7`
- HPFP Stack GHC: `8.6.5`
- Haskell Language Server: not part of the current HPFP environment

Other GHC versions are also installed through GHCup, but they are not the compiler chosen for HPFP.

### Why keep this separation

GHCup manages installed Haskell tools.

Stack determines which compiler/snapshot HPFP should use.

The HPFP project should not depend on whichever compiler happens to be globally selected.

---

## 4. VS Code

Observed VS Code version:

```text
1.136.1
```

### Haskell extension

The only Haskell-related extension intentionally installed is:

```text
haskell.language-haskell@3.8.0
```

This extension provides Haskell syntax highlighting and language grammar support.

The following extensions were previously installed but were removed during the environment audit:

```text
haskell.haskell
justusadam.language-haskell
```

`justusadam.language-haskell` was the older predecessor of the current `haskell.language-haskell` extension and was redundant.

`haskell.haskell` provides the fuller Haskell Language Server (HLS) integration. It was removed because HLS is not part of the current HPFP learning workflow. The present goal is to use VS Code primarily as a predictable text editor with syntax highlighting, while using GHC and GHCi directly for compiler feedback, types, errors, and evaluation.

Because the HLS extension was removed, the following obsolete setting was also removed from the global VS Code settings:

```json
"haskell.manageHLS": "GHCup"
```

The intended division of responsibilities is therefore:

```text
VS Code
    → editing
    → syntax highlighting
    → manual layout

GHC / GHCi
    → compilation
    → type feedback
    → errors
    → evaluation
```

HLS can be reconsidered later if a concrete need for IDE features arises.

---

## 5. Haskell-specific VS Code settings

Use this Haskell language override:

```json
"[haskell]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 4,
    "editor.detectIndentation": false,
    "editor.autoIndent": "keep",
    "editor.formatOnType": false,
    "editor.formatOnPaste": false,
    "editor.formatOnSave": false
}
```

A global setting may still have:

```json
"editor.formatOnSave": true
```

The Haskell-specific setting overrides it for Haskell files.

### Reasons

#### Four spaces

```json
"editor.insertSpaces": true,
"editor.tabSize": 4
```

Indentation is made with spaces, with four spaces treated as one intentional indentation step.

#### Do not infer indentation from existing files

```json
"editor.detectIndentation": false
```

VS Code should not silently replace the chosen indentation behavior because it inspected a file and inferred something else.

#### Enter preserves the current indentation level

```json
"editor.autoIndent": "keep"
```

This is the central choice.

If the cursor is here:

```haskell
main = do
    putStrLn "hello"
```

pressing Enter after the `putStrLn` line preserves its indentation.

If the cursor is here:

```haskell
main :: IO ()
```

pressing Enter begins the next line at the same indentation level as `main`.

Likewise, pressing Enter after:

```haskell
main = do
```

starts the next line at the same indentation as `main`; the four-space indentation required for the `do` block is added manually.

The editor therefore does not decide Haskell layout. The programmer does.

#### No automatic formatting

```json
"editor.formatOnType": false,
"editor.formatOnPaste": false,
"editor.formatOnSave": false
```

While learning from HPFP, formatting should remain visible work rather than an automatic transformation performed by the editor.

This makes Haskell's layout rules something to learn directly.

---

## 6. Normal HPFP workflow

### Start in the chapter directory

For example:

```bash
cd ~/dev/HPFP/03
```

Open the directory in VS Code as usual.

### Start the book's GHCi

Use:

```bash
stack exec ghci
```

This gives GHCi inside the HPFP Stack environment rather than whichever GHCi is globally selected.

### Load a file

Inside GHCi:

```text
:load print2.hs
```

or:

```text
:l print2.hs
```

### Edit and reload

1. Edit the file in VS Code.
2. Save it.
3. Return to GHCi.
4. Run:

```text
:reload
```

or:

```text
:r
```

This should be the default edit–save–reload loop.

### Start GHCi with a file already loaded

As a convenience:

```bash
stack exec ghci -- print2.hs
```

### Useful GHCi commands

```text
:load FILE
:reload
:type EXPRESSION
:info NAME
:quit
```

Short forms commonly used:

```text
:l FILE
:r
:t EXPRESSION
:i NAME
:q
```

Note: GHCi 8.6.5 does **not** accept `:show version`; that command is not part of this version's `:show` syntax.

---

## 7. Running a standalone file

To interpret and run a file without first entering GHCi:

```bash
stack exec runghc -- print2.hs
```

For the early chapters, however, prefer the GHCi edit–reload loop when the point is to experiment with expressions and definitions.

---

## 8. Working habits

### Type examples manually

Do not copy and paste book examples merely to make them run.

Typing them makes syntax, spacing, parentheses, names, and structure part of the learning process.

### Control indentation manually

Enter preserves the previous line's indentation.

Add or remove indentation yourself.

Treat four spaces as the normal deliberate indentation step, while remembering that Haskell's layout rule is semantic rather than a rule that every nested construct must literally use four spaces.

### Do not let the editor repair the program

For now:

- no format-on-save
- no format-on-type
- no automatic Haskell indentation
- no need to add a formatter
- no need to add HLS merely because it exists

The compiler and GHCi should provide the important feedback.

### Read compiler errors

When code fails, read the GHC message before changing the program.

The goal is not only to reach compiling code but to learn how GHC describes syntax, types, and scope.

### Keep chapter files lightweight

Continue using small standalone files such as:

```text
~/dev/HPFP/03/print1.hs
~/dev/HPFP/03/print2.hs
~/dev/HPFP/03/print3.hs
```

Do not turn each chapter into a package unless the book or a concrete need requires it.

### Avoid unnecessary environment changes

Do not upgrade the HPFP compiler merely because a newer GHC exists.

Do not globally switch the machine to GHC 8.6.5 merely because HPFP uses it.

The book directory already carries its own historical environment through Stack.

---

## 9. Current project structure

The working arrangement is conceptually:

```text
~/dev/HPFP/
├── stack.yaml          # lts-13.24 / GHC 8.6.5
├── HPFP_environment_and_working_practices.md
├── Haskell Programming from First Principles.pdf
├── 02/
│   └── ...
├── 03/
│   ├── print1.hs
│   ├── print2.hs
│   └── print3.hs
└── ...
```

The Stack configuration belongs at the HPFP root so every chapter inherits the same book environment.

---

## 10. When to reconsider this setup

Add tooling only when a concrete need appears.

Possible future reasons include:

- the book begins using Cabal/Stack packages directly
- package dependencies become necessary
- HLS would materially help with navigation, type information, refactoring, or other IDE features after the current manual workflow has become familiar
- a formatter becomes useful after manual layout has become familiar
- overlapping VS Code Haskell extensions cause an actual problem
- compatibility with the book requires an additional old package or tool

Until then, keep the setup simple and stable.
