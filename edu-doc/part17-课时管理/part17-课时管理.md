# part17-课时管理

# 1 课时管理

## 1.1 新增课时

web层：VideoController.java

```java
package com.atguigu.guli.service.edu.controller.admin;

@CrossOrigin
@Api(description = "课时管理")
@RestController
@RequestMapping("/admin/edu/video")
@Slf4j
public class VideoController {
    @Autowired
    private VideoService videoService;
    @ApiOperation("新增课时")
    @PostMapping("save")
    public R save(
            @ApiParam(value="课时对象", required = true)
            @RequestBody Video video){
        boolean result = videoService.save(video);
        if (result) {
            return R.ok().message("保存成功");
        } else {
            return R.error().message("保存失败");
        }
    }
}
```

## 1.2 根据id查询课时

web层：VideoController.java

```java
@ApiOperation("根据id查询课时")
@GetMapping("get/{id}")
public R getById(
    @ApiParam(value="课时id", required = true)
    @PathVariable String id){
    Video video = videoService.getById(id);
    if (video != null) {
        return R.ok().data("item", video);
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 1.3 更新课时

web层：VideoController.java

```java
@ApiOperation("根据id修改课时")
@PutMapping("update")
public R updateById(
    @ApiParam(value="课时对象", required = true)
    @RequestBody Video video){
    boolean result = videoService.updateById(video);
    if (result) {
        return R.ok().message("修改成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

## 1.4 根据id删除课时

web层：VideoController.java

```java
@ApiOperation("根据ID删除课时")
@DeleteMapping("remove/{id}")
public R removeById(
    @ApiParam(value = "课时ID", required = true)
    @PathVariable String id){
    //TODO 删除视频：VOD
    //在此处调用vod中的删除视频文件的接口
    boolean result = videoService.removeById(id);
    if (result) {
        return R.ok().message("删除成功");
    } else {
        return R.error().message("数据不存在");
    }
}
```

# 2 前端整合

## 2.1 定义api

创建api/video.js

```js
import request from '@/utils/request'
export default {
  
  save(video) {
    return request({
      url: '/admin/edu/video/save',
      method: 'post',
      data: video
    })
  },
  
  getById(id) {
    return request({
      url: `/admin/edu/video/get/${id}`,
      method: 'get'
    })
  },
  
  updateById(video) {
    return request({
      url: '/admin/edu/video/update',
      method: 'put',
      data: video
    })
  },
  
  removeById(id) {
    return request({
      url: `/admin/edu/video/remove/${id}`,
      method: 'delete'
    })
  }
  
}
```

# 3 课时表单组件

## 3.1 组件模板

src/views/course/components/Video/Form.vue

```html
<template>
  <!-- 添加和修改课时表单 -->
  <el-dialog :visible="dialogVisible" title="添加课时"  @close="close()">
    <el-form :model="video" label-width="120px">
      <el-form-item label="课时标题">
        <el-input v-model="video.title"/>
      </el-form-item>
      <el-form-item label="课时排序">
        <el-input-number v-model="video.sort" :min="0" />
      </el-form-item>
      <el-form-item label="是否免费">
        <el-radio-group v-model="video.free">
          <el-radio :label="true">免费</el-radio>
          <el-radio :label="false">默认</el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close()">取 消</el-button>
      <el-button type="primary" @click="saveOrUpdate()">确 定</el-button>
    </div>
  </el-dialog>
</template>
```

## 3.2 组件脚本

```js
<script>
export default {
  data() {
    return {
      dialogVisible: false,
      video: {
        sort: 0,
        free: false
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
      if (!this.video.id) {
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

# 4 添加课时

## 4.1 引入课时表单组件

src/views/course/components/Chapter/Index.vue 中引入课时表单

```js
// 引入组件
import VideoForm from '@/views/course/components/Video/Form'
export default {
  // 注册组件
  components: { ChapterForm, VideoForm },
  ......
}
```

Chapter/Index.vue 中使用组件

```html

<template>
  <div>
      ......
      <!-- 课时表单对话框 -->
      <video-form ref="videoForm" />
  </div>
</template>

```

## 4.2 "添加课时"按钮

Chapter/Index.vue  中添加按钮注册事件

```html
<el-button type="text" @click="addVideo(chapter.id)">添加课时</el-button>
```

定义方法

```js
// 添加课时
addVideo(chapterId) {
    this.$refs.videoForm.open(chapterId)
},
```

Video/Form.vue 中修改open方法，传递chapterId参数

```js
open(chapterId) {
    this.dialogVisible = true
    this.video.chapterId = chapterId
}
```

## 4.3 保存课时

VideoForm.vue 中完善save方法

```js
import videoApi from '@/api/video'
```

```js
save() {
    this.video.courseId = this.$parent.$parent.courseId
    videoApi.save(this.video).then(response => {
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
    this.video = {
        sort: 0,
        free: false,
    }
},
```

# 5 修改课时

## 5.1 编辑课时按钮

Chapter/Index.vue 

```html
<el-button type="text" @click="editVideo(chapter.id, video.id)">编辑</el-button>
```

定义方法

```js
editVideo(chapterId, videoId) {
    this.$refs.videoForm.open(chapterId, videoId)
},
```

## 5.2 回显课时

Video/Form.vue 中修改open方法

```js
open(chapterId, videoId) {
    this.dialogVisible = true
    this.video.chapterId = chapterId
    if (videoId) {
        videoApi.getById(videoId).then(response => {
            this.video = response.data.item
        })
    }
},
```

## 5.3 完善更新方法

Video/Form.vue 

```js
update() {
    videoApi.updateById(this.video).then(response => {
        this.$message.success(response.message)
        // 关闭组件
        this.close()
        // 刷新列表
        this.$parent.fetchNodeList()
    })
}
```

# 6 删除课时

## 6.1 删除课时按钮

Chapter/Index.vue 

```html
<el-button type="text" @click="removeVideoById(video.id)">删除</el-button>
```

## 6.2 删除方法

Chapter/Index.vue 

```js
import videoApi from '@/api/video'
```

```js
removeVideoById(videoId) {
    this.$confirm('此操作将永久删除该课时, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        return videoApi.removeById(videoId)
    }).then(response => {
        this.fetchNodeList()
        this.$message.success(response.message)
    }).catch((response) => {
        if (response === 'cancel') {
            this.$message.info('取消删除')
        }
    })
},
```

