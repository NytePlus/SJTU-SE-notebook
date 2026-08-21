# compiler
```bash
gcc -E test.c > test-pp.c (test-pp.c)
gcc -S test.c (test.s)
gcc -c test.c (test.o)
gcc -o test test.c  (test)
```

make
![img_61.png](img_61.png)

![img_170.png](img_170.png)
# bit
![img_54.png](img_54.png)

# storage
## data size
![img_49.png](img_49.png)

## virtual memory
![img_50.png](img_50.png)
![img_51.png](img_51.png)
![img_43.png](img_43.png)
## byte ordering
![img_52.png](img_52.png)
![img_53.png](img_53.png)
# encoding
![img_45.png](img_45.png)
unsigned

![img_46.png](img_46.png)

twos-complement

![img_44.png](img_44.png)

正数的范围是0到2^(w-1)-1，而负数的范围是-1到-2^(w-1)。

unsigned和singed比较，统一转成unsigned

**T2U(-2147483647) = 2^32-2147483647 = 2147483648**
![img_47.png](img_47.png)

size_t是unsigned
![img_48.png](img_48.png)

# operation
## multiplication
两个w位的bit-vector相乘的结果的前w位相同
![img_41.png](img_41.png)
example
![img_42.png](img_42.png)

| 4-bit              | ( x + y ) | ( x - y ) | ( x * y )                             | ( -y ) |
|--------------------|-----------|-----------|---------------------------------------|--------|
| ( x = 4, y = 7 )   | -5        | -3        | -4                                    | -7     |
| ( x = -6, y = -8 ) | 2         | 2         | 0                                     | -8     |
| ( x = 5, y = -1 )  | 4         | 6         | -5                                    | 1      |
| ( x = -3, y = 6 )  | 3         | 7         | **<span style="color:red">-2</span>** | -6     |
### -3 * 6解法
1. -3 * 6 = U2T(13 * 6 mod 16) = U2T(14) = 14 - 16 = -2
2. -3 * 6 = -18 = ~(0b10010) + 1 = 0b01110
trunc(0b01110) = 0b1110 = -2

# Machine-Level Representation of Programs
![img_31.png](img_31.png)
## registrer
![img_34.png](img_34.png)
![img_35.png](img_35.png)
32 bytes
![img_36.png](img_36.png)
![img_37.png](img_37.png)

## address
![img_38.png](img_38.png)

```
function(%rdi, %rsi, %rdx)
    return %rax
```
## Data movement

![img_39.png](img_39.png)
对于32位机器
- w 字(2 bytes) 16位
- d,l 双字 32位
- q 四字 64位
![img_40.png](img_40.png)
unsigned
![img.png](img.png)
signed
![img_1.png](img_1.png)
### example 1
![img_3.png](img_3.png)
- ![img_84.png](img_84.png)

### example 2
填充零还是一取决于原类型，如果是char则填充1，unsigned char则填充0
![img_166.png](img_166.png)
![img_167.png](img_167.png)
## Stack
%rsp register stack pointer

![img_5.png](img_5.png)
abc是局部变量但是不能放在寄存器里，因为有取地址

## Data manipulation
注意 
- sub S, D 是 D <- D - S被减数和存入的都在右侧
- sar算术右移（填上符号位），shr逻辑右移（填上零）
- idivq S右边有长整数除法

![img_6.png](img_6.png)
![img_7.png](img_7.png)
![img_8.png](img_8.png)

# control
%rip PC 64位
%eflag 32位

![img_9.png](img_9.png)

## change CD
%eflag 存condition codes 32位
- CF: carry flag
- OF: overflow flag
- ZF: zero flag
- SF: sign flag
![img_10.png](img_10.png)

非算术运算符修改CD

![img_11.png](img_11.png)
![img_55.png](img_55.png)
![img_12.png](img_12.png)

### 注意
cmp b, a
jg ...就是a>b则跳转

## read CD
![img_13.png](img_13.png)

## jmp
rep作为一个优化，不执行动作。
![img_14.png](img_14.png)

如果有lt_cnt和ge_cnt
![img_15.png](img_15.png)
如果没有，则会优化
![img_16.png](img_16.png)

## conditional move

源寄存器或内存地址S，目的寄存器R
![img_17.png](img_17.png)

destination must be register. source doesn't matter

不能用cmove，*xp始终会执行
![img_18.png](img_18.png)

when are the use of registers not saved
- Leave procedures
- Inter-procedure register allocation
- a1 is dead before f calls h()
- Register window

## jmp table

### c++伪代码：

&&可以取label的地址。index设置为unsigned可以让小于0的值上溢到一个很大数
![img_19.png](img_19.png)
![img_20.png](img_20.png)
jmp table in rodata

### 汇编:
![img_164.png](img_164.png)
![img_165.png](img_165.png)

## procedure call

store in stack
![img_161.png](img_161.png)

jmp with: return, pass data, local variable, register

caller: 调用者 callee: 被调用者
![img_21.png](img_21.png)

- call = push + jmp
- ret = pop + jmp
### example 1
![img_22.png](img_22.png)
![img_23.png](img_23.png)
push的时候%rsp减0x8八个byte
![img_24.png](img_24.png)

多于6个参数
![img_25.png](img_25.png)

#### example 2
![img_162.png](img_162.png)
因为每个变量都要取地址，所以都在栈上。前六个参数放在寄存器上。
![img_163.png](img_163.png)
参数必须8对齐，从右向左依次压栈

caller-save callee可以随便修改，caller保存才能恢复
- ![img_27.png](img_27.png)
callee-save 对于caller来说，callee不会修改这些值
- ![img_26.png](img_26.png)

![img_28.png](img_28.png)
example
![img_29.png](img_29.png)
![img_30.png](img_30.png)

# array

![img_56.png](img_56.png)

# Heterogeneous Data Structures
## struct & union
![img_57.png](img_57.png)

## align
![img_58.png](img_58.png)
最后整个struct的长度要被最大元素整除

### example
![img_59.png](img_59.png)
![img_60.png](img_60.png)

```cpp
char (*f)(int); 函数指针(8)

int (*up)[3]; 指向数组的指针(8)
```

# buffer overflow

## prevent
1. stack randomization
2. stack corruption detect: canary
![img_62.png](img_62.png)
3. limit excutable code region: stack not excutable

## return-oriented programming

# pointer
![img_63.png](img_63.png)
函数指针
![img_65.png](img_65.png)

![img_64.png](img_64.png)
![img_67.png](img_67.png)
![img_66.png](img_66.png)

# floating point
注意多算两位取整，bias是加不是减

## IEEE Float-point representation
![img_151.png](img_151.png)
![img_152.png](img_152.png)
![img_153.png](img_153.png)
![img_154.png](img_154.png)
--- 
### denormal
![img_155.png](img_155.png)
exp全零和只有一个1都是-126(?)
### 不是denormal
![img_156.png](img_156.png)
![img_157.png](img_157.png)
![img_158.png](img_158.png)

## op
![img_159.png](img_159.png)
round-to-even(os default): 四舍五入，但刚好是5则最终结果为偶数

round down: 向下取整

round up: 向上取整

### example: binary round-to-even
保留两位小数
![img_160.png](img_160.png)

### multiply
![img_176.png](img_176.png)
![img_177.png](img_177.png)

### addition
![img_178.png](img_178.png)
![img_179.png](img_179.png)
加法: 移动到大的E

### other operation
![img_172.png](img_172.png)
![img_173.png](img_173.png)
![img_171.png](img_171.png)
![img_174.png](img_174.png)
![img_175.png](img_175.png)

# exception

## event & exception
related: syscall, sysret, page fault, divide zero
因为执行了指令才发生的

unrelated: a system timer goes off, an I/O request completes
系统自动发生的

## exception handler
![img_90.png](img_90.png)

run in kernel mode(这个函数权限最高)

push necessary information onto kernel's stack: 
ret addr, RFLAGS, RSP，方便重启程序

为了提高性能syscall不需要

## exception table
![img_91.png](img_91.png)

入口地址写在一个寄存器里，表的每条只存一个jmp指令

## synchronous exceptions
### 1. Traps
主动发生特权态的切换，syscall, breakpoint traps

### 2. Faults
出错了但可以恢复，page faults
可以重新执行, protection faults

如果程序设置了处理这些异常的逻辑，则可以继续执行

### 3. Aborts
不是故意的且无法恢复的, parity error, machine check

## asynchronous exceptions(interrupts)
![img_92.png](img_92.png)

键盘按下、网卡接受信息都是向cpu发一个interrupt

## How CPU Access IO Devices
![img_93.png](img_93.png)
mm-io将每个IO设备的地址都映射到一个地址

p-io是两个in、out接口分别读入、写入io设备

![img_94.png](img_94.png)
![img_95.png](img_95.png)
DMA数据搬运的过程不需要cpu参与
![img_96.png](img_96.png)
最后通过interrupt告诉cpu传输完毕

# process

## How to concurrent
1. Interleaving
2. virtual address

## context switch

context contain
![img_97.png](img_97.png)

在timer中断、read、sleep时会触发

![img_68.png](img_68.png)
## scheduler(a chunk of kernel code)
![img_98.png](img_98.png)

## three state
![img_69.png](img_69.png)

running -> stop: SIGSTOP

stop -> running: SIGCONT

all -> terminated: 
![img_99.png](img_99.png)

stdio.h(libc)的出错返回值是-1，并且设置errno。
printf是对系统调用write的封装，
比如syscall write返回-2则printf返回-1并且设置errno=2
![img_100.png](img_100.png)

## state switch
![img_70.png](img_70.png)

## api
```c++
pid_t getpid(void);
pid_t getppid(void); // 获取父进程的pid
void exit(int status);
pid_t fork(void);
```
## Fork
调用一次返回两次，子进程返回0，父进程返回子进程的pid(如果没创建成功则返回0)
![img_101.png](img_101.png)

![img_71.png](img_71.png)
A -> syscall -> syscall_handler -> sysret -> A or B
假如A的时间片刚好用完了，那么就会返回B

## reap child process
![img_72.png](img_72.png)
父进程terminated之后，init进程才会回收。

如果是一个long running的进程，父进程一直存在，不能让init掌管回收

## waitpid
```cpp
pid_t waitpid(pid_t pid, int *status, int options);
pid_t wait(int *status);
unsigned int sleep(unsigned int secs);
int pause(void);
```
![img_73.png](img_73.png)
![img_102.png](img_102.png)

![img_75.png](img_75.png)
![img_74.png](img_74.png)
![img_76.png](img_76.png)

### 正常退出
![img_81.png](img_81.png)
### 信号退出
![img_82.png](img_82.png)
### 是否是block而不是terminal
![img_83.png](img_83.png)

![img_77.png](img_77.png)
![img_103.png](img_103.png)
sleep返回睡眠的剩余时间。pause是一直暂停直到接受到一个任意未被忽略或阻塞信号

## execve
创建一个进程
![img_78.png](img_78.png)

### 环境变量和参数存储
![img_88.png](img_88.png)
![img_89.png](img_89.png)
存在stack上，不存在data段因为data段是来源于程序。
比如ls -lt，只有ls是程序
### 设置环境变量
![img_79.png](img_79.png)

## signals
![img_85.png](img_85.png)
![img_86.png](img_86.png)

## sending signal
![img_87.png](img_87.png)
![img_105.png](img_105.png)
the kernel sends a signal to a dst
by updating some state in the context of the dst process

```cpp
while(...){
    recv();
    ...
}
```
这种实现方式无法做到及时响应，并且大多数时间没有收到信号但是还是会读内存，
同时两个进程无法共享内存。

程序如果不是一个循环，该在哪里进行recv

send signal for two reason:
1. kernel detect a system event
2. a process invoked the kill function

![img_80.png](img_80.png)

unix一种信号只能pending一个，后来的会被简单地丢弃

屏蔽信号，则接受的信号会pending，但是系统不会要求他响应，直到unblock

![img_104.png](img_104.png)

A send signal to B

A kill -> os -> A -> ... -> os -> B(要求B响应)

os在决定开始进行B进程之前会检查pending bit和block bit，要求B响应。
如果有多个，则选择某一个/全部，取决于实现

![img_106.png](img_106.png)
自己给自己发

## process group
![img_107.png](img_107.png)
默认子进程和父进程在同一个进程组

setpid(0, 0)则当前进程创建一个进程组，编号为自己的pid

ctrl-c SIGINT![img_109.png](img_109.png)

ctrl-z SIGTSTP![img_108.png](img_108.png)
暂停，默认就是所有前台变成后台

## receive signal
除了SIGSTOP, SIGKILL之外的信号可以修改handler
![img_110.png](img_110.png)
![img_111.png](img_111.png)
SIG_IGN忽略的, SIG_DFL默认的
![img_112.png](img_112.png)
handler要回到os怎么回: 在栈上放一个返回地址

![img_113.png](img_113.png)

![img_114.png](img_114.png)
![img_168.png](img_168.png)
## concurrent
handler的开始应该保存一个errno
![img_115.png](img_115.png)

### example
![img_116.png](img_116.png)
![img_117.png](img_117.png)
![img_118.png](img_118.png)
一个子进程先退出，父进程执行handler，清空pending vector并设置block vector为1，
这时候第二个子进程退出了，设置pending vector为1，在handler还没结束时第三个子进程退出，pending bit重叠。
handler结束，设置block vector为0

![img_169.png](img_169.png)
有些系统，在调用可能阻塞的系统调用（如read）时会被打断

![img_119.png](img_119.png)
设置handler被打断之后做什么

# I/O

## Unix I/O
![img_120.png](img_120.png)

fflush(stdout) 将缓冲区数据立马写入输出流

two file type: regular file, directory, socket
![img_121.png](img_121.png)

程序获得自己所在路径通过环境变量

## Open File
0 stdin, 1 stdout, 2 stderr

返回最小的非负整数，每个进程都有独立的fd(两个进程同时open，都返回3)

为每一个打开的文件维护一个数据结构，存储position
![img_122.png](img_122.png)

V-node table是inode table在内存里的cache，存储file静态原数据。

fork的子进程会复制fd table，从而指向同一个open file table，增加它的refcnt。refcnt为0的时候os自动回收

![img_123.png](img_123.png)
![img_124.png](img_124.png)

## Reading and Writing File
![img_125.png](img_125.png)
### short count
![img_127.png](img_127.png)

![img_126.png](img_126.png)

## Reading metadata
![img_128.png](img_128.png)
![img_129.png](img_129.png)

## Reading directory
![img_130.png](img_130.png)

![img_131.png](img_131.png)
一个读f一个读o，因为指向同一个file struct
![img_132.png](img_132.png)

## I/O Redirection
![img_133.png](img_133.png)
![img_134.png](img_134.png)
![img_135.png](img_135.png)

如果我们要保存stdout
![img_136.png](img_136.png)

![img_137.png](img_137.png)

# Process Scheduling

Mechanisms(机制): 需要进程切换

Policies(策略): 如何进程切换

## 1. Workload 1
![img_138.png](img_138.png)
![img_139.png](img_139.png)

---
* not at the same time
### FIFO
长任务先到达就不好

---
* not run to completion
### Shortest Job First(SJF)

### Shortest Time-to-completion First(STCF)
![img_140.png](img_140.png)

### Round Robin
![img_141.png](img_141.png)
![img_142.png](img_142.png)

---
* not only use CPU

![img_143.png](img_143.png)

---
* don't know run time
### Multi-Level Feedback Queue(MLFQ)
根据任务历史估计一个进程的io使用、运行时长
![img_144.png](img_144.png)
![img_145.png](img_145.png)
给你一些时间片如果很快用完了，就说明是long-running的，分配小优先级。
如果是interactive任务，则优先级高，降低response time和turnaround time。

![img_146.png](img_146.png)

#### problem
![img_147.png](img_147.png)
低优先级一直无法执行。如果时间片接近用完就进行io，则优先级最高，接近于独占cpu

PELT: 在一段时间片里面测量究竟占用多少cpu

解决starvation和行为改变
![img_148.png](img_148.png)

解决欺骗：第一次用了99，在下一次只要用了1就降低优先级
![img_149.png](img_149.png)
![img_150.png](img_150.png)
