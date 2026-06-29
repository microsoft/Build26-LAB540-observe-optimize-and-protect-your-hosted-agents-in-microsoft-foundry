# Open Codespace

Your Codespace should be ready now. Switch to its tab (Tab 3) and let's move to code-first observabilty.

1. [] Switch to the **Codespace** tab. Wait until VS Code has fully loaded.

1. [] Open a terminal (**Terminal → New Terminal**).
1. [] Confirm the core CLIs are present:

   +++az version+++

   +++azd version+++

   +++python --version+++


## Reset to the clean baseline

Clear any stale **.foundry** state and restore the baseline concierge prompt. This ensures every run starts from the same intentionally under-optimized prompt as everyone else:

1. [] Type this command in the terminal to execute it:  +++rm -rf zava/src/zava-travel-concierge/.foundry+++
1. [] Type this command to run script: +++bash zava/src/zava-travel-concierge/scripts/reset-instructions.sh+++

## What **main.py** does

1. [] Open the agent's source file **zava/src/zava-travel-concierge/main.py** and skim it. This is the agent you've been observing — and the code the optimize loop will change.
1. [] Read the description below to understand the components that make up our **zava-concierge** hosted agent.

**main.py** defines the whole **multi-agent system** with the **Microsoft Agent
Framework (MAF)** — Microsoft's open-source SDK for building agents in Python or
C#, where agents, tools, and orchestration are all defined in code.

| Component | What it is |
|:----------|:-----------|
| **Specialist agents** | **flight_agent**, **hotel_agent**, and **car_rental_agent** — each with its own instructions and a single typed Python **tool** (**search_flights**, **search_hotels**, **search_car_rentals**) that queries one CSV catalog. |
| **Concierge agent** | **zava-concierge** exposes the three specialists **as tools** and orchestrates them — delegating in parallel and merging the results into a single itinerary. |
| **Concierge instructions** | The concierge's system prompt, loaded from **instructions/concierge.md**. **This is the file the optimize loop will edit** to improve quality. |
| **ResponsesHostServer** | Wraps the concierge so it runs as a Foundry **hosted agent** behind the Responses protocol. |

---

> ✅ **Success:** your Codespace is open, **az**, **azd**, and **python** are all
> available, you've reviewed the agent code, there's no stale **.foundry**
> folder, and the concierge prompt is reset to the baseline.
