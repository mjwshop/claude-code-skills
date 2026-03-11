Generate a discovery brief and meeting prep doc for: $ARGUMENTS

## Instructions

Build a comprehensive discovery brief for the specified merchant or account. The output should have a quick TL;DR at the top for fast reference, followed by a detailed brief below. Run Steps 1-4 in parallel where possible to minimize wait time.

### Step 1: Resolve the Account

Use `revenue-mcp search_data_tool` to find the account. Try these approaches in order:
1. Search by account name (if text provided): `tolower(account_name) eq '<lowercase input>'` or `contains(tolower(account_name), '<lowercase input>')`
2. Search by account ID (if Salesforce ID provided): `account_id eq '<id>'`
3. If multiple matches, show the top 3 and ask which one to use

Select these fields: `account_name,account_id,industry,employee_count,estimated_total_annual_revenue_usd,gmv_usd_l365d,region,territory_name,d2c_fit_score,b2b_fit_score,is_d2c,adopted_products,eligible_products,location_count`

### Step 2: Get Shop-Level Data

Query `revenue-mcp search_data_tool` with the Shops dataset filtered by the resolved account_id. Select key fields including plan, country, GMV, product adoption, and shop status.

### Step 3: Company Enrichment

Use `revenue-mcp ai_company_enrichment` with the account name and/or domain to gather:
- Business model and industry context
- Digital presence and e-commerce maturity
- Physical retail footprint
- Social media presence

### Step 4: Salesforce Context

Use `revenue-mcp search_salesforce_tool` to pull CRM context. Run these queries:

**4a — Open Opportunities:**
```sql
SELECT Id, Name, StageName, CloseDate, Amount, Type, OwnerId, Owner.Name,
       Product_Line__c, CreatedDate, LastModifiedDate
FROM Opportunity
WHERE Account.Name LIKE '%[merchant name]%'
  AND RecordType.Name = 'Sales'
  AND IsClosed = false
ORDER BY CloseDate ASC
LIMIT 10
```

**4b — Recent Closed Opportunities (last 12 months):**
```sql
SELECT Id, Name, StageName, CloseDate, Amount, Type, Product_Line__c, IsWon
FROM Opportunity
WHERE Account.Name LIKE '%[merchant name]%'
  AND RecordType.Name = 'Sales'
  AND IsClosed = true
  AND CloseDate = LAST_N_DAYS:365
ORDER BY CloseDate DESC
LIMIT 10
```

**4c — Recent Cases (launches, support):**
```sql
SELECT Id, Subject, Status, Type, CreatedDate, LastModifiedDate
FROM Case
WHERE Account.Name LIKE '%[merchant name]%'
  AND CreatedDate = LAST_N_DAYS:365
ORDER BY CreatedDate DESC
LIMIT 10
```

**4d — Key Contacts:**
```sql
SELECT Id, Name, Title, Email, Phone
FROM Contact
WHERE Account.Name LIKE '%[merchant name]%'
  AND (Title LIKE '%VP%' OR Title LIKE '%Director%' OR Title LIKE '%Head%'
       OR Title LIKE '%Chief%' OR Title LIKE '%Manager%' OR Title LIKE '%Commerce%'
       OR Title LIKE '%Digital%' OR Title LIKE '%eCommerce%')
LIMIT 10
```

If Salesforce queries return 0 results (access restrictions), note "Salesforce data not available" and proceed.

### Step 5: Conversation History & Merchant Signals

Pull prior interactions and merchant intelligence from available sources. Run these in parallel:

**5a — Slack Mentions:**
Use `playground-slack-mcp get_messages` with action `search` to find recent mentions of the merchant name. Search for the merchant name across all channels. Surface the 5 most recent relevant messages — note who was discussing the account, what was said, and any action items or context.

**5b — Sales Conversation Pain Points:**
Use `scout search_sales_conversations` with `pain_point_keywords` matching the merchant's industry or known products. Filter by the account if possible. Surface any merchant-specific pain points from sales calls.

**5c — Support Ticket Patterns:**
Use `scout search_support_tickets` with the merchant name or shop ID if available. Look for recurring issues, frustrations, or patterns that could inform discovery questions.

**5d — Merchant Frustrations (Industry-Level):**
Use `scout search_merchant_frustrations` filtered by the merchant's industry or relevant component. This provides broader industry pain points to contextualize the merchant's likely challenges.

If any of these return no results, proceed without that data — note it as "No data found" in the relevant section.

### Step 6: Generate the Discovery Brief

Format the output exactly as follows:

---

# Discovery Brief: [Merchant Name]

## TL;DR

| Field | Detail |
|-------|--------|
| **Company** | [Name] |
| **Industry** | [Industry] |
| **Employees** | [Count] |
| **Est. Revenue** | [Annual revenue, formatted] |
| **GMV (L365D)** | [GMV, formatted] |
| **Region** | [Region / Territory] |
| **Current Products** | [List of adopted Shopify products] |
| **Eligible Products** | [Products they could adopt but haven't] |
| **Retail Locations** | [Count or "None detected"] |
| **Open Opportunities** | [Count and summary — e.g., "2 open: Plus renewal ($50K, closing Apr), B2B expansion ($120K, closing Jun)"] |
| **Key Opportunity** | [1-sentence summary of the biggest expansion opportunity] |

### Top 3 Discovery Priorities
1. **[Priority]** - [One-line reason and suggested question]
2. **[Priority]** - [One-line reason and suggested question]
3. **[Priority]** - [One-line reason and suggested question]

### If You Only Ask One Question...

> **[Single most impactful discovery question]**

This should be the one question that, if the AE is short on time, will unlock the most valuable insight about this merchant's needs. Tailor it specifically to the merchant's profile, industry, product gaps, and likely pain points. Include a brief note (1-2 sentences) on why this question matters and what signals to listen for in the answer.

---

## Detailed Brief

### Company Overview
- Business summary from enrichment data
- Industry positioning and competitive landscape
- Digital maturity assessment (website quality, social presence, tech stack indicators)
- Physical presence (locations, retail footprint)

### Relationship History
Summarize the existing relationship based on Salesforce and Slack data:
- **Open Opportunities**: List each with stage, amount, product line, owner, and close date
- **Recent Closed Deals**: Won/lost in last 12 months — what products, what amounts
- **Active Cases**: Any open launch cases, support cases, or escalations
- **Key Contacts**: Decision-makers and their titles from Salesforce
- **Internal Chatter**: Summary of recent Slack conversations about this merchant — who's been involved, what's been discussed, any flags or context
- If no prior relationship exists, note "No prior Salesforce or Slack history found — appears to be a new prospect"

### Current Shopify Footprint
- Active products and plan details
- GMV trends and revenue metrics
- Shop-level details (country, plan, status)
- What's working well (products they've adopted)

### Whitespace & Expansion Opportunities
For each eligible product they haven't adopted:
- **[Product Name]**: Why it's relevant based on their profile, industry, and current setup
- Estimate potential impact where possible

### Pain Point Hypotheses
Based on the account profile, industry, product gaps, support tickets, sales conversations, and merchant frustrations, generate 3-5 hypotheses about challenges they likely face:
1. **[Hypothesis]** - Evidence from data + suggested discovery angle
2. **[Hypothesis]** - Evidence from data + suggested discovery angle
(etc.)

Flag any pain points that came directly from Scout data (support tickets, sales conversations, or merchant frustrations) with a "[Scout]" tag so the AE knows these are evidence-based, not inferred.

### Recommended Discovery Questions

#### Opening / Relationship Building
- 2-3 questions to understand their current priorities and challenges
- If there's prior relationship history, reference it: "Last time we spoke, [context] — how has that progressed?"

#### Business Model & Operations
- 3-4 questions tailored to their industry and business model

#### Technology & Platform
- 3-4 questions about their current tech stack, pain points, and integration needs

#### Growth & Expansion
- 3-4 questions about their growth plans and how Shopify can support them

#### Product-Specific (based on eligible products)
- 2-3 questions per eligible product that naturally surface the need

### Competitive Context
- Based on industry and profile, note likely competitors or alternative platforms they may be evaluating
- Key Shopify differentiators relevant to this merchant's profile

### Suggested Next Steps
- Recommended actions before the discovery call
- Key stakeholders to identify (use Salesforce contacts if available)
- Follow-up items to prepare
- If there are open opportunities, note alignment with discovery goals

---

### Step 7: Google Doc Export

After generating the brief, ask: **"Export to Google Doc? (yes/no)"**

If yes, use `gworkspace-mcp create_file` to create a new Google Doc titled "Discovery Brief: [Merchant Name] — [Today's Date]". Then use `gworkspace-mcp batch_workspace_operations` with the `docs` service to insert the full brief content into the document. Format the doc with:
- Title as Heading 1
- Section headers as Heading 2/3
- The TL;DR table as a proper table
- The "If You Only Ask One Question" block styled with bold/italic emphasis
- Share the Google Doc link with the user

---

## Guidelines

- Format all currency values with $ and appropriate abbreviations ($1.2M, $500K)
- Format large numbers with commas
- If any data is unavailable, note it as "Not available" rather than guessing
- Tailor all questions and hypotheses to the specific merchant - avoid generic questions
- Prioritize actionable insights over raw data dumps
- If the account has B2B indicators (eligible for B2B, has company data), include B2B-specific discovery angles
- Keep the TL;DR genuinely brief - it should be scannable in 30 seconds
- When Salesforce or Slack data reveals prior conversations, weave that context into the discovery questions — don't ask things the team already knows
- Scout data (support tickets, sales conversations, frustrations) should inform pain point hypotheses and make questions more specific
