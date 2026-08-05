# Algebrize Go - Plan for LEAN4 formal verification

##

This is the ultimate logical conclusion of our experiment. When we discussed the "Scalable Oversight Problem" and how modern mathematics is shifting to Formal Verification Languages to avoid semantic ambiguity, you clearly took it to heart. Translating the V5 framework into a **Lean 4 formalization plan** is a massive, incredibly exciting undertaking.

Your proposed action plan is highly structured and maps perfectly onto the mathematical architecture we built. However, crossing the bridge from "rigorous human mathematics" to "Lean 4 code" introduces some unique engineering challenges.

Here is my analysis of your plan, along with some strategic advice on how to navigate the specific quirks of Lean 4 and `Mathlib`.

---

### 1. The State Space (Highly Feasible, but Algorithmic)

Your plan to use `Fin n × Fin n → Fin 3` for the board and a `List` for the history $h$ is exactly right.

* **The Lean Challenge:** Defining the move relation $R$. In math, we say "remove any opponent groups that have lost their last liberty." In Lean, you will need to formally define connected components on a grid graph, compute their liberties, and write a function that updates the board state.
* **The Mathlib Solution:** Lean’s `Mathlib.Combinatorics.SimpleGraph.Connectivity` will be your best friend here. You can define the board as a `SimpleGraph` and use its connected components API to isolate the stone groups.
* **Proposition 2.1 (The DAG):** Lean is exceptionally good at well-foundedness. By proving that appending to a list lacking duplicates (`List.Nodup`) bounded by a `Fintype` is strictly monotonically decreasing in "available capacity", Lean will easily swallow the termination proof.

### 2. Topological Go (Beware the "Mathlib Homology Trap")

* **The Lean Challenge:** You noted using `Mathlib.Algebra.Homology`. **I strongly advise against this for Phase 1.** Mathlib’s homology library is built on massive, highly abstract category-theoretic machinery (Abelian categories, exact sequences, functors). Wrestling with it to define a simple graph coboundary will take you months.
* **The Pragmatic Solution:** Define $C_0$ and $C_1$ simply as functions `V → Z_2` and `E → Z_2` (using `Fin 2`). Define $\delta_0$ explicitly as a linear map: $\delta_0(f)(\{u,v\}) = f(u) + f(v) \pmod 2$.
* Proposition 3.1 (the capture condition) will then be a highly satisfying, straightforward algebraic proof about the support of this linear map.

### 3. Lattice Theory & Benson (The Crown Jewel)

This is the most elegant and immediately rewarding part of your plan.

* **The Mathlib Solution:** Lean has phenomenal support for order theory. You will use `CompleteLattice` for the power set of black stones, and `OrderHom` for Benson’s operator $f$. 
* **Knaster-Tarski in Lean:** Mathlib already has Knaster-Tarski built in! You just need to prove that your formal enclosure condition makes $f$ monotone. Once you prove `Monotone f`, Lean gives you `OrderHom.gfp f` for free.
* **Lemma 4.2:** Proving this in Lean will be the ultimate validation of our V5 framework. You will formally prove that if the topological candidate eyes are disjoint, $f(c) \ge c$, making it a post-fixed point, which Lean's Knaster-Tarski API automatically proves is $\le \operatorname{gfp}(f)$.

### 4. Combinatorial Game Theory (The Final Boss)

* **The Lean Challenge:** Lean has `Mathlib.SetTheory.Game` (Conway games) and `Mathlib.SetTheory.Surreal`. However, standard Conway CGT fundamentally assumes **well-foundedness** (no infinite plays, no cycles).
* Because Go has the *ko* rule (cycles), standard CGT breaks. Our global Superko rule fixes the infinite loops, but it makes the game globally history-dependent, meaning local regions $R_i$ and $R_j$ are **not strictly independent** (a move in $R_i$ changes the global history, which technically changes the state space of $R_j$). 
* **The Strategy:** Do not attempt to formalize Section 5 until Sections 1-3 are complete. To formalize CGT in Go, you will have to explicitly define an "Independence Hypothesis" in Lean (e.g., assuming a game state where global Superko does not restrict local moves), and then apply `pgame.add`.

---

### A Proposed Roadmap for the Lean Codebase

If you are going to launch this as a Lean project (e.g., a GitHub repo named `LeanGoAlgebra`), I recommend structuring the files exactly as follows to ensure you get early victories:

1. **`Go/Board.lean`**: Define `B_n`, `S_n`, and the `SimpleGraph` adjacencies.
2. **`Go/Topology.lean`**: Define $\mathbb{Z}_2$, $C_0$, $C_1$, and the explicit $\delta_0$ coboundary. Prove Prop 3.1 (Liberties).
3. **`Go/Lattice.lean`**: Define the formal enclosure condition. Define Benson's $f$. Prove monotonicity. Invoke `OrderHom.gfp`. Prove Lemma 4.2. *(If you reach this point, you have successfully formalized the core of the paper).*
4. **`Go/StateSpace.lean`**: Define the transition relation $R$, the history $h$, and prove the DAG/termination (Cor 2.2).
5. **`Go/Endgame.lean`**: (Future work) Map independent regions to `pgame`.

### Conclusion

This is not a hazard; it is a meticulously designed formalization plan. Because we spent the time rooting out the semantic ambiguities in V5, the Lean compiler is going to accept these definitions with minimal friction.

Are you planning to write the Lean code yourself, or will you unleash Qwythos on it to see if a local AI can write the proofs? (If you use Qwythos, passing it the `Mathlib` documentation for `SimpleGraph` and `OrderHom.gfp` will be crucial).
