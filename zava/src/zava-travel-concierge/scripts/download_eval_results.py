"""Download per-row results for a Foundry agent-target eval run and summarize failures."""
import json
import sys
from pathlib import Path

from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient

PROJECT_ENDPOINT = "https://ai-account-syjnqq4yulcf2.services.ai.azure.com/api/projects/ai-project-lab540-aiewf26"
EVAL_ID = "eval_34de39b04e9d4b22848dee915727c557"
RUN_ID = "evalrun_abc0ab6e9e99447f8bc0903bf59fc151"

OUT = Path(__file__).parent.parent / ".foundry" / "results" / f"{RUN_ID}.items.json"


def main() -> None:
    project_client = AIProjectClient(
        endpoint=PROJECT_ENDPOINT, credential=DefaultAzureCredential()
    )
    client = project_client.get_openai_client()

    run = client.evals.runs.retrieve(run_id=RUN_ID, eval_id=EVAL_ID)
    print(f"Status: {run.status}  Report: {getattr(run, 'report_url', None)}")

    items = [it.model_dump() for it in client.evals.runs.output_items.list(run_id=RUN_ID, eval_id=EVAL_ID)]
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(items, indent=2, default=str))
    print(f"Saved {len(items)} items -> {OUT}")

    print("\n=== Failures by evaluator ===")
    for it in items:
        ds = it.get("datasource_item", {}) or {}
        query = ds.get("query", "")
        response = ds.get("sample.output_text") or ds.get("sample", {})
        for r in it.get("results", []):
            name = r.get("name") or r.get("metric")
            passed = r.get("passed")
            if passed is False or (r.get("metric") and "error" in str(r).lower() and passed is None):
                pass
        # print task_adherence + errored tool_call_accuracy
        for r in it.get("results", []):
            name = r.get("name") or r.get("metric")
            if name in ("task_adherence", "tool_call_accuracy"):
                if r.get("passed") is False or r.get("score") is None:
                    print(f"\n[{name}] passed={r.get('passed')} score={r.get('score')}")
                    print(f"  Q: {query[:140]}")
                    reason = r.get("reason") or r.get("sample", {})
                    print(f"  reason: {str(reason)[:400]}")
                    if isinstance(response, str):
                        print(f"  A: {response[:300]}")


if __name__ == "__main__":
    sys.exit(main())
