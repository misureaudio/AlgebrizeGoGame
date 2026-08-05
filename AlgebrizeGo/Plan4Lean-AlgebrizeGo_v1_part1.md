# **Plan for Formalizing the Algebraic Framework of Go in Lean 4**

This revised framework for Go incorporates **algebraic topology, lattice theory, and combinatorial game theory**. To certify parts of this theory using **Lean 4**, we can break it down into modular components that align with existing mathematical libraries (e.g., `Mathlib`, `Topology`, `Order Theory`, `Game Theory`). Below is a structured plan for formalization:

---

## **1. Modeling the State Space of Go**

### **Key Components:**

- **Board positions (`P_n`)** as functions `s : B_n → {0,1,2}`.
- **Legal moves (`R`)** as a relation `(p,q) ∈ R` if `q` is reachable from `p` by a single move.
- **Game states (`G_n`)** as `(p, h)` where `h` is the history (a list of positions).

### **Formalization Steps:**

1. **Define the board (`B_n`)** as a finite set of intersections.
2. **Represent states (`S_n`)** as functions from `B_n` to `Z_3` (or `Fin 3`).
3. **Define legal positions (`P_n`)** as those states where every monochromatic group has at least one liberty.
4. **Formalize the move relation (`R`)**:
   - A move is legal if it captures an opponent group (i.e., the opponent group loses its last liberty).
   - Use **dependent types** to ensure `q ∉ h` (positional superko).
5. **Prove the DAG property (`T`)**:
   - Show that `T` is acyclic (history length increases).
   - Use `Lean.Elab.Tactic` to automate this in the kernel.

### **Certification Targets:**

- **Proposition 2.1**: The transition relation `T` is a finite DAG.
- **Corollary 2.2**: Termination bound `D(p, h) ≤ |P_n| − |h| − 1`.

---

## **2. Topological Go: Liberties and Eyes**

### **Key Components:**

- **Liberties (`L(c)`)** as the coboundary of a stone group `c`.
- **Candidate eyes** as empty vertices orthogonally enclosed by stones.

### **Formalization Steps:**

1. **Model the board as a graph (`G = (V, E)`)**:
   - `V = B_n` (vertices are board intersections).
   - `E = orthogonal adjacencies` (edges between adjacent points).
2. **Define chain complexes (`C_0, C_1`)** over `Z_2`.
3. **Represent stone groups (`1_c`)** as cochains (indicators).
4. **Compute the coboundary (`δ_0(1_c)`)** and prove:
   - A group `c` is captured iff `δ_0(1_c)` is supported entirely on occupied vertices (Proposition 3.1).
5. **Formalize candidate eyes**:
   - An empty vertex `v` is a candidate eye if all its neighbors are in `c` (or `δ_0(1_{\{v\}})` touches `c`).
   - Use **homology (`H_1`)** to verify enclosure.

### **Certification Targets:**

- **Proposition 3.1**: The coboundary condition for capture.
- **Remark 3.2**: False eyes vs. true eyes (topological vs. dynamic distinction).
- **Lemma 4.2 (bridge to topology)**: Candidate eyes imply life in Benson’s fixed point.

---

## **3. Lattice Theory: Life and Death**

### **Key Components:**

- **Boolean lattice of black stones (`L = P(Black stones)`)**.
- **Benson’s operator (`f`)** as a monotone map on the lattice.
- **Greatest fixed point (`gfp(f)`)** as the set of unconditionally alive stones.

### **Formalization Steps:**

1. **Define the lattice `L`** as a complete lattice (power set of black stones).
2. **Prove `f` is order-preserving**:
   - For `X ⊆ Y`, `f(X) ⊆ f(Y)` (since enclosure is monotone).
3. **Apply Knaster–Tarski theorem**:
   - Show `gfp(f)` exists and is the largest fixed point.
   - Use `Mathlib.OrderTheory.FixedPoint` (or similar).
4. **Prove Lemma 4.2**:
   - If `c` has two disjoint candidate eyes, then `c ⊆ gfp(f)`.

### **Certification Targets:**

- **Theorem 4.1**: Existence of `gfp(f)`.
- **Lemma 4.2**: Sufficient condition for life via eyes.

---

## **4. Combinatorial Game Theory: Endgames**

### **Key Components:**

- **Direct sum decomposition (`G = g_1 ⊕ g_2 ⊕ ...`)**.
- **Independence condition (`move in R_i` does not affect `R_j`)**.
- **Surreal numbers (`Go positions`)**.

### **Formalization Steps:**

1. **Model the game `G`** as a **loopy game** (with cycles allowed).
2. **Define independence (`g_i ⊕ g_j`)**:
   - A move in `R_i` is legal in `G` iff it is legal in `g_i`.
3. **Sum the regions**:
   - The total game is the sum of independent regions.
4. **Use surreal numbers (`Mathlib.Data.Surreal`)**:
   - Represent the value of a Go position as a surreal number.
   - Prove that the sum of values corresponds to the direct sum.

### **Certification Targets 4:**

- **Lemma 5.1**: Independence condition for direct sum.
- **Theorem 5.2**: Sum of values in endgame positions.

---

## **5. Open Problems & Further Work**

### **Potential Formalization:**

1. **Characterization of true eyes**:
   - Can we prove that a group has life iff it has two surviving candidate eyes?
2. **DAG height closed form**:
   - Can we express `D(p)` in terms of liberties, eyes, or other topological invariants?
3. **Representation theory of `D_4` (board symmetries)**:
   - How do irreducible representations decompose endgame values?

### **Certification Targets 5:**

- **Problem (i)**: Strengthening Lemma 4.2 to a full characterization.
- **Problem (ii)**: Closed-form expression for `D(p)`.
- **Problem (iii)**: Symmetry decompositions of endgame values.

---

## **Tools & Libraries to Use:**

| **Component**               | **Lean 4 Tool/Library**                          |
|----------------------------|------------------------------------------------|
| **Board & state modeling**   | `Mathlib.Data.Fin`, `Mathlib.Data.List`         |
| **DAG & partial order**     | `Mathlib.OrderTheory`, `Mathlib.DAG`            |
| **Chain complexes & homology** | `Mathlib.Algebra.Homology`                   |
| **Complete lattices & fixed points** | `Mathlib.OrderTheory.FixedPoint`       |
| **Surreal numbers & CGT**   | `Mathlib.Data.Surreal`, `Mathlib.GameTheory`    |
| **Metaprogramming (tactics)** | `Lean.Elab.Tactic`, `Mathlib.Tactic`        |

---

## **Next Steps:**

1. **Start with the state space (`P_n`)**:
   - Define `B_n` as `Fin n × Fin n`.
   - Represent `S_n` as `B_n → Fin 3`.
   - Formalize `P_n` and prove `Proposition 2.1`.
2. **Extend to chain complexes (`δ_0`)**:
   - Use `Mathlib.Algebra.Homology` for the coboundary operator.
   - Prove `Lemma 4.2`.
3. **Work on lattice fixed points (`gfp(f)`)**:
   - Use `Mathlib.OrderTheory.FixedPoint`.
   - Prove `Theorem 4.1`.
4. **Model endgame independence (`g_i ⊕ g_j`)**:
   - Use `Mathlib.GameTheory` for direct sums.
5. **Address open problems**:
   - Require deeper algebraic insights (e.g., characterizing true eyes).

This modular approach ensures that we can **certify each part of the theory** while leveraging Lean’s strong type system and automation tools. Would you like a more detailed breakdown of any specific section?
