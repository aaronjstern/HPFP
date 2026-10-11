# Haskell Programming from First Principles
## Layout and Formatting

_Last updated: 2026-10-08_

This file records how Haskell's layout (indentation) rule works, explained intuitively, and the approach chosen for typing out HPFP code by hand.

It complements `HPFP_environment_and_working_practices.md`, which covers the toolchain and editor settings.

The guiding principle is:

> Before typing a line, decide what it is: a new item, a continuation, or the end of the block. Then place it accordingly.

---

## 1. The one rule: blocks have a left edge

Some keywords open a **block** of lines:

```text
where   let   do   of
```

The **first word after the keyword** sets the block's **left edge**. Picture a vertical line dropped down from that word:

```haskell
    where secondGreeting =
          │
          │  ← the edge is wherever secondGreeting starts
          │
```

Every following line is judged by where it starts relative to that edge:

| Line starts… | Meaning |
|---|---|
| **on** the edge | a new item in the block |
| **right of** the edge | continuing the item above |
| **left of** the edge | the block is over |

That is the whole rule.

---

## 2. The rule applied to real errors

### `03/TopOrLocal.hs`: a new item was left of the edge

```haskell
    where woot :: Integer
          │
        woot = 10        ← left of edge → block ends → parse error
```

The second `woot` is a new item, so it must start **on** the edge:

```haskell
    where woot :: Integer
          woot = 10
```

### `03/print3.hs`: a continuation was left of the edge

```haskell
    where secondGreeting =
          │
        concat [...]     ← left of edge → block ends → parse error
```

`concat ...` continues the definition of `secondGreeting`, so it must start **right of** the edge:

```haskell
    where secondGreeting =
            concat [hello, " ", world]
```

Note that starting `concat` exactly **on** the edge would also fail: GHC would treat it as a new definition.

### Summary of the difference

- A **new definition** must line up **exactly on** the edge.
- A **continuation** must be **to the right of** the edge.

---

## 3. The top level is a block too

The whole file is a block whose edge is column 1. That is why:

- `main :: IO ()` and `main = do` start in column 1 (on the edge → new items).
- The `do` lines are indented (right of the edge → they belong to `main`).
- Accidentally indenting a new top-level definition makes GHC read it as a continuation of the previous one.

---

## 4. Nested blocks have nested edges

Each block has its own edge. A line is compared against the innermost edge first. If the line is left of it, that block closes and the line is checked against the next edge outward.

```haskell
main = do
    putStrLn greeting
    │
    where greeting =
          │   concat [hello, " ", world]
          │   ↑ right of the where-edge → continues greeting
```

Here `where` sits on the `do` block's edge. `where` cannot start a `do` statement, so GHC closes the `do` block and attaches the `where` to `main`. Lines inside the `where` then answer to the `where` block's own edge.

---

## 5. Approach for typing HPFP code

### Put the block keyword at the end of the line

Instead of the book's inline style:

```haskell
    where woot :: Integer
          woot = 10
```

write:

```haskell
    where
        woot :: Integer
        woot = 10
```

The two are equivalent to GHC.

#### Why

With the keyword ending its line, every edge falls on a multiple of 4. This fits the editor setting `"editor.autoIndent": "keep"`: press Enter, add one 4-space step, and you are on the edge.

With the book's inline style, the edge lands at awkward columns (11, 13, …) that depend on the length of the keyword, which 4-space steps cannot reach.

The same applies to `do` (already used this way), `let`, and `case … of`.

This is still consistent with "type it, don't paste it": every token is still typed by hand, and choosing where blocks begin is exactly the skill being practised. Later, transcribe a few examples in the book's exact layout so both styles become readable.

### Decide what each line is before typing it

New item → on the edge.
Continuation → right of the edge.
End of block → left of the edge.

### Make continuations clearly to the right

Use the edge plus 4 spaces, not plus 1. A continuation that is only one column in is easy to misjudge.

### Use GHC's error position

An error such as:

```text
print3.hs:17:9: error: parse error
```

means line 17, column 9. VS Code's status bar shows `Ln, Col` with the same 1-based numbering.

On a parse error, go to that position and ask:

1. Which edge is this line being compared against?
2. Which side of that edge is it on?
3. Which side should it be on?

### Make whitespace visible

These are set in the `[haskell]` VS Code settings (see section 5 of `HPFP_environment_and_working_practices.md`):

```json
"editor.renderWhitespace": "all",
"editor.guides.indentation": true
```

Spaces show as faint dots, and indent guides mark every 4 columns, which, in the recommended style, are the block edges.

---

## 6. Worked example

`03/print3.hs` in the recommended style:

```haskell
main :: IO ()
main = do
    putStrLn myGreeting
    putStrLn secondGreeting
    where
        secondGreeting =
            concat [hello, " ", world]
```

Every edge is on a multiple of 4, each line's role is unambiguous, and it can all be typed with Enter plus 4-space steps.

---

## 7. Quick reference

```text
Block keywords:  where  let  do  of
Edge:            column of the first word after the keyword

on the edge      → new item
right of edge    → continuation of the item above
left of edge     → block ends

Top level:       edge is column 1
Nested blocks:   innermost edge first, then outward
Style:           keyword at end of line, block on the next line, +4 spaces
```
