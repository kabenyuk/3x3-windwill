# 3x3-windmill

Algorithm for searching 19 triples on 19 points with specific intersection properties.

## Algorithm (lexicographic backtracking)

We construct a set of blocks of the form $B=(a,b,c)$, with $a<b<c$, on the set $V=\\{1,\dots,19\\}$ such that:
1. Each point in $V$ appears exactly three times (regularity R);
2. Any two blocks share at most one common point (linearity L);
3. If three blocks intersect pairwise, they must share a common point (triangle-free T).

### State
* $\mathcal{S}$: current list of triples;
* $cap(x)$: remaining quota of point $x$ (initially $3$ for all $x$).

### Step
1. Let $a$ be the smallest point with $cap(a)>0$.
2. Try all triples $(a,b,c)$ with $a<b<c$ and $cap(b)$, $cap(c)>0$, in lexicographic order.
3. A candidate $B=(a,b,c)$ is accepted iff:
    * **(L)** For every existing block $X\in\mathcal{S}$, $|X\cap B|\leq1$;
    * **(T)** Let $\mathcal{P}=\\{X\in\mathcal{S}\mid X\cap B\neq\varnothing\\}$ be the set of existing blocks intersecting $B$. For any pair $X,Y\in\mathcal{P}$, either $X\cap Y=\varnothing$ or $X\cap Y\subset B$.
4. If accepted, decrease $cap(a),cap(b),cap(c)$ by $1$, add $B$ to $\mathcal{S}$, and continue recursively.
5. If no candidate works, backtrack to the most recent choice and continue with the next lexicographic option.

### Termination
The process stops when $19$ blocks are constructed and all quotas are zero.

## Usage
You can run the algorithm using either **GAP** or **Python**.

### Option 1: GAP System
### Prerequisites
You need the **GAP System** (Groups, Algorithms, Programming) installed on your computer.
[Download GAP here](https://www.gap-system.org/Download/index.html).

### Running the Code
1. Download the file `search_design.g` from this repository.
2. Open GAP.
3. Run the script using the `Read` command (provide the correct path to the file):

```gap
gap> Read("/path/to/your/search_design.g");
```
### Option 2: Python

### Prerequisites
Python 3.x installed.

### Running the Code
1. Download the file search_design.py from this repository.
2. Open your terminal (command prompt).
3. Run the script:
`python3 search_design.py`

### Output
Both scripts will output the execution time and the list of 19 blocks if a solution is found.
