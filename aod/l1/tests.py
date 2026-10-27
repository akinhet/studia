#!/usr/bin/env python3
"""Uruchamia testy algorytmow grafowych i zapisuje wyniki do CSV.

Uruchom z katalogu glownego projektu: python3 run_graph_tests.py --repeats 5
Programy otrzymuja sciezke do grafu jako pierwszy argument CLI.
"""
import argparse
import csv
import json
import re
import statistics
import subprocess
import sys
import time
from pathlib import Path

# (zadanie, nazwa algorytmu, sciezka wykonywalna)
PROGRAMS = [
    ("z1", "bfs", "z1/bfs"),
    ("z1", "dfs", "z1/dfs"),
    ("z2", "topo", "z2/topo"),
    ("z3", "scc", "z3/scc"),
    ("z4", "bipartite", "z4/bipartite"),
]


def files_for(root, task):
    # Wlasne testy kazdego zadania oraz oficjalne testy dla zadan 2-4.
    candidates = list((root / task).glob("g*.txt"))
    official_dir = root / "aod_testy1" / task[1:]
    if task == "z2":
        candidates += list(official_dir.glob("g2*.txt"))
    elif task == "z3":
        candidates += list(official_dir.glob("g3*.txt"))
    elif task == "z4":
        candidates += list(official_dir.glob("[du]4*.txt"))
    return sorted({p.resolve() for p in candidates if p.is_file()}, key=lambda p: str(p))


def graph_metadata(path):
    try:
        with path.open(encoding="utf-8-sig") as f:
            kind = f.readline().strip()
            n = int(f.readline().strip())
            m = int(f.readline().strip())
            return kind, n, m
    except (OSError, ValueError):
        return "", "", ""


def extract_result(algorithm, stdout):
    """Krotki opis, pelny stdout trafia do osobnego pliku."""
    if algorithm == "topo":
        if re.search(r"has a directed cycle|contains a directed cycle", stdout, re.I):
            return "cycle"
        if re.search(r"is acyclic", stdout, re.I):
            return "acyclic"
    elif algorithm == "scc":
        match = re.search(r"Number of SCCs\s*:\s*(\d+)", stdout, re.I)
        if match:
            return f"scc={match.group(1)}"
    elif algorithm == "bipartite":
        if re.search(r"\bnot bipartite\b|\bis not bipartite\b", stdout, re.I):
            return "not bipartite"
        if re.search(r"\bbipartite\b", stdout, re.I):
            return "bipartite"
    return ""


def save_csv(path, fields, rows):
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)


def main():
    ap = argparse.ArgumentParser(description="Benchmark programow grafowych.")
    ap.add_argument("--root", type=Path, default=Path(__file__).resolve().parent,
                    help="Katalog projektu (domyslnie katalog skryptu)")
    ap.add_argument("--repeats", type=int, default=5, help="Powtorzenia kazdego testu")
    ap.add_argument("--timeout", type=float, default=30.0, help="Limit sekund na uruchomienie")
    ap.add_argument("--out", type=Path, default=Path("benchmark_results"),
                    help="Katalog wynikow (wzgledem katalogu projektu)")
    args = ap.parse_args()
    if args.repeats < 1 or args.timeout <= 0:
        ap.error("--repeats musi byc >= 1, a --timeout > 0")
    root = args.root.resolve()
    out = args.out if args.out.is_absolute() else root / args.out
    logs = out / "outputs"
    logs.mkdir(parents=True, exist_ok=True)

    runs = []
    summaries = []
    for task, algo, executable in PROGRAMS:
        exe = root / executable
        if not exe.is_file():
            print(f"BRAK programu: {exe} (pomijam)", file=sys.stderr)
            continue
        cases = files_for(root, task)
        if not cases:
            print(f"BRAK testow: {task}", file=sys.stderr)
        for case in cases:
            kind, n, m = graph_metadata(case)
            case_rel = str(case.relative_to(root))
            case_id = case_rel.replace("/", "__")
            durations = []
            statuses = []
            outputs = []
            for rep in range(1, args.repeats + 1):
                started = time.perf_counter_ns()
                try:
                    p = subprocess.run([str(exe), str(case)], cwd=root, capture_output=True,
                                       text=True, errors="replace", timeout=args.timeout)
                    status = "ok" if p.returncode == 0 else f"exit_{p.returncode}"
                    stdout, stderr = p.stdout, p.stderr
                    retcode = p.returncode
                except subprocess.TimeoutExpired as e:
                    status = "timeout"
                    stdout = e.stdout.decode(errors="replace") if isinstance(e.stdout, bytes) else (e.stdout or "")
                    stderr = e.stderr.decode(errors="replace") if isinstance(e.stderr, bytes) else (e.stderr or "")
                    retcode = ""
                except OSError as e:
                    status, stdout, stderr, retcode = "exec_error", "", str(e), ""
                duration = (time.perf_counter_ns() - started) / 1e6
                log_path = logs / f"{task}__{algo}__{case_id}__run{rep}.txt"
                log_path.write_text(f"STDOUT:\n{stdout}\nSTDERR:\n{stderr}\n", encoding="utf-8")
                result = extract_result(algo, stdout) if status == "ok" else ""
                runs.append({"task": task, "algorithm": algo, "test_file": case_rel,
                             "graph_type": kind, "vertices": n, "edges": m, "repeat": rep,
                             "status": status, "returncode": retcode,
                             "wall_ms": round(duration, 6), "result": result,
                             "output_file": str(log_path.relative_to(out))})
                statuses.append(status)
                outputs.append(stdout)
                if status == "ok":
                    durations.append(duration)
            success = len(durations)
            consistent = len({s for s, status in zip(outputs, statuses) if status == "ok"}) <= 1
            summaries.append({"task": task, "algorithm": algo, "test_file": case_rel,
                              "graph_type": kind, "vertices": n, "edges": m,
                              "successful_runs": success, "repeats": args.repeats,
                              "min_ms": round(min(durations), 6) if success else "",
                              "mean_ms": round(statistics.mean(durations), 6) if success else "",
                              "median_ms": round(statistics.median(durations), 6) if success else "",
                              "max_ms": round(max(durations), 6) if success else "",
                              "stdev_ms": round(statistics.stdev(durations), 6) if success > 1 else "",
                              "output_identical": consistent,
                              "result": extract_result(algo, next((s for s, st in zip(outputs, statuses) if st == "ok"), "")),
                              "statuses": ";".join(statuses)})
            print(f"{task:>2} {algo:<10} {case_rel:<40} "
                  f"{success}/{args.repeats} OK  "
                  f"median={statistics.median(durations):.3f}ms" if durations
                  else f"{task} {algo} {case_rel}: BLAD ({';'.join(statuses)})")

    if not runs:
        print("Nie znaleziono programow/testow; sprawdz --root.", file=sys.stderr)
        return 1
    run_fields = ["task", "algorithm", "test_file", "graph_type", "vertices", "edges",
                  "repeat", "status", "returncode", "wall_ms", "result", "output_file"]
    summary_fields = ["task", "algorithm", "test_file", "graph_type", "vertices", "edges",
                      "successful_runs", "repeats", "min_ms", "mean_ms", "median_ms",
                      "max_ms", "stdev_ms", "output_identical", "result", "statuses"]
    save_csv(out / "runs.csv", run_fields, runs)
    save_csv(out / "summary.csv", summary_fields, summaries)
    print(f"\nWyniki zapisano w: {out}")
    print("runs.csv = kazde uruchomienie; summary.csv = statystyki; outputs/ = pelne wyniki")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
