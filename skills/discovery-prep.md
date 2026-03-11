Generate a discovery brief and meeting prep doc for: $ARGUMENTS

## Instructions

Build a comprehensive discovery brief for the specified merchant or account. The output should have a quick TL;DR at the top for fast reference, followed by a detailed brief below.

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

### Step 4: Generate the Discovery Brief

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
Based on the account profile, industry, and product gaps, generate 3-5 hypotheses about challenges they likely face:
1. **[Hypothesis]** - Evidence from data + suggested discovery angle
2. **[Hypothesis]** - Evidence from data + suggested discovery angle
(etc.)

### Recommended Discovery Questions

#### Opening / Relationship Building
- 2-3 questions to understand their current priorities and challenges

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
- Key stakeholders to identify
- Follow-up items to prepare

---

### Step 5: Google Doc Export

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
