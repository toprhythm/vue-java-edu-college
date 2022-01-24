# part30-个人中心

# 1 嵌套路由

![image-20211116102037041](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211116102037041.png)

## 1.1 **嵌套路由**

创建内嵌子路由，你需要添加一个 Vue 文件，同时添加一个与该文件同名的目录用来存放子视图组件。 

例如，将ucenter.vue文件创建到与ucenter目录的父目录下，即和ucenter目录保持平级。

假设文件结构如：

```shell
pages/
‐‐| ucenter.vue
‐‐| ucenter/
‐‐‐‐‐| index.vue
‐‐‐‐‐| order.vue
‐‐‐‐‐| collect.vue
```

Nuxt.js 自动生成的路由配置如下：

```js
router: { 
    routes: [ 
        { 
            path: '/ucenter',
            component: 'pages/ucenter.vue', 
            children: [ 
                { 
                    path: '', 
                    component: 'pages/ucenter/index.vue', 
                    name: 'ucenter' 
                },
                { 
                    path: 'order', 
                    component: 'pages/ucenter/order.vue', 
                    name: 'ucenter-order' 
                },
                { 
                    path: 'collect', 
                    component: 'pages/ucenter/collect.vue', 
                    name: 'ucenter-collect' 
                }
            ] 
        } 
    ]
}
```

# 2 创建页面

## 2.1 ucenter.vue

pages/ucenter.vue

```html
<template>
  <div>
    <h2>用户中心</h2>
    <ul>
      <!-- 切换子页面 -->
      <li><nuxt-link to="/ucenter">个人信息</nuxt-link></li>
      <li><nuxt-link to="/ucenter/order">我的订单</nuxt-link></li>
      <li><nuxt-link to="/ucenter/collect">我的收藏</nuxt-link></li>
    </ul>
    <!-- 子页面组件的占位符 -->
    <nuxt-child />
  </div>
</template>
<script>
export default {
}
</script>
```

## 2.2 index.vue

pages/ucenter/index.vue

```html
<template>
  <div>
    <h3>个人信息</h3>
  </div>
</template>
<script>
export default {
}
</script>
```

## 2.3 order.vue

pages/ucenter/order.vue

```html
<template>
  <div>
    <h3>我的订单页面</h3>
  </div>
</template>
<script>
export default {
}
</script>
```

## 2.4 collect.vue

pages/ucenter/collect.vue

```html
<template>
  <div>
    <h3>我的收藏页面</h3>
  </div>
</template>
<script>
export default {
}
</script>
```

访问如下地址进行测试：

http://localhost:3000/ucenter

# 3 完善个人中心主页

ucenter.vue

```html
<template>
  <!-- 内容区域 -->
  <div class="bg-fa of">
    <section class="container">
      <div class="u-body mt40">
        <menu class="col-3 fl uMenu">
          <header class="comm-title"><h2 class="fl tac"><span class="c-333">个人中心</span></h2></header>  
          <dl>
            <dd class="u-m-dd">
              <ul>
                <li>
                  <span>Wo的资料</span>
                  <ol>
                    <li>
                      <a href="uc_base.html" title="">
                        基本资料
                      </a>
                    </li>
                    <li>
                      <a href="uc_avatar.html" title="">
                        个人头像
                      </a>
                    </li>
                    <li>
                      <a href="uc_password.html" title="">
                        密码设置
                      </a>
                    </li>
                  </ol>
                </li>
              </ul>
              <ul>
                <li>
                  <span>Wo的学习</span>
                  <ol>
                    <router-link to="/ucenter/order" tag="li" active-class="current" exact>
                      <a>我的订单</a>
                    </router-link>
                    <router-link to="/ucenter/collect" tag="li" active-class="current" exact>
                      <a>我的收藏</a>
                    </router-link>
                  </ol>
                </li>
              </ul>
              <ul>
                <li>
                  <span>Wo的问答</span>
                  <ol>
                    <li>
                      <a href="uc_question.html" title="">
                        Wo的提问
                      </a>
                    </li>
                    <li>
                      <a href="uc_anwser.html" title="">
                        Wo的回答
                      </a>
                    </li>
                  </ol>
                </li>
              </ul>
              <ul>
                <li >
                  <span>Wo的消息</span>
                  <ol>
                    <li>
                      <a href="uc_letter.html" title="">系统消息</a>
                    </li>
                  </ol>
                </li>
              </ul>
            </dd>
          </dl>
        </menu>
        <nuxt-child />
        <div class="clear"/>
      </div>
    </section>
  </div>
  <!-- /内容区域 -->
</template>
<script>
export default {
}
</script>
```



# 4 我的订单

## 4.1 订单列表接口 web层

ApiOrderController

```java
@ApiOperation(value = "获取当前用户订单列表")
@GetMapping("auth/list")
public R list(HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    List<Order> list = orderService.selectByMemberId(jwtInfo.getId());
    return R.ok().data("items", list);
}
```

## 4.2 service层

接口：OrderService

```java
List<Order> selectByMemberId(String memberId);
```

实现：OrderServiceImpl

```java
@Override
public List<Order> selectByMemberId(String memberId) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper.orderByDesc("gmt_create");
    queryWrapper.eq("member_id", memberId);
    return baseMapper.selectList(queryWrapper);
}
```

# 5 **删除订单接口**

## 5.1 web层

ApiOrderController

```java
@ApiOperation(value = "删除订单")
@DeleteMapping("auth/remove/{orderId}")
public R remove(@PathVariable String orderId, HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    boolean result = orderService.removeById(orderId, jwtInfo.getId());
    if (result) {
        return R.ok().message("删除成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 5.2 service层

接口：OrderService

```java
boolean removeById(String orderId, String memberId);
```

实现：OrderServiceImpl

```java
@Override
public boolean removeById(String orderId, String memberId) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper
        .eq("id", orderId)
        .eq("member_id", memberId);
    return this.remove(queryWrapper);
}
```

# 6 **前端**

## 6.1 api

api/order.js

```js
getList() {
  return request({
    baseURL: 'http://localhost:8170',
    url: '/api/trade/order/auth/list',
    method: 'get'
  })
},
removeById(orderId) {
  return request({
    baseURL: 'http://localhost:8170',
    url: `/api/trade/order/auth/remove/${orderId}`,
    method: 'delete'
  })
}
```

## 6.2 个人中心订单列表

```html
<template>
  <article class="col-7 fl">
    <div class="u-r-cont">
      <section>
        <div>
          <section class="c-infor-tabTitle c-tab-title">
            <a href="javascript: void(0)" title="我的订单" class="current">
              订单列表
            </a>
          </section>
        </div>
        <div class="mt40">
          <section v-if="orderList.length === 0" class="no-data-wrap">
            <em class="icon30 no-data-ico">&nbsp;</em>
            <span class="c-666 fsize14 ml10 vam" >您还没有订单哦！</span>
          </section>
          <!-- 表格 -->
          <el-table
            v-if="orderList.length>0"
            :data="orderList"
            border
            fit
            highlight-current-row>
            <el-table-column label="课程信息" align="center" >
              <template slot-scope="scope">
                <div class="info" >
                  <div class="pic">
                    <img :src="scope.row.courseCover" alt="scope.row.courseTitle" width="100px">
                  </div>
                  <div class="title">
                    <a :href="'/course/'+scope.row.courseId">{{ scope.row.courseTitle }}</a>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="讲师名称" width="100" align="center">
              <template slot-scope="scope">
                {{ scope.row.teacherName }}
              </template>
            </el-table-column>
            <el-table-column label="价格" width="100" align="center" >
              <template slot-scope="scope">
                {{ scope.row.totalFee / 100 }}
              </template>
            </el-table-column>
            <el-table-column label="创建时间" width="180" align="center">
              <template slot-scope="scope">
                {{ scope.row.gmtCreate }}
              </template>
            </el-table-column>
            <el-table-column prop="status" label="订单状态" width="100" align="center" >
              <template slot-scope="scope">
                <el-tag :type="scope.row.status === 0 ? 'warning' : 'success'">{{ scope.row.status === 0 ? '未支付' : '已支付' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150" align="center">
              <template slot-scope="scope" >
                <router-link v-if="scope.row.status === 0" :to="'/order/'+scope.row.id">
                  <el-button type="text" size="mini" icon="el-icon-edit">去支付</el-button>
                </router-link>
                <router-link v-if="scope.row.status === 1" :to="'/course/'+scope.row.courseId">
                  <el-button type="text" size="mini" icon="el-icon-edit">去学习</el-button>
                </router-link>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </section>
    </div>
  </article>
</template>
<script>
import orderApi from '~/api/order'
export default {
  data() {
    return {
      orderList: []
    }
  },
  created() {
    this.fetchOrderList()
  },
  methods: {
    fetchOrderList() {
      orderApi.getList().then(response => {
        this.orderList = response.data.items
      })
    }
  }
}
</script>
```

## 6.3 删除订单

html

```html
<i
   class="el-icon-delete"
   style="cursor:pointer"
   title="删除订单"
   @click="removeById(scope.row.id)"/>
```

脚本

```js
// 根据id删除数据
removeById(id) {
    this.$confirm('确认要删除当前订单吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        return orderApi.removeById(id)
    }).then((response) => {
        this.fetchOrderList()
        this.$message({
            type: 'success',
            message: response.message
        })
    }).catch(error => {
        if (error === 'cancel') {
            this.$message({
                message: '取消删除'
            })
        }
    })
}
```



# 7 我的收藏

![image-20211116105601617](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211116105601617.png)

## 7.1 判断是否收藏 web层

ApiCourseCollectController

```java
package com.atguigu.guli.service.edu.controller.api;

@CrossOrigin
@RestController
@RequestMapping("/api/edu/course-collect")
@Slf4j
public class ApiCourseCollectController {
    @Autowired
    private CourseCollectService courseCollectService;
    @ApiOperation(value = "判断是否收藏")
    @GetMapping("auth/is-collect/{courseId}")
    public R isCollect(
            @ApiParam(name = "courseId", value = "课程id", required = true)
            @PathVariable String courseId,
            HttpServletRequest request) {
        JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
        boolean isCollect = courseCollectService.isCollect(courseId, jwtInfo.getId());
        return R.ok().data("isCollect", isCollect);
    }
}
```

## 7.2 service层

接口：CourseCollectService

```java
boolean isCollect(String courseId, String memberId);
```

实现：CourseCollectServiceImpl

```java
/**
     * 判断用户是否收藏
     */
@Override
public boolean isCollect(String courseId, String memberId) {
    QueryWrapper<CourseCollect> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("course_id", courseId).eq("member_id", memberId);
    Integer count = baseMapper.selectCount(queryWrapper);
    return count > 0;
}
```

# 8 收藏课程

## 8.1 web层

ApiCourseCollectController

```java
@ApiOperation(value = "收藏课程")
@PostMapping("auth/save/{courseId}")
public R save(
    @ApiParam(name = "courseId", value = "课程id", required = true)
    @PathVariable String courseId,
    HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    courseCollectService.saveCourseCollect(courseId, jwtInfo.getId());
    return R.ok();
}
```

## 8.2 service层

接口：CourseCollectService

```java
void saveCourseCollect(String courseId, String memberId);
```

实现：**CourseCollectServiceImpl**

```java
@Override
public void saveCourseCollect(String courseId, String memberId) {
    //未收藏则收藏
    if(!this.isCollect(courseId, memberId)) {
        CourseCollect courseCollect = new CourseCollect();
        courseCollect.setCourseId(courseId);
        courseCollect.setMemberId(memberId);
        this.save(courseCollect);
    }
}
```

# 9 获取课程收藏列表

## 9.1 定义vo

```java
package com.atguigu.guli.service.edu.entity.vo;

@Data
public class CourseCollectVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String courseId; //课程id
    private String title;//标题
    private BigDecimal price;//价格
    private Integer lessonNum;//课时数
    private String cover;//封面
    private String gmtCreate;//收藏时间
    private String teacherName;//讲师
}
```

## 9.2 web层

ApiCourseCollectController

```java
@ApiOperation(value = "获取课程收藏列表")
@GetMapping("auth/list")
public R collectList(HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    List<CourseCollectVo> list = courseCollectService.selectListByMemberId(jwtInfo.getId());
    return R.ok().data("items", list);
}
```

## 9.3 service层

接口：CourseCollectService

```java
List<CourseCollectVo> selectListByMemberId(String memberId);
```

实现：CourseCollectServiceImpl

```java
@Override
public List<CourseCollectVo> selectListByMemberId(String memberId) {
    return baseMapper.selectPageByMemberId(memberId);
}
```

## 9.4 mapper层

接口：CourseCollectMapper

```java
List<CourseCollectVo> selectPageByMemberId(String memberId);
```

实现：CourseCollectMapper.xml

```xml
<select id="selectPageByMemberId" resultType="com.atguigu.guli.service.edu.entity.vo.CourseCollectVo">
    select
    cl.id,
    cl.gmt_create as gmtCreate,
    c.id as courseId,
    c.title,
    c.cover,
    CONVERT(c.price, DECIMAL(8,2)) AS price,
    c.lesson_num as lessonNum,
    t.name as teacherName
    from edu_course_collect cl
    left join edu_course c on c.id = cl.course_id
    left join edu_teacher t on t.id = c.teacher_id
    where member_id = #{memberId}
    order by cl.gmt_create desc
</select>
```

# 10 取消收藏

## 10.1 web层

ApiCourseCollectController

```java
@ApiOperation(value = "取消收藏课程")
@DeleteMapping("auth/remove/{courseId}")
public R remove(
    @ApiParam(name = "courseId", value = "课程id", required = true)
    @PathVariable String courseId,
    HttpServletRequest request) {
    JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
    boolean result = courseCollectService.removeCourseCollect(courseId, jwtInfo.getId());
    if (result) {
        return R.ok().message("已取消");
    } else {
        return R.error().message("取消失败");
    }
}
```

## 10.2 service层

接口：CourseCollectService

```java
boolean removeCourseCollect(String courseId, String memberId);
```

实现：CourseCollectServiceImpl

```java
@Override
public boolean removeCourseCollect(String courseId, String memberId) {
    //已收藏则删除
    if(this.isCollect(courseId, memberId)) {
        QueryWrapper<CourseCollect> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("course_id", courseId).eq("member_id", memberId);
        return this.remove(queryWrapper);
    }
    return false;
}
```





# 11 我的收藏前端

## 11.1 **api**

api/collect.js

```js
import request from '@/utils/request'
export default {
  isCollect(courseId) {
    return request({
      url: `/api/edu/course-collect/auth/is-collect/${courseId}`,
      method: 'get'
    })
  },
  addCollect(courseId) {
    return request({
      url: `/api/edu/course-collect/auth/save/${courseId}`,
      method: 'post'
    })
  },
  getCollectList() {
    return request({
      url: '/api/edu/course-collect/auth/list',
      method: 'get'
    })
  },
  removeById(courseId) {
    return request({
      url: `/api/edu/course-collect/auth/remove/${courseId}`,
      method: 'delete'
    })
  }
}
```

# 12 **课程页面**

## 12.1 html

pages/course/_id.vue

```html
<section class="c-attr-mt of">
    <span v-if="isCollect" class="ml10 vam sc-end">
        <em class="icon18 scIcon"/>
        <a
           style="cursor:pointer"
           class="c-fff vam"
           title="取消收藏"
           @click="removeCollect(course.id)">已收藏</a>
    </span>
    <span v-else class="ml10 vam">
        <em class="icon18 scIcon"/>
        <span
           style="cursor:pointer"
           class="c-fff vam"
           title="收藏"
           @click="addCollect(course.id)" >收藏</span>
    </span>
</section>
```

## 12.2 判断是否收藏

引入api

```java
import collectApi from '~/api/collect'
```

data中定义

```java
isCollect: false // 是否已收藏
```

created中判断是否收藏

```java
created() {
    ......
    if (token) {
        //判断是否购买
        ......
        //判断是否收藏
        collectApi.isCollect(this.course.id).then(response => {
            this.isCollect = response.data.isCollect
        })
    }
},
```

## 12.3 定义收藏方法

```js
//收藏
addCollect(courseId) {
  collectApi.addCollect(this.course.id).then(response => {
    this.isCollect = true
    this.$message.success(response.message)
  })
},
//取消收藏
removeCollect(courseId) {
  collectApi.removeById(this.course.id).then(response => {
    this.isCollect = false
    this.$message.success(response.message)
  })
}
```

# 13 我的收藏页面

pages/collect.vue

```html
<template>
  <article class="col-7 fl">
    <div class="u-r-cont">
      <section>
        <div>
          <section class="c-infor-tabTitle c-tab-title">
            <a href="javascript: void(0)" title="我的收藏" class="current">
              收藏列表
            </a>
          </section>
        </div>
        <div class="mt40">
          <section v-if="collectList.length === 0" class="no-data-wrap">
            <em class="icon30 no-data-ico">&nbsp;</em>
            <span class="c-666 fsize14 ml10 vam">您还没有收藏课程哦！</span>
          </section>
          <!-- 表格 -->
          <el-table
            v-if="collectList.length > 0"
            :data="collectList"
            border
            fit
            highlight-current-row>
            <el-table-column label="课程信息" align="center" >
              <template slot-scope="scope">
                <div class="info" >
                  <div class="pic">
                    <img :src="scope.row.cover" alt="scope.row.title" width="100px">
                  </div>
                  <div class="title">
                    <a :href="'/course/'+scope.row.courseId">{{ scope.row.title }}</a>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="讲师名称" align="center">
              <template slot-scope="scope">
                {{ scope.row.teacherName }}
              </template>
            </el-table-column>
            <el-table-column label="价格" width="100" align="center">
              <template slot-scope="scope">
                {{ scope.row.price }}
              </template>
            </el-table-column>
            <el-table-column label="收藏时间" align="center">
              <template slot-scope="scope">
                {{ scope.row.gmtCreate }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150" align="center">
              <template slot-scope="scope">
                <a href="javascript:void(0);" title="取消收藏" @click="removeCollect(scope.row.courseId)">取消收藏</a>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </section>
    </div>
  </article>
</template>
<script>
import collectApi from '~/api/collect'
export default {
  data() {
    return {
      collectList: []
    }
  },
  created() {
    this.fetchCollectList()
  },
  methods: {
    fetchCollectList() {
      collectApi.getCollectList().then(response => {
        this.collectList = response.data.items
      })
    },
    removeCollect(courseId) {
      collectApi.removeById(courseId).then(response => {
        this.$message.success(response.message)
        this.fetchCollectList()// 刷新列表
      })
    }
  }
}
</script>
```

