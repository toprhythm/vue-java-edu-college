# part19-课程视频上传

# 1 **创建视频点播微服务**

## 1.1 创建模块

Artifact：service_vod

## 1.2 配置pom.xml

```xml
<dependencies>
      <dependency>
          <groupId>com.aliyun</groupId>
          <artifactId>aliyun-java-sdk-core</artifactId>
      </dependency>
      <dependency>
          <groupId>com.aliyun.oss</groupId>
          <artifactId>aliyun-sdk-oss</artifactId>
      </dependency>
      <dependency>
          <groupId>com.aliyun</groupId>
          <artifactId>aliyun-java-sdk-vod</artifactId>
      </dependency>
      <!--非开源jar-->
      <dependency>
          <groupId>com.aliyun</groupId>
          <artifactId>aliyun-sdk-vod-upload</artifactId>
      </dependency>
</dependencies>
```

## 1.3 安装非开源jar包

参考文档：https://help.aliyun.com/document_detail/53406.html?spm=a2c4g.11186623.6.980.5f027853fqcnnZ#h2-2-sdk-2
![image-20211109081344334](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211109081344334.png)

在本地Maven仓库中安装jar包：

下载视频上传SDK，解压，命令行进入lib目录，执行以下代码

```shell
mvn install:install-file -DgroupId=com.aliyun -DartifactId=aliyun-sdk-vod-upload -Dversion=1.4.14 -Dpackaging=jar -Dfile=aliyun-java-vod-upload-1.4.14.jar
```

## 1.4 **配置application.yml**

```yaml
server:
  port: 8130 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-vod # 服务名
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
  servlet:
    multipart:
      max-file-size: 1024MB # 最大上传单个文件大小：默认1M
      max-request-size: 1024MB # 最大置总上传的数据大小 ：默认10M
aliyun:
  vod:
    keyid: 你的keyid
    keysecret: 你的keysecret
    templateGroupId: 你配置的转码模板组id #转码模板组id
    workflowId: 你配置的工作流id #工作流id
```

## 1.5 logback-spring.xml

修改日志路径为vod

## 1.6 创建启动类

ServiceVodApplication.java

```java
package com.yunzoukj.yunzou.service.vod;

@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)//取消数据源自动配置
@ComponentScan({"com.atguigu.guli"})
@EnableDiscoveryClient
public class ServiceVodApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceVodApplication.class, args);
    }
}
```

## 1.7 启动项目



# 2 实现视频上传

## 2.1 文件上传参考

https://help.aliyun.com/document_detail/53406.html?spm=a2c4g.11186623.6.980.5f027853fqcnnZ#h2-3-3

文档

​	![image-20211109081601382](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211109081601382.png)

上传示例：

![image-20211109081617028](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211109081617028.png)

## 2.2 从配置文件读取常量

创建常量读取工具类：VodProperties.java

```java
package com.atguigu.guli.service.vod.util;

@Data
@Component
@ConfigurationProperties(prefix="aliyun.vod")
public class VodProperties {
    private String keyid;
    private String keysecret;
    private String templateGroupId;
    private String workflowId;
}
```

## 2.3 视频上传业务

接口：VideoService.java

```java
package com.atguigu.guli.service.vod.service;

public interface VideoService {
    String uploadVideo(InputStream file, String originalFilename);
}
```

实现：VideoServiceImpl.java

```java
package com.atguigu.guli.service.vod.service.impl;

@Service
@Slf4j
public class VideoServiceImpl implements VideoService {
    @Autowired
    private VodProperties vodProperties;
    @Override
    public String uploadVideo(InputStream inputStream, String originalFilename) {
        String title = originalFilename.substring(0, originalFilename.lastIndexOf("."));
        UploadStreamRequest request = new UploadStreamRequest(
                vodProperties.getKeyid(),
                vodProperties.getKeysecret(),
                title, originalFilename, inputStream);
        /* 模板组ID(可选) */
//        request.setTemplateGroupId(vodProperties.getTemplateGroupId());
        /* 工作流ID(可选) */
//        request.setWorkflowId(vodProperties.getWorkflowId());
        UploadVideoImpl uploader = new UploadVideoImpl();
        UploadStreamResponse response = uploader.uploadStream(request);
        String videoId = response.getVideoId();
        //没有正确的返回videoid则说明上传失败
        if(StringUtils.isEmpty(videoId)){
            log.error("阿里云上传失败：" + response.getCode() + " - " + response.getMessage());
            throw new GuliException(ResultCodeEnum.VIDEO_UPLOAD_ALIYUN_ERROR);
        }
        return videoId;
    }
}
```

## 2.4 创建controller

MediaController.java

```java
package com.atguigu.guli.service.vod.controller.admin;

@Api(description="阿里云视频点播")
@CrossOrigin //跨域
@RestController
@RequestMapping("/admin/vod/media")
@Slf4j
public class MediaController {
    @Autowired
    private VideoService videoService;
    @PostMapping("upload")
    public R uploadVideo(
            @ApiParam(name = "file", value = "文件", required = true)
            @RequestParam("file") MultipartFile file) {
        try {
            InputStream inputStream = file.getInputStream();
            String originalFilename = file.getOriginalFilename();
            String videoId = videoService.uploadVideo(inputStream, originalFilename);
            return R.ok().message("视频上传成功").data("videoId", videoId);
        } catch (IOException e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.VIDEO_UPLOAD_TOMCAT_ERROR);
        }
    }
}
```

# 3 使用工作流

## 3.1 配置工作流

![image-20211109081848525](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211109081848525.png)

## 3.2 设置请求参数

```java
/* 工作流ID(可选) */
request.setWorkflowId(vodProperties.getWorkflowId());
```



# 4 前端整合视频上传

## 4.1 模板和数据绑定 数据定义

在 src/views/course/components/Video/Form.vue中定义

```js
fileList: [],//上传文件列表
uploadBtnDisabled: false
```



## 4.2 整合上传组件

```html
<!-- 上传视频 -->
<el-form-item label="上传视频">
    <el-upload
               ref="upload"
               :auto-upload="false"
               :on-success="handleUploadSuccess"
               :on-error="handleUploadError"
               :on-exceed="handleUploadExceed"
               :file-list="fileList"
               :limit="1"
               action="http://127.0.0.1:8130/admin/vod/media/upload">
        <el-button slot="trigger" size="small" type="primary">选择视频</el-button>
        <el-button
                   :disabled="uploadBtnDisabled"
                   style="margin-left: 10px;"
                   size="small"
                   type="success"
                   @click="submitUpload()">上传</el-button>
    </el-upload>
</el-form-item>
```



## 4.3 回调函数和上传

(1) 上传限制

```js
//上传多于一个视频
handleUploadExceed(files, fileList) {
  this.$message.warning('想要重新上传视频，请先删除已上传的视频')
},
```

(2) 上传方法

```js
// 上传
submitUpload() {
    this.uploadBtnDisabled = true
    this.$refs.upload.submit() // 提交上传请求
}
```

(3)成功和失败回调

```js

// 视频上传成功的回调
handleUploadSuccess(response, file, fileList) {
  this.uploadBtnDisabled = false
  if (response.success) {
    this.video.videoSourceId = response.data.videoId
    this.video.videoOriginalName = file.name
  } else {
    this.$message.error('上传失败1')
  }
},
// 失败回调
handleUploadError() {
  this.uploadBtnDisabled = false
  this.$message.error('上传失败2')
},
```

(4)**重置视频上传列表**

在 src/views/course/components/Video/Form.vue

```js
resetForm() {
    this.video = ......
    this.fileList = [] //重置视频上传列表
},
```

## 4.4 回显

(1)修改时回显视频

Video/Form.vue 中open方法中获取数据后添加 "回显" 部分代码

```js
open(chapterId, videoId) {
    this.dialogVisible = true
    this.video.chapterId = chapterId
    if (videoId) {
        videoApi.getById(videoId).then(response => {
            this.video = response.data.item
            // 回显
            if (this.video.videoOriginalName) {
                this.fileList = [{ 'name': this.video.videoOriginalName }]
            }
        })
    }
},
```



# 5 删除视频

## **后端接口**

文档：服务端SDK->Java SDK->媒资管理

https://help.aliyun.com/document_detail/61065.html?spm=a2c4g.11186623.6.831.654b3815cIxvma#h2--div-id-deletevideo-div-7

vod微服务中添加service方法

## 5.1 创建工具类

service_vod中创建AliyunVodSDKUtils.java

```java
package com.atguigu.guli.service.vod.util;

public class AliyunVodSDKUtils {
    public static DefaultAcsClient initVodClient(String accessKeyId, String accessKeySecret) {
        String regionId = "cn-shanghai";  // 点播服务接入区域
        DefaultProfile profile = DefaultProfile.getProfile(regionId, accessKeyId, accessKeySecret);
        DefaultAcsClient client = new DefaultAcsClient(profile);
        return client;
    }
}
```

## 5.2 service

接口：VideoService

```java
void removeVideo(String videoId) throws ClientException;
```

实现：VideoServiceImpl

```java
@Override
public void removeVideo(String videoId) throws ClientException {
    DefaultAcsClient client = AliyunVodSDKUtils.initVodClient(
        vodProperties.getKeyid(),
        vodProperties.getKeysecret());
    DeleteVideoRequest request = new DeleteVideoRequest();
    request.setVideoIds(videoId);
    client.getAcsResponse(request);
}
```

## 5.3 **controller**

```java
@DeleteMapping("remove/{vodId}")
public R removeVideo(
    @ApiParam(value="阿里云视频id", required = true)
    @PathVariable String vodId){
    try {
        videoService.removeVideo(vodId);
        return R.ok().message("视频删除成功");
    } catch (Exception e) {
        log.error(ExceptionUtils.getMessage(e));
        throw new GuliException(ResultCodeEnum.VIDEO_DELETE_ALIYUN_ERROR);
    }
}
```

# 6 前端

## 6.1 定义api

新建 api/vod.js

```js
import request from '@/utils/request'

export default {
  removeByVodId(id) {
    return request({
      baseURL: 'http://127.0.0.1:8130',
      url: `/admin/vod/media/remove/${id}`,
      method: 'delete'
    })
  }
}
```

## 6.2 组件方法

在 src/views/course/components/Video/Form.vue中定义

el-upload中注册事件 :before-remove 和 :on-remove

模板：

```html
<!-- 上传视频 -->
<el-form-item label="上传视频">
        <el-upload
          :before-remove="handleBeforeRemove"
          :on-remove="handleOnRemove"
```

引入api

```js
import vodApi from '@/api/vod'
```

定义回调方法

```js
// 删除视频文件确认
handleBeforeRemove(file, fileList) {
  return this.$confirm(`确定移除 ${file.name}？`)
},
// 执行视频文件的删除
handleOnRemove(file, fileList) {
  if (!this.video.videoSourceId) {
    return
  }
  vodApi.removeByVodId(this.video.videoSourceId).then(response => {
    this.video.videoSourceId = ''
    this.video.videoOriginalName = ''
    videoApi.updateById(this.video)
    this.$message.success(response.message)
  })
},
```

# 7 删除video的同时删除视频

## 7.1 创建feign接口

```java
package com.atguigu.guli.service.edu.feign;

@Service
@FeignClient(value = "service-vod", fallback = VodMediaServiceFallBack.class)
public interface VodMediaService {
    @DeleteMapping("/admin/vod/media/remove/{vodId}")
    R removeVideo(@PathVariable("vodId") String vodId);
}

```

## 7.2 创建容错类

```java
package com.atguigu.guli.service.edu.feign.fallback;

@Service
@Slf4j
public class VodMediaServiceFallBack implements VodMediaService {
    @Override
    public R removeVideo(String vodId) {
        log.info("熔断保护");
        return R.error();
    }
}

```

## 7.3 service中调用feign接口

接口：VideoService.java

```java
void removeMediaVideoById(String id);
```

实现：VideoServiceImpl.java

```java
@Autowired
private VodMediaService vodMediaService;

@Override
public void removeMediaVideoById(String id) {
    log.warn("VideoServiceImpl：video id = " + id);
    //根据videoid找到视频id
    Video video = baseMapper.selectById(id);
    String videoSourceId = video.getVideoSourceId();
    log.warn("VideoServiceImpl：videoSourceId= " + videoSourceId);
    vodMediaService.removeVideo(videoSourceId);
}
```

## 7.4 web层

VideoController.java中完善removeById

```java
//删除视频
videoService.removeMediaVideoById(id);
```



# 8 批量删除视频和远程调用

## 8.1 web层

VideoController.java

```java
@DeleteMapping("remove")
public R removeVideoByIdList(
    @ApiParam(value = "阿里云视频id列表", required = true)
    @RequestBody List<String> videoIdList){
    try {
        videoService.removeVideoByIdList(videoIdList);
        return  R.ok().message("视频删除成功");
    } catch (Exception e) {
        log.error(ExceptionUtils.getMessage(e));
        throw new GuliException(ResultCodeEnum.VIDEO_DELETE_ALIYUN_ERROR);
    }
}
```

## 8.2 Service层

接口：VideoService.java

```java
void removeVideoByIdList(List<String> videoIdList) throws ClientException;
```

实现：VideoServiceImpl.java

```java
@Override
public void removeVideoByIdList(List<String> videoIdList) throws ClientException {
    //初始化client对象
    DefaultAcsClient client = AliyunVodSDKUtils.initVodClient(
        vodProperties.getKeyid(),
        vodProperties.getKeysecret());
    DeleteVideoRequest request = new DeleteVideoRequest();
    int size = videoIdList.size();
    StringBuffer idListStr = new StringBuffer();
    for (int i = 0; i < size; i++) {
        idListStr.append(videoIdList.get(i));
        if(i == size -1 || i % 20 == 19){
            System.out.println("idListStr = " + idListStr.toString());
            //支持传入多个视频ID，多个用逗号分隔，最多20个
            request.setVideoIds(idListStr.toString());
            client.getAcsResponse(request);
            idListStr = new StringBuffer();
        }else if(i % 20 < 19){
            idListStr.append(",");
        }
    }
}
```

## 8.3 swagger测试

![image-20211109093828943](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211109093828943.png)



# 9 edu项目中实现远程调用

## 9.1 创建feign接口

```java
package com.atguigu.guli.service.edu.feign;

@Service
@FeignClient(value = "service-vod", fallback = VodMediaServiceFallBack.class)
public interface VodMediaService {
    @DeleteMapping("/admin/vod/media/remove")
    R removeVideoByIdList(@RequestBody List<String> videoIdList);
}
```

## 9.2 创建容错类

```java

package com.atguigu.guli.service.edu.feign.fallback;

@Service
@Slf4j
public class VodMediaServiceFallBack implements VodMediaService {
    @Override
    public R removeVideoByIdList(List<String> videoIdList) {
        log.info("熔断保护");
        return R.error().message("调用超时");
    }
}

```

# 10 删除video时删除视频（传递id列表方案）

## 10.1 service中调用feign接口

接口：VideoService.java

```java
void removeMediaVideoById(String id);
```

实现：VideoServiceImpl.java

```java
@Autowired
private VodMediaService vodMediaService;

@Override
public void removeMediaVideoById(String id) {
    Video video = baseMapper.selectById(id);
    String videoSourceId = video.getVideoSourceId();
    List<String> videoSourceIdList = new ArrayList<>();
    videoSourceIdList.add(videoSourceId);
    vodMediaService.removeVideoByIdList(videoSourceIdList);
}
```

## 10.2 web层

VideoController.java中完善removeById

```java
//删除视频
videoService.removeMediaVideoById(id);
```

# 11 删除chapter时删除视频

## 11.1 service中调用feign接口

接口：VideoService.java

```java
void removeMediaVideoByChapterId(String chapterId);
```

实现：VideoServiceImpl.java

```java
@Override
public void removeMediaVideoByChapterId(String chapterId) {
    QueryWrapper<Video> queryWrapper = new QueryWrapper<>();
    queryWrapper.select("video_source_id");
    queryWrapper.eq("chapter_id", chapterId);
    List<Map<String, Object>> maps = baseMapper.selectMaps(queryWrapper);
    List<String> videoSourceIdList = new ArrayList<>();
    for (Map<String, Object> map : maps) {
        String videoSourceId = (String)map.get("video_source_id");
        videoSourceIdList.add(videoSourceId);
    }
    vodMediaService.removeVideoByIdList(videoSourceIdList);
}
```

## 11.2 web层

ChapterController.java中添加依赖

```java
@Autowired
private VideoService videoService;
```

ChapterController.java中完善removeById

```java
//删除视频：VOD
videoService.removeMediaVideoByChapterId(id);
```

# 12 **删除course时删除视频**

## 12.1 service中调用feign接口

接口：VideoService.java

```java
void removeMediaVideoByCourseId(String courseId);
```

实现：VideoServiceImpl.java

辅助方法

```java

/**
     * 获取阿里云视频id列表
     */
private List<String> getVideoSourceIdList(List<Map<String, Object>> maps){
    List<String> videoSourceIdList = new ArrayList<>();
    for (Map<String, Object> map : maps) {
        String videoSourceId = (String)map.get("video_source_id");
        videoSourceIdList.add(videoSourceId);
    }
    return videoSourceIdList;
}
```

实现方法

```java
@Override
public void removeMediaVideoByCourseId(String courseId) {
    QueryWrapper<Video> queryWrapper = new QueryWrapper<>();
    queryWrapper.select("video_source_id");
    queryWrapper.eq("course_id", courseId);
    List<Map<String, Object>> maps = baseMapper.selectMaps(queryWrapper);
    List<String> videoSourceIdList = this.getVideoSourceIdList(maps);
    vodMediaService.removeVideoByIdList(videoSourceIdList);
}
```

## 12.2 web层

CourseController.java中添加依赖

```java
@Autowired
private VideoService videoService;
```

CourseController.java中完善removeById

```java
//删除视频：VOD
videoService.removeMediaVideoByCourseId(id);
```

