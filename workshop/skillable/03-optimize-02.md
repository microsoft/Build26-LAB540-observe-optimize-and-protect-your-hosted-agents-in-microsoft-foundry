# Sign in to Azure

The optimize loop talks to your Foundry project from code, so sign in with both
the Azure CLI (`az`) and the Azure Developer CLI (`azd`). You'll use **device
code** sign-in to keep things simple inside the Codespace.

## Sign in with `az`

1. [] In the terminal, run:

   ++az login --use-device-code++

1. [] Open the verification URL, enter the code shown, and sign in with your lab
   credentials:

   **Username:** +++@lab.CloudPortalCredential(User1).Username+++
   **Password (TAP):** +++@lab.CloudPortalCredential(User1).AccessToken+++

1. [] When prompted, select the default subscription.

## Sign in with `azd`

1. [] In the terminal, run:

   ++azd auth login --use-device-code++

1. [] Complete the same device-code sign-in flow.

<!-- TODO screenshot: device code sign-in prompt -->

---

> ✅ **Success:** you're signed in to Azure with both `az` and `azd`.
