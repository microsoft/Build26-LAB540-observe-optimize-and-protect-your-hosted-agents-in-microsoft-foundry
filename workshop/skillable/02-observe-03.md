# Run Prompt 1

Send a simple, single-specialist request and watch the metrics light up.

1. [] In the playground, type this prompt as input:

   +++What flights are available from Chicago to Rome?+++

1. [] Wait for the concierge to reply with flight options (this takes a few  seconds). 
1. [] Note the default response, the **log stream** of agent actions, the
   auto-evaluated **quality & safety metrics**, and the link to **traces** for this request.

   ![The prompt 1 flight response with evaluator metrics in the playground](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-03-prompt1.png)

## View Evaluation Metrics

1. [] Hover over the **metrics** panel shown in green. You should see the evaluation score components behind it.
1. [] Click on one of the metrics in the green box. It should open up a trace view as shown below. Note how the trace visualizes the sequence of actions within the flow along with token costs and latency per response.
1. [] Note the **evaluations attached to the trace** — the actual scores for the selected quality metrics plus latency, token costs, and the events that produced this response. This lets you correlate metrics with the actions taken, for more effective debugging when needed.

   ![The trace view with quality evaluations attached for the prompt 1 turn](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-03-trace.png)

>[!Knowledge] **Evaluators** are automatic graders that score each response live
> on quality and safety — no test code required. A **trace** is the step-by-step
> record of how the agent produced its answer, including the call it made to the
> **Flight Specialist**. The evaluator scores hang right off the trace, so
> quality and execution live in one place.

## View Monitoring Metrics

1. [] Close the trace window, then click the **Monitor** tab in the playground
   navigation. This is the production monitoring view for your deployed agent —
   a single pane of glass showing how many times it was called, tokens consumed,
   tools invoked, and failures across its lifetime.

   ![The Monitor tab showing aggregated agent metrics and evaluations](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-03-monitor.png)

1. [] Click the **agent helper** icon within any chart to get an AI-generated
   analysis of that metric, surfacing insights into agent performance.

   ![The Runs and token metrics chart with an AI-generated analysis of agent runs and token usage](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/02-observe-03-monitor-analyze.png)

>[!Knowledge] The **Monitor** tab is your single pane of glass in production. It
> aggregates calls, token usage, tool invocations, and failures across the
> agent's lifetime, with AI-generated analysis to surface insights.

---

> ✅ **Success:** you've seen a response scored live, opened its trace with
> evaluations, and explored production monitoring.
