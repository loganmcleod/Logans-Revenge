# Logan's Revenge

> A read-only Claude Code agent that walks into a legacy codebase and hands you a plan to **stabilize it with the least possible effort** — not a rewrite proposal.

Every senior engineer has inherited the codebase that pages them at 3am. `Logan's Revenge` is the diagnostician you wish you'd had: it performs deep static analysis across eight engineering lenses, scores every finding by real production risk, and tells you the **smallest change** that removes each defect — including which defects to *leave alone*.

It **never edits your code.** It diagnoses, and it plans. Fixing stays a human-approved step.

---

## Why it exists

Most "audit" tools optimize for finding the most problems. That's the wrong objective for a legacy system that is *already in production*. The prime directive here is the opposite:

**Stabilize the existing architecture. Minimize refactoring. Transform only when a defect genuinely cannot be removed any other way.**

A working-but-ugly system left running beats a "clean" rewrite that destabilizes it. The agent is built around that belief.

---

## What it does

### 1. Detects your stack first
Before judging anything, it reads your manifests, lockfiles, container/IaC config, and framework setup to establish the runtime, concurrency model, datastore, and deploy target. Findings are only meaningful relative to how the thing actually runs.

### 2. Audits across eight lenses

| Lens | Hunts for |
|---|---|
| **Architecture & pattern erosion** | Layer violations, God classes, circular dependencies, boundary breaches |
| **Database & persistence** | N+1 queries, eager-fetch cascades, transaction-scope bloat, missing indexes, Cartesian explosions |
| **Performance & scalability** | Unbounded materialization, single-node state that blocks horizontal scaling, hot-path waste |
| **Correctness & state integrity** | Races on shared mutable state, proxy/AOP self-invocation traps, swallowed exceptions |
| **Systems engineering** | Build/deploy health, env parity, dependency & CVE posture, secrets in source |
| **Stability & resilience** | Failure-mode cascades, missing timeouts/retries/breakers, observability gaps |
| **Data architecture** | Schema-vs-code drift, unsafe migrations, referential integrity, data lifecycle |
| **Security posture** | AuthZ gaps, injection surfaces, exposed secrets, reachable dependency vulns |

### 3. Scores every finding so the plan falls out mechanically
Each finding carries four axes:

- **Risk** — Critical / High / Medium / Low (likelihood × severity *under real load and failure*)
- **Blast radius** — Isolated → Module → Service-wide → Systemic
- **Effort** — S (one config/guard/index/annotation) / M (a few files) / L (structural, cross-cutting)
- **Confidence** — Verified (traced) / Likely / Speculative

Speculative findings never drive churn — they go to a separate "verify next" list.

### 4. Returns a two-tier report

**Tier 1 — Diagnosis:** every defect, grouped by lens, with the traced mechanism and the evidence.

**Tier 2 — Stabilization plan**, in three ranked buckets:
- **A. Stabilize now** — high-value, low-effort, verified. The smallest change that removes each risk.
- **B. Watch / schedule** — real risk, but effort or uncertainty argues for later; names the trigger that promotes it.
- **C. Do-not-touch** — low-risk/high-effort or long-tolerated defects where the churn is worse than the disease. Recommending inaction is a first-class outcome.

---

## Stack support

The agent's eight lenses are **stack-agnostic**. Concrete, idiom-level checks live in pluggable adapters:

- **Java / Spring / Hibernate-JPA / Angular** — JPA N+1, `FetchType.EAGER` cascades, `@Transactional` scope & proxy self-invocation, RxJS subscription leaks, template-method change-detection thrash, and more.
- **Next.js / TypeScript / Postgres / Drizzle** — per-row queries in `.map`, Server Action / RSC pitfalls, transaction boundaries around outbound work, missing indexes on scoped queries, in-process caches that break across instances.
- **Generic fallback** — the eight lenses applied at the language-agnostic level for any other stack, with a note naming the adapter worth adding.

Adding an adapter is a documentation edit, not a code change — extend the appendix in the agent file.

---

## Install

`Logan's Revenge` is a [Claude Code](https://claude.com/claude-code) subagent — a single Markdown file with frontmatter.

**Per project** (checked into a repo you want the agent available in):
```bash
mkdir -p .claude/agents
curl -o .claude/agents/legacy-stabilization-auditor.md \
  https://raw.githubusercontent.com/<your-org>/Logans-Revenge/main/.claude/agents/legacy-stabilization-auditor.md
```

**Globally** (available in every project on your machine):
```bash
mkdir -p ~/.claude/agents
cp .claude/agents/legacy-stabilization-auditor.md ~/.claude/agents/
```

The agent inherits whatever model your Claude Code session is running and is restricted to read-only tools (`Read`, `Grep`, `Glob`, `Bash`).

## Use

Once installed, invoke it in Claude Code:

- **By name:** `Use the legacy-stabilization-auditor to diagnose this repo and give me a stabilization plan.`
- **It self-triggers** on requests like "audit / diagnose / evaluate / triage this legacy codebase" or "how do I stabilize this?"

Point it at a whole repo, a module, or a single subsystem. The tighter the scope, the deeper the trace.

## License

MIT — see [LICENSE](LICENSE).
