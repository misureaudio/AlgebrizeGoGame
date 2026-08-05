import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Data.Sym.Sym2
import Mathlib.Data.Set.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Order.FixedPoints
import Mathlib.Order.Lattice

variable {n : ℕ}

-- 1. BOARD DEFINITION
def adj (n : ℕ) (a b : Fin n × Fin n) : Prop :=
  (a.1 = b.1 ∧ ((a.2 : ℤ) - (b.2 : ℤ)).natAbs = 1) ∨
  (a.2 = b.2 ∧ ((a.1 : ℤ) - (b.1 : ℤ)).natAbs = 1)

lemma adj_symmetric (n : ℕ) : Std.Symm (adj n) := sorry
lemma adj_irreflexive (n : ℕ) : Std.Irrefl (adj n) := sorry

def boardGraph (n : ℕ) : SimpleGraph (Fin n × Fin n) where
  Adj := adj n
  symm := adj_symmetric n
  loopless := adj_irreflexive n

def BoardState (n : ℕ) := (Fin n × Fin n) → Fin 3

-- 2. TOPOLOGY DEFINITION
def C0 (n : ℕ) := (Fin n × Fin n) → ZMod 2
def C1 (n : ℕ) := (boardGraph n).edgeSet → ZMod 2

def edgeSum (f : C0 n) (u v : Fin n × Fin n) : ZMod 2 := f u + f v

lemma edgeSum_symm (f : C0 n) (u v : Fin n × Fin n) : edgeSum f u v = edgeSum f v u := by
  exact add_comm (f u) (f v)

def delta_0 (f : C0 n) : C1 n :=
  fun e => Sym2.lift ⟨edgeSum f, edgeSum_symm f⟩ (e.val)

def isCaptured (s : BoardState n) (c : Set (Fin n × Fin n)) : Prop :=
  ∀ v ∈ c, ∀ u, (boardGraph n).Adj v u → s u ≠ 0

-- Theorem 3.1 WITH the explicit occupancy hypothesis (hc)
theorem prop_3_1 (s : BoardState n) (c : Set (Fin n × Fin n)) [DecidablePred (· ∈ c)]
    (hc : ∀ v ∈ c, s v ≠ 0) :
  let f : C0 n := fun v => if v ∈ c then 1 else 0;
  (isCaptured s c) ↔ (∀ e : (boardGraph n).edgeSet,
    (∃ v ∈ e.val, s v = 0) → delta_0 f e = 0) := by sorry


-- 3. LATTICE THEORY (Benson's Algorithm and Knaster-Tarski)

-- Definition of an enclosed region of empty points (Formal Enclosure)
def isEnclosed (s : BoardState n) (R : Set (Fin n × Fin n)) (X : Set (Fin n × Fin n)) : Prop :=
  (∀ v ∈ R, s v = 0) ∧
  (∀ v ∈ R, ∀ u, (boardGraph n).Adj v u → u ∉ R → u ∈ X)

-- Definition of a liberty of a specific stone 'x'
def isLibertyOf (s : BoardState n) (l x : Fin n × Fin n) : Prop :=
  s l = 0 ∧ (boardGraph n).Adj l x

-- Claude's Fixed Benson Operator: Returns ONLY Black stones (s x = 1) whose liberties are enclosed
def benson_f (s : BoardState n) (X : Set (Fin n × Fin n)) : Set (Fin n × Fin n) :=
  { x ∈ X | s x = 1 ∧ ∀ l, isLibertyOf s l x → ∃ R, l ∈ R ∧ isEnclosed s R X }

lemma benson_f_monotone (s : BoardState n) : Monotone (benson_f s) := by
  -- Monotonicity means if X ⊆ Y, then benson_f X ⊆ benson_f Y
  intro X Y hSub x hx
  -- Unpack the definition of x ∈ benson_f X
  dsimp [benson_f] at hx ⊢
  rcases hx with ⟨hx_in_X, hx_black, hx_libs⟩
  -- Prove x ∈ Y, x is black, and construct the enclosed regions for Y
  refine ⟨hSub hx_in_X, hx_black, ?_⟩
  intro l hl
  -- For any liberty l, get the region R that was enclosed by X
  rcases hx_libs l hl with ⟨R, hlR, hR_encl⟩
  use R
  refine ⟨hlR, ?_⟩
  -- Now prove that R is ALSO enclosed by Y
  dsimp [isEnclosed] at hR_encl ⊢
  rcases hR_encl with ⟨hR_empty, hR_bndry⟩
  refine ⟨hR_empty, fun v hv u h_adj h_u_not_R => ?_⟩
  -- Since the boundary is in X, and X ⊆ Y, the boundary is in Y!
  exact hSub (hR_bndry v hv u h_adj h_u_not_R)

-- Bundle the function and its monotonicity into an Order Homomorphism
def benson_op (s : BoardState n) : Set (Fin n × Fin n) →o Set (Fin n × Fin n) where
  toFun := benson_f s
  monotone' := benson_f_monotone s

-- THE GRAND FINALE: Unconditionally alive stones defined via Knaster-Tarski Greatest Fixed Point!
def unconditionally_alive (s : BoardState n) : Set (Fin n × Fin n) :=
  OrderHom.gfp (benson_op s)
