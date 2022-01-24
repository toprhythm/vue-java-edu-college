# part16-章节管理

# 1 新增章节

## 1.1 web层

web层：ChapterController.java

```java

package com.atguigu.guli.service.edu.controller.admin;
@CrossOrigin
@Api(description = "章节管理")
@RestController
@RequestMapping("/admin/edu/chapter")
@Slf4j
public class ChapterController {
    @Autowired
    private ChapterService chapterService;
    @ApiOperation("新增章节")
    @PostMapping("save")
    public R save(
            @ApiParam(value="章节对象", required = true)
            @RequestBody Chapter chapter){
        boolean result = chapterService.save(chapter);
        if (result) {
            return R.ok().message("保存成功");
        } else {
            return R.error().message("保存失败");
        }
    }
}
```

# 2 根据id查询章节

## 2.1 web层

web层：ChapterController.java

```java
@ApiOperation("根据id查询章节")
@GetMapping("get/{id}")
public R getById(
    @ApiParam(value="章节id", required = true)
    @PathVariable String id){
    Chapter chapter = chapterService.getById(id);
    if (chapter != null) {
        return R.ok().data("item", chapter);
    } else {
        return R.error().message("数据不存在");
    }
}
```



# 3 更新章节

## 3.1 web层

web层：ChapterController.java

```java
@ApiOperation("根据id修改章节")
@PutMapping("update")
public R updateById(
    @ApiParam(value="章节对象", required = true)
    @RequestBody Chapter chapter){
    boolean result = chapterService.updateById(chapter);
    if (result) {
        return R.ok().message("修改成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

# 4 根据id删除章节

## 4.1 web层

ChapterController.java

```java
@ApiOperation("根据ID删除章节")
@DeleteMapping("remove/{id}")
public R removeById(
    @ApiParam(value = "章节ID", required = true)
    @PathVariable String id){
    //TODO 删除视频：VOD
    //在此处调用vod中的删除视频文件的接口
    boolean result = chapterService.removeChapterById(id);
    if (result) {
        return R.ok().message("删除成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 4.2 Service层

接口：ChapterService.java

```java
boolean removeChapterById(String id);
```

实现：ChapterServiceImpl.java

```java
@Autowired
private VideoMapper videoMapper;

@Transactional(rollbackFor = Exception.class)
@Override
public boolean removeChapterById(String id) {
    //课时信息：video
    QueryWrapper<Video> videoQueryWrapper = new QueryWrapper<>();
    videoQueryWrapper.eq("chapter_id", id);
    videoMapper.delete(videoQueryWrapper);
    //章节信息：chapter
    return this.removeById(id);
}
```

# 5 章节列表显示

## 5.1 定义vo

VideoVo.java

```java
package com.atguigu.guli.service.edu.entity.vo;
@Data
public class VideoVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private Boolean free;
    private Integer sort;
    private String videoSourceId;
}
```

ChapterVo.java

```java
package com.atguigu.guli.service.edu.entity.vo;
@Data
public class ChapterVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String title;
    private Integer sort;
    private List<VideoVo> children = new ArrayList<>();
}
```

## 5.2 web层

ChapterController.java

```java
@ApiOperation("嵌套章节数据列表")
@GetMapping("nested-list/{courseId}")
public R nestedListByCourseId(
    @ApiParam(value = "课程ID", required = true)
    @PathVariable String courseId){
    List<ChapterVo> chapterVoList = chapterService.nestedList(courseId);
    return R.ok().data("items", chapterVoList);
}
```

## 5.3 service层

接口：ChapterService.java

```java
List<ChapterVo> nestedList(String courseId);
```

实现：ChapterServiceImpl.java

```java
@Override
public List<ChapterVo> nestedList(String courseId) {
    List<ChapterVo> chapterVoList = new ArrayList<>();
    //获取章信息
    QueryWrapper<Chapter> queryWrapperChapter = new QueryWrapper<>();
    queryWrapperChapter.eq("course_id", courseId);
    queryWrapperChapter.orderByAsc("sort", "id");
    List<Chapter> chapterList = baseMapper.selectList(queryWrapperChapter);
    //获取课时信息
    QueryWrapper<Video> queryWrapperVideo = new QueryWrapper<>();
    queryWrapperVideo.eq("course_id", courseId);
    queryWrapperVideo.orderByAsc("sort", "id");
    List<Video> videoList = videoMapper.selectList(queryWrapperVideo);
    //填充列表数据：Chapter列表
    for (int i = 0; i < chapterList.size(); i++) {
        Chapter chapter = chapterList.get(i);
        //创建ChapterVo对象
        ChapterVo chapterVo = new ChapterVo();
        BeanUtils.copyProperties(chapter, chapterVo);
        chapterVoList.add(chapterVo);
        //填充列表数据：Video列表
        List<VideoVo> videoVoList = new ArrayList<>();
        for (int j = 0; j < videoList.size(); j++) {
            Video video = videoList.get(j);
            if(chapter.getId().equals(video.getChapterId())){
                VideoVo videoVo = new VideoVo();
                BeanUtils.copyProperties(video, videoVo);
                videoVoList.add(videoVo);
            }
        }
        chapterVo.setChildren(videoVoList);
    }
    return chapterVoList;
}
```

# 6 前端列表组件开发

## 6.1 **定义api**

api/chapter.js

```js
import request from '@/utils/request'
export default {
  
  getNestedTreeList(courseId) {
    return request({
      url: `/admin/edu/chapter/nested-list/${courseId}`,
      method: 'get'
    })
  },
  
  removeById(id) {
    return request({
      url: `/admin/edu/chapter/remove/${id}`,
      method: 'delete'
    })
  },
  
  save(chapter) {
    return request({
      url: '/admin/edu/chapter/save',
      method: 'post',
      data: chapter
    })
  },
  
  getById(id) {
    return request({
      url: `/admin/edu/chapter/get/${id}`,
      method: 'get'
    })
  },
  
  updateById(chapter) {
    return request({
      url: '/admin/edu/chapter/update',
      method: 'put',
      data: chapter
    })
  }
  
}
```

# 7 显示章节列表

## 7.1 组件脚本

src/views/course/components/Chapter/Index.vue

```js
import chapterApi from '@/api/chapter'
export default {
  data() {
    return {
      chapterList: [] // 章节嵌套列表
    }
  },
  created() {
    this.fetchNodeList()
  },
  methods: {
    // 获取远程数据
    fetchNodeList() {
      chapterApi.getNestedTreeList(this.$parent.courseId).then(response => {
        this.chapterList = response.data.items
      })
    },
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
```



## 7.2 组件模板

```html
<!-- 添加章节按钮 -->
<div>
    <el-button type="primary">添加章节</el-button>
</div>
<!-- 章节列表 -->
<ul class="chapterList">
    <li
        v-for="chapter in chapterList"
        :key="chapter.id">
        <p>
            {{ chapter.title }}
            <span class="acts">
                <el-button type="text">添加课时</el-button>
                <el-button type="text">编辑</el-button>
                <el-button type="text">删除</el-button>
            </span>
        </p>
        <!-- 视频 -->
        <ul class="chapterList videoList">
            <li
                v-for="video in chapter.children"
                :key="video.id">
                <p>
                    {{ video.title }}
                    <el-tag v-if="!video.videoSourceId" size="mini" type="danger">
                        {{ '尚未上传视频' }}
                    </el-tag>
                    <span class="acts">
                        <el-tag v-if="video.free" size="mini" type="success">{{ '免费观看' }}</el-tag>
                        <el-button type="text">编辑</el-button>
                        <el-button type="text">删除</el-button>
                    </span>
                </p>
            </li>
        </ul>
    </li>
</ul>
<!-- 章节表单对话框 TODO -->
<!-- 课时表单对话框 TODO -->
```

## 7.3 定义样式

```css

<style>
.chapterList{
    position: relative;
    list-style: none;
    margin: 0;
    padding: 0;
}
.chapterList li{
  position: relative;
}
.chapterList p{
  float: left;
  font-size: 20px;
  margin: 10px 0;
  padding: 10px;
  height: 70px;
  line-height: 50px;
  width: 100%;
  border: 1px solid #DDD;
}
.chapterList .acts {
    float: right;
    font-size: 14px;
}
.videoList{
  padding-left: 50px;
}
.videoList p{
  float: left;
  font-size: 14px;
  margin: 10px 0;
  padding: 10px;
  height: 50px;
  line-height: 30px;
  width: 100%;
  border: 1px dashed #DDD;
}
</style>
```

# 8 删除章节

## 8.1 删除章节按钮

```html
<el-button type="text" @click="removeChapterById(chapter.id)">删除</el-button>
```

## 8.2 定义删除方法

```js
removeChapterById(chapterId) {
    this.$confirm('此操作将永久删除该章节，是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        return chapterApi.removeById(chapterId)
    }).then(response => {
        this.fetchNodeList()
        this.$message.success(response.message)
    }).catch((response) => {
        if (response === 'cancel') {
            this.$message.info('取消删除')
        }
    })
}
```

# 9 章节表单组件

## 9.1 组件模板

src/views/course/components/Chapter/Form.vue

```html
<template>
  <!-- 添加和修改章节表单 -->
  <el-dialog :visible="dialogVisible" title="添加章节" @close="close()">
    <el-form :model="chapter" label-width="120px">
      <el-form-item label="章节标题">
        <el-input v-model="chapter.title"/>
      </el-form-item>
      <el-form-item label="章节排序">
        <el-input-number v-model="chapter.sort" :min="0"/>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close()">取 消</el-button>
      <el-button type="primary" @click="saveOrUpdate()">确 定</el-button>
    </div>
  </el-dialog>
</template>
```

## 9.2 组件脚本

```js
<script>
export default {
  data() {
    return {
      dialogVisible: false,
      chapter: {
        sort: 0
      }
    }
  },
  methods: {
    open() {
      this.dialogVisible = true
    },
    close() {
      this.dialogVisible = false
    },
    saveOrUpdate() {
      if (!this.chapter.id) {
        this.save()
      } else {
        this.update()
      }
    },
    save() {
    },
    update() {
    }
  }
}
</script>
```

# 10 添加章节

## 10.1 引入章节表单组件

src/views/course/components/Chapter/Index.vue 中引入章节表单

```js

// 引入组件
import ChapterForm from '@/views/course/components/Chapter/Form'
export default {
  // 注册组件
  components: { ChapterForm },
  ......
}
```

Chapter/Index.vue 中使用组件

```html
<template>
  <div>
      ......
      <!-- 章节表单对话框 -->
      <chapter-form ref="chapterForm" />
  </div>
</template>
```

## 10.2 "添加章节"按钮

Chapter/Index.vue  中添加按钮注册事件

```html
<el-button type="primary" @click="addChapter()">添加章节</el-button>
```

定义方法

```js

// 添加章节
addChapter() {
    this.$refs.chapterForm.open()
}
```

## 10.3 保存章节

Chapter/Form.vue 中完善save方法

```js
import chapterApi from '@/api/chapter'
```

```js
save() {
    this.chapter.courseId = this.$parent.$parent.courseId
    chapterApi.save(this.chapter).then(response => {
        this.$message.success(response.message)
        // 关闭组件
        this.close()
        // 刷新列表
        this.$parent.fetchNodeList()
    })
},
```

修改close()方法，添加resetForm()方法

```js
close() {
    this.dialogVisible = false
    // 重置表单
    this.resetForm()
},
resetForm() {
    this.chapter = {
        sort: 0
    }
}
```

# 11 **修改章节**

## 11.1 编辑章节按钮

Chapter/Index.vue 

```html
<el-button type="text" @click="editChapter(chapter.id)">编辑</el-button>  
```

定义方法

```js
editChapter(chapterId) {
    this.$refs.chapterForm.open(chapterId)
},
```

## 11.2 回显章节

Chapter/Form.vue 中修改open方法

```js

open(chapterId) {
    this.dialogVisible = true
    if (chapterId) {
        chapterApi.getById(chapterId).then(response => {
            this.chapter = response.data.item
        })
    }
},
```

## 11.3 完善更新方法

```js
update() {
    chapterApi.updateById(this.chapter).then(response => {
        this.$message.success(response.message)
        // 关闭组件
        this.close()
        // 刷新列表
        this.$parent.fetchNodeList()
    })
}
```

