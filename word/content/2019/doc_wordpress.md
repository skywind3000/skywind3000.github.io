---
uuid: 2343
title: 博客升级
status: private
categories: 随笔
tags: 
slug: 
---

完全使用 Markdown 编写博客内容，并用命令行工具 [markpress](https://github.com/skywind3000/markpress) 发布到 WordPress：

#### 漂亮代码

Markdown 的 fenced code block，效果如下：

```cpp
#include <stdio.h>
int main(void)
{
    printf("Hello, World !!\n");
    return 0;
}
```

#### 内嵌公式

输入：

```
$z=\sqrt{x^2 + \sqrt{y^2}}$
```

得到：

$z=\sqrt{x^2 + \sqrt{y^2}}$

#### 内嵌图表

输入：

`````
```viz-dot
digraph G {
   A -> B
   B -> C
   B -> D
}
```
`````

得到：

<!--more-->

```viz-dot
digraph G {
   A -> B
   B -> C
   B -> D
}
```

#### 复杂图形

输入：

`````
```viz-circo
digraph st2 {
 rankdir=TB;
 node [fontname = "Verdana", fontsize = 10, color="skyblue", shape="record"];
 edge [fontname = "Verdana", fontsize = 10, color="crimson", style="solid"];
 st_hash_type [label="{<head>st_hash_type|(*compare)|(*hash)}"];
 st_table_entry [label="{<head>st_table_entry|hash|key|record|<next>next}"];
 st_table [label="{st_table|<type>type|num_bins|num_entries|<bins>bins}"];
 st_table:bins -> st_table_entry:head;
 st_table:type -> st_hash_type:head;
 st_table_entry:next -> st_table_entry:head [style="dashed", color="forestgreen"];
}
```
`````

得到：

```viz-circo
digraph st2 {
 rankdir=TB;
  
 node [fontname = "Verdana", fontsize = 10, color="skyblue", shape="record"];
 edge [fontname = "Verdana", fontsize = 10, color="crimson", style="solid"];
  
 st_hash_type [label="{<head>st_hash_type|(*compare)|(*hash)}"];
 st_table_entry [label="{<head>st_table_entry|hash|key|record|<next>next}"];
 st_table [label="{st_table|<type>type|num_bins|num_entries|<bins>bins}"];
  
 st_table:bins -> st_table_entry:head;
 st_table:type -> st_hash_type:head;
 st_table_entry:next -> st_table_entry:head [style="dashed", color="forestgreen"];
}

```


