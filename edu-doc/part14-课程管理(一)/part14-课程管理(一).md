# part14-课程管理(一)

# 1 课程发布流程

## 1.1 编辑课程基本信息

![image-20211105181927343](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105181927343.png)

## 1.2 课程大纲列表

![image-20211105182000642](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182000642.png)

## 1.3 添加章节

![image-20211105182017985](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182017985.png)

## 1.4 添加课时

![image-20211105182037458](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182037458.png)

## 1.5 课程发布预览

![image-20211105182142658](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182142658.png)

# 2 课程列表

![image-20211105182224904](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182224904.png)

# 3 步骤条

## 3.1 配置路由 添加vue组件

组件开发的场景

- 业务逻辑独立
- 组件可复用
- 组件过于庞大可拆分为子组件

![image-20211105182535204](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105182535204.png)

## 3.2 添加路由

```js
// 课程管理
{
  path: '/course',
    component: Layout,
      redirect: '/course/list',
        name: 'Course',
          meta: { title: '课程管理' },
            children: [
              {
                path: 'list',
                name: 'CourseList',
                component: () => import('@/views/course/list'),
                meta: { title: '课程列表' }
              },
              {
              path: 'info',
              name: 'CourseInfo',
              component: () => import('@/views/course/form'),
                meta: { title: '发布课程' }
},
  {
    path: 'info/:id',
      name: 'CourseInfoEdit',
        component: () => import('@/views/course/form'),
          meta: { title: '编辑课程' },
            hidden: true
  },
    {
      path: 'chapter/:id',
        name: 'CourseChapterEdit',
          component: () => import('@/views/course/form'),
            meta: { title: '编辑大纲' },
              hidden: true
    }
]
},
```

# 4 整合步骤导航

## 组件开发的步骤

- step1：创建组件文件（*.vue）
- step2：在父组件中引入组件  import
- step3：注册组件 components
- step4：使用组件 <组件名>

## 4.1 表单页面

form.vue

```html
<template>
  <div class="app-container">
    <h2 style="text-align: center;">发布新课程</h2>
    <el-steps :active="active" finish-status="success" simple style="margin-bottom: 40px">
      <el-step title="填写课程基本信息" />
      <el-step title="创建课程大纲" />
      <el-step title="发布课程" />
    </el-steps>
    <!-- 填写课程基本信息 -->
    <info v-if="active === 0" />
    <!-- 创建课程大纲 -->
    <chapter v-if="active === 1" />
    <!-- 发布课程 -->
    <Publish v-if="active === 2 || active === 3" />
  </div>
</template>
<script>
// 引入子组件
import Info from '@/views/course/components/Info'
import Chapter from '@/views/course/components/Chapter'
import Publish from '@/views/course/components/Publish'
export default {
  components: { Info, Chapter, Publish }, // 注册子组件
  data() {
    return {
      active: 0,
      courseId: null
    }
  }
}
</script>
```

## 4.2 课程信息页面

components/info.vue

```html
<template>
  <div class="app-container">
    <!-- 课程信息表单 TODO -->
    <div style="text-align:center">
      <el-button :disabled="saveBtnDisabled" type="primary" @click="saveAndNext()">保存并下一步</el-button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      saveBtnDisabled: false // 按钮是否禁用
    }
  },
  methods: {
    // 保存并下一步
    saveAndNext() {
      this.saveBtnDisabled = true   
      this.$parent.active = 1
    }
  }
}
</script>
```

## 4.3 课程大纲页面

components/Chapter/index.vue

```html
<template>
  <div class="app-container">
    <!-- 章节列表 TODO -->
    <div style="text-align:center">
      <el-button type="primary" @click="prev()">上一步</el-button>
      <el-button type="primary" @click="next()">下一步</el-button>
    </div>
  </div>
</template>
<script>
export default {
  methods: {
    // 上一步
    prev() {
      this.$parent.active = 0
    },
    // 下一步
    next() {
      this.$parent.active = 2
    }
  }
}
</script>
```

## 4.4 课程发布页面

components/publish.vue

```html
<template>
  <div class="app-container">
    <!--课程预览 TODO-->   
    <div style="text-align:center">
      <el-button type="primary" @click="prev()">上一步</el-button>
      <el-button :disabled="publishBtnDisabled" type="primary" @click="publish()">发布课程</el-button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      publishBtnDisabled: false // 按钮是否禁用
    }
  },
  methods: {
    // 上一步
    prev() {
      this.$parent.active = 1
    },
    // 下一步
    publish() {
      this.publishBtnDisabled = true   
      this.$parent.active = 3
    }
  }
}
</script>
```

# 5 后端接口

service_edu微服务

## 5.1 定义form表单对象

CourseInfoForm.java

```java
package com.atguigu.guli.service.edu.entity.form;

@ApiModel("课程基本信息")
@Data
public class CourseInfoForm implements Serializable {
  
    private static final long serialVersionUID = 1L;
    @ApiModelProperty(value = "课程ID")
    private String id;
    @ApiModelProperty(value = "课程讲师ID")
    private String teacherId;
    @ApiModelProperty(value = "课程专业ID")
    private String subjectId;
    @ApiModelProperty(value = "课程专业父级ID")
    private String subjectParentId;
    @ApiModelProperty(value = "课程标题")
    private String title;
    @ApiModelProperty(value = "课程销售价格，设置为0则可免费观看")
    private BigDecimal price;
    @ApiModelProperty(value = "总课时")
    private Integer lessonNum;
    @ApiModelProperty(value = "课程封面图片路径")
    private String cover;
    @ApiModelProperty(value = "课程简介")
    private String description;
}
```

## 5.2 CourseDescription主键策略

在CourseDescription中添加主键定义，并定义生成策略为IdType.NONE

```java
@ApiModelProperty(value = "ID")
@TableId(value = "id", type = IdType.NONE)
private String id;
```

## 5.3 定义常量

实体类Course.Java中定义

```java
public static final String COURSE_DRAFT = "Draft";//未发布
public static final String COURSE_NORMAL = "Normal";//已发布
```

## 5.4 定义控制层接口

CourseController.java

```java
package com.atguigu.guli.service.edu.controller.admin;

@Api(description="课程管理")
@CrossOrigin //跨域
@RestController
@RequestMapping("/admin/edu/course")
public class CourseController {
  
    @Autowired
    private CourseService courseService;
    @ApiOperation("新增课程")
    @PostMapping("save-course-info")
    public R saveCourseInfo(
            @ApiParam(value = "课程基本信息", required = true)
            @RequestBody CourseInfoForm courseInfoForm){
        String courseId = courseService.saveCourseInfo(courseInfoForm);
        return R.ok().data("courseId", courseId).message("保存成功");
    }
}
```

## 5.5 定义业务层方法

接口：CourseService.java

```java
/**
* 保存课程和课程详情信息
* @param courseInfoForm
* @return 新生成的课程id
*/     
String saveCourseInfo(CourseInfoForm courseInfoForm);
```

实现：CourseServiceImpl.java

注意：这里使用了事物

```java
//注意：为了避免idea在这个位置报告找不到依赖的错误，
//我们可以在CourseDescriptionMapper接口上添加@Repository注解
@Autowired
private CourseDescriptionMapper courseDescriptionMapper;
@Transactional(rollbackFor = Exception.class)
@Override
public String saveCourseInfo(CourseInfoForm courseInfoForm) {
    //保存课程基本信息
    Course course = new Course();
    course.setStatus(Course.COURSE_DRAFT);
    BeanUtils.copyProperties(courseInfoForm, course);
    baseMapper.insert(course);
    //保存课程详情信息
    CourseDescription courseDescription = new CourseDescription();
    courseDescription.setDescription(courseInfoForm.getDescription());
    courseDescription.setId(course.getId());
    courseDescriptionMapper.insert(courseDescription);
    return course.getId();
}
```

# 6 前端实现

## 6.1 定义api

api/course.js

```js
import request from '@/utils/request'

export default {
  saveCourseInfo(courseInfo) {
    return request({
      url: '/admin/edu/course/save-course-info',
      method: 'post',
      data: courseInfo
    })
  }
}
```

## 6.2 组件模板

src/views/course/components/Info.vue

```html
<!-- 课程信息表单 -->
<el-form label-width="120px">
    <el-form-item label="课程标题">
        <el-input v-model="courseInfo.title" placeholder=" 示例：机器学习项目课：从基础到搭建项目视频课程。专业名称注意大小写"/>
    </el-form-item>
    <!-- 课程讲师 TODO -->
    <!-- 所属分类 TODO -->
    <el-form-item label="总课时">
        <el-input-number :min="0" v-model="courseInfo.lessonNum" controls-position="right" placeholder="请填写课程的总课时数"/>
    </el-form-item>
    <!-- 课程简介 TODO -->
    <!-- 课程封面 TODO -->
    <el-form-item label="课程价格">
        <el-input-number :min="0" v-model="courseInfo.price" controls-position="right" placeholder="免费课程请设置为0元"/> 元
    </el-form-item>
</el-form>
```

## 6.3 组件js

```js
<script>
  
import courseApi from '@/api/course'
export default {
  data() {
    return {
      saveBtnDisabled: false, // 按钮是否禁用
      courseInfo: {// 表单数据
        price: 0,
        lessonNum: 0,
        // 以下解决表单数据不全时insert语句非空校验
        teacherId: '',
        subjectId: '',
        subjectParentId: '',
        cover: '',
        description: ''
      }
    }
  },
  methods: {
    // 保存并下一步
    saveAndNext() {
      this.saveBtnDisabled = true
      this.saveData()
    },
    // 保存
    saveData() {
      courseApi.saveCourseInfo(this.courseInfo).then(response => {
        this.$message.success(response.message)
        this.$parent.courseId = response.data.courseId // 获取courseId
        this.$parent.active = 1 // 下一步  
      })
    }
  }
}
</script>
```



# 7 下拉列表

## 7.1 前端实现 组件脚本

Info.vue组件中引入teacher api

```js
import teacherApi from '@/api/teacher'
```

定义data

```js
teacherList: [] // 讲师列表
```

methods中获取讲师列表

```js
initTeacherList() {
  teacherApi.list().then(response => {
    this.teacherList = response.data.items
  })
},
```

组件初始化时获取讲师列表

```js
created() {
  // 获取讲师列表
  this.initTeacherList()
},
```

## 7.2 组件模板

```html
<!-- 课程讲师 -->
<el-form-item label="课程讲师">
  <el-select
    v-model="courseInfo.teacherId"
    placeholder="请选择">
    <el-option
      v-for="teacher in teacherList"
      :key="teacher.id"
      :label="teacher.name"
      :value="teacher.id"/>
  </el-select>
</el-form-item>
```



# 8 获取课程一级分类

## 8.1 组件数据定义

```js
subjectList: [],//一级分类列表
subjectLevelTwoList: []//二级分类列表
```

## 8.2 组件脚本 

表单初始化时获取一级分类嵌套列表，引入subject api

```js
import subjectApi from '@/api/subject'
```

定义方法

```js
initSubjectList() {
  subjectApi.getNestedTreeList().then(response => {
    this.subjectList = response.data.items
  })
},
```

页面加载时

```js
created() {
    // 获取讲师列表
    this.initTeacherList()
    // 初始化分类列表
    this.initSubjectList()
},
```

## 8.3 组件模板

```html
<!-- 所属分类：级联下拉列表 -->
<el-form-item label="课程类别">
  <!-- 一级分类 -->
  <el-select
    v-model="courseInfo.subjectParentId"
    placeholder="请选择">
    <el-option
      v-for="subject in subjectList"
      :key="subject.id"
      :label="subject.title"
      :value="subject.id"/>
  </el-select>
  <!-- 二级分类 TODO -->  
</el-form-item>
```

# 9 级联显示课程二级分类

## 9.1 注册change事件

在一级分类的<el-select>组件中注册change事件

```html
 <el-select @change="subjectChanged" ......
```

## 9.2 定义change事件方法

```js
subjectChanged(value) {
    this.subjectList.forEach(subject => {
        if (subject.id === value) {
            this.courseInfo.subjectId = ''
            this.subjectLevelTwoList = subject.children
        }
    })
},
```

## 9.3 组件模板

```html
<!-- 二级分类 -->
<el-select v-model="courseInfo.subjectId" placeholder="请选择">
  <el-option
    v-for="subject in subjectLevelTwoList"
    :key="subject.id"
    :label="subject.title"
    :value="subject.id"/>
</el-select>
```

# 10 富文本编辑器 Tinymce可视化编辑器

参考：https://panjiachen.gitee.io/vue-element-admin/#/components/tinymce

Tinymce是一个传统javascript插件，默认不能用于Vue.js因此需要做一些特殊的整合步骤



## 10.1 复制脚本库

将脚本库复制到项目的static目录下（在vue-element-admin-master的static路径下）

## 10.2 引入js脚本

在guli-admin/index.html 中引入js脚本

```js
<script src="/static/tinymce4.7.5/tinymce.min.js"></script>
<script src="/static/tinymce4.7.5/langs/zh_CN.js"></script>
```

## 10.3 组件引入

为了让Tinymce能用于Vue.js项目，vue-element-admin对Tinymce进行了封装，下面我们将它引入到我们的课程信息页面

## 10.4 复制组件

src/components/Tinymce（在vue-element-admin-master的src路径下）

## 10.5 引入组件

Info.vue组件中引入 Tinymce

```js
import Tinymce from '@/components/Tinymce'

export default {
  components: { Tinymce },
  //......
}
```

## 10.6 组件模板

```js
<!-- 课程简介-->
<el-form-item label="课程简介">
    <tinymce :height="300" v-model="courseInfo.description"/>
</el-form-item>
```

## 10.7 组件样式

在info.vue文件的最后添加如下代码，调整上传图片按钮的高度

```css
<style>
.tinymce-container {
  position: relative;
  line-height: normal;
}
</style>
```

# 11 课程封面上传

## 11.1 组件模板

在Info.vue中添加上传组件模板

```html
<!-- 课程封面 -->
<el-form-item label="课程封面">
    <el-upload
           :show-file-list="false"
           :on-success="handleCoverSuccess"
           :before-upload="beforeCoverUpload"
           :on-error="handleCoverError"
           class="cover-uploader"
           action="http://localhost:8120/admin/oss/file/upload?module=cover">
        <img v-if="courseInfo.cover" :src="courseInfo.cover">
        <i v-else class="el-icon-plus avatar-uploader-icon"/>
    </el-upload>
</el-form-item>
```

css

```css
<style>
.cover-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.cover-uploader .el-upload:hover {
  border-color: #409EFF;
}
.cover-uploader .avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 640px;
  height: 357px;
  line-height: 357px;
  text-align: center;
}
.cover-uploader img {
  width: 640px;
  height: 357px;
  display: block;
}
</style>
```

## 11.2 回调函数

```js
// 上传成功回调
handleCoverSuccess(res, file) {
  if (res.success) {
    // console.log(res)
    this.courseInfo.cover = res.data.url
    // 强制重新渲染
    this.$forceUpdate()
  } else {
    this.$message.error('上传失败1')
  }
},
// 上传校验
beforeCoverUpload(file) {
  const isJPG = file.type === 'image/jpeg'
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isJPG) {
    this.$message.error('上传头像图片只能是 JPG 格式!')
  }
  if (!isLt2M) {
    this.$message.error('上传头像图片大小不能超过 2MB!')
  }
  return isJPG && isLt2M
},
// 错误处理
handleCoverError() {
  console.log('error')
  this.$message.error('上传失败2')
},
```

# 12 课程信息回显

## 12.1 web层

CourseController.java

```java
@ApiOperation("根据ID查询课程")
@GetMapping("course-info/{id}")
public R getById(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String id){
    CourseInfoForm courseInfoForm = courseService.getCourseInfoById(id);
    if (courseInfoForm != null) {
        return R.ok().data("item", courseInfoForm);
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 12.2 service层

接口：CourseService.java

```java
CourseInfoForm getCourseInfoById(String id);
```

实现：CourseServiceImpl.java

```java
@Override
public CourseInfoForm getCourseInfoById(String id) {
    //从course表中取数据
    Course course = baseMapper.selectById(id);
    if(course == null){
        return null;
    }
    //从course_description表中取数据
    CourseDescription courseDescription = courseDescriptionMapper.selectById(id);
    //创建courseInfoForm对象
    CourseInfoForm courseInfoForm = new CourseInfoForm();
    BeanUtils.copyProperties(course, courseInfoForm);
    courseInfoForm.setDescription(courseDescription.getDescription());
    return courseInfoForm;
}
```

## 12.3 课程回显前端实现 定义**api**

api/course.js

```js

getCourseInfoById(id) {
    return request({
        url: `/admin/edu/course/course-info/${id}`,
        method: 'get'
    })
}
```

## 12..4 组件js

src/views/course/components/Info.vue

```js

fetchCourseInfoById(id) {
  courseApi.getCourseInfoById(id).then(response => {
    this.courseInfo = response.data.item
  })
},
```

页面加载时

```js
created() {
  if (this.$parent.courseId) { // 回显
    this.fetchCourseInfoById(this.$parent.courseId)
  }
  // 获取讲师列表
  this.initTeacherList()
  // 初始化分类列表
  this.initSubjectList()
},
```

**注意：测试的时候检查subject_parent_id和subject_id的数据是否存在（因为在前面的课程类别章节中已经删除了旧的类别，因此原来的课程数据需要重新填入类别信息）**

# 13 二级类别填充问题

默认情况下，当 this.initSubjectList()方法被调用的时候，只会填充一级分类列表，不会填充二级分类列表

因此二级分类列表中没有数据，当页面回填的时候，二级分类列表被回填的是id值，无法找到列表中对应的title显示出来，

因此二级分类列表中只显示一个id的值

解决方案：得到表单回填数据后，根据表单回填数据的subjectParentId，找到对应的二级列表，将次二级列表回填至页面

## 13.1 修改info.vue的created

将 this.initSubjectList() 移至else

```js
created() {
    if (this.$parent.courseId) { // 回显
        this.fetchCourseInfoById(this.$parent.courseId)
    } else { // 新增
        // 初始化分类列表
        this.initSubjectList()
    }
    // 获取讲师列表
    this.initTeacherList()
},
```

## 13.2 修改fetchCourseInfoById

```js
fetchCourseInfoById(id) {
  courseApi.getCourseInfoById(id).then(response => {
    this.courseInfo = response.data.item
    // 初始化分类列表
    // this.initSubjectList()
    subjectApi.getNestedTreeList().then(response => {
      this.subjectList = response.data.items
      // 填充二级菜单：遍历一级菜单列表，
      this.subjectList.forEach(subject => {
        // 找到和courseInfo.subjectParentId一致的父类别记录
        if (subject.id === this.courseInfo.subjectParentId) {
          // 拿到当前类别下的子类别列表，将子类别列表填入二级下拉菜单列表
          this.subjectLevelTwoList = subject.children
        }
      })
    })
  })
},
```

# 14 更新课程信息

## 14.1 后端实现 web层

CourseController.java

```java
@ApiOperation("更新课程")
@PutMapping("update-course-info")
public R updateCourseInfoById(
    @ApiParam(value = "课程基本信息", required = true)
    @RequestBody CourseInfoForm courseInfoForm){
    courseService.updateCourseInfoById(courseInfoForm);
    return R.ok().message("修改成功");
}
```

## 14.2 service层

接口：CourseService.java

```java
void updateCourseInfoById(CourseInfoForm courseInfoForm);
```

实现：CourseServiceImpl.java

```java
@Transactional(rollbackFor = Exception.class)
@Override
public void updateCourseInfoById(CourseInfoForm courseInfoForm) {
    //保存课程基本信息
    Course course = new Course();
    BeanUtils.copyProperties(courseInfoForm, course);
    baseMapper.updateById(course);
    //保存课程详情信息
    CourseDescription courseDescription = new CourseDescription();
    courseDescription.setDescription(courseInfoForm.getDescription());
    courseDescription.setId(course.getId());
    courseDescriptionMapper.updateById(courseDescription);
}
```

## 14.3 前端实现 定义api

src/course.js

```js

updateCourseInfoById(courseInfo) {
    return request({
        url: '/admin/edu/course/update-course-info',
        method: 'put',
        data: courseInfo
    })
}
```



## 14.4 组件js

src/views/course/components/Info.vue创建updateData()方法

```js
// 修改
updateData() {
    courseApi.updateCourseInfoById(this.courseInfo).then(response => {
        this.$message.success(response.message)
        this.$parent.active = 1 // 下一步
    })
}
```

调用updateData

```js

// 保存并下一步
saveAndNext() {
    this.saveBtnDisabled = true
    if (!this.$parent.courseId) {
        this.saveData()
    } else {
        this.updateData()
    }
}
```

