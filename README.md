# Claude Code Skills

Reusable Claude Code skill files for Shopify SEs and AEs. Drop a `.md` file into your `.claude/commands/` folder and run it as a slash command.

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| **Discovery Prep** | `/discovery-prep [merchant]` | Generates a full discovery brief with TL;DR, recommended question, pain point hypotheses, tailored discovery questions, competitive context, and optional Google Doc export. |

## Quick Install

```bash
# Clone the repo
git clone git@github.com:mjwshop/claude-code-skills.git

# Install all skills to your Claude Code environment
./install.sh
```

Or install a single skill manually:

```bash
cp skills/discovery-prep.md ~/.claude/commands/discovery-prep.md
```

## Prerequisites

Each skill lists its MCP server dependencies. Make sure you have the required servers configured:

| MCP Server | Used By |
|------------|---------|
| `revenue-mcp` | Discovery Prep (account data, shop data, company enrichment) |
| `gworkspace-mcp` | Discovery Prep (optional Google Doc export) |

## Usage

After installing, run the skill in Claude Code:

```
/discovery-prep Centric Brands
```

The skill will:
1. Resolve the account in Copilot/Salesforce
2. Pull shop-level data
3. Run company enrichment
4. Generate a comprehensive discovery brief
5. Offer to export to Google Docs

## Contributing

Have a skill to share? Add a `.md` file to the `skills/` folder and open a PR.

## File Structure

```
claude-code-skills/
├── README.md
├── install.sh          # Installs all skills to .claude/commands/
└── skills/
    └── discovery-prep.md
```
