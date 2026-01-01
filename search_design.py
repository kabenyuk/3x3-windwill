#!/usr/bin/env python3
import time

def main():
    start = time.time()
    V, R = 19, 3
    
    # 1. Structures
    # adj[i][j] = True if pair {i, j} is already covered
    adj = [[False] * (V + 1) for _ in range(V + 1)]
    # inc[p] = list of sets (blocks) that contain point p
    inc = [[] for _ in range(V + 1)]
    # cap[p] = remaining capacity for point p
    cap = [0] + [R] * V
    blocks = []

    # 2. Seed (Same as in GAP version)
    seed = [
        (1, 2, 3), (1, 4, 5), (1, 6, 7), 
        (2, 8, 9), (2, 10, 11),
        (3, 12, 13), (3, 14, 15), 
        (4, 16, 17), (4, 18, 19)
    ]
    seed = []
    # Apply seed
    for t in seed:
        blocks.append(t)
        s = set(t)
        u, v, w = t
        for p in t:
            cap[p] -= 1
            inc[p].append(s)
        adj[u][v] = adj[v][u] = adj[u][w] = adj[w][u] = adj[v][w] = adj[w][v] = True

    # 3. Backtracking
    def backtrack():
        if len(blocks) == V: return True 

        # Find first point with capacity
        a = next((p for p in range(1, V + 1) if cap[p]), None)
        if not a: return False

        for b in range(a + 1, V + 1):
            if not cap[b] or adj[a][b]: continue
            
            # Triangle Check for A and B
            if any(not x.isdisjoint(y) for x in inc[a] for y in inc[b]): continue

            for c in range(b + 1, V + 1):
                if not cap[c] or adj[a][c] or adj[b][c]: continue
                
                # Triangle Check for C against A and B
                if any(not x.isdisjoint(y) for x in inc[c] for y in inc[a] + inc[b]): continue

                # Add Block
                t = (a, b, c)
                s = {a, b, c}
                blocks.append(t)
                adj[a][b] = adj[b][a] = adj[a][c] = adj[c][a] = adj[b][c] = adj[c][b] = True
                for p in t: 
                    cap[p] -= 1
                    inc[p].append(s)

                if backtrack(): return True

                # Backtrack
                for p in t: 
                    inc[p].pop()
                    cap[p] += 1
                adj[a][b] = adj[b][a] = adj[a][c] = adj[c][a] = adj[b][c] = adj[c][b] = False
                blocks.pop()
        return False

    print("Starting optimized search in Python...")
    if backtrack():
        elapsed = time.time() - start
        print(f"Solution found in {elapsed:.4f}s:")
        for b in blocks: print(b)
    else:
        print("No solution.")

if __name__ == "__main__":
    main()
