#!/usr/bin/env python3
"""Wykresy z benchmark_results/summary.csv utworzonego przez run_graph_tests.py."""
import argparse
import csv
import math
import re
from collections import Counter
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def read_rows(path):
    with path.open(newline='', encoding='utf-8-sig') as f:
        rows = list(csv.DictReader(f))
    if not rows:
        raise ValueError('Plik CSV nie ma danych.')
    required = {'task', 'algorithm', 'test_file', 'vertices', 'edges',
                'median_ms', 'successful_runs', 'result'}
    if not required.issubset(rows[0]):
        raise ValueError('Niepoprawny format summary.csv; brak: ' +
                         ', '.join(sorted(required - set(rows[0]))))
    valid = []
    for r in rows:
        try:
            if int(r['successful_runs']) <= 0:
                continue
            r['vertices'] = int(r['vertices'])
            r['edges'] = int(r['edges'])
            r['median_ms'] = float(r['median_ms'])
            r['min_ms'] = float(r['min_ms']) if r.get('min_ms') else r['median_ms']
            r['max_ms'] = float(r['max_ms']) if r.get('max_ms') else r['median_ms']
            if not math.isfinite(r['median_ms']):
                continue
            valid.append(r)
        except (ValueError, TypeError):
            continue
    return valid


def finish(path):
    plt.grid(alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180, bbox_inches='tight')
    plt.close()
    print('Zapisano:', path)


def times_plot(rows, xfield, outfile, title, log=False):
    fig, ax = plt.subplots(figsize=(10, 6))
    groups = sorted(set(r['algorithm'] for r in rows))
    for algo in groups:
        sub = sorted((r for r in rows if r['algorithm'] == algo),
                     key=lambda r: (r[xfield], r['test_file']))
        # Scatter, nie linia: rozne grafy o podobnym n nie sa jedna seria pomiarowa.
        ax.scatter([r[xfield] for r in sub], [r['median_ms'] for r in sub],
                   s=42, alpha=.8, label=algo)
    ax.set_title(title)
    ax.set_xlabel('Liczba wierzcholkow' if xfield == 'vertices' else 'Liczba krawedzi')
    ax.set_ylabel('Mediana czasu calego procesu [ms]')
    if log and all(r[xfield] > 0 and r['median_ms'] > 0 for r in rows):
        ax.set_xscale('log')
        ax.set_yscale('log')
    ax.legend()
    finish(outfile)


def compare_bfs_dfs(rows, out):
    bfs = {r['test_file']: r for r in rows if r['algorithm'] == 'bfs'}
    dfs = {r['test_file']: r for r in rows if r['algorithm'] == 'dfs'}
    shared = sorted(bfs.keys() & dfs.keys(), key=lambda k: bfs[k]['vertices'])
    if not shared:
        return
    fig, ax = plt.subplots(figsize=(10, 6))
    a = [bfs[k]['median_ms'] for k in shared]
    b = [dfs[k]['median_ms'] for k in shared]
    ax.scatter(a, b, alpha=.8)
    bound = max(a+b) * 1.07
    ax.plot([0, bound], [0, bound], '--', linewidth=1, label='Jednakowy czas')
    for k, x, y in zip(shared, a, b):
        if len(shared) <= 18:
            ax.annotate(Path(k).name, (x, y), xytext=(3, 3),
                        textcoords='offset points', fontsize=8)
    ax.set_title('BFS vs DFS na tych samych grafach')
    ax.set_xlabel('BFS: mediana [ms]')
    ax.set_ylabel('DFS: mediana [ms]')
    ax.legend()
    finish(out / 'bfs_vs_dfs.png')


def result_plots(rows, out):
    for task, title in [('z2', 'Sortowanie topologiczne'),
                        ('z4', 'Dwudzielnosc')]:
        sub = [r for r in rows if r['task'] == task and r['result']]
        if not sub:
            continue
        counts = Counter(r['result'] for r in sub)
        fig, ax = plt.subplots(figsize=(8, 5))
        bars = ax.bar(list(counts), list(counts.values()))
        ax.bar_label(bars)
        ax.set_ylabel('Liczba grafow testowych')
        ax.set_title(title + ': wyniki testow')
        finish(out / f'{task}_wyniki.png')

    sub = [r for r in rows if r['task'] == 'z3']
    parsed = []
    for r in sub:
        m = re.fullmatch(r'scc=(\d+)', r['result'].strip())
        if m:
            parsed.append((r['vertices'], int(m.group(1)), Path(r['test_file']).name))
    if parsed:
        fig, ax = plt.subplots(figsize=(10, 6))
        ax.scatter([p[0] for p in parsed], [p[1] for p in parsed], s=48)
        if len(parsed) <= 18:
            for n, num, name in parsed:
                ax.annotate(name, (n, num), xytext=(3, 3),
                            textcoords='offset points', fontsize=8)
        ax.set_xlabel('Liczba wierzcholkow')
        ax.set_ylabel('Liczba silnie spojnych skladowych')
        ax.set_title('SCC: liczba skladowych a wielkosc grafu')
        finish(out / 'z3_liczba_scc.png')


def main():
    ap = argparse.ArgumentParser(description='Wykresy benchmarkow grafowych')
    ap.add_argument('--csv', type=Path, default=Path('benchmark_results/summary.csv'))
    ap.add_argument('--out', type=Path, default=Path('benchmark_results/plots'))
    args = ap.parse_args()
    if not args.csv.is_file():
        ap.error(f'Brak pliku {args.csv}; najpierw uruchom run_graph_tests.py')
    rows = read_rows(args.csv)
    if not rows:
        ap.error('Brak udanych pomiarow w CSV.')
    args.out.mkdir(parents=True, exist_ok=True)
    for task in sorted(set(r['task'] for r in rows)):
        sub = [r for r in rows if r['task'] == task]
        for field, suffix in [('vertices', 'wierzcholki'), ('edges', 'krawedzie')]:
            times_plot(sub, field, args.out / f'{task}_czas_{suffix}.png',
                       f'{task.upper()}: czas a liczba {"wierzcholkow" if field == "vertices" else "krawedzi"}')
            if any(r[field] > 0 for r in sub) and all(r[field] > 0 and r['median_ms'] > 0 for r in sub):
                times_plot(sub, field, args.out / f'{task}_czas_{suffix}_log.png',
                           f'{task.upper()}: czas a liczba {"wierzcholkow" if field == "vertices" else "krawedzi"} (log-log)', True)
    compare_bfs_dfs(rows, args.out)
    result_plots(rows, args.out)


if __name__ == '__main__':
    main()
