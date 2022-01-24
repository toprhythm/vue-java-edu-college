# part24-首页展示和redis

# 1 幻灯片数据展示

service_cms模块

## 1.1 后端 web层

ApiAdController

```java
package com.atguigu.guli.service.cms.controller.api;

@CrossOrigin //解决跨域问题
@Api(description = "广告推荐")
@RestController
@RequestMapping("/api/cms/ad")
public class ApiAdController {
    @Autowired
    private AdService adService;
    @ApiOperation("根据推荐位id显示广告推荐")
    @GetMapping("list/{adTypeId}")
    public R listByAdTypeId(@ApiParam(value = "推荐位id", required = true) @PathVariable String adTypeId) {
        List<Ad> ads = adService.selectByAdTypeId(adTypeId);
        return R.ok().data("items", ads);
    }
}
```

## 1.2 service层

接口：AdService

```java
List<Ad> selectByAdTypeId(String adTypeId);
```

实现：AdServiceImpl

```java
@Override
public List<Ad> selectByAdTypeId(String adTypeId) {
    QueryWrapper<Ad> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByAsc("sort", "id");
    queryWrapper.eq("type_id", adTypeId);
    return baseMapper.selectList(queryWrapper);
}
```

# 2 **前端**

## 2.1 api

创建index.js

```js
import request from '~/utils/request'
export default {
  getTopBannerAdList() {
    return request({
      baseURL: 'http://localhost:8140',
      url: '/api/cms/ad/list/1',
      method: 'get'
    })
  }
}
```

## 2.2 主页banner

pages/index.vue

引入api

```js
import indexApi from '~/api/index'
```

服务端渲染

```js
async asyncData() {
    // 获取首页banner数据
    const topBannerAdListResponse = await indexApi.getTopBannerAdList()
    const topBannerAdList = topBannerAdListResponse.data.items
    return {
        topBannerAdList
    }
},
```

页面模板

```html
<div class="swiper-wrapper">
    <div
         v-for="topBannerAd in topBannerAdList"
         :key="topBannerAd.id"
         :style="'background: ' + topBannerAd.color"
         class="swiper-slide">
        <a target="_blank" href="/">
            <img :src="topBannerAd.imageUrl" :alt="topBannerAd.title">
        </a>
    </div>
</div>
```



# 3 首页课程和讲师

service_edu模块

## 3.1 后端 web层

ApiIndexController

```java
package com.atguigu.guli.service.edu.controller.api;

@CrossOrigin
@Api(description="首页")
@RestController
@RequestMapping("/api/edu/index")
public class ApiIndexController {
    @Autowired
    private CourseService courseService;
    @Autowired
    private TeacherService teacherService;
    @ApiOperation("课程列表")
    @GetMapping
    public R index(){
        //获取首页最热门前8条课程数据
        List<Course> courseList = courseService.selectHotCourse();
        //获取首页推荐前4条讲师数据
        List<Teacher> teacherList = teacherService.selectHotTeacher();
        return R.ok().data("courseList", courseList).data("teacherList", teacherList);
    }
}
```

## 3.2 course service层

接口：CourseService

```java
List<Course> selectHotCourse();
```

实现：CourseServiceImpl

```java
@Override
public List<Course> selectHotCourse() {
  
    QueryWrapper<Course> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByDesc("view_count");
    queryWrapper.last("limit 8");
    return baseMapper.selectList(queryWrapper);
}
```

## 3.3 teacher service层

接口：TeacherService

```java
List<Teacher> selectHotTeacher();
```

实现：TeacherServiceImpl

```java
@Override
public List<Teacher> selectHotTeacher() {
    QueryWrapper<Teacher> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByAsc("sort");
    queryWrapper.last("limit 4");
    return baseMapper.selectList(queryWrapper);
}
```



# 4 前端

## 4.1 api

index.js

```js
getIndexData() {
    return request({
        url: '/api/edu/index',
        method: 'get'
    })
}
```

## 4.2 主页获取数据

pages/index.vue

```js
async asyncData() {
    // 获取首页banner数据
    ......
    //获取名师和热门课程
    const indexDataResponse = await indexApi.getIndexData()
    const courseList = indexDataResponse.data.courseList
    const teacherList = indexDataResponse.data.teacherList
    return {
      topBannerAdList,
      courseList,
      teacherList
    }
},
```

## 4.3 课程页面渲染

```html
<ul id="bna" class="of">
    <li v-for="course in courseList" :key="course.id">
        <div class="cc-l-wrap">
            <section class="course-img">
                <img
                     :src="course.cover"
                     :alt="course.title"
                     class="img-responsive"
                     >
                <div class="cc-mask">
                    <a :href="'/course/'+course.id" title="开始学习" class="comm-btn c-btn-1">开始学习</a>
                </div>
            </section>
            <h3 class="hLh30 txtOf mt10">
                <a :href="'/course/'+course.id" :title="course.title" class="course-title fsize18 c-333">{{ course.title }}</a>
            </h3>
            <span v-if="Number(course.price) === 0" class="fr jgTag bg-green">
                <i class="c-fff fsize12 f-fA">免费</i>
            </span>
            <span v-else class="fr jgTag ">
                <i class="c-orange fsize12 f-fA"> ￥{{ course.price }}</i>
            </span>
            <span class="fl jgAttr c-ccc f-fA">
                <i class="c-999 f-fA">{{ course.viewCount }}人学习</i>
                |
                <i class="c-999 f-fA">{{ course.buyCount }}人购买</i>
            </span>
        </div>
    </li>
</ul>
```

## 4.4 名师页面渲染

```html
<ul class="of">
    <li v-for="teacher in teacherList" :key="teacher.id">
        <section class="i-teach-wrap">
            <div class="i-teach-pic">
                <a :href="'/teacher/'+teacher.id" :title="teacher.name">
                    <img :src="teacher.avatar" :alt="teacher.name" height="142">
                </a>
            </div>
            <div class="mt10 hLh30 txtOf tac">
                <a :href="'/teacher/'+teacher.id" :title="teacher.name" class="fsize18 c-666">{{ teacher.name }}</a>
            </div>
        </section>
    </li>
</ul>
```



# 5 集成redis缓存banner

## 5.1 简介 场景

由于首页数据变化不是很频繁，而且首页访问量相对较大，所以我们有必要把首页数据缓存到redis中，减少数据库压力和提高访问速度。

## 5.2 RedisTemplate

Jedis是Redis官方推荐的面向Java的操作Redis的客户端，而RedisTemplate是Spring Data Redis中对Jedis api的高度封装。

Spring Data Redis是spring大家族的一部分，提供了在srping应用中通过简单的配置访问redis服务，对reids底层开发包(Jedis, JRedis, and RJC)进行了高度封装，RedisTemplate提供了redis各种操作、异常处理及序列化功能，支持发布订阅，并对spring cache进行了实现。

# 6 引入redis

## 6.1 项目中集成redis

common父模块中添加redis依赖，Spring Boot 2.0以上默认通过commons-pool2连接池连接redis

```xml
<!-- spring boot redis缓存引入 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<!-- lecttuce 缓存连接池-->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
```



mac终端启动一个redis服务器:

```shell
redis-server
```

终端打开redisGUI软件: rdm ( Redis Desktop Manager )



##  6.2 添加redis连接配置

service_cms 和 service_edu 的 application.yml 中添加如下配置

```yaml
spring: 
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
```



## 6.3 配置Redis

service-base添加RedisConfig

```java
package com.atguigu.guli.service.base.config;

/**
 * 我们自定义一个 RedisTemplate，设置序列化器，这样我们可以很方便的操作实例对象。
 * 否则redis自动使用对象的jdk序列化
 */
@Configuration
public class RedisConfig {
    @Bean
    public RedisTemplate<String, Serializable> redisTemplate(LettuceConnectionFactory connectionFactory) {
        RedisTemplate<String, Serializable> redisTemplate = new RedisTemplate<>();
        redisTemplate.setKeySerializer(new StringRedisSerializer());//key序列化方式
        redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());//value序列化
        redisTemplate.setConnectionFactory(connectionFactory);
        return redisTemplate;
    }
}
```



# 7 测试redisTemplate

## 7.1 测试redis数据存储

ApiAdController中添加下面的方法进行测试

```java

@Autowired
private RedisTemplate redisTemplate;

@PostMapping("save-test")
public R saveAd(@RequestBody Ad ad){
    //redisTemplate.opsForValue().set("ad1", ad);
    redisTemplate.opsForValue().set("index::ad", ad);
    return R.ok();
}
@GetMapping("get-test/{key}")
public R getAd(@PathVariable String key){
    Ad ad = (Ad)redisTemplate.opsForValue().get(key);
    return R.ok().data("ad", ad);
}
@DeleteMapping("remove-test/{key}")
public R removeAd(@PathVariable String key){
    Boolean delete = redisTemplate.delete(key);
    System.out.println(delete);//是否删除成功
    Boolean hasKey = redisTemplate.hasKey(key);
    System.out.println(hasKey);//key是否存在
    return R.ok();
}
```

## 7.2 常用方法

redisTemplate提供了以下几种存储数据的方法

```java
redisTemplate.opsForValue(); //操作字符串
redisTemplate.opsForHash(); //操作hash
redisTemplate.opsForList(); //操作list
redisTemplate.opsForSet(); //操作set
redisTemplate.opsForZSet(); //操作有序set
```

# 8 使用缓存注解

## 8.1 修改Redis配置类

配置类上添加注解

```java
@EnableCaching
```

添加bean配置

```java
@Bean
public CacheManager cacheManager(LettuceConnectionFactory connectionFactory) {
    RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
        //过期时间600秒
        .entryTtl(Duration.ofSeconds(600)) 
        // 配置序列化
        .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
        .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()))
        .disableCachingNullValues();
    RedisCacheManager cacheManager = RedisCacheManager.builder(connectionFactory)
        .cacheDefaults(config)
        .build();
    return cacheManager;
}
```

## 8.2 添加缓存注解

@Cacheable(value = "xxx", key = "'xxx'")：标注在方法上，对方法返回结果进行缓存。下次请求时，如果缓存存在，则直接读取缓存数据返回；如果缓存不存在，则执行方法，并把返回的结果存入缓存中。一般用在查询方法上。

service_cms：AdServiceImpl

```java
@Cacheable(value = "index", key = "'selectByAdTypeId'")
@Override
public List<Ad> selectByAdTypeId(String adTypeId) {
```

service_edu：CourseServiceImpl

```java
@Cacheable(value = "index", key = "'selectHotCourse'")
@Override
public List<Course> selectHotCourse() {
```

service_edu：TeacherServiceImpl

```java
@Cacheable(value = "index", key = "'selectHotTeacher'")
@Override
public List<Teacher> selectHotTeacher() {
```



