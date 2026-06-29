# Prerequisites

Before you provision anything, confirm you have what you need.

<!-- TODO screenshot: Foundry model quota / region availability for gpt-5.4-mini -->

1. Confirm you have an **Azure subscription** where you can create resources.
2. Confirm your subscription has access to **Microsoft Foundry** models with
   **`gpt-5.4-mini`** Global Standard quota in one of the supported regions:
   - **`eastus2`** (default ⭐)
   - **`swedencentral`** (EU alternate)
   - **`northcentralus`** (US backup)
3. Confirm you have a **personal GitHub account** with support for **GitHub
   Codespaces** and **GitHub Copilot**, which you'll use to fork a repo and run a
   Codespace.

> [!NOTE]
> You don't need anything installed locally — you'll do all the work inside a
> **GitHub Codespace**, which already has `az`, `azd`, `python`, and Docker.

> [!TIP]
> We recommend a **GitHub Copilot Pro** subscription so you can pick a stronger
> model (like the **Claude** series) in the optimize stage — these tend to
> produce noticeably better results when running the eval → fix → redeploy loop.

> [!IMPORTANT]
> Provisioning runs in **your** subscription and incurs cost. You'll tear it all
> down with `azd down` at the end.

---

> ✅ **Success:** you met all the pre-requisites.

---

[← Prev: Get Started](./00-intro.md) &nbsp;•&nbsp; 🏠 [Contents](./README.md) &nbsp;•&nbsp; [Next: Fork the Repo →](./01-setup-02.md)
