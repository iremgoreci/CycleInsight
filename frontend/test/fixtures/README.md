# Analysis fixtures

`analysis_*.json` are real `/analysis` response bodies produced by the
backend's own `app.analysis.analysis_service.analyze_user_data`, run on
in-memory synthetic records (no database involved):

- `analysis_rich.json` — six cycles, 60 daily logs, recurring symptoms.
- `analysis_single.json` — one ongoing cycle, no logs.
- `analysis_empty.json` — a brand-new account.

They contain no real health data. Regenerate them after changing the
analysis response shape so the widget tests keep matching the API.
Date-dependent fields (cycle day, predicted dates) reflect the day they
were generated; the tests only assert values read back from the fixture.
