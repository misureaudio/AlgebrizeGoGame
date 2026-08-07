# Question: How does @Topology_v5.lean relates to the original essay?

The Lean code is a **partial formalization** of the essay — it implements Sections 3–4 faithfully but omits Sections 2 and 5 entirely. Here's the detailed mapping:

---

### What's Implemented (Sections 3–4)

| Essay Concept | Lean Code | Notes |
|---|---|---|
| Board graph G = (V, E) | `boardGraph n : SimpleGraph (Fin n × Fin n)` with `adj` | ✓ Exact match |
| Chain groups C⁰, C¹ over ℤ₂ | `C0 n := (Fin n × Fin n) → ZMod 2`, `C1 n := edgeSet → ZMod 2` | ✓ Exact match |
| Coboundary δ₀ | `delta_0 f e = f u + f v` via `edgeSum` and `Sym2.lift` | ✓ Correctly handles undirected edges |
| Stone group indicator / capture condition (Prop 3.1) | `isCaptured s c` + `prop_3_1` | ✓ Same coboundary characterization; Lean version adds explicit occupancy hypothesis `hc` for technical clarity |
| Candidate eye definition | `isCandidateEye s c e := s e = 0 ∧ ∀ u, Adj e u → u ∈ c` (in §4) | ✓ Matches essay's "orthogonal neighbors all in c" |
| Enclosure (flood-fill condition) | `isEnclosed s R X := (∀ v ∈ R, s v = 0) ∧ (∀ boundary point → in X)` | ✓ Exactly the flood-fill / coboundary condition described |
| Benson's monotone operator f | `benson_f s X` with monotonicity lemma | ✓ Same definition: stones whose liberties lie in regions enclosed by X |
| Knaster–Tarski greatest fixed point = unconditionally alive | `unconditionally_alive s := OrderHom.gfp (benson_op s)` | ✓ Direct implementation of Theorem 4.1 |
| Two-eyes theorem (Lemma 4.2) | Full proof with case split on `h_libs` | ✓ Complete; Lean version makes explicit the hypothesis that e₁, e₂ are the *only* liberties |

---

### What's Omitted

| Essay Section | Content | Status in Lean |
|---|---|---|
| **Section 2** (State Space) | Legal positions Pₙ, move relation R, positional superko, game states (p, h), DAG/poset structure, Proposition 2.1 & Corollary 2.2 | ❌ Not present at all |
| **Section 5** (CGT / Endgames) | Direct-sum decomposition of endgames, surreal numbers, infinitesimals, independence hypothesis | ❌ Not present at all |
| Section 0 acknowledgment details, Remark 3.2 on false eyes, Remark 4.3 on converse failure, Open problems | Conceptual discussion | ❌ Not formalized (expected) |

---

### Key Differences / Refinements in the Lean Version

1. **More explicit hypotheses:** Lemma 4.2's `h_libs` condition ("all liberties of c are e₁ or e₂") is stated explicitly, whereas the essay phrases it more informally as "remain enclosed throughout the iteration." This strengthens rigor.

2. **Restricted to Black stones:** The Lean `benson_f` and `unconditionally_alive` only consider Black stones (`s x = 1`). The essay's lattice L is described as "Black stones on the board," so this matches, but the Lean code doesn't generalize to arbitrary color.

3. **Prop 3.1 structure:** The Lean version adds (hc : ∀ v ∈ c, s v ≠ 0) (the group must actually be occupied) and reformulates the capture condition in terms of `isCaptured` + a universal quantification over edges — functionally equivalent but technically more careful.

4. **Proof completeness:** Lemma 4.2 is fully proved in Lean (including the {e₁} / {e₂} enclosure constructions), whereas the essay's proof is sketched informally.

---

### Summary

The Lean code is a **faithful, rigorous implementation of the core algebraic-topological-heart** of the essay (Sections 3–4): coboundary-based liberties, Benson's operator, Knaster–Tarski life/death, and the two-eyes lemma. It deliberately leaves out:

- The game-theoretic superko/DAG framework (Section 2)
- The combinatorial game theory / surreal number endgame analysis (Section 5)

So: **the Lean code formalizes the "algebraic topology + lattice theory" pillar of the essay, but not its full scope.**
