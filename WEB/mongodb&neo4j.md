## Nosql - MongoDB

#### 为什么nosql

- **数据量大**：mysql虽然有分区，但数据量大的情况下mysql还是会很慢
  - 当数据量超过1k，mysql将变得很慢，因为它是用B树建立索引，此时还要随机IO
- **非结构化 半结构化数据：**这种数据难以用关系型数据库存储

下表为传统关系型数据库和常见的大规模数据处理程序（如mapreduce）的需求的对比

| **维度**       | **传统 RDBMS**                            | **MapReduce**                                     |
| -------------- | ----------------------------------------- | ------------------------------------------------- |
| **数据规模**   | Gigabytes（千兆字节级别）                 | Petabytes（PB 级别，超大规模）                    |
| **访问方式**   | 支持交互式和批量（Interactive and batch） | 仅支持批量（Batch）                               |
| **更新模式**   | 读写多次（Read and write many times）     | 写入一次，读取多次（Write once, read many times） |
| **数据结构**   | 静态模式（Static schema）                 | 动态模式（Dynamic schema）                        |
| **数据完整性** | 高完整性（High）                          | 完整性较低（Low）                                 |
| **扩展性**     | 非线性扩展（Nonlinear）                   | 线性扩展（Linear）锁少                            |

------

#### mongoDB

1. **文档式存储（Document-Oriented）**
   - MongoDB 是一个面向文档的数据库，存储的数据为 JSON（或 BSON 格式）的文档。每个文档是一个键值对集合，与关系型数据库中的行类似。
2. 全索引支持(2D)，支持地理空间索引
3. 高可用性（通过复制和分区）
4. auto sharding：自行分区，负载均衡：
   - 分区信息存放在config中，请求来了在config中确定分区再搜索
5. **查询操作**：MongoDB 提供丰富的查询功能，包括简单查询和复杂的聚合查询，支持类似 SQL 的操作，但没有像 SQL 中的 JOIN 操作。
6. **就地修改（In-place Update）**：MongoDB 支持高效的就地修改操作，可以直接修改文档中的字段，而不需要重新写入整个文档。
   - 快，非常快，比重新写入快多了
7. **内嵌文件系统（GridFS）**：MongoDB 提供内嵌的文件系统 GridFS，用于存储超大文件（如图片、视频等）。
8. **支持 MapReduce**：MongoDB 支持 MapReduce 用于大规模数据处理，适用于批处理任务。

------

#### mongodb的数据结构

- database(数据库)：权限控制（就不同的人可以访问不同的数据库），每个数据库存储在单独的文件
- collection 集合 (对应mysql中的表)：MongoDB 的集合是模式自由（Schema-free）的，不需要提前定义结构。集合可以包含多个文档。
  - subcollection(相当于垂直分割，但没有关联关系)
- document 文档：json格式key value对（实际上是 BSON 格式）；当数据存(不是指针指向大数据)
  - **_id (对应主键)**
  - **类型敏感，大小写敏感**
  - **字段唯一性**：每个文档中的键值对的键不能重复
- 不能所有数据都存一个collection中：
  - 可以这么做，但是难维护，且查询效率低

------

#### mongodb操作

- find：用于查询文档，类似 SQL 中的 SELECT 语句，但没有复杂的嵌套操作。
- updateOne：有key，对value修改
- replaceOne：对key更改
  - 是对文档的结构（scheme）的改变
- delete
- aggregate pipeline：聚集流水线操作：一连串的操作
  - 用于进行多阶段的查询处理。聚合操作通常用于复杂的数据处理和分析。
- index：
  - mongodb支持多种索引类型，如多列索引；还可以建立空间索引；
  - 索引有助于提高查询效率，但不支持 SQL 中的 JOIN 操作。
  - mongodb中搜索没有关系型数据库中join操作的效率高

------

#### Auto-Sharding 自动分片

- 数据量大，切成小chunk，放到不同的集群中：把collection切成小块
  - 分片由mongoDB自动做，访问时不能指定在哪个分区
    - mongoDB会自动识别数据所在的分区并路由：Router
- **路由器（Router）**：记录什么存在哪里，会把请求转发到合适的shard上
  - 一些配置的元教据需要记录，在config 配置服务器存储，相当于router

**为什么需要 Auto-Sharding？**

- **数据量太大，存储不下**：数据超出了单机存储的容量，分布到多个机器上。
- **用户访问量大，需要分开写入**：为了提高并发读写能力，将用户数据分布到不同的机器上。
- **内存不足，需要扩展集群缓存**：通过增加 Shard，提升缓存能力，避免内存瓶颈。

**每个 Shard 有唯一的 Shard Key**：

- Shard Key 是决定数据如何在多个 Shard 之间分布的字段。

mongoDB会**自动负载均衡**(增加机器等情况)

- shard中有很多chunk：所有shard中chunk数量的差异有一定限制，保证平衡
  - 每个chunk包括一些document key (UUID )的范围，chunk的范围&位置 这些信息均记录在config中
  - 每当某个 Shard 中的 Chunk 超过容量限制时，MongoDB 会自动拆分该 Chunk。
  - 如果 Shard 的负载不均衡，MongoDB 会动态地将数据迁移到其他 Shard 上，确保负载均衡。
- **手动分区管理**：管理员也可以手动控制分区的策略，例如根据数据访问频率来调整 Shard 中的数据分布。



### 图数据库 Neo4J

#### **基本概念**

- **节点（Node）**：表示实体或对象。
  - **id**：每个节点都有一个唯一的标识符，类似关系型数据库中的主键。通常这个 `id` 自动生成。
  - **类型（Type）**：表示节点的种类（如：User、Message 等）。
  - **属性（Label）**：节点可以拥有多个属性，属性是键值对形式。例如，一个 `User` 节点可以有属性 `name` 和 `content`。
- **边（Relationship）**：表示节点之间的关系。
  - **有向**：边是有方向的，表示从一个节点指向另一个节点。
  - **关系标签（Relationship Label）**：边有关系标签，用于表示不同类型的关系。例如：`FOLLOWS`、`TEAMMATE`。
- **标签（Label）**：标签可以用于标识节点或边，帮助对数据进行分类和查询。
- **属性（Attribute）**：节点或边的属性是键值对形式，描述了节点或边的特征。例如，`name` 和 `age` 是节点 `User` 的属性。

------

#### **图数据库底层存储结构**

- 底层存储引擎和查询处理引擎

  ：Neo4j 的底层结构是专为图数据设计的，可以高效地存储和查询图形数据。它包含：

  - **节点**：每个节点存储其 ID、第一条边的 ID、属性的 ID、标签的 ID 等。
  - **边**：每条边存储边的类型、起始节点和终止节点的 ID、相关的属性等。

------

#### 为什么使用图数据库

本质原因：**关系的查询效率高**

- mysql：跨表关联，join操作多，性能差（e.g. A的好友的好友
- nosql：嵌套不能反向结构(只能扫描所有的document)；只能一次一次搜索查找
- 图数据库：**查找关系不用访问所有节点和边；描述关系简单，在进行复杂关系查询时具有较高的性能。**

------

### query语句：Cypher

(emil:Person {name:'Emil'}) <-[:KNOWS]-(jim:Person {name:'Jim'}) -[:KNOWS]->(ian:Person {name:'Ian'}) -[:KNOWS]->(emil) MATCH (a:Person)-[:KNOWS]->(b)-[:KNOWS]->(c), (a)-[:KNOWS]->(c) WHERE [a.name](http://a.name/) = 'Jim' RETURN b, c

------

### Neo4j

- 多机器均衡；主从备份（主写从读）
- 同一个进程开一个嵌入式的neo4j：
  - Neo4j 可以作为嵌入式数据库运行在同一进程内，适用于一些本地存储的场景。

内部存储结构：

- 节点：
  - 1bit：是否使用；
  - 第一条边的id ；
  - 第一个属性的id；
  - label的id；
- 边：
  - 1bit：是否使用；
  - 从哪个nodeID出（前一条边ID 后一条边ID），
  - 入（前一条边ID 后一条边ID；）

![1736687877310](assets/1736687877310-1737025599934-4.jpg)

