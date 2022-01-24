# part15-课程管理(二)

# 1 课程列表

## 1.1 后端实现 定义搜索对象 

CourseQueryVo.java

```java

package com.atguigu.guli.service.edu.entity.vo;

@Data
public class CourseQueryVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String title;
    private String teacherId;
    private String subjectParentId;
    private String subjectId;
}
```

## 1.2 定义查询结果对象

```java

package com.atguigu.guli.service.edu.entity.vo;

@Data
public class CourseVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private String subjectParentTitle;
    private String subjectTitle;
    private String teacherName;
    private Integer lessonNum;
    private String price;
    private String cover;
    private Long buyCount;
    private Long viewCount;
    private String status;
    private String gmtCreate;
}
```

## 1.3 web层

CourseController.java

```java

@ApiOperation("分页课程列表")
@GetMapping("list/{page}/{limit}")
public R index(
    @ApiParam(value = "当前页码", required = true)
    @PathVariable Long page,
    @ApiParam(value = "每页记录数", required = true)
    @PathVariable Long limit,
    @ApiParam(value = "查询对象")
    CourseQueryVo courseQueryVo){
    IPage<CourseVo> pageModel = courseService.selectPage(page, limit, courseQueryVo);
    List<CourseVo> records = pageModel.getRecords();
    long total = pageModel.getTotal();
    return  R.ok().data("total", total).data("rows", records);
}
```

## 1.4 service层

难点：使用MyBatis Plus的分页插件和QueryWrapper结合自定义mapper xml实现多表关联查询

接口：CourseService.java

```java
IPage<CourseVo> selectPage(Long page, Long limit, CourseQueryVo courseQueryVo);
```

实现：CourseServiceImpl.java

```java
@Override
public IPage<CourseVo> selectPage(Long page, Long limit, CourseQueryVo courseQueryVo) {
    QueryWrapper<CourseVo> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByDesc("c.gmt_create");
    String title = courseQueryVo.getTitle();
    String teacherId = courseQueryVo.getTeacherId();
    String subjectParentId = courseQueryVo.getSubjectParentId();
    String subjectId = courseQueryVo.getSubjectId();
    if (!StringUtils.isEmpty(title)) {
        queryWrapper.like("c.title", title);
    }
    if (!StringUtils.isEmpty(teacherId) ) {
        queryWrapper.eq("c.teacher_id", teacherId);
    }
    if (!StringUtils.isEmpty(subjectParentId)) {
        queryWrapper.eq("c.subject_parent_id", subjectParentId);
    }
    if (!StringUtils.isEmpty(subjectId)) {
        queryWrapper.eq("c.subject_id", subjectId);
    }
    Page<CourseVo> pageParam = new Page<>(page, limit);
    //放入分页参数和查询条件参数，mp会自动组装
    List<CourseVo> records = baseMapper.selectPageByCourseQueryVo(pageParam, queryWrapper);
    pageParam.setRecords(records);
    return pageParam;
}
```

## 1.5 mapper层

接口：CourseMapper.java

```java
List<CourseVo> selectPageByCourseQueryVo(
    //mp会自动组装分页参数
    Page<CourseVo> pageParam,
    //mp会自动组装queryWrapper：
    //@Param(Constants.WRAPPER) 和 xml文件中的 ${ew.customSqlSegment} 对应
    @Param(Constants.WRAPPER) QueryWrapper<CourseVo> queryWrapper);
```

xml：CourseMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.atguigu.guli.service.edu.mapper.CourseMapper">
    <sql id="columns">
     c.id,
     c.title,
     c.lesson_num AS lessonNum,
     CONVERT(c.price, DECIMAL(8,2)) AS price,
     c.cover,
     c.buy_count AS buyCount,
     c.view_count AS viewCount,
     c.status,
     c.gmt_create AS gmtCreate,
     t.name AS teacherName,
     s1.title AS subjectParentTitle,
     s2.title AS subjectTitle
    </sql>
    <sql id="tables">
        edu_course c
        LEFT JOIN edu_teacher t ON c.teacher_id = t.id
        LEFT JOIN edu_subject s1 ON c.subject_parent_id = s1.id
        LEFT JOIN edu_subject s2 ON c.subject_id = s2.id
    </sql>
    <select id="selectPageByCourseQueryVo" resultType="com.atguigu.guli.service.edu.entity.vo.CourseVo">
        SELECT
        <include refid="columns" />
        FROM
        <include refid="tables" />
        ${ew.customSqlSegment}
    </select>
</mapper>
```

# 2 前端实现

## 2.1 定义api

src/api/course.js

```js
getPageList(page, limit, searchObj) {
  return request({
    url: `/admin/edu/course/list/${page}/${limit}`,
    method: 'get',
    params: searchObj
  })
},

```

## 2.2 组件中的js

src/views/course/list.vue

```js
<script>
import courseApi from '@/api/course'
import teacherApi from '@/api/teacher'
import subjectApi from '@/api/subject'
export default {
  data() {
    return {
      list: [], // 课程列表
      total: 0, // 总记录数
      page: 1, // 页码
      limit: 10, // 每页记录数
      searchObj: {
        subjectId: ''// 解决查询表单无法选中二级类别
      }, // 查询条件
      teacherList: [], // 讲师列表
      subjectList: [], // 一级分类列表
      subjectLevelTwoList: [] // 二级分类列表,
    }
  },
  created() {
    this.fetchData()
    // 初始化分类列表
    this.initSubjectList()
    // 获取讲师列表
    this.initTeacherList()
  },
  methods: {
    fetchData() {
      courseApi.getPageList(this.page, this.limit, this.searchObj).then(response => {
        this.list = response.data.rows
        this.total = response.data.total
      })
    },
    initTeacherList() {
      teacherApi.list().then(response => {
        this.teacherList = response.data.items
      })
    },
    initSubjectList() {
      subjectApi.getNestedTreeList().then(response => {
        this.subjectList = response.data.items
      })
    },
    subjectLevelOneChanged(value) {
      for (let i = 0; i < this.subjectList.length; i++) {
        if (this.subjectList[i].id === value) {
          this.subjectLevelTwoList = this.subjectList[i].children
          this.searchObj.subjectId = ''
        }
      }
    },
    // 每页记录数改变，size：回调参数，表示当前选中的“每页条数”
    changePageSize(size) {
      this.limit = size
      this.fetchData()
    },
    // 改变页码，page：回调参数，表示当前选中的“页码”
    changeCurrentPage(page) {
      this.page = page
      this.fetchData()
    },
    // 重置表单
    resetData() {
      this.searchObj = {}
      this.subjectLevelTwoList = [] // 二级分类列表
      this.fetchData()
    }
  }
}
</script>
```

## 2.3 组件模板

src/views/course/list.vue

```html
<template>
  <div class="app-container">
      <!--查询表单 TODO-->
      <!-- 表格 TODO -->
      <!-- 分页 TODO -->
  </div>
</template>      
```

查询表单

```html
<!--查询表单-->
<el-form :inline="true" class="demo-form-inline">
    <!-- 所属分类：级联下拉列表 -->
    <!-- 一级分类 -->
    <el-form-item label="课程类别">
        <el-select
                   v-model="searchObj.subjectParentId"
                   placeholder="请选择"
                   @change="subjectLevelOneChanged">
            <el-option
                       v-for="subject in subjectList"
                       :key="subject.id"
                       :label="subject.title"
                       :value="subject.id"/>
        </el-select>
        <!-- 二级分类 -->
        <el-select v-model="searchObj.subjectId" placeholder="请选择">
            <el-option
                       v-for="subject in subjectLevelTwoList"
                       :key="subject.id"
                       :label="subject.title"
                       :value="subject.id"/>
        </el-select>
    </el-form-item>
    <!-- 标题 -->
    <el-form-item>
        <el-input v-model="searchObj.title" placeholder="课程标题"/>
    </el-form-item>
    <!-- 讲师 -->
    <el-form-item>
        <el-select
                   v-model="searchObj.teacherId"
                   placeholder="请选择讲师">
            <el-option
                       v-for="teacher in teacherList"
                       :key="teacher.id"
                       :label="teacher.name"
                       :value="teacher.id"/>
        </el-select>
    </el-form-item>
    <el-button type="primary" icon="el-icon-search" @click="fetchData()">查询</el-button>
    <el-button type="default" @click="resetData()">清空</el-button>
</el-form>
```

表格：注意货币和日期类型列的处理

```html
  <!-- 表格 -->
    <el-table :data="list" border stripe>
      <el-table-column label="#" width="50">
        <template slot-scope="scope">
          {{ (page - 1) * limit + scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column label="封面" width="200" align="center">
        <template slot-scope="scope">
          <img :src="scope.row.cover" alt="scope.row.title" width="100%">
        </template>
      </el-table-column>
      <el-table-column label="课程信息">
        <template slot-scope="scope">
          <a href="">{{ scope.row.title }}</a>
          <p>
            分类：{{ scope.row.subjectParentTitle }} > {{ scope.row.subjectTitle }}
          </p>
          <p>
            课时：{{ scope.row.lessonNum }} /
            浏览：{{ scope.row.viewCount }} /
            付费学员：{{ scope.row.buyCount }}
          </p>
        </template>
      </el-table-column>
      <el-table-column label="讲师" width="100" align="center">
        <template slot-scope="scope">
          {{ scope.row.teacherName }}
        </template>
      </el-table-column>
      <el-table-column label="价格(元)" width="100" align="center" >
        <template slot-scope="scope">
          <!-- {{ typeof '0' }}  {{ typeof 0 }} {{ '0' == 0 }} -->
          <!-- {{ typeof scope.row.price }}
          {{ typeof Number(scope.row.price) }}
          {{ typeof Number(scope.row.price).toFixed(2) }} -->
          <el-tag v-if="Number(scope.row.price) === 0" type="success">免费</el-tag>
          <!-- 前端解决保留两位小数的问题 -->
          <!-- <el-tag v-else>{{ Number(scope.row.price).toFixed(2) }}</el-tag> -->
          <!-- 后端解决保留两位小数的问题，前端不用处理 -->
          <el-tag v-else>{{ scope.row.price }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="课程状态" width="100" align="center" >
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === 'Draft' ? 'warning' : 'success'">{{ scope.row.status === 'Draft' ? '未发布' : '已发布' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" width="120" align="center">
        <template slot-scope="scope">
          {{ scope.row.gmtCreate.substr(0, 10) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="300" align="center">
        <template slot-scope="scope">
          <router-link :to="'/course/info/'+scope.row.id">
            <el-button type="primary" size="mini" icon="el-icon-edit">修改</el-button>
          </router-link>
          <router-link :to="'/course/chapter/'+scope.row.id">
            <el-button type="primary" size="mini" icon="el-icon-edit">编辑大纲</el-button>
          </router-link>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="removeById(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
```

分页：

```html

<!-- 分页组件 -->
    <el-pagination
      :current-page="page"
      :total="total"
      :page-size="limit"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      style="padding: 30px 0; text-align: center;"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="changePageSize"
      @current-change="changeCurrentPage"
    />
```

## 2.4 点击修改按钮

src/views/course/form.vue

```js
created() {
    // 获取路由id
    if (this.$route.name === 'CourseInfoEdit') {
        this.courseId = this.$route.params.id
        this.active = 0
    }
    if (this.$route.name === 'CourseChapterEdit') {
        this.courseId = this.$route.params.id
        this.active = 1
    }
}
```

# 3 删除课程

## 3.1 后端实现 web层

定义删除api方法：CourseController.java

```java
@ApiOperation("根据ID删除课程")
@DeleteMapping("remove/{id}")
public R removeById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String id){
    //TODO 删除视频：VOD
    //在此处调用vod中的删除视频文件的接口
    //删除封面：OSS
    courseService.removeCoverById(id);
    //删除课程
    boolean result = courseService.removeCourseById(id);
    if (result) {
        return R.ok().message("删除成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 3.2 service层

接口：CourseService.java

```java
boolean removeCoverById(String id);
boolean removeCourseById(String id);
```

实现：CourseServiceImpl.java

依赖注入：Mapper接口上添加 @Repository注解

```java
@Autowired
private VideoMapper videoMapper;
@Autowired
private ChapterMapper chapterMapper;
@Autowired
private CommentMapper commentMapper;
@Autowired
private CourseCollectMapper courseCollectMapper;
@Autowired
private OssFileService ossFileService;
```

删除课程封面：

```java
@Override
public boolean removeCoverById(String id) {
    Course course = baseMapper.selectById(id);
    if(course != null) {
        String cover = course.getCover();
        if(!StringUtils.isEmpty(cover)){
            //删除图片
            R r = ossFileService.removeFile(cover);
            return r.getSuccess();
        }
    }
    return false;
}
```

删除课程：

```java
@Transactional(rollbackFor = Exception.class)
@Override
public boolean removeCourseById(String id) {
    //收藏信息：course_collect
    QueryWrapper<CourseCollect> courseCollectQueryWrapper = new QueryWrapper<>();
    courseCollectQueryWrapper.eq("course_id", id);
    courseCollectMapper.delete(courseCollectQueryWrapper);
    //评论信息：comment
    QueryWrapper<Comment> commentQueryWrapper = new QueryWrapper<>();
    commentQueryWrapper.eq("course_id", id);
    commentMapper.delete(commentQueryWrapper);
    //课时信息：video
    QueryWrapper<Video> videoQueryWrapper = new QueryWrapper<>();
    videoQueryWrapper.eq("course_id", id);
    videoMapper.delete(videoQueryWrapper);
    //章节信息：chapter
    QueryWrapper<Chapter> chapterQueryWrapper = new QueryWrapper<>();
    chapterQueryWrapper.eq("course_id", id);
    chapterMapper.delete(chapterQueryWrapper);
    //课程详情：course_description
    courseDescriptionMapper.deleteById(id);
    //课程信息：course
    return this.removeById(id);
}
```

# 4 前端实现 

## 4.1 定义api

src/api/course.js中添加删除方法

```js

removeById(id) {
    return request({
        url: `/admin/edu/course/remove/${id}`,
        method: 'delete'
    })
}

```

## 4.2 修改删除按钮

src/views/course/list.vue 删除按钮注册click事件

```html
<el-button type="text" size="mini" icon="el-icon-delete" @click="removeById(scope.row.id)">删除</el-button>
```

## 4.3 编写删除方法

```js

// 根据id删除数据
removeById(id) {
    this.$confirm('此操作将永久删除该课程，以及该课程下的章节和视频，是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        return courseApi.removeById(id)
    }).then(response => {
        this.fetchData()
        this.$message.success(response.message)
    }).catch((response) => { // 失败
        if (response === 'cancel') {
            this.$message.info('取消删除')
        }
    })
}
```

# 5 发布课程

要求完成接口： 

（1）根据课程id获取课程发布基本信息

（2）根据课程id发布课程

## 5.1 **查询课程发布信息 **定义vo

```java
package com.atguigu.guli.service.edu.entity.vo;
@Data
public class CoursePublishVo  implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private String cover;
    private Integer lessonNum;
    private String subjectParentTitle;
    private String subjectTitle;
    private String teacherName;
    private String price;//只用于显示
}
```

## 5.2 web层

CourseController.java

```java
@ApiOperation("根据ID获取课程发布信息")
@GetMapping("course-publish/{id}")
public R getCoursePublishVoById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String id){
    CoursePublishVo coursePublishVo = courseService.getCoursePublishVoById(id);
    if (coursePublishVo != null) {
        return R.ok().data("item", coursePublishVo);
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 5.3 service层

接口：CourseService.java

```java
CoursePublishVo getCoursePublishVoById(String id);
```

实现：CourseServiceImpl.java

```java
@Override
public CoursePublishVo getCoursePublishVoById(String id) {
    return baseMapper.selectCoursePublishVoById(id);
}
```

## 5.4 **mapper层**

接口：CourseMapper.java

```java
CoursePublishVo selectCoursePublishVoById(String id);
```

实现：CourseMapper.xml

```xml
<select id="selectCoursePublishVoById" resultType="com.atguigu.guli.service.edu.entity.vo.CoursePublishVo">
    SELECT
    c.id,
    c.title,
    c.cover,
    c.lesson_num AS lessonNum,
    CONVERT(c.price, DECIMAL(8,2)) AS price,
    t.name AS teacherName,
    s1.title AS subjectParentTitle,
    s2.title AS subjectTitle
    FROM
    <include refid="tables" />
    WHERE c.id = #{id}
</select>
```

# 6 根据id发布课程

## 6.1 **web层**

CourseController.java

```java
@ApiOperation("根据id发布课程")
@PutMapping("publish-course/{id}")
public R publishCourseById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String id){
    boolean result = courseService.publishCourseById(id);
    if (result) {
        return R.ok().message("发布成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 6.2 service层

接口：CourseService.java

```java
boolean publishCourseById(String id);
```

实现：CourseServiceImpl.java

```java
@Override
public boolean publishCourseById(String id) {
    Course course = new Course();
    course.setId(id);
    course.setStatus(Course.COURSE_NORMAL);
    return this.updateById(course);
}
```

# 7 前端代码

## 7.1 定义api

api/course.js

```js
getCoursePublishById(id) {
  return request({
    url: `/admin/edu/course/course-publish/${id}`,
    method: 'get'
  })
},
publishCourseById(id) {
  return request({
    url: `/admin/edu/course/publish-course/${id}`,
    method: 'put'
  })
}
```

## 7.2 定义数据模型

src/views/course/components/Publish.vue

```js
data() {
    return {
        publishBtnDisabled: false, // 按钮是否禁用
        coursePublish: {}
    }
},
```

## 7.3 组件方法定义

src/views/course/components/Publish.vue

引入courseApi

```js
import courseApi from '@/api/course'
```

生命周期函数

```js
created() {
    if (this.$parent.courseId) {
        this.fetchCoursePublishById(this.$parent.courseId)
    }
}
```

获取数据的方法

```js

// 获取课程发布信息
fetchCoursePublishById(id) {
    courseApi.getCoursePublishById(id).then(response => {
        this.coursePublish = response.data.item
    })
}
```

## 7.4 组件模板

```js
<!--课程预览-->
<div class="ccInfo">
    <img :src="coursePublish.cover">
    <div class="main">
        <h2>{{ coursePublish.title }}</h2>
        <p class="gray"><span>共{{ coursePublish.lessonNum }}课时</span></p>
        <p><span>所属分类：{{ coursePublish.subjectParentTitle }} — {{ coursePublish.subjectTitle }}</span></p>
        <p>课程讲师：{{ coursePublish.teacherName }}</p>
        <h3 class="red">￥{{ coursePublish.price }}</h3>
    </div>
</div>
```

## 7.5 css样式

```css
<style>
.ccInfo {
    background: #f5f5f5;
    padding: 20px;
    overflow: hidden;
    border: 1px dashed #DDD;
    margin-bottom: 40px;
    position: relative;
}
.ccInfo img {
    background: #d6d6d6;
    width: 500px;
    height: 278px;
    display: block;
    float: left;
    border: none;
}
.ccInfo .main {
    margin-left: 520px;
}
.ccInfo .main h2 {
    font-size: 28px;
    margin-bottom: 30px;
    line-height: 1;
    font-weight: normal;
}
.ccInfo .main p {
    margin-bottom: 10px;
    word-wrap: break-word;
    line-height: 24px;
    max-height: 48px;
    overflow: hidden;
}
.ccInfo .main p {
    margin-bottom: 10px;
    word-wrap: break-word;
    line-height: 24px;
    max-height: 48px;
    overflow: hidden;
}
.ccInfo .main h3 {
    left: 540px;
    bottom: 20px;
    line-height: 1;
    font-size: 28px;
    color: #d32f24;
    font-weight: normal;
    position: absolute;
}
</style>
```

## 7.6 发布课程

```js
// 下一步
publish() {
    this.publishBtnDisabled = true
    courseApi.publishCourseById(this.$parent.courseId).then(response => {
        this.$parent.active = 3
        this.$message.success(response.message)
    })
},
```

