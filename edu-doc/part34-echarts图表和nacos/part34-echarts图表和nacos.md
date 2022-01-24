# part34-echarts图表和nacos

# 1 echarts的使用

## 1.1 五分钟入门ECharts 简介

ECahrs是百度的一个项目，用于图表展示，提供了常规的[折线图](https://echarts.baidu.com/option.html#series-line)、[柱状图](https://echarts.baidu.com/option.html#series-line)、[散点图](https://echarts.baidu.com/option.html#series-scatter)、[饼图](https://echarts.baidu.com/option.html#series-pie)、[K线图](https://echarts.baidu.com/option.html#series-candlestick)，用于统计的[盒形图](https://echarts.baidu.com/option.html#series-boxplot)，用于地理数据可视化的[地图](https://echarts.baidu.com/option.html#series-map)、[热力图](https://echarts.baidu.com/option.html#series-heatmap)、[线图](https://echarts.baidu.com/option.html#series-lines)，用于关系数据可视化的[关系图](https://echarts.baidu.com/option.html#series-graph)、[treemap](https://echarts.baidu.com/option.html#series-treemap)、[旭日图](https://echarts.baidu.com/option.html#series-sunburst)，多维数据可视化的[平行坐标](https://echarts.baidu.com/option.html#series-parallel)，还有用于 BI 的[漏斗图](https://echarts.baidu.com/option.html#series-funnel)，[仪表盘](https://echarts.baidu.com/option.html#series-gauge)，并且支持图与图之间的混搭。



## 1.2 基本使用

入门参考：官网->文档->教程->5分钟上手ECharts

（1）创建html页面：柱图.html

（2）引入ECharts

```js
<!-- 引入 ECharts 文件 -->
<script src="echarts.min.js"></script>
```

（3）定义图表区域

```html
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 600px;height:400px;"></div> 
```

（4）渲染图表

```html
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
    // 指定图表的配置项和数据
    var option = {
        title: {
            text: 'ECharts 入门示例'
        },
        tooltip: {},
        legend: {
            data:['销量']
        },
        xAxis: {
            data: ["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"]
        },
        yAxis: {},
        series: [{
            name: '销量',
            type: 'bar',
            data: [5, 20, 36, 10, 10, 20]
        }]
    };
    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
</script>
```

## 1.3 折线图

实例参考：官网->实例->官方实例 https://echarts.baidu.com/examples/

折线图.html

```html
<script>
    var myChart = echarts.init(document.getElementById('main'));
    var option = {
        //x轴是类目轴（离散数据）,必须通过data设置类目数据
        xAxis: {
            type: 'category',
            data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        //y轴是数据轴（连续数据）
        yAxis: {},
        //系列列表。每个系列通过 type 决定自己的图表类型
        series: [{
            //系列中的数据内容数组
            data: [820, 932, 901, 934, 1290, 1330, 1320],
            //折线图
            type: 'line'
        }]
    };
    myChart.setOption(option);
</script>
```

# 2 前端显示统计图表

## 2.1 安装echarts

```js
npm install echarts@4.5.0
```

## 2.2 html

src/views/statistics/chart.vue

```html
<template>
  <div class="app-container">
    <!--表单-->
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item>
        <el-date-picker
          v-model="searchObj.begin"
          type="date"
          placeholder="选择开始日期"
          value-format="yyyy-MM-dd" />
      </el-form-item>
      <el-form-item>
        <el-date-picker
          v-model="searchObj.end"
          type="date"
          placeholder="选择截止日期"
          value-format="yyyy-MM-dd" />
      </el-form-item>
      <el-button
        :disabled="btnDisabled"
        type="primary"
        icon="el-icon-search"
        @click="showChart()">查询</el-button>
    </el-form>
    <el-row>
      <el-col :span="12">
        <div id="register_num" class="chart" style="height:500px;" />
      </el-col>
      <el-col :span="12">
        <div id="login_num" class="chart" style="height:500px;" />
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="12">
        <div id="video_view_num" class="chart" style="height:500px;" />
      </el-col>
      <el-col :span="12">
        <div id="course_num" class="chart" style="height:500px;" />
      </el-col>
    </el-row>
  </div>
</template>
```

## 2.3 **script**

```js
<script>
import echarts from 'echarts'
// import statisticsApi from '@/api/statistics'
export default {
  data() {
    return {
      searchObj: {
        begin: '',
        end: ''
      },
      btnDisabled: false,
      chartData: {}
    }
  },
  methods: {
    showChart() {
      this.showChartByType('register_num', '学员登录数统计', this.chartData.registerNum)
      this.showChartByType('login_num', '学员注册数统计', this.chartData.loginNum)
      this.showChartByType('video_view_num', '课程播放数统计', this.chartData.videoViewNum)
      this.showChartByType('course_num', '每日课程数统计', this.chartData.courseNum)
    },
    showChartByType(type, title, data) {
      // 基于准备好的dom，初始化echarts实例
      var myChart = echarts.init(document.getElementById(type))
      // 指定图表的配置项和数据
      var option = {
        title: {
          text: title
        },
        xAxis: {
          data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
        },
        yAxis: {},
        series: [{
          type: 'line',
          data: [5, 20, 36, 10, 10, 20]
        }]
      }
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option)
    }
  }
}
</script>
```



# 3 后端聚合数据

## 3.1 web层

DailyController

```java
@ApiOperation("显示统计数据")
@GetMapping("show-chart/{begin}/{end}")
public R showChart(
    @ApiParam("开始时间") @PathVariable String begin,
    @ApiParam("结束时间") @PathVariable String end){
    Map<String, Map<String, Object>> map = dailyService.getChartData(begin, end);
    return R.ok().data("chartData", map);
}
```

## 3.2 service层

接口：DailyService

```java
Map<String, Map<String, Object>> getChartData(String begin, String end);
```

实现：DailyServiceImpl

```java
/**
     * 获取所有类比的数据
     */
@Override
public Map<String, Map<String, Object>> getChartData(String begin, String end) {
    Map<String, Map<String, Object>> map = new HashMap<>();
    Map<String, Object> registerNum = this.getChartDataByType(begin, end, "register_num");
    Map<String, Object> loginNum = this.getChartDataByType(begin, end, "login_num");
    Map<String, Object> videoViewNum = this.getChartDataByType(begin, end, "video_view_num");
    Map<String, Object> courseNum = this.getChartDataByType(begin, end, "course_num");
    map.put("registerNum", registerNum);
    map.put("loginNum", loginNum);
    map.put("videoViewNum", videoViewNum);
    map.put("courseNum", courseNum);
    return map;
}
/**
     * 辅助方法：根据类别获取数据
     */
private Map<String, Object> getChartDataByType(String begin, String end, String type) {
    HashMap<String, Object> map = new HashMap<>();
    ArrayList<String> xList = new ArrayList<>();//日期列表
    ArrayList<Integer> yList = new ArrayList<>();//数据列表
    QueryWrapper<Daily> queryWrapper = new QueryWrapper<>();
    queryWrapper.select(type, "date_calculated");
    queryWrapper.between("date_calculated", begin, end);
    List<Map<String, Object>> mapsData = baseMapper.selectMaps(queryWrapper);
    for (Map<String, Object> data : mapsData) {
        String dateCalculated = (String)data.get("date_calculated");
        xList.add(dateCalculated);
        Integer count = (Integer) data.get(type);
        yList.add(count);
    }
    map.put("xData", xList);
    map.put("yData", yList);
    return map;
}
```

# 4 前端显示图表

## 4.1 api

src/api/statistics.js中添加方法

```js
showChart(searchObj) {
    return request({
        // baseURL: 'http://127.0.0.1:8180',
        url: `/admin/statistics/daily/show-chart/${searchObj.begin}/${searchObj.end}`,
        method: 'get'
    })
}
```

## 4.2 方法

引入api

```js
import statisticsApi from '@/api/statistics'
```

方法

```js
methods: {
    showChart() {
      statisticsApi.showChart(this.searchObj).then(response => {
        this.chartData = response.data.chartData
        this.showChartByType('register_num', '学员登录数统计', this.chartData.registerNum)
        this.showChartByType('login_num', '学员注册数统计', this.chartData.loginNum)
        this.showChartByType('video_view_num', '课程播放数统计', this.chartData.videoViewNum)
        this.showChartByType('course_num', '每日课程数统计', this.chartData.courseNum)
      })
    },
    showChartByType(type, title, data) {
      // 基于准备好的dom，初始化echarts实例
      var myChart = echarts.init(document.getElementById(type))
      // 指定图表的配置项和数据
      var option = {
        title: {
          text: title
        },
        xAxis: {
          data: data.xData
        },
        yAxis: {},
        series: [{
          data: data.yData,
          type: 'line'
        }]
      }
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option)
    }
}
```



# 5 nacos介绍

## 5.1 配置中心介绍

## 问题

**微服务架构下关于配置文件的问题：**

- 配置文件相对分散

在一个微服务架构下，配置文件会随着微服务的增多变的越来越多，而且分散在各个微服务中，不好统一配置和管理。

- 配置文件无法区分环境

微服务项目可能会有多个环境，例如：测试环境、预发布环境、生产环境。每一个环境所使用的配置理论上都是不同的，一旦需要修改，就需要我们去各个微服务下手动

维护，这比较困难。

- 配置文件无法实时更新

我们修改了配置文件之后，必须重新启动微服务才能使配置生效，这对一个正在运行的项目来说非常不友好。

**配置中心的思路是：**

- 首先把项目中各种配置全部都放到一个集中的地方进行统一管理，并提供一套标准的接口。
- 服务需要获取配置的时候，就来配置中心的接口拉取自己的配置。
- 配置中心参数有更新时，能够通知到微服务实时同步最新的配置信息，使之动态更新。

# 6 常见配置中心

## 6.1 Apollo

Apollo是由携程开源的分布式配置中心。特点有很多，比如：配置更新之后可以实时生效，支持灰度发布功能，并且能对所有的配置进行版本管理、操作审计等功能，提供开放平台API。并且资料 也写的很详细。

## 6.2 Disconf

Disconf是由百度开源的分布式配置中心。基于Zookeeper实现配置变更后实时通知和生效。

## 6.3 SpringCloud Conﬁg

Spring Cloud的配置中心组件。和Spring无缝集成，使用起来非常方便，配置存储支持Git。不过它没有可视化的操作界面，配置的生效也不是实时的，需要重启或去刷新。要结合SpringCloud Bus和消息队列才能完成配置实时刷新的功能。

## 6.4 Nacos

SpingCloud alibaba技术栈中的一个组件，前面我们已经使用它做过服务注册中心。其实它也集成了服务配置的功能，我们可以直接使用它作为服务配置中心。



# 7 **创建测试Controller**

## 7.1 创建测试控制器

在service-sms微服务中创建SampleController

使用@Value读取配置信息

```java
package com.atguigu.guli.service.sms.controller;
@RestController
@RequestMapping("/sms/sample")
public class SampleController {
    @Value("${aliyun.sms.signName}")
    private String signName;
    @GetMapping("test1")
    public R test1(){
        return R.ok().data("signName", signName);
    }
}
```

测试：http://localhost:8150/sms/sample/test1

## 7.2 测试2

使用@ConfigurationProperties读取配置信息

```java
@Autowired
private SmsProperties smsProperties;
@GetMapping("test2")
public R test2(){
    return R.ok().data("smsProperties", smsProperties);
}
```

测试：http://localhost:8150/sms/sample/test2

# 8 接入配置中心

参考文档：https://github.com/alibaba/spring-cloud-alibaba/blob/master/spring-cloud-alibaba-examples/nacos-example/nacos-config-example/readme-zh.md

## 8.1 service中添加依赖

```xml
<!--配置中心-->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>
```

## 8.2 创建bootstrap.yml配置文件

bootstrap作为引导文件会优先于application文件的加载

```yaml
spring:
  application:
    name: service-sms
  cloud:
    nacos:
      config:
        server-addr: 127.0.0.1:8848 #nacos中心地址
        file-extension: yaml # 配置文件格式，如果是properties文件则不用配置此项
```

- bootstrap文件先于application加载
- properties的配置覆盖yml的配置
- application的配置覆盖bootstrap的配置



## 8.3 在nacos中添加配置

![image-20211119095652946](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119095652946.png)

## 8.4 填写配置信息

- **Data ID：** service-sms.yaml

- - 服务名.文件格式

- **配置内容：**删除或注释本地的bootstrap.yml中的内容

```yaml
server:
 port: 8150 # 服务端口
spring:
#  profiles:
#    active: dev # 环境设置
#  application:
#    name: service-sms # 服务名
 cloud:
   nacos:
     discovery:
       server-addr: localhost:8848 # nacos服务地址
#spring:
 redis:
   host: 192.168.100.100
   port: 6379
   database: 0
   password: 123456 #默认为空
   lettuce:
     pool:
       max-active: 20  #最大连接数，负值表示没有限制，默认8
       max-wait: -1    #最大阻塞等待时间，负值表示没限制，默认-1
       max-idle: 8     #最大空闲连接，默认8
       min-idle: 0     #最小空闲连接，默认0
#阿里云短信
aliyun:
 sms:
   regionId: cn-hangzhou
   keyId: 你的id
   keySecret: 你的secret
   templateCode: 你的code
   signName: 谷粒
```

## 8.5 测试

重新启动service-sms测试从配置中心读取配置信息

## 8.6 配置中心优先

如果配置中心和当前应用的配置文件中都配置了相同的项目，优先使用配置中心中的配置



# 9 配置动态刷新

如果修改了配置中心的配置，我们的程序无法读取到实时的配置信息，需要重新启动服务器，因此可以配置动态刷新。

## 9.1 添加注解

在controller类上配置下面的注解，并重启服务器

```java
@RefreshScope
```

## 9.2 修改配置

```java
修改nacos注册中心的配置信息，无需重新启动服务器，配置即可生效
```



# 10 多环境配置

## 10.1 添加active属性

在bootstrap.yml中添加如下配置

```yaml
#spring:  
  profiles:
    active: dev # 环境标识，test、prod等
```

## 10.2 添加配置配置文件

配置中心添加 service-sms-dev.yaml 配置文件，文件最后一部分的名字和环境标识保持一致

```yaml
#阿里云短信
aliyun:
 sms:
   signName: 谷粒dev
```

# 11 使用命名空间做环境隔离

## 11.1 创建命名空间

![image-20211119095929702](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119095929702.png)

## 11.2 克隆配置文件

在public命名空间中克隆文件到新的命名空间

![image-20211119095946317](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119095946317.png)

## 11.3 配置命名空间

默认情况下微服务读取配置中心中 public 命名空间中的配置文件，可以指定命名空间id使用特定命名空间中的配置

![image-20211119100002159](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100002159.png)

![image-20211119100010648](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100010648.png)

# 12 使用命名空间做微服务隔离

## 12.1 创建命名空间

![image-20211119100029482](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100029482.png)

## 12.2 克隆配置文件

在public命名空间中克隆文件到sms命名空间

## 12.3 配置命名空间

将sms命名空间id配置给sms微服务的boorstrap.yml文件

## 12.4 命名空间和环境配置

也可以命名空间和多环境配置联合使用

![image-20211119100059601](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100059601.png)

![image-20211119100107328](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100107328.png)

# 13 使用分组

## 13.1 创建分组

![image-20211119100124803](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100124803.png)

![image-20211119100132938](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100132938.png)

## 13.2 配置分组名称

![image-20211119100146279](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100146279.png)

# 14 几个概念

## 14.1 命名空间

Namespace：命名空间可用于进行不同环境的配置隔离。可以按环境隔离，也可以按微服务隔离。

## 14.2 配置集

Data：所有配置的集合，在系统中，一个配置文件通常就是一个配置集。

## 14.3 配置集ID

Data ID：nacos中的配置文件名称，规范：微服务名称-环境名称.扩展名

## 14.4 配置分组

默认所有的配置集都属于DEFAULT_GROUP分组，不同的分组中可以有相同的配置文件名称。



# 15 多配制文件加载

## 15.1 创建aliyun.yaml

将aliyun的相关配置从service-sms中删除，移到aliyun.yaml文件中

![image-20211119100240488](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100240488.png)

## 15.2 配置bootstrap.yml

![image-20211119100259904](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100259904.png)

## 15.3 创建redis.yaml

## 15.4 配置bootstrap.yml

![image-20211119100319627](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100319627.png)

## 15.5 测试

controller中添加如下测试，测试数据是否写入了redis

```java
@Autowired
private RedisTemplate redisTemplate;
@GetMapping("test3")
public R test3(){
    redisTemplate.opsForValue().set("test", "123", 5, TimeUnit.MINUTES);
    return R.ok();
}
```

## 15.6 查看文件的加载

微服务启动时查看控制台输出

![image-20211119100400665](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211119100400665.png)

