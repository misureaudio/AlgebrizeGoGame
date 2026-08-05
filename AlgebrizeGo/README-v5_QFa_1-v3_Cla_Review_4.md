# Question: Should be fixed

Checked it line by line. Both real issues from last time are fixed correctly, not just papered over.

**`prop_3_1` — hypothesis fix confirmed correct.** `hc : ∀ v ∈ c, s v ≠ 0` is now in the signature (line 43), exactly closing the counterexample I built (the "$(1,1)$ empty but formally in $c$" case). I re-checked both directions of the iff under this added hypothesis and they go through cleanly, so the *statement* is now true. One thing still outstanding: the proof body is still `:= by sorry` (line 46). The claim is now correct, but not yet formally established — worth flagging so it doesn't get filed as "done" when it's "statement fixed, proof still owed."

**`benson_f` — the color-restriction fix is actually better than what I suggested.** I'd proposed restricting the ambient lattice to $\mathcal{P}(\text{Black stones})$. Instead you added `s x = 1` as a conjunct inside the set-builder itself (line 62), leaving the ambient type as the full `Set (Fin n × Fin n)`. That's a cleaner fix: since `benson_f s X` is defined to only ever output elements with `s x = 1`, any fixed point — in particular the gfp — inherits that constraint automatically, because a fixed point satisfies `gfp = benson_f s gfp`, and the right-hand side is a subset of `{x | s x = 1}` by construction. So `unconditionally_alive` is guaranteed to consist only of Black stones without needing to touch the type of the lattice at all. That's the right way to encode a "restricted lattice" constraint when the restriction is closed under the operator anyway — good fix.

**`benson_f_monotone` — this is the one that mattered most, and it's now a real proof, not a `sorry`.** I traced it:

- Unpacks `x ∈ benson_f s X` into `x ∈ X`, `s x = 1`, and the liberty-enclosure clause (lines 66–69) — correct destructuring of the nested conjunction.
- Uses `hSub : X ⊆ Y` to lift `x ∈ X` to `x ∈ Y` and carries `s x = 1` through unchanged (line 71) — fine, monotonicity of $X$ doesn't touch the color fact.
- The substantive step is showing that if a region $R$ is enclosed by $X$, it's enclosed by $Y \supseteq X$ (lines 77–82): `isEnclosed` only asks that boundary vertices of $R$ land in the container set, and `hSub` pushes that containment forward from $X$ to $Y$ directly. This is mathematically exactly right — enclosure is monotone in its containing set, which is the one fact Lemma 4.2's whole argument leans on.

This is a complete, correct proof of the load-bearing lemma. Since `benson_op` bundles it via `monotone' := benson_f_monotone s` and `unconditionally_alive` is `OrderHom.gfp (benson_op s)`, the Knaster–Tarski application is now actually licensed rather than assumed. That closes the gap I'd flagged as the most serious one last round.

**Remaining open items, for completeness:**

- `adj_symmetric` and `adj_irreflexive` (lines 16–17) are still `sorry` — mechanical, low-stakes, but `boardGraph` technically isn't yet verified to be a legal `SimpleGraph` until these are filled.
- `prop_3_1`'s proof body, as noted above.

Both are routine compared to what's been fixed. The two substantive gaps from last round — the missing occupancy hypothesis and the unproven monotonicity — are genuinely resolved now, not just reworded.
