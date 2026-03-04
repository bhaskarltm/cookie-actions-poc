# cookie-actions-poc — Autonomous Auto Fix PoC (Cookie Compliance)

This repository demonstrates an **autonomous remediation workflow** for a simple **cookie security policy** (**HttpOnly / Secure / SameSite**) aligned to the PoC flow described in the [reference deck](https://ltimindtree-my.sharepoint.com/personal/janardhana_68050039_ltimindtree_com/_layouts/15/Doc.aspx?sourcedoc=%7B0F71CA19-E571-4F3F-9B30-3001BF51911F%7D&file=Semi_Automated_Compliance_Operations_at_Scale_v1.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1) (trigger action → create fix branch → run tests → commit → raise PR).

## What’s inside

- **Sample .NET WebAPI** with an intentionally insecure cookie endpoint (`/set-cookie`) to trigger policy violations (PoC).
- **Policy gate script**: `scripts/check_cookies.sh` — fails CI if cookie flags are missing (**HttpOnly / Secure / SameSite**).
- **3‑workflow GitHub Actions chain (decoupled responsibilities)**:
  1. **Orchestrator (A)**: creates/resets the issue branch (`autofix/issue-<id>`), runs build/tests + cookie gate, and decides whether a fix is required.
  2. **Fix + Commit (B)**: applies deterministic fix logic and commits to the issue branch (reusable workflow).
  3. **Raise PR (C)**: opens a PR from the issue branch to `main` (reusable workflow).

## How to run

1. **Create a GitHub Issue (task)** like: **“Fix insecure cookie settings”**.
2. Go to **Actions → AutoFix Orchestrator** and run it with:
   - `issue_number=<issue-id>` (Already created issue_number=1)
   - `base_branch=main`
3. If the policy gate fails, the chain automatically:
   - **fixes + commits**, then **raises a PR**.

