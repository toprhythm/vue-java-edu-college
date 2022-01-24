# part22-视频播放

# 1 **后端获取播放凭证**

## 1.1 web层

service_vod微服务中创建controller.api包

创建ApiMediaController，创建 getPlayAuth方法

```java
package com.atguigu.guli.service.vod.controller.api;

@Api(description="阿里云视频点播")
@CrossOrigin //跨域
@RestController
@RequestMapping("/api/vod/media")
@Slf4j
public class ApiMediaController {
    @Autowired
    private VideoService videoService;
    @GetMapping("get-play-auth/{videoSourceId}")
    public R getPlayAuth(
            @ApiParam(value = "阿里云视频文件的id", required = true)
            @PathVariable String videoSourceId){
        try{
            String playAuth = videoService.getPlayAuth(videoSourceId);
            return  R.ok().message("获取播放凭证成功").data("playAuth", playAuth);
        } catch (Exception e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.FETCH_PLAYAUTH_ERROR);
        }
    }
}
```

## 1.2 **service层**

接口：VideoService

```java
String getPlayAuth(String videoSourceId) throws ClientException;
```

实现：VideoServiceImpl

```java
@Override
public String getPlayAuth(String videoSourceId) throws ClientException {
    //初始化client对象
    DefaultAcsClient client = AliyunVodSDKUtils.initVodClient(
        vodProperties.getKeyid(),
        vodProperties.getKeysecret());
    //创建请求对象
    GetVideoPlayAuthRequest request = new GetVideoPlayAuthRequest ();
    request.setVideoId(videoSourceId);
    GetVideoPlayAuthResponse response = client.getAcsResponse(request);
    return response.getPlayAuth();
}
```

# 2 前端播放器整合

## 2.1 api

course.js，从后端获取播放凭证

```js
getPlayAuth(vid) {
    return request({
        baseURL: 'http://localhost:8130',
        url: `/api/vod/media/get-play-auth/${vid}`,
        method: 'get'
    })
}
```

## 2.2 点击播放超链接

course/_id.vue

修改课时目录超链接

![image-20211111111928603](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211111111928603.png)

```html
<a
  :href="'/player/'+video.videoSourceId"
  :title="video.title" 
  target="_blank">
  <span v-if="Number(course.price) !== 0 && video.free===true" class="fr">
    <i class="free-icon vam mr10">免费试听</i>
  </span>
  <em class="lh-menu-i-2 icon16 mr5">&nbsp;</em>{{ video.title }}
</a>
```

## 2.3 创建播放页面

创建 pages/player/_vid.vue

（1）引入播放器js库和css样式

```html
<template>
  <div>
    <!-- 阿里云视频播放器样式 -->
    <link rel="stylesheet" href="https://g.alicdn.com/de/prismplayer/2.8.2/skins/default/aliplayer-min.css" >
    <!-- 启用私有加密的防调式：生产环境使用 -->
    <script src="https://g.alicdn.com/de/prismplayer/2.8.0/hls/aliplayer-vod-anti-min.js" />
    <!-- 阿里云视频播放器脚本 -->
    <script charset="utf-8" type="text/javascript" src="https://g.alicdn.com/de/prismplayer/2.8.2/aliplayer-min.js" />
    <!-- 定义播放器dom -->
    <div id="J_prismPlayer" class="prism-player"/>
  </div>
</template>
```

## 2.4 获取播放凭证

```js
<script>
import courseApi from '~/api/course'
export default {
  async asyncData(page) {
    const vid = page.route.params.vid
    const response = await courseApi.getPlayAuth(vid)
    return {
      vid: vid,
      playAuth: response.data.playAuth
    }
  }
}
</script>
```

## 2.5 渲染播放器

```js
/**
 * 页面渲染完成时：此时js脚本已加载，Aliplayer已定义，可以使用
 */
mounted() {
    /* eslint-disable no-undef */ //忽略 no-undef 检测
    /*const player = */new Aliplayer({
       id: 'J_prismPlayer',
       width: '100%',
       // 播放方式二：加密视频的播放：首先获取播放凭证
       encryptType: '1', // 如果播放加密视频，则需设置encryptType=1，非加密视频无需设置此项
       vid: this.vid,
       playauth: this.playAuth,
    }, function(player) {
        console.log('播放器创建成功')
    })
}
```

