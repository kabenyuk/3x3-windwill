Solve3x3 := function()
    local V, R, adj, inc, cap, blocks, seed, t, u, v, w, p, start_time, Backtrack;

    V := 19;
    R := 3;

    # Initialize structures
    # adj: V x V matrix, filled with false (adjacency matrix)
    adj := List([1..V], i -> List([1..V], j -> false));
    
    # inc: list of lists (which blocks contain a specific point)
    inc := List([1..V], i -> []);
    
    # cap: remaining capacity for each point (initially R)
    cap := List([1..V], i -> R);
    
    blocks := [];

    # Initial seed
    seed := [
        [1, 2, 3], [1, 4, 5], [1, 6, 7], 
        [2, 8, 9], [2, 10, 11],
        [3, 12, 13], [3, 14, 15], 
        [4, 16, 17], [4, 18, 19]
    ];
    
    # To search from scratch (empty seed), uncomment the line below:
    seed := [];

    # Apply Seed
    for t in seed do
        Add(blocks, t);
        u := t[1]; v := t[2]; w := t[3];

        # Decrease capacity and update incidence lists
        cap[u] := cap[u] - 1; Add(inc[u], t);
        cap[v] := cap[v] - 1; Add(inc[v], t);
        cap[w] := cap[w] - 1; Add(inc[w], t);

        # Update adjacency matrix (mark edges as used)
        adj[u][v] := true; adj[v][u] := true;
        adj[u][w] := true; adj[w][u] := true;
        adj[v][w] := true; adj[w][v] := true;
    od;

    # Internal Backtrack function
    Backtrack := function()
        local a, b, c, i, blk_a, blk_b, blk_c, conflict, new_block;

        # Termination condition: 19 blocks found
        if Length(blocks) = V then return true; fi;

        # 1. Find the first point 'a' with available capacity (cap > 0)
        a := fail;
        for i in [1..V] do
            if cap[i] > 0 then a := i; break; fi;
        od;
        if a = fail then return false; fi;

        # 2. Iterate over 'b'
        for b in [a+1..V] do
            # Skip if no capacity or edge (a,b) is already used
            if cap[b] > 0 and adj[a][b] = false then
                
                # (Optimization) Triangle check for A and B
                # If blocks containing A intersect with blocks containing B -> conflict
                conflict := false;
                for blk_a in inc[a] do
                    for blk_b in inc[b] do
                        # Intersection returns a list of common elements. If not empty -> they intersect.
                        if Intersection(blk_a, blk_b) <> [] then 
                            conflict := true; break; 
                        fi;
                    od;
                    if conflict then break; fi;
                od;

                if not conflict then
                    # 3. Iterate over 'c'
                    for c in [b+1..V] do
                        if cap[c] > 0 and adj[a][c] = false and adj[b][c] = false then
                            
                            # Triangle check for C against (A and B)
                            conflict := false;
                            # Concatenate lists for A and B, check against C
                            for blk_c in inc[c] do
                                for blk_ab in Concatenation(inc[a], inc[b]) do
                                    if Intersection(blk_c, blk_ab) <> [] then
                                        conflict := true; break;
                                    fi;
                                od;
                                if conflict then break; fi;
                            od;

                            if not conflict then
                                # --- APPLY ---
                                new_block := [a, b, c];
                                Add(blocks, new_block);
                                
                                adj[a][b] := true; adj[b][a] := true;
                                adj[a][c] := true; adj[c][a] := true;
                                adj[b][c] := true; adj[c][b] := true;

                                cap[a] := cap[a]-1; Add(inc[a], new_block);
                                cap[b] := cap[b]-1; Add(inc[b], new_block);
                                cap[c] := cap[c]-1; Add(inc[c], new_block);

                                # Recursion
                                if Backtrack() then return true; fi;

                                # --- BACKTRACK (Undo) ---
                                cap[a] := cap[a]+1; Remove(inc[a]); # Remove deletes the last element
                                cap[b] := cap[b]+1; Remove(inc[b]);
                                cap[c] := cap[c]+1; Remove(inc[c]);

                                adj[a][b] := false; adj[b][a] := false;
                                adj[a][c] := false; adj[c][a] := false;
                                adj[b][c] := false; adj[c][b] := false;

                                Remove(blocks); # Removes the last added block
                            fi;
                        fi;
                    od;
                fi;
            fi;
        od;
        return false;
    end;

    # Run and measure time
    start_time := Runtime();
    Print("Starting optimized search in GAP...\n");

    if Backtrack() then
        Print("Solution found in ", String(Runtime() - start_time), " ms:\n");
        for t in blocks do
            Print(t, "\n");
        od;
    else
        Print("No solution found.\n");
    fi;
end;

# Automatically run when file is read
Solve3x3();
