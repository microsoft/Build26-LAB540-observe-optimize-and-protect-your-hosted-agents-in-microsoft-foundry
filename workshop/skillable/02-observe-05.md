# Run Prompt 3

Finally, send an **out-of-scope** request and watch the agent's instructions
keep it on task.

1. [] In the playground, send this prompt and read the concierge's description
   of its role as a travel concierge:

   ++what can you do?++

1. [] Now send an out-of-scope prompt and watch the agent keep on task:

   ++Can you help me write a Python script?++

1. [] Confirm the concierge **politely declines** and redirects to travel
   topics instead of answering. If it doesn't, that's another area for agent
   optimization.

![The concierge politely declining the out-of-scope request and redirecting to travel topics](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-05-prompt3.png)

>[!Knowledge] The concierge's **agent instructions** define its scope. Because
> the instructions tell it to handle travel only, it refuses unrelated requests
> — exactly the behavior you'll measure and protect with evaluations.

>[!Knowledge] These initial checks across prompts 1–3 give a baseline read on
> where the agent can be **optimized** — across **cost**, **latency**, and
> **quality**. The gaps they surface are the issues you'll fix iteratively in
> the next stage.

---

> ✅ **Success:** the agent correctly refused an out-of-scope request.
>
> 🏁 **Stage 2 complete.** You've validated that the infrastructure and hosted
> agent work, and you understand Foundry's built-in observability — metrics,
> traces, evaluations, and replays. Next, you'll improve the agent from code.
