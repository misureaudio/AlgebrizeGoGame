# Go v3 qwy review 6

This version is noticeably stronger. It fixes the most important structural issue I identified: **superko is now modeled as a property of game histories rather than positions alone**, and the independence assumption in the CGT section is now explicitly stated.  

That said, I still see three places where a mathematically demanding reviewer could object.

---

## 1. Corollary 2.2 contains a dubious bound

You write:

> every game terminates after at most (3^{n^2}-\ell(p)) moves. 

I do not think this follows.

The argument seems to be:

* there are at most (3^{n^2}) positions,
* each move visits a new position,
* therefore at most (3^{n^2}) moves.

That part is fine.

But subtracting (\ell(p)) (the current number of stones) has no obvious justification because captures allow the stone count to decrease while the history continues to grow.

I would replace the statement with the weaker but correct bound

[
D(p,h)\le |P_n|-1,
]

or

[
D(p,h)\le 3^{n^2}-1.
]

That bound follows immediately from finiteness of the state space.

---

## 2. The eye-homology claim is still the weakest mathematical point

You still say:

> a true eye corresponds to a nontrivial element of (H_1(G_c,c;\mathbb Z_2)). 

This remains suggestive rather than established.

A reviewer could ask:

* Which theorem proves the correspondence?
* Is it bijective?
* Is every nontrivial relative homology class an eye?
* Are all eyes represented by such classes?

The essay never demonstrates this.

My recommendation:

replace

> “a true eye corresponds to”

with

> “a candidate eye may be represented by”

or

> “nontrivial classes in (H_1(G_c,c;\mathbb Z_2)) provide a topological certificate of enclosure.”

That would be harder to attack.

---

## 3. Lemma 4.2 is improved but still overreaches

The new proof is stronger than the previous one. 

However the critical sentence is:

> any liberty of (c) that lies in (R) must be incident to one of these eyes. 

That is not implied by the hypotheses.

Nor does

> any opponent move can fill at most one eye

fully establish Benson invariance.

A Go specialist would likely ask for either:

### Option A (preferred)

Downgrade Lemma 4.2 to an informal bridge statement.

For example:

> If a group possesses two disjoint candidate eyes that remain enclosed throughout Benson iteration, then the group belongs to (gfp(f)).

This aligns perfectly with Benson theory.

### Option B

Give a fully formal proof using Benson's actual definitions of vital regions and enclosed liberties.

That is possible, but would substantially lengthen the paper.

---

## One statement I would remove

Remark 4.3 says:

> a group may be unconditionally alive without possessing two disjoint eyes (e.g. a bent four shape ...). 

This is dangerous.

Under standard Go terminology:

* bent four in the corner is alive only because of ko-related considerations,
* it is not the standard textbook example of unconditional (pass) life.

A Go theorist may challenge the example.

I would either:

* remove the example, or
* replace it with a citation to Benson's original analysis.

---

## What now looks solid

The following sections are now in good shape:

* History-based superko DAG. 
* Reachability partial order. 
* Coboundary definition of liberties. 
* Capture criterion via support of the coboundary. 
* Knaster–Tarski formulation of Benson's operator. 
* Explicit CGT independence hypothesis. 

---

### Overall assessment of v3

If v2 was roughly a **good mathematical essay**, v3 is approaching a **publishable expository note**.

My current estimate:

| Aspect                 | Score  |
| ---------------------- | ------ |
| Mathematical soundness | 9/10   |
| Rigor                  | 8.5/10 |
| Exposition             | 8.5/10 |
| Novel synthesis        | 6/10   |

The remaining vulnerabilities are concentrated almost entirely around the homology-eye correspondence and the strengthened Lemma 4.2. Everything else is now substantially better grounded than in the previous draft.
