# Self-Guided Step 1 — Install Prerequisites & Open Workspace

You have two options:

- **Option A (recommended)**: Use a GitHub Codespace — all tools
  pre-installed.
- **Option B**: Install everything locally.

## Option A — Open in Codespaces

1. Visit the workshop repo:
   <https://github.com/microsoft/Build26-LAB540>
2. Click **Code → Codespaces → Create codespace on `main`**.
3. Wait for the dev container to build (~1–2 minutes).
4. Open the integrated terminal: <kbd>Ctrl</kbd>+<kbd>`</kbd>.

Skip ahead to [Step 2 — Sign in to Azure](./2-azure-login.md).

## Option B — Install Locally

Install these on your machine:

| Tool | Install |
|------|---------|
| Git | [Install](https://git-scm.com/downloads) |
| Azure CLI (`az`) | [Install](https://learn.microsoft.com/cli/azure/install-azure-cli) |
| Azure Developer CLI (`azd`) ≥ 1.25 | [Install](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) |
| Docker Desktop | [Install](https://docs.docker.com/get-docker/) |
| Python 3.10+ | [Install](https://python.org) |
| VS Code | [Install](https://code.visualstudio.com/) |
| GitHub Copilot extension | Install from VS Code Extensions panel |

Then clone the repo:

```bash
git clone https://github.com/microsoft/Build26-LAB540.git
cd Build26-LAB540
```

Open the folder in VS Code:

```bash
code .
```

Open the integrated terminal in VS Code: <kbd>Ctrl</kbd>+<kbd>`</kbd>.

## ✅ Checkpoint

Confirm in the terminal:

```bash
az version
azd version
docker info
python --version
```

All four should print a version (Docker should print engine info without
errors).

---

**Next**: [Step 2 — Sign in to Azure →](./2-azure-login.md)
