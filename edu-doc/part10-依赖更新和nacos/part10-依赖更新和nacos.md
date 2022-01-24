# part10-依赖更新和nacos

# 1 停更引发的升级惨案

停更不停用：Spring Cloud Netflix 项目进入了维护模式

- 被动修复bugs
- 不再接受合并请求
- 不再发布新版本

所以使用sca



# 2 版本选择

在guli_parent中确认以下依赖的版本

## 2.1 统一springboot版本

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.2.2.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
```

## 2.2 统一springcloud版本

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-dependencies</artifactId>
    <version>Hoxton.SR1</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

## 2.3 统一sca版本

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-alibaba-dependencies</artifactId>
    <version>2.1.0.RELEASE</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```



# 3 nacos安装和使用

## 3.1 nacos安装启动

nacos下载地址（类似tomcat软件）: https://github.com/alibaba/nacos/releases

下载版本：nacos-server-1.1.4.zip 或 nacos-server-1.1.4.tar.gz，解压任意目录即可

启动: 

```shell
cd bin/
sh startup.sh -m standalone
```



后台管理入口: http://localhost:8848/nacos/index.html

用户名密码：nacos/nacos



## 3.2 nacos注册edu微服务

(1)引入依赖

service模块中配置Nacos客户端的pom依赖

```xml

<!--服务注册-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

(2)添加服务配置信息

配置application.properties，在客户端微服务中添加注册Nacos服务的配置信息

```yaml
#spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
```

(3) 添加Nacos客户端注解

在客户端微服务启动类中添加注解

```java
@EnableDiscoveryClient
```

(4)启动客户端微服务

启动注册中心，启动已注册的微服务，可以在Nacos服务列表中看到被注册的微服务



## 3.3 同理注册oss微服务



## 3.4 nacos下划线兼容性很差

```shell
servive_edu(报错)

service-edu(正确) 
```



## 3.5 测试

启动edu微服务，刷新micro服务管理列表页面

<font size=4 color="red">每次启动项目之前，先把nacos启动一下</font>



# 4 openfeign

## 4.1 OpenFeign是什么

OpenFeign是Spring Cloud提供的一个声明式的伪Http客户端， 它使得调用远程服务就像调用本地服务一样简单， 只需要创建一个接口并添加一个注解即可。

Nacos很好的兼容了OpenFeign， OpenFeign默认集成了 Ribbon， 所以在Nacos下使用OpenFeign默认就实现了负载均衡的效果。

## 4.2 OpenFeign的引入

(1)引入依赖

service模块中配置OpenFeign的pom依赖（实际是在服务消费者端需要OpenFeign的依赖）

```xml
<!--服务调用-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

(2)启动类添加注解

在service_edu的启动类添加如下注解

```java
@EnableFeignClients
```

## 4.3 OpenFeign的使用

（1）oss微服务中创建测试api

服务的生产者的FileController中添加如下方法：

```java
@ApiOperation(value = "测试openfeign")
@GetMapping("test")
public R test() {
    log.info("oss test被调用");
    return R.ok();
}
```

(2)edu微服务中创建远程调用接口

服务消费者中创建feign包，创建如下接口：

```java

package com.atguigu.guli.service.edu.feign;

@Service
@FeignClient("service-oss")
public interface OssFileService {
    @GetMapping("/admin/oss/file/test")
    R test();
}
```

（3）调用远程方法

服务消费者中的TeacherController中添加如下方法：

```java
@Autowired
private OssFileService ossFileService;

@ApiOperation("测试服务调用")
@GetMapping("test")
public R test(){
    ossFileService.test();
    return R.ok();
}
```

swagger里测试，清空idea日志，查看idea日志



# 5 ribbon负载均衡

## 5.1 配置多实例

给oss取editconfiguration，点击oss，点击复制上一个重命名为8120，下一个重命名为8121

![image-20211103123340164](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211103123340164.png)



## 5.2 测试负载均衡

启动8120,8121,8110

清除三台微服务的控制台日志

测试 localhost:8110/swagger-ui.html里的test接口

点击try，发现是8121接受了这次请求，再点一下是8120，再点一下是8121，所以默认机制是轮询





## 5.3 Ribbon的负载均衡策略

| 策略名                    | 策略描述                                                     |
| ------------------------- | ------------------------------------------------------------ |
| BestAvailableRule         | 选择一个最小的并发请求的server                               |
| AvailabilityFilteringRule | 过滤掉那些因为一直连接失败的被标记为circuit tripped的后端server，并过滤掉那些高并发的的后端server（activeconnections 超过配置的阈值） |
| WeightedResponseTimeRule  | 根据响应时间分配一个weight，响应时间越长，weight越小，被选中的可能性越低。 |
| RetryRule                 | 对选定的负载均衡策略机上重试机制。                           |
| RoundRobinRule            | 轮询选择server                                               |
| RandomRule                | 随机选择一个server                                           |
| ZoneAvoidanceRule         | 综合判断server所在区域的性能和server的可用性选择server       |



配置负载均衡策略的方式：配置在eduservice里

```yaml
service-oss: # 调用的提供者的名称
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```

清除日志，请求5次，查看效果，连续三次压给8121



## **5.4 解决方案**

application.yml文件中配置ribbon的超时时间（因为OpenFeing的底层即是对ribbon的封装）

```yaml
ribbon:
  ConnectTimeout: 10000 #连接建立的超时时长，默认1秒
  ReadTimeout: 10000 #处理请求的超时时间，默认为1秒
```



## 5.5 接下去学什么

Zxjy,mysql,redis,送水公司员工管理系统,blog,boot电脑商城



# 6 OpenFeign的超时控制

## 6.1 模拟长流程业务

修改oss服务FileController的test方法，添加sleep 3秒：

```java
@ApiOperation(value = "测试")
@GetMapping("test")
public R test() {
    log.info("oss test被调用");
    try {
        TimeUnit.SECONDS.sleep(3);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    return R.ok();
}
```

## 6.2 远程调用测试

上面的程序在测试时会出现远程调用超时错误。如下：因为OpenFeign默认等待1秒钟，否则超时报错

serviceedu的控制台日志显示超时

超时后，服务消费者端默认会发起一次重试

重试规则：每隔一秒发起重试

```yaml
#在eduservice的yaml
ribbon:
  MaxAutoRetries: 0 # 同一实例最大重试次数，不包括首次调用，默认0，不重试
  MaxAutoRetriesNextServer: 1 # 重试其他实例的最大重试次数，不包括首次所选的server，默认1，重试1次
#总共两次
```

## 6.3 **解决方案**

```yaml
ribbon:
  ConnectTimeout: 10000 #连接建立的超时时长，默认1秒
  ReadTimeout: 10000 #处理请求的超时时间，默认为1秒
```



feign.RetryableException: Read timed out executing GET http://service-oss/admin/oss/file/test



额外的方案

```yaml
#在eduservice的yaml
ribbon:
  MaxAutoRetries: 1 # 同一实例最大重试次数，不包括首次调用，默认0，不重试
  MaxAutoRetriesNextServer: 1 # 重试其他实例的最大重试次数，不包括首次所选的server，默认1，重试1次
#总共4次
```



清除三台日志，测试tesswagger，然后发现只有一台oss微服务服务器处理了请求，而且成功了



# 7 删除讲师头像

Edu微服务对oss微服务发起一个远程调用

## 7.1需求：

删除讲师的同时删除讲师头像

## 7.2 删除文件接口

oss微服务中实现删除文件接口

## 7.3 FileService接口

```java
void removeFile(String url);
```

## 7.4 FileService实现

```java
@Override
public void removeFile(String url) {
    String endpoint = ossProperties.getEndpoint();
    String keyid = ossProperties.getKeyid();
    String keysecret = ossProperties.getKeysecret();
    String bucketname = ossProperties.getBucketname();
    // 创建OSSClient实例。
    OSS ossClient = new OSSClientBuilder().build(endpoint, keyid, keysecret);
    String host = "https://" + bucketname + "." + endpoint + "/";
    String objectName = url.substring(host.length());
    // 删除文件。
    ossClient.deleteObject(bucketname, objectName);
    // 关闭OSSClient。
    ossClient.shutdown();
}
```

## 7.5 FileController

```java

@ApiOperation("文件删除")
@DeleteMapping("remove")
public R removeFile(
    @ApiParam(value = "要删除的文件路径", required = true)
    @RequestBody String url) {
    fileService.removeFile(url);
    return R.ok().message("文件刪除成功");
}
```



重启edu和oss只启动8120，不启动8121

8120/swagger-ui.html

登录阿里云控制台，随便上传一张图片

URL https://yunzou-edu.oss-cn-beijing.aliyuncs.com/avatar/girl8.jpg

文件删除成功



# 8 OpenFeign远程调用删除头像

edu微服务中实现远程调用

## 8.1 创建远程调用接口

```java
package com.atguigu.guli.service.edu.feign;

@Service
@FeignClient("service-oss")
public interface OssFileService {
    @DeleteMapping("/admin/oss/file/remove")
    R removeFile(@RequestBody String url);
}
```

## 8.2 调用远程方法

TeacherService中增加根据讲师id删除图片的方法

接口

```java
boolean removeAvatarById(String id);
```



## 8.3 实现

```java
@Autowired
private OssFileService ossFileService;

@Override
public boolean removeAvatarById(String id) {
    Teacher teacher = baseMapper.selectById(id);
    if(teacher != null) {
        String avatar = teacher.getAvatar();
        if(!StringUtils.isEmpty(avatar)){
            //删除图片
            R r = ossFileService.removeFile(avatar);
            return r.getSuccess();
        }
    }
    return false;
}
```



## 8.4 controller层

修改TeacherController中的removeById方法，删除讲师的同时删除头像

```java
@ApiOperation(value = "根据ID删除讲师", notes = "根据ID删除讲师，逻辑删除")
@DeleteMapping("remove/{id}")
public R removeById(@ApiParam(value = "讲师ID", required = true) @PathVariable String id){
    //删除图片
    teacherService.removeAvatarById(id);
    //删除讲师
    boolean result = teacherService.removeById(id);
    if(result){
        return R.ok().message("删除成功");
    }else{
        return R.error().message("数据不存在");
    }
}
```

## 8.5 前端修改

前端src/request.js修改超时时间

```java
// 创建axios实例
const service = axios.create({
  baseURL: process.env.BASE_API, // api 的 base_url
  timeout: 12000 // 请求超时时间
})
```



