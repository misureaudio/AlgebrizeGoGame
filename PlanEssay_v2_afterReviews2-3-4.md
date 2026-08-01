# Plan: Go Essay Version 2

**Guiding principle (from Gem's synthesis of Cla's reviews):** every algebraic structure introduced must *do work* — i.e., derive a real Go fact that is nontrivial to prove. Anything that is merely a metaphor, a relabeling, or a formalism that does not yield theorems gets cut or replaced.

## Section-by-Section Changes

1. **Introduction** — Retain the scope and audience, but revise the roadmap to match the new structure. Add a brief sentence acknowledging the evolution of the framework through reviewer feedback (as Gem suggested), framing the essay as a move from "notation cosplay" to machinery that proves things.

2. **The State Space (replaces the old §§2–3)** — *Remove* the $\mathbb{F}_3$ vector-space model entirely (Cla review 2: cosmetic; no addition of positions is meaningful). *Replace* with a directed-graph model of legal positions and moves, and invoke the **Positional Superko rule** to prove the graph is a finite DAG, hence the reachability relation is a **poset**. This is the "load-bearing" finiteness/termination fact Cla review 4 endorsed. No category/groupoid language (the groupoid was trivial per Cla review 2).

3. **Topological Go (replaces old §4)** — *Fix* the type error (Cla review 2) by using the **coboundary operator** $\delta_0: C^0(G;\mathbb{Z}_2) \to C^1(G;\mathbb{Z}_2)$ on the indicator function of a stone group; $\delta_0(\mathbf{1}_c)$ is the edge-cut, and restricting to edges landing on empty vertices gives a rigorous definition of liberties (Cla review 4: genuinely fixed). *Keep* the $H_1$-based definition of true eyes as cycles of a stone group's induced subgraph. *Downgrade/qualify* the false-eye discussion per Cla review 4: state explicitly that orthogonal enclosure (detectable homologically) is a necessary but not sufficient condition for a true eye, and that the diagonal/ko-dependent part lies outside pure topology — no CW-complex promissory note unless a worked example is supplied later.

4. **Lattice Theory: Life and Death (centerpiece, expands old §5)** — This is the strongest original material (Cla review 2), so it becomes the longest section. Define the Boolean lattice $L$ of black-stone subsets, the monotone operator $f: L \to L$ (Benson's "vital region" function), and invoke the **Knaster–Tarski theorem** to prove existence of the greatest fixed point as the unconditionally alive set. *Add* the bridge Cla review 4 requested: a lemma linking topological eyes (Section 3) to Benson's vital regions — e.g., "a region containing two disjoint $H_1$-eyes is $f$-invariant" — so Sections 3 and 4 actually feed each other rather than sitting side by side.

5. **Combinatorial Game Theory: Endgames (keeps old §6)** — Unchanged; Cla review 2 already validated it as legitimate (Berlekamp–Conway–Wolfe). Keep the direct-sum decomposition $G = g_1 \oplus \cdots \oplus g_k$ and the surreal-number valuation.

6. **Remove entirely** — Old §7 (operator algebras/quantum analogy). Cla review 2 called it the weakest section; Gem's mea culpa agreed; no reviewer defended it. Cutting it is the single most important purge.

## Order of Implementation

- **Step 1:** Excise old §§2, 3, 7 in one pass (they are not reused).
- **Step 2:** Draft the new State Space section (DAG + Superko + poset).
- **Step 3:** Rewrite the Topological section with $\delta_0$, liberties, and the qualified eyes claim.
- **Step 4:** Expand the Lattice section and write the bridge lemma tying it to Section 3.
- **Step 5:** Update the Introduction and Conclusion to reflect the new structure; leave the CGT section as-is.
- **Step 6:** Consistency pass: check that every defined structure is actually used to prove something (the Cla review 2 criterion), and that no undefined notation remains.

This plan incorporates every concrete suggestion from Cla reviews 2 and 4 and Gem's synthesis in review 3, in chronological order, and prioritizes the proven-strong material (lattice, CGT, fixed coboundary) while discarding or qualifying the weak material (vector space, groupoid, operator algebra, CW-complex overclaim).
