# Watch Baseline

Watch the Observe skill work. This is **code-first optimization** — the same
loop you saw in the portal, now driven from your editor.

As it runs, you'll see Copilot:

1. [] Create a **.foundry** folder with the generated evaluators and test
   dataset.

>[!Hint] Once the **.foundry** folder appears, open **zava/src/zava-travel-concierge/.foundry/agent-metadata.yaml**
> in the editor. Leave it open — it updates as the loop runs and gives you a
> live view of the observe loop's progress.
1. [] Run a **baseline evaluation** of your deployed agent against that dataset.
1. [] Produce a set of **recommendations** based on the failures it found.

It creates a plan of action and starts executing tasks to establish the baseline
evaluation results, as shown below.

![Copilot Chat creating tasks and running the baseline evaluation](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-06-init-tasks.png)

>[!Alert] **Let it finish.** The baseline run and analysis take a few minutes.
> Watch the updates stream in and **wait until the recommendations appear**
> before moving on.

---

> ✅ **Success:** you just saw **code-first optimization** — a baseline
> evaluation and recommendations generated from your own editor.
