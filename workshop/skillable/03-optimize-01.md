# Open Codespace

Your Codespace should be ready now. Switch to its tab (Tab 3) and confirm the
tools you'll need are installed.

1. [] Switch to the **Codespace** tab. Wait until VS Code has fully loaded.
1. [] Open a terminal (**Terminal → New Terminal**).
1. [] Confirm the core CLIs are present:

   ++az version++

   ++azd version++

   ++python --version++

<!-- TODO screenshot: VS Code Codespace with terminal open -->

>[!Alert] **Remove any stale Foundry state.** If a `.foundry` folder already
> exists under `zava/src/zava-travel-concierge/`, delete it so the Observe skill
> starts clean:
>
> ++rm -rf zava/src/zava-travel-concierge/.foundry++

---

> ✅ **Success:** your Codespace is open and `az`, `azd`, and `python` are all
> available, with no stale `.foundry` folder.
