# 概论

![img.png](img.png)

# 1. Linear Regression
## 回归
![img_35.png](img_35.png)
## 均方损失
![img_29.png](img_29.png)
## 梯度下降法
![img_30.png](img_30.png)
## 极值点法
![img_31.png](img_31.png)
![img_32.png](img_32.png)
## 正则化
![img_33.png](img_33.png)
1. **模型复杂度**：正则化通过最小化权重向量的二范数‖w‖，限制权重的幅度，从而降低模型的复杂度。这类似于将高次曲线函数简化为线性函数，避免模型过度拟合训练数据。
2. **贝叶斯视角**：最小化二范数相当于假设权重 w 的先验分布服从高斯分布（零均值，方差由 λ 控制），从而引入对模型参数的先验约束。
3. 引入正则化等价于对**数据增强**。正则化项 λI 的加入可以看作是在原始数据 XTX 的基础上增加了随机数据（方差为 λ）。这种“虚拟数据”的引入在数据不充分时提高了模型的鲁棒性，限制了模型的复杂度，从而提升了泛化能力。
随着数据的增加，往往需要更复杂的模型以捕捉数据中的规律，但如果模型过于复杂时，又会导致过拟合，表现为数据“不足”，需要增加更多的数据。

# 2. Decision Tree

## 算法
1. 构造一个根节点，包含整个数据集.
2. 选择一个最合适的属性，以最大化标签的纯度
3. 根据选择属性的不同取值，将当前节点的样本划分成若干子集；
4. 对每个划分后的子集创建一个孩子节点，并将子集的数据传给该孩子节点；
5. 递归重复2~4直到满足**停止条件**
![img_38.png](img_38.png)

## “纯度”指标
![img_37.png](img_37.png)

## ID3
![img_36.png](img_36.png)

## 决策树
![img_39.png](img_39.png)
![img_40.png](img_40.png)

## 随机森林
将数据随机划分子集，各自构建决策树，将结果合并。
![img_41.png](img_41.png)
![img_42.png](img_42.png)

# 3. Bayes
## 新数据
![img_43.png](img_43.png)
1. 对于一些犬牙交错的分布数据，其并没有明显的决策边界，难以做到细致的划分
2. 当数据的分布呈现复杂的非线性模式时，决策树需要大量划分才能捕捉数据的特征，导致模型复杂度急剧增加。
## Probabilistic Inference
![img_44.png](img_44.png)


![img_4.png](img_4.png)
![img_6.png](img_6.png)
P(x|Ci) ?

## Decision rule

![img_5.png](img_5.png)

如果x是多维
![img_18.png](img_18.png)

如何计算P(x|c)分为两种学派

## Conditional Independence
![img_45.png](img_45.png)
![img_20.png](img_20.png)
![img_46.png](img_46.png)

## Application
![img_47.png](img_47.png)
### Doc Classification
计算P(wk|c)时注意|Vocab|是w所有可能取值个数，n是w总个数，nk是wk总个数/?
![img_48.png](img_48.png)
### spam filtering
![img_49.png](img_49.png)

## adv & dis
![img_50.png](img_50.png)
![img_51.png](img_51.png)
![img_52.png](img_52.png)

# 4. knn
## 距离与相似度与归一化
![img_57.png](img_57.png)

## 算法
![img_53.png](img_53.png)
### 如何选k
![img_54.png](img_54.png)

## pros and cons
![img_55.png](img_55.png)
![img_56.png](img_56.png)

# 5. Logistic Regression

能否直接通过数据学习这个决策边界，而不必关心数据的具体分布特性

## Decision rule
![img_2.png](img_2.png)

g使用一个线性函数

![img_3.png](img_3.png)

## Perception

![img_7.png](img_7.png)

![img_8.png](img_8.png)

r*x很难说明这是什么

跳跃的函数很难优化。模型输出类别，不包含概率大小

## odds几率
P(C1|x) = y
![img_9.png](img_9.png)

![img_10.png](img_10.png)
高斯分布的前提下对数几率是x的线性函数，线性函数的w和b可以由高斯分布的均值方差表示

![img_11.png](img_11.png)

## Optimization

r为01标签，y为预测值

![img_12.png](img_12.png)

![img_13.png](img_13.png)

```python
linear_output = np.dot(X, self.weights) + self.bias
y_pred = sigmoid(linear_output)

dw = (1 / n_samples) * np.dot(X.T, (y_pred - y))
db = (1 / n_samples) * np.sum(y_pred - y)
```

## Softmax
![img_58.png](img_58.png)
![img_59.png](img_59.png)

# 6. SVM
- 分割样本的边界有很多，还需要考虑能否最大化边界和样本间的距离。
- **支持向量**：对模型学习起作用的是边界上的数据，只要获得边界上的点（支持向量），即能支撑整个模型

## 通过最大化间隔推导优化式子
### $w^Tx+w_0=+-\delta$确定了两个支持面，等式同除$\delta$表示同一个支持面
![img_60.png](img_60.png)
### 对于两个支撑面的两个点$x^{(1)}$、$x^{(2)}$，在超平面法向量方向上的距离
![img_61.png](img_61.png)
### 最大化这个距离就是最小化w范数

## 优化式子
### 最大化边界等于最小化w范数
![img_25.png](img_25.png)
### 通过合页损失处理约束：只在不满足约束时施加惩罚
![img_62.png](img_62.png)

## 梯度
![img_26.png](img_26.png)

# 8. lm
## word embedding
one-hot encoding -> word embedding

### Mikolov’s CBOW(词袋)
![img_63.png](img_63.png)
![img_64.png](img_64.png)
![img_65.png](img_65.png)
![img_66.png](img_66.png)

## language model
1. 处理可变长度输入
2. 跟踪远距离的依赖
3. 考虑顺序
4. 不同句子共享参数

### RNN
![img_67.png](img_67.png)

### Backpropagation Through Time (BPTT)
无内容

### Aplications
分类、生成

# 9. Transformers
## RNN-based Encoder-Decoder
![img_70.png](img_70.png)
没看懂他这里是$c$是$s_0$还是$y_0$还是什么
![img_69.png](img_69.png)
![img_68.png](img_68.png)
缺点将整个句子编码成一个向量，不考虑各个位置的重要性。在长上下文条件下性能急剧减少
### 将每一段${h_i, h_{i+1}, ...h_{i+n}}$加权成为$c_i$
![img_71.png](img_71.png)
### 使用神经网络$a_{i,j}=NN(s_{i−1}, h_j)$获得权重
![img_72.png](img_72.png)

## Tranformers
RNN无法并行训练。

![img_73.png](img_73.png)
Self-Attention Mask
- for both encoder and decoder
- to ignore padding tokens
Cross-Attention Mask
- for encoder only
- to ignore padding tokens in the source sequence
Causal Mask
- for decoder only
- only pay attention to generated
words

# 10. large language models
## BERT
### pretrain: MASK词预测，是否是下一句判断
![img_74.png](img_74.png)
![img_75.png](img_75.png)

### finetune: 句子分类，词标注，句子对分类，QA
![img_76.png](img_76.png)
![img_78.png](img_78.png)
![img_77.png](img_77.png)
![img_79.png](img_79.png)
![img_80.png](img_80.png)
对于每一个document的词输出，用相同的全连接层预测他作为“答案”开头的分数。用另一个全连接层预测它作为结束的分数

## GPT

## prompt, few shot, chat-of-thought
## ReAct
Reasoning + Action
![img_27.png](img_27.png)

## Retrieval-Augmented Generation
![img_28.png](img_28.png)
1. **Index** 将文档切成小块，经过embedding变成向量
2. **Retrieval** 将Query经过embedding，计算cos相似度获得top-k文档

# 11. cnn
## 其它做法
### nn
![img_81.png](img_81.png)

## cnn计算
![img_82.png](img_82.png)

## cnns
leNet, alexNet, ResNet

# 12. Computer Vision
显存不够![img_83.png](img_83.png)

## upsample
![img_84.png](img_84.png)

### 转置卷积之所以叫“转置”
![img_85.png](img_85.png)
被卷积的展平，卷积核展平，依次右移一格，遇到下一行则右移宽度
![img_86.png](img_86.png)
将这个重排列的卷积核转置，乘以原来的输出得到原来的输入

## 目标检测
![img_87.png](img_87.png)

### 多物体
#### 遍历不同的图片切片，依次使用图像分类：expensive
#### Selective Search：Find “blobby” image regions that are likely to contain objects
#### R-CNN系列

1. 一张图像生成1k～2k个候选区域（使用 Selective Search 方法)
2. 对每个候选区域，使用深度网络（图片分类网络）提取特征
3. 特征送入每一类SVM分类器，判断是否属于该类
4. 使用回归器精细修正候选框位置。（使用 Selective Search 算法得到的候选框并不是框得那么准）
![img_89.png](img_89.png)

1. 一张图像生成1k～2k个候选区域（使用 Selective Search 方法）
2. 将图像输入网络得到相应的特征图，将 Selective Search 算法生成的候选框投影到特征图上获得相应的特征矩阵
3. 将每个特征矩阵通过 ROI pooling 层缩放为$ 7 \times 7$大小的特征图，接着将特征图展平通过一系列全连接层获得预测结果。
![img_90.png](img_90.png)

1. 将图像输入网络得到相应的特征图
2. 使用RPN(Region Proposal Network)结构生成候选框，基于候选框的cls得分，采用非极大值抑制选出候选框，将候选框投影到特征图上获得相应的特征矩阵。
3. 将每个特征矩阵通过 ROI pooling 层缩放为$7 \times 7$大小的特征图，接着将特征图展平通过一系列全连接层获得预测结果。
![img_91.png](img_91.png)
Region Proposal Network: 对于每一个卷积块内生成k个“是物体的概率”和坐标
![img_92.png](img_92.png)

#### YOLO
1. 将图片划分为很多个单元格
2. 每个单元格只对应一个概率最高的类别，对该类别预测B个锚框以及置信度（边界框含有目标的可能性大小+边界框的准确度）
3. 根据分数选择锚框，每个锚框进行分类
![img_93.png](img_93.png)

# 14. Clustering

## 无监督学习
![img_94.png](img_94.png)
![img_95.png](img_95.png)

## k-means
### 算法
![img_96.png](img_96.png)
1. 簇标签无变化
2. 中心位置无变化
3. 指标不再下降
![img_97.png](img_97.png)
### 复杂度 Iknd
![img_98.png](img_98.png)

### 选择k
![img_99.png](img_99.png)
对于每个候选 K运行K-means，计算组内平方和WSS。随K增加迅速下降，拐点为选择点

### 选择起始点
kmeans++
1. **均匀随机**选择一个点作为第一个中心
2. 计算每个点到最近中心的距离D(x)
3. 按概率$P(x) = \frac{D(x)^2}{\sum_{x_i \in \mathcal{X}} D(x_i)^2}$选择下一个中心。距离越远的点，被选中的概率越高，最大化初始中心之间的分散性，改善后续聚类效果。
4. 重复步骤 2-3 直到选出k个中心
5. 运行标准 K-means 算法

### pros & cons
![img_100.png](img_100.png)
![img_101.png](img_101.png)

# 15. dim
## 为什么降维
降低维度并且保持数据特征
![img_102.png](img_102.png)

## Principal Component Analysis (PCA)
### 优化式子（均值一定要为0，减去样本均值就行）
将原数据$x$使用$u$投影，希望投影后方差最大
![img_103.png](img_103.png)
![img_104.png](img_104.png)

### 使用拉格朗日乘数法求解，反正就是求$S$的前k个特征值
![img_105.png](img_105.png)
![img_106.png](img_106.png)

### 选k
![img_107.png](img_107.png)

### 应用
• Data visualization
• Preprocessing
• Modeling – prior for new data
• Compression

# 16. gen
## GAN
![img_108.png](img_108.png)

### Deep Convolutional GANs (DCGAN)无条件生成
输入随机噪声
![img_109.png](img_109.png)

### CycleGAN: Domain Transformation有条件生成
参考图片直接输入G
![img_110.png](img_110.png)

## Variational Autoencoder (VAE)
输出一个概率分布然后采样，采样不可微，但**输出的均值加上一个随机数乘以方差**可微
![img_113.png](img_113.png)

### KL正则化，一般接近单位高斯
![img_114.png](img_114.png)

## Limitations of VAEs (and also GANs)
![img_115.png](img_115.png)

## Diffusion
![img_116.png](img_116.png)
![img_117.png](img_117.png)
![img_118.png](img_118.png)
![img_121.png](img_121.png)
模型一般预测的是噪声
![img_119.png](img_119.png)

![img_120.png](img_120.png)

# 17. RL
![img_122.png](img_122.png)