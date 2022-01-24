# part13-课程类目管理

# 1 需求

## 1.1 导入课程分类

![image-20211105074656807](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105074656807.png)

## 1.2 **课程分类列表**

![image-20211105074718721](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105074718721.png)



# 2 Excel模板上传

## 2.1 编辑Excel模板

## 2.2 将文件上传至阿里云OSS

![image-20211105074849477](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105074849477.png)

# 3 路由和组件

## 3.1 添加vue组件

![image-20211105074910395](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211105074910395.png)

## 3.2 添加路由

```js
// 课程分类管理
{
  path: '/subject',
  component: Layout,
  redirect: '/subject/list',
  name: 'Subject',
  meta: { title: '课程分类管理' },
  children: [
    {
      path: 'list',
      name: 'SubjectList',
      component: () => import('@/views/subject/list'),
      meta: { title: '课程分类列表' }
    },
    {
      path: 'import',
      name: 'SubjectImport',
      component: () => import('@/views/subject/import'),
      meta: { title: '导入课程分类' }
    }
  ]
},
```

# 4 import.vue组件

## 4.1 添加配置

config/dev.env.js中添加阿里云oss bucket地址，**注意：修改后重启前端服务器**

```js
OSS_PATH: '"https://guli-file.oss-cn-beijing.aliyuncs.com"'
```

## 4.2 js定义数据

```js
<script>
export default {
  data() {
    return {
      defaultExcelTemplate: process.env.OSS_PATH + '/excel/课程分类列表模板.xls', // 默认Excel模板
      importBtnDisabled: false // 导入按钮是否禁用
    }
  }
}
</script>
```

## 4.3 template

```vue
<template>
  <div class="app-container">
    <el-form label-width="120px">
      <el-form-item label="信息描述">
        <el-tag type="info">excel模版说明</el-tag>
        <el-tag>
          <i class="el-icon-download"/>
          <a :href="defaultExcelTemplate">点击下载模版</a>
        </el-tag>
      </el-form-item>
      <el-form-item label="选择Excel">
        <el-upload
          ref="upload"
          :auto-upload="false"
          :on-exceed="fileUploadExceed"
          :on-success="fileUploadSuccess"
          :on-error="fileUploadError"
          :limit="1"
          action="http://127.0.0.1:8110/admin/edu/subject/import"
          name="file"
          accept="application/vnd.ms-excel">
          <el-button
            slot="trigger"
            size="small"
            type="primary">选取文件</el-button>
          <el-button
            :disabled="importBtnDisabled"
            style="margin-left: 10px;"
            size="small"
            type="success"
            @click="submitUpload()">导入</el-button>
        </el-upload>
      </el-form-item>
    </el-form>
  </div>
</template>
```

## 4.4 js上传方法

```js
methods: {
    // 上传多于一个视频时
    fileUploadExceed() {
      this.$message.warning('只能选取一个文件')
    },
    // 上传
    submitUpload() {
      this.importBtnDisabled = true
      this.$refs.upload.submit() // 提交上传请求
    },
    fileUploadSuccess(response) {
      
    },
    fileUploadError(response) {
    }
}
```



# 5 前端upload组件分析

## 5.1 添加依赖 

service_edu中添加如下依赖

```xml
<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>easyexcel</artifactId>
    </dependency>
    <dependency>
        <groupId>org.apache.xmlbeans</groupId>
        <artifactId>xmlbeans</artifactId>
    </dependency>
</dependencies>
```

## 5.2 创建Excel实体类

```java
package com.atguigu.guli.service.edu.entity.excel;

@Data
public class ExcelSubjectData {
    @ExcelProperty(value = "一级分类")
    private String levelOneTitle;
    @ExcelProperty(value = "二级分类")
    private String levelTwoTitle;
}
```

# 6 实现Excel导入

## 6.1 创建监听器

```java
package com.atguigu.guli.service.edu.listener;

@Slf4j
@AllArgsConstructor //全参
@NoArgsConstructor //无参
public class ExcelSubjectDataListener extends AnalysisEventListener<ExcelSubjectData> {
    /**
     * 假设这个是一个DAO，当然有业务逻辑这个也可以是一个service。当然如果不用存储这个对象没用。
     */
    private SubjectMapper subjectMapper;
    /**
     *遍历每一行的记录
     * @param data
     * @param context
     */
    @Override
    public void invoke(ExcelSubjectData data, AnalysisContext context) {
        log.info("解析到一条记录: {}", data);
        //处理读取出来的数据
        String levelOneTitle = data.getLevelOneTitle();//一级标题
        String levelTwoTitle = data.getLevelTwoTitle();//二级标题
        log.info("levelOneTitle: {}", levelOneTitle);
        log.info("levelTwoTitle: {}", levelTwoTitle);
        // 组装数据：Subject
        // 存入数据库：subjectMapper.insert()
    }
    /**
     * 所有数据解析完成了 都会来调用
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        log.info("所有数据解析完成！");
    }
}
```

## 6.2 监听器中添加辅助方法

```java
/**
     * 根据分类名称查询这个一级分类是否存在
     * @param title
     * @return
     */
private Subject getByTitle(String title) {
    QueryWrapper<Subject> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("title", title);
    queryWrapper.eq("parent_id", "0");//一级分类
    return subjectMappter.selectOne(queryWrapper);
}
/**
     * 根据分类名称和父id查询这个二级分类是否存在
     * @param title
     * @return
     */
private Subject getSubByTitle(String title, String parentId) {
    QueryWrapper<Subject> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("title", title);
    queryWrapper.eq("parent_id", parentId);
    return subjectMappter.selectOne(queryWrapper);
}
```

## 6.3 完善invoke方法

```java

/**
     * 这个每一条数据解析都会来调用
     */
@Override
public void invoke(ExcelSubjectData data, AnalysisContext context) {
    log.info("解析到一条数据:{}", data);
    //处理读取进来的数据
    String titleLevelOne = data.getLevelOneTitle();
    String titleLevelTwo = data.getLevelTwoTitle();
    //判断一级分类是否重复
    Subject subjectLevelOne = this.getByTitle(titleLevelOne);
    String parentId = null;
    if(subjectLevelOne == null) {
        //将一级分类存入数据库
        Subject subject = new Subject();
        subject.setParentId("0");
        subject.setTitle(titleLevelOne);//一级分类名称
        subjectMappter.insert(subject);
        parentId = subject.getId();
    }else{
        parentId = subjectLevelOne.getId();
    }
    //判断二级分类是否重复
    Subject subjectLevelTwo = this.getSubByTitle(titleLevelTwo, parentId);
    if(subjectLevelTwo == null){
        //将二级分类存入数据库
        Subject subject = new Subject();
        subject.setTitle(titleLevelTwo);
        subject.setParentId(parentId);
        subjectMappter.insert(subject);//添加
    }
}
```

## 6.4 **SubjectService**

接口

```java
void batchImport(InputStream inputStream);
```

实现：获取Excel记录并逐条导入

```java
@Transactional(rollbackFor = Exception.class)
@Override
public void batchImport(InputStream inputStream) {
    // 这里 需要指定读用哪个class去读，然后读取第一个sheet 文件流会自动关闭
    EasyExcel.read(inputStream, ExcelSubjectData.class, new ExcelSubjectDataListener(baseMapper))
        .excelType(ExcelTypeEnum.XLS).sheet().doRead();
}
```

## 6.5 SubjectController

```java
package com.atguigu.guli.service.edu.controller.admin;

@CrossOrigin
@Api(description = "课程类别管理")
@RestController
@RequestMapping("/admin/edu/subject")
@Slf4j
public class SubjectController {
  
    @Autowired
    private SubjectService subjectService;
    @ApiOperation(value = "Excel批量导入课程类别数据")
    @PostMapping("import")
    public R batchImport(
            @ApiParam(value = "Excel文件", required = true)
            @RequestParam("file") MultipartFile file) {
        try {
            InputStream inputStream = file.getInputStream();
            subjectService.batchImport(inputStream);
            return R.ok().message("批量导入成功");
        } catch (Exception e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.EXCEL_DATA_IMPORT_ERROR);
        }
    }
}
```

# 7 **前端完善回调函数**

## 7.1 成功回调

```js
// 上传成功的回调
fileUploadSuccess(response) {
    if (response.success) {
        this.importBtnDisabled = false // 启用按钮
        this.$message.success(response.message)
        this.$refs.upload.clearFiles() // 清空文件列表
    } else {
        this.$message.error('上传失败! （非20000）')
    }
}
```

## 7.2 失败回调

```js
// 上传失败的回调
fileUploadError() {
    this.importBtnDisabled = false // 启用按钮
    this.$message.error('上传失败! （http失败）')
    this.$refs.upload.clearFiles() // 清空文件列表
}
```



# 8 分类列表展示

## 8.1 后端接口 创建vo

```java
package com.atguigu.guli.service.edu.entity.vo;

@Data
public class SubjectVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private Integer sort;
    private List<SubjectVo> children = new ArrayList<>();
}
```

## 8.2 创建controller方法

SubjectController

```java

@ApiOperation(value = "嵌套数据列表")
@GetMapping("nested-list")
public R nestedList(){
    List<SubjectVo> subjectVoList = subjectService.nestedList();
    return R.ok().data("items", subjectVoList);
}
```

## 8.3 创建SubjectService方法

接口

```java
List<SubjectVo> nestedList();
```

实现

```java
@Override
public List<SubjectVo> nestedList() {
    return baseMapper.selectNestedListByParentId("0");
}
```

## 8.4 创建mapper映射

SubjectMapper.java

```java
List<SubjectVo> selectNestedListByParentId(String parentId);
```

SubjectMapper.xml

```xml
<resultMap id="nestedSubject" type="com.atguigu.guli.service.edu.entity.vo.SubjectVo">
    <id property="id" column="id"/>
    <result property="title" column="title"/>
    <result property="sort" column="sort" />
    <collection property="children"
                ofType="com.atguigu.guli.service.edu.entity.vo.SubjectVo"
                select="selectNestedListByParentId"
                column="id"/>
</resultMap>
<select id="selectNestedListByParentId" resultMap="nestedSubject">
    select id, sort, title from edu_subject where parent_id = #{parentId}
</select>
```

## 8.5 swagger

```
报告异常：
```

ResultCodeEnum(success=false, code=20001, message=未知错误)

Invalid bound statement (not found): 

com.atguigu.guli.service.edu.mapper.SubjectMapper.selectNestedListByParentId

# 9 异常解决

## 9.1 **问题分析**

dao层编译后只有class文件，没有mapper.xml，
因为maven工程在默认情况下src/main/java目录下的所有资源文件是不发布到target目录下的

## 9.2 **解决方案**

**（1）在service_edu的pom中配置如下节点**

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

重新打包项目会发现target目录下出现了xml文件夹

（2）还需要在Spring Boot配置文件中添加配置

```yaml

mybatis-plus:
  mapper-locations: classpath:com/yunzoukj/yunzou/service/edu/mapper/xml/*.xml
```

# 10 **前端整合**

## 10.1 api

创建api/subject.js

```js

import request from '@/utils/request'
export default {
  getNestedTreeList() {
    return request({
      url: '/admin/edu/subject/nested-list',
      method: 'get'
    })
  }
}
```

## 10.2 list组件

```vue
<template>
  <div class="app-container">
    <el-input
      v-model="filterText"
      placeholder="输入查询条件"
      style="margin-bottom:30px;" />
    <el-tree
      ref="subjectTree"
      :data="subjectList"
      :props="defaultProps"
      :filter-node-method="filterNode"
      style="margin-top:10px;" />
  </div>
</template>
<script>
import subjectApi from '@/api/subject'
export default {
  data() {
    return {
      filterText: '', // 过滤文本
      subjectList: [], // 数据列表
      defaultProps: {// 属性列表数据属性的key
        children: 'children',
        label: 'title'
      }
    }
  },
  // 监听 filterText的变化
  watch: {
    filterText(val) {
      this.$refs.subjectTree.filter(val)// 调用tree的filter方法
    }
  },
  created() {
    this.fetchNodeList()
  },
  methods: {
    // 获取远程数据
    fetchNodeList() {
      subjectApi.getNestedTreeList().then(response => {
          this.subjectList = response.data.items
      })
    },
    // 过滤节点
    filterNode(value, data) {
      if (!value) return true
      return data.title.indexOf(value) !== -1
    }
  }
}
</script>
```

## 10.3 优化前端过滤功能

忽略大小写

```js
filterNode(value, data) {
    if (!value) return true
    return data.title.toLowerCase().indexOf(value.toLowerCase()) !== -1//忽略大小写
}
```

