# Confirm Azure Sign-in

The optimize loop talks to your Foundry project from code, so make sure both the
Azure CLI (`az`) and the Azure Developer CLI (`azd`) are still authenticated.

> [!NOTE]
> You already signed in during setup. If your Codespace session is still active,
> these checks will pass and you can move on. If your session expired, re-run the
> sign-in commands below.

## Verify `az`

1. In the terminal, run:

   ```bash
   az account show
   ```

   If this fails, sign in again:

   ```bash
   az login --use-device-code
   ```

## Verify `azd`

1. In the terminal, run:

   ```bash
   azd auth login --check-status
   ```

   If this reports you're not logged in, run:

   ```bash
   azd auth login --use-device-code
   ```

---

> ✅ **Success:** both `az` and `azd` are authenticated to your subscription.

---

[← Prev: Return to Codespace](./03-optimize-01.md) &nbsp;•&nbsp; 🏠 [Contents](./README.md) &nbsp;•&nbsp; [Next: Activate Copilot →](./03-optimize-03.md)
