# MORE: Continuous Evaluation & Monitoring

## Objective

Set up continuous evaluation for your hosted agent so you catch quality regressions before users do.

## What You'll Learn

- Difference between batch evaluation and continuous evaluation
- How to configure continuous eval with automatic triggers
- How to read eval trending dashboards
- How to set up alerts for quality regressions

---

## Step 1: Batch vs. Continuous Evaluation

| Aspect | Batch Evaluation | Continuous Evaluation |
|--------|-----------------|----------------------|
| When | On-demand (you trigger it) | Automatic (runs on schedule or trigger) |
| Scope | Full dataset pass | Sample of production traffic |
| Use case | Pre-deployment validation | Post-deployment monitoring |
| Latency | Minutes (full run) | Near real-time |

In Labs 2-3, you used batch evaluation. Now let's set up continuous monitoring.

## Step 2: Activate Continuous Evaluation

> "Set up continuous evaluation for my Zava Travel Concierge agent"

This configures:
- Automatic sampling of production conversations
- Periodic evaluation runs against sampled traffic
- Score tracking over time
- Anomaly detection for quality drops

## Step 3: Generate Traffic for Monitoring

To see continuous eval in action, generate some agent traffic:

```bash
# Run the load test script to simulate conversations
python scripts/load-test.py --conversations 20 --delay 5
```

This sends 20 diverse travel queries to your agent, simulating real usage.

## Step 4: View Evaluation Trending

After traffic flows through, check the continuous eval dashboard:

> "Show me the continuous evaluation status and trending"

You should see:
- Score trends over time
- Distribution of scores across metrics
- Any flagged conversations (low scores)

## Step 5: Understand Alerts and Thresholds

Configure alert thresholds for important metrics:

> "Set up an alert if my agent's groundedness score drops below 3.5"

This ensures you're notified when quality regresses — whether due to:
- Data source changes
- Infrastructure issues
- Prompt drift
- New edge cases in user queries

## Step 6: Respond to a Quality Alert

If continuous eval detects an issue:
1. **Identify** — Which metric dropped? On what types of queries?
2. **Trace** — Use the tracing lab skills to investigate specific failures
3. **Fix** — Apply the optimization (prompt change, data update, etc.)
4. **Verify** — Batch eval confirms the fix, continuous eval confirms stability

---

## ✅ Checkpoint

- [ ] Understand the difference between batch and continuous evaluation
- [ ] Continuous evaluation is activated for your agent
- [ ] Generated traffic and saw evaluation trending data
- [ ] Understand how to configure alerts and respond to regressions

## Scoreboard Update

Continuous eval gives you ongoing scores. Note the trend direction alongside your point-in-time scores.

**Back to**: [MORE Labs](./README.md)
