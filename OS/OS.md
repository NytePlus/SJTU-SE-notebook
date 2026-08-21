# 概论
论文是把钱变成知识，创业是把知识变成钱

openai: 过程中rewarding，在解题过程的每一个步骤都要rewarding，成本高

deepseek: 只看结果，也能训出很好的结果

安卓本身是不是linux：安卓内核用的linux的kernel+一些libc库，在加上了一些硬件的东西如GPS（电脑设备一般没有），安卓的进程间交互有更高的api（而不是简单的sysccall和文件）

java虚拟机在安卓里面是os的一部分，因为应用程序要在里面跑。而在ubuntu里面不是

## 是os？
window 10所包含的所有软件

linux内核及所有设备的驱动

在macbook上下载的第三方NTFS文件系统

华为Mate 30出厂时所有的软件

大疆无人机出厂时所有的软件

火星车上运行的软件

运行在用户态的I/O框架？不一定

运行在内核里的就是？不一定

## 操作系统是在硬件和应用之间的软件层

## 为什么要有操作系统
操作系统不是理论上需要，而是工程上发现需要

特权操作：调时间、关中断、格式化磁盘，一个应用不能影响其它应用，所以需要特权操作，这就决定了os不能以一个库的形式存在，必须独立存在

![img.png](img.png)
需要操作系统，所以不需要系统管理应用、不需要特权，os存在的目的就是抽象硬件，叫做libOS

unikernel：一个os只保留几个syscall作为function call，只跑一个应用，缺点是定制化太高了

![img_1.png](img_1.png)
比如数据库希望将索引写在最外圈。硬盘存储在最外圈性能最高。这个时候就不需要了，但是重新写网络协议很复杂

# 操作系统架构

## 降低操作系统复杂性

策略与机制分离
![img_2.png](img_2.png)

## 宏内核(Monolithic Kernel)

![img_3.png](img_3.png)

![img_4.png](img_4.png)
隔离机制：一个程序员写错了，不会影响其它模块运行。

linux的kernel代码占了50%，是bug重灾区且bug都是引起系统崩溃的

## 微内核(Micro Kernel)

![img_5.png](img_5.png)

用奥卡姆剃刀原则：文件系统、驱动都拿出去，只剩下进程和调度

function call很快，只有10个cycle，但一旦要进出kernel就慢了

### example
![img_6.png](img_6.png)

Mach微内核

L3/L4极大提升IPC的性能

seL4：被形式化证明的微内核，8700行代码bug-free

原生鸿蒙也是微内核，但是性能还是太差，所以还是放回了很多东西到内核来

QNX Neutrino：Quick UNIX广发用于交通、能源、航天航空

很长一段时间手表的os是android ware，后来android ware没人维护了，造手表的又只有三星但他不开源，现在手表厂商开始选择鸿蒙

Google有os坟场之称，开发了很多os但最后都没下文

MINIX 用在intel的me模块

![img_7.png](img_7.png)
![img_8.png](img_8.png)

如何让unix兼容海思？先让华为成为unix贡献第一（以前是IBM，intel），然后培养maintainer，然后出现俄罗斯maintainer被diss的新闻，所以全面坚定自己开发鸿蒙

## 混合内核架构

喷果粉：你这个才2G内存，别人cpu跑分都。。。

果粉：但他滑动很丝滑

苹果在处理页面滑动时会使用所有cpu资源

### Windows NT

### maxOS
kernel是Mach

## 外核架构(Exokernel)
![img_9.png](img_9.png)

如何分配cpu，应用关中断怎么办？因此应用会申请一个timer，在这段时间里应用会清楚地知道他的任务分配和cache，之后主动释放

如何分配disk。os直接提供物理地址，但是不能改变别人的页表

应用通过libOS使用默认的，或者可以自己定义自己的

将操作系统的两个功能服务应用和管理应用分配给libOS和Exokernel

### Unikernel
只有一个应用+libOS，跑在内核态

![img_10.png](img_10.png)

## 多内核/复内核(multikernel)

### 背景

os内部维护很多共享状态，cache一致性越来越难。

GPU等设备越来越多，很多设备有自己的cpu，通过系统总线连接

### 思路

默认的状态是划分而不是共享，维持多份状态的copy而不是一份状态，显示核间通信

每个core上运行一个小内核，os整体是一个分布式系统，应用程序运行在os之上

## 对比
![img_21.png](img_21.png)

### 图形界面在内核态还是用户态
![img_22.png](img_22.png)

# 中断、异常、系统调用

## ARM

![img_23.png](img_23.png)

```
VBAR_EL1
ESR_EL1
FAR_EL1
```
![img_24.png](img_24.png)

函数调用
![img_25.png](img_25.png)
![img_26.png](img_26.png)

x86-64系统状态寄存器
![img_37.png](img_37.png)

ARM系统状态寄存器
![img_38.png](img_38.png)

x86-64的系统控制寄存器
![img_27.png](img_27.png)

ARM控制寄存器
![img_29.png](img_29.png)

MMIO和PIO
![img_28.png](img_28.png)

## ARM中断与异常处理
![img_30.png](img_30.png)
![img_31.png](img_31.png)

异常向量表
![img_32.png](img_32.png)
如果表项不够，可以分层表
![img_33.png](img_33.png)
![img_34.png](img_34.png)

## 内核态和用户态的切换
![img_35.png](img_35.png)
x86-64缺页异常错误地址放CR2
![img_36.png](img_36.png)

## 系统调用
eret: 从内核态返回用户态
![img_39.png](img_39.png)

![img_40.png](img_40.png)

svc: 从用户态进入内核态。存入ELR_EL1的是当前指令的下一条，并且不需要设置ESR_EL1
![img_41.png](img_41.png)
内核态能不能系统调用？可以调用，不需要换栈

系统调用
![img_42.png](img_42.png)
![img_43.png](img_43.png)

### 寄存器放不下参数怎么办
![img_44.png](img_44.png)

### 如何验证用户态的指针合法性？
需要检查指针是否来自所有的合法内存区域(VMA)

Linux仅仅检查是否在最大的VMA间，依然可能不合法。
在内核态发生非法内存访问，一般会认为是内核bug而触发oops，kill掉相关进程

## 访问用户态内存的一组routinue
![img_45.png](img_45.png)

## VDSO(Virtual Dynamic Shared Object)
![img_46.png](img_46.png)

## FLEC-SC
切换状态会污染cache，能否不切换状态进行系统调用。引入 system call page ，由 user & kernel 共享
调用和执行解耦，用户态push多个syscall，然后内核态pull所有syscall执行，执行结果写回共享空间。时延敏感则不行

## EBPF & SYSCALL
内核虚拟机运行沙箱
![[Pasted image 20250609195654.png]]
# 初始化

## kernel启动的两个主要任务
两步都是写寄存器，写TDBR和异常向量表
### 1. 配置页表开启虚拟内存机制，允许使用虚拟地址

一旦MMU开启，地址向cpu拿，硬件都会做翻译，所以内核都使用虚拟地址

### 2. 配置异常向量表，打开中断

## 树莓派
上电之后真正运行的第一行代码:0x0地址运行firmware(也叫bootloader)，然后再去初始化CPU,SDRAM等，最后加载内核、根文件系统到内存

树莓派第一行代码由GPU运行，因为GPU是他们自己做的，CPU是买的

CPU从预定义的RAM地址读取第一行代码，由硬件厂商决定

### 0. 内核代码前
![img_47.png](img_47.png)

### 1. 编译启动代码
![img_48.png](img_48.png)
ChCore启动代码，涉及到boot和kernel两个目录，boot段翻译后放在elf文件.init段，kernel放在.text段。因为boot只执行一次，cpu在执行之后可以取消映射节约内存

### 2. 准备进入EL1
```
EL0	用户模式
EL1	操作系统内核模式
EL2	虚拟机监控程序模式
EL3	安全监控模式
```

初始时CPU运行在EL3

```
FUNC(_start)
    cpu编号放x8
    cbz x8, primary
    
wait_for_bss_clear:

wait_until_smp_enabled:
    
    换栈?
    
primary:
    bl arm64_elX_to_el1
    设置启动时栈，用于C函数调用
    bl init_c
        
FUNC(arm64_elX_to_el1)
    mrs x9, CurrentEL
    
    根据x9跳转到对应分支

    设置SCR_EL3(NS,HCE,RW)
    设置ELR_EL3, SPSR_EL3(DAIF)
    eret(跳到.Ltarget)
    
.Ltarget:
    ret
```

启动时栈示意图，内核栈4k
![img_49.png](img_49.png)

```
void init_c(void)
{
    clear_bss()
    
    early_uart_init()
    
    init_boot_pt()
    
    el1_mmu_activate()
    
    start_kernel()
}

void init_boot_pt()
{
    设置ttbr0(低地址)页表，分为三级
    映射内存地址 
    映射设备地址 
    
    设置ttbr1(高地址)页表，分为三级
    映射内存地址
    映射设备地址 
    //DEVICE_MEMORY(non-cachable, 设备地址都是一些寄存器，映射完了之后你什么都不写他也会改，所以cache没意义)
}
```

树莓派物理地址划分
![img_50.png](img_50.png)
```
FUNC(start_kernel)
    换栈
    bl main(低地址跳到高地址)

FUNC(el1_mmu_activate)
    ???
    
    将页表的物理地址写入ttbr0和ttbr1

    mrs x8, sctlr_el1
    将x8某些bit设为1(开关)
    mrs sctlr_el1, x8 
    //这一步之后所有地址都变成虚拟地址，但是pc+1所在的虚拟地址和物理地址相同
```

开启页表之后
![img_51.png](img_51.png)

异常向量表初始化（kernel/main.c）

```
void main()
{
    ...
    
    arch_interrupt_init();
}
   
void arch_interrupt_init()
{
    arch_interrupt_init_per_cpu()
}

void arch_interrupt_init_per_cpu()
{
    set_exception_vector()
}

FUNC(set_exception_vector)
    adr x0, el1_vector
    msr vbar_el1, x0
    ret
    
EXPORT(el1_vector)
```

# 虚拟内存管理

## IBM 360的内存隔离
内存划分为2kb内存块，一个内存块一个key寄存器，检查与应用key相同。

不能使用绝对地址
![img_52.png](img_52.png)

## RISC-V物理内存隔离

## 物理地址的缺点
![img_53.png](img_53.png)

![img_54.png](img_54.png)
## 分段机制
![img_55.png](img_55.png)
或者更细粒度的分段
![img_57.png](img_57.png)
可以更好地共享
![img_56.png](img_56.png)

## 分页机制
硬件视图：
1. 一个CPU核有一个TLB
2. 页表基地址是物理地址
![img_58.png](img_58.png)

![img_59.png](img_59.png)
![img_60.png](img_60.png)
![img_61.png](img_61.png)

### level 3页表项
![img_62.png](img_62.png)
![img_63.png](img_63.png)

### level 0,1,2页表项
![img_64.png](img_64.png)

## TLB(translation lookaside buffer)
虚拟页到物理页的映射

### TLB flush
![img_65.png](img_65.png)

### 如何避免
![img_66.png](img_66.png)
映射不一致，一定需要flush

一个进程一个asid，如果进程数超过2^8，可以为两个进程分配同一个asid

### 多核
![img_67.png](img_67.png)

## 段和VMA

### 添加VMA

VMA记录进程可以访问的虚拟地址。数量少时用链表，多时用红黑树
![img_68.png](img_68.png)

### 什么时候添加VMA
1. os创建应用时分配
![img_69.png](img_69.png)

2. 进程主动申请
![img_70.png](img_70.png)

### 延迟映射/按需调页(on-demand paging)
![img_71.png](img_71.png)

如何判断缺页异常的合法性：落在VMA区域则合法否则非法

![img_72.png](img_72.png)
第一种不在VMA里，后两种都在。可以在VMA里存储一个hash表记录被换出的，或者在页表项的某些位表示被换出

### mmap
![[Pasted image 20250609205657.png]]
用来将磁盘空间映射到用户内存。应用调用mmap，内核将对应的文件信息记录在V-NODE中。
应用访问时触发pf，并且将文件内容写入页缓存中，建立用户页表映射到对应物理内存。调用close或msync同步到磁盘中。msync过程中宕机无法维护原子性
![img_73.png](img_73.png)
页表项放磁盘地址

mmap优化：
1.prefault: 预取pf的页之后的几个页
2.一次mmap将所有的文件内容建立映射

![img_74.png](img_74.png)
1.匿名映射：不关联任何文件，直接分配一块虚拟内存，通常用于进程的堆（如 `malloc` 可能底层使用 `mmap`）、共享内存或大块内存分配。
文件映射：将文件的一部分或全部映射到进程的虚拟地址空间，使得读写内存就像读写文件一样（由操作系统自动处理磁盘 I/O）
2.不需要
3.可以

## 虚拟内存其它机制
### 共享内存
节约内存，如共享库

进程通信，传递数据

### 写时复制
fork

### 内存去重
基于写时拷贝，在内存中扫描具有相同内容的页执行去重。
由操作系统发起，对用户态透明

### 内存压缩
![img_75.png](img_75.png)

### 大页
![img_77.png](img_77.png)
一个L3管理16k / 8 * 16k = 32M，所以大页是32M
![img_76.png](img_76.png)

## 虚拟内存优势
高效使用物理内存，简化内存管理，更强的隔离和更细粒度的权限控制

为什么虚拟内存是必要的：很多人觉得物理内存是不够的，所以需要虚拟内存。最早的时候还是为了隔离

其实地址翻译是很慢的，如果TLB miss的话一次访存会变成多次访存。
![img_80.png](img_80.png)
1.一个进程对应一个页表、task和mm结构、内核栈
2.内核区域映射了全部DRAM区域（好像也可以说全部物理内存，但是物理内存还包括很多设备内存）
3.内核区域有所有进程一样的部分
![img_81.png](img_81.png)
task_struct是什么，mm_struct是什么

# 物理内存管理

## 分配物理内存：由os负责
![img_78.png](img_78.png)
内核使用kmalloc时立即分配物理地址

## 内核启动：Direct Mapping
1.物理地址通过加上偏移量转换成虚拟地址
2.可以使用大页映射，节约TLB项确保可以存在TLB中提高效率

## 触发on-demand paging
![img_79.png](img_79.png)
所有DRAM内存都被映射到了虚拟地址高地址（内核），因此内核通过访问自己的虚拟地址，找到可以分配的物理地址，进行分配。

### 使用bitmap进行管理: 外部碎片

物理内存分配器的指标：资源利用率，分配效率
### 伙伴系统
```
void init_buddy()
{
    for() allocated=1, order=0;
    for() init_list(free_list[order]);
    for() buddy_free_pages(page);
    //需要先将每一页标记为已分配，再释放合并。这样会损失效率，但是工程上合理，因为页的数量不确定也不一定是2的幂次
}

struct physical_page
{
    int allocated;
    int order;
    list_node node;
    struct slab *slab; //标识是否是slab分配的
}
```

### SLAB
伙伴系统以页为粒度，内核分配的基本上是dentry，容易产生内部碎片

slab只分配固定大小的块（2^n, 3<=n<12），每个块使用内存池，使用best fit定位内存池

一个slab用完后，使用伙伴系统再分配一个slab。当一个slab全部释放则还给伙伴系统

vmalloc：内核的on-demand paging。适用于内核也需要大片内存时

## 换页
![img_82.png](img_82.png)
利用页表项记录按需分配还是需要换入

### 何时换页
![img_83.png](img_83.png)
高低水位线之间：空闲换页
最小水位线：暂停所有应用，强制进行回收（如果kmalloc都失败了那内核就崩了）

### 代价
优势：突破物理内存容量限制
劣势：缺页异常+磁盘操作导致访问延迟增加

## FIFO:
Belady's Anomaly资源增加性能变差

## Second chance

![img_11.png](img_11.png)

为什么这种策略没有belady's anomoly

## LRU

![img_12.png](img_12.png)

## 时钟算法

![img_14.png](img_14.png)

kmalloc分配的虚拟地址就是物理地址加偏移量，kmalloc的数据不会被swap，内核的内存不会swap（用户态的页表也属于内核）

一个进程一个页表，进程切换改变TTBR0_EL1值

os访问一个虚拟地址，会在页表项PTE中打上access bit。VA kernel也有一个页表，映射一个大页。
![img_13.png](img_13.png)

## Thrashing Problem与工作集模型
![img_15.png](img_15.png)
![img_16.png](img_16.png)

# CHCORE案例

## 内核启动时启用虚拟内存
x86页表寄存器CR3，arm低地址TTBRO_EL1，高地址TTBR1_EL1
- 如果虚拟地址的最高位是 `0`，MMU 使用 `TTBR0_ELx` 对应的页表（用户空间或内核低地址映射）。
- 如果最高位是 `1`，MMU 使用 `TTBR1_ELx` 对应的页表（内核高地址映射）

![img_17.png](img_17.png)

## 进程创建

### 创建虚拟地址空间vmspace

![img_18.png](img_18.png)

如果一个核的tlb miss突然上升了：一定是因为TLB flush。可能是因为进程太多两个进程被附上了同样的asid。
每个核有自己的TLB，如果两个相同asid进程在同一个核上跑，那么TLB flush就会上升(虚拟空间是一样的)

vmregion有
![img_20.png](img_20.png)

```
int vmspace_int(struct vmspace *vmspace)
{
    init_list_head(&vmspace -> vmr_list);
    vmspace -> pgtbl = get_pages(0); //内核和应用要内存都是用get_pages
    
    arch_vmspace_init(vmspace);
    
    pmo_init()
    ...
    ret = vmspace_map_range()
}

void pmo_init()
{
    case PMO_DATA:
    case PMO_ANONYM:
    case PMM_SHM;
}    

int vmspace_map_range()
{
    case DATA:
        fill_page_table->msp_tsnhr_in_hgtbl
    case 
}

int add_vmr_to_vmspace()
{
    //检查重叠并加入
}

int fill_page_table()
{
    ...
    msp_range_int_bgtbl()
}
    
int msp_range_in_pgtbl()
{
    // |<- 16 ->|<- 9 ->|<- 9 ->|<- 9 ->|<- 9 ->|<- 12 ->|
    
    total_page_cnt = len / PAGESIZE + (len % PAGESIZE ? 1: 0)
    ...
    while(total_page_cnt > 0):
        ret = get_next_ptp //l0
        ret = get_next_ptp //l1
        ret = get_next_ptp //l2
        
        for(i = pte_index; i < PTP_ENTRIES; ++ i):
            set_pte_flags
            total_page_cnt -= 1
}

void set_pte_flags() //填写页表flag

int get_next_ptp() //主机遍历页表，如果不存在则分配或报错
    
```
![img_19.png](img_19.png)

### 缺页处理
```
void do_page_fault()
{
    fault_addr = get_fault_addr();
    case XXX:
        handle_trans_fault()
}

int handle_trans_fault()
{
    vmr = find_vmr_for_va
    if(vmr == NULL) //segmentation fault
    
    switch(pmo -> type)
        case ANONYM: //pmo是空的
        case SHM:
            commit_page_to_pmo//在radix_tree中记录物理页信息
            map_range_in_pgtbl//填写页表
}
            
```

页表放在内存里面，他就有另一个页表来翻译它的地址。

地址翻译由硬件完成，填页表由os完成。

kmalloc、slab都调用getpage

```
struct vmspace {
        /* List head of vmregion (vmr_list) */
        struct list_head vmr_list;
        /* rbtree root node of vmregion (vmr_tree) */
        struct rb_root vmr_tree;

        /* Root page table */
        void *pgtbl;
        /* Address space ID for avoiding TLB conflicts */
        unsigned long pcid;

        /* The lock for manipulating vmregions */
        struct lock vmspace_lock;
        /* The lock for manipulating the page table */
        struct lock pgtbl_lock;

        /*
         * For TLB flushing:
         * Record the all the CPU that a vmspace ran on.
         */
        unsigned char history_cpus[PLAT_CPU_NUM];

        struct vmregion *heap_boundary_vmr;

        /* Records size of memory mapped. Protected by pgtbl_lock. */
        long rss;
};
```

---
# 进程
## 进程声明周期

![[Pasted image 20250610010551.png]]

## 如何表示进程：进程控制块(PCB)

进程控制块存储在内核态：不能让用户访问为了安全

至少包含：独立的虚拟地址空间、独立的执行上下文

```
struct PCB
{
    struct process_ctx *;
    struct vmspace *; //包括了该进程TTBR0_EL1
    sturct stack *; //包含SP_EL1，内核栈
}

struct process_ctx
{
	u64 x0, x1, ..., x30;
	u64 sp_el0;
	u64 elr_el1, spsr_el1;
}
```

使用execve执行，一般在fork之后调用，因为在调用execve后会重置地址空间。我的理解就是创建一个子进程加载代码运行的场景

copy-on-write:给每个页都标记为只读，给每个VMA都标志私有的写时复制。当子进程写时会copy并将copy的部分标为读写。

此时父进程对于该区域还是只读，是否需要标为读写？如果不标，之后在写时再改，这样再次fork可以少标一次只读。

父进程改页表是麻烦的，因为只要在一个核上跑过就有可能留有项，需要tlb shootdown将所有核的tlb都flush。子节点不需要因为肯定没跑过。
![img_84.png](img_84.png)

vfork：父子进程间共享同一地址空间。只能用在fork+exce场景，共享地址存在安全问题。

![img_85.png](img_85.png)

# 线程

![img_86.png](img_86.png)

静态部分由进程提供，线程只包含运行时的状态（主要是栈和寄存器，寄存器在cpu上，栈由一个寄存器指向）

每个线程有自己的内核栈和用户栈

一个三线程的进程的一个线程调用fork，只会多一个线程的进程：栈存在但执行流只有一个

如何让一个线程调用fork出三个线程：在一个点保存三个状态，在fork之后再跑多线程

## 线程模型
### 概念：用户态线程与内核态线程
用户态线程不能被调度所以不能并行，让它绑定到内核态线程上。如何绑定称为**线程模型**
![[Pasted image 20250609215605.png]]
多对一：不合理，一个io所有线程阻塞
![img_87.png](img_87.png)

一对一：
![img_89.png](img_89.png)

多对多：
![img_88.png](img_88.png)

### TCB
![img_90.png](img_90.png)

## 线程本地存储(TLS)
![img_91.png](img_91.png)
创建线程时将线程对应基地址写入寄存器，之后的访问地址会加上这个基地址

![img_92.png](img_92.png)

# 进程切换
线程切换只需要改内核栈
![img_93.png](img_93.png)
内存的状态和内核分开，不会被覆盖

为什么内核栈不能用用户栈：相互隔离增加安全性

寄存器存储到另一个寄存器为什么必须由硬件实现：比如PC的保存，如果软件实现则它一定处在内核代码中，而我们需要它在原位

![img_94.png](img_94.png)

## 切换过程
### 1. P0进入内核态 2. P0保存上下文
### 3. 地址空间切换：P1改TTBR0_EL1
![img_95.png](img_95.png)
TTBR1_EL1不变，TTBR0_EL1改变

```
switch_vmspace_to(pcb1 -> vmspace);
//写入物理地址，刷新tlb
```
这里是切换用户态页表，所以内核代码正常运行。内核有自己页表

线程切换和进程切换唯一区别；不需要地址空间转换
### 4. 切换内核栈：P1改内核栈SP
将p1的内核栈地址赋给sp
### 5. 切换到P1上下文：P1恢复上下文 6. P1返回用户态eret

# 纤程
一对一模型的实现
![img_97.png](img_97.png)

用户态线程
![img_98.png](img_98.png)
![img_99.png](img_99.png)
![img_100.png](img_100.png)
![img_101.png](img_101.png)

缺点：不能并行，编码麻烦

# 调度

## 调度器目标
![img_102.png](img_102.png)

## 策略
### first in first serve: 先来先服务

### shortest time first: 最短时间的最先

### round robin: 每个任务分配固定时间片

### multi-level queue: 
![img_103.png](img_103.png)

![img_104.png](img_104.png)
![img_105.png](img_105.png)
![img_106.png](img_106.png)

静态优先级策略都会导致低优先级任务饥饿

### multi-level feedback queue
目标：无先验知识，周转时间低、响应时间低，调度开销低

优先级相同的任务round robin，优先级高的先运行。给定时间片用完则降低优先级。

可能会导致低优先级任务饥饿，在某个时间段后将所有任务优先级提升到最高

在时间片用完前一点执行io，实现独占cpu。放弃cpu之后时间片不重置

## 公平共享调度
### Lottery Scheduling
每个任务有自己的ticket，每次调度时生成随机数，落在哪个区间就执行哪个任务

份额影响任务对cpu的占用比例，不会饿死。优先级影响顺序，可能会饿死

### Stride Scheduling
确定性版本的彩票调度，

![img_107.png](img_107.png)

份额小的步幅大迈得远，因为每次挑走的最短的，所以他吃亏

## 多核调度
同一个进程的线程之间可能有依赖关系

### Gang Scheduling

在多个cpu上运行同一个进程的线程，如果线程数超过cpu数那就还是串行
![img_108.png](img_108.png)

全局使用一个调度器的问题
![img_109.png](img_109.png)
读全局调度器需要加锁，并且希望同一个线程尽可能不要换cpu

Two-level Scheduling
![img_110.png](img_110.png)
通过work-stealing维持负载均衡

### 如何定义任务的负载
![img_111.png](img_111.png)

### 亲和性(Affinity)
系统接口指定cpu核
![img_112.png](img_112.png)

## IPC(Inter-Process Communication)

![img_113.png](img_113.png)
管道：单向，父进程需要一个读一个写。可以通过fork之后dup2，让子进程一个写一个读

套接字：为什么要引入socket，它的send、receive和read、write不是一样的吗。socket不得不引入listen、accept
两个进程就可以走本地socket不走网卡

### IPC接口类型
![img_114.png](img_114.png)

### 简单IPC实现
![img_115.png](img_115.png)
![img_116.png](img_116.png)
![img_117.png](img_117.png)
RPC是同步的
![img_118.png](img_118.png)

两阶段：建立通信，进行通信

消息一般不包括指针，如果包括也只能指向mmap映射的虚拟地址内

![img_119.png](img_119.png)

### 基于共享内存的问题
#### kernel bypass
比如收发网络包，os只负责将网卡内存映射到用户空间，只要写就能发包。这样不经过os就能发包，但接受包需要轮询。

#### tocttou(time of check to time of use)
共享内存，假如接受方使用
```
if(*p > 256)
    error
for(int i = 0; i < *p; i ++)
    ...
```
那么发送方可以通过检查之后修改长度值造成越界

![img_120.png](img_120.png)

IPC控制流：同步或异步

连接抽象：直接通信（接受者发送者互相知道身份），间接通信（一个邮箱）

权限检查：

进程创建时会将user写入PCB（从bash命令开始，他和子进程的user都是你）

PCB有一个capability list，进程A调用B时，内核检查它的capability list。
A可以将自己的capability给别人。进程通过capability id操作，内核管理它的表但进程无法看到，像fd
![img_121.png](img_121.png)

IP的命名服务
![img_122.png](img_122.png)
FS给naming service所有权限以及复制权限的权限，naming service给所有进程分发

### 管道
间接方式基于管道`ls|grep`
![img_123.png](img_123.png)
![img_124.png](img_124.png)

### 共享内存
![img_125.png](img_125.png)

### 消息队列
![img_126.png](img_126.png)
![img_127.png](img_127.png)

### 轻量级远程方法调用
减少切换时间：减少上下文保存、copy、中间调度其它任务的时间

（这里的client和server是两个进程，不是两个主机）client使用Server的代码、数据和权限。只切换地址空间、权限表，不做调度和线程切换（沿用栈）

参数栈A-stack被同时映射，执行栈E-stack在server端（可能有多个，可以被多个client连接）

寄存器不需要保存和恢复

![img_128.png](img_128.png)
- 参数栈是client和server都需要看见的，运行栈不需要client看见
- 进出内核的开销
- 不会出现tocttou问题，除非client还有一个线程

![img_129.png](img_129.png)
![img_130.png](img_130.png)
![img_131.png](img_131.png)

## ChCore进程间通信
略

---
# 同步
- 同步：顺序。避免use after free 
- 互斥：唯一。有一个共享变量，大家都加

![img_132.png](img_132.png)

![img_133.png](img_133.png)

## 生产者消费者
基础实现，在一个消费者一个生产者时没有问题
![img_134.png](img_134.png)
![img_135.png](img_135.png)

多个生产者
![img_136.png](img_136.png)

### 软件解决方案：皮特森算法
在x86上正确，在arm(弱内存模型，不同cpu核看到一个变量不一定相同)上错误
![img_137.png](img_137.png)

在单核上可以通过关中断防止错误。

### 互斥锁：临界区是两行改buffer和prodCnt

## 读写者
读写之间互斥（防止读一半写成别的），读读间不互斥，写写互斥

偏向读者，偏向写者（有写者等待则不让读者再进入临界区）

## 条件变量
![img_139.png](img_139.png)
wait在进去和出来的时候持有锁，在实际wait的时候放掉锁

![img_138.png](img_138.png)
因为可能有多个消费者

## 信号量
![img_141.png](img_141.png)
![img_142.png](img_142.png)

### 二元信号变量和互斥锁
![img_140.png](img_140.png)

## 多线程执行屏障：等待全部执行到屏障后继续执行
```
lock(mtx);
cnt --;
unlock(mtx);
while(cnt > 0);
```
可行但cpu一直占用

![img_143.png](img_143.png)
在这里不需要while(thread_cnt != 0)

## 等待队列工作窃取：在空时窃取其它核心的任务
![img_144.png](img_144.png)

## map-reduce：一旦**任意数量**mapper完成则继续执行
![img_145.png](img_145.png)
![img_146.png](img_146.png)
或
![img_147.png](img_147.png)
前者视变量cnt为共享资源，后者视完成的mapper为有限资源

## 线程池：允许同时3个线程执行
![img_148.png](img_148.png)

## 网页服务器：后端更新，client看
读写锁

## 死锁
产生的原因
1. 互斥访问
2. 持有并等待
3. 资源非抢占
4. 循环等待

### 检测死锁与恢复
每次拿锁时记录时间，操作系统每次中断或者调度的时候检测超时。

根据资源分配表和进程等待表，判断是否有环

直接kill所有环中线程/随机kill一个，如果有环继续kill/全部回滚到过去某一状态

为什么没有一个操作系统有这种机制：操作系统没有理由kill进程，这是程序员的错误。回滚是很难的

### 死锁预防
![img_150.png](img_150.png)
![img_151.png](img_151.png)
但是会造成活锁，每个进程都在交替拿锁放锁
![img_152.png](img_152.png)
资源允许抢占：允许抢占别人已经拿到的锁

# 同步原语实现
## 硬件原子指令
![img_153.png](img_153.png)

## Spinlock
如果lock等于0，则置为1
![img_154.png](img_154.png)
![img_155.png](img_155.png)

## Ticket Lock
加上一个数并返回值
![img_156.png](img_156.png)
![img_157.png](img_157.png)

## 读写锁
### 偏向读者
![img_158.png](img_158.png)
### 偏向写者
书355

## 条件变量
一般来说wait前处于拿锁状态，因为需要检查共享变量
![img_159.png](img_159.png)

### yield
![img_160.png](img_160.png)
RUNNABLE状态转化为RUNNING。CPUs table对应项只能被自己的CPU读写

#### 使用yield实现send
send是bounded buffer的生产者。这里演示可以不占用cpu的生产者锁实现
![img_161.png](img_161.png)

```
yield():
    lock(t_lock)
    
    id = cpus[CPU].thread
    threads[id].state = RUNNABLE
    threads[id].sp = SP
    
    do
        id = (id + 1) MOD N
    while thread[id].state != RUNNABLE
    
    threads[id].state = RUNNING
    SP = threads[id].sp
    cpus[CPU].thread = id
    
    unlock(t_lock);
```

#### 使用 WAIT/SIGNAL 实现send：左边出现Lost Notification错误 
![img_162.png](img_162.png)
左边实现wait参数没有锁，放锁单独写在睡眠前面，出现丢失唤醒问题。unlock必须在加入睡眠队列之后，否则会出现先唤醒再睡眠
正确做法右边，放锁、睡眠、拿锁必须同时实现。下面介绍这个wait的写法
### wait
注意这里和前面的yield不同，state改成WAITING，不会再被调度。函数中yield和yield_wait不同，yield_wait一定等条件满足再唤醒。
为什么这里不出现丢失唤醒：因为signal也要拿到t_lock，所以放锁和睡眠之间不会唤醒

![img_163.png](img_163.png)

![img_164.png](img_164.png)
会出现死锁问题
![img_165.png](img_165.png)

解决死锁但出现并发错误的方案：
![img_166.png](img_166.png)

为每个cpu单独设栈解决。CPU2可能写线程0的栈让CPU0上的线程0运行出错
![img_169.png](img_169.png)

进程在yield或yield_wait时发生时钟中断，则会自己等自己
![img_167.png](img_167.png)

在wait的时候关中断
![img_168.png](img_168.png)

## 信号量
busy-looping
![img_170.png](img_170.png)

信号量 = 条件变量 + 互斥锁 + 计数器

使用条件变量，但是signal开销高
![img_171.png](img_171.png)

减少signal次数，但是无法被唤醒（signal一次但是value还是小于0，还是无法唤醒。所以用value来表达需不需要被唤醒是不够的）
![img_172.png](img_172.png)

用一个单独变量表示可以被唤醒的数量
![img_173.png](img_173.png)

不能使用while，否则同时出现被唤醒和wait拿到资源
![img_174.png](img_174.png)
## 多核与同步原语
![[Pasted image 20250606203951.png]]
### 1. 多核缓存问题
#### 单核高速缓存
![[Pasted image 20250606204406.png]]
#### 多核缓存结构
![[Pasted image 20250606204445.png]]
#### 断崖式下降
spin lock造成**缓存行失效**，每次锁释放都会导致其他核心的缓存行失效，需重新从内存或上级缓存加载。解决方案MCS实际上是一个排队锁，避免饥饿。
![[Pasted image 20250606205008.png]]
### LINUX的QSPINLOCK
![[Pasted image 20250606205711.png]]
### 2. 非一致内存访问
### UMA 的局限性
在传统的 **UMA** 架构（如 SMP，对称多处理）中：
- 所有 CPU 通过**共享总线**访问同一块内存。
- **问题**：随着 CPU 核心数增加，总线争用加剧，内存访问延迟上升，扩展性变差。
### NUMA 的解决方案
NUMA 通过**将内存和 CPU 分组**（称为 **NUMA Node**），使得：
- **本地内存（Local Memory）**：CPU 访问所属 Node 的内存，**延迟低、带宽高**。    
- **远程内存（Remote Memory）**：CPU 访问其他 Node 的内存，**延迟高、带宽受限**
![[Pasted image 20250606210212.png]]
### NUMA-aware设计：cohort lock
![[Pasted image 20250610012140.png]]
**缓存行在多个 NUMA 节点间频繁迁移**，降低性能。
让某个NUMA节点的任务全部完成，再执行下一个NUMA节点的任务
### 代理锁：代理执行
与其跨节点访问数据，不如将程序发到对面
### 非对称多核的可拓展性
小核的执行能力更弱，公平性可能导致性能更低。
小核抢锁的能力更弱，更容易饥饿。
#### 非对称多核感知锁LIBASL
时延需求指导的锁传递顺序

---
# 不同的文件系统
## 如何查找文件
![img_177.png](img_177.png)

## mmap
![img_175.png](img_175.png)

优势
![img_176.png](img_176.png)

## VFS
文件描述符表：记录fd到文件文件描述表的映射
文件描述表：记录读取的offset，打开模式，目标inode
vnode：inode的内存版本
页缓存：块的内存版本
![[4fc92e37198e599cb42803f37154629.jpg]]
VFS中的inode：vnode维护一个inode缓存，使用hash表保存操作系统中所有inode
VFS中的数据块：使用基数树维护数字i到内存页的映射关系。基数树非常适合以0为开始的连续索引
VFS中的目录项：目录项缓存
### 过程
用户态shell执行rm程序->系统调用->虚拟文件系统调用->适配代码(非inode文件系统)->文件系统本身代码操作磁盘

## Ext2文件系统
![img_178.png](img_178.png)
![img_179.png](img_179.png)

### 文件类型
![img_181.png](img_181.png)
![img_180.png](img_180.png)

## 基于table文件系统FAT
![img_182.png](img_182.png)
next组织随机访问效率低。只能用在相机

每个目录项大小固定32字节
![img_184.png](img_184.png)
![img_183.png](img_183.png)

- U盘一般用FAT：传文件顺序读
- 不支持硬链接：目录里存有file size，文件改变之后会改多个目录项

![img_185.png](img_185.png)

## 基于数据库的NTFS
MFT(Master File Table)是一个关系型数据库
![img_186.png](img_186.png)

### 主文件表记录
![img_187.png](img_187.png)
文件名既记录在目录，又记录在文件属性里
![img_188.png](img_188.png)
意思就是文件属性里记录两个名字：原名字和硬链接名字

### 存储位置
![img_189.png](img_189.png)

- Everything查找文件快：NFTS在MFT里查找文件，不需要遍历所有目录

## ChCore文件系统
radix保存<逻辑块号,块指针>，哈希表保存目录项

## VFS
![img_190.png](img_190.png)
FAT没有inode，需要构造出一个内存中的inode，称为vnode

## 存储结构与缓存
![img_191.png](img_191.png)

![img_192.png](img_192.png)
为了提高内存的利用率。页粒度对于icache太大了

### ChCore中文件与存储
![img_193.png](img_193.png)

## 文件系统高级功能
### Clone, snapshot
只复制关键元数据，其它区域COW

### 稀疏文件
在索引中增加标记“该段全0”

## 文件系统多种形式
### GIT: 内容寻址文件系统
![img_194.png](img_194.png)
![img_195.png](img_195.png)
只要内容一样那么文件名就一样

### SQLite
![img_196.png](img_196.png)
![img_197.png](img_197.png)
inode等等都有overhead

---
# Crash
## FUSE:用户态文件系统接口
类似于微内核，速度慢，但不会影响内核
![[Pasted image 20250417103802.png]]

## 崩溃一致性
refcnt是冗余的，为了性能。

创建一个文件包括:
1. 标记inode为占用  
2. 初始化inode  
3. 将目录项写入目录中
![[Pasted image 20250417105108.png]]
有三种无影响：目录项没写所以没有人看得见。inode结构初始化也不可见。等价于情况1。
另外三种都写了目录项，所以会信息错乱
## 简化假设
- 磁盘是fail-stop
- 磁盘会1:1地执行文件系统下发的命令，不多做也不少做
- 磁盘可能不会执行最近的几次操作
- 磁盘不会写飞（wild writes，不受控的写入）
- 磁盘能保证单个磁盘块的写入原子性，但不保证顺序
### 一、同步原数据+fsck
2.如果inode指向一个bitmap显示未free的块，则修改bitmap。
5.明显有问题是不那么明显的，是基于经验的大段代码
![[Pasted image 20250417110822.png]]
![[Pasted image 20250417110916.png]]
![[Pasted image 20250417111250.png]]
通过inode修改bitmap，扫描inode本身，对于目录文件纠正。

NTFS由于冗余信息更多，所以更容易纠错

![[Pasted image 20250417111421.png]]
### 二、日志
![[Pasted image 20250417111559.png]]
#### 问题
问题1. 每个操作都写磁盘，内存缓存优势被抵消  
问题2. 每个修改需要拷贝新数据到日志  
问题3. 相同块的多个修改被记录多次
#### 利用内存中的页缓存
![[Pasted image 20250417111924.png]]
#### 批量处理日志减少磁盘写
多个文件操作的日志合并在一起，每个修改过的块只需记录一次、
- 定期触发
- 每一段时间（如5s）触发一次
- 日志达到一定量（如500MB）时触发一次
- 用户触发
- 例如：应用调用fsync()时触发

### Linux中的日志系统JBD2
差不多5秒一次
![[Pasted image 20250417112752.png]]

前面的方案无法解决问题2，所以需要引入模式，权衡一致性和性能
![[Pasted image 20250417113148.png]]
#### Ordered Mode
在修改文件的时候会出现一半新一半旧，因为只有block原子性。一定数据在原数据之前写，否则恢复的时候你是改了还是没改

#### Ordered Mode：两次Flush保证顺序
磁盘也是有缓存的，紫色的flush表示磁盘的flush操作。
磁盘没有保证顺序，只提供flush api。如果先写Jcmt元数据再第二次flush，如果写一半断电导致Jcmt未写入但元数据写入，恢复的时候的说法：没有Jcmt，则需要元数据还原，但元数据已经写入无法还原。
![[Pasted image 20250417114057.png]]
如何去掉第一次flush：给cmt加校验和，checksum效率低需要和flush效率权衡
![[Pasted image 20250417122704.png]]
### 二、copy-on-write
![[Pasted image 20250610013030.png]]
相较于日志：不需要额外空间。对小的修改开销大，至少有一个块的copy 
- 将要修改的数据块进行复制（分配新的块）
- 在新的数据块上修改数据
- 向上递归复制和修改，直到所有修改能原子完成
- 进行原子修改
- 回收资源
写时复制文件系统：Btrfs

### 三、Soft Updates
#### 总体思想
![[Pasted image 20250507233001.png]]
磁盘操作存在依赖，按照依赖关系先写被依赖的。这样每一步都保证一致性，不需要每一步都fsync。
在内存中记录依赖关系。说实话相对于日志文件系统没啥优势，就是可能不需要额外空间记日志
#### 顺序原则
![[Pasted image 20250507232401.png]]
不要一对空，不要多对一，不要空对一？
比如执行`mv a.txt b.txt`包含三个步骤。第一步之后断电则b不见了，这违反了第三条。rename是文件系统里最难的一个，没有之一。
```
unlink b.txt
link a.txt b.txt
unlink a.txt
```

#### 如何找依赖：创建文件
```
1. 标记inode为占用（对bitmap的修改）  
2. 初始化inode（对inode的修改，依赖于1）  
3. 将目录项写入目录中（对目录文件的内容修改，依赖于1和2）
```
![[Pasted image 20250507233712.png]]
第一行：比较好理解，目录项就是指向inode的指针
第二行：因为inode在bitmap分配了，所以别人不会重用他了，所以满足规则二了
按照这个规则就不会出现不一致只会出现空间泄漏
#### 如何找依赖：删除文件
第一行：先删目录项，再重置bitmap。因为根据规则二，如果目录项没删则被指针指向则不能重用
![[Pasted image 20250507234132.png]]
#### 如何找依赖：文件重命名
不能接受a.txt、b.txt都没有，可以接受a.txt、b.txt同时存在
![[Pasted image 20250507234407.png]]
#### 依赖追踪的两个问题
磁盘写操作的最小单位是block，所以可能出现循环依赖。某些操作可能一直产生新的依赖，所以一直无法写回。两个问题的解决方式是先撤销其中一个操作，再重做这个操作，这个解决方式可能会改变操作顺序。
![[Pasted image 20250507234755.png]]
# 日志文件系统(Log-structured FS)
![[Pasted image 20250508000150.png]]
super block和checkpoint区域固定。inode table被inode map取代。没有bitmap，新的block、inode就往后写就行。
### 创建文件并写入echo hello > /file3
![[Pasted image 20250508000610.png]]
有4个inode，位置记录在inode map中， 对应4个文件分别为：/，/dir2，/file2，/dir2/file1
先写数据块再写inode再写根目录，两个特点：所有操作都是顺序写，所有操作断电都没事
## 空间回收
回收的空间是个洞
- 串联：将所有空闲空间用链表串起来。磁盘空间会越来越碎，影响到LFS的大块顺序写的性能
- 拷贝：将所有的有效空间整理拷贝到新的存储设备
### 段
![[Pasted image 20250508001021.png]]
检测到三个段的利用率都不高，则拷贝
![[Pasted image 20250508001228.png]]
### 段概要
拷贝的过程中地址改变了，指向它的指针也应该改变，概要相当于做了一个反向索引
![[Pasted image 20250508001443.png]]
## 挂载和恢复
![[Pasted image 20250508001808.png]]
![[Pasted image 20250508001836.png]]有两个检查点可以容错，担心写其中一个的时候断电
### 恢复：前滚（roll-forward)\?
![[Pasted image 20250508004109.png]]
checkpoint指向的inode map及以前肯定有效
## 其它LFS实现
Flash和SSD只能一整块擦掉，不能只写某一个位置
![[Pasted image 20250508002811.png]]
## LFS读性能
读请求可以通过内存缓存，如果真的在磁盘上读，由于文件分散所以比较慢

# 新型存储设备的文件系统
## 瓦式磁盘
![[Pasted image 20250508095726.png]]
![[Pasted image 20250508091753.png]]
Bnad之间可以随机写，Band大小（30MB） >> 块设备读写粒度（4KB）
### 瓦式磁盘随机写
多次拷贝：要随机写X的4K，读X，写Y，再写X
缓存+动态映射：磁盘头部放25G SSD，通过动态映射Shingle Translation Layer (STL)，从外部（逻辑）地址到内部（物理）地址的映射。要随机写X的4K，标记Band X为dirty，修改STL映射指向持久化缓存，空闲时清理dirty
### Ext4 on 瓦式磁盘
Ext4上的随机写主要是元数据，且比较分散。让元数据修改写入journal无须写回，在在内存中维护jmap将S映射到J做地址翻译。
日志满了：无效元数据回收，冷元数据写回，热元数据保留在日志。
jmap持久化：jmap也写入日志
## 闪存盘(NAND)
![[Pasted image 20250508095756.png]]
![[Pasted image 20250508095819.png]]
![[Pasted image 20250508100245.png]]
SLC成本太高，QLC最便宜，存储空间最大，写入速度最慢，最容易写坏
Flash Translation Layer (FTL)逻辑地址转换到物理地址，这样对同一个位置一直写会映射到对不同位置

### LFS on 闪存
![[Pasted image 20250508100657.png]]
递归更新问题
![[Pasted image 20250508101041.png]]
单一log顺序写入
![[Pasted image 20250508101131.png]]
### F2FS(Flash Friendly File System)
#### NAT(Node Address Table)：所有地址都要经过NAT翻译，只需要修改一个node和一个映射
![[Pasted image 20250508200520.png]]
#### 多log并行
将文件分成好几个log
![[Pasted image 20250508200923.png]]
![[Pasted image 20250508200932.png]]
## 非易失性内存
NVDIMM：有一个电容，断电之后DRAM自动写入NAND
Intel Optiane DC Persistent Memory: 比DRAM慢六七倍，比NAND快1000倍
### 内存写入
如果是writeback（内存写入先写到cache里，之后统一写入DRAM），可能改变写入顺序
CLFLUSHOPT cache写入DRAM且清除cache
CLWB cache写入DRAM且不清除cache
### 非易失性内存文件系统
![[Pasted image 20250508202344.png]]
不需要设备驱动，因为直接由cpu管理。不需要IO调度，因为速度很快。内存的写入单位是cacheline，寻址单位是字节，所以不需要块。
#### 一致性保证
![[Pasted image 20250508202601.png]]
原子指令更新：8字节，16字节，64字节
#### 文件系统接口
read/write会被翻译成load/store，可以直接调用mmap不需要翻译
#### 如何防止NVM上的wild write
- Supervisor Mode Access Protection (SMAP)
	- 防止内核错误地修改用户内存
- Write windows (PMFS提出)
	- 挂载时，NVM映射为只读
	- 写入时，x86的CR0.WP临时设置为0，内核可以修改只读映射
## 操作系统IO层次
![[Pasted image 20250530132117.png]]
## 1. 系统与CPU的连接与交互
### 硬件总线
![[Pasted image 20250530132901.png]]
APB外设总线的频率较低，AHB系统总线频率较高，通过桥连接。慢速设备不能跑在高速总线上
### 总线事务
![[Pasted image 20250530133225.png]]
设备给处理器发中断
![[Pasted image 20250530133237.png]]
### 设备与CPU交互
寄存器通过总线与CPU相连
![[Pasted image 20250530133344.png]]
![[Pasted image 20250530133431.png]]
系统物理地址一部分是内存，一部分是设备
### 可编程IO
![[Pasted image 20250530133956.png]]
ChCore的UART MMIO会循环load设备寄存器的值，当设备ready时值会变成一。但是循环读会被编译器优化，所以要加volatile关键字
![[Pasted image 20250530133909.png]]
in/out只有内核能调，load/store都能调，所以arm只有MMIO

### DMA
![[Pasted image 20250530134146.png]]
DMA这块区域如何保证缓存一致性，因为cpu未修改它也会变
- 方案1：将DMA区域映射为non-cacheable
- 方案2：由软件负责维护一致性，软件主动刷缓存
- 部分架构在硬件上保证了DMA一致性，如总线监视技术
DMA可以绕过cpu访问物理地址，如何保证安全性：只允许io设备访问某个特定的内存，但是这样不同设备之间也互相可见；IOMMU
### IOMMU
![[Pasted image 20250530134404.png]]

### 中断与中断响应：是cpu、硬件交互的最后一个环节
![[Pasted image 20250530134610.png]]
### 中断控制器GIC
所有的设备中断信息都发给GIC
![[Pasted image 20250530134656.png]]
- GIC：Generic Interrupt Controller
- 组件1：Distributor中断分发器
	- 负责全局中断的分发和管理
	- 将当前最高优先级中断转发给对应CPU Interface
	- 寄存器：GICD
- 组件2：CPU Interface
	- 类似“门卫”，判断中断是否要发给CPU处理
	- 将GICD发送的中断，通过IRQ中断线发给连接到 interface 的核心
	- 寄存器：GICC
![[Pasted image 20250531003951.png]]
### ARM中断生命周期
![[Pasted image 20250530150303.png]]
### 为什么重置优先级
中断有优先级
![[Pasted image 20250530150411.png]]
### 高频中断：频繁接受网卡写入，一直中断不合理
中断开始后轮询
![[Pasted image 20250530150500.png]]
### 中断合并
![[Pasted image 20250530150536.png]]
## 2. 设备驱动
驱动程序包含中断处理程序，是os bug主要来源
![[Pasted image 20250530150723.png]]

![[Pasted image 20250530150736.png]]
![[Pasted image 20250610013300.png]]
### 驱动模型的好处
![[Pasted image 20250530151202.png]]
### Linux Device Driver Model
- 支持电源管理与设备的热拔插
- 利用sysfs向用户空间提供系统信息
- 维护内核对象的依赖关系与生命周期，简化开发工作
	- 驱动人员只需告诉内核对象间的依赖关系
	- 启动设备时会自动初始化依赖的对象，直到启动条件满足为止
### Linux上下半部
中断处理函数执行时无法终端，设备驱动的中断处理函数可能会导致系统失去响应
中断处理分为两部分：
#### top half
![[Pasted image 20250530151332.png]]
#### bottom half
softirqs：系统返回用户态时，看有没有可以做的。就像从自习室回家时看一眼小本本有没有可以做的
内核线程：从kernel自己做变成了可以调度的，没有用户上下文的
![[Pasted image 20250530151413.png]]
## 3. I/O子系统：关心缓冲区和IO模型
cache一般处理读请求，buffer一般处理写请求（读写速度不匹配的问题）
统一抽象——设备文件
不用read/write，ioctl写设备寄存器
![[Pasted image 20250530151955.png]]
### 设备分类
![[Pasted image 20250530152108.png]]
#### 字符设备
![[Pasted image 20250530152137.png]]
#### 块设备
![[Pasted image 20250530152126.png]]

#### 网络设备
也是顺序访问，但是是格式化的访问
![[Pasted image 20250530152151.png]]
### 设备缓冲管理：单双缓冲区
缓冲区/普通单缓冲区解决：
- 读写性能不匹配：慢速的存储设备 vs. 高速的CPU
- 读写粒度不匹配：小数据的访问存在读写放大的问题
游戏进程写入下一帧的时候，GPU渲染上一帧，这样就不会互相干扰
![[Pasted image 20250530152424.png]]
### I/O模型小结
![[Pasted image 20250530152748.png]]
# 资源虚拟化
## 虚拟化优势
1. 服务器整合![[Pasted image 20250530140141.png]]
2. 方便程序开发![[Pasted image 20250530140200.png]]
3. 简化服务器管理![[Pasted image 20250530140218.png]]
## 操作系统中的接口层次
![[Pasted image 20250530140324.png]]
![[Pasted image 20250530140419.png]]
![[Pasted image 20250530140437.png]]

- Hello world: 调用C库API，java的JVM的API
- Web game: 调用服务器的API
- Dota: API和ABI
- Office 2016: API, ABI
- Windows 10: ISA
- Java applications: ABI
- ChCore: ISA
## CPU虚拟化
虚拟机监控器（VMM/Hypervisor）：ISA区分操作系统和硬件，所以VMM向上层暴露虚拟ISA
### type-1 VMM直接运行在硬件之上
充当操作系统的角色，直接管理所有物理资源，性能损失较少，例如Xen，VMware ESX Server
### type-2 基于Host OS
主机操作系统管理物理资源，虚拟机监控器以进程/内核模块的形态运行，易于实现和安装。例如：QEMU/KVM
### 提供系统ISA
![[Pasted image 20250530142608.png]]
### 流程
![[Pasted image 20250530142539.png]]
### 一种直接实现
把虚拟机当做应用程序，将虚拟机监控器运行在EL1，将客户操作系统和其上的进程都运行在EL0，当操作系统执行系统ISA指令时下陷
- 写入TTBR0_EL1
- 执行WFI指令
- …...
### 版本零：用进程模拟
1：系统中断触发，下陷，保存上下文
![[Pasted image 20250530143747.png]]
### 版本一：模拟虚拟机时钟中断
![[Pasted image 20250530143848.png]]
虚拟机的中断不应该真正修改cpu的中断
5：时钟中断触发，下陷，判断时间片、中断屏蔽位
6：虚拟机一旦恢复，由VMM控制跳转到irq_handler。irq_handler为什么要保存寄存器？应该在下陷的时候就由VMM保存了。因为对于虚拟机本身来说，他需要自己保存
7：eret下陷
### 版本二：模拟用户态和系统调用
![[Pasted image 20250530204355.png]]
4：调用syscall的下陷，转发到虚拟机的内核态trap_handler
curr_mode存储虚拟机当前的状态
### 版本三：多个用户态线程
![[Pasted image 20250530204930.png]]
虚拟机可分配的内存数是有限的，达到上限之后就没了？
### 版本四：用线程模拟多个vCPU
![[Pasted image 20250530205313.png]]
两层独立调度：os调度，虚拟机内部调度。可能会出现
1. 虚拟机内vCPU-1跑生产者vCPU-2跑消费者，但是os不运行vCPU-1线程，而vCPU-2在空等
2. double schedued：拿锁的线程在os上没有跑，等锁的线程在os上跑
### 版本五：支持多个虚拟机间的分时复用
![[Pasted image 20250530210904.png]]
### 问题：ARM不是严格可虚拟化的架构
不是所有敏感指令都是特权指令。有些指令执行后不会下陷到内核态，silent failure
![[Pasted image 20250530211155.png]]
- CPSID和CPSIE分别可以关闭和打开中断
- 内核态执行：PSTATE.{A, I, F} 可以被CPS指令修改
- 在用户态执行：CPS 被当做NOP指令，不产生任何效果
如何处理不会下陷的敏感指令：
1. 解释执行：用软件方法模拟虚拟机代码。模拟不同ISA，易于实现。缺点非常慢
2. 二进制翻译![[Pasted image 20250530212332.png]]将cli翻译成call HANDLE_CLI![[Pasted image 20250530212701.png]]JVM的指令都是自己的指令集，JIT根据自身状态会修改代码。Hypervisor只有在想要翻译下一个基本块的时候才会执行
3. 半虚拟化：让VMM提供Hypercall给虚拟机，修改操作系统源码，将不下陷的敏感指令替换成超级调用
4. 硬件虚拟化![[Pasted image 20250530213829.png]]root/non-root模式与ring0/ring3模式正交，只有root的ring0才是系统真正操作所有资源，虚拟机内核态是non-root的ring0，可以不下陷IO和开关中断。在硬件层面解决问题
## 1. x86的INTEL VT-X
这个扩展让虚拟机几乎没有额外开销了
![[Pasted image 20250530215013.png]]
### Virtual Machine Control Structure
![[Pasted image 20250530215146.png]]
包含6个部分
![[Pasted image 20250530215336.png]]
vm-execution control fields: 用bit标记non-root模式能否开关中断等
![[Pasted image 20250530215640.png]]
一个vCPU一个VMCS，就是因为CPU的上下文不一样，相应的execution control fields也可以CPU之间不同
![[Pasted image 20250530220033.png]]
## 2. ARM的VHE

![[Pasted image 20250530215950.png]]
没有VMLAUNCH指令，复用eret。![[Pasted image 20250530220105.png]]
进入VM软件主动加载VM状态，下陷时软件主动保存VM状态
![[Pasted image 20250530220417.png]]
1. x86的CR3只有一个，所以需要通过VMCS恢复。ARM的页表寄存器有TTBR0_EL1和TTBR0_EL2，各自用各自的
2. 优点就是状态加载保存的开销小
![[Pasted image 20250530221340.png]]只有EL2才有的寄存器，专门用来控制虚拟机的状态。WFI是进入低功耗模式，如果发生中断再叫我
![[Pasted image 20250530222000.png]]
不能用Type-2虚拟机：HostOS使用的寄存器和EL2不是一一对应的，所以HostOS不能运行在EL2中

ARM本来的优势是下陷不用保存状态，但是这种方案需要保存两次状态
![[Pasted image 20250603004638.png]]
在8.1版本迅速通过硬件解决掉这个问题
![[Pasted image 20250603004743.png]]
![[Pasted image 20250603004914.png]]
## 3. 对比  
| |VT-x|VHE|
|-|-|-|
|新特权级|Root和Non-root|EL2|
|是否有VMCS？|是|否|
|VM Entry/Exit时硬件自动保存状态？|是|否|
|是否引入新的指令？|是(多)|是(少)|
|是否引入新的系统寄存器?|否|是(多)|
|是否有扩展页表(第二阶段页表)?|是|是|
## 内存虚拟化
QEMU/KVM架构：QEMU负责策略，KVM负责机制，QEMU使用KVM的用户态接口ioctl是一个循环
![[Pasted image 20250603010122.png]]
![[Pasted image 20250603010004.png]]
KVM可以处理的中断、调度、内存映射，否则给QEMU用户态Exit handler
### example
WFI只涉及调度，没有用户态
![[Pasted image 20250603010320.png]]
I/O指令需要用户态（？），所以进QEMU
![[Pasted image 20250603010353.png]]
问：VM、KVM和QEMU总共几个线程？一个。QEMU起一个vCPU时，会pthread创一个线程，然后运行ioctl，让出CPU创虚拟机

![[Pasted image 20250603012230.png]]
### 1. 影子页表
![[Pasted image 20250603014028.png]]
GVA直接通过SPT翻译成HPA。虚拟机内部只会管理GPT，宿主机操作系统只会修改HPT，在创建虚拟机时将GPT和HPT合在一起作为SPT，将SPT地址填入CR3
创建虚拟机时HPT存在，虚拟机内核启动时填写GPT。虚拟机进程缺页时，Guest的系统填写GPT，将GPT对应页在SPT的页表项设为ro，从而让VMM知道GPT改写，从而同步GPT中的更改到SPT
目前影子页表是一个进程一个。SPT随GPT变化
#### guest内核和guest用户如何隔离？
虚拟机的用户态和内核态分别用一个页表。用户态的内核空间没有映射，内核态都有映射。3个虚拟机每个20进程共120个SPT
### 2. 直接映射
改GuestOS，不要GPA，直接映射到HPA不一定连续，提供HyperCall修改页表
- Positive
	- Easy to implement and more clear architecture
	- Better performance: guest can batch to reduce trap，原本一个字节的分配都需要下陷，现在可以在guestOS做batch操作
- Negatives
	- Not transparent to the guest OS
	- The guest now knows much info, e.g., HPA
		- May use such info to trigger rowhammer attacks，告诉他哪些可以用相当于告诉他哪些不能用，虽然只能调用HyperCall会检查，但是由于dram硬件特性，对一个位置反复写可能导致相邻地址bit flip
### 3. 硬件虚拟化
- Intel VT-x和ARM硬件虚拟化都有对应的内存虚拟化
	- Intel Extended Page Table (EPT)
	- ARM Stage-2 Page Table (第二阶段页表)
- 新的页表
	- 将GPA翻译成HPA
	- 此表被VMM直接控制
	- 每一个VM有一个对应的页表，所以3个虚拟机每个20个进程共三个GPT
普通进程只会使用一个页表，可以灵活切换
![[Pasted image 20250604113200.png]]
![[Pasted image 20250604113354.png]]
#### 翻译过程
因为虚拟机进程的TTBR0_EL1存储的是GPA，所有GPA都需要第二阶段翻译成HPA。GVA的翻译过程查一次寄存器和四级页表，每一级页表基地址都需要进行一次翻译，因此总共$5*5-1$次访问。
![[Pasted image 20250604114633.png]]
- TLB可以缓存一二阶段翻译，切换VTTBR_EL2时理论上应将前一个VM的TLB项全部刷掉
- VMID (Virtual Machine IDentifier)：VMM为不同进程分配8/16 VMID，将VMID填写在VTTBR_EL2的高8/16位，VMID位数由VTCR_EL2的第19位（VS位）决定，避免刷新上个VM的TLB
#### page fault
第一阶段不会下陷，调用GuestOS。第二阶段会调用VMM的page fault handler
![[Pasted image 20250604115332.png]]

### 虚拟机级别内存换页
将VMA的内存数据存入磁盘，然后将A的物理内存地址映射给VMB。虚拟机内部也有换页机制，可能冲突
![[Pasted image 20250604115512.png]]
进程级别内存换页：P2触发Page Fault，OS需要分配物理页，检测到物理页不够，通过LRU机制换走物理页到磁盘
虚拟机级别内存换页：VMM看不到VM的run queue。VM2触发Page Fault，VMM需要分配物理页，检测到物理页不够，需要将VM1的物理页换入磁盘。此时VM1内部恰好触发换页机制也要换走这个页，读到自己的内存页触发Page Fault，从而VMM先从disk读出来，然后VM再写入disk
#### 内存气球机制
![[Pasted image 20250605153000.png]]
VMM调用虚拟机的kmalloc(upcall)，虚拟机使用自己的换页机制。此时VM将GPA告诉VMM后，VMM不需要将这些页写入磁盘
## IO虚拟化
### VM不能直接管理设备
- 正确性问题：所有VM都直接访问网卡
	- 所有VM都有相同的MAC地址、IP地址，无法正常收发网络包
- 安全性问题：恶意VM可以直接读取其他VM的数据
	- 除了直接读取所有网络包，还可能通过DMA访问其他内存
### 1. 设备模拟
VM的操作track到VMM，通过VMM访问，比如MMIO访问网卡内存，触发page fault
**QEMU/KVM发网络包**：VMM读取VM某个内存获得网络包内容。VMM读取VM的地址是很容易的，VMM作为一个进程先mmap出一段地址，在VM创建时再映射这个地址
![[Pasted image 20250605155052.png]]
**QEMU/KVM收网络包**：![[Pasted image 20250605155431.png]]
![[Pasted image 20250605155455.png]]
### 2.半虚拟化方式
![[Pasted image 20250605155614.png]]从被动监测到主动调用，可以batch
**QEMU/KVM发网络包**：![[Pasted image 20250605155818.png]]
![[Pasted image 20250605155844.png]]
### 3.设备直通
![[Pasted image 20250605160211.png]]

#### 问题1：DMA恶意读写内存
每个虚拟机独占设备，还是有问题。DMA操作物理内存，VM-2告诉他VM-1的物理内存
![[Pasted image 20250605160257.png]]
通过IOMMU来检查
![[Pasted image 20250605160422.png]]
#### 问题2 设备不够
网卡内部实现虚拟化，提供接口，网卡内部实现隔离性
![[Pasted image 20250605160652.png]]
![[Pasted image 20250605160745.png]]

|               | 设备模拟 | 半虚拟化 | 设备直通 |
|----------|----------|----------|----------|
| 性能       | 差       | 中       | 好       |
| 修改虚拟机内核| 否       | 驱动+修改| 安装VF驱动|
| VMM复杂度     | 高       | 中       | 低       |
| Interposition | 有       | 有       | 无       |
| 是否依赖硬件功能 | 否      | 否       | 是       |
| 支持老版本OS  | 是       | 否       | 否       |
### 硬件虚拟化的中断虚拟化
![[Pasted image 20250605161054.png]]
前面已经使用过软件模拟调用VM的中断处理函数，这里介绍硬件实现的中断
![[Pasted image 20250605161109.png]]
![[Pasted image 20250605161209.png]]
#### GICv3
![[Pasted image 20250605161236.png]]
设备产生物理中断，下陷到VMM，VMM插入虚拟中断——写入GIC提供的ICH_LR0_EL2寄存器设置中断号，VMM恢复vCPU执行时硬件自动调用VM的IRQhandler。问题就是每次需要停下虚拟机——物理中断依然下陷，在设备直通时影响很大
#### GICv4
![[Pasted image 20250605161826.png]]
直通设备发送物理中断后，将直接查询GIC ITS，GIC负责将虚拟中断插入VM。这样不会引起任何形式的虚拟机下陷。
![[Pasted image 20250605161833.png]]
## 轻量级隔离docker
### CHROOT
改变文件系统的根目录
不同用户设置不同根目录有什么问题？
- 遇到类似“..”的路径会发生什么？
- 一个用户想要使不同进程有不同的根目录怎么办？
![[Pasted image 20250606104711.png]]
- 不同的执行环境想要共享一些文件怎么办？
	- 涉及到网络服务时会发生什么？
- 所有执行环境共用一个IP地址，所以无法区分许多服务
- 执行环境需要root权限该怎么办？
	- 全局只有一个root用户，所以不同执行环境间可能相互影响
### Linux Container（资源隔离）
![[Pasted image 20250606105048.png]]
![[Pasted image 20250606105104.png]]
#### 1. MNT(Mount)
![[Pasted image 20250606105419.png]]
#### 2. IPC
![[Pasted image 20250606105551.png]]
#### 3. IP
虚拟机有一个IP
![[Pasted image 20250606105933.png]]
![[Pasted image 20250606110430.png]]
#### 4. PID
不能通过PID访问容器外的进程
![[Pasted image 20250606110659.png]]
#### 5. User
chcore的capability是一个数字，像fd
![[Pasted image 20250606110852.png]]
容器内的root还需要限制，不能关机等
![[Pasted image 20250606111201.png]]
#### 5. UTS, Cgroup
![[Pasted image 20250606111255.png]]
### 性能隔离
#### control group
![[Pasted image 20250606111406.png]]
任务（task）：一个线程
控制组（control group）：资源限制的单位
子系统（Sub-system）/资源控制器：可以跟踪或限制控制组使用该类型物理资源的内核组件
层级（Hierarchy）：由控制组组成的树状结构

![[Pasted image 20250606111602.png]]
# 操作系统安全
操作系统没问题
![[Pasted image 20250606112714.png]]
操作系统存在bug但可信
![[Pasted image 20250606112750.png]]
操作系统不可信
![[Pasted image 20250606112818.png]]
![[Pasted image 20250606140133.png]]
### 操作系统安全很难指标化
•指标-1：千行代码的缺陷密度
–Linux 的缺陷密度近年来已经小于 0.5
•GPU 驱动的缺陷密度仅为 0.19， 160个缺陷
•SMACK（Linux 的一个安全模块）高达 1.11，6个缺陷
•指标-2：已发现的缺陷数量
–缺陷的编号方法

•CVE（Common Vulnerabilities and Exposures）
–相对值直接比较也缺乏说服力
•Linux 内核的 CVE 数量目前排在第 3 位（2,357 个）
•Windows XP 则排第 28 位（741 个），比Linux更安全？

### 安全目标
•机密性（Conﬁdentiality）
–常又称隐私性（Privacy）
–数据不能被未授权的主体窃取（即恶意读操作）
•完整性（Integrity）
–数据不能被未授权的主体篡改（即恶意写操作）
•可用性（Availability）
–数据能够被授权主体正常访问

## 访问控制
![[Pasted image 20250606141711.png]]
认证：从用户到进程，每个进程的PCB中包含user字段，shell进程初始化user，子进程继承父进程user

### 授权机制：POSIX文件权限
每个用户都区分，存储空间太大了，所以分三个组
![[Pasted image 20250606141849.png]]
/etc/hosts被所有人共享，所以只有root能修改。改成一个/etc/hostsd目录，然后每个用户创建一个文件？不兼容以前的linux。将这个目录虚拟化成一个文件，读这个目录等于读一组文件的组合
### 基于角色的访问控制（RBAC）
角色与权限之间的关系比较稳定，而用户和角色之间的关系变化相对频繁
- 设计者负责设定权限与角色的关系（机制）
- 管理者只需要配置用户属于哪些角色（策略）
### 最小特权级原则：setuid机制
![[Pasted image 20250606142949.png]]
root身份运行，远大于必要权限。如果buffer overflow可以直接以root权限执行
### Capability
![[Pasted image 20250606143251.png]]
#### fd和capability
![[Pasted image 20250606143510.png]]
#### linux capability
![[Pasted image 20250606143447.png]]
### DAC和MAC
自主访问控制（DAC: Discretionary Access Control）：对象拥有者可以改对象权限
强制访问控制（MAC: Mandatory Access Control）：由"系统"增加一些强制的、不可改变的规则
#### Bell-LaPadula 模型
![[Pasted image 20250606143911.png]]
“上读下写”。长官无法传递消息给士兵

引入了“受信任主体”的概念（Trusted Subject） ：
- 受信任主体可以不受星属性的限制
- 但前提是该主体必须遵守相应的“降密策略”（Declassiﬁcation Policy）
## 案例：SELinux
![[Pasted image 20250606144337.png]]
![[Pasted image 20250606144919.png]]
![[Pasted image 20250606144954.png]]
## 操作系统内核攻防
操作系统有bug
### 整形溢出漏洞
增加对溢出的检查代码；利用自动化工具查找并修复
### Return-to-user攻击（ret2usr）
- 方法一：仔细检查内核中的每个函数指针
	- 需对内核所有模块进行检查，很难做到 100% 的覆盖率
- 方法二：在陷入内核时修改页表，将用户态所有的内存都标记为不可执行
	- 由于修改页表后必须要刷新 TLB 才能生效，因 此修改页表、刷新 TLB，以及后续运行触发 TLB miss 都会导致性能下降
	- 在返回用户态之前必须将页表恢复，并再次刷掉 TLB，这样又会导致用户态执行时出现 TLB miss，因此对性能的影响非常大
- 方法三：硬件保证CPU处于内核态时不得运行任何用户态的代码
	- 如 Intel 的 SMEP（Supervisor Mode Execution Prevention）技术：防止内核跳到用户态
	- ARM 同样有类似 SMEP 的技术，称为 PXN（Privileged eXecute-Never）
SMEP 不能完全解决 ret2usr：ret2dir：direct mapping部分也是内核态，但其实映射到了用户态空间，可以跳到这。解决方法是dm部分不可执行
### KASLR：内核地址布局随机化
随机化增加攻击难度。64位地址空间一半$2^{63}$ 是天文数字，一般用$2^{47}$，假设内核占4G（$2^{32}$）有$2^{15}$个内核，如果对齐则只需要访问$2^{15}$次。访问没有映射的区域出错的速度比内核区域出错的时间快
### Seccomp: 减少攻击面
限制程序只能访问他需要的syscall
### 侧信道与隐秘信道
![[Pasted image 20250606155317.png]]
隐秘信道：发送方和接收方互相串通
侧信道：发送方是好人，被接收方窃取
利用这个猜密码是侧信道
![[Pasted image 20250606155824.png]]
Cache Channel：两个进程不是一个内存，但是libc是共享内存。两个进程会复用cache，进程切换只刷TLB不刷cache![[Pasted image 20250606160418.png]]
flush+reload
![[Pasted image 20250606160358.png]]

flush+flush
![[Pasted image 20250606160609.png]]
evict+reaload
![[Pasted image 20250606160658.png]]
prime+probe
![[Pasted image 20250606160837.png]]
防御侧信道攻击根本方法：不同享
常量时间，但是增加了计算量
![[Pasted image 20250606161129.png]]
不经意随机访问内存（ORAM），引入大量额外负载
### 案例：Meltdown漏洞
允许应用程序读取任意内核内存
CPU投机执行：无依赖关系的临近指令执行顺序被打乱，
如提前执行了错误指令，则将执行结果丢弃。在寄存器层面可以回滚，回滚的原理是一开始在shadow寄存器上面跑，预测成功后copy。但是在cache层面不能回滚，因为cache的成本太高不能shadow
![[Pasted image 20250606162254.png]]
```
load key, %rax
load buf[%rax], %rbx
```
通过挨个访问buf判断访问时间判断在不在cache里判断key值。
解决方案：不能改硬件，否则intel破产也回收不回来。不能所以不能让内核和应用使用同一个地址空间，KPTI(Kernel Page Table Isolation)将内核态和用户态页表分离，用户态的页表的内核地址空间只有一段entry代码方便调syscall，内核态转用户态tlb也要刷新
![[Pasted image 20250606163027.png]]
造成性能急剧下降，优化方法：页表切换tlb只刷新direct mapping部分，内核代码读就读了
### 案例：Spectre攻击
训练CPU分支预测表让它以为某个条件总是成立，进而访问非法地址。虽然撤销但是缓存改变
解决方法
![[Pasted image 20250606163452.png]]
## 操作系统不可信
恶意操作系统攻击应用
- 应用的攻击面
	- 同层：其他应用程序
	- 底层：操作系统、Hypervisor、硬件
![[Pasted image 20250606193444.png]]
### 一种新的威胁模型：安全处理器
![[Pasted image 20250606193744.png]]
- Enclave的两个主要功能
	- 远程证明：验证远程节点是否为加载了合法代码的Enclave
	- 隔离执行：Enclave外无法访问Enclave内部的数据
- Enclave带来的能力：限制访问数据的软件
	- 可保证数据只在提前被认证的合法节点间流动
	- 合法节点：部署了合法软件的节点
![[Pasted image 20250606194806.png]]
![[Pasted image 20250606194538.png]]
### TEE远程证明
![[Pasted image 20250606195102.png]]
启动时度量/静态度量：如TPM芯片，下层软件加载验证上层软件，形成信任链，TPM是信任根
启动后度量/动态度量：静态度量的hash值没法更新。如Intel TXT，支持启动后对区域内存进行认证，如认证Hypervisor
![[Pasted image 20250606200245.png]]
### TEE隔离执行
#### 攻击1：恶意特权软件攻击
特权软件：如操作系统、Hypervisor。可直接窃取或篡改用户数据和代码（隐私性与完整性攻击），可拒绝为应用提供服务（可用性攻击）
#### 防御1：基于访问控制隔离特权软件
直接新增硬件隔离能力保护TEE范围的硬件
引入更底层的特权软件（属于可信计算基）
examples：
- 页表机制，主流CPU均支持
- PMP（Physical Memory Protection），如：RISC-V
- PRM（Processor Reserved Memory），如：Intel SGX
- 嵌套虚拟化，如：CloudVisor
#### 攻击2：恶意硬件的攻击
examples：
- 内存中间人攻击（威胁机密性、完整性与可用性）
- 系统总线嗅探攻击（威胁机密性）
- 非易失性内存窃取（威胁机密性、完整性）
- 恶意DMA攻击（威胁机密性、完整性）
- 内存冷冻启动攻击（威胁机密性）
#### 防御2：内存加密防御物流攻击
隐私性保护：内存加密
- CPU外皆为密文，包括内存、存储、网络等
- CPU内部为明文，包括各级Cache与寄存器
- 数据进出CPU时，进行加密和解密操作
完整性保护：Hash Tree
- 对内存数据计算一级hash，对一级hash计算  
二级hash，形成树
- CPU内部仅保存root hash
- 当内存中的数据被修改时，更新Merkle Tree
#### 攻击3：基于访问模式的侧信道攻击
examples：
- 利用页表攻击Intel SGX窃取TEE内数据
- 利用缓存攻击TrustZone窃取TEE数据
#### 防御3：混淆访问模式+减少资源共享
常量时间，ORAM，
空间隔离：为TEE使用单独的CPU核、内存和外设
时间隔离：在切换时刷掉所有共享状态如缓存、TLB
## TEE三种形态
![[Pasted image 20250606202443.png]]
### 形态1：Enclave -- Intel SGX
SGX: Software Guard eXtension
- Enclave内部与外部的隔离：Enclave内外共享一个虚拟地址空间，内部可以访问外部的内存，反之则不行
- 内存加密与完整性保护
- 远程验证
### 形态2：ARM TrustZone 技术
同时运行一个安全的OS和一个普通的OS：两个系统之间互相隔离运行，安全的OS具有更多的权限
TrustZone是一个全系统级别的安全架构：处理器、内存和外设的安全隔离
### 形态-3：机密虚拟机 -- AMD SEV
以虚拟机为粒度的Enclave：对不同的虚拟机进行加密，每个虚拟机的密钥均不相同，Hypervisor有自己的密钥
安全模型的缺陷：依然部分依赖Hypervisor，如为VM设置正确的密钥
# 系统研究领域前沿
1. 模型原生
2. 异构操作系统
3. 新的应用接口
4. 同步原语
5. 持久性内存
6. 系统安全
7. 操作系统测试
8. 形式化证明
