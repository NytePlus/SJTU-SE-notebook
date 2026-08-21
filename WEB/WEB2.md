
# 攻击
1. SQL注入（SQL Injection）
定义：攻击者通过在输入字段中插入恶意SQL代码，欺骗数据库执行非预期的操作。
示例：
假设登录查询为：SELECT * FROM users WHERE username = '输入的用户名' AND password = '输入的密码';
攻击者输入：' OR '1'='1
最终查询变为：SELECT * FROM users WHERE username = '' OR '1'='1' AND password = '' OR '1'='1';，从而绕过登录验证。
防御措施：
使用参数化查询（Prepared Statements）或ORM框架。
对用户输入进行严格的输入验证和转义。
限制数据库用户的权限，避免使用管理员账户连接数据库。
定期进行安全审计和漏洞扫描。
2. CSRF攻击（跨站请求伪造，Cross-Site Request Forgery）
定义：攻击者诱使用户在已认证的Web应用中执行非预期的操作（如转账、修改密码）。
示例：
用户登录银行网站后，访问攻击者的网站。
攻击者的网站中包含一个隐藏的转账请求：`<img src="http://bank.com/transfer?to=attacker&amount=1000" />`。
浏览器自动发送请求，完成转账。
防御措施：
使用CSRF Token：为每个表单生成唯一的Token，验证请求来源。
检查请求头中的Referer字段，确保请求来自合法来源。
使用SameSite Cookie属性，限制Cookie的跨站发送。
对敏感操作进行二次验证（如短信验证码）。
3. XSS攻击（跨站脚本攻击，Cross-Site Scripting）
定义：攻击者将恶意脚本注入到网页中，当其他用户访问时，脚本会在其浏览器中执行。
示例：
攻击者在评论区输入：<script>alert('XSS');</script>。
其他用户访问页面时，脚本被执行。
防御措施：
对用户输入进行输出编码（如HTML、JavaScript、URL编码）。
使用内容安全策略（CSP）限制脚本加载来源。
避免直接将用户输入插入到HTML中。
使用安全的框架和库（如React、Vue等）自动处理XSS风险。

# java面向对象
多态、封装、继承

# Java多态
c++多态
- 编译时：函数重载、运算符重载、模板
- 运行时：虚函数（利用基类指针调用派生类的重写函数）
java多态
- 方法重载，接口与实现
- 方法重写，向上/向下转型

# sql
```
(9)SELECT 
    DISTINCT <column>,
    COUNT(*) AS employee_count, 
    AVG(salary) AS avg_salary
(1)FROM employees
    INNER JOIN departments 
    ON employees.department_id = departments.department_id
(4)WHERE employees.hire_date > '2020-01-01'
(5)GROUP BY department_id
WITH {CUBE|ROLLUP}
HAVING AVG(salary) > 5000
ORDER BY employee_count DESC
LIMIT 5;
```

# 消息队列

## rabbitmq和后两种有什么区别

## 消息重复消费怎么解决？

## 消息丢失怎么解决

## 消息可靠性怎么保证

## 业务怎么保证消息顺序性

## 如何保证幂等写

## 消息积压了怎么办

## rocketMQ和kafka的区别

## kafka为什么这么快

# redis

## 五种数据类型

## zset的原理

## skip-list相对于B+的优势

## listpack

## 哈希表怎么扩容

## redis为什么快？为什么比mysql快

## redis哪里使用了多线程

## redis集群模式

## 本地缓存和redis缓存的区别

## 如何解决mysql和redis一致性模型

# mysql

## Nosql和sql区别

## 数据库范式

## mysql如何避免插入重复数据

## mysql的基本函数有哪些

## mysql执行顺序是怎样的

## 执行一条sql语句的过程是什么样的

## mysql的两种存储引擎以及他们的区别？

## 聚簇索引和非聚簇索引的区别？

## 什么字段适合做主键？

## 性别字段能否加索引？

## 自增id和uuid的比较？

## 查找数据时，到达B+树叶子结点之后怎么做？

## B+树相对于B树的优势？

## 为什么不使用跳表

## 如果一个列既是单列索引也是联合索引，会使用哪一个？

## 什么字段适合建索引？

## 索引优化的方法有哪些？

## 可重复读隔离级别后如何保证不出现幻读？

## mysql中锁的类型

## 两个非索引列的范围查找，会不会阻塞

## 主从复制的过程是什么样的