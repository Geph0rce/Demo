Page 1:
每天APP都会处理不同的数据，这些数据：

* 可能来自磁盘；
* 来自网络请求；
* 也可能来自用户输入；

为了让APP可以正常运行，就需要保证数据是有效的；

Page 2、3:
有时候，当某个数据源出现了问题，APP就会显示异常，严重时， 也许会引起Crash;

Page 4:
什么是可信赖的数据？
一般需要保证:

* 数据没有在未知情况下被修改过；
* 数据格式、结构是我们所需要的；

Page 5:

数据Model化会经过以下几个过程:

* 网络请求回来的二进制原始数据；
* 经过NSJSONSerialization，反序列化之后的原型数据 (NSDictionary/NSArray)；
* 解析NSDictionary/NSArray之后，生成的结构化数据，我们称之为Model；


NSSecureCoding and Codable
