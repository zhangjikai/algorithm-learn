# 并查集算法
<!-- toc -->

## 动态连通性
给定一些对象，这些对象中的某些对象存在 `连通` 的关系，这里我们假设 `连通` 关系是一种等价 (equivalence) 关系：
* 自反性 (Reflexive): p 和 p 是相连的
* 对称性 (Symmetric): 如果 p 和 q 相连，那么 q 和 p 也是相连的
* 传递性 (Transitive): 如何 p 和 q 相连并且 q 和 r 也是相连的，那么 p 和 r 也是相连的。

等价关系可以将对象分为多个等价类。在这里，当且仅当两个对象相连时它们才属于同一个等价类。在动态连通性问题中，对于给定的两点 p 和 q，我们需要判断 p 和 q 是否相连，同时对象之间的连通关系会动态的发生变化。

## 算法实现
下面是算法的 API：

![](/images/union-find/api.png)

其中 `connected` 和 `count` 实现比较简单：

```java
public boolean connected(int p, int q) {
    return find(p) == find(q);
}

public int count() {
    return count;
}
```

对于合并和查找这里主要记录一下 `weighted quick-union` 算法。在该算法中，使用一个数组 sites 来存储点，通过模拟森林来表示连通关系，森林中的每棵树都表示一个连通分量。对于索引 i，如果 `sites[i] == i` 那么点 i 就是某个树的根节点，如果 `sites[i] != i`，那么表明这是一个子节点，该节点中的值就是它父节点的索引，通过父节点，我们可以递归的向上直到找到最终的根节点。下面是实现 find 和 union 的方式：
* 对于 `find(int p)`，判断当前点 p 是否为根节点，如果是返回 p，否则递归的往上找。在向上找的过程中，进行路径压缩，也就是将 p 指向它的祖父节点。
* 对于 `union(int p, int q)`，首先找到 p 和 q 对应的根节点，判断两者是否相同。如果不同则进行合并，合并的依赖的将小树合并到大树上(这里用一个专门的数组记录了每棵树的大小)。

下面是算法实现
```java
/**
 * Returns the component identifier for the component containing site {@code p}.
 *
 * @param  p the integer representing one site
 * @return the component identifier for the component containing site {@code p}
 * @throws IllegalArgumentException unless {@code 0 <= p < n}
 */
public int find(int p) {
    validate(p);
    while (p != parent[p]) {
        parent[p] = parent[parent[p]]; // path compression by halving
        p = parent[p];
    }
    return p;
}

/**
 * Merges the component containing site {@code p} with the
 * the component containing site {@code q}.
 *
 * @param  p the integer representing one site
 * @param  q the integer representing the other site
 * @throws IllegalArgumentException unless
 *         both {@code 0 <= p < n} and {@code 0 <= q < n}
 */
public void union(int p, int q) {
    int rootP = find(p);
    int rootQ = find(q);
    if (rootP == rootQ) return;

    // make root of smaller rank point to root of larger rank
    if (size[rootP] < size[rootQ]) {
        parent[rootP] = rootQ;
        size[rootQ] += size[rootP];
    }
    else {
        parent[rootQ] = rootP;
        size[rootP] += size[rootQ];
    }
    count--;
}
```

## 完整实现
下面是算法的完整实现， [源码地址](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/UF.java.html)：
[import](code/UF.java)
