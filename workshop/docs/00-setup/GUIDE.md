# Workshop Guide
 
## 1. Status Check

You probably came to this document from the repository README. Pick the path that suits you to do a quick status check:

### 1.1 Skillable Learner (In-Venue)

You have been provided with a Skillable account with an active GitHub Enterprise subscription and an Azure subscription. By now, you have kicked off the session and completed these tasks from the VM-based instructions. If you have not done so, please take a minute to complete them.

- [X] You launched the Skillable VM and logged in
- [X] You verified you had Azure credentials (username, password)
- [X] You opened a private browser and have 3 tabs open
- [X] (Tab 1) You are logged in to [https://portal.azure.com](ttps://portal.azure.com)
- [X] (Tab 3) You are logged in to [https://ai.azure.com](https://ai.azure.com)
- [X] (Tab 3) You are logged in to GitHub with the Skillable GHE
- [X] You visited [Lab 540](https://aka.ms/build26/lab540) and launched Codespaces on it.

### 1.2 Self-Guided Learner (At-Home)

You will need your own Azure Subscription and GitHub Copilot (pro) subscription to get the best from this lab. Your setup path is simpler. All you need to do is launch GitHub Codespaces and then continue from the next step.

1. Open a new private browser - and open 3 tabs in it.
1. (Tab 1) Navigate to [https://portal.azure.com](https://portal.azure.com) and log in.
1. (Tab 2) Navigate to [https://ai.azure.com](https://ai.azure.com) and log in.
4. (Tab 3) Naviagate to [Lab 540](https://github.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry) and fork it to your profile
5. Launch GitHub Codespaces from your fork.

<br/>

## 2. GitHub Codespaces + GitHub Copilot

You should now be in the GitHub Codespaces session and have the browser also open to tabs with Azure Portal and Foundry Portal displayed.

This workshop makes active use of GitHub Copilot, showcasing the use of Foundry Skills for running a continuous `observe-eval-optimize` loop for your Microsoft Foundry Hosted Agent. In this section, let's do a quick check to make sure you are setup with GitHub Copilot correctly.

### 2.1. Activate Session


1. Clck on the "chat" icon (top right of Codespaces, next to search bar)
1. You should see a Chat window slide out to the right.
1. Start a new session with a simple "Hello" in the chat (bottom right)

**This will activate GitHub Copilot**

1. It will activate MCP servers and extensions. You should see this prompt in chat:
    ```
    The MCP server Foundry MCP may have new tools and requires interaction to start. Start it now?
    ```
1. Say Yes. It will trigger a dialog that will prompt you to log in to Azure.
1. Confirm. You will complete the workflow to use the same Azure subscription.
1. _Your Copilot is now able to talk to the Foundry MCP server for our tasks_.

### 2.2 Select Model

**You need to pick a Model**

_You may see a popup with "The model Claude Haiku 4.5 hasn't been deployed yet. Would you like to deploy it?" - just dismiss it and click New Session to start a new chat_

1. We need a good model to help drive our skills-based workflow
1. In the chat area, hover over the third icon - it should say "Pick Model"
1. Click that and select the Claude Sonnet 2.6 model - it is ideal for this

### 2.3. Try It Out

**Let's Do A Quick Test**

Let's try a couple of quick prompts to get a sense for Copilot use.

1. See if it knows about Microsoft Foundry skills.

    ```bash
    What skills do you have for Microsoft Foundry?
    ```

    You should see:
    
    1. A comment like: "Reviewed microsoft-foundry skill documentation"
    1. A response like: _The microsoft-foundry skill covers the full lifecycle of Azure AI Foundry agents. Here's a summary of the available sub-skills:_ with more details. Exact text may differ.

1. See if it knows about skills to run this workshop.

    ```bash
    What workshop skills do you have?
    ```

    You should see:
    1. A comment like: "Reviewed .agents/skills"
    1. A response like:

        This repo has 7 workshop-specific skills under skills:

        | Skill | Trigger phrases |
        |---|---|
        | `run-workshop` | "run the workshop", "start the lab", "what's first" |
        | `setup-env` | "set up my environment", "configure Azure login", "create .env" |
        | `complete-lab` | "help me complete lab N", "walk me through lab" |
        | `explain-this` | "explain this", "what just happened", "why did that work" |
        | `help-me-debug` | "help me debug", "this isn't working", "I got an error" |
        | `what-next` | "what's next", "what should I do after this" |
        | `add-skillable-instructions` | "author a Skillable page", "bundle lab instructions" |

        Just ask using any of those phrases and I'll load the relevant skill and guide you through it.

### 2.4. Try Workshop Skills

You can run the workshop skills in one of two ways - you can type out one of the trigger phrases provided, or you can use the skill name with a `/` command in the chat window. Let's try it:

1. In the chat window type:

    ```bash
    what's first
    ```

    This will map to the _run-workshop_ skill and will kick off Lab 0. Just watch for what it asks you and answer to kickstart the lab journey. For instance, it may ask you to run a command to check pre-requisites. It will tell you what it is looking for - you can respond with a "Done" or you can paste the results from trying out that command into the chat so it can verify it.

    **Were you able to test this out and see the skill in action?**

1. You continue the workshop -- but first, let's also learn about another way to call the skill. This time I want to have it explain something to me and I want to use the workshop's `/explain-this` skill.

    ```bash
    /explain-this what is azd
    ```

    You should see an explanation of what azd is - AND it should provide you some context for why it matters to this workshop.

**Congratulations** - you are ready to proceed with the workshop.

 
## Workshop Progress

Some handy tips before we start:

1. **Path Setting** The workshop will kick off by asking you which path you are on. Make sure you pick the right option for your current context! If you pick the wrong one - that's okay. Just correct it by saying "I picked the wrong path - start again" - and let it guide you in making changes.

1. **Progress Tracker** The workshop skill will track your progress in a file called [`progress.json`](./../workshop/progress.json). This will keep track of what you finished, where you stopped and any issues you faced. This allows you to stop anytime to ask questions (`/explain-this`) or troubleshoot something (`/help-me-debug`) - and have Copilot pick up from where you stopped afterwards by saying `/what-next`.

1. **Troubleshooting** Raise your hand to ask a proctor. You can also try asking Copilot to explain something or to help you debug first. Try to use this with caution - too much output can cause you to lose track of your session output. One way to manage this is to click **New Session** to have a second chat open just to ask questions like this. Then move back to the first session to continue workshop.

Ready? Say **`/what-next` and get started.

<br/>