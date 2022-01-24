# part28-oauth2微信扫码登录

# 1 OAuth2解决什么问题

## 1.1 开放系统间授权

照片拥有者想要在云冲印服务上打印照片，云冲印服务需要访问云存储服务上的资源

![image-20211115104534698](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104534698.png)

## 1.2 图例

资源拥有者：照片拥有者

客户应用：云冲印

受保护的资源：照片![image-20211115104600629](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104600629.png)

## 1.3 方式一：用户名密码复制

![image-20211115104618678](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104618678.png)

用户将自己的"云存储"服务的用户名和密码，告诉"云冲印"，（即资源服务器的用户名和密码存储在客户应用服务器上）后者就可以读取用户的照片了。这样的做法有以下几个严重的缺点。

（1）"云冲印"为了后续的服务，会保存用户的密码，这样很不安全。

（2）Google不得不部署密码登录，而我们知道，单纯的密码登录并不安全。

（3）"云冲印"拥有了获取用户储存在Google所有资料的权力，用户没法限制"云冲印"获得授权的范围和有效期。

（4）用户只有修改密码，才能收回赋予"云冲印"的权力。但是这样做，会使得其他所有获得用户授权的第三方应用程序全部失效。

（5）只要有一个第三方应用程序被破解，就会导致用户密码泄漏，以及所有被密码保护的数据泄漏。

**总结：**

将受保护的资源中的用户名和密码存储在客户应用的服务器上，使用时直接使用这个用户名和密码登录

适用于同一公司内部的多个系统，不适用于不受信的第三方应用

## 1.4 方式二：通用开发者key

key是事先在"云存储"服务和"云冲印"服务间约定好的，适用于合作商或者授信的不同业务部门之间

![image-20211115104650944](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104650944.png)

## 1.5 方式三：颁发令牌

需要考虑如何管理令牌、颁发令牌、吊销令牌，需要统一的申请令牌和颁发令牌的协议

![image-20211115104709671](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104709671.png)

**令牌类比仆从钥匙**![image-20211115104723050](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104723050.png)

# 2 OAuth2简介

## 2.1 OAuth主要角色

![image-20211115104745473](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104745473.png)

## 2.2 最简向导

川崎高彦：OAuth2领域专家，开发了一个OAuth2 sass服务，OAuth2 as Service，并且做成了一个公司

在融资的过程中为了向投资人解释OAuth2是什么，于是写了一篇文章，《OAuth2最简向导》



# 3 OAuth2的应用

## 3.1 微服务安全

现代微服务中系统微服务化以及应用的形态和设备类型增多，不能用传统的登录方式

核心的技术不是用户名和密码，而是token，由AuthServer颁发token，用户使用token进行登录

![image-20211115104826054](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104826054.png)

## 3.2 社交登录

![image-20211115104841010](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104841010.png)

# 4 生成授权url

## 4.1 **准备工作** 注册

- 微信开放平台：https://open.weixin.qq.com

## 4.2 邮箱激活

## 4.3 完善开发者资料

## 4.4 开发者资质认证

准备营业执照，1-2个工作日审批、300元

## 4.5 创建网站应用

提交审核，7个工作日审批

## 4.6 熟悉微信登录流程

参考文档：https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419316505&token=e547653f995d8f402704d5cb2945177dc8aa4e7e&lang=zh_CN

**获取access_token时序图**

![image-20211115104957952](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115104957952.png)

第一步：请求CODE（生成授权URL）

第二步：通过code获取access_token（开发回调URL）



# 5 后端开发

service_ucenter微服务

## 5.1 添加配置

application.yml添加相关配置信息

```yaml
wx:
  open:
    # 微信开放平台 appid
    appId: wxed9954c01bb89b47
    # 微信开放平台 appsecret
    appSecret: a7482517235173ddb4083788de60b90e
    # 微信开放平台 重定向url（guli.shop需要在微信开放平台配置）
    redirectUri: http://guli.shop/api/ucenter/wx/callback8160
```

## 5.2 **创建常量类**

创建util包，创建UcenterProperties.java类

```java
package com.atguigu.guli.service.ucenter.util;

@Data
@Component
//注意prefix要写到最后一个 "." 符号之前
@ConfigurationProperties(prefix="wx.open")
public class UcenterProperties {
    private String appId;
    private String appSecret;
    private String redirectUri;
}

```

## 5.3 创建controller

```java
package com.atguigu.guli.service.ucenter.controller.api;
@CrossOrigin
@Controller//注意这里没有配置 @RestController
@RequestMapping("/api/ucenter/wx")
@Slf4j
public class ApiWxController {
    @Autowired
    private UcenterProperties ucenterProperties;
    @GetMapping("login")
    public String genQrConnect(HttpSession session){
        String baseUrl = "https://open.weixin.qq.com/connect/qrconnect" +
                "?appid=%s" +
                "&redirect_uri=%s" +
                "&response_type=code" +
                "&scope=snsapi_login" +
                "&state=%s" +
                "#wechat_redirect";
        //处理回调url
        String redirecturi = "";
        try {
            redirecturi = URLEncoder.encode(ucenterProperties.getRedirectUri(), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.URL_ENCODE_ERROR);
        }
        //处理state：生成随机数，存入session
        String state = UUID.randomUUID().toString();
        log.info("生成 state = " + state);
        session.setAttribute("wx_open_state", state);
        String qrcodeUrl = String.format(
                baseUrl,
                ucenterProperties.getAppId(),
                redirecturi,
                state
        );
        return "redirect:" + qrcodeUrl;
    }
 }
```

授权url参数说明

| 参数          | 是否必须 | 说明                                                         |
| ------------- | -------- | ------------------------------------------------------------ |
| appid         | 是       | 应用唯一标识                                                 |
| redirect_uri  | 是       | 请使用urlEncode对链接进行处理                                |
| response_type | 是       | 填code                                                       |
| scope         | 是       | 应用授权作用域，拥有多个作用域用逗号（,）分隔，网页应用目前仅填写snsapi_login即 |
| state         | 否       | 用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验 |

## 5.4 测试

访问：访问以下授权url后会得到一个微信登录二维码

[http://localhost:8160/api/ucenter/wx/login](http://helen.free.idcfengye.com/api/ucenter/wx/login)



## 5.5 前端整合登录超链接

pages/login.vue和register.vue中替换微信登录的超链接

# 6 集成Spring Session

使用spring session实现分布式session共享，对原有代码无侵入，自动在redis中存储session信息

## 6.1 service_ucenter中添加依赖

```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>
```

## 6.2 service_ucenter中添加配置文件

```java
package com.atguigu.guli.service.base.config;
@Configuration
@EnableRedisHttpSession
public class HttpSessionConfig {
    //可选配置
    @Bean
    public CookieSerializer cookieSerializer() {
        DefaultCookieSerializer serializer = new DefaultCookieSerializer();
        //我们可以将Spring Session默认的Cookie Key从SESSION替换为原生的JSESSIONID
        serializer.setCookieName("JSESSIONID");
        // CookiePath设置为根路径
        serializer.setCookiePath("/");
        // 配置了相关的正则表达式，可以达到同父域下的单点登录的效果
        serializer.setDomainNamePattern("^.+?\\.(\\w+\\.[a-z]+)$");
        return serializer;
    }
}
```

# 7 回调方式说明

## 7.1 回调方法定义

ApiWxController中添加方法

```java

@GetMapping("callback")
public String callback(String code, String state){
    //回调被拉起，并获得code和state参数
    System.out.println("callback被调用");
    System.out.println("code = " + code);
    System.out.println("state = " + state);
    return null;
}
```

用户点击“确认登录”后，微信服务器会向谷粒学院的业务服务器发起回调，回调地址就是yml中配置的redirecturi

## 7.2 发起回调的方式

(1)方式一：内网穿透

**步骤：**开通并启动内网穿透ngrok-->开放平台配置回调地址-->yml配置

**开放平台配置：**

![image-20211115105431272](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115105431272.png)

**yml配置：**

```yaml
wx:
  open:
    # 微信开放平台 appid
    appId: wxc606fb748aedee7c
    # 微信开放平台 appsecret
    appSecret: 073e8e1117c1054b14586c8aa922bc9c
    # 微信开放平台 重定向url（guli.shop需要在微信开放平台配置）
    redirectUri: http://imhelen.free.idcfengye.com/api/ucenter/wx/callback
```

**注意：**yml文件中redirecturi的域名必须和开放平台中应用配置的授权回调域的值完全一致，

但是开放平台上的一个应用只能配置一个回调地址，提供给一个开发者使用

(2)方式二：外网服务器跳转

解决多人无法共享回调域设置的问题。

**步骤：**将跳转程序部署到外网服务器-->开放平台配置回调地址-->yml配置

**跳转程序：部署在guli.shop上**

guli.shop服务器的接口可以接收微信的回调请求，将微信回调请求转发到开发者的localhost的8160端口，并传递code和state参数

**开放平台配置\**：\****

授权回调域一般设置为一个内网穿透地址，例如使用ngrok工具申请一个内网穿透地止

![image-20211115105534695](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211115105534695.png)

```yaml
#yml配置：
wx:
  open:
    # 微信开放平台 appid
    appId: wxed9954c01bb89b47
    # 微信开放平台 appsecret
    appSecret: a7482517235173ddb4083788de60b90e
    # 微信开放平台 重定向url（guli.shop需要在微信开放平台配置）
    redirectUri: http://guli.shop/api/ucenter/wx/callback8160
```

# 8 测试回调跳转服务器

访问回调服务器

[http://guli.shop](http://guli.shop/api/)[/api/ucenter/wx/callback8160?code=1234&state=666](http://localhost:8150/api/ucenter/wx/callback?code=1234&state=666)

跳转到

http://localhost:8160/api/ucenter/wx/callback?code=1234&state=666



# 9 开发回调url

## 9.1 准备 httpclient工具类

放入common_util项目的util包

HttpClientUtils.java

## 9.2 pom依赖

common_util项目中加入依赖

```xml
<!--httpclient-->
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
</dependency>
```

# 10 获取**access_token**

在WxApiController.java中添加如下方法

```java
@GetMapping("callback")
public String callback(String code, String state, HttpSession session){
    //回调被拉起，并获得code和state参数
    log.info("callback被调用");
    log.info("code = " + code);
    log.info("state = " + state);
    if(StringUtils.isEmpty(code) || StringUtils.isEmpty(state) ){
        log.error("非法回调请求");
        throw new GuliException(ResultCodeEnum.ILLEGAL_CALLBACK_REQUEST_ERROR);
    }
    String sessionState = (String)session.getAttribute("wx_open_state");
    if(!state.equals(sessionState)){
        log.error("非法回调请求");
        throw new GuliException(ResultCodeEnum.ILLEGAL_CALLBACK_REQUEST_ERROR);
    }
    //携带授权临时票据code，和appid以及appsecret请求access_token
    String accessTokenUrl = "https://api.weixin.qq.com/sns/oauth2/access_token";
    Map<String, String> accessTokenParam = new HashMap();
    accessTokenParam.put("appid", ucenterProperties.getAppId());
    accessTokenParam.put("secret", ucenterProperties.getAppSecret());
    accessTokenParam.put("code", code);
    accessTokenParam.put("grant_type", "authorization_code");
    HttpClientUtils client = new HttpClientUtils(accessTokenUrl, accessTokenParam);
    String result = "";
    try {
        //发送请求
        client.get();
        result = client.getContent();
        System.out.println("result = " + result);
    } catch (Exception e) {
        log.error("获取access_token失败");
        throw new GuliException(ResultCodeEnum.FETCH_ACCESSTOKEN_FAILD);
    }
    Gson gson = new Gson();
    HashMap<String, Object> resultMap = gson.fromJson(result, HashMap.class);
    //判断微信获取access_token失败的响应
    Object errcodeObj = resultMap.get("errcode");
    if(errcodeObj != null){
        String errmsg = (String)resultMap.get("errmsg");
        Double errcode = (Double)errcodeObj;
        log.error("获取access_token失败 - " + "message: " + errmsg + ", errcode: " + errcode);
        throw new GuliException(ResultCodeEnum.FETCH_ACCESSTOKEN_FAILD);
    }
    //微信获取access_token响应成功
    String accessToken = (String)resultMap.get("access_token");
    String openid = (String)resultMap.get("openid");
    log.info("accessToken = " + accessToken);
    log.info("openid = " + openid);
    //根据access_token获取微信用户的基本信息
    // TODO
    return null;
}
```

# 11 获取用户信息

## 11.1 根据openid查询用户是否已注册

业务接口：MemberService.java

```java
/**
     * 根据openid返回用户信息
     * @param openid
     * @return
     */
Member getByOpenid(String openid);
```

业务实现：MemberServiceImpl.java

```java
@Override
public Member getByOpenid(String openid) {
    QueryWrapper<Member> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("openid", openid);
    return baseMapper.selectOne(queryWrapper);
}
```

## 11.2 **根据access_token获取用户信息**

```java
@Autowired
private MemberService memberService;
@GetMapping("callback")
public String callback(String code, String state, HttpSession session){
    ............
       //根据access_token获取微信用户的基本信息
        //根据openid查询当前用户是否已经使用微信登录过该系统
        Member member = memberService.getByOpenid(openid);
        if(member == null){
            //向微信的资源服务器发起请求，获取当前用户的用户信息
            String baseUserInfoUrl = "https://api.weixin.qq.com/sns/userinfo";
            Map<String, String> baseUserInfoParam = new HashMap();
            baseUserInfoParam.put("access_token", accessToken);
            baseUserInfoParam.put("openid", openid);
            client = new HttpClientUtils(baseUserInfoUrl, baseUserInfoParam);
            String resultUserInfo = null;
            try {
                client.get();
                resultUserInfo = client.getContent();
            } catch (Exception e) {
                log.error(ExceptionUtils.getMessage(e));
                throw new GuliException(ResultCodeEnum.FETCH_USERINFO_ERROR);
            }
            HashMap<String, Object> resultUserInfoMap = gson.fromJson(resultUserInfo, HashMap.class);
            if(resultUserInfoMap.get("errcode") != null){
                log.error("获取用户信息失败" + "，message：" + resultMap.get("errmsg"));
                throw new GuliException(ResultCodeEnum.FETCH_USERINFO_ERROR);
            }
            String nickname = (String)resultUserInfoMap.get("nickname");
            String headimgurl = (String)resultUserInfoMap.get("headimgurl");
            Double sex = (Double)resultUserInfoMap.get("sex");
            //用户注册
            member = new Member();
            member.setOpenid(openid);
            member.setNickname(nickname);
            member.setAvatar(headimgurl);
            member.setSex(sex.intValue());
            memberService.save(member);
        }
        JwtInfo jwtInfo = new JwtInfo();
        jwtInfo.setId(member.getId());
        jwtInfo.setNickname(member.getNickname());
        jwtInfo.setAvatar(member.getAvatar());
        String jwtToken = JwtUtils.getJwtToken(jwtInfo, 1800);
        //携带token跳转
        return "redirect:http://localhost:3000?token=" + jwtToken;
}
```

# 12 前端整合

components/AppHeader.vue

```java
mounted() {
    // 微信登录url token获取
    this.token = this.$route.query.token
    if (this.token) {
        // 将token存在cookie中
        cookie.set('guli_jwt_token', this.token, { domain: 'localhost' })
        // 跳转页面：擦除url中的token
        // 注意：window对象在created方法中无法被访问，因此要写在mounted中
        window.location.href = '/'
    }
},
```

