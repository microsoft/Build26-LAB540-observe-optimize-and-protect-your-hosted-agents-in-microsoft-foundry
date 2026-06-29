# Sign in to Azure

The optimize loop talks to your Foundry project from code, so sign in with both
the Azure CLI (**az**) and the Azure Developer CLI (**azd**). You'll use **device
code** sign-in to keep things simple inside the Codespace.

## Sign in with **az**

1. [] In the terminal, run:

   +++az login --use-device-code+++

1. [] Open the verification URL, enter the code shown, and sign in with your lab
   credentials:

   **Username:** +++@lab.CloudPortalCredential(User1).Username+++
   **Password (TAP):** +++@lab.CloudPortalCredential(User1).AccessToken+++

1. [] When prompted, select the default subscription.

## Sign in with **azd**

1. [] In the terminal, run:

   +++azd auth login --use-device-code+++

1. [] Complete the same device-code sign-in flow.

<!-- TODO screenshot: device code sign-in prompt -->

## Setup **.env** in Codespaces

Run the script to automatically have your **.env** created from the deployed infrastructure.

1. [] Type this command in the terminal to execute it:  +++bash scripts/discover-env.sh+++
1. [] You will be prompted for the name of the resource group to use. Enter the resource group name you see in the Azure portal tab. It should start with **rg-lab540-**.
1. Wait till the script is complete. Verify that a **.env** was setup with all required parameters filled in.

>[!Knowledge] This *.env* will be used by GitHub Copilot in a subsequent step to establish our *.azure* configuration for the Azure Developer CLI tooling.

---

> ✅ **Success:** you're signed in to Azure with both **az** and **azd**.
