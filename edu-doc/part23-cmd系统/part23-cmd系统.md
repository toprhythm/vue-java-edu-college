# part23-cmd系统

# 1 数据库设计 

## 1.1 数据库

创建数据库：guli_cms

创建数据库：db_yunzoukj_cms

Utf8mb4 utfbmb4_general_ci

```sql
create database db_yunzoukj_cms CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```



## 1.2 **数据表**

执行sql脚本 "guli_cms.sql"

# 2 创建内容管理微服务

## 2.1 创建模块

Artifact：service_cms

## 2.2 配置pom.xml

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

## 2.3 配置application.yml

```yaml
server:
  port: 8140 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-cms # 服务名
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
    url: jdbc:mysql://216.127.184.152:3306/db_yunzoukj_cms?serverTimezone=GMT%2B8
    username: root
    password: Zwq2573424062@qq.com
  #spring:
  jackson: #返回json的全局时间格式
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #mybatis日志
  mapper-locations: classpath:com/yunzoukj/yunzou/service/cms/mapper/xml/*.xml
ribbon:
  ConnectTimeout: 10000 #连接建立的超时时长，默认1秒
  ReadTimeout: 10000 #处理请求的超时时间，默认为1秒
feign:
  sentinel:
    enabled: true
```



## 2.4 logback-spring.xml

修改日志路径为 guli_log/cms



## 2.5 创建启动类

创建ServiceCmsApplication.java

```java
package com.yunzoukj.yunzou.service.cms;

@SpringBootApplication
@ComponentScan({"com.atguigu.guli"})
@EnableDiscoveryClient
@EnableFeignClients
public class ServiceCmsApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceCmsApplication.class, args);
    }
}

```

## 2.6 代码生成器

创建代码生成器并执行



# 3 后台管理AdType

## 3.1 controller

AdTypeController.java

```java
package com.atguigu.guli.service.cms.controller.admin;

@CrossOrigin //解决跨域问题
@Api(description = "推荐位管理")
@RestController
@RequestMapping("/admin/cms/ad-type")
@Slf4j
public class AdTypeController {
    @Autowired
    private AdTypeService adTypeService;
    @ApiOperation("所有推荐类别列表")
    @GetMapping("list")
    public R listAll() {
        List<AdType> list = adTypeService.list();
        return R.ok().data("items", list);
    }
    @ApiOperation("推荐类别分页列表")
    @GetMapping("list/{page}/{limit}")
    public R listPage(@ApiParam(value = "当前页码", required = true) @PathVariable Long page,
                      @ApiParam(value = "每页记录数", required = true) @PathVariable Long limit) {
        Page<AdType> pageParam = new Page<>(page, limit);
        IPage<AdType> pageModel = adTypeService.page(pageParam);
        List<AdType> records = pageModel.getRecords();
        long total = pageModel.getTotal();
        return R.ok().data("total", total).data("rows", records);
    }
    @ApiOperation(value = "根据ID删除推荐类别")
    @DeleteMapping("remove/{id}")
    public R removeById(@ApiParam(value = "推荐类别ID", required = true) @PathVariable String id) {
        boolean result = adTypeService.removeById(id);
        if (result) {
            return R.ok().message("删除成功");
        } else {
            return R.error().message("数据不存在");
        }
    }
    @ApiOperation("新增推荐类别")
    @PostMapping("save")
    public R save(@ApiParam(value = "推荐类别对象", required = true) @RequestBody AdType adType) {
        boolean result = adTypeService.save(adType);
        if (result) {
            return R.ok().message("保存成功");
        } else {
            return R.error().message("保存失败");
        }
    }
    @ApiOperation("更新推荐类别")
    @PutMapping("update")
    public R updateById(@ApiParam(value = "讲师推荐类别", required = true) @RequestBody AdType adType) {
        boolean result = adTypeService.updateById(adType);
        if (result) {
            return R.ok().message("修改成功");
        } else {
            return R.error().message("数据不存在");
        }
    }
    @ApiOperation("根据id获取推荐类别信息")
    @GetMapping("get/{id}")
    public R getById(@ApiParam(value = "推荐类别ID", required = true) @PathVariable String id) {
        AdType adType = adTypeService.getById(id);
        if (adType != null) {
            return R.ok().data("item", adType);
        } else {
            return R.error().message("数据不存在");
        }
    }
}
```



# 4 后台管理Ad

## 4.1 vo

AdVo.java

```java
package com.atguigu.guli.service.cms.entity.vo;

@Data
public class AdVo implements Serializable {
    private static final long serialVersionUID=1L;
    private String id;
    private String title;
    private Integer sort;
    private String type;
}

```

## 4.2 controller

AdController.java

```java
package com.atguigu.guli.service.cms.controller.admin;

@CrossOrigin //解决跨域问题
@Api(description = "广告推荐管理")
@RestController
@RequestMapping("/admin/cms/ad")
@Slf4j
public class AdController {
  
    @Autowired
    private AdService adService;
  
    @ApiOperation("新增推荐")
    @PostMapping("save")
    public R save(@ApiParam(value = "推荐对象", required = true) @RequestBody Ad ad) {
        boolean result = adService.save(ad);
        if (result) {
            return R.ok().message("保存成功");
        } else {
            return R.error().message("保存失败");
        }
    }
    @ApiOperation("更新推荐")
    @PutMapping("update")
    public R updateById(@ApiParam(value = "讲师推荐", required = true) @RequestBody Ad ad) {
        boolean result = adService.updateById(ad);
        if (result) {
            return R.ok().message("修改成功");
        } else {
            return R.error().message("数据不存在");
        }
    }
    @ApiOperation("根据id获取推荐信息")
    @GetMapping("get/{id}")
    public R getById(@ApiParam(value = "推荐ID", required = true) @PathVariable String id) {
        Ad ad = adService.getById(id);
        if (ad != null) {
            return R.ok().data("item", ad);
        } else {
            return R.error().message("数据不存在");
        }
    }
    @ApiOperation("推荐分页列表")
    @GetMapping("list/{page}/{limit}")
    public R listPage(@ApiParam(value = "当前页码", required = true) @PathVariable Long page,
                      @ApiParam(value = "每页记录数", required = true) @PathVariable Long limit) {
        IPage<AdVo> pageModel = adService.selectPage(page, limit);
        List<AdVo> records = pageModel.getRecords();
        long total = pageModel.getTotal();
        return R.ok().data("total", total).data("rows", records);
    }
    @ApiOperation(value = "根据ID删除推荐")
    @DeleteMapping("remove/{id}")
    public R removeById(@ApiParam(value = "推荐ID", required = true) @PathVariable String id) {
        //删除图片
        adService.removeAdImageById(id);
        //删除推荐
        boolean result = adService.removeById(id);
        if (result) {
            return R.ok().message("删除成功");
        } else {
            return R.error().message("数据不存在");
        }
    }
}
```

## 4.3 service

AdService.java

```java
package com.atguigu.guli.service.cms.service;

public interface AdService extends IService<Ad> {
    IPage<AdVo> selectPage(Long page, Long limit);
    boolean removeAdImageById(String id);
}
```

AdServiceImpl.java

```java
package com.atguigu.guli.service.cms.service.impl;

@Service
public class AdServiceImpl extends ServiceImpl<AdMapper, Ad> implements AdService {
    @Autowired
    private OssFileService ossFileService;
    @Override
    public IPage<AdVo> selectPage(Long page, Long limit) {
        QueryWrapper<AdVo> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("a.type_id", "a.sort");
        Page<AdVo> pageParam = new Page<>(page, limit);
        List<AdVo> records = baseMapper.selectPageByQueryWrapper(pageParam, queryWrapper);
        pageParam.setRecords(records);
        return pageParam;
    }
    @Override
    public boolean removeAdImageById(String id) {
        Ad ad = baseMapper.selectById(id);
        if(ad != null) {
            String imagesUrl = ad.getImageUrl();
            if(!StringUtils.isEmpty(imagesUrl)){
                //删除图片
                R r = ossFileService.removeFile(imagesUrl);
                return r.getSuccess();
            }
        }
        return false;
    }
}
```

## 4.4 mapper

AdMapper.java

```java
package com.atguigu.guli.service.cms.mapper;

public interface AdMapper extends BaseMapper<Ad> {
    List<AdVo> selectPageByQueryWrapper(
            Page<AdVo> pageParam,
            @Param(Constants.WRAPPER) QueryWrapper<AdVo> queryWrapper);
}
```

AdMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.atguigu.guli.service.cms.mapper.AdMapper">
    <select id="selectPageByQueryWrapper" resultType="com.atguigu.guli.service.cms.entity.vo.AdVo">
        SELECT
          a.id,
          a.title,
          a.sort,
          t.title AS type
        FROM cms_ad a
        LEFT JOIN cms_ad_type t ON a.type_id = t.id
        ${ew.customSqlSegment}
    </select>
</mapper>
```

## 4.5 feign

OssFileService.java

```java
package com.atguigu.guli.service.cms.feign;

@Service
@FeignClient(value = "service-oss", fallback = OssFileServiceFallBack.class)
public interface OssFileService {
    @DeleteMapping("/admin/oss/file/remove")
    R removeFile(@RequestBody String url);
}
```

OssFileServiceFallBack.java

```java
package com.atguigu.guli.service.cms.feign.fallback;

@Service
@Slf4j
public class OssFileServiceFallBack implements OssFileService {
    @Override
    public R removeFile(String url) {
        log.info("熔断保护");
        return R.error().message("调用超时");
    }
}
```



# 5 cms前端 创建相关文件

## 5.1 api

src/api

![image-20211112111518581](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211112111518581.png)

## 5.2 页面组件

src/views

![image-20211112111539353](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211112111539353.png)

## 5.3 路由配置

src/router/index.js

```js
// 内容管理
{
    path: '/ad',
    component: Layout,
    redirect: '/ad/list',
    name: 'Ad',
    meta: { title: '内容管理' },
    children: [
      {
        path: 'list',
        name: 'AdList',
        component: () => import('@/views/ad/list'),
        meta: { title: '广告推荐' }
      },
      {
        path: 'create',
        name: 'AdCreate',
        component: () => import('@/views/ad/form'),
        meta: { title: '添加广告推荐' },
        hidden: true
      },
      {
        path: 'edit/:id',
        name: 'AdEdit',
        component: () => import('@/views/ad/form'),
        meta: { title: '编辑广告推荐' },
        hidden: true
      },
      {
        path: 'type-list',
        name: 'AdTypeList',
        component: () => import('@/views/adType/list'),
        meta: { title: '推荐位' }
      },
      {
        path: 'type-create',
        name: 'AdTypeCreate',
        component: () => import('@/views/adType/form'),
        meta: { title: '添加推荐位' },
        hidden: true
      },
      {
        path: 'type-edit/:id',
        name: 'AdTypeEdit',
        component: () => import('@/views/adType/form'),
        meta: { title: '编辑推荐位' },
        hidden: true
      }
    ]
},
```

# 6 AdType模块

## 6.1 api/AdType.js

```js
import request from '@/utils/request'
export default {
  list() {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: '/admin/cms/ad-type/list',
      method: 'get'
    })
  },
  pageList(page, limit) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad-type/list/${page}/${limit}`,
      method: 'get'
    })
  },
  removeById(id) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad-type/remove/${id}`,
      method: 'delete'
    })
  },
  save(adType) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: '/admin/cms/ad-type/save',
      method: 'post',
      data: adType
    })
  },
  getById(id) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad-type/get/${id}`,
      method: 'get'
    })
  },
  updateById(adType) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: '/admin/cms/ad-type/update',
      method: 'put',
      data: adType
    })
  }
}
```

## 6.2 views/AdType/list.vue

```html
<template>
  <div class="app-container">
    <!-- 工具按钮 -->
    <div style="margin-bottom: 10px">
      <router-link to="/ad/type-create">
        <el-button type="primary" size="mini" icon="el-icon-edit">添加推荐位</el-button>
      </router-link>
    </div>
    <!-- 表格 -->
    <el-table :data="list" border stripe>
      <el-table-column
        label="#"
        width="50">
        <template slot-scope="scope">
          {{ (page - 1) * limit + scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="title" label="推荐位名称" />
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <router-link :to="'/ad/type-edit/'+scope.row.id">
            <el-button type="primary" size="mini" icon="el-icon-edit">修改</el-button>
          </router-link>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="removeById(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
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
  </div>
</template>
<script>
import adTypeApi from '@/api/adType'
export default {
  // 定义数据模型
  data() {
    return {
      list: [], // 列表
      total: 0, // 总记录数
      page: 1, // 页码
      limit: 10 // 每页记录数
    }
  },
  // 页面渲染成功后获取数据
  created() {
    this.fetchData()
  },
  // 定义方法
  methods: {
    fetchData() {
      // 调用api
      adTypeApi.pageList(this.page, this.limit).then(response => {
        this.list = response.data.rows
        this.total = response.data.total
      })
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
    // 根据id删除数据
    removeById(id) {
      this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        return adTypeApi.removeById(id)
      }).then((response) => {
        this.fetchData()
        this.$message.success(response.message)
      }).catch(error => {
        // 当取消时会进入catch语句:error = 'cancel'
        // 当后端服务抛出异常时：error = 'error'
        if (error === 'cancel') {
          this.$message.info('取消删除')
        }
      })
    }
  }
}
</script>
```

## 6.3 views/AdType/form.vue

```html
<template>
  <div class="app-container">
    <!-- 输入表单 -->
    <el-form label-width="120px">
      <el-form-item label="推荐位名称">
        <el-input v-model="adType.title" />
      </el-form-item>
      <el-form-item>
        <el-button :disabled="saveBtnDisabled" type="primary" @click="saveOrUpdate()">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
import adTypeApi from '@/api/adType'
export default {
  data() {
    return {
      adType: {},
      saveBtnDisabled: false // 保存按钮是否禁用，防止表单重复提交
    }
  },
  // 页面渲染成功
  created() {
    if (this.$route.params.id) {
      this.fetchDataById(this.$route.params.id)
    }
  },
  methods: {
    saveOrUpdate() {
      // 禁用保存按钮
      this.saveBtnDisabled = true
      if (!this.adType.id) {
        this.saveData()
      } else {
        this.updateData()
      }
    },
    // 新增
    saveData() {
      // debugger
      adTypeApi.save(this.adType).then(response => {
        this.$message.success(response.message)
        this.$router.push({ path: '/ad/type-list' })
      })
    },
    // 根据id更新记录
    updateData() {
      // teacher数据的获取
      adTypeApi.updateById(this.adType).then(response => {
        this.$message.success(response.message)
        this.$router.push({ path: '/ad/type-list' })
      })
    },
    // 根据id查询记录
    fetchDataById(id) {
      adTypeApi.getById(id).then(response => {
        this.adType = response.data.item
      })
    }
  }
}
</script>
```

# 7 Ad模块

## 7.1 api/Ad.js

```js
// @ 符号在build/webpack.base.conf.js 中配置 表示 'src' 路径
import request from '@/utils/request'

export default {
  pageList(page, limit) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad/list/${page}/${limit}`,
      method: 'get'
    })
  },
  removeById(id) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad/remove/${id}`,
      method: 'delete'
    })
  },
  save(ad) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: '/admin/cms/ad/save',
      method: 'post',
      data: ad
    })
  },
  getById(id) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: `/admin/cms/ad/get/${id}`,
      method: 'get'
    })
  },
  updateById(ad) {
    return request({
      baseURL: 'http://127.0.0.1:8140',
      url: '/admin/cms/ad/update',
      method: 'put',
      data: ad
    })
  }
}
```

## 7.2 views/Ad/list.vue

```html
<template>
  <div class="app-container">
    <!-- 工具按钮 -->
    <div style="margin-bottom: 10px">
      <router-link to="/ad/create">
        <el-button type="primary" size="mini" icon="el-icon-edit">添加广告推荐</el-button>
      </router-link>
    </div>
    <!-- 表格 -->
    <el-table :data="list" border stripe>
      <el-table-column
        label="#"
        width="50">
        <template slot-scope="scope">
          {{ (page - 1) * limit + scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="type" label="推荐位名称" />
      <el-table-column prop="title" label="广告名称" />
      <el-table-column prop="sort" label="排序" />
      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <router-link :to="'/ad/edit/'+scope.row.id">
            <el-button type="primary" size="mini" icon="el-icon-edit">修改</el-button>
          </router-link>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="removeById(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
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
  </div>
</template>
<script>
import adApi from '@/api/ad'
export default {
  // 定义数据模型
  data() {
    return {
      list: [], // 列表
      total: 0, // 总记录数
      page: 1, // 页码
      limit: 10 // 每页记录数
    }
  },
  // 页面渲染成功后获取数据
  created() {
    this.fetchData()
  },
  // 定义方法
  methods: {
    fetchData() {
      // 调用api
      adApi.pageList(this.page, this.limit).then(response => {
        this.list = response.data.rows
        this.total = response.data.total
      })
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
    // 根据id删除数据
    removeById(id) {
      this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        return adApi.removeById(id)
      }).then((response) => {
        this.fetchData()
        this.$message.success(response.message)
      }).catch(error => {
        // 当取消时会进入catch语句:error = 'cancel'
        // 当后端服务抛出异常时：error = 'error'
        if (error === 'cancel') {
          this.$message.info('取消删除')
        }
      })
    }
  }
}
</script>
```

## 7.3 views/Ad/form.vue

```html
<template>
  <div class="app-container">
    <!-- 输入表单 -->
    <el-form label-width="120px">
      <el-form-item label="广告推荐名称">
        <el-input v-model="ad.title" />
      </el-form-item>
      <!-- 推荐位 -->
      <el-form-item label="推荐位">
        <el-select
          v-model="ad.typeId"
          placeholder="请选择">
          <el-option
            v-for="adType in adTypeList"
            :key="adType.id"
            :label="adType.title"
            :value="adType.id"/>
        </el-select>
      </el-form-item>
      <el-form-item label="排序">
        <el-input-number v-model="ad.sort" :min="0"/>
      </el-form-item>
      <el-form-item label="广告图片">
        <el-upload
          :on-success="handleAvatarSuccess"
          :on-error="handleAvatarError"
          :on-exceed="handleUploadExceed"
          :before-upload="beforeAvatarUpload"
          :limit="1"
          :file-list="fileList"
          action="http://localhost:8120/admin/oss/file/upload?module=ad"
          list-type="picture">
          <el-button size="small" type="primary">点击上传</el-button>
        </el-upload>
      </el-form-item>
      <el-form-item label="背景颜色">
        <el-color-picker v-model="ad.color"/>
      </el-form-item>
      <el-form-item label="链接地址">
        <el-input v-model="ad.linkUrl" />
      </el-form-item>
      <el-form-item>
        <el-button :disabled="saveBtnDisabled" type="primary" @click="saveOrUpdate()">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
import adApi from '@/api/ad'
import adTypeApi from '@/api/adType'
export default {
  data() {
    return {
      ad: {
        sort: 0
      },
      fileList: [], // 上传文件列表
      adTypeList: [],
      saveBtnDisabled: false // 保存按钮是否禁用，防止表单重复提交
    }
  },
  // 页面渲染成功
  created() {
    if (this.$route.params.id) {
      this.fetchDataById(this.$route.params.id)
    }
    // 获取推荐位列表
    this.initAdTypeList()
  },
  methods: {
    initAdTypeList() {
      adTypeApi.list().then(response => {
        this.adTypeList = response.data.items
      })
    },
    saveOrUpdate() {
      // 禁用保存按钮
      this.saveBtnDisabled = true
      if (!this.ad.id) {
        this.saveData()
      } else {
        this.updateData()
      }
    },
    // 新增
    saveData() {
      // debugger
      adApi.save(this.ad).then(response => {
        this.$message.success(response.message)
        this.$router.push({ path: '/ad/list' })
      })
    },
    // 根据id更新记录
    updateData() {
      // teacher数据的获取
      adApi.updateById(this.ad).then(response => {
        this.$message.success(response.message)
        this.$router.push({ path: '/ad/list' })
      })
    },
    // 根据id查询记录
    fetchDataById(id) {
      adApi.getById(id).then(response => {
        this.ad = response.data.item
        this.fileList = [{ 'url': this.ad.imageUrl }]
      })
    },
    // 上传多于一个文件
    handleUploadExceed(files, fileList) {
      this.$message.warning('想要重新上传图片，请先删除已上传的视频')
    },
    // 上传校验
    beforeAvatarUpload(file) {
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
    // 上传成功回调
    handleAvatarSuccess(res, file) {
      console.log(res)
      if (res.success) {
        // console.log(res)
        this.ad.imageUrl = res.data.url
        // 强制重新渲染
        // this.$forceUpdate()
      } else {
        this.$message.error('上传失败1')
      }
    },
    // 错误处理
    handleAvatarError() {
      console.log('error')
      this.$message.error('上传失败2')
    }
  }
}
</script>
```

