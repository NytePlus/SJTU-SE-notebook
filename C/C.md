# Introduction
## How to define source language
1. regular expression
2. context-free grammar
## How to translate source to internals
![img_29.png](img_29.png)
## How to translate internals to target
![img_30.png](img_30.png)

# <span style="color:yellow">Regular Expression</span>

```regexp
ε       空
AB      拼接
A|B     联结
[a-z]+  一个或多个
[a-z]*  零个或多个
```
## example
![img_66.png](img_66.png)
![img_63.png](img_63.png)

## ambiguities
![img_64.png](img_64.png)
![img_65.png](img_65.png)

## error handler
![img_67.png](img_67.png)

## finite automata
![img_68.png](img_68.png)
### DFA and NFA
![img_69.png](img_69.png)
### example
```regexp
[0|1]*00
```
![img_70.png](img_70.png)

### regexp for NFA
![img_71.png](img_71.png)
![img_72.png](img_72.png)
### example
![img_73.png](img_73.png)

### DFA to NFA
![img_74.png](img_74.png)
### example
![img_75.png](img_75.png)

注意:
1. 不要遗漏原地打转的项
2. 对于字符的联结，在DFA中可拆可不拆
3. 两种不同的原地打转项同时又是同一个终止状态，则他不能合并，需要分别前往下一个终止状态
![img_89.png](img_89.png)
4. 匹配TODO:的过程中T、TO、TOD、TODO都是另一个终止状态
# <span style="color:gold"> Parse Lexeme</span>

![img.png](img.png)

## CFG(context-free grammar)

can define a language's grammar

![img_1.png](img_1.png)

# <span style="color:gold">LL(1) Parsing(Top down)</span>

## two operations
- shift
  - ![img_2.png](img_2.png)
- reduce
  - ![img_3.png](img_3.png)

## cannot solve 
### 1
![img_5.png](img_5.png) 
because First(T + E) == First(T)当遇到First(T)时不知道应该E→T+E还是E→T 

convert to ![img_6.png](img_6.png)

### 2. Left recursive
```regexp
 E → E + T
 E → T
```
convert to
```regexp
 E → TE'
 E'→ +TE'
 E'→
```

## LL parse table

row terminal, column non-terminal
![img_8.png](img_8.png)

## LL parse example

![img_7.png](img_7.png)
![img_9.png](img_9.png)

## construct predictive parse table

### First(X) X可以形成的前缀的集合
![img_10.png](img_10.png)
![img_57.png](img_57.png)

### Follow(X) == First(b) \beta是LL过程中匹配的部分，X是一个non-terminal，b是一个terminal
![img_11.png](img_11.png)
![img_12.png](img_12.png)

### algorithm
如果一个表中有两个，那么就不是LL(1)

![img_13.png](img_13.png)

## top-down error recovery
![img_14.png](img_14.png)
跳到出错点的follow，相当于删除token

## 总结
LL会出现歧义、左递归，没有左分解性，

大多数编程语言不是LL(1)

# <span style="color:gold">LR Parsing</span>

## LR parse example 
![img_15.png](img_15.png)

### parsing DFA
![img_16.png](img_16.png)

### DFA table
![img_17.png](img_17.png)

## algorithm
![img_18.png](img_18.png)
**push <X, Goto[top_stack(stack), X]>**

## construct DFA

### LR term
![img_19.png](img_19.png)

我们希望读到\alpha · \beta时，最后跟一个a。reduce with X->a on a

- 如果·后面跟terminal，需要执行一次shift
- 如果·读到a，需要执行一次reduce
- 如果·后面跟non-terminal，则需要计算闭包
  - ![img_25.png](img_25.png)
  - ![img_26.png](img_26.png)

### closure operation
rule==production rhs:

对于状态state红点后面是y
![img_62.png](img_62.png)
![img_20.png](img_20.png)
对于A->·ε可以直接shift，因为ε等价于没有操作

红点在最后则reduce

### example
![img_4.png](img_4.png)
![img_60.png](img_60.png)
![img_61.png](img_61.png)

- 下面这张图为什么下面两个有+，因为第一次从第一个item增加了第二、三个的')'，第二次从第二个item又增加了二、三个的'+'
  - ![img_27.png](img_27.png)

### shift-reduce conflict
![img_21.png](img_21.png)
![img_22.png](img_22.png)
![img_59.png](img_59.png)

how to solve:
- %prec reduce让这个规则和shift操作同优先级
- ![img_24.png](img_24.png)

### reduce-reduce conflict
![img_32.png](img_32.png)
better rewrite the grammar

# <span style="color:yellow">LA(look ahead)LR Parsing</span>

reduce LR states.
![img_88.png](img_88.png)

reduce-reduce conflict
- ![img_23.png](img_23.png)

## 总结
无二义性的编程语言都有LALR

LL is a subset of LR

# LR parse error recovery
![img_77.png](img_77.png)
![img_78.png](img_78.png)
只不过bottom-up需要增加一些规则

<span style="color:red">synchronizing token</span>就是follow(error)
## bottom-up error recovery
### local bottom-up error recovery
![img_79.png](img_79.png)

![img_28.png](img_28.png)

遇到error，pop直到error能shift，再pop直到能reduce
![img_80.png](img_80.png)
![img_81.png](img_81.png)
![img_82.png](img_82.png)
![img_83.png](img_83.png)
![img_84.png](img_84.png)
![img_85.png](img_85.png)

### Burke-Fisher error recovery(single token global bottom-up error recovery)
在错误前K个字符分别尝试一个字符的增删改

示意
![img_86.png](img_86.png)
![img_87.png](img_87.png)

# <span style="color:golden">Abstract syntax tree</span>

AST和parse tree的区别在于没有reduce的中间节点

![img_31.png](img_31.png)

# <span style="color:yellow">AST for Tiger</span>

# <span style="color:yellow">Semantic Actions for Top-Down parsing</span>
![img_33.png](img_33.png)
这个LL会有左递归问题

![img_34.png](img_34.png)
这个就消除左递归，但是原来在reduce时做的action，现在需要两阶段做

Inherent Attribute: 自顶向下(后者)

Synthesized Attribute: 自底向上(前者)

## 补充材料
- [lab2 tiger.lex](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\lex\tiger.lex) 🔗
- [lab3 tiger.y](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\parse\tiger.y) 🔗
- [lab3 absyn.cc](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\absyn\absyn.h) 🔗
- [lab3 symbol.h](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\symbol\symbol.h) 🔗
![img_38.png](img_38.png)

# <span style="color:yellow">Symbol table</span>

## example
![img_39.png](img_39.png)
![img_40.png](img_40.png)

a冲突，优先选\sigma_3

## two style
1. functional style: keep \sigma_1 while creating new \sigma_2, \sigma_3
2. imperative style: destructive update, undo the modification

## symbol table implement
### imperative
- hash table 应对重复元素还是正常插入，正常删除
- undo stack 由hash链表结点串起来

### functional
![img_41.png](img_41.png)

table:
![img_44.png](img_44.png)

type binding:
![img_42.png](img_42.png)
- record可以为空，判断为空需要用到NilTy
- function没有返回值，返回类型为VoidTy

value binding:
![img_43.png](img_43.png)
- Access 变量分配的位置内存/寄存器
- Level 函数嵌套的位置

variable declaration
![img_48.png](img_48.png)

function declaration
1. 查返回类型ty
2. 查参数列表ty，参数列表插入
3. 函数本身插入venv，参数列表插入venv
4. 函数体插入
![img_49.png](img_49.png)

type equal in tiger
![img_50.png](img_50.png)
![img_51.png](img_51.png)

## 补充材料
- [lab3 types.h](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\semant\types.h) 🔗
- [lab3 env.h](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\env\env.h) 🔗
- [lab3 semant.cc](D:\用户目录\Desktop\作业\编译\compilers-2024\src\tiger\semant\semant.cc) 🔗

# Activation record
lifetime: dynamic concept,
scope: static concept

## Higher-Order Functions

1. Nested functions
2. Function-valued variables

![img_45.png](img_45.png)

### 函数传参的方式
call-by-value
f(3+1)

call-by-reference
f(&a)如果f(&4)则创建一个指针

call-by-restore
执行过程中修改local，返回修改reference

call-by-name
macro

### 寄存器传参的问题
1. 函数嵌套
2. 可变参数

escape: 本来应该在register里，但是逃出来了![img_47.png](img_47.png)
global: C全局变量不放在AR放Static Data里，tiger字符串常量放Static Data里
heap: tiger的record、array

### static link

编译时就可以确定frame size
![img_52.png](img_52.png)
不是callee指向caller，而是编译时的高层指向低层
![img_53.png](img_53.png)
1. 深层调浅层的变量：向上移np-nx
2. 深层调浅层的函数：
3. 浅层调深层的函数：

### display

```
function printSquare(hasQueen:int)
function nQueens(N:int)
  function printBoard()
  function try(c:int)
```
![img_76.png](img_76.png)
![img_54.png](img_54.png)
### Lambda lifting
前面的local都传成参数
## Frame in tiger

### shift of view
???

### escape
深层访问浅层，看浅层变量是否escape

# Intermediate Representation(IR)
## design goal
different language(c++, python) to different backend(x86, arm)
## LLVM
local %
global, function @

virtual register cannot be overwritten or redefined
![img_55.png](img_55.png)
![img_56.png](img_56.png)
![img_58.png](img_58.png)

# instructiong selection
![img_90.png](img_90.png)
![img_91.png](img_91.png)

# global optimization
## liveness
### 单变量
1. 联合
![img_92.png](img_92.png)
2. use规则
![img_93.png](img_93.png)
3. define规则
![img_94.png](img_94.png)
4. 传递规则
![img_95.png](img_95.png)
前三个都是后面推导前面
![img_96.png](img_96.png)

### 多变量
![img_107.png](img_107.png)
![img_97.png](img_97.png)

## constant propagation
#### c 常量，# 不可达，* 不知道

### 四个传播规则
1. 前驱不知道，则不知道
![img_98.png](img_98.png)

2. 前驱有变化，则不知道
![img_99.png](img_99.png)
3. 前驱要么c要么#，则c
![img_100.png](img_100.png)
4. 都#则#
![img_101.png](img_101.png)
### 两个产生规则
5. ![img_102.png](img_102.png)
6. 因为是在一个函数里做全局分析，所以经过函数就是不知道
![img_103.png](img_103.png)
7. ![img_104.png](img_104.png)

# register reallocation
![img_105.png](img_105.png)
![img_106.png](img_106.png)

![img_108.png](img_108.png)
- simplify: 低度且move无关
- freeze: 低度且move相关
- spill: 高度
- worklistMove: 放的是move指令

- active_moves: 无法合并但还没冻结的
- constrained_moves: 无法合并的
- frozen_moves: 被冻结的

EnableMoves: 在simplify或combine之后，active_moves中的重新加入worklistMove

判断能否合并
![img_109.png](img_109.png)
![img_110.png](img_110.png)

## on tree
### simple
![img_131.png](img_131.png)
![img_132.png](img_132.png)
但其实只需要两个

### label
![img_133.png](img_133.png)

# GC
## mark and sweep 标记清扫式
![img_134.png](img_134.png)
![img_135.png](img_135.png)
H是堆大小，R是存活变量大小
May case stack overflow。dfs标记的时候不使用递归式写法，其中栈的写法有下面两种形式
1. explict stack 使用自己的栈
2. pointer reversal 用原指针代替栈
这种方法会导致存在外部碎片
## reference count
递归的record，在z从freelist中去掉(被alloc)时才回收z.x
强制要求不能成环，weak ref。检测环
![img_152.png](img_152.png)
## copying collection 复制式搜集
### Cheney算法：广度有限搜索
![img_136.png](img_136.png)
pro: no stack, no pointer reverse

cons: poor locality, irrelevant records are copied together
![img_139.png](img_139.png)
c是record的长度，除以是为了求均摊

### semi-depth first
![img_138.png](img_138.png)
![img_137.png](img_137.png)

## generation collection 分代搜集
从老指向新的指针很少，除非老对象b在创建很久之后才修改他的一个指针指向a，可以用三种方法记录。垃圾搜集开始时，下面的这些方法可以指出最新的地址修改。
- 记忆表/记忆集合：remember list/set record every cross-gen ref。编译器为`b.f1<-a`这样的指令添加一段代码，在运行时将b加入记忆表
- card marking：$2^k$大小的地址对应一个数组bit，当这个地址被修改，这个卡片就被标记
- page marking：如果卡片大小是一个页，就可以通过页表实现

![img_140.png](img_140.png)
每个老一代的空间都呈指数型增长，只对新代进行垃圾回收。

## incremental collection 增量式搜集
no need to pause
![img_141.png](img_141.png)
![img_142.png](img_142.png)
![img_143.png](img_143.png)
如果有白插入黑，则标灰白或标灰黑

### baker
![img_145.png](img_145.png)
![img_146.png](img_146.png)
新对象需要做特殊处理吗：不需要，他没有创建有用的ref。他如果指向一个旧对象，他并不会改变这个对象的生死，
因为这个ref都是别人传给他的。唯一例外是这个ref先放在栈上，然后原对象死亡，这个ref再赋给新对象。
这就需要黑或者白的处理。
![img_147.png](img_147.png)
分配多少空间，则需要扫描多少空间
![img_148.png](img_148.png)
不允许指向from-space，读一个白对象则马上变灰并co到to-space

floating garbage:
1. 已经标黑后，所有指向它的ref被删
2. garbage in new set

read-barrier 在编译器读一个指向白色对象的指针时，会立即标灰

write-barrier 在将一个黑色的记录的域写入白色记录指针时，将该白色记录标灰

都是防止黑指向白

### concurrent
![img_150.png](img_150.png)
加锁。mutate的时候collector没权限。

# gc in compiler

## allocate optime
![img_151.png](img_151.png)

![img_149.png](img_149.png)
## how can gc collector handle different type 
![img_111.png](img_111.png)
![img_113.png](img_113.png)
![img_112.png](img_112.png)

## root description
### 1. guess
![img_114.png](img_114.png)
### 2. Pointer map
包括temp、栈上的和callee saved regs

在alloc_record的时候GC之前、每次call都要生成pointer map

静态的编译时生成的结构

map上记录指针相对rsp的偏移
![img_115.png](img_115.png)

how about registers: 我们不仅应该记录他是否是指针类型，还需要能够恢复出它的值
![img_116.png](img_116.png)
![img_117.png](img_117.png)

![img_118.png](img_118.png)
![img_119.png](img_119.png)
![img_120.png](img_120.png)
![img_121.png](img_121.png)
caller记类型，callee如果spill则不记，否则复制map

![img_155.png](img_155.png)
对于这种函数我们不能插桩所以只能push到栈上

scanning: 将framesize放在map里，到达alloc_record的时候记录rbp

![img_154.png](img_154.png)
### corner case
#### 1. Derived Pointers
- 派生指针的中间结果可能指向非法的地址，因此扫描必须从原指针开始
- 派生指针存活，则原指针必须存活
- ![img_122.png](img_122.png)![img_123.png](img_123.png)
- ![img_124.png](img_124.png)

# Modern GC in Java
## Parallel Scavenge(PS)
![img_125.png](img_125.png)
from-to来回co
inplace较后的co到前

# Minor GC: Three Smi-spaces
![img_159.png](img_159.png)
Eden专门分配，To和From专门做copy，他们都是young区。
![img_126.png](img_126.png)
使用了一个promote来控制什么时候co到old区

如何并行: 
1. 分任务 ![img_160.png](img_160.png)
2. copy racing: compare-and-swap，罕见所以如果copy两份，删除其中一个
3. work stealing: 两个worker负载不均衡则分

## Major GC(空间小)
![img_127.png](img_127.png)
![img_128.png](img_128.png)
先cleanup一段区域，再co再clean

## problem
![img_129.png](img_129.png)
本来空间就大，并且算法本身也比他慢
![img_130.png](img_130.png)

#### fix time difference

mixed gc更灵活，所有young都回收，old区选择回收最快的。

使用concurrent marking来估计回收时间
![img_158.png](img_158.png)

write barrier保证old区指向回收old区的指针也在remember set里

# Functional programming
![img_156.png](img_156.png)

## pure-tiger
![img_157.png](img_157.png)

## inline
避免变量名相同

1. activation records
2. intermediate code
3. basic blocks and traces
   
   - trace 意思是把bb组织成连续的代码，因为我们用llvm所以没讲
4. instruction selection
5. liveness analysis
6. register allocation
7. put it all
8. gc
9. object-oriented language
10. functional language