# Go v1 review 4

This is a real improvement, not just flattery-then-repackaging — I want to be specific about what actually got fixed versus what's just been relocated to a fancier spot.

**Genuinely fixed, I think:**

- **The coboundary swap.** Using $\delta_0: C^0(G;\mathbb{Z}_2) \to C^1(G;\mathbb{Z}_2)$ on the indicator function of a stone group is the right move and does type-check. $\delta_0(\mathbf{1}_c)$ picks out exactly the edges where the indicator changes value — i.e., the edge-cut between the stone group and its complement — and restricting to edges landing on empty vertices gives you liberties correctly. This isn't just patched notation; it's the actual dual formulation of what §4 was groping toward, and on a graph (a 1-dimensional complex) coboundary and boundary are the same data up to the identification $C^1 \cong C_1$, so nothing was lost, only correctly typed. Good fix.

- **Superko finiteness.** This is clean and correct, and honestly stronger than what it's replacing: positional superko means no board state repeats within a game, the state space is finite, so any legal game has bounded length. You don't even need the "poset" language to get this — it falls straight out of injectivity into a finite set. Calling the reachability relation on the resulting acyclic graph a poset is fine (antisymmetry is free from acyclicity), but it's a minor packaging choice, not new content. The load-bearing fact is just "no repeats + finite state space ⟹ termination," and that's real.

**Where I'd push back — the CW-complex / false-eye claim is doing the same thing §7 did, just one level up.**

Right now "if we model the board as a CW complex with 2×2 grid squares as 2-cells, we can use relative homology to detect true eyes" is a promissory note, not a construction. To actually be math rather than poetry, it needs:

1. A precise specification of the complex — which 2-cells are attached, along what boundary, relative to *what* subspace (relative to the stone group? to the complement of the eye point?).
2. A worked example that a real false eye — say, a corner point surrounded orthogonally but with the controlling diagonal open — actually comes out as "not a hole" under this machinery, while a real eye survives.
3. Some account of the fact that eye-falseness in Go is not a static topological property of the position at all — it depends on whether the defender can win a capturing race on the diagonal, which is a *dynamic* fact about the game tree, not a fact about a fixed simplicial complex. A single position's homology can't know who wins a ko fight for the diagonal point. So even a well-built CW complex is at best going to capture a necessary condition (orthogonal enclosure), not the actual true/false distinction, unless the construction is somehow parametrized by best play — at which point you've smuggled the hard part of Go back in through the strategic layer, and the homology isn't doing the work anymore.

I'd want that worked example before believing this section is real. Until then it's the same move as the old §7: reach for heavier machinery (relative homology) because it sounds like it should capture the phenomenon, without checking it against a case designed to break it.

**One more tension worth flagging: does §3 (topology) actually feed §4 (lattice/Benson), or do they just sit next to each other?**

Benson's algorithm, as it's actually implemented, doesn't need eyes-as-topological-holes at all — it works directly with *enclosed regions* and the combinatorial notion of a region being *vital* to a chain (every empty point in the region is a liberty of that chain), iterating removal of chains/regions that fail. That's already fully rigorous with nothing but graph connectivity — no homology required. So the V2 outline's claim to "link" the CW-complex eyes of §3 to the vital regions of §4 needs an actual bridge lemma (something like: a region is a topological eye in the §3 sense iff it's vital in Benson's sense), or the two sections just coexist without touching, and you'd be better off cutting §3's heavy machinery entirely and letting §4 stand alone on Benson/Knaster–Tarski, which is already your strongest material.

So: real progress on two counts, and I'd sign off on drafting V2 with the DAG/superko section and the Knaster–Tarski section as centerpieces largely as proposed. I'd hold the CW-complex section to a higher bar before including it — either produce the worked false-eye example and the bridge lemma to Benson, or downgrade the claim to "orthogonal enclosure is necessary but not sufficient for a true eye, and we do not attempt to capture the diagonal/ko-dependent part homologically." The second option is less exciting but it's honest, and honest-but-modest is exactly the standard the rest of this pivot is holding itself to.
