# CLAUDE.md — Coding Interaction Preferences

## Identity & Communication

- **Language**: British English. Correct my English when needed.
- **Tone**: Direct, no sycophancy. Be brutally honest. If code is bad, say so. Criticise me if needed.
- **Framing**: I'm a senior data/software engineer with a battery engineering background (EPFL, École Polytechnique). Don't over-explain fundamentals — jump to the point.
- **Verdict style**: When comparing approaches, give a clear recommendation with rationale. Don't hedge excessively. Rank approaches if needed.

## Python Standards

### Version & Typing

- **Python 3.12+ minimum**. Use modern syntax everywhere.
- **PEP 604**: `X | Y` instead of `Union[X, Y]`, `X | None` instead of `Optional[X]`.
- **PEP 585**: `list[str]`, `dict[str, int]`, `tuple[float, ...]` — never import `List`, `Dict`, `Tuple`, `Set` from `typing`.
- Type-hint all function signatures (params + return). Use `-> None` explicitly.

```python
# ✅ Correct
def process(items: list[str], threshold: float | None = None) -> dict[str, int]:
    ...

# ❌ Wrong
from typing import List, Optional, Dict
def process(items: List[str], threshold: Optional[float] = None) -> Dict[str, int]:
    ...
```

### Docstrings

- Use **NumPy-style** docstrings for public functions.
- reST-style (`:param:`) is acceptable for quick internal functions.
- Always include `Parameters`, `Returns`. Add `Raises` and `Notes` when non-trivial.

### Library Preferences

Strongly prefer these over their alternatives. Don't suggest the alternative unless I ask.

| Use          | Not                                        |
| ------------ | ------------------------------------------ |
| `polars`     | `pandas`                                   |
| `plotly`     | `matplotlib` / `seaborn`                   |
| `httpx`      | `requests`                                 |
| `rich`       | `print()` / `pprint`                       |
| `uv` / `uvx` | `pip` / `pipx` / `poetry`                  |
| `ruff`       | `black` + `isort` + `flake8`               |
| `loguru`     | `logging` (stdlib)                         |
| `typer`      | `argparse` (stdlib)                        |
| `pydantic`   | manual validation / dataclasses for config |

When Polars is used, **never** fall back to pandas syntax (no `.set_index()`, no `.apply()`, no `.iterrows()`). Know the Polars API: `unpivot`, `pivot`, `with_columns`, `str.split_exact`, `struct.unnest`, `list.to_struct`, etc.

### Code Style

- **Chaining over mutation**: Prefer `df.with_columns(...).filter(...).sort(...)` over sequential reassignment.
- **Dict literals over `dict()` constructor**: `{"color": "red"}` not `dict(color="red")`.
- **f-strings** over `.format()` or `%`.
- **`pathlib.Path`** over `os.path`.
- **`match` statements** where appropriate (Python 3.10+).
- **No bare `except:`**. Catch specific exceptions.

## Architecture & Design

### Pragmatism Over Purity

- Don't overengineer. A few well-named functions beat a class hierarchy for notebook/pipeline code.
- SOLID principles at discretion — apply when they earn their keep, not dogmatically.
- If the code is not production (notebook cleanup, one-off analysis), **functions are fine**. Don't propose config classes, registries, or abstract base classes unprompted.
- For production code, proper structure matters: clear module boundaries, explicit interfaces, error handling.
- Use Red/Green TDD
- Use screaming architecture and colocation when applicable

### Refactoring Style

When I ask to refactor:

1. Identify distinct concerns (parsing, I/O, computation, visualisation).
2. Split into a handful of meaningful functions (4–6 is typical for a notebook pipeline).
3. Type-hint everything, add docstrings.
4. Tidy interfaces between functions.
5. Don't change the logic unless I ask or there's a clear bug.
6. Flag overengineering in existing code — I appreciate that feedback.

### When I Say "Don't Overengineer"

I mean it. Specifically:

- No class hierarchies for < 3 variants.
- No abstract base classes for single implementations.
- No custom exception types unless there are genuinely distinct failure modes.
- No schema registries for small projects.
- No factory patterns for straightforward instantiation.

## Domain Context

### Battery Energy Storage Systems (BESS)

I work on analytics for grid-scale battery systems. Common concepts in my code:

- **SOC** (State of Charge), **SOH** (State of Health), **DOD** (Depth of Discharge)
- **RTE** (Round-Trip Efficiency), **PCS** (Power Conversion System), **PCC** (Point of Common Coupling)
- **ECM** (Equivalent Circuit Model) parameter identification
- **Coulombic efficiency**, **calendar/cycle aging**
- Cell-level voltage, module/rack/container hierarchy

You can assume I understand these concepts. Don't define them in code comments or explanations unless I ask.

### Algorithmic Preferences

- **Explainable methods over black-box ML**. Prefer signal processing, Kalman filters, DBSCAN, survival analysis over neural networks.
- **Kalman filters**: UKF, adaptive KF, Dual UKF. I'm familiar with filterpy and the Bayesian intuition (Labbe's book). Frame explanations in terms of prediction/update, process noise, measurement noise.
- **Signal processing**: TVRD, Whittaker-Eilers smoothing, Savitzky-Golay (but aware of its limitations). Comfortable with `scipy.signal`, `cvxpy`.
- **Clustering**: HDBSCAN, DBSCAN. Not k-means unless justified.

## Data Stack

### Polars

Primary DataFrame library. I use it extensively and know the API well. When helping:

- Use native Polars expressions, not pandas-on-polars workarounds.
- Prefer `unpivot`/`pivot` over manual reshaping.
- Use `str.extract`, `str.split_exact`, `struct.unnest` for string parsing.
- Know that `pl.col(...).unique()` doesn't preserve order — flag this when it matters.

## Tooling & Environment

### Development Environment

- **Editor**: Neovim (nvim) + tmux
- **Shell**: zsh with fzf
- **Package manager**: `uv` exclusively. `uvx` for one-off tool usage.
- **Formatting/linting**: `ruff`. Run with "uv run ruff format && uv run ruff check"
- **Testing**: `pytest` with coverage, doctest-modules. Run pytest using "uv run pytest"
- **Containerisation**: Docker, multi-stage builds, Alpine-based images preferred
- **Cloud**: Databricks notebook to run Spark and production data related stuff

### CI/CD

- Azure DevOps pipelines.
- Trivy for container vulnerability scanning.
- PEP 440 version string compliance.

### Git

- Make conventional commits
- Commit the work done

## Response Formatting

- **Code blocks**: Always include language identifier. Use `python`, `sql`, `bash`, `dockerfile`, `toml` as appropriate.
- **When comparing approaches**: Use a clear verdict ("Your original approach is the most concise and efficient. There's no hidden one-liner that's shorter.").
- **When reviewing code**: Flag issues by severity. Use line numbers or quote the relevant snippet. Be specific about what's wrong and why.
- **When refactoring**: Show the full refactored code, then explain key changes in a short list. Don't interleave explanation with code fragments.
- **Minimal formatting**: Don't overuse headers and bullet points for simple answers. A direct paragraph is often better.

## Anti-Patterns to Avoid

Don't do these in code you write for me:

- `from typing import List, Dict, Tuple, Optional, Union` (use builtins + `|`)
- `import pandas as pd` when the task is a Polars task
- `plt.show()` or matplotlib anything unless explicitly asked
- `requests.get()` — use `httpx`
- `print()` for user-facing output — use `rich`
- Classes when functions suffice
- `**kwargs` without documentation of what's accepted
- Silent `except Exception: pass`
- Returning `Any` when a concrete type is knowable
- `# TODO` without context of what/why
- No "from futures import **annotations**" we use python 3.10 or above.

## Learning & Compounding

- When I correct your approach, propose a patch to this file or to `~/docs/ai/learnings.md`.
- Don't add vague advice. Only capture specific, repo-relevant rules with examples.

## Testing

- Bug fixes require a failing test first (red/green).
- New public functions: propose a test alongside the implementation.
- Use `pytest`. Prefer parametrize for variant testing.ing)

## Post-Task

- Generate documentation with `uvx showboat` after completing code tasks.
- For web interfaces, use `uvx rodney` to verify behaviour.
