## 介绍
### 语音基本单位
Phoneme: 语音的基本单位
Grapheme: 语言的基本单位，比如字母+空白
![[Pasted image 20251025123715.png]]
对于16KHz的语音，25ms的语音段有400个数字。采样之间有重叠
直接用语音频谱做识别，可能性太大。
![[Pasted image 20251025124215.png]]
### 训练语料需要多少
![[Pasted image 20251025124622.png]]
### ASR如何定义问题
两种视角：Seq2Seq, HMM
### LAS(listen, attend and spell)
#### Listen
![[Pasted image 20251025125321.png]]
语音序列非常长，Down Sampling: Pyramid RNN, Pooling over time, TDNN(只考虑一段时间内最开始和最后的token)，Truncated Self-attention
#### Attend & Spell
![[Pasted image 20251025131825.png]]
spell是一个RNN，$z_0$是零时刻的隐状态，他要与encoder的输出做点积，点积后的概率向量作为RNN的输入改变隐状态

### CTC
![[44de45a2e9e84ffbe6dc6cfdff343c99_v2-e9beb83e56946be48f6927172a614c18_r_source=2c26e567.jpg]]
CTC每一个{x_t}输入进去，只代表一个很小的时间内，每个$y_t$相互独立。classifier是linear的，不过encoder可能是LSTM
输出的结果可能包含连续的相同字母或空白，连续的合并，空白丢弃。如果输出$\phi d e\phi e p$则是deep，$\phi d e e p$是dep
### RNN-Transducer
RNA：将CTC的classifier变成RNN
RNN-T：同一个$h_t$可以输出多个$y$，直到输出$\phi$ 
这样在推理时可以实现，但是在训练时会有很大的aliement问题
![[Pasted image 20251025145514.png]]
我们需要一个独立的RNN来训练，它可以看做一个语言模型
![[Pasted image 20251025150418.png]]
### Neural Transducer
![[Pasted image 20251025150536.png]]
Transducer每次会输入固定窗口大小的h
### MoCha(可变window)
每次移动到一个位置，判断是否可以在此停下，然后transducer生成一个token进行预测（只解码一个y）
### HMM（TODO）
用tri-phoneme作为最小单位，因为一个音节的发音还受前后音节影响
一个state代表一个tri-phoneme的所有发音的分布，用一个GMM表示。state数量太多，相似的合并为一个分布

---
### Alignment
![[Pasted image 20251025154205.png]]
![[Pasted image 20251025154908.png]]
![[Pasted image 20251025155317.png]]以RNN-T为例，RNN只与gt序列有关，不吃$\phi$。所以到达每个格子后，向下和向右走的概率，不会受到如何到达这个格子的影响。因为每个状态下到达下一个位置的概率，只跟$h_t$和RNN输出有关。
所以可以用递推计算。直接用gt输入RNN得到$l$，每个格子就拿自己的$x$和$l$计算向左和向下概率就完了。所以我认为训练过程首先随机初始化RNN，然后并行每个$x$和每个$l$都计算概率，最后递推计算总概率。
decoding：理论上应该解码$P(Y|X)$最大，但我们只管$P(h|X)$最大
## With LM
shallow-fusion：语音模型$P_{LAS}(Y)$和语言模型$P_{LM}(u)$直接log相加
deep-fusion: 或者将hidden一起输入神经网络，这个还是需要重新训练，而且换语言模型又要重新训。如果hidden是softmax之前的那个向量，则不同语言模型不见得要重训
code-fusion: 语言和语音一起初始化和训练，这样LAS训练会快一点

## HuBert
1. 对语音帧做聚类，
2. 输入mask后的原语音序列，输出隐藏表示。输出向量与每个类中心的点积，softmax后作为该类概率，最大化正确类别的概率
3. 对隐藏表示做聚类，
4. 将隐藏状态作为输入，预测结果与新类中心计算损失
## 架构

| 名称        | 说明                 |     |
| --------- | ------------------ | --- |
| Conformer | Transformer + Conv |     |
|           |                    |     |
|           |                    |     |

## 语音编码器
| 名称      | 训练任务    | 架构                        |     |
| ------- | ------- | ------------------------- | --- |
| HuBERT  | 自监督     | BERT                      |     |
| CLAP    | 对比学习    | 音频CNN，文字BERT              |     |
| Whisper | 有监督     | Transfomer-EncoderDecoder |     |
| WavLM   | 加噪声，自监督 | CNN+Transformer           |     |
CIF和CTC对于下游任务哪个好？

| 名称  | 任务      |     |     |
| --- | ------- | --- | --- |
| ASV | 自动说话人识别 |     |     |
|     |         |     |     |
与其想一个idea“可能会更好”，不如选一个idea“可以验证为什么不好”。做东西的一致性很重要
多语言都是同一个base，
## 多模态对齐的方法
从mala的attention-map来看，只是加了一个热词的偏置而已，就像训练时一直在听周杰伦的歌，那么推理时也会一直耳边循环。用一个all-in-one 的captioner做一个音频到文本的对齐器
step-audio-r1
omni-captioner
lego-slm
dac
triplet loss
# 关于多说话人
![[截屏2026-01-21 21.17.15.png]]
长上下文需要用cache进行全局说话人特征。现在缺少语音编码器有多说话人特征
进行多说话人的asr，相当于一个前端信号模型和一个理解模型的联合优化，换句话说多说话人可以换成背景噪，asr任务也可以换成信号领域其他任务
用语言信息指导sd任务

TASU如何解决上限是sensevoice的问题。因为他的仿真模拟器是模拟sensevoice的真实ctc，所以需要仿真数据。pj提出仿真器要以ctc本来的WER特征
同音不同义、同义不同音

hyposis：mala的训练效果是增加偏置

测试norm之后的其他任务能力
qwen-omni在加入kw之后会有注意力吗
clap
![[Pasted image 20260125193204.png]]
# 目录
- 语音信号处理
- 马尔可夫过程进行语音处理
- 深度学习语音识别
- 声纹及语音合成
作业
- 语音端点检测

人工智能是模拟人类思维活动的智能 ❌
人工智能核心在于处理”不确定性“ ✅

2014 amazon发布一款音响，后续大家都在做音响。80%机箱都是speech提供语音服务，后续小米等都在自己做。

语音识别难点：
1. 变长输入（音频/词均变长）
2. 词表数量巨大
3. 环境、说话人干扰

多说话人/鸡尾酒会：
1. 方法一：需要每个说话人30s的单独音频，并且只有论文能用实际场景不能用
2. 方法二：汽车座舱四个位置每个都有一个麦克风，分别处理分别理解

上院100-伍威权堂
1. 麦克风阵列，防止回音

多说话人会议识别：
1. 目前最难场景之一
2. 多说话人识别比asr更难，比噪声更难（本身就有噪声）
3. 目前做到10个人效果不错

tts
1. 自然语言指令描述语气
2. 2019年diffusion语音编辑

全双工
1. chatgpt，奔驰想把他放在车上，但是做控制的时候crash掉。因为他不考虑可靠性，只考虑多样性。如果我有一个方言识别模型能达到95正确性，也不能解决，电话号码11位，错一个就是错。

# 信号与系统
图像（位置的函数）和语音（时间的函数）都是信号。
模拟信号：时间和幅值均连续。抽样信号：时间不连续。数字信号：时间和幅值均不连续

q：目标说话人特征
q-encoder: 目标说话人说的干净音频的编码器

提取一般是encoder-fusion-decoder，最后通过一个信号损失还原原始音频。fusion模型可以融合encoder和q-encoder的特征
DAE-TSE的q-encoder是KCE-encoder：编码mix-audio 和keyword，训练时接一个ctc预测头和说话人标签预测头，从而训练出分离目标说话人的能力。

常规做法是kw-spot + 音频截取，作为说话人注册，这部分音频还是嘈杂的。

三步
1. 检测关键词：KCE-encoder有ctc预测头，使用奚总的kw-spot算法
2. 输入关键词
3. 进行语音分离
