# part11-注册中心和服务容错

# 1 service_edu

## 1.1 tomcat并发修改

service_edu  yml中tomcat最大并发线程数调整为10

```yaml
server:
  port: 8110 # 服务端口
  tomcat: 
    max-threads: 10 #tomcat的最大并发值修改为10,默认是200
```

## 1.2 controller测试方法

TeacherController中添加并发测试方法

```java
@ApiOperation("测试并发")
@GetMapping("test_concurrent")
public R testConcurrent(){
    log.info("test_concurrent");
    return R.ok();
}
```

## 1.3 **测试**

swagger访问 test_concurrent，立即得到响应结果, 

对test接口进行jmeter大并发访问，swagger测试test_concurrent会不会受影响,test_concurrent原本只要1s就可以响应，现在要4秒,被影响翻翻了



# 2 **JMeter并发测试工具**

## 2.1 JMeter下载和安装

下载地址：https://jmeter.apache.org/ apache-jmeter-5.2.1.zip

下载版本：apache-jmeter-5.2.1.zip，解压任意目录即可



## 2.2 配置

/bin/jmeter.properties 37行，改为简体中文

language=zh_CN



## 2.3 启动JMeter

\- Windows

启动：双击bin/jmeter.bat运行文件

访问：http://localhost:8848/nacos

用户名密码：nacos/nacos



__mac:

修改为中文

```shell
code /bin/jmeter.properties

# language
language=zh_CN
```

启动：

```shell
cd bin/
sh jmeter
```







# 3 使用JMeter测试高并发

## 3.1 添加线程组

![image-20211104080724156](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080724156.png)

## 3.2 配置线程并发

![image-20211104080739720](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080739720.png)

## 3.3 添加Http请求取样器

![image-20211104080752961](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080752961.png)

## 3.4 配置Http取样器

![image-20211104080807932](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080807932.png)

## 3.5 配置查看结果树

![image-20211104080819537](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080819537.png)

## 3.6 启动测试

![image-20211104080834085](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104080834085.png)

## 3.7 测试并发

当test接口收到高并发访问请求时，同一服务器上的test_concurrent接口响应延迟严重



# 4 服务雪崩

分布式系统环境下，通常会有很多层的服务调用。由于网络原因或自身的原因，服务一般无法保证 100% 可用。如果一个服务出现了问题，调用这个服务就会出现线程阻塞的情况，此时若有大量的请求涌入，就会出现多条线程阻塞等待，进而导致服务瘫痪。

如下图，对于同步调用，当底层的库存服务不可用时，商品服务请求线程被阻塞，当有大批量请求调用库存服务时，最终可能导致整个商品服务资源耗尽，无法继续对外提供服务。

由于服务与服务之间的依赖性，故障会传播，不可用沿请求调用链向上传递，会对整个微服务系统造成灾难性的严重后果，这就是服务故障的 “雪崩效应” 。

![image-20211104085240860](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104085240860.png)



test接口是一个长链接的猪队友，沾满了服务器资源，影响到了test_concurrent接口



# 5 服务容错

## 5.1 **容错方案**

要防止雪崩的扩散，我们就要做好服务的容错：保护自己不被猪队友拖垮的一些措施。

常见的容错方案：隔离、超时、限流、熔断、降级

## 5.2 隔离

将系统按照一定的原则划分为若干个服务模块，各个模块之间相对独立，无强依赖。当有故障发生时，能将问题和影响隔离在某个模块内部，而不扩散风险，不波及其它模块，不影响整体的系统服务。常见的隔离方式有：线程池隔离和信号量隔离。

## 5.3 超时

上游服务调用下游服务时，设置一个最大响应时间，如果超过这个时间，下游未作出响应，就断开请求，释放掉线程。

## 5.4 限流

限制系统的输入和输出流量以达到保护系统的目的。为了保证系统的稳定运行，一旦达到的需要限制的阈值，就采取相应措施以完成限制流量的目的。

## 5.5 熔断

当下游服务因访问压力过大而响应变慢或失败，上游服务为了保护系统整体的可用性，可以暂时切断对下游服务的调用。这种牺牲局部，保全整体的措施就叫做熔断。

## 5.5 降级

降级就是为服务提供一个托底方案，一旦服务无法正常调用，就使用托底方案。



# 6 容错组件

## 6.1 Hystrix

Hystrix是由Netflix开源的一个延迟和容错组件，用于隔离访问远程系统、服务或者第三方库，防止级联失败，从而提升系统的可用性与容错性。

## 6.2 Resilience4J

Resilicence4J提供丰富的容错工具，轻量、简单、文档清晰，也是Spring Cloud官方推荐替代Hystrix的产品。不仅如此，Resilicence4j还原生支持Spring Boot 1.x/2.x，而且监控也支持和prometheus等多款主流产品进行整合。

## 6.3 Sentinel

Sentinel 是阿里巴巴开源的一款断路器实现，在阿里内部已经被大规模采用，非常稳定。



# 7 **Sentinel介绍**

## 7.1 什么是Sentinel

Sentinel (分布式系统的流量防卫兵) 是阿里开源的一套用于服务容错的综合性解决方案。它以流量为切入点，从流量控制、熔断降级、系统负载保护等多个维度来保护服务的稳定性。



## 7.2 Sentinel 的特征

- 丰富的应用场景：Sentinel 承接了阿里巴巴近 10 年的双十一大促流量的核心场景，例如秒杀、消息削峰填谷、集群流量控制、实时熔断下游不可用应用等。
- 完备的实时监控：Sentinel 提供了实时的监控功能。通过控制台可以看到接入应用的单台机器秒级数据，甚至 500 台以下规模的集群的汇总运行情况。
- 广泛的开源生态：Sentinel 提供开箱即用的与其它开源框架/库的整合模块，例如与 SpringCloud、Dubbo、gRPC 的整合。只需要引入相应的依赖并进行简单的配置即可快速地接入Sentinel。
- 完善的扩展点：Sentinel 提供简单易用、完善的扩展接口。您可以通过实现扩展接口来快速地定制逻辑。例如定制规则管理、适配动态数据源等。



## 7.3 Sentinel 的组成

核心库（Java 客户端）：不依赖任何框架/库，能够运行于所有 Java 运行时环境，同时对 Dubbo /Spring Cloud 等框架也有较好的支持。

控制台（Dashboard）：基于 Spring Boot 开发，打包后可以直接运行，不需要额外的 Tomcat 等应用容器。



# 8 Sentinel控制台

Sentinel 提供一个轻量级的控制台, 它提供机器发现、单机资源实时监控以及规则管理等功能。

## 8.1 下载和安装

下载地址：https://github.com/alibaba/Sentinel/releases

下载版本：sentinel-dashboard-1.7.0.jar



## 8.2 启动控制台

控制台本身是一个SpringBoot项目，直接使用jar命令启动项目

```shell
java -jar sentinel-dashboard-1.7.0.jar
```

```shell
java -Dserver.port=8888 -Dcsp.sentinel.dashboard.server=localhost:8080 -Dproject.name=sentinel-dashboard -jar sentinel-dashboard-1.7.0.jar
```

访问：http://localhost:8080

用户名密码：sentinel/sentinel



# 9 微服务集成Sentinel客户端

## 9.1 引入依赖

service模块中配置Sentinel的pom依赖（实际是在服务消费者端需要依赖）

```xml
<!--服务容错-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

## 9.2 添加测试方法

TeacherController中添加如下方法用于测试

```java

@GetMapping("/message1")
public String message1() {
    return "message1";
}
@GetMapping("/message2")
public String message2() {
    return "message2";
}
```



# 10 微服务连接控制台

## 10.1 微服务配置

service_edu微服务yml中添加以下配置

```yaml
#spring:
#  cloud:
    sentinel:
      transport:
        port: 8081 #跟控制台交流的端口，随意指定一个未使用的端口即可
        dashboard: localhost:8080 # 指定控制台服务的地址
```

## 10.2 swagger中测试

测试message1和message2的访问

## 10.3 查看sentinel控制台

实时监控并发数量,gui

OPS：每秒访问量



## 10.4 控制台运行原理

Sentinel的控制台是一个SpringBoot编写的程序。我们需要将我们的微服务程序注册到控制台上，即在微服务中指定控制台的地址（localhost:8080）

并且还要开启一个跟控制台传递数据的端口（8081），控制台也可以通过此端口调用微服务中的监控程序获取微服务的各种信息。



# 11 **实现接口限流**

## 11.1 添加流控规则

![image-20211104092723690](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104092723690.png)

![image-20211104093216967](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104093216967.png)

每秒有两个访问

swagger测试message1接口，快速点击好几次tryitout

![image-20211104093419985](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104093419985.png)

成功实现流量控制



## 11.2 基本参数

- 资源名：唯一名称，默认是请求路径，可自定义
- 针对来源：指定对哪个微服务进行限流，默认指default，意思是不区分来源，全部限制
- 阈值类型/单机阈值：
- QPS（每秒请求数量）: 当调用该接口的QPS达到阈值的时候，进行限流
- 线程数：当调用该接口的线程数达到阈值的时候，进行限流
- 是否集群：暂不需要集群

## 11.3 **测试限流效果**

![image-20211104093419985](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104093419985.png)

# 12 sentinel基本概念

## 12.1 资源

资源就是Sentinel要保护的东西

资源是 Sentinel 的关键概念。它可以是 Java 应用程序中的任何内容，可以是一个服务，也可以是一个方法，甚至可以是一段代码。

- 案例中的message1方法就可以认为是一个资源

## 12.2 规则

规则就是用来定义如何进行保护资源的

作用在资源之上, 定义以什么样的方式保护资源，主要包括流量控制规则、熔断降级规则以及系统保护规则。

- 案例中就是为message1资源设置了一种流控规则, 限制了进入message1的流量

# 13 sentinel重要功能

![image-20211104093608546](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211104093608546.png)

## 13.1 流量控制

思想：保证自己不被上游服务压垮

任意时间到来的请求往往是随机不可控的，而系统的处理能力是有限的。我们需要根据系统的处理能力对流量进行控制。Sentinel可以根据需要把随机的请求调整成合适的形状。

## 13.2 熔断降级

思想：保证自己不被下游服务拖垮

当检测到调用链路中某个资源出现不稳定的表现，例如请求响应时间长或异常比例升高的时候，则对这个资源的调用进行限制，让请求快速失败，避免影响到其它的资源而导致级联故障。

## 13.3 系统负载保护思想：保证外界环境良好（CPU、内存）

当系统负载较高的时候，如果还持续让请求进入可能会导致系统崩溃，无法响应。在集群环境下，会把本应这台机器承载的流量转发到其它的机器上去。如果这个时候其它的机器也处在一个边缘状态的时候，Sentinel 提供了对应的保护机制，让系统的入口流量和系统的负载达到一个平衡，保证系统在能力范围之内处理最多的请求。



# 14 openfeign整合sentinel

## 14.1 **引入sentinel的依赖**

在service模块的pom

```xml
<!--服务容错-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

## 14.2 开启Sentinel支持

在service_edu的yml配置文件中开启Feign对Sentinel的支持

```yaml
feign:
  sentinel:
    enabled: true
```

## 14.3 创建容错类

```java
package com.atguigu.guli.service.edu.feign.fallback;

@Service
public class OssFileServiceFallBack implements OssFileService {
    @Override
    public R test() {
        return R.error();
    }
    @Override
    public R removeFile(String url) {
        log.info("熔断保护");
        return R.error();
    }
}
```

## 14.4 指定容错类

为OpenFeign远程调用接口添加fallback属性值没指定容错类

```java
@Service
@FeignClient(value = "service-oss", fallback = OssFileServiceFallBack.class)
public interface OssFileService {
```

## 14.5 测试

停止service_oss微服务，测试删除讲师的功能

Caused by: com.netflix.client.ClientException: Load balancer does not have available server for client: service-oss



error

Caused by: java.lang.IllegalStateException: No fallback instance of type class 

缺少注解"@Component",导致编译时未将"FeignClientFalLback"类自动实例化,当服务接口不可用时,

