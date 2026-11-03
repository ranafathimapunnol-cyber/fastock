#!/bin/bash
set -e

OWNER="ranafathimapunnol-cyber"
REPO="fastock"
PROJECT=10

echo "Creating priority labels..."

gh label create must --color D73A4A --description "Must-have requirement" --force
gh label create should --color 0075CA --description "Should-have requirement" --force
gh label create could --color C2E0C6 --description "Could-have requirement" --force
gh label create wont --color EDEDED --description "Out of scope" --force

echo "Creating six weekly milestones..."

create_milestone() {
  TITLE="$1"
  DESCRIPTION="$2"

  if ! gh api "repos/$OWNER/$REPO/milestones?state=all&per_page=100" \
    --jq '.[].title' | grep -Fxq "$TITLE"; then
    gh api --method POST "repos/$OWNER/$REPO/milestones" \
      -f title="$TITLE" -f description="$DESCRIPTION" >/dev/null
  fi
}

create_milestone "Week 1 — Discover, Design and Spike" "Project discovery, architecture and technical spikes."
create_milestone "Week 2 — Core Product and First Deployment" "Core inventory application and first deployment."
create_milestone "Week 3 — Knowledge Layer and Read-only Agent" "RAG implementation and read-only AI agent."
create_milestone "Week 4 — Actions, Approval and Evaluations" "Agent actions, approval workflow and evaluations."
create_milestone "Week 5 — Production Hardening" "Security, reliability, monitoring and production readiness."
create_milestone "Week 6 — Launch and Demo Day" "Final testing, documentation and project demonstration."

echo "Creating user-story issues..."

create_issue() {
  TITLE="$1"
  LABEL="$2"
  MILESTONE="$3"
  BODY="$4"

  URL=$(gh issue create \
    --title "$TITLE" \
    --body "$BODY" \
    --label "$LABEL" \
    --milestone "$MILESTONE")

  echo "Created: $URL"

  gh project item-add "$PROJECT" \
    --owner "$OWNER" \
    --url "$URL"

  echo "Added to project board."
}

create_issue "US-01 Secure User Login" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As a user, I want to securely log in so that only authorised users can access the application.

## Acceptance Criteria
- Given valid credentials, when I log in, then I access my account.
- Given invalid credentials, when I log in, then an appropriate error is displayed.
- Given an unauthorised user, when they access a protected page, then access is denied.
BODY
)"

create_issue "US-02 Product Management" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to create, view, update and manage products.

## Acceptance Criteria
- Given valid product details, when I create a product, then it is saved.
- Given an existing product, when I update its details, then the changes are saved.
- Given invalid product data, when I submit it, then validation errors are displayed.
BODY
)"

create_issue "US-03 Record Stock Movements" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to record stock movements so that inventory quantities remain accurate.

## Acceptance Criteria
- Given a valid stock-in movement, when recorded, then stock increases.
- Given a valid stock-out movement, when recorded, then stock decreases.
- Given insufficient stock, when stock-out is attempted, then the operation is rejected.
- Every movement records its type, quantity, date and user.
BODY
)"

create_issue "US-04 View Inventory" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to view inventory and available quantities.

## Acceptance Criteria
- Given existing products, when I open inventory, then product quantities are displayed.
- Given a search term, when I search, then matching products are displayed.
- Given inventory records, when I filter them, then matching results are displayed.
BODY
)"

create_issue "US-05 Identify Low-Stock Products" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to identify products below their reorder level.

## Acceptance Criteria
- Given a product below its reorder level, when inventory is checked, then it is identified as low stock.
- Given sufficient stock, when inventory is checked, then it is not incorrectly marked low stock.
- Low-stock results show current quantity and reorder level.
BODY
)"

create_issue "US-06 Supplier Management" should "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to manage supplier information.

## Acceptance Criteria
- Given valid supplier details, when I create a supplier, then it is saved.
- Given an existing supplier, when I update the details, then changes are saved.
- Supplier information can be viewed and searched.
BODY
)"

create_issue "US-07 View Sales Summary" should "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As a business owner, I want to view sales summaries to understand product movement.

## Acceptance Criteria
- Given sales records, when I request a summary, then totals are calculated.
- Given a date range, when I filter sales, then only matching records are included.
- The summary displays product-level sales information.
BODY
)"

create_issue "US-08 Search Inventory Policies" must "Week 3 — Knowledge Layer and Read-only Agent" "$(cat <<'BODY'
## User Story
As a user, I want to search inventory policies and procedures using natural language.

## Acceptance Criteria
- Given indexed knowledge documents, when I ask a question, then relevant passages are retrieved.
- Retrieved answers include document citations.
- When no supporting evidence exists, the system clearly says it could not find the information.
BODY
)"

create_issue "US-09 Ask the AI Copilot" must "Week 3 — Knowledge Layer and Read-only Agent" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to ask the AI copilot questions about inventory.

## Acceptance Criteria
- Given an inventory question, when I submit it, then the copilot provides a relevant response.
- The copilot uses authorised business data and knowledge tools.
- Responses provide explanations and supporting evidence where applicable.
- The system handles tool and LLM errors safely.
BODY
)"

create_issue "US-10 Generate Purchase Order Proposals" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want the AI copilot to prepare purchase order proposals.

## Acceptance Criteria
- Given stock and supplier information, when I request restocking, then a purchase proposal is generated.
- The proposal includes products, quantities and supplier details.
- The proposal does not automatically place an order.
- The proposal is available for authorised human review.
BODY
)"

create_issue "US-11 Review and Approve Proposals" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an administrator, I want to review and approve or reject proposed business actions.

## Acceptance Criteria
- Given a pending proposal, when I review it, then its details are displayed.
- Given an authorised administrator, when they approve or reject it, then the decision is recorded.
- Only approved proposals can be executed.
- Every decision is recorded in the audit log.
BODY
)"

create_issue "US-12 Investigate Stock Discrepancies" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want the AI copilot to investigate stock discrepancies.

## Acceptance Criteria
- Given a product discrepancy, when I request an investigation, then relevant stock movements are retrieved.
- The investigation provides evidence and possible explanations.
- The agent does not directly change stock quantities.
- Findings are presented to the user.
BODY
)"

create_issue "US-13 Propose Stock Adjustments" should "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to review proposed stock adjustments.

## Acceptance Criteria
- Given investigation findings, when an adjustment is justified, then a proposal is created.
- The proposal includes the affected product, quantity and reason.
- Stock is not changed before human approval.
- Approved execution is audited.
BODY
)"

create_issue "US-14 Inspect Agent Runs" should "Week 5 — Production Hardening" "$(cat <<'BODY'
## User Story
As an administrator, I want to inspect AI agent runs and their execution traces.

## Acceptance Criteria
- Given an agent run, when I inspect it, then its status and execution steps are visible.
- Tool calls, errors and timestamps are recorded.
- Sensitive information is masked.
- Only authorised users can inspect traces.
BODY
)"

create_issue "US-15 Export Inventory Reports" could "Week 6 — Launch and Demo Day" "$(cat <<'BODY'
## User Story
As a business owner, I want to export inventory reports for record keeping.

## Acceptance Criteria
- Given inventory data, when I request an export, then a report is generated.
- The report contains relevant product and stock information.
- Exported data respects the user's permissions.
BODY
)"

echo ""
echo "=========================================="
echo "FASTOCK GITHUB SETUP COMPLETED!"
echo "=========================================="
echo "Repository: https://github.com/$OWNER/$REPO"
echo "Project: https://github.com/users/$OWNER/projects/$PROJECT"
echo "15 issues, priority labels and milestones created."
EOFmkdir -p scripts
cat > scripts/setup_github.sh <<'EOF'
#!/bin/bash
set -e

OWNER="ranafathimapunnol-cyber"
REPO="fastock"
PROJECT=10

echo "Creating priority labels..."

gh label create must --color D73A4A --description "Must-have requirement" --force
gh label create should --color 0075CA --description "Should-have requirement" --force
gh label create could --color C2E0C6 --description "Could-have requirement" --force
gh label create wont --color EDEDED --description "Out of scope" --force

echo "Creating six weekly milestones..."

create_milestone() {
  TITLE="$1"
  DESCRIPTION="$2"

  if ! gh api "repos/$OWNER/$REPO/milestones?state=all&per_page=100" \
    --jq '.[].title' | grep -Fxq "$TITLE"; then
    gh api --method POST "repos/$OWNER/$REPO/milestones" \
      -f title="$TITLE" -f description="$DESCRIPTION" >/dev/null
  fi
}

create_milestone "Week 1 — Discover, Design and Spike" "Project discovery, architecture and technical spikes."
create_milestone "Week 2 — Core Product and First Deployment" "Core inventory application and first deployment."
create_milestone "Week 3 — Knowledge Layer and Read-only Agent" "RAG implementation and read-only AI agent."
create_milestone "Week 4 — Actions, Approval and Evaluations" "Agent actions, approval workflow and evaluations."
create_milestone "Week 5 — Production Hardening" "Security, reliability, monitoring and production readiness."
create_milestone "Week 6 — Launch and Demo Day" "Final testing, documentation and project demonstration."

echo "Creating user-story issues..."

create_issue() {
  TITLE="$1"
  LABEL="$2"
  MILESTONE="$3"
  BODY="$4"

  URL=$(gh issue create \
    --title "$TITLE" \
    --body "$BODY" \
    --label "$LABEL" \
    --milestone "$MILESTONE")

  echo "Created: $URL"

  gh project item-add "$PROJECT" \
    --owner "$OWNER" \
    --url "$URL"

  echo "Added to project board."
}

create_issue "US-01 Secure User Login" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As a user, I want to securely log in so that only authorised users can access the application.

## Acceptance Criteria
- Given valid credentials, when I log in, then I access my account.
- Given invalid credentials, when I log in, then an appropriate error is displayed.
- Given an unauthorised user, when they access a protected page, then access is denied.
BODY
)"

create_issue "US-02 Product Management" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to create, view, update and manage products.

## Acceptance Criteria
- Given valid product details, when I create a product, then it is saved.
- Given an existing product, when I update its details, then the changes are saved.
- Given invalid product data, when I submit it, then validation errors are displayed.
BODY
)"

create_issue "US-03 Record Stock Movements" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to record stock movements so that inventory quantities remain accurate.

## Acceptance Criteria
- Given a valid stock-in movement, when recorded, then stock increases.
- Given a valid stock-out movement, when recorded, then stock decreases.
- Given insufficient stock, when stock-out is attempted, then the operation is rejected.
- Every movement records its type, quantity, date and user.
BODY
)"

create_issue "US-04 View Inventory" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to view inventory and available quantities.

## Acceptance Criteria
- Given existing products, when I open inventory, then product quantities are displayed.
- Given a search term, when I search, then matching products are displayed.
- Given inventory records, when I filter them, then matching results are displayed.
BODY
)"

create_issue "US-05 Identify Low-Stock Products" must "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to identify products below their reorder level.

## Acceptance Criteria
- Given a product below its reorder level, when inventory is checked, then it is identified as low stock.
- Given sufficient stock, when inventory is checked, then it is not incorrectly marked low stock.
- Low-stock results show current quantity and reorder level.
BODY
)"

create_issue "US-06 Supplier Management" should "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to manage supplier information.

## Acceptance Criteria
- Given valid supplier details, when I create a supplier, then it is saved.
- Given an existing supplier, when I update the details, then changes are saved.
- Supplier information can be viewed and searched.
BODY
)"

create_issue "US-07 View Sales Summary" should "Week 2 — Core Product and First Deployment" "$(cat <<'BODY'
## User Story
As a business owner, I want to view sales summaries to understand product movement.

## Acceptance Criteria
- Given sales records, when I request a summary, then totals are calculated.
- Given a date range, when I filter sales, then only matching records are included.
- The summary displays product-level sales information.
BODY
)"

create_issue "US-08 Search Inventory Policies" must "Week 3 — Knowledge Layer and Read-only Agent" "$(cat <<'BODY'
## User Story
As a user, I want to search inventory policies and procedures using natural language.

## Acceptance Criteria
- Given indexed knowledge documents, when I ask a question, then relevant passages are retrieved.
- Retrieved answers include document citations.
- When no supporting evidence exists, the system clearly says it could not find the information.
BODY
)"

create_issue "US-09 Ask the AI Copilot" must "Week 3 — Knowledge Layer and Read-only Agent" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to ask the AI copilot questions about inventory.

## Acceptance Criteria
- Given an inventory question, when I submit it, then the copilot provides a relevant response.
- The copilot uses authorised business data and knowledge tools.
- Responses provide explanations and supporting evidence where applicable.
- The system handles tool and LLM errors safely.
BODY
)"

create_issue "US-10 Generate Purchase Order Proposals" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want the AI copilot to prepare purchase order proposals.

## Acceptance Criteria
- Given stock and supplier information, when I request restocking, then a purchase proposal is generated.
- The proposal includes products, quantities and supplier details.
- The proposal does not automatically place an order.
- The proposal is available for authorised human review.
BODY
)"

create_issue "US-11 Review and Approve Proposals" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an administrator, I want to review and approve or reject proposed business actions.

## Acceptance Criteria
- Given a pending proposal, when I review it, then its details are displayed.
- Given an authorised administrator, when they approve or reject it, then the decision is recorded.
- Only approved proposals can be executed.
- Every decision is recorded in the audit log.
BODY
)"

create_issue "US-12 Investigate Stock Discrepancies" must "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want the AI copilot to investigate stock discrepancies.

## Acceptance Criteria
- Given a product discrepancy, when I request an investigation, then relevant stock movements are retrieved.
- The investigation provides evidence and possible explanations.
- The agent does not directly change stock quantities.
- Findings are presented to the user.
BODY
)"

create_issue "US-13 Propose Stock Adjustments" should "Week 4 — Actions, Approval and Evaluations" "$(cat <<'BODY'
## User Story
As an inventory manager, I want to review proposed stock adjustments.

## Acceptance Criteria
- Given investigation findings, when an adjustment is justified, then a proposal is created.
- The proposal includes the affected product, quantity and reason.
- Stock is not changed before human approval.
- Approved execution is audited.
BODY
)"

create_issue "US-14 Inspect Agent Runs" should "Week 5 — Production Hardening" "$(cat <<'BODY'
## User Story
As an administrator, I want to inspect AI agent runs and their execution traces.

## Acceptance Criteria
- Given an agent run, when I inspect it, then its status and execution steps are visible.
- Tool calls, errors and timestamps are recorded.
- Sensitive information is masked.
- Only authorised users can inspect traces.
BODY
)"

create_issue "US-15 Export Inventory Reports" could "Week 6 — Launch and Demo Day" "$(cat <<'BODY'
## User Story
As a business owner, I want to export inventory reports for record keeping.

## Acceptance Criteria
- Given inventory data, when I request an export, then a report is generated.
- The report contains relevant product and stock information.
- Exported data respects the user's permissions.
BODY
)"

echo ""
echo "=========================================="
echo "FASTOCK GITHUB SETUP COMPLETED!"
echo "=========================================="
echo "Repository: https://github.com/$OWNER/$REPO"
echo "Project: https://github.com/users/$OWNER/projects/$PROJECT"
echo "15 issues, priority labels and milestones created."
