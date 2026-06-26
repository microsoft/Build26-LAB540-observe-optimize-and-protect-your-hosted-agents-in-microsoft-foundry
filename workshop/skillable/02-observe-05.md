# Run Prompt 3

Finally, send an **out-of-scope** request and watch the agent's instructions
keep it on task.

1. [] In the playground, send this prompt:

   ++Can you help me write a Python script?++

1. [] Note that the concierge **politely declines** and redirects to travel
   topics instead of answering.

<!-- TODO screenshot: prompt 3 refusal / redirect -->

>[!Knowledge] The concierge's **agent instructions** define its scope. Because
> the instructions tell it to handle travel only, it refuses unrelated requests
> — exactly the behavior you'll measure and protect with evaluations.

---

> ✅ **Success:** the agent correctly refused an out-of-scope request.
>
> 🏁 **Stage 2 complete.** You've validated that the infrastructure and hosted
> agent work, and you understand Foundry's built-in observability — metrics,
> traces, evaluations, and replays. Next, you'll improve the agent from code.
