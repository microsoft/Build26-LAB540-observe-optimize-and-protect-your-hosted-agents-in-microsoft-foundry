# Step 3 — Provision with `azd up`

`azd up` reads the Bicep templates in `zava/infra/` and the agent manifest
in `zava/src/zava-travel-concierge/agent.manifest.yaml`. In one command it:

1. Creates a Microsoft Foundry project, model deployment, ACR, App Insights
   and supporting resources.
2. Builds and pushes the Zava Travel Concierge container image to ACR.
3. Registers and starts the hosted agent in Foundry.

## 3.1 — Choose a region

This workshop is region-restricted to three Foundry **Hosted Agents**
preview regions, all of which have `gpt-4.1-mini` GlobalStandard quota:

| Region | Best for | Notes |
|--------|----------|-------|
| `eastus2` *(default)* | US — broad tool support | Default; widest hosted-agent tool surface |
| `swedencentral` | Europe — data residency | Full hosted-agent feature parity |
| `northcentralus` | US — backup capacity | Use if `eastus2` quota is tight |

> 📚 See [`zava/README.md`](../../../../zava/README.md) §4.4 for the source
> Microsoft Learn references.

## 3.2 — Initialize the azd environment

From the repo root:

```bash
cd zava
azd env new build26-lab540  
```

This sets the default local environment for azd. You should see a `zava/.azure/` folder created with that environment as a subfolder, containing a `.env` file.


## 3.3 — Provision + deploy

Still inside `zava/`:

```bash
azd up
```

You'll be asked for:

- Azure subscription → pick yours
- Region → press Enter to accept `eastus2`, or type one of the three
  supported regions above

This takes ~5–8 minutes. You'll see Bicep provisioning, then a Docker
build + push, then the agent registration. On success you should see a message like this (the numbers will be different)

```bash
SUCCESS: Your application was provisioned and deployed to Azure in 7 minutes 37 seconds.
  Provisioning: 4 minutes 28 seconds
  Deploying:    3 minutes 30 seconds
```

## 3.4 — Confirm the agent is running

The console above should also show you some guidance here:

```bash
Service         Status        Duration
  ──────────────  ────────────  ──────────
  ● zava-concierge  Done          3m22s
  - Agent playground (portal): **portal link here**
  - Agent endpoint (responses): **endpoint URL here** 

 Next:  
  azd ai agent show zava-concierge -- verify it's running
  see src/zava-travel-concierge/README.md -- find the sample-specific payload
  azd ai agent invoke zava-concierge '<payload>' -- test with sample-specific payload
```

You can now verify the environment variables available in your azd `.env`:

```bash
azd env get-values
```

Then test the deployed agent with a sample payload:

```bash
azd ai agent invoke zava-concierge "what can you do"
```

You should see something like this. 

```bash
Agent:        zava-concierge (remote)
Message:      "what can you do"
Session:      (new — server will assign)
Conversation: conv_bd6b2f43e05a8f3b00Qfz8iyAFGnL1ScwCUR9UkxU4tZkzhisc

Trace ID:     434c2dcbb3065bd4042a24b7c665a9f8
Session:      488fbaae633efe22fcf50b1db9347efccf4b4d97ddba44875e20076f3b3982e (assigned by server)
[zava-concierge] I can help you find and book flights, hotels, and car rentals across Paris, London, Tokyo, Rome, and Cancún. You can ask me to recommend travel options based on your preferences like dates, budget, star rating for hotels, cabin class for flights, or vehicle type for rentals. Just tell me where and when you want to travel, and what you're looking for, and I'll take care of the rest!
```

Want to understand what the _Conversation_, _Trace_ and _Session_ identfifers are? We'll explore this when we test out the hosted agent in the portal later.

**You are now ready to move onto the next lab!**


## ✅ Checkpoint

- [ ] `azd up` completed without errors
- [ ] `zava-concierge` was deployed to Foundry 
- [ ] `zava-concierge` responded to a test query

---

**Next**: [Shared Step 1 — Populate `.env` →](../shared/1-discover-env.md)
