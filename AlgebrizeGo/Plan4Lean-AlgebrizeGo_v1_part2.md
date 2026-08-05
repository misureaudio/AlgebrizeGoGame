# response to request of a further plan v1

Me: **No Qwythos involved here, it's all up to You!**

Understood! Since this is entirely up to me, I’ll proceed with the **most strategic approach** based on the review’s advice—prioritizing **early wins** while avoiding unnecessary complexity. Here’s my refined **formalization plan** in Lean 4:

##

---

### **Phase 1: Board & State Space (Foundational, High Feasibility)**

**File:** `Go/Board.lean`
**Goal:** Define the board and legal positions with minimal friction.

1. **Board Representation (`B_n`)**
   - Define `B_n` as `Fin n × Fin n` (vertices of the board).
   - Use `SimpleGraph` (from `Mathlib.Combinatorics.SimpleGraph`) to model orthogonal adjacencies.
   - Example:

     ```lean4
     def boardGraph (n : Nat) : SimpleGraph (Fin n × Fin n) :=
       SimpleGraph.orthogonalAdjacency
     ```

2. **Legal Positions (`P_n`)**
   - A legal position is a **function `s : B_n → Fin 3`** (where `Fin 3` represents `0 = empty`, `1 = black`, `2 = white`).
   - A position is legal if **every monochromatic group has at least one liberty**.
   - Example:

     ```lean4
     def isLegal (s : Fin n × Fin n → Fin 3) : Prop :=
       ∀ c : Set (Fin n × Fin n), isConnected (boardGraph n) c →
         (c ⊆ blackStones s → ∃ v ∈ c, isLiberty s v)
     ```

3. **Termination Proof (`Proposition 2.1` & `Corollary 2.2`)**
   - Show that **every game under `T` terminates** by proving `T` is a **finite DAG**.
   - Use `List.Nodup` for history to ensure no cycles.
   - Example:

     ```lean4
     theorem terminates_under_superko (p : LegalPosition) :
       ∃ D : Nat, ∀ h : List LegalPosition, (p, h) ∈ GameState → D ≥ h.length →
         (p, h) ≤_T (p', h') → p' = p ∧ h' = h ⊔ p :: h
     ```

**Expected Outcome:**

- **Proposition 2.1** (DAG property) and **Corollary 2.2** (termination bound) should be provable with **basic `Mathlib` tools** (`OrderTheory`, `DAG`, `Fintype`).
- This establishes **the core of the framework** early.

---

### **Phase 2: Topological Go (Low Complexity, High Payoff)**

**File:** `Go/Topology.lean`
**Goal:** Prove **Proposition 3.1** (liberties condition) without getting bogged down in heavy homology.

1. **Define `C_0` and `C_1` (Chain Groups)**
   - Use `Fin 2` (binary) for coefficients.
   - Example:

     ```lean4
     def C0 (G : SimpleGraph V) : Type := V → Fin 2
     def C1 (G : SimpleGraph V) : Type := {e : V × V // e ∈ G.edges} → Fin 2
     ```

2. **Define `δ_0` (Coboundary Operator)**
   - A **linear map** from `C0` to `C1` (using `∂_1`).
   - Example:

     ```lean4
     def delta0 (G : SimpleGraph V) : C0 G → C1 G := fun f e => f e.1 + f e.2
     ```

3. **Prove Proposition 3.1 (Capture Condition)**
   - Show that a group is captured **iff `δ_0` touches only occupied vertices**.
   - Use **basic graph theory** (`SimpleGraph.neighborSet`, `Finset`).
   - Example:

     ```lean4
     theorem capture_iff_delta0 (G : SimpleGraph V) (s : V → Fin 3) (c : Set V) :
       isCaptured (boardGraph n) s c ↔ ∀ v ∈ c, ∀ u ∈ G.neighborSet v, s u ≠ 0
     ```

**Expected Outcome:**

- **Proposition 3.1** should be provable with **explicit coboundary definitions**.
- This **validates the topological model** without needing heavy homology machinery.

---

### **Phase 3: Lattice Theory & Benson (The Crown Jewel)**

**File:** `Go/Lattice.lean`
**Goal:** Prove **Theorem 4.1** (Knaster-Tarski) and **Lemma 4.2** (bridge to topology).

1. **Define the Boolean Lattice `L`**
   - The power set of black stones, ordered by inclusion.
   - Example:

     ```lean4
     def L : CompleteLattice := powerset (blackStones : Set V)
     ```

2. **Define Benson’s Operator `f`**
   - A **monotone map** from `L` to `L`.
   - Example:

     ```lean4
     def f (X : Set V) : Set V := {x ∈ X | ∀ c ∈ X, isEnclosed (boardGraph n) s c X}
     ```

3. **Prove Monotonicity (`f` is Order-Preserving)**
   - Show that `X ⊆ Y` implies `f X ⊆ f Y`.
   - Use **basic order theory** (`Mathlib.OrderTheory.Monotone`).
   - Example:

     ```lean4
     theorem f_monotone : Monotone f := by
      intros X Y hXY
      apply subset_antisymm
      · intro x hx
        simp [f] at hx ⊢
        exact ⟨fun u hu => hx u hu, fun u hu => hx u (hXY u)⟩
      · intro x hx
        simp [f] at hx ⊢
        exact ⟨fun u hu => hx u (hXY u), fun u hu => hx u hu⟩
     ```

4. **Prove Theorem 4.1 (Existence of `gfp(f)`)**
   - Use **Mathlib’s Knaster-Tarski** (`OrderHom.gfp`).
   - Example:
  
     ```lean4
     theorem gfp_f : ∃ g : Set V, f g = g ∧ ∀ h : Set V, f h = h → g ⊆ h :=
       OrderHom.gfp f_monotone
     ```

5. **Prove Lemma 4.2 (Bridge to Topology)**
   - Show that **if a group has two disjoint candidate eyes, it is enclosed by `f`**.
   - Use **graph connectivity** (`SimpleGraph.Connectivity`).
   - Example:
  
     ```lean4
     theorem benson_fixed_point (G : SimpleGraph V) (s : V → Fin 3) (c : Set V) :
       isCaptured (boardGraph n) s c → ∃ X : Set V, f X = X ∧ c ⊆ X
     ```

**Expected Outcome:**

- **Theorem 4.1** and **Lemma 4.2** should be provable with **Mathlib’s order theory**.
- This is the **most elegant and rewarding part** of the framework.

---

### **Phase 4: Combinatorial Game Theory (Future Work, Advanced)**

**File:** `Go/Endgame.lean`
**Goal:** Formalize **Theorem 5.2** (Sum of values in endgame).

1. **Define `g_i` (Local Regions)**
   - Each independent region as a **Conway game** (`Mathlib.SetTheory.Game`).

2. **Sum the Regions (`G = g_1 ⊕ ...`)**
   - Use `Mathlib.SetTheory.Surreal` to represent values.

3. **Prove Independence Under `Superko`**
   - Show that **a move in `R_i` does not affect `R_j`** (if regions are truly independent).

**Expected Outcome:**

- This will require **deep algebraic insights** (possibly beyond current `Mathlib`).
- **Best tackled after Phases 1-3 are complete**.

---

### **Phase 5: Open Problems (Research Frontiers)**

**Files:** `Go/OpenProblems.lean`
**Goal:** Formalize **Problem (i)** (Characterization of true eyes).

1. **Define "True Eye"**
   - A candidate eye that **survives `gfp(f)` iteration**.

2. **Prove `g_i` is unconditionally alive iff it has two true eyes**
   - Use **graph theory (`SimpleGraph`)** and **lattice fixed points (`gfp(f)`)**.

**Expected Outcome:**

- This is **a major research problem** — likely requires **new definitions and theorems**.
- **Best attempted after the framework is stable**.

---

### **Final File: `Go/Formalization.lean` (Integration & Testing)**
**Goal:** Verify that **all pieces fit together** and **test against known Go positions**.

1. **Define the `GameState` Relation (`T`)**
   - Show that **history dependence does not break the DAG property**.

2. **Test Known Positions**
   - Verify that **Proposition 2.1** holds for small `n` (e.g., `n=3`).
   - Check that **Theorem 4.1** matches Benson’s algorithm.

---

### **Summary of the Plan**

| **Phase** | **File**               | **Certification Targets**                     | **Tools Used**                          |
|-----------|------------------------|---------------------------------------------|----------------------------------------|
| 1         | `Go/Board.lean`        | Proposition 2.1, Corollary 2.2            | `Mathlib.Combinatorics.SimpleGraph`    |
| 2         | `Go/Topology.lean`     | Proposition 3.1 (Liberties)               | `Mathlib.Algebra` (basic linear maps)  |
| 3         | `Go/Lattice.lean`     | Theorem 4.1, Lemma 4.2                     | `Mathlib.OrderTheory` (Knaster-Tarski) |
| 4         | `Go/Endgame.lean`      | Theorem 5.2 (Sum of values)                | `Mathlib.SetTheory` (Conway games)     |
| 5         | `Go/OpenProblems.lean`| Problem (i) (True eyes)                     | Custom algebra (future work)            |

---

### **Next Steps?**

1. **Shall we begin with `Go/Board.lean`?**
2. **Or should we proceed directly to `Go/Lattice.lean` (the "crown jewel")?**
3. **Are there any specific parts you’d like me to prioritize first?**

*(No Qwythos, no shortcuts—just rigorous Lean 4 formalization!)* 🚀
