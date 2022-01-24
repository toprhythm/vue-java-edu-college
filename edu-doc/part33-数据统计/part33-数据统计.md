# part33-数据统计

# 1 页面需求

## 1.1 生成统计结果

![image-20211118125012651](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118125012651.png)

## 1.2 展示统计信息

![image-20211118125029424](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118125029424.png)



# 2 用户注册统计

## 2.0 用户注册统计

使用QueryWrapper查询出的用户是非逻辑删除的用户，这里我们想统计所有的用户，因此使用Mapper

## 2.1 mapper

接口：MemberMapper

```java
Integer selectRegisterNumByDay(String day);
```

映射文件：MemberMapper.xml

```java
<select id="selectRegisterNumByDay" resultType="java.lang.Integer">
    SELECT COUNT(1)
    FROM ucenter_member
    WHERE DATE(gmt_create) = #{day}
</select>
```

## 2.2 service

接口：MemberService

```java
Integer countRegisterNum(String day);
```

实现：MemberServiceImpl

```java
@Override
public Integer countRegisterNum(String day) {
    return baseMapper.selectRegisterNumByDay(day);
}
```



## 2.3 controller

```java
package com.atguigu.guli.service.ucenter.controller.admin;
//@CrossOrigin
@Api(description = "会员管理")
@RestController
@RequestMapping("/admin/ucenter/member")
public class MemberController {
    @Autowired
    private MemberService memberService;
    @ApiOperation(value = "根据日期统计注册人数")
    @GetMapping(value = "count-register-num/{day}")
    public R countRegisterNum(
            @ApiParam(name = "day", value = "统计日期")
            @PathVariable String day){
        Integer num = memberService.countRegisterNum(day);
        return R.ok().data("registerNum", num);
    }
}
```

## 2.4 Swagger测试

日期格式：2019-01-01



# 3 数据库设计

## 3.1 数据库

创建数据库：guli_statistics

字符集：utf8mb4

排序: utf8mb4_general_ci

create database {database name} CHARACTER SET utf8 COLLATE utf8_general_ci

```sql
create database db_yunzoukj_statistics CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```



## 3.2 **数据表**

执行sql脚本

```sql
guli_statistics.sql
```

# 4 **创建微服务**

## 4.1 创建模块

service_statistics

## 4.2 **配置 pom.xml**

```xml
<dependencies>
    <dependency>
        <groupId>joda-time</groupId>
        <artifactId>joda-time</artifactId>
    </dependency>
</dependencies>
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

## 4.3 application.yml

resources目录下创建文件

```yaml
server:
  port: 8180 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-statisticss # 服务名
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
    sentinel:
      transport:
        port: 8081
        dashboard: localhost:8080
  datasource: # mysql数据库连接
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://216.127.184.152:3306/db_yunzoukj_statistics?serverTimezone=GMT%2B8
    username: root
    password: Zwq2573424062@qq.com
  #spring:
  jackson: #返回json的全局时间格式
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #mybatis日志
  mapper-locations: classpath:com/yunzoukj/yunzoukj/service/statistics/mapper/xml/*.xml
ribbon:
  ConnectTimeout: 10000 #连接建立的超时时长，默认1秒
  ReadTimeout: 10000 #处理请求的超时时间，默认为1秒
feign:
  sentinel:
    enabled: true
```

## 4.4 logback-spring.xml

修改日志路径为 guli_log/statistics

## 4.5 创建SpringBoot启动类

```java
package com.yunzoukj.yunzou.service.statistics;

@SpringBootApplication
@ComponentScan({"com.yunzoukj.yunzou"})
@EnableDiscoveryClient
@EnableFeignClients
public class ServiceStatisticsApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceStatisticsApplication.class, args);
    }
}
```

## 4.6 MP代码生成器



# 5 调用用户注册统计

## 5.1 创建调用接口

```java
package com.atguigu.guli.service.statistics.feign;

@FeignClient(value = "service-ucenter", fallback = UcenterMemberServiceFallBack.class)
public interface UcenterMemberService {
    @GetMapping(value = "/admin/ucenter/member/count-register-num/{day}")
    R countRegisterNum(@PathVariable("day") String day);
}
```

## 5.2 服务熔断

```java
package com.atguigu.guli.service.statistics.feign.fallback;

@Service
@Slf4j
public class UcenterMemberServiceFallBack implements UcenterMemberService {
    @Override
    public R countRegisterNum(String day) {
        //错误日志
        log.error("熔断器被执行");
        return R.ok().data("registerNum", 0);
    }
}
```

## 5.3 service层

接口：DailyService

```java
void createStatisticsByDay(String day);
```

实现：DailyServiceImpl

```java
@Autowired
private UcenterMemberService ucenterMemberService;
@Transactional(rollbackFor = Exception.class)
@Override
public void createStatisticsByDay(String day) {
    //如果当日的统计记录已存在，则删除重新统计|或 提示用户当日记录已存在
    QueryWrapper<Daily> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("date_calculated", day);
    baseMapper.delete(queryWrapper);
    //生成统计记录
    R r = ucenterMemberService.countRegisterNum(day);
    Integer registerNum = (Integer)r.getData().get("registerNum");
    int loginNum = RandomUtils.nextInt(100, 200);
    int videoViewNum = RandomUtils.nextInt(100, 200);
    int courseNum = RandomUtils.nextInt(100, 200);
    //在本地数据库创建统计信息
    Daily daily = new Daily();
    daily.setRegisterNum(registerNum);
    daily.setLoginNum(loginNum);
    daily.setVideoViewNum(videoViewNum);
    daily.setCourseNum(courseNum);
    daily.setDateCalculated(day);
    baseMapper.insert(daily);
}
```

## 5.4 web层

```java
package com.atguigu.guli.service.statistics.controller.admin;

@Api(description="统计分析管理")
//@CrossOrigin
@RestController
@RequestMapping("/admin/statistics/daily")
public class DailyController {
    @Autowired
    private DailyService dailyService;
    @ApiOperation("生成统计记录")
    @PostMapping("create/{day}")
    public R createStatisticsByDay(
            @ApiParam("统计日期")
            @PathVariable String day) {
        dailyService.createStatisticsByDay(day);
        return R.ok().message("数据统计生成成功");
    }
}
```



# 6 前端实现

## 6.1 api

src/api/statistics.js

```js
import request from '@/utils/request'

export default {
  createStatistics(day) {
    return request({
      // baseURL: 'http://127.0.0.1:8180',
      url: `/admin/statistics/daily/create/${day}`,
      method: 'post'
    })
  }
}
```



# 7 路由

## 7.1 新建页面组件

![image-20211118125820316](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118125820316.png)

## 7.2 路由配置

src/router/index.js

```js
{
    path: '/statistics',
    component: Layout,
    redirect: '/statistics/create',
    name: 'Statistics',
    meta: { title: '统计分析' },
    children: [
      {
        path: 'create',
        name: 'StatisticsCreate',
        component: () => import('@/views/statistics/create'),
        meta: { title: '生成统计' }
      },
      {
        path: 'chart',
        name: 'StatisticsChart',
        component: () => import('@/views/statistics/chart'),
        meta: { title: '统计图表' }
      }
    ]
},
```

# 8 页面组件

## 8.1 html

src/views/statistics/create.vue

```html
<template>
  <div class="app-container">
    <!--表单-->
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item label="日期">
        <el-date-picker
          v-model="day"
          type="date"
          placeholder="选择要统计的日期"
          value-format="yyyy-MM-dd" />
      </el-form-item>
      <el-button
        :disabled="btnDisabled"
        type="primary"
        @click="genarateData()">生成</el-button>
    </el-form>
  </div>
</template>
```

## 8.2 script

```js
<script>
import statisticsApi from '@/api/statistics'
export default {
  data() {
    return {
      day: '',
      btnDisabled: false
    }
  },
  methods: {
    genarateData() {
      this.btnDisabled = true
      statisticsApi.createStatistics(this.day).then(response => {
        this.btnDisabled = false
        this.$message.success('生成成功')
      })
    }
  }
}
</script>
```

# 9 网关配置

微服务网关中添加如下配置

```yaml
      - id: service-statistics
        uri: lb://service-statistics
        predicates:
        - Path=/*/statistics/**
```

```sql
mysql> select id,date_calculated,video_view_num from statistics_daily  where date_calculated='2020-05-10';
+---------------------+-----------------+----------------+
| id                  | date_calculated | video_view_num |
+---------------------+-----------------+----------------+
| 1461210186109054977 | 2020-05-10      |            132 |
+---------------------+-----------------+----------------+

```



![image-20211118135413386](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211118135413386.png)



# 10 需求

每天凌晨1点自动生成前一天的统计数据



# 11 定时任务实现方式

## 11.1 Timer

使用jdk的Timer和TimerTask可以实现简单的间隔执行任务，无法实现按日历去调度执行任务



## 11.2 ScheduledThreadPool线程池

创建可以延迟或定时执行任务的线程，无法实现按日历去调度执行任务



## 11.3 quartz

使用Quartz实现 Quartz 是一个异步任务调度框架，功能丰富，可以实现按日历调度



## 11.4 Spring Task

Spring 3.0后提供Spring Task实现任务调度，支持按日历调度，相比Quartz功能稍简单，但是开发基本够用，支持注解编程方式



# 12 集成Spring Task

## 12.1 启动类添加注解

statistics启动类添加注解

```java
@EnableScheduling
```

## 12.2 创建定时任务类

使用cron表达式

```java
package com.atguigu.guli.service.statistics.task;

@Slf4j
@Component
public class ScheduledTask {
    @Autowired
    private DailyService dailyService;
    /**
     * 测试
     */
    @Scheduled(cron="0/3 * * * * *") // 每隔3秒执行一次
    public void task1() {
        log.info("task1 执行");
    }
}
```

## 12.3 测试

控制台定时输出日志

## 12.4 在线生成cron表达式

http://cron.qqe2.com/



## 12.5 自动生成统计信息

```java
@Autowired
private DailyService dailyService;
/**
     * 每天凌晨1点执行定时任务
     */
@Scheduled(cron = "0 0 1 * * ?") //注意只支持6位表达式
public void taskGenarateStatisticsData() {
    //获取上一天的日期
    String day = new DateTime().minusDays(1).toString("yyyy-MM-dd");
    dailyService.createStatisticsByDay(day);
    log.info("taskGenarateStatisticsData 统计完毕");
}
```



测试sql

```sql
select id,date_calculated,video_view_num,gmt_create from statistics_daily  where date_calculated='2021-11-17';
```

成功了哈哈

```sql
mysql> select id,date_calculated,video_view_num,gmt_create from statistics_daily  where date_calculated='2021-11-17';
+---------------------+-----------------+----------------+---------------------+
| id                  | date_calculated | video_view_num | gmt_create          |
+---------------------+-----------------+----------------+---------------------+
| 1461213357715955714 | 2021-11-17      |            191 | 2021-11-18 14:03:07 |
+---------------------+-----------------+----------------+---------------------+

```

