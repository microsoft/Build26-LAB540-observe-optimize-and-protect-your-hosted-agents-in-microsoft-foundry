# Run Prompt 2

Now send a multi-part request that makes the concierge coordinate all three
specialists.

1. [] In the playground, send this prompt:

   ++Plan a trip from Chicago to Rome for the first two weeks of November. I need flights, a hotel, and a car rental.++

1. [] Wait for the concierge to compose the full itinerary — the response now
   includes flight, hotel, and car results, so all three specialists were called
   before composing the final answer.

![The prompt 2 itinerary response combining flights, hotel, and car rental](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-04-prompt2.png)

1. [] Click the **Traces** button to open the **Trajectory** view, which
   visualizes this turn's trace as a **conversation** — the concierge delegating
   to the flight, hotel, and car-rental agents. Click **Play** to watch it
   unfold, and check the metrics (top-right) for chat calls, tool calls, tokens,
   time, and **spans**.

![The Trajectory view visualizing the conversation trace with the concierge delegating to the flight, hotel, and car-rental agents](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-04-trajectory.png)

1. [] Click the **User View** tab, then **Play**. This is a time-based replay of
   which requests went to each agent, when, and how the final response was
   composed — giving you an intuitive sense of per-agent latency. Each agent's
   requests and responses stream in parallel before being merged into one reply.

![The User View tab showing a time-based replay of requests to each agent](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-04-user-view.png)

>[!Knowledge] **Trajectory vs. User View** are two complementary lenses on the
> same trace. The **Trajectory view** exposes the agent's internal orchestration
> — how the concierge decomposed and delegated — so you can pinpoint *which*
> agent or tool call went wrong. The **User View** replays the interaction on a
> timeline, showing *when* each request fired, so you can spot the step
> responsible for latency. Together they let you debug correctness and diagnose
> performance from a single captured trace — no re-running required.

---

> ✅ **Success:** you've inspected a multi-agent conversation trace through both
> the Trajectory and User View lenses.
