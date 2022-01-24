# part07-讲师管理开发



# 1 api模块的定义

## 1.1 项目开发流程

![image-20211019075343789](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211019075343789.png)

## 1.2 定义路由模块	

src/router/index.js

配置讲师管理相关路由



## 1.3 定义api模块

创建文件 src/api/teacher.js

```js
// 引入封装了axios的request模块
import request from '@/utils/request'

// 导出teacher模块
export default {

  // 讲师列表的api接口请求方法
  list() {
    return request({
      url: '/admin/edu/teacher/list',
      method: 'get'
    })
  }

}

```



## 1.4 **定义页面组件脚本**

list.vue

```js
<script>

// 导入teacher.js模块
import teacherApi from '@/api/teacher'

export default {

  data() {
    return {
      // 定义讲师列表数据模型
      list: []
    }
  },

  created() {
    // 页面一加载执行list的api调用
    this.fetchData()
  },

  methods: {
    // 定义加载讲师列表的方法
    async fetchData() {
      // 调用teacher模块的list方法, 把data重命名为res
      const res = await teacherApi.list()
      // console.log(res.data.items)
      this.list = res.data.items
    }
  }

}
</script>
```



## 1.5 **定义页面组件模板**

```vue
<!-- 表格 -->
<el-table :data="list" border stripe>
    <el-table-column type="index" width="50"/>
    <el-table-column prop="name" label="名称" width="80" />
    <el-table-column label="头衔" width="90">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.level === 1" type="success" size="mini">高级讲师</el-tag>
          <el-tag v-if="scope.row.level === 2" size="mini">首席讲师</el-tag>
        </template>
    </el-table-column>
    <el-table-column prop="intro" label="简介" />
    <el-table-column prop="sort" label="排序" width="60" />
    <el-table-column prop="joinDate" label="入驻时间" width="160" />
</el-table>

```



## 1.6 list效果

![image-20211019083137946](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211019083137946.png)



# 2 项目流程

## 2.1 页面加载流程

![image-20211019083232897](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211019083232897.png)



## 2.2 **页面渲染流程**

![image-20211019083253620](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211019083253620.png)



# 3 分页查询

## 3.1 定义api模块

src/api/teacher.js

```js
pageList(page, limit, searchObj) {
    return request({
        url: `/admin/edu/teacher/list/${page}/${limit}`,
        method: 'get',
        params: searchObj
    })
}
```

## 3.2 定义页面组件脚本

src/views/teacher/list.vue，完善data定义

```js
data() {// 定义数据
    return {
        list: null, // 数据列表
        total: 0, // 总记录数
        page: 1, // 页码
        limit: 10, // 每页记录数
        searchObj: {}// 查询条件
    }
}
```

修改fetchData方法

```js
fetchData() {
    // 调用api
    teacherApi.pageList(this.page, this.limit, this.searchObj).then(response => {
        this.list = response.data.rows
        this.total = response.data.total
    })
}
```

## 3.3 定义页面组件模板

在table组件下面添加分页组件

```html
<!-- 分页组件 -->
<el-pagination
  :current-page="page"
  :total="total"
  :page-size="limit"
  :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
  style="padding: 30px 0; text-align: center;"
  layout="total, sizes, prev, pager, next, jumper"
/>

```

## 3.4 **改变每页条数**

为<el-pagination>组件注册事件

```js
@size-change="changePageSize"
```

定义事件脚本

```js

// 每页记录数改变，size：回调参数，表示当前选中的“每页条数”
changePageSize(size) {
    this.limit = size
    this.fetchData()
}
```

## 3.5 翻页

为<el-pagination>组件注册事件

```js
@current-change="changeCurrentPage"
```

定义事件脚本

```js
// 改变页码，page：回调参数，表示当前选中的“页码”
changeCurrentPage(page) {
    this.page = page
    this.fetchData()
},
```

## 3.6 序号列

```html
<el-table-column
  label="#"
  width="50">
  <template slot-scope="scope">
    {{ (page - 1) * limit + scope.$index + 1 }}
  </template>
</el-table-column>
```

## 3.7 查询表单

在table组件上面添加查询表单

```vue
<!--查询表单-->
<el-form :inline="true">
    <el-form-item>
        <el-input v-model="searchObj.name" placeholder="讲师"/>
    </el-form-item>
    <el-form-item>
        <el-select v-model="searchObj.level" clearable placeholder="头衔">
            <el-option value="1" label="高级讲师"/>
            <el-option value="2" label="首席讲师"/>
        </el-select>
    </el-form-item>
    <el-form-item label="入驻时间">
        <el-date-picker
                        v-model="searchObj.joinDateBegin"
                        placeholder="开始时间"
                        value-format="yyyy-MM-dd" />
    </el-form-item>
    <el-form-item label="-">
        <el-date-picker
                        v-model="searchObj.joinDateEnd"
                        placeholder="结束时间"
                        value-format="yyyy-MM-dd" />
    </el-form-item>
    <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="fetchData()">查询</el-button>
        <el-button type="default" @click="resetData()">清空</el-button>
    </el-form-item>
</el-form>
```

重置表单脚本

```js
// 重置表单
resetData() {
    this.searchObj = {}
    this.fetchData()
}
```



# 4 数据删除

## 4.1 定义api模块

src/api/teacher.js

```js
removeById(id) {
    return request({
        url: `/admin/edu/teacher/remove/${id}`,
        method: 'delete'
    })
}
```

## 4.2 定义页面组件模板

在table组件中添加删除列

```vue
<el-table-column label="操作" width="200" align="center">
    <template slot-scope="scope">
        <el-button type="danger" size="mini" icon="el-icon-delete" @click="removeById(scope.row.id)">删除</el-button>
    </template>
</el-table-column>
```

## 4.3 定义页面组件脚本

```js
// 根据id删除数据
removeById(id) {
    this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        return teacherApi.removeById(id)
    }).then((response) => {
        this.fetchData()
        this.$message.success(response.message)
    }).catch(error => {
        console.log('error', error)
        // 当取消时会进入catch语句:error = 'cancel'
        // 当后端服务抛出异常时：error = 'error'
        if (error === 'cancel') {
            this.$message.info('取消删除')
        }
    })
}
```



# 5 axios拦截响应器

## 5.1 关于code===20000

code!==20000的响应会被拦截，并转到 error=>{} 处理

```js
if (res.code !== 20000) {
    return Promise.reject('error')
}
```

## 5.2 关于**response**

code===20000时放行，前端页面接收到response.data的值，而不是response

```js
if (res.code !== 20000) {
    return Promise.reject('error')
} else {
    return response.data
}
```

## 5.3 关于error

统一处理错误结果，显示错误消息



# 6 新增讲师

## 6.1 定义api模块

src/api/teacher.js

```js
save(teacher) {
    return request({
        url: '/admin/edu/teacher/save',
        method: 'post',
        data: teacher
    })
}
```

## 6.2 定义页面组件脚本

```vue

<script>
export default {
  data() {
    return {
      // 初始化讲师默认数据
      teacher: {
        sort: 0,
        level: 1
      },
      saveBtnDisabled: false // 保存按钮是否禁用，防止表单重复提交
    }
  }
}
</script>
```

## 6.3 **定义页面组件模板**

src/views/teacher/form.vue

```vue
<!-- 输入表单 -->
<el-form label-width="120px">
    <el-form-item label="讲师名称">
        <el-input v-model="teacher.name" />
    </el-form-item>
    <el-form-item label="入驻时间">
        <el-date-picker v-model="teacher.joinDate" value-format="yyyy-MM-dd" />
    </el-form-item>
    <el-form-item label="讲师排序">
        <el-input-number v-model="teacher.sort" :min="0"/>
    </el-form-item>
    <el-form-item label="讲师头衔">
        <el-select v-model="teacher.level">
            <!--
            数据类型一定要和取出的json中的一致，否则没法回填
            因此，这里value使用动态绑定的值，保证其数据类型是number
            -->
            <el-option :value="1" label="高级讲师"/>
            <el-option :value="2" label="首席讲师"/>
        </el-select>
    </el-form-item>
    <el-form-item label="讲师简介">
        <el-input v-model="teacher.intro"/>
    </el-form-item>
    <el-form-item label="讲师资历">
       <el-input v-model="teacher.career" :rows="10" type="textarea"/>
    </el-form-item>
    <!-- 讲师头像：TODO -->
    <el-form-item>
        <el-button :disabled="saveBtnDisabled" type="primary" @click="saveOrUpdate()">保存</el-button>
    </el-form-item>
</el-form>
```

## 6.4 实现新增功能

src/views/teacher/form.vue，引入teacher api模块：

```js
import teacherApi from '@/api/teacher'
```

定义保存方法

```js
methods: {
  saveOrUpdate() {
    // 禁用保存按钮
    this.saveBtnDisabled = true
    this.saveData()
  },
  // 新增讲师
  saveData() {
    // debugger
    teacherApi.save(this.teacher).then(response => {
      this.$message({
        type: 'success',
        message: response.message
      })
      this.$router.push({ path: '/teacher' })
    })
  }
}
```

## 6.5 测试保存功能



# 7 数据回显

点击编辑按钮，进入添加讲师页面，数据回显

## 7.1 显示讲师信息

定义api模块

 src/api/teacher.js

```js

getById(id) {
    return request({
        url: `/admin/edu/teacher/get/${id}`,
        method: 'get'
    })
}
```

## 7.2 定义页面组件脚本

src/views/teacher/form.vue，methods中定义回显方法

```js

// 根据id查询记录
fetchDataById(id) {
    teacherApi.getById(id).then(response => {
        this.teacher = response.data.item
    })
}
```

页面渲染成功后获取数据

因为已在路由中定义如下内容：path: 'edit/:id'，因此可以使用 this.$route.params.id 获取路由中的id

```js
//页面渲染成功
created() {
    if (this.$route.params.id) {
        this.fetchDataById(this.$route.params.id)
    }
}
```

## 7.3 定义页面组件模板

src/views/teacher/list.vue，表格“操作”列中增加“修改”按钮

```html
<router-link :to="'/teacher/edit/'+scope.row.id">
    <el-button type="primary" size="mini" icon="el-icon-edit">修改</el-button>
</router-link>
```



# 8 更新讲师

## 8.1 定义api模块

 src/api/teacher.js

```js
updateById(teacher) {
    return request({
        url: '/admin/edu/teacher/update',
        method: 'put',
        data: teacher
    })
}
```

## 8.2 定义页面组件脚本

src/views/teacher/form.vue，methods中定义updateData

```js
// 根据id更新记录
updateData() {
  // teacher数据的获取
  teacherApi.updateById(this.teacher).then(response => {
      this.$message({
        type: 'success',
        message: response.message
      })
      this.$router.push({ path: '/teacher' })
  })
},
```

完善saveOrUpdate方法

```js
saveOrUpdate() {
    // 禁用保存按钮
    this.saveBtnDisabled = true
    if (!this.teacher.id) {
        this.saveData()
    } else {
        this.updateData()
    }
}
```

## 8.3 组件重用问题

**问题：**vue-router导航切换 时，如果两个路由都渲染同个组件，

组件的生命周期方法（created或者mounted）不会再被调用, 组件会被重用，显示上一个路由渲染出来的自建

**解决方案：**可以简单的在 router-view上加上一个唯一的key，来保证路由切换时都会重新触发生命周期方法，确保组件被重新初始化。

修改 src/views/layout/components/AppMain.vue 文件如下：

```html
<router-view :key="key"></router-view>
```

```js
computed: {
    key() {
        return this.$route.name !== undefined? this.$route.name + +new Date(): this.$route + +new Date()
 }
```

