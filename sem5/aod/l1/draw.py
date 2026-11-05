import subprocess

with open("./aod_testy1/2/g2a-4.txt") as f:
    directed = f.readline().strip() == "D"
    n = int(f.readline())
    m = int(f.readline())
    edges = [tuple(map(int, f.readline().split())) for _ in range(m)]

kind = "digraph" if directed else "graph"
arrow = "->" if directed else "--"

with open("graph.dot", "w") as f:
    f.write(f"{kind} G {{\n")
    f.write('  graph [overlap=false, splines=true];\n')
    f.write('  node [shape=circle, width=0.35, fixedsize=true];\n')

    for v in range(1, n + 1):
        f.write(f"  {v};\n")

    for u, v in edges:
        f.write(f"  {u} {arrow} {v};\n")

    f.write("}\n")

subprocess.run(
    ["dot", "-Tsvg", "graph.dot", "-o", "graph.svg"],
    check=True
)
