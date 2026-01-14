
# Infrastructure Deployment (Bicep + .bicepparam)

This folder contains CI/CD artifacts to deploy `infra/core/main.bicep` with environment-specific `.bicepparam` files to multiple subscriptions (Dev → Prod).

## Prerequisites
- Azure CLI `>= 2.53` (supports `.bicepparam`)
- Azure DevOps Service Connection `SC-Azure-DevOps` with Contributor on target subs
- Param files:
  - `infra/params/dev.bicepparam`
  - `infra/params/prod.bicepparam`

## Local Use
### Validate (what-if)
```powershell
pwsh ./deploy/whatif.ps1 `
  -SubscriptionId 383cf7d8-46ce-433f-9b54-ceac47c81c34 `
  -ResourceGroupName rg-ai-core `
  -ParamFile ./infra/params/dev.bicepparam
