# Tab 1 — Azure Portal

Your first tab is the **Azure Portal**, where your pre-provisioned resource group lives.

1. [] Click in the **address bar** of new tab to give it focus, then navigate to +++https://portal.azure.com+++
1. [] Sign in with the lab credentials below:

   - **Username:** +++@lab.CloudPortalCredential(User1).Username+++
   - **Password (TAP):** +++@lab.CloudPortalCredential(User1).AccessToken+++

1. [] If prompted to save the password, **dismiss** it.
1. [] If prompted to stay signed in, check **Don't show this again** and select
   **Yes**.

   ![Azure portal home](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/skillable/images/01-setup-02-azure-portal-home.png)

1. [] Select **Resource groups** in the portal to view the list of resource
   groups.
1. [] Confirm you see **two** resource groups, one of which starts with
   **rg-lab540**.

<br/>

>[!Alert] If you do **not** see a resource group starting with **rg-lab540**,
> raise your hand and ask a proctor for help. This is likely a cold-start
> problem where provisioning hasn't finished yet.

>[!Knowledge] Everything in your resource group — the Foundry project, model
> deployment, container registry, and Application Insights — was pre-provisioned
> for you by the Skillable environment.

>[!Hint] Prefer dark mode? Click the **gear** icon in the portal toolbar, open
> **Appearance**, and switch the theme to **dark**. Click the **gear** icon
> again to return to the default portal page.

---

> ✅ **Success:** the Azure Portal home page is open in **Tab 1**.
