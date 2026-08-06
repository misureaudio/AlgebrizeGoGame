# Question: Topology_v6.lean fidelity to essay

This is a substantial improvement over the previous version. In fact, **Topology_v6 now reaches the point where it formalizes nearly all of the genuinely verifiable mathematics in Sections 3 and 4 of v5**, including a formal version of Lemma 4.2.

My assessment would be:

| Essay section        | Formalized? | Quality            |
| -------------------- | ----------- | ------------------ |
| Board graph          | Yes         | Strong             |
| Coboundary/liberties | Yes         | Strong             |
| Proposition 3.1      | Yes         | Good               |
| Candidate eyes       | Yes         | Good               |
| Enclosure            | Yes         | Very good          |
| Benson operator      | Yes         | Very good          |
| Monotonicity         | Yes         | Excellent          |
| Knaster–Tarski gfp   | Yes         | Excellent          |
| Lemma 4.2            | Yes         | Surprisingly close |
| Superko DAG          | No          | Missing            |
| Homology discussion  | No          | Missing            |
| CGT section          | No          | Missing            |

---

## The strongest improvement

The key advance is that you no longer try to formalize the homological language.

The essay itself now says:

> candidate eyes

rather than

> eyes are nontrivial classes in (H_1).

Your Lean definition

```lean
def isCandidateEye ...
```

matches the revised essay far better than any attempt to formalize relative homology would.

Mathematically, this is exactly the right move.

---

## One subtle mismatch remains

The essay says:

> two disjoint candidate eyes that remain enclosed throughout Benson iteration

The Lean theorem assumes

```lean
h_libs :
  ∀ x ∈ c, ∀ l,
  isLibertyOf s l x →
  l = e1 ∨ l = e2
```

This is actually **stronger**.

The theorem you're proving is:

> every liberty of every stone in the group is one of the two eyes.

That immediately implies the Benson condition.

So the Lean theorem is not exactly Lemma 4.2.

It is a formally convenient strengthening of Lemma 4.2.

I would explicitly document this in comments.

---

## The largest remaining gap

The essay's most mathematically interesting innovation is now Section 2:

* game histories
* superko
* transition relation
* DAG
* reachability order
* termination bound

None of that exists in Lean.

If your goal is eventually

> "formalize all theorem-like content"

then Section 2 is the next target.

---

## What I would add next

## Step 1 — histories

Introduce

```lean
structure GameState (n : ℕ) where
  pos : BoardState n
  history : List (BoardState n)
```

or a finite sequence.

---

## Step 2 — superko transition

```lean
def LegalTransition :
  GameState n → GameState n → Prop
```

encoding

```text
q ∉ history
```

---

## Step 3 — acyclicity theorem

Formalize the measure

```lean
history.length
```

and prove

```lean
history.length strictly increases
```

which yields

```lean
NoCycle
```

almost automatically.

That would be a very nice Lean theorem corresponding exactly to Proposition 2.1.

---

## Another worthwhile addition

You currently have

```lean
delta_0
```

but not the explicit liberty set.

I would define

```lean
def libertySet
```

and then prove

```lean
isCaptured ↔ libertySet = ∅
```

This would correspond even more directly to Proposition 3.1.

---

## What I would *not* do

I would not attempt to formalize

```text
H₁(G_c,c;ℤ₂)
```

yet.

The essay wisely downgraded that discussion to an interpretation rather than a theorem.

A Lean development of relative homology on finite graphs would be a project larger than the rest of the paper combined and would contribute very little to the actual Go theory.

---

## One possible strengthening of Lemma 4.2

Right now you prove

```lean
c ⊆ unconditionally_alive s
```

under the strong liberty hypothesis.

A more Benson-like theorem would introduce:

```lean
def EnclosedEye
```

and prove

```lean
two_disjoint_enclosed_eyes
  → c ⊆ gfp
```

without enumerating every liberty.

That would move the Lean theorem closer to the prose statement.

---

## Overall verdict

For the **mathematically verifiable content of Sections 3–4**, I would now rate Topology_v6 at roughly **90–95% correspondence** with the essay.

The remaining work is not really topology anymore. The next major milestone is to formalize **Section 2 (superko as a history-based DAG)**. That section is compact, clean, and exceptionally well suited to Lean. If I were extending the development, that is where I would spend effort next.
