# Optimize & Redeploy

Watch Copilot apply the fix and push a new version of your agent — the loop
closing itself.

As it runs, you'll see Copilot:

1. Update the agent's **instructions** with the optimized version.
2. **Redeploy** the hosted agent (rebuild + push, then publish a new revision).
3. Optionally **re-evaluate** against the same dataset to compare before and
   after.

<!-- TODO screenshot: redeploy + comparison output in chat -->

> [!NOTE]
> Improvement isn't guaranteed on every pass — a regression is **data**, telling
> you which axis you traded off. The value is the feedback signal that makes your
> next change more informed.

---

> ✅ **Success:** you saw continuous optimization — the agent was fixed and redeployed.
>
> 🏁 **Stage 3 complete.** You ran one full **eval → fix → redeploy** loop with
> Foundry Skills. You've now observed, evaluated, and optimized your hosted agent
> end to end. 🎉

## Clean up

When you're done, tear down everything `azd up` created so you don't keep paying
for it:

```bash
cd zava
azd down --purge --force
```

---

[← Prev: Pick Top Fix](./03-optimize-07.md) &nbsp;•&nbsp; 🏠 [Contents](./README.md)
