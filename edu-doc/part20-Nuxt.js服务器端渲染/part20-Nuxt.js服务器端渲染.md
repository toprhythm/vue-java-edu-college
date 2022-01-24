# part20-Nuxt.js服务器端渲染

# 1 搜索引擎优化

## 1.1 什么是SEO

**总结：**seo是网站为了提高自已的网站排名，获得更多的流量，对网站的结构及内容进行调整和优化，以便搜索引擎 （百度，google等）更好抓取到优质网站的内容。


常见的SEO方法比如：

- 对url链接的规范化，多用restful风格的url，多用静态资源url；
- 注意keywords、description、title的设置；
- h1-h6、a标签的使用
- 等等

注意：spider对javascript支持不好，ajax获取的JSON数据无法被spider爬取

采用什么技术有利于SEO？要解答这个问题需要理解服务端渲染和客户端渲染。





## 1.2 Nuxt.js服务器端渲染

服务端渲染又称SSR (Server Side Render)是在服务端完成页面的内容渲染，而不是在客户端完成页面内容的渲染。

服务端渲染的特点：

- 在服务端生成html网页的dom元素
- 客户端（浏览器）只负责显示dom元素内容

客户端渲染的特点：

- 在服务端只是给客户端响应的了数据，而不是html网页

- 客户端（浏览器）负责获取服务端的数据生成dom元素

- ## 两种方式各有什么优缺点？ 

**客户端渲染：** 

1) 缺点：不利于网站进行SEO，因为网站大量使用javascript技术，不利于搜索引擎抓取网页。 

2) 优点：客户端负责渲染，用户体验性好，服务端只提供数据不用关心用户界面的内容，有利于提高服务端的开发效率。 

3）适用场景：对SEO没有要求的系统，比如后台管理类的系统，如电商后台管理，用户管理等。

 **服务端渲染：** 

1) 优点：有利于SEO，网站通过href的url将搜索引擎直接引到服务端，服务端提供优质的网页内容给搜索引擎。

2) 缺点：服务端完成一部分客户端的工作，通常完成一个需求需要修改客户端和服务端的代码，开发效率低，不利于系统的稳定性。

3适用场景：对SEO有要求的系统，比如：门户首页、商品详情页面等。



SSR并不是前端特有的技术，我们学习过的JSP技术和Thymeleaf技术就是典型的SSR

下图展示了从客户端请求到Nuxt.js进行服务端渲染的整体的工作流程：

1）用户打开浏览器，输入网址请求到Node.js中的前端View组件

2）部署在Node.js的应用Nuxt.js接收浏览器请求，并请求服务端获取数据 

3）Nuxt.js获取到数据后进行服务端渲染 

4）Nuxt.js将html网页响应给浏览器

# 2 Nuxt.js环境初始化

## 2.1 解压

解压 guli_site

## 2.2 端口修改

项目默认3000端口启动，如果想要修改Nuxt.js的启动端口，则可以在package.json文件中添加如下配置

```js
"config": {
  "nuxt": {
    "host": "127.0.0.1",
    "port": "3333"
  }
}
```

## 2.3 安装依赖 

```shell
npm install
```

## 2.4 运行项目

```shell
npm run dev
```

# 3 页面布局结构

## 3.1 布局组件

页头和页尾提取出来，形成布局页

![image-20211110073310100](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211110073310100.png)

## 3.2 布局文件

layouts目录下default.vue，引用布局组件

<nuxt />：主内容占位符
![image-20211110073337013](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211110073337013.png)

## 3.3 首页面

pages/index.vue，默认使用layouts目录下default.vue布局文件

index.vue中的页面内容会被自动嵌入到模板文件的 <nuxt/> 的位置

# 4 自动路由

## 4.1 基础路由

Nuxt.js 依据 pages 目录结构自动生成 vue-router 模块的路由配置。 

下边是一个基础路由的例子： 假设 pages 的目录结构如下：

```shell
pages/ 
‐‐|index.vue
‐‐|teacher/ 
‐‐‐‐‐| index.vue 
```

那么，Nuxt.js 自动生成的路由配置如下：

```shell
router:{ 
    routes: [ 
        { 
            name: 'index', 
            path: '/',
            component: 'pages/index.vue' 
        },
        { 
            name: 'teacher', 
            path: '/teacher',
            component: 'pages/teacher/index.vue' 
        }
    ] 
}
```

## 4.2 动态路由

动态路由的页面需要加下划线前缀，例如： _id.vue

```shell
pages/ 
‐‐|teacher/ 
-----| _id.vue
```

_id.vue页面实现了向页面传入id参数，Nuxt.js 自动生成的路由配置如下：

```shell
router:{ 
    routes: [ 
        { 
            name: 'teacher‐id', 
            path: '/teacher/:id', 
            component: 'pages/teacher/_id.vue'
        } 
    ] 
}
```



# 5 获取讲师列表数据

## 5.1 **后端接口** web层

创建ApiTeacherController

```java
package com.atguigu.guli.service.edu.controller.api;

@CrossOrigin
@Api(description="讲师")
@RestController
@RequestMapping("/api/edu/teacher")
public class ApiTeacherController {
  
    @Autowired
    private TeacherService teacherService;
  
    @ApiOperation(value="所有讲师列表")
    @GetMapping("list")
    public R listAll(){
        List<Teacher> list = teacherService.list(null);
        return R.ok().data("items", list).message("获取讲师列表成功");
    }
}
```



# 6 获取数据

## 6.1 前端api

创建api/teacher.js

```js
import request from '~/utils/request'

export default{
  getList() {
    return request({
      url: '/api/edu/teacher/list',
      method: 'get'
    })
  }
}
```

## 6.2 列表视图组件

创建pages/teacher/test.vue

```html
<template>
  <div>
    讲师列表
    <div v-for="(item,index) in items" :key="index">
      <a :href="'teacher/'+item.id">{{ item.name }}</a>
    </div>
  </div>
</template>
<script>
import teacherApi from '~/api/teacher'
export default {
  // 异步获取数据
  asyncData() {
    return teacherApi.getList().then(response => {
      return {
        items: response.data.items
      }
    })
  },
  data() {
    return {
      test: 'test' // 这里的数据最后会和asyncData中的数据定义合并
    }
  }
}
</script>
```

**asyncData 方法**Nuxt.js 扩展了 Vue.js，增加了一个叫 asyncData 的方法， asyncData 方法会在组件（限于页面组件）每次加载 之前被调用。它可以在服务端或路由更新之前被调用。 你可以利用 asyncData 方法来获取数据，Nuxt.js 会将 asyncData 返回的数据融合组件 data 方法 返回的数据一并返回给当前组件。 

注意：由于 asyncData 方法是在组件 初始化前被调用的，所以在方法内是没有办法通过 this 来引用组件的实例对象。

查看开发者工具的“Vue”选项卡

![image-20211110075148750](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211110075148750.png)

# 7 异步数据和同步数据

## 7.1 异步调用

teacherApi.getList()后面的代码和这行代码异步执行的

```js
asyncData() {
    console.log('asyncData')
    const response = teacherApi.getList()
    console.log(response)
    return {
        items: response.data.items // 报错：response未定义
    }
},
```

## 7.2 同步调用

使用 async 和 await 关键字

teacherApi.getList()后面的代码和这行代码同步执行

```js
async asyncData() {
    console.log('asyncData')
    const response = await teacherApi.getList()
    console.log(response)
    return {
        items: response.data.items
    }
},

```

# 8 渲染讲师列表

teacher/index.vue

## 8.1 无数据提示

添加：v-if="total===0"

```html
<!-- /无数据提示 开始-->
<section v-if="items.length===0" class="no-data-wrap">
    <em class="icon30 no-data-ico">&nbsp;</em>
    <span class="c-666 fsize14 ml10 vam">没有相关数据，小编正在努力整理中...</span>
</section>
<!-- /无数据提示 结束-->
```

## 8.2 数据列表

```html
<!-- /数据列表 开始-->
<article v-if="items.length>0" class="i-teacher-list">
    <ul class="of">
        <li v-for="item in items" :key="item.id">
            <section class="i-teach-wrap">
                <div class="i-teach-pic">
                    <a :href="'/teacher/'+item.id" :title="item.name">
                        <img :src="item.avatar" :alt="item.name" height="142">
                    </a>
                </div>
                <div class="mt10 hLh30 txtOf tac">
                    <a :href="'/teacher/'+item.id" :title="item.name" class="fsize18 c-666">{{ item.name }}</a>
                </div>
                <div class="hLh30 txtOf tac">
                    <span class="fsize14 c-999" >{{ item.intro }}</span>
                </div>
                <div class="mt15 i-q-txt">
                    <p class="c-999 f-fA">{{ item.career }}</p>
                </div>
            </section>
        </li>
    </ul>
    <div class="clear"/>
</article>
<!-- /数据列表 结束-->
```



# 10 讲师详情

## 10.1 后端 s**ervice层**

接口：TeacherService

```java
/**
     * 根据讲师id获取讲师详情页数据
     * @param id
     * @return
     */
Map<String, Object> selectTeacherInfoById(String id);
```

实现：TeacherServiceImpl

```java
@Autowired
private CourseMapper courseMapper;
/**
     * 根据讲师id获取讲师详情页数据
     * @param id
     * @return
     */
@Override
public Map<String, Object> selectTeacherInfoById(String id) {
    //获取讲师信息
    Teacher teacher = baseMapper.selectById(id);
    //根据讲师id获取讲师课程
    List<Course> courseList =  courseMapper.selectList(new QueryWrapper<Course>().eq("teacher_id", id));
    Map<String, Object> map = new HashMap<>();
    map.put("teacher", teacher);
    map.put("courseList", courseList);
    return map;
}
```

## 10.2 web层

ApiTeacherController

```java

@ApiOperation(value = "获取讲师")
@GetMapping("get/{id}")
public R get(
    @ApiParam(value = "讲师ID", required = true)
    @PathVariable String id) {
    Map<String, Object> map = teacherService.selectTeacherInfoById(id);
    return R.ok().data(map);
}
```

# 11 前端

## 11.1 api

api/teacher.js

```javascript
getById(id) {
    return request({
        url: `/api/edu/teacher/get/${id}`,
        method: 'get'
    })
}
```

## 11.2 页面脚本

pages/teacher/_id.vue

```js

<script>
import teacherApi from '~/api/teacher'
export default {
  // 在这个方法被调用的时候，第一个参数被设定为当前页面的 上下文对象，
  async asyncData(page) {
    console.log(page.route)
    const response = await teacherApi.getById(page.route.params.id)
    return {
      teacher: response.data.teacher,
      courseList: response.data.courseList
    }
  }
}
</script>
```

## 11.3 讲师详情显示

```html
<!-- 讲师基本信息 开始 -->
<section class="fl t-infor-box c-desc-content">
    <div class="mt20 ml20">
        <section class="t-infor-pic">
            <img :src="teacher.avatar" :alt="teacher.name">
        </section>
        <h3 class="hLh30">
            <span class="fsize24 c-333">{{ teacher.name }}
                &nbsp;
                {{ teacher.level===1?'高级讲师':'首席讲师' }}
            </span>
        </h3>
        <section class="mt10">
            <span class="t-tag-bg">{{ teacher.intro }}</span>
        </section>
        <section class="t-infor-txt">
            <p class="mt20">{{ teacher.career }}</p>
        </section>
        <div class="clear"/>
    </div>
</section>
<!-- /讲师基本信息 结束 -->
```

## 11.4 无数据提示

```html
<!-- 无数据提示 开始-->
<section v-if="courseList.length===0" class="no-data-wrap">
    <em class="icon30 no-data-ico">&nbsp;</em>
    <span class="c-666 fsize14 ml10 vam">没有相关数据，小编正在努力整理中...</span>
</section>
<!-- /无数据提示 结束-->
```

## 11.5 讲师课程列表

```html
<!-- 课程列表 开始-->
<article class="comm-course-list">
  <ul class="of">
    <li v-for="course in courseList" :key="course.id">
      <div class="cc-l-wrap">
        <section class="course-img">
          <img :src="course.cover" class="img-responsive">
          <div class="cc-mask">
            <a :href="'/course/'+course.id" title="开始学习" target="_blank" class="comm-btn c-btn-1">开始学习</a>
          </div>
        </section>
        <h3 class="hLh30 txtOf mt10">
          <a
            :href="'/course/'+course.id"
            :title="course.title"
            class="course-title fsize18 c-333">{{ course.title }}</a>
        </h3>
      </div>
    </li>
  </ul>
  <div class="clear"/>
</article>
<!-- /课程列表 结束-->
```

