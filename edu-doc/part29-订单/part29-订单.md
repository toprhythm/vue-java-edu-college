# part29-订单

# 1 数据库

## 1.1 数据库

创建数据库：guli_trade

Utf8mb4 utfbmb4_general_ci

```sql
create database db_yunzoukj_trade CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```



## 1.2 **数据表**

执行sql脚本
guli_trade.sql

由于交易模块与教学模块、会员模块是不同的服务模块和不同数据库，所以我们在订单表冗余了课程与会员相关的表字段，这样有利于数据库表查询效率。支付成功后我们会把支付平台返回的数据全部记录，并且更新订单状态。

# 2 **创建交易微服务**

课程分为免费观看与付费观看，如果是付费观看的课程，会员需下单支付后才可以观看

## 2.1 创建模块

service_trade

## 2.2 **配置 pom.xml**

```xml
<build>
    <!-- 项目打包时会将java目录中的*.xml文件也进行打包 -->
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
            </includes>
            <filtering>false</filtering>
        </resource>
    </resources>
</build>
```

## 2.3 application.yml

```yaml
server:
  port: 8170 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-trade # 服务名
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
    sentinel:
      transport:
        port: 8081
        dashboard: localhost:8080
  #spring:
  redis:
    host: 127.0.0.1
    port: 6379
    database: 0
    password: #123456 #默认为空
    lettuce:
      pool:
        max-active: 20  #最大连接数，负值表示没有限制，默认8
        max-wait: -1    #最大阻塞等待时间，负值表示没限制，默认-1
        max-idle: 8     #最大空闲连接，默认8
        min-idle: 0     #最小空闲连接，默认0
  datasource: # mysql数据库连接
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://216.127.184.152:3306/db_yunzoukj_trade?serverTimezone=GMT%2B8
    username: root
    password: Zwq2573424062@qq.com
  #spring:
  jackson: #返回json的全局时间格式
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #mybatis日志
  mapper-locations: classpath:com/yunzoukj/yunzou/service/trade/mapper/xml/*.xml
ribbon:
  ConnectTimeout: 10000 #连接建立的超时时长，默认1秒
  ReadTimeout: 10000 #处理请求的超时时间，默认为1秒
feign:
  sentinel:
    enabled: true
```

## 2.4 logback-spring.xml

修改日志路径为 guli_log/trade

## 2.5 创建启动类

```java
package com.yunzoukj.yunzou.service.trade;

@SpringBootApplication
@ComponentScan({"com.yunzoukj.yunzou"})
@EnableDiscoveryClient
@EnableFeignClients
public class ServiceTradeApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceTradeApplication.class, args);
    }
}
```

## 2.6 MP代码生成器



# 3 新增订单接口

## 3.1 准备 工具类

在service_trade中添加util包、OrderNoUtils.java

## 3.2 定义dto对象

在service_base中创建DTO（Data Transfer Object）：服务和服务之间的数据传输对象

课程：CourseDto

```java
package com.atguigu.guli.service.base.dto;

@Data
public class CourseDto implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;//课程ID
    private String title;//课程标题
    private BigDecimal price;//课程销售价格，设置为0则可免费观看
    private String cover;//课程封面图片路径
    private String teacherName;//课程讲师
}
```

会员：MemberDto

```java
package com.atguigu.guli.service.base.dto;

@Data
public class MemberDto implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;//会员id
    private String mobile;//手机号
    private String nickname;//昵称
}
```

# 4 service_edu中创建接口

根据课程id获取订单中需要的课程和讲师信息

## 4.1 controller

ApiCourseController

```java
@ApiOperation("根据课程id查询课程信息")
@GetMapping("inner/get-course-dto/{courseId}")
public CourseDto getCourseDtoById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String courseId){
    CourseDto courseDto = courseService.getCourseDtoById(courseId);
    return courseDto;
}
```

## 4.2 service

CourseService接口：

```java
CourseDto getCourseDtoById(String courseId);
```

CourseServiceImpl实现：

```java
@Override
public CourseDto getCourseDtoById(String courseId) {
    return baseMapper.selectCourseDtoById(courseId);
}
```

## 4.3 mapper

CourseMapper接口：

```java
CourseDto selectCourseDtoById(String courseId);
```

CourseMapper.xml配置文件：

```java
<select id="selectCourseDtoById" resultType="com.atguigu.guli.service.base.dto.CourseDto">
    SELECT
    c.id,
    c.title,
    CONVERT(c.price, DECIMAL(8,2)) AS price,
    c.cover,
    t.name AS teacherName
    FROM
    edu_course c
    LEFT JOIN edu_teacher t ON c.teacher_id = t.id
    WHERE
    c.id = #{id}
</select>
```

# 5 service_ucenter中创建接口

根据用户id获取订单中需要的会员信息

## 5.1 **controller**

ApiMemberController

```java
@ApiOperation("根据会员id查询会员信息")
@GetMapping("inner/get-member-dto/{memberId}")
public MemberDto getMemberDtoByMemberId(
    @ApiParam(value = "会员ID", required = true)
    @PathVariable String memberId){
    MemberDto memberDto = memberService.getMemberDtoByMemberId(memberId);
    return memberDto;
}
```

## 5.2 service

MemberService接口：

```java
MemberDto getMemberDtoByMemberId(String memberId);
```

MemberServiceImpl实现：

```java
@Override
public MemberDto getMemberDtoByMemberId(String memberId) {
    Member member = baseMapper.selectById(memberId);
    MemberDto memberDto = new MemberDto();
    BeanUtils.copyProperties(member, memberDto);
    return memberDto;
}
```

# 6 service_trade远程调用

## 6.1 调用service_edu

接口：

```java
package com.atguigu.guli.service.trade.feign;

@Service
@FeignClient(value = "service-edu", fallback = EduCourseServiceFallBack.class)
public interface EduCourseService {
    @GetMapping(value = "/api/edu/course/inner/get-course-dto/{courseId}")
    CourseDto getCourseDtoById(@PathVariable(value = "courseId") String courseId);
}
```

容错：

```java
package com.atguigu.guli.service.trade.feign.fallback;

@Service
@Slf4j
public class EduCourseServiceFallBack implements EduCourseService {
    @Override
    public CourseDto getCourseDtoById(String courseId) {
        log.info("熔断保护");
        return null;
    }
}
```

## 6.2 **调用service_ucenter**

接口：

```java
package com.atguigu.guli.service.trade.feign;

@Service
@FeignClient(value = "service-ucenter", fallback = UcenterMemberServiceFallBack.class)
public interface UcenterMemberService {
    @GetMapping(value = "/api/ucenter/member/inner/get-member-dto/{memberId}")
    MemberDto getMemberDtoByMemberId(@PathVariable(value = "memberId") String memberId);
}
```

容错：

```java
package com.atguigu.guli.service.trade.feign.fallback;

@Service
@Slf4j
public class UcenterMemberServiceFallBack implements UcenterMemberService {
    @Override
    public MemberDto getMemberDtoByMemberId(String memberId) {
        log.info("熔断保护");
        return null;
    }
}
```

# 7 在service_trade中保存订单

## 7.1 controller

ApiOrderController创建新增订单方法

```java
package com.atguigu.guli.service.trade.controller.api;

@RestController
@RequestMapping("/api/trade/order")
@Api(description = "网站订单管理")
@CrossOrigin //跨域
@Slf4j
public class ApiOrderController {
    @Autowired
    private OrderService orderService;
    @ApiOperation("新增订单")
    @PostMapping("auth/save/{courseId}")
    public R save(@PathVariable String courseId, HttpServletRequest request) {
        JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
        String orderId = orderService.saveOrder(courseId, jwtInfo.getId());
        return R.ok().data("orderId", orderId);
    }
}
```

## 7.2 service

OrderService接口

```java
String saveOrder(String courseId, String memberId);
```

OrderServiceImpl实现

```java
@Autowired
private EduCourseService eduCourseService;
@Autowired
private UcenterMemberService ucenterMemberService;
@Override
public String saveOrder(String courseId, String memberId) {
    //查询当前用户是否已有当前课程的订单
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("course_id", courseId);
    queryWrapper.eq("member_id", memberId);
    Order orderExist = baseMapper.selectOne(queryWrapper);
    if(orderExist != null){
        return orderExist.getId(); //如果订单已存在，则直接返回订单id
    }
    //查询课程信息
    CourseDto courseDto = eduCourseService.getCourseDtoById(courseId);
    if (courseDto == null) {
        throw new GuliException(ResultCodeEnum.PARAM_ERROR);
    }
    //查询用户信息
    MemberDto memberDto = ucenterMemberService.getMemberDtoByMemberId(memberId);
    if (memberDto == null) {
        throw new GuliException(ResultCodeEnum.PARAM_ERROR);
    }
    //创建订单
    Order order = new Order();
    order.setOrderNo(OrderNoUtils.getOrderNo());
    order.setCourseId(courseId);
    order.setCourseTitle(courseDto.getTitle());
    order.setCourseCover(courseDto.getCover());
    order.setTeacherName(courseDto.getTeacherName());
    order.setTotalFee(courseDto.getPrice().multiply(new BigDecimal(100)));//分
    order.setMemberId(memberId);
    order.setMobile(memberDto.getMobile());
    order.setNickname(memberDto.getNickname());
    order.setStatus(0);//未支付
    order.setPayType(1);//微信支付
    baseMapper.insert(order);
    return order.getId();
}
```

## 7.3 在postman中测试

先登录，再使用jwt测试订单的生成

1 打开localhost:8160/swagger-ui.html ,测试一次登录接口，拿到jwt，给postman用

```shell
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJndWxpLXVzZXIiLCJpYXQiOjE2MzcwMjUwNzAsImV4cCI6MTYzNzAyNjg3MCwiaWQiOiIxNDU5NzAwMTkyMDkxOTgzODczIiwibmlja25hbWUiOiJ6d3ExMjMiLCJhdmF0YXIiOiJodHRwOi8va3Iuc2hhbmdoYWktaml1eGluLmNvbS9maWxlLzIwMjEvMDIyNi9zbWFsbDQyZTE2ZjNkNTQ5N2ZhMGYyYzM4ZDg1YTQ0MzFhYjMwLmpwZyJ9.Z0kXEdhrS1ZwE_dmnGNQhz1h0uG9HUClGMmXFudjkys
```

2 打开postman，增加文件夹，交易中心，增加一个接口post，打开8170swagger

```shell
http://localhost:8170/api/trade/order/auth/save/{courseId}
```

3 也就是说postman，加上token参数，加上这个post请求：http://localhost:8170/api/trade/order/auth/save/1458032708263763969，拿到orderId，去数据库查看order表

整个测试完成



# 8 前端整合下单流程

## 8.1 课程页面 api

api/order.js

```js
import request from '~/utils/request'
export default {
  createOrder(courseId) {
    return request({
      baseURL: 'http://localhost:8170',
      url: `/api/trade/order/auth/save/${courseId}`,
      method: 'post'
    })
  }
}
```

## 8.2 购买按钮

pages/course/_id.vue

```html
<section class="c-attr-mt">
    <a
       href="javascript:void(0);"
       title="立即购买"
       class="comm-btn c-btn-3"
       @click="createOrder()">立即购买</a>
</section>
```

## 8.3 创建订单脚本

登录成功后，在课程详情页点击“立即购买”，调用创建订单方法，如下

pages/course/_id.vue

```js
import orderApi from '~/api/order'
```

```js
methods: {
    createOrder() {
        orderApi.createOrder(this.course.id).then(response => {
            this.$router.push({ path: '/order/' + response.data.orderId })
        })
    }
}
```

## 8.4 订单页面

pages/order/_id.vue

```html
<template>
  <div class="Page Confirm">
    <div class="Title">
      <h1 class="fl f18">订单确认</h1>
      <div class="clear"/>
    </div>
    <table class="GoodList">
      <tbody>
        <tr>
          <td colspan="3" class="teacher">讲师：{{ order.teacherName }}</td>
        </tr>
        <tr class="good">
          <td class="name First">
            <a :href="'/course/'+order.courseId" target="_blank">
              <img :src="order.courseCover">
            </a>
            <div class="goodInfo">
              <a :href="'/course/'+ order.courseId" target="_blank">{{ order.courseTitle }}</a>
            </div>
          </td>
          <td class="red priceNew Last">￥<strong>{{ order.totalFee/100 }}</strong></td>
        </tr>
      </tbody>
    </table>
    <div class="Finish">
      <div class="check fr">
        <el-checkbox v-model="agree">我已阅读并同意<a href="javascript:" target="_blank">《谷粒学院购买协议》</a></el-checkbox>
      </div>
      <div class="clear"/>
      <div class="Main fl">
        <div class="fl">
          <a :href="'/course/'+order.courseId">返回课程详情页</a>
        </div>
      </div>
      <el-button :disabled="!agree" type="danger">去支付</el-button>
      <div class="clear"/>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      order: {},
      agree: true
    }
  }
}
</script>
```



# 9 显示当前订单信息

根据订单id获取订单

## 9.1 后端接口 **Controller**

ApiOrderController

必须是自己的订单才能查看

```java
@ApiOperation("获取订单")
@GetMapping("auth/get/{orderId}")
public R get(@PathVariable String orderId, HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    Order order = orderService.getByOrderId(orderId, jwtInfo.getId());
    return R.ok().data("item", order);
}
```

## 9.2 **Service**

OrderService接口

```java
Order getByOrderId(String orderId, String memberId);
```

OrderService实现

```java
@Override
public Order getByOrderId(String orderId, String memberId) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper
        .eq("id", orderId)
        .eq("member_id", memberId);
    Order order = baseMapper.selectOne(queryWrapper);
    return order;
}
```

# 10 前端实现

## 10.1 api

api/order.js

```js
getById(orderId) {
    return request({
        baseURL: 'http://localhost:8170',
        url: `/api/trade/order/auth/get/${orderId}`,
        method: 'get'
    })
}
```

## 10.2 订单页面

pages/order/_id.vue

```js
import orderApi from '~/api/order'
```

```js
created() {
    orderApi.getById(this.$route.params.id).then(response => {
        this.order = response.data.item
    })
}
```



# 11 判断课程是否购买

## 11.1 后端接口 Controller

判断数据库中是否存在已支付订单

ApiOrderController

```java
@ApiOperation( "判断课程是否购买")
@GetMapping("auth/is-buy/{courseId}")
public R isBuyByCourseId(@PathVariable String courseId, HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    Boolean isBuy = orderService.isBuyByCourseId(courseId, jwtInfo.getId());
    return R.ok().data("isBuy", isBuy);
}
```



## 11.2 Service

OrderService接口

```java
Boolean isBuyByCourseId(String courseId, String memberId);
```

OrderServiceImpl实现

```java
@Override
public Boolean isBuyByCourseId(String courseId, String memberId) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper
        .eq("member_id", memberId)
        .eq("course_id", courseId)
        .eq("status", 1);
    Integer count = baseMapper.selectCount(queryWrapper);
    return count.intValue() > 0;
}
```

# 12 前端实现

## 12.1 api

api/order.js

```js
isBuy(courseId) {
    return request({
        baseURL: 'http://localhost:8170',
        url: `/api/trade/order/auth/is-buy/${courseId}`,
        method: 'get'
    })
}
```

## 12.2 课程页面

pages/course/_id.vue

```js
import cookie from 'js-cookie'
```

```js
data() {
    return {
      isBuy: false // 是否已购买
    }
},
created() {
    // 如果未登录，则isBuy=false
    // 如果已登录，则判断是否已购买
    var token = cookie.get('guli_jwt_token')
    if (token) {
      orderApi.isBuy(this.course.id).then(response => {
        this.isBuy = response.data.isBuy
      })
    }
},
```

## 12.3 购买和观看按钮

pages/course/_id.vue

```html
<section v-if="isBuy || course.price === 0" class="c-attr-mt">
    <a
       href="javascript:void(0);"
       title="立即观看"
       class="comm-btn c-btn-3">立即观看</a>
</section>
<section v-else class="c-attr-mt">
    <a
       href="javascript:void(0);"
       title="立即购买"
       class="comm-btn c-btn-3"
       @click="createOrder()">立即购买</a>
</section>
```

## 12.4 课时节点

pages/course/_id.vue

```html
<li v-for="video in chapter.children" :key="video.id" class="lh-menu-second ml30">
    <a
       v-if="isBuy || course.price === 0"
       :href="'/player/'+video.videoSourceId"
       :title="video.title">
        <em class="lh-menu-i-2 icon16 mr5">&nbsp;</em>{{ video.title }}
    </a>
    <a
       v-else-if="video.free === true"
       :href="'/player/'+video.videoSourceId"
       :title="video.title">
        <em class="lh-menu-i-2 icon16 mr5">&nbsp;</em>{{ video.title }}
        <i class="free-icon vam mr10">免费试听</i>
    </a>
    <a
       v-else
       :title="video.title">
        <em class="lh-menu-i-2 icon16 mr5">&nbsp;</em>{{ video.title }}
    </a>
</li>
```



