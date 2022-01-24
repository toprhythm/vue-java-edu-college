# part21-课程展示

# 1 课程展示

## 1.1 后端 **定义vo**

WebCourseQueryVo

```java
package com.atguigu.guli.service.edu.entity.vo;

@Data
public class WebCourseQueryVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String subjectParentId;
    private String subjectId;
    private String buyCountSort;
    private String gmtCreateSort;
    private String priceSort;
}
```

## 1.2 查询接口

 创建ApiCourseController.java 

```java
package com.atguigu.guli.service.edu.controller.api;

@CrossOrigin
@Api(description="课程")
@RestController
@RequestMapping("/api/edu/course")
public class ApiCourseController {
    @Autowired
    private CourseService courseService;
    @ApiOperation("课程列表")
    @GetMapping("list")
    public R list(
            @ApiParam(value = "查询对象", required = false)
                    WebCourseQueryVo webCourseQueryVo){
        List<Course> courseList = courseService.webSelectList(webCourseQueryVo);
        return  R.ok().data("courseList", courseList);
    }
}
```

## 1.3 查询业务

接口：CourseService

```java
List<Course> webSelectList(WebCourseQueryVo webCourseQueryVo);
```

实现：CourseServiceImpl

```java
@Override
public List<Course> webSelectList(WebCourseQueryVo webCourseQueryVo) {
    QueryWrapper<Course> queryWrapper = new QueryWrapper<>();
    //查询已发布的课程
    queryWrapper.eq("status", Course.COURSE_NORMAL);
    if (!StringUtils.isEmpty(webCourseQueryVo.getSubjectParentId())) {
        queryWrapper.eq("subject_parent_id", webCourseQueryVo.getSubjectParentId());
    }
    if (!StringUtils.isEmpty(webCourseQueryVo.getSubjectId())) {
        queryWrapper.eq("subject_id", webCourseQueryVo.getSubjectId());
    }
    if (!StringUtils.isEmpty(webCourseQueryVo.getBuyCountSort())) {
        queryWrapper.orderByDesc("buy_count");
    }
    if (!StringUtils.isEmpty(webCourseQueryVo.getGmtCreateSort())) {
        queryWrapper.orderByDesc("gmt_create");
    }
    if (!StringUtils.isEmpty(webCourseQueryVo.getPriceSort())) {
        queryWrapper.orderByDesc("price");
    }
    return baseMapper.selectList(queryWrapper);
}
```

# 2 前端脚本

## 2.1 定义api

api下创建course.js

```js
import request from '~/utils/request'
export default {
  getList(searchObj) {
    return request({
      url: '/api/edu/course/list',
      method: 'get',
      params: searchObj
    })
  }
}

```

## 2.2 组件脚本

pages/course/index.vue

```java
<script>
import courseApi from '~/api/course'
export default {
  async asyncData() {
    // 组装查询参数
    const searchObj = {}
    // 课程列表
    const courseListResponse = await courseApi.getList(searchObj)
    const courseList = courseListResponse.data.courseList
    return {
      courseList // 课程列表
    }
  }
}
</script>
```

# 3 列表渲染

## 3.1 无数据提示

添加：v-if="total==0"

```html

<!-- /无数据提示 开始-->
<section v-if="courseList.length===0" class="no-data-wrap">
    <em class="icon30 no-data-ico">&nbsp;</em>
    <span class="c-666 fsize14 ml10 vam">没有相关数据，小编正在努力整理中...</span>
</section>
<!-- /无数据提示 结束-->
```

## 3.2 列表

```html
<!-- 数据列表 开始-->
<article v-if="courseList.length>0" class="comm-course-list">
    <ul id="bna" class="of">
        <li v-for="item in courseList" :key="item.id">
            <div class="cc-l-wrap">
                <section class="course-img">
                    <img :src="item.cover" :alt="item.title" class="img-responsive">
                    <div class="cc-mask">
                        <a :href="'/course/'+item.id" title="开始学习" class="comm-btn c-btn-1">开始学习</a>
                    </div>
                </section>
                <h3 class="hLh30 txtOf mt10">
                    <a :href="'/course/'+item.id" :title="item.title" class="course-title fsize18 c-333">{{ item.title }}</a>
                </h3>
                <section class="mt10 hLh20 of">
                    <span v-if="Number(item.price) === 0" class="fr jgTag bg-green">
                        <i class="c-fff fsize12 f-fA">免费</i>
                    </span>
                    <span v-else class="fr jgTag ">
                        <i class="c-orange fsize12 f-fA"> ￥{{ item.price }}</i>
                    </span>
                    <span class="fl jgAttr c-ccc f-fA">
                        <i class="c-999 f-fA">{{ item.viewCount }}人学习</i>
                        |
                        <i class="c-999 f-fA">{{ item.buyCount }}人购买</i>
                    </span>
                </section>
            </div>
        </li>
    </ul>
    <div class="clear"/>
</article>
<!-- /数据列表 结束-->
```

# 4 课程分类和排序

## 4.1 后端 课程分类嵌套列表接口

ApiSubjectController

```java
package com.atguigu.guli.service.edu.controller.api;

@CrossOrigin
@Api(description="课程分类")
@RestController
@RequestMapping("/api/edu/subject")
public class ApiSubjectController {
    @Autowired
    private SubjectService subjectService;
    @ApiOperation("嵌套数据列表")
    @GetMapping("nested-list")
    public R nestedList(){
        List<SubjectVo> subjectVoList = subjectService.nestedList();
        return R.ok().data("items", subjectVoList);
    }
}

```

## 4.2 前端

（1）定义api

course.js

```js

getSubjectNestedList() {
    return request({
        url: '/api/edu/subject/nested-list',
        method: 'get'
    })
},
```

(2)网站端的查询条件

网站的前端查询一般要求浏览器的地址栏中体现出查询条件，这样的查询结果可备转发、收藏，例如腾讯课程的课程查询，京东的商品查询等：

![image-20211111101308771](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211111101308771.png)

组装查询参数对象：course/index.vue

```html
  async asyncData(page) {//此处传递当前页面的上下文对象，以便获取查询条件
    // 组装查询参数  
    const searchObj = {}
    // 从url地址栏中获取查询参数
    const query = page.route.query
    searchObj.subjectParentId = query.subjectParentId || ''
    searchObj.subjectId = query.subjectId || ''
    searchObj.buyCountSort = query.buyCountSort || ''
    searchObj.gmtCreateSort = query.gmtCreateSort || ''
    searchObj.priceSort = query.priceSort || ''
    ......
}
```

(3)课程列表分类

```js
<script>
import courseApi from '~/api/course'
export default {
  async asyncData(page) {
    // 组装查询参数
    ......
    // 从url地址栏中获取查询参数
    ......
    // 获取课程分类嵌套列表
    const subjectNestedListResponse = await courseApi.getSubjectNestedList()
    const subjectNestedList = subjectNestedListResponse.data.items
    // 创建课程分类子列表
    let subSubjectList = []
    // 遍历一级分类
    for (let i = 0; i < subjectNestedList.length; i++) {
      // 如果查询参数中的一级分类id和当前一级分类id一致
      if (subjectNestedList[i].id === searchObj.subjectParentId) {
        // 则获取二级分类列表
        subSubjectList = subjectNestedList[i].children
      }
    }
    // 课程列表
    ......
    
    return {
      courseList, // 课程列表
      subjectNestedList, // 一级分类列表
      subSubjectList, // 二级分类列表
      searchObj// 查询参数
    }
  }
}
</script>
```

## 4.3 渲染一级类别

组件模板

```html

<!-- 一级类别 开始-->
<ul class="clearfix">
    <li
        :class="{current:!$route.query.subjectParentId}">
        <a
           title="全部"
           href="javascript:void(0);"
           @click="searchSubjectLevelOne('')">全部</a>
    </li>
    <li
        v-for="item in subjectNestedList"
        :key="item.id"
        :class="{current:$route.query.subjectParentId===item.id}">
        <a
           :title="item.title"
           href="javascript:void(0);"
           @click="searchSubjectLevelOne(item.id)">{{ item.title }}</a>
    </li>
</ul>
<!-- /一级类别 结束-->
```

定义事件函数

```js
methods: {
    // 选择一级分类
    searchSubjectLevelOne(subjectParentId) {
      window.location = 'course?subjectParentId=' + subjectParentId
    }
}
```

## 4.4 渲染二级类别

组件模板

```html
<!-- 二级类别 开始-->
<ul v-if="$route.query.subjectParentId" class="clearfix">
    <li :class="{current:!$route.query.subjectId}">
        <a
           title="全部"
           href="javascript:void(0);"
           @click="searchSubjectLevelTwo('')">全部</a>
    </li>
    <li
        v-for="item in subSubjectList"
        :key="item.id"
        :class="{current:$route.query.subjectId===item.id}">
        <a
           :title="item.title"
           href="javascript:void(0);"
           @click="searchSubjectLevelTwo(item.id)">{{ item.title }}</a>
    </li>
</ul>
<!-- /二级类别 结束-->
```

安装querystring

```shell
npm install querystring
```

引入querystring

```js
import querystring from 'querystring' // url参数拼接工具
```

定义事件函数

```js
// 选择二级分类
searchSubjectLevelTwo(subjectId) {
    // console.log(this.searchObj)
    // window.location = 'course?subjectId=' + subjectId + '&subjectParentId=' + this.searchObj.subjectParentId
    // 自动组装queryString
    const obj = {
        subjectParentId: this.searchObj.subjectParentId,
        subjectId: subjectId
    }
    const querys = querystring.stringify(obj)
    // console.log(querys)
    window.location = '/course?' + querys
},
```

## 4.5 渲染排序按钮

定义事件函数

```js
// 选择按销量倒序
searchBuyCount() {
    // console.log(this.searchObj)
    // window.location = 'course?buyCountSort=1'
    //  + '&subjectId=' + this.searchObj.subjectId
    //  + '&subjectParentId=' + this.searchObj.subjectParentId
    // 自动组装queryString
    const obj = {
        subjectParentId: this.searchObj.subjectParentId,
        subjectId: this.searchObj.subjectId,
        buyCountSort: 1
    }
    const querys = querystring.stringify(obj)
    window.location = '/course?' + querys
},
// 选择按创建时间倒序
searchGmtCreate() {
  // 自动组装queryString
  const obj = {
    subjectParentId: this.searchObj.subjectParentId,
    subjectId: this.searchObj.subjectId,
    gmtCreateSort: 1
  }
  const querys = querystring.stringify(obj)
  window.location = '/course?' + querys
},
// 选择按价格倒序
searchPrice() {
  // 自动组装queryString
  const obj = {
    subjectParentId: this.searchObj.subjectParentId,
    subjectId: this.searchObj.subjectId,
    priceSort: 1
  }
  const querys = querystring.stringify(obj)
  window.location = '/course?' + querys
}
```

组件模板

```html
<!-- 排序 开始-->
<ol class="js-tap clearfix">
    <li :class="{'current bg-green': $route.query.buyCountSort}">
        <a title="销量" href="javascript:void(0);" @click="searchBuyCount()">销量
            <span>↓</span>
        </a>
    </li>
    <li :class="{'current bg-green': $route.query.gmtCreateSort}">
        <a title="最新" href="javascript:void(0);" @click="searchGmtCreate()">最新
            <span>↓</span>
        </a>
    </li>
    <li :class="{'current bg-green': $route.query.priceSort}">
        <a title="价格" href="javascript:void(0);" @click="searchPrice()">价格&nbsp;
            <span>↓</span>
        </a>
    </li>
</ol>
<!-- /排序 结束-->
```

# 5 价格排序优化

实现点击正序，再次点击倒序

## 5.1 后端vo

WebCourseQueryVo中添加 type表示正序或倒序

```java
@Data
public class WebCourseQueryVo implements Serializable {
    ......
    private Integer type; //价格正序：1，价格倒序：2
}
```

## 5.2 业务层

CourseServiceImpl 修改根据价格排序的业务

```java
@Override
public List<Course> webSelectList(WebCourseQueryVo webCourseQueryVo) {
    ......
    if (!StringUtils.isEmpty(webCourseQueryVo.getPriceSort())) {
        if(webCourseQueryVo.getType() == null || webCourseQueryVo.getType() == 1){
            queryWrapper.orderByAsc("price");
        }else{
            queryWrapper.orderByDesc("price");
        }
    }
    return baseMapper.selectList(queryWrapper);
}
```

## 5.3 前端模板

升序和降序超链接，事件函数传递参数1或2

```html
<li :class="{'current bg-green': $route.query.priceSort}">
    <a v-if="!$route.query.type || $route.query.type == 1" title="价格" href="javascript:void(0);" @click="searchPrice(2)">价格
        <i>↑</i>
    </a>
    <a v-if="$route.query.type == 2" title="价格" href="javascript:void(0);" @click="searchPrice(1)">价格
        <i>↓</i>
    </a>
</li>
```

## 5.4 初始化脚本

添加searchObj.type

```js
async asyncData(page) {
    // 组装查询参数
    const searchObj = {}
    ......
    searchObj.type = query.type || '' // 1：正序，2：倒序
    ......
}
```

## 5.5 排序事件函数

```js
// 按价格排序
searchPrice(type) {
    const queryObj = {
        ......
        type: type
    }
    ......
}
```

# 6 课程详情页

## 6.1 后端接口 vo对象的定义

WebCourseVo.java

```java
package com.atguigu.guli.service.edu.entity.vo;

@Data
public class WebCourseVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private BigDecimal price;
    private Integer lessonNum;
    private String cover;
    private Long buyCount;
    private Long viewCount;
    private String description;
    private String teacherId;
    private String teacherName;
    private String intro;
    private String avatar;
    private String subjectLevelOneId;
    private String subjectLevelOne;
    private String subjectLevelTwoId;
    private String subjectLevelTwo;
}
```

## 6.2 查询课程和讲师信息

CourseMapper.java

```java
WebCourseVo selectWebCourseVoById(String courseId);
```

CourseMapper.xml

```xml
<select id="selectWebCourseVoById" resultType="com.atguigu.guli.service.edu.entity.vo.WebCourseVo">
    SELECT
    c.id,
    c.title,
    c.cover,
    CONVERT(c.price, DECIMAL(8,2)) AS price,
    c.lesson_num AS lessonNum,
    c.buy_count AS buyCount,
    c.view_count AS viewCount,
    cd.description,
    t.id AS teacherId,
    t.name AS teacherName,
    t.intro,
    t.avatar,
    s1.id AS subjectLevelOneId,
    s1.title AS subjectLevelOne,
    s2.id AS subjectLevelTwoId,
    s2.title AS subjectLevelTwo
    FROM
    edu_course c
    LEFT JOIN edu_course_description cd ON c.id = cd.id
    LEFT JOIN edu_teacher t ON c.teacher_id = t.id
    LEFT JOIN edu_subject s1 ON c.subject_parent_id = s1.id
    LEFT JOIN edu_subject s2 ON c.subject_id = s2.id
    WHERE
    c.id = #{id}
</select>
```

## 6.3 获取数据并更新浏览量

CourseService 接口

```java
/**
     * 获取课程信息并更新浏览量
     * @param id
     * @return
     */
WebCourseVo selectWebCourseVoById(String id);
```

实现

```java
@Transactional(rollbackFor = Exception.class)
@Override
public WebCourseVo selectWebCourseVoById(String id) {
    //更新课程浏览数
    Course course = baseMapper.selectById(id);
    course.setViewCount(course.getViewCount() + 1);
    baseMapper.updateById(course);
    //获取课程信息
    return baseMapper.selectWebCourseVoById(id);
}
```

## 6.4 接口层

ApiCourseController

```java
@Autowired
private ChapterService chapterService;
@ApiOperation("根据ID查询课程")
@GetMapping("get/{courseId}")
public R getById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String courseId){
    //查询课程信息和讲师信息
    WebCourseVo webCourseVo = courseService.selectWebCourseVoById(courseId);
    //查询当前课程的章节信息
    List<ChapterVo> chapterVoList = chapterService.nestedList(courseId);
    return R.ok().data("course", webCourseVo).data("chapterVoList", chapterVoList);
}
```

# 7 前端

## 7.1 api

api/course.js

```js
getById(id) {
    return request({
        url: `/api/edu/course/get/${id}`,
        method: 'get'
    })
}
```

## 7.2 页面脚本

pages/course/_id.vue

```html
<script>
import courseApi from '~/api/course'
export default {
  async asyncData(page) {
    const response = await courseApi.getById(page.route.params.id)
    return {
      course: response.data.course,
      chapterList: response.data.chapterVoList
    }
  }
}
</script>
```

## 7.3 课程分类

```html
<!-- 课程所属分类 开始 -->
<section class="path-wrap txtOf hLh30">
    <a href="/" title class="c-999 fsize14">首页</a>
    \
    <a href="/course" title class="c-999 fsize14">课程列表</a>
    \
    <a :href="'/course?subjectParentId='+course.subjectLevelOneId" class="c-333 fsize14">{{ course.subjectLevelOne }}</a>
    \
    <a :href="'/course?subjectParentId='+course.subjectLevelOneId+'&subjectId='+course.subjectLevelTwoId" class="c-333 fsize14">{{ course.subjectLevelTwo }}</a>
</section>
```

## 7.4 课程信息

```html
<!-- 课程基本信息 开始 -->
<div>
    <article class="c-v-pic-wrap" style="height: 357px;">
        <section id="videoPlay" class="p-h-video-box">
            <img :src="course.cover" :alt="course.title" class="dis c-v-pic">
        </section>
    </article>
    <aside class="c-attr-wrap">
        <section class="ml20 mr15">
            <h2 class="hLh30 txtOf mt15">
                <span class="c-fff fsize24">{{ course.title }}</span>
            </h2>
            <section class="c-attr-jg">
                <span class="c-fff">价格：</span>
                <b class="c-yellow" style="font-size:24px;">￥{{ course.price }}</b>
            </section>
            <section class="c-attr-mt c-attr-undis">
                <span class="c-fff fsize14">主讲： {{ course.teacherName }}&nbsp;&nbsp;&nbsp;</span>
            </section>
            <section class="c-attr-mt of">
                <span class="ml10 vam">
                    <em class="icon18 scIcon"/>
                    <a class="c-fff vam" title="收藏" href="#" >收藏</a>
                </span>
            </section>
            <section class="c-attr-mt">
                <a href="#" title="立即观看" class="comm-btn c-btn-3">立即观看</a>
            </section>
        </section>
    </aside>
    <aside class="thr-attr-box">
        <ol class="thr-attr-ol">
            <li>
                <p>&nbsp;</p>
                <aside>
                    <span class="c-fff f-fM">购买数</span>
                    <br>
                    <h6 class="c-fff f-fM mt10">{{ course.buyCount }}</h6>
                </aside>
            </li>
            <li>
                <p>&nbsp;</p>
                <aside>
                    <span class="c-fff f-fM">课时数</span>
                    <br>
                    <h6 class="c-fff f-fM mt10">{{ course.lessonNum }}</h6>
                </aside>
            </li>
            <li>
                <p>&nbsp;</p>
                <aside>
                    <span class="c-fff f-fM">浏览数</span>
                    <br>
                    <h6 class="c-fff f-fM mt10">{{ course.viewCount }}</h6>
                </aside>
            </li>
        </ol>
    </aside>
    <div class="clear"/>
</div>
<!-- /课程基本信息 结束 -->
```

## 7.5 课程详情介绍

```html
<!-- 课程详情介绍 开始 -->
<div>
    <h6 class="c-i-content c-infor-title">
        <span>课程介绍</span>
    </h6>
    <div class="course-txt-body-wrap">
        <!-- v-html：将内容中的html翻译过来 -->
        <section class="course-txt-body" v-html="course.description">
            <!-- {{ course.description }} -->
        </section>
    </div>
</div>
<!-- /课程详情介绍 结束 -->
```

还原被重置的样式

```css
<style>
.course-txt-body ol, .course-txt-body ul{
    padding-left: 40px;
    margin: 16px 0;
}
.course-txt-body ol li{
    list-style: decimal;
}
.course-txt-body ul li{
    list-style: disc;
}
</style>
```

## 7.6 课程大纲

```html
<!-- 课程大纲 开始-->
<div class="mt50">
    <h6 class="c-g-content c-infor-title">
        <span>课程大纲</span>
    </h6>
    <section class="mt20">
        <div class="lh-menu-wrap">
            <menu id="lh-menu" class="lh-menu mt10 mr10">
                <ul>
                    <!-- 课程章节目录 -->
                    <li v-for="chapter in chapterList" :key="chapter.id" class="lh-menu-stair">
                        <a :title="chapter.title" href="javascript: void(0)" class="current-1">
                            <em class="lh-menu-i-1 icon18 mr10"/>{{ chapter.title }}
                        </a>
                        <ol class="lh-menu-ol" style="display: block;">
                            <li v-for="video in chapter.children" :key="video.id" class="lh-menu-second ml30">
                                <a href="#" title>
                                    <span v-if="Number(course.price) !== 0 && video.free===true" class="fr">
                                        <i class="free-icon vam mr10">免费试听</i>
                                    </span>
                                    <em class="lh-menu-i-2 icon16 mr5">&nbsp;</em>{{ video.title }}
                                </a>
                            </li>
                        </ol>
                    </li>
                </ul>
            </menu>
        </div>
    </section>
    <!-- /课程大纲 结束 -->
```

## 7.7 主讲讲师

```html
<!-- 主讲讲师 开始-->
<div>
    <section class="c-infor-tabTitle c-tab-title">
        <a title href="javascript:void(0)">主讲讲师</a>
    </section>
    <section class="stud-act-list">
        <ul style="height: auto;">
            <li>
                <div class="u-face">
                    <a :href="'/teacher/'+course.teacherId" target="_blank">
                        <img :src="course.avatar" width="50" height="50" alt>
                    </a>
                </div>
                <section class="hLh30 txtOf">
                    <a :href="'/teacher/'+course.teacherId" class="c-333 fsize16 fl" target="_blank">{{ course.teacherName }}</a>
                </section>
                <section class="hLh20 txtOf">
                    <span class="c-999">{{ course.intro }}</span>
                </section>
            </li>
        </ul>
    </section>
</div>
<!-- /主讲讲师 结束 -->
```

