# part18-aliyunVOD视频点播

# 1 阿里云视频点播

## 1.1 功能介绍

视频点播（ApsaraVideo VoD，简称VoD）是集视频采集、编辑、上传、媒体资源管理、自动化转码处理（窄带高清TM）、视频审核分析、分发加速于一体的一站式音视频点播解决方案。

## 1.2 应用场景

- **音视频网站：**无论是初创视频服务企业，还是已拥有海量视频资源，可定制化的点播服务帮助客户快速搭建拥有极致观看体验、安全可靠的视频点播应用。
- **短视频：**集音视频拍摄、特效编辑、本地转码、高速上传、自动化云端转码、媒体资源管理、分发加速、播放于一体的完整短视频解决方案。目前已帮助1000+APP快速实现手机短视频功能。
- **直播转点播：**将直播流同步录制为点播视频，用于回看。并支持媒资管理、媒体处理（转码及内容审核/智能首图等AI处理）、内容制作（云剪辑）、CDN分发加速等一系列操作。
- **在线教育：**为在线教育客户提供简单易用、安全可靠的视频点播服务。可通过控制台/API等多种方式上传教学视频，强大的转码能力保证视频可以快速发布，覆盖全网的加速节点保证学生观看的流畅度。防盗链、视频加密等版权保护方案保护教学内容不被窃取。
- **视频生产制作：**提供在线可视化剪辑平台及丰富的OpenAPI，帮助客户高效处理、制作视频内容。除基础的剪切拼接、混音、遮标、特效、合成等一系列功能外，依托云剪辑及点播一体化服务还可实现标准化、智能化剪辑生产，大大降低视频制作的槛，缩短制作时间，提升内容生产效率。
- **内容审核：**应用于短视频平台、传媒行业审核等场景，帮助客户从从语音、文字、视觉等多维度精准识别视频、封面、标题或评论的违禁内容进行AI智能审核与人工审核。

# 2 开通视频点播

## 2.1 前提条件

在使用阿里云VOD服务之前，请确保您已经注册了阿里云账号并完成实名认证。

## 2.2 开通服务

产品->企业应用->视频云->视频点播

## 2.3 选择按使用流量计费

# 3 控制台

## 3.1 媒资库

**上传文件**

- 选择**媒资库** > **音视频**，单击**上传音视频**
- 在**上传音视频**页面，您可以根据需要连续添加多个音视频或选择移除某个音视频，单击开始上传。 

**管理资源**

- 上传完成后，资源统一在媒资库呈现，可查看音视频的处理状态、视频id、视频地址等信息

## 3.2 存储管理

- 选择**配置管理** > **媒资管理配置** > **存储管理**

VOD提供存储服务，会默认帮您分配一个存储bucket，默认区域为华东2(上海)，无需任何配置即可进行上传和媒体资源管理，如您对存储区域有要求可再进行添加，目前VOD服务支持华北2(北京)和华东2(上海)两个服务中心。

## 3.3 视频转码和加密

转码即将一个音视频文件转换成另一个或多个不同清晰度等条件音视频文件，以适应不同网络带宽、不同终端设备和不同的用户需求，可以根据实际业务场景需求，进行转码模版配置

- 选择**配置管理** > **媒体处理配置** > **转码模板组**，单击**添加转码模板组**
- 在视频转码模板组页面，根据的业务需求选择封装格式和清晰度
- 在高级参数下，打开HLS加密开关使用数据加密，保护您的视频

![image-20211108092755275](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211108092755275.png)

上传视频时使用刚刚创建的加密转码模板组：

![image-20211108092821791](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211108092821791.png)

查看转码后的文件：

![image-20211108092841678](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211108092841678.png)

**注意：**如要播放加密视频**，**必须首先进行域名加速配置

## 3.4 域名管理

视频相对于一般的图文内容，文件体积更大，在传播过程对传输能力的体验要求更高，点播CDN服务可将您的资源缓存至阿里云遍布全球的加速节点上。当终端用户请求访问和获取这些资源时，系统将就近调用CDN节点上已经缓存的资源，提高播放的速度，并提供稳定的流畅体验，添加完成加速域名即可开启点播加速服务。

**[\**（1）\**添加域名](https://help.aliyun.com/document_detail/86074.html?spm=a2c4g.11186623.2.23.2c3a65ddmIASlb)**

进入VOD控制台，添加用于视频分发与加速的自有域名。

选择**配置管理** > **分发加速****配置** > **域名管理**，单击**添加域名**。

注意：请确保该域名已经备案，并拥有使用权。

![image-20211108092934547](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211108092934547.png)

**[\**（2）\**CNAME解析处理](https://help.aliyun.com/document_detail/86076.html)**

添加域名后可获得阿里云加速域名CNAME地址。完成CNAME配置后，即可完成域名添加操作。

注意：请根据提示信息，到您的域名解析商处完成CNAME绑定。如果使用万网、新网或DNSPod域名。

## **5、视频审核**

- 选择**审核****管理** **>** **视频审核**
- 选择**审核****管理** **>** **审核设置**（可以设置先发后审，也可以设置先审后发，还可以设置智能审核）

# 4 资费说明

https://www.aliyun.com/price/product?spm=a2c4g.11186623.2.12.7fbd59b9vmXVN6#/vod/detail

- 后付费
- 套餐包
- 欠费说明
- 计费案例：https://help.aliyun.com/document_detail/64032.html?spm=a2c4g.11186623.4.3.363db1bcfdvxB5

# 5 SDK准备工作

## 5.1 设置不转码

测试之前设置默认“不转码”，以节省开发成本

## 5.2 找到子账户的AccessKey ID

## 5.3 给子账户添加授权

AliyunVODFullAccess

## 5.4 阅读文档

- 服务端API

- - API调用示例参考：https://help.aliyun.com/document_detail/44435.html?spm=a2c4g.11186623.6.708.2c643d44SY21Hb

- 服务端SDK

- - SDK将API进行了进一步的封装，使用起来更简单方便

# 6 创建和初始化项目

## 6.1 创建maven项目 

Group：com.atguigu

Artifact：aliyun_vod

## 6.2 添加Maven依赖

```xml
<dependencies>
    <dependency>
        <groupId>com.aliyun</groupId>
        <artifactId>aliyun-java-sdk-core</artifactId>
        <version>4.3.3</version>
    </dependency>
    <dependency>
        <groupId>com.aliyun</groupId>
        <artifactId>aliyun-java-sdk-vod</artifactId>
        <version>2.15.2</version>
    </dependency>
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.8.2</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
</dependencies>

```

## 6.3 创建测试类并初始化

参考文档：https://help.aliyun.com/document_detail/61062.html

```java
package com.atguigu.aliyunvod;
public class VodSdkTest {
    public static DefaultAcsClient initVodClient(String accessKeyId, String accessKeySecret) {
        String regionId = "cn-shanghai";  // 点播服务接入区域
        DefaultProfile profile = DefaultProfile.getProfile(regionId, accessKeyId, accessKeySecret);
        DefaultAcsClient client = new DefaultAcsClient(profile);
        return client;
    }
}
```

# 7 创建测试用例

## 7.1 获取视频播放地址

参考文档：https://help.aliyun.com/document_detail/61064.html

```java
/*获取播放地址函数*/
public static GetPlayInfoResponse getPlayInfo(DefaultAcsClient client) throws Exception {
    GetPlayInfoRequest request = new GetPlayInfoRequest();
    request.setVideoId("视频ID");
    //request.setResultType("Multiple"); //如果视频id是加密视频的id，则需要设置此参数。但只能获取文件无法解密播放
    return client.getAcsResponse(request);
}
@Test
public void testGetPlayInfo(){
    DefaultAcsClient client = initVodClient("<您的AccessKeyId>", "<您的AccessKeySecret>");
    GetPlayInfoResponse response = new GetPlayInfoResponse();
    try {
        response = getPlayInfo(client);
        List<GetPlayInfoResponse.PlayInfo> playInfoList = response.getPlayInfoList();
        //播放地址
        for (GetPlayInfoResponse.PlayInfo playInfo : playInfoList) {
            System.out.print("PlayInfo.PlayURL = " + playInfo.getPlayURL() + "\n");
        }
        //Base信息
        System.out.print("VideoBase.Title = " + response.getVideoBase().getTitle() + "\n");
    } catch (Exception e) {
        System.out.print("ErrorMessage = " + e.getLocalizedMessage());
    }
    System.out.print("RequestId = " + response.getRequestId() + "\n");
}
```

## 7.2 获取视频播放凭证

参考文档：https://help.aliyun.com/document_detail/61064.html#h2--div-id-getvideoplayauth-div-2

加密视频必须使用此方式播放

```java
/*获取播放凭证函数*/
public static GetVideoPlayAuthResponse getVideoPlayAuth(DefaultAcsClient client) throws Exception {
    GetVideoPlayAuthRequest request = new GetVideoPlayAuthRequest();
    request.setVideoId("视频ID");
    return client.getAcsResponse(request);
}
/*以下为调用示例*/
@Test
public void testGetVideoPlayAuth() {
    DefaultAcsClient client = initVodClient("<您的AccessKeyId>", "<您的AccessKeySecret>");
    GetVideoPlayAuthResponse response = new GetVideoPlayAuthResponse();
    try {
        response = getVideoPlayAuth(client);
        //播放凭证
        System.out.print("PlayAuth = " + response.getPlayAuth() + "\n");
        //VideoMeta信息
        System.out.print("VideoMeta.Title = " + response.getVideoMeta().getTitle() + "\n");
    } catch (Exception e) {
        System.out.print("ErrorMessage = " + e.getLocalizedMessage());
    }
    System.out.print("RequestId = " + response.getRequestId() + "\n");
}
```

# 8 视频播放测试

## 8.1 关于flash的前世和今生

- 关于flash的前世和今生
- 私有加密方调试
- 关于cdn服务器和前端请求数量优化：减轻主服务器的压力、加速用户访问静态资源

**视频播放器**

参考文档：https://help.aliyun.com/document_detail/125570.html?spm=a2c4g.11186623.6.1083.1c53448blUNuv5

## 8.2 视频播放器介绍

阿里云播放器SDK（ApsaraVideo Player SDK）是阿里视频服务的重要一环，除了支持点播和直播的基础播放功能外，深度融合视频云业务，如支持视频的加密播放、安全下载、清晰度切换、直播答题等业务场景，为用户提供简单、快速、安全、稳定的视频播放服务。

## 8.3 集成视频播放器

- 创建aliyunplayer_pro文件夹
- 创建index.html文件
- 引入css文件

```css
<link rel="stylesheet" href="https://g.alicdn.com/de/prismplayer/2.8.2/skins/default/aliplayer-min.css" >
```



- 引入脚本文件并初始化视频播放器

```js
<div class="prism-player" id="J_prismPlayer"></div>
<script charset="utf-8" src="https://g.alicdn.com/de/prismplayer/2.8.2/aliplayer-min.js"></script>
<script>
    var player = new Aliplayer({
        id: 'J_prismPlayer',
        width: '100%',
        //播放配置
    },function(player){
        console.log('播放器创建好了。')
    });
</script>
```

## 8.4 **播放地址播放**

在Aliplayer的配置参数中添加如下属性

```js
//播放方式一：支持播放地址播放,此播放优先级最高，此种方式不能播放加密视频
source : '你的视频播放地址',
```

启动浏览器运行，测试视频的播放

# 8.5 播放凭证播放（推荐）

阿里云播放器支持通过播放凭证自动换取播放地址进行播放，接入方式更为简单，且安全性更高。播放凭证默认时效为100秒（最大为3000秒）。

如果凭证过期则无法获取播放地址，需要重新获取凭证。

```js
//播放方式二：加密视频和多数据源视频的播放
vid : '视频id',
playauth : '视频播放授权码',
encryptType:1, //当播放私有加密流时需要设置。   
```

注意：播放凭证有过期时间，默认值：100秒 。取值范围：**100~3000**。

设置播放凭证的有效期：在获取播放凭证的测试用例中添加如下代码

```java
request.setAuthInfoTimeout(200L);
```



# 9 功能和组件

**功能展示：**https://player.alicdn.com/aliplayer/presentation/index.html

## 9.1 视频封面

配置中添加cover属性设置

```js
cover: 'http://liveroom-img.oss-cn-qingdao.aliyuncs.com/logo.png',
```

## 9.2 跑马灯

引入js脚本

```js
<!-- 阿里云视频播放器组件 -->
<script charset="utf-8" src="https://player.alicdn.com/aliplayer/presentation/js/aliplayercomponents.min.js"></script>
```

播放器中添加配置项

```js
components: [{
    name: 'BulletScreenComponent', // 跑马灯组件
    type: AliPlayerComponent.BulletScreenComponent,
    /** 跑马灯组件三个参数 text, style, bulletPosition
       * text: 跑马灯文字内容
       * style: 跑马灯样式
       * bulletPosition: 跑马灯位置, 可选的值为 'top' (顶部), 'bottom' (底部), 'random' (随机), 不传值默认为 'random'
       */
    args: ['欢迎来到谷粒学院', { fontSize: '16px', color: '#00c1de' }, 'random']
}]
```

## 9.3 弹幕

首先定义弹幕组件的弹幕列表

```js
/* 弹幕组件集成了 CommentCoreLibrary 框架, 更多 Api 请查看文档 https://github.com/jabbany/CommentCoreLibrary/ */
  var danmukuList = [{
    "mode": 1,
    "text": "哈哈",
    "stime": 1000,
    "size": 25,
    "color": 0xffffff
  }, {
    "mode": 1,
    "text": "前方高能",
    "stime": 2000,
    "size": 25,
    "color": 0xff0000
  }, {
    "mode": 1,
    "text": "灵魂歌手",
    "stime": 30000,
    "size": 25,
    "color": 0xff0000
  }, {
    "mode": 1,
    "text": "顺手一划",
    "stime": 10000,
    "size": 25,
    "color": 0x00c1de
  }]
```

播放器中添加配置项

```js
components: [{
    name: 'AliplayerDanmuComponent', // 弹幕组件
    type: AliPlayerComponent.AliplayerDanmuComponent,
    args: [danmukuList] //列表：注意需要外层的[ ]
}]
```

## 9.4 旋转镜像

```js
// 舞蹈健身教学视频场景下使用，左手->右手，和受学者的手一致
components: [{
    name: 'RotateMirrorComponent',
    type: AliPlayerComponent.RotateMirrorComponent
}]
```



Keyid: LTAI5tJKfWCCd7uwCnkhYoaM

keyScrect: OFejxoxQmMGB5TlFYPj50GKtyb7CgS

InvalidAuthInfo.ExpireTime| 过期时间he specified parameter AuthInfo has expired.