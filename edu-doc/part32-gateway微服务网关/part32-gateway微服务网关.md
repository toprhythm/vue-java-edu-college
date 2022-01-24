# part32-gateway微服务网关

# 1 API网关介绍

## 1.1 网关基本概念

API 网关出现的原因是微服务架构的出现，不同的微服务一般会有不同的网络地址，而外部客户端可能需要调用多个服务的接口才能完成一个业务需求，如果让客户端直接与各个微服务通信，会有以下的问题：

（1）客户端会多次请求不同的微服务，增加了客户端的复杂性。

（2）存在跨域请求，在一定场景下处理相对复杂。

（3）认证复杂，每个服务都需要独立认证。

（4）难以重构，随着项目的迭代，可能需要重新划分微服务。例如，可能将多个服务合并成一个或者将一个服务拆分成多个。如果客户端直接与微服务通信，那么重构将会很难实施。

以上这些问题可以借助 API 网关解决。API 网关是介于客户端和服务器端之间的中间层，所有的外部请求都会先经过 API 网关这一层。也就是说，API 的实现方面更多的考虑业务逻辑，而安全、性能、监控可以交由 API 网关来做，这样既提高业务灵活性又不缺安全性

## 1.2 **Spring Cloud Gateway**

**Spring cloud gateway**是spring官方基于Spring 5.0和Spring Boot2.0等技术开发的网关，Spring Cloud Gateway旨在为微服务架构提供简单、有效和统一的API路由管理方式，Spring Cloud Gateway作为Spring Cloud生态系统中的网关，目标是替代Netflix Zuul，其不仅提供统一的路由方式，并且还基于Filer链的方式提供了网关基本的功能，例如：安全、监控/埋点、限流等。



## 1.3 ***\*Spring Cloud Gateway 核心概念\****

下面介绍一下Spring Cloud Gateway中几个重要的概念。

（1）路由。路由是网关最基础的部分，路由信息有一个ID、一个目的URL、一组断言和一组Filter组成。如果断言路由为真，则说明请求的URL和配置匹配

（2）断言。Java8中的断言函数。Spring Cloud Gateway中的断言函数允许开发者去定义匹配来自于http request中的任何信息，比如请求头和参数等。

（3）过滤器。一个标准的Spring webFilter。Spring cloud gateway中的filter分为两种类型的Filter，分别是Gateway Filter和Global Filter。过滤器Filter将会对请求和响应进行修改处理。

## 1.4 执行流程

如下图所示，Spring cloud Gateway发出请求。然后再由Gateway Handler Mapping中找到与请求相匹配的路由，将其发送到Gateway web handler。Handler再通过指定的过滤器链将请求发送到我们实际的服务执行业务逻辑，然后返回。

![image-20211118103841437](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118103841437.png)

## 1.4 **特点**

优点：

- 性能强劲：是第一代网关Zuul的1.6倍
- 功能强大：内置了很多实用的功能，例如转发、监控、限流等
- 设计优雅，容易扩展

缺点：

- 其实现依赖Netty与WebFlux，不是传统的Servlet编程模型，学习成本高
- 不能将其部署在Tomcat、Jetty等Servlet容器里，只能打成jar包执行
- 需要Spring Boot 2.0及以上的版本，才支持



# 2 搭建Gateway服务

## 2.1 创建父模块infrastructure 创建模块

在guli_parent下创建普通maven模块

Artifact：infrastructure

## 2.2 删除src目录

# 3 创建模块api_gateway

## 3.1 创建模块

在infrastructure下创建普通maven模块

Artifact：api_gateway

## 3.2 配置pom

在api_gateway的pom中添加如下依赖

```xml
<dependencies>
    <!-- 网关 -->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-gateway</artifactId>
    </dependency>
</dependencies>
```

## 3.3 配置application.yml

```yaml
server:
  port: 9110 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: infrastructure-apigateway # 服务名
```

## 3.4 logback.xml

修改日志输出目录名为 apigateway

## 3.5 创建启动类

```java
package com.yunzoukj.yunzou.infrastructure.apigateway;

@SpringBootApplication
public class InfrastructureApiGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(InfrastructureApiGatewayApplication.class, args);
    }
}
```

## 3.6 启动网关微服务



# 4 配置路由和跨域

## 4.1 基本配置 路由和断言

application.yml文件中添加路由配置

- -：表示数组元素，可以配置多个节点
- id：配置的唯一标识，可以和微服务同名，也可以起别的名字，区别于其他 Route。
- uri：路由指向的目的地 uri，即客户端请求最终被转发到的微服务。
- predicates：断言的作用是进行条件判断，只有断言都返回真，才会真正的执行路由。
- Path：路径形式的断言。当匹配这个路径时，断言条件成立
- /**：一个或多个层次的路径

```yaml
#spring:
  cloud:
    gateway:
      routes:
      - id: service-edu
        uri: http://localhost:8110
        predicates:
        - Path=/user/**
```

## 4.2 测试网关路由转发

访问：http://localhost:9110/user/info

请求转发到：[http://localhost:8110/user/info](http://localhost:9110/user/info)

![image-20211118104336156](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118104336156.png)

# 5 通过nacos注册中心

## 5.1 网关中添加依赖

```xml
<!--服务注册-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

## 5.2 主类添加注解

```java
@EnableDiscoveryClient
class InfrastructureApiGatewayApplication
```

## 5.3 添加nacos配置

```yaml
#spring:
#  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
```

## 5.4 添加gateway配置

```yaml
#spring:
#  cloud:
#    gateway:
      discovery:
        locator:
          enabled: true # gateway可以发现nacos中的微服务
```

## 5.5 修改uri配置

将uri的地址修改成注册中心中的微服务地址，网关姜葱nacos中按照名称获取微服务

lb：表示在集群环境下通过负载均衡的方式调用

```yaml
uri: lb://service-edu
```

## 5.6 测试

访问：http://localhost:9110/user/info

## 5.7 匹配多个path

```yaml
- Path=/user/**, /*/edu/**
```

# 6 跨域配置

## 6.1 前端配置

修改guli-admin中 config/dev.env.js，BASE_API指定到网关地址

```js
BASE_API: '"http://127.0.0.1:9110"',
```

## 6.2 删除后端跨域配置

此时可以删除微服务中的跨域注解 *@CrossOrigin*

*例如 service_edu中 LoginController的跨域注解*

## 6.3 跨域配置

```java
package com.yunzoukj.yunzou.infrastructure.apigateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.web.util.pattern.PathPatternParser;

/**
 * @author helen
 * @since 2020/5/8
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsWebFilter corsFilter() {

        CorsConfiguration config = new CorsConfiguration();
        config.addAllowedMethod("*");
        config.addAllowedOrigin("*");
        config.addAllowedHeader("*");

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource(new PathPatternParser());
        source.registerCorsConfiguration("/**", config);

        return new CorsWebFilter(source);
    }
}
```

注意：去掉后端的所有跨域配置



# 7 	完整的路由配置

## 7.1 yml配置

```yaml
routes:
- id: service-edu
  uri: lb://service-edu
  predicates:
  - Path=/user/**, /*/edu/**
- id: service-cms
  uri: lb://service-cms
  predicates:
  - Path=/*/cms/**
- id: service-oss
  uri: lb://service-oss
  predicates:
  - Path=/*/oss/**
- id: service-sms
  uri: lb://service-sms
  predicates:
  - Path=/*/sms/**
- id: service-trade
  uri: lb://service-trade
  predicates:
  - Path=/*/trade/**
- id: service-ucenter
  uri: lb://service-ucenter
  predicates:
  - Path=/*/ucenter/**
- id: service-vod
  uri: lb://service-vod
  predicates:
  - Path=/*/vod/**  
```

## 7.2 **前端配置**

（1）修改guli-site中 utils/request.js，BASE_API指定到网关地址

（2）所有的api模块中的baseURL可以删除

（3）guli-admin上传相关表单中action地址的修改

data中定义：

```js
BASE_API: process.env.BASE_API
```

html中使用：

```js
:action="BASE_API+'/admin/oss/file/upload?module=avatar'"
```

# 8 **内置路由断言工厂**

## 8.1 路由断言

Predicate(断言) 用于进行条件判断，只有断言都返回真，才会真正的执行路由。

SpringCloud Gateway包括许多内置的断言工厂，所有这些断言都与HTTP请求的不同属性匹配。具体如下：

## 8.2 基于Datetime

此类型的断言根据时间做判断，主要有三个：

- AfterRoutePredicateFactory： 接收一个日期参数，判断请求日期是否晚于指定日期
- BeforeRoutePredicateFactory： 接收一个日期参数，判断请求日期是否早于指定日期
- BetweenRoutePredicateFactory： 接收两个日期参数，判断请求日期是否在指定时间段内

```java
- After=2019-12-31T23:59:59.789+08:00[Asia/Shanghai]
```

## 8.3 基于远程地址

RemoteAddrRoutePredicateFactory：接收一个IP地址段，判断请求主机地址是否在地址段中

```java
- RemoteAddr=192.168.1.1/24
```

## 8.4 基于Cookie

CookieRoutePredicateFactory：接收两个参数，cookie 名字和一个正则表达式。 判断请求cookie是否具有给定名称且值与正则表达式匹配。

```java
- Cookie=chocolate, ch.
```

## 8.5 基于Header

HeaderRoutePredicateFactory：接收两个参数，标题名称和正则表达式。 判断请求Header是否具有给定名称且值与正则表达式匹配。

```java
- Header=X-Request-Id, \d+
```

## 8.6 基于Host

HostRoutePredicateFactory：接收一个参数，主机名模式。判断请求的Host是否满足匹配规则。

```java
- Host=**.testhost.org
```

## 8.7 基于Method请求方法

MethodRoutePredicateFactory：接收一个参数，判断请求类型是否跟指定的类型匹配。

```java
- Method=GET
```

## 8.8 基于Path请求路径

```java
- Path=/foo/**
```

## 8.9 基于Query请求参数

QueryRoutePredicateFactory ：接收两个参数，请求param和正则表达式， 判断请求参数是否具有给定名称且值与正则表达式匹配。

```yaml
- Query=baz, ba.
```

## 8.10 基于路由权重

WeightRoutePredicateFactory：接收一个[组名,权重]，然后对于同一个组内的路由按照权重转发

```yaml
routes:
- id: weight_route1 
  uri: host1 
  predicates:
  - Path=/product/**
  - Weight=group3, 1
- id: weight_route2 
  uri: host2 
  predicates:
  - Path=/product/**
  - Weight= group3, 9

```



# 9 **过滤器的基本概念**

## 9.1 作用

过滤器就是在请求的传递过程中，对请求和响应做一些修改

## 9.2 生命周期

客户端的请求先经过“pre”类型的filter，然后将请求转发到具体的业务服务，收到业务服务的响应之后，再经过“post”类型的filter处理，最后返回响应到客户端。

pre： 这种过滤器在请求被路由之前调用。我们可利用这种过滤器实现参数校验、权限校验、流量监控、日志输出、协议转换等；

post：这种过滤器在路由到达微服务以后执行。这种过滤器可用做响应内容、响应头的修改，日志的输出，流量监控等。

![image-20211118105909416](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118105909416.png)

## 9.3 分类

局部过滤器 GatewayFilter：作用在某一个路由上

全局过滤器 GlobalFilter：作用全部路由上

# 10 局部过滤器

## 10.1 内置局部过滤器

在SpringCloud Gateway中内置了很多不同类型的网关路由过滤器。具体如下

| 过滤器工厂                  | 作用                                                         | 参数                                                         |
| --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| AddRequestHeader            | 为原始请求添加Header                                         | Header的名称及值                                             |
| AddRequestParameter         | 为原始请求添加请求参数                                       | 参数名称及值                                                 |
| AddResponseHeader           | 为原始响应添加Header                                         | Header的名称及值                                             |
| DedupeResponseHeader        | 剔除响应头中重复的值                                         | 需要去重的Header名称及去重策略                               |
| Hystrix                     | 为路由引入Hystrix的断路器保护                                | HystrixCommand 的名称                                        |
| FallbackHeaders             | 为fallbackUri的请求头中添加具体的异常信息                    | Header的名称                                                 |
| PreﬁxPath                   | 为原始请求路径添加前缀                                       | 前缀路径                                                     |
| PreserveHostHeader          | 为请求添加一个preserveHostHeader=true的属性，路由过滤器会检查该属性以决定是否要发送原始的Host | 无                                                           |
| RequestRateLimiter          | 用于对请求限流，限流算法为令牌桶                             | keyResolver、rateLimiter、statusCode、denyEmptyKey、emptyKeyStatus |
| RedirectTo                  | 将原始请求重定向到指定的URL                                  | http状态码及重定向的url                                      |
| RemoveHopByHopHeadersFilter | 为原始请求删除IETF组织规定的一系列Header                     | 默认就会启用，可以通过配置指定仅删除哪些Header               |
| RemoveRequestHeader         | 为原始请求删除某个Header                                     | Header名称                                                   |
| RemoveResponseHeader        | 为原始响应删除某个Header                                     | Header名称                                                   |
| RewritePath                 | 重写原始的请求路径                                           | 原始路径正则表达式以及重写后路径的正则表达式                 |
| RewriteResponseHeader       | 重写原始响应中的某个Header                                   | Header名称，值的正则表达式，重写后的值                       |
| SaveSession                 | 在转发请求之前，强制执行WebSession::save 操作                | 无                                                           |
| secureHeaders               | 为原始响应添加一系列起安全作用的响应头                       | 无，支持修改这些安全响应头的值                               |
| SetPath                     | 修改原始的请求路径                                           | 修改后的路径                                                 |
| SetResponseHeader           | 修改原始响应中某个Header的值                                 | Header名称，修改后的值                                       |
| SetStatus                   | 修改原始响应的状态码                                         | HTTP 状态码，可以是数字，也可以是字符串                      |
| StripPreﬁx                  | 用于截断原始请求的路径                                       | 使用数字表示要截断的路径的数量                               |
| Retry                       | 针对不同的响应进行重试                                       | retries、statuses、methods、series                           |
| RequestSize                 | 设置允许接收最大请求包的大 小。如果请求包大小超过设置的值，则返回 413 Payload TooLarge | 请求包大小，单位为字节，默认值为5M                           |
| ModifyRequestBody           | 在转发请求之前修改原始请求体内容                             | 修改后的请求体内容                                           |
| ModifyResponseBody          | 修改原始响应体的内容                                         | 修改后的响应体内容                                           |

## 10.2 **内置局部过滤器的使用**

```yaml
routes:
- id: service-edu
uri: lb://service-edu
predicates:
- Path=/user/**, /*/edu/**
filters:
- SetStatus=250 # 修改返回状态码
```

![image-20211118110040332](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110040332.png)

![image-20211118110048992](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110048992.png)

# 11 全局过滤器

## 11.1 内置全局过滤器

![image-20211118110109307](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110109307.png)

内置全局过滤器的使用举例：负载均衡过滤器

```YAML
lb://service-edu
```

## 11.2 **自定义全局过滤器

定义一个Filter实现 GlobalFilter 和 Ordered接口

# 12 网关鉴权

## 12.1 **问题**

当我们在未登录状态下点击“购买课程”按钮时，会显示“未知错误”，查看trade微服务控制台，发现

![image-20211118110217582](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110217582.png)

JWT为空，无法鉴权。

## 12.2 **解决方案**

微服务网关中添加自定义全局过滤器，统一处理需要鉴权的服务

## 12.3 **鉴权逻辑描述**

- 当客户端第一次请求服务时，服务端对用户进行信息认证（登录）
- 认证通过，将用户信息进行加密形成token，返回给客户端
- 作为登录凭证以后每次请求，客户端都携带认证的token
- 服务端对token进行解密，判断是否有效

![image-20211118110251303](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110251303.png)

对于验证用户是否已经登录鉴权的过程可以在网关统一检验。检验的标准就是请求中是否携带token凭证以及token的正确性。

下面的我们自定义一个GlobalFilter，去校验所有的请求参数中是否包含“token”，如何不包含请求

参数“token”则不转发路由，否则执行正常的逻辑。

# 13 开发鉴权逻辑

## 13.1 网关中添加依赖

```XML
<dependency>
     <groupId>com.atguigu</groupId>
     <artifactId>common_util</artifactId>
     <version>0.0.1-SNAPSHOT</version>
     <!--排除spring-boot-starter-web，否则和gateway中的webflux冲突-->
     <exclusions>
         <exclusion>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
         </exclusion>
     </exclusions>
</dependency>
<!--将随着spring-boot-starter-web排除的servlet-api添加回来 -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
<!--gson-->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
</dependency>
```

## 13.2 排除数据源自动配置

```java
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
```

## 13.3 创建过滤器

```java
package com.atguigu.guli.infrastructure.apigateway.filter;

@Component
public class AuthGlobalFilter implements GlobalFilter, Ordered {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String path = request.getURI().getPath();
        //谷粒学院api接口，校验用户必须登录
        AntPathMatcher antPathMatcher = new AntPathMatcher();
        if(antPathMatcher.match("/api/**/auth/**", path)) {
            List<String> tokenList = request.getHeaders().get("token");
            //没有token
            if(null == tokenList) {
                ServerHttpResponse response = exchange.getResponse();
                return out(response);
            }
            //token校验失败
            Boolean isCheck = JwtUtils.checkJwtTToken(tokenList.get(0));
            if(!isCheck) {
                ServerHttpResponse response = exchange.getResponse();
                return out(response);
            }
        }
        //放行
        return chain.filter(exchange);
    }
    //定义当前过滤器的优先级，值越小，优先级越高
    @Override
    public int getOrder() {
        return 0;
    }
    private Mono<Void> out(ServerHttpResponse response) {
        JsonObject message = new JsonObject();
        message.addProperty("success", false);
        message.addProperty("code", 28004);
        message.addProperty("data", "");
        message.addProperty("message", "鉴权失败");
        byte[] bytes = message.toString().getBytes(StandardCharsets.UTF_8);
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        //指定编码，否则在浏览器中会中文乱码
        response.getHeaders().add("Content-Type", "application/json;charset=UTF-8");
        //输出http响应
        return response.writeWith(Mono.just(buffer));
    }
}
```

```
测试：未登录状态下点击立即购买显示“鉴权失败”
```

![image-20211118110515056](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118110515056.png)

## 13.4 前端修改

```
guli-site的utils/request.js中修改响应过滤器 ，添加分支：

```

```java
else if (res.code === 28004) { // 鉴权失败
    window.location.href = '/login'
    return
} 
```

修改pages/login.vue的submitLogin方法：登录后回到原来的页面

```js
// 跳转到首页
// window.location.href = '/'
if (document.referrer.indexOf('register') !== -1) {
    window.location.href = '/'
} else {
    history.go(-1)
}
```

