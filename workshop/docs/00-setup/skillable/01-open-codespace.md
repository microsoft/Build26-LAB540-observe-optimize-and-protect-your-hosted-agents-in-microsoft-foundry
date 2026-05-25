## Open your Codespace

In this step you'll open the GitHub Codespace where you'll do the rest of
the workshop.

### 1. Sign in to GitHub from the VM

Open a browser inside the lab VM and go to:

<[GitHub SSO sign-in](https://github.com/enterprises/skillable-events/sso)

Sign in using the GitHub credentials shown in the **Resources** tab of
this lab. Keep this tab open — VS Code will use this session to
authenticate you in the Codespace.

- [] I'm signed in to GitHub on the SSO page.

### 2. Open the Codespace

Open the workshop repo and create / resume a Codespace:

<[Open the LAB540 repo](https://github.com/microsoft/Build26-LAB540)

Click the green **Code** button → **Codespaces** tab → **Create
codespace on `main`** (or **Open** an existing one if you see one
listed).

> [!Knowledge] First-load timing
> The first time a Codespace launches it can take 60–90 seconds to
> build the dev container. The container pre-installs `az`, `azd`,
> Docker, Python, and the Foundry tooling so you don't have to.

- [] My Codespace is open and the VS Code UI has loaded in the browser.

### 3. Open the integrated terminal

Inside the Codespace, open a terminal:

> [!Hint] Keyboard shortcut
> Press **Ctrl+`** (backtick) — or use the menu: **Terminal → New
> Terminal**.

### 4. Confirm Azure login

Skillable pre-configures Azure CLI with your lab subscription. Run:

++az account show --query '{name:name, id:id}' -o table++

You should see the lab subscription printed in a table. If not, run:

++az login --use-device-code++

…and use the device-code flow with the credentials in the **Resources**
tab.

- [] `az account show` returns the Skillable subscription.

> [!Alert] Stop here if Azure login isn't working
> The rest of the workshop assumes you're authenticated. If `az login`
> failed, ping the proctor before continuing.

===

