---
uuid: 2746
title: 帧同步游戏中使用 Run-Ahead 隐藏输入延迟
status: publish
categories: 游戏开发
tags: 同步
slug: 
date: 2023-10-22 11:05
---
帧同步可以轻松解决高互动的联网游戏（如格斗，RTS 等）的同步问题，但该方案对延迟很敏感，现在一般省内服务器延迟差不多 10-15ms （1帧），跨省一般 40ms （2-3 帧），在此情况下，使用 Run-Ahead 机制可以有效的掩盖延迟的体感，让用玩家立马看到自己的操作反馈。

该机制有很多其他名字比如：预测回滚（prediction and rollback），或者时间曲力（time warp），名字取的天花乱坠的，很多文章也只是云里雾里说一半天，结果还没说清楚，所以本文打算最简短的句子说清楚这个概念，并给出可以实际操作的实现步骤。

我觉得用 Run-Ahead 这个质朴的名字更容易说明这个算法背后的思想：提前运行，这个概念不光用在游戏同步里，也早已用在游戏模拟器中，为了便于理解，先说一下模拟器中的情况（更简单）。

RetroArch 使用 Run-Ahead 隐藏输入延迟，一般需要设置一下 Run-Ahead 的帧数，比如 0 是关闭，1 是提前运行一帧，2 是提前运行两帧，一般设置用 1 或者 2，不要超过 5，因为太高游戏表现会很奇怪：

![](https://skywind3000.github.io/images/blog/2023/runahead1.png)

运行时 RetroArch 为每帧保存快照，假定的是用户输入有持续性，那么运行时当前帧使用上一帧用户的输入作为本帧输入（假设 runahead 设置为 1），然后接着往下运行，如果用户新输入来了，一律把它算作当前帧-1 的输入，然后再去对比历史如果和上一帧所尝试假定的输入一致就继续，否则快照回退到上一帧，重新用新的输入去运行，然后再快进到当前帧。

通常手柄或键盘都有 5ms 左右的输入延迟（部分设备如 switch 的 pro 手柄延迟高达 15ms），再加上操作系统处理的延迟，投递到模拟器进程里，从按下到真正开始处理也许也差不多 1 帧的时间了，RetroArch 用这个功能，也只有用户真实输入和预测输入不一致时才会触发，由于间隔很短，所以即使纠正也难看出来，最终在模拟器上达到了物理设备一样的超低延迟体验。

理解了模拟器的 Run-Ahead 实现，其实在帧同步里的原理也就差不多了，无外乎是用远程的旧输入，搭配本地刚采集到的新输入，作为预测帧的输入值，产生新帧，不匹配了再回滚。

帧同步里引入类似 Run-Ahead 的机制，要求游戏最近所有状态都可以被快速保存、复制和恢复，实现有很多种，你可以用状态的反复前进、后退来实现，但是 BUG 率太高了，这里给出一个更简易的实现方式：

（点击 more 展开）

<!--more-->

1. 主逻辑沿用旧的帧同步逻辑：收到服务端第 N 帧的更新消息 `Update N` 后，游戏才往前播放，否则等待。
2. 游戏第 N 帧的状态为 `S(N)`，当收到 `Update N` 时从 `S(N-1)` 计算得到。
3. 计算**预测输入**= `Update N` 中其他玩家的旧输入+本地刚采集到的本地玩家最新输入。
4. 每次得到一个新的 `S(N)` 时，复制出一个副本 `S'(N)` 来，并在其基础上用**预测输入**，产生 `S'(N+1)` 用于显示。

给一个图示：

![](https://skywind3000.github.io/images/blog/2023/runahead2.png)

其实就是维护两条状态线索，主线索：`S(N-2)`, `S(N-1)`, `S(N)` ... 同老的帧同步一样单向前进，用作胜负判断，但不用于显示，用于显示的是每帧的状态 `S(N)` 的副本 `S'(N)` 的下一个预测副本 `S'(N+1)`。

要点就是：**每次播放到第 N 帧后，再用预测的输入值立马生成一个新的临时帧 N+1 用于显示**。

复习一下原始乐观帧锁定（输入是每个用户某几个按键是否被按下的状态）：

> 1）所有用户将当前采集到的输入上报服务器。
> 2）服务器每秒钟 20-50 次的频率向所有客户端广播更新消息（帧号+所有人的最新输入）。
> 3）客户端就像播放游戏录像一样不停的播放这些包含每帧所有玩家操作的 update 消息。
> 4）客户端如果没有 update 数据了，就必须等待，直到有新的数据到来。
> 5）客户端如果一下子收到很多连续的 update，则快进播放。

需要详细了解帧同步的原理可以 [看这里](https://www.skywind.me/blog/archives/131)，我们把前面的概念带入进去，追加两条即可：

1）所有用户将当前采集到的输入上报服务器。

2）服务器每秒钟 20-50 次的频率向所有客户端广播更新消息（帧号+所有人的最新输入）。

3）客户端就像播放游戏录像一样**不停的播放这些包含每帧所有玩家操作的 `update` 消息**。

4）客户端如果没有 `update` 数据了，就必须等待，直到有新的数据到来。

5）客户端如果一下子收到很多连续的 `update`，则快进播放。

6）将 update 中其他玩家的旧输入+本地刚采集到的本地玩家最新输入作为 “**预测输入值**”。

7）每帧状态 `S(N)` **不用于显示**，而是同时复制出 `S'(N)` 并立马用上面的预测输入产生 `S'(N+1)` **用于显示**。

由于游戏的主状态 `S(N)` 完全采用服务端下发的更新消息驱动，因此由于输入一致，它在各个客户端上都是严格同步的，**我们用主状态 `S(N)` 来判断游戏结果，但不用它来显示**，我们用它复制出一个临时副本 `S'(N)` 来，并再副本基础上用 “预测输入值”作为输入，立马产生出 `S'(N+1)` 用于显示（驱动显示状态），这样 `S'(N+1)` 就具备了本地输入上的一个提前量，**可以让用户感知到立马操作就有反馈**。

注意，从主状态更新到 `S(N)` 开始，到复制 `S'(N)` 并计算 `S'(N+1)` 中间没有任何停顿，主状态一更新到 `S(N)` 就立马算出预测状态 `S'(N+1)` 用于显示。

这里假设 runahead=1 的话，实际运行起来的体验就是如果远端输入没有改变，那么就是连续运行，如果远端输入改变了，那么会在瞬间有一个：回滚一帧，再用新输入立马同时前进一帧的效果，而这个回滚和再前进是同时在一帧内发生的，**玩家并不会在视觉上看到任何老画面，只会在最新帧里看到和之前稍有不连续的动画**。

同时，我们这个实现内部并没有真的去做回滚再前进这么危险的事情，主状态始终以最简单的方式单向递增前进，副本状态每帧在主状态上分叉并进行预测计算用于显示，避免了很多容易出错的地方，又达到了相同效果。

该算法的一些优化点：

1）客户端没如期收到服务端更新消息，主状态停在 `S(N)` 处，下一帧时间到了，预测状态可继续用最新输入迭代成 `S'(N+2)` 来显示。

2）预测状态不能无限领先，比如 runahead=2 的话，最多领先 2 帧，就停下来等待主状态了。

3）显示和动画系统需要做出相应的调整和适配，以适应状态切换，以及逻辑和显示相分离。

4）音效播放难以撤销，最好所有音频触发都放在主状态里，那里是确定的完全同步的逻辑。

5）计算预测输入值时，本地输入不一定取当前最新的，可以适当往前取 1-2 帧的本地输入，比如本地反应很灵敏，但服务端延迟又大的时候（比如 > 40ms），就会导致经常回退，这种情况人为加点延迟，降低回退率。

6）实际实现不必每帧都做状态复制，输入不变就可保持主状态 `S(N)` 和副本预测状态 `S'(N+1)` 各自独立更新，前者决定逻辑，后者用于显示，预测不正确时再把主状态复制过来成新副本 `S'(N)` ，再迭代出 `S'(N+1)` 来。

注意：输入数据有两种，一种是**状态型**（某几个按键当前是按下还是放开），另一种是**事件触发型**（我按了一次攻击键，或者高级点的抽象我放了个某技能），上文中的 “预测输入”针对的是状态型，如果是触发型，那么生成预测输入值时就只用本地最近产生的输入事件即可，不必理会其他人的老输入。

最后，这个算法不是降低延迟，而是隐藏/掩盖延迟，让用户可以像本地游戏一样立马看到自己的输入反馈。


<br/>

--

相关阅读：

- [再谈网络游戏同步 - Skywind Inside](https://www.skywind.me/blog/archives/1343)
- [帧锁定同步算法 - Skywind Inside](https://www.skywind.me/blog/archives/131)
- [网络游戏同步法则 - Skywind Inside](https://www.skywind.me/blog/archives/112)
- [影子跟随算法 - Skywind Inside](https://www.skywind.me/blog/archives/1145)
- [关于 “帧同步” 说法的历史由来 - Skywind Inside](https://www.skywind.me/blog/archives/2651)



--
