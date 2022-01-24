# part25-短信服务和登录注册服务

# 1 阿里云短信服务

## 1.1 开通

![image-20211113092323414](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092323414.png)

## 1.2 添加签名

![image-20211113092344151](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092344151.png)

## 1.3 添加模板

![image-20211113092401720](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092401720.png)

## 1.4 套餐

free.aliyun.com![image-20211113092424472](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092424472.png)

## 1.5 快速学习

![image-20211113092445724](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092445724.png)

# 2 测试短信发送

## 2.1 查找使用示例

![image-20211113092509097](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092509097.png)

## 2.2 测试短信发送

![image-20211113092530986](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092530986.png)

## 2.3 查看发送结果

短信服务->业务统计->发送记录查询



# 3 使用容联云 实现短信服务 个人开发使用 下面会附上demo 代码清晰

## 3.1 首先注册容联云

注册成功 登录管理控制台 会有个人基本信息

![image-20211113092851868](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092851868.png)

**接下来就可以实操了**
首先进行相应配置 绑定到容联云 标题可以随意定义 但是下属的子标题要和容联云对应上 ip和端口必须和我图上一致

![image-20211113092921235](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113092921235.png)

## 3.2 然后就配置注入 代码业务实现

SmsService接口

。。。

SmsServiceImpl实现

。。。

容联云boot的实现博客

https://blog.csdn.net/qq_45628515/article/details/120247027

![image-20211113093841498](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113093841498.png)

免费开发测试短信服务: https://doc.yuntongxun.com/p/5a531a353b8496dd00dcdfe2



```shell
ACCOUNT SID：8aaf07087ce03b67017d16f1fabf0bde
auth_token: 8c922862617142d695ef0833610660f9
Rest URL(生产)：https://app.cloopen.com:8883
AppID(默认)：8aaf07087ce03b67017d16f1fbe00be4

```



# 4 创建短信微服务

## 4.1 创建项目 创建模块

service_sms

## 4.2 **配置 pom.xml**

```xml
<dependencies>
    <!--阿里云短信-->
    <dependency>
        <groupId>com.aliyun</groupId>
        <artifactId>aliyun-java-sdk-core</artifactId>
    </dependency>
</dependencies>
```



Backup: 容联云配置pom: 这是个开源jar包，可以直接aliyun源mvn下载

```xml
<!-- 容联云 短信 依赖-->
<dependency>
  <groupId>com.cloopen</groupId>
  <artifactId>java-sms-sdk</artifactId>
  <version>1.0.3</version>
</dependency>
<!--  配置文件处理器 让自定义的配置在application.yaml进行自动提示  -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-configuration-processor</artifactId>
  <optional>true</optional>
</dependency>
```





## 4.3 application.yml

resources目录下创建文件

```yaml
server:
  port: 8150 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-sms # 服务名
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
#spring: 
  redis:
    host: 192.168.100.100
    port: 6379
    database: 0
    password: 123456 #默认为空
    lettuce:
      pool:
        max-active: 20  #最大连接数，负值表示没有限制，默认8
        max-wait: -1    #最大阻塞等待时间，负值表示没限制，默认-1
        max-idle: 8     #最大空闲连接，默认8
        min-idle: 0     #最小空闲连接，默认0        
#阿里云短信
#aliyun:
#  sms:
#    regionId: cn-hangzhou
#    keyId: 你的keyid
#    keySecret: 你的keysecret
#    templateCode: 你的短信模板code
#    signName: 你的短信模板签名
    
#容联云短信
rckj:
  accountSId: 8aaf07087ce03b67017d16f1fabf0bde
  accountToken: 8c922862617142d695ef0833610660f9
  appId: 8aaf07087ce03b67017d16f1fbe00be4
  serverIp: app.cloopen.com
  serverPort: 8883
```







## 4.4 为子账户添加授权

AliyunDysmsFullAccess

## 4.5 logback-spring.xml

修改成sms

## 4.6 创建SpringBoot启动类

```java
package com.atguigu.guli.service.sms;

@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
@ComponentScan({"com.atguigu.guli"})
@EnableDiscoveryClient
public class ServiceSmsApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceSmsApplication.class, args);
    }
}

```



## 4.7 配置和工具

 (1)从配置文件读取常量
 创建常量读取工具类：SmsProperties.java

```java
package com.atguigu.guli.service.sms.util;

@Data
@Component
//注意prefix要写到最后一个 "." 符号之前
@ConfigurationProperties(prefix="aliyun.sms")
public class SmsProperties {
    private String regionId;
    private String keyId;
    private String keySecret;
    private String templateCode;
    private String signName;
}
```



## 4.8 引入工具类

common-util中引入工具类：RandomUtils.java、FormUtils.java



测试了一波容联云，把我整懵逼了

```shell
java.lang.NoSuchMethodError: com.google.gson.JsonParser.parseString(Ljava/lang/String;)Lcom/google/gson/JsonElement;

	at com.cloopen.rest.sdk.CCPRestSmsSDK.generateJson(CCPRestSmsSDK.java:314)
	at com.cloopen.rest.sdk.CCPRestSmsSDK.send(CCPRestSmsSDK.java:153)
	at com.cloopen.rest.sdk.CCPRestSmsSDK.sendTemplateSMS(CCPRestSmsSDK.java:115)
	at com.yunzoukj.yunzou.service.sms.service.impl.SmsServiceImpl.send(SmsServiceImpl.java:41)
	at com.yunzoukj.yunzou.service.sms.service.SendSmsTest.sendSmsTest(SendSmsTest.java:25)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
```

解决这个错误，第一步：修改gson版本到最新版

```java
<gson.version>2.8.9</gson.version>
```

重新启动sms模块

重新写测试方法

```java
 @Test
    void contextLoads() {

        //生产环境请求地址：app.cloopen.com
        String serverIp = "app.cloopen.com";
        //请求端口
        String serverPort = "8883";
        //主账号,登陆云通讯网站后,可在控制台首页看到开发者主账号ACCOUNT SID和主账号令牌AUTH TOKEN
        String accountSId = "8aaf07087ce03b67017d16f1fabf0bde";
        String accountToken = "8c922862617142d695ef0833610660f9";
        //请使用管理控制台中已创建应用的APPID
        String appId = "8aaf07087ce03b67017d16f1fbe00be4";
        CCPRestSmsSDK sdk = new CCPRestSmsSDK();
        sdk.init(serverIp, serverPort);
        sdk.setAccount(accountSId, accountToken);
        sdk.setAppId(appId);
        sdk.setBodyType(BodyType.Type_JSON);
        String to = "18974017944";
        String templateId= "1";
        //String[] datas = {"变量1(4位验证码)","变量2(请于x分钟内正确输入)","变量3"};
        String[] datas = {"9939","2","变量3"};
        String subAppend="1234";  //可选 扩展码，四位数字 0~9999
        String reqId="fadfafas";  //可选 第三方自定义消息id，最大支持32位英文数字，同账号下同一自然天内不允许重复
        //HashMap<String, Object> result = sdk.sendTemplateSMS(to,templateId,datas);
        HashMap<String, Object> result = sdk.sendTemplateSMS(to,templateId,datas,subAppend,reqId);
        if("000000".equals(result.get("statusCode"))){
            //正常返回输出data包体信息（map）
            HashMap<String,Object> data = (HashMap<String, Object>) result.get("data");
            Set<String> keySet = data.keySet();
            for(String key:keySet){
                Object object = data.get(key);
                System.out.println(key +" = "+object);
            }
        }else{
            //异常返回输出错误码和错误信息
            System.out.println("错误码=" + result.get("statusCode") +" 错误信息= "+result.get("statusMsg"));
        }

    }
```

运行之后，终于成功了

![image-20211113114420330](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211113114420330.png)





# 5 发送短信

## 5.1 创建controller 

ApiSmsController.java

```java
package com.atguigu.guli.service.sms.controller;

@RestController
@RequestMapping("/api/sms")
@Api(description = "短信管理")
@CrossOrigin //跨域
@Slf4j
public class ApiSmsController {
  
    @Autowired
    private SmsService smsService;
  
    @Autowired
    private RedisTemplate redisTemplate;
    @GetMapping("send/{mobile}")
    public R getCode(@PathVariable String mobile) throws ClientException {
        //校验手机号是否合法
        if(StringUtils.isEmpty(mobile) || !FormUtils.isMobile(mobile)) {
            log.error("请输入正确的手机号码 ");
            throw new GuliException(ResultCodeEnum.LOGIN_PHONE_ERROR);
        }
        //生成验证码
        String checkCode = RandomUtils.getFourBitRandom();
        //发送验证码
        smsService.send(mobile, checkCode);
        //将验证码存入redis缓存
        redisTemplate.opsForValue().set(mobile, checkCode, 5, TimeUnit.MINUTES);
        return R.ok().message("短信发送成功");
    }
}
```



容联云发送短信Controller

```java
@RestController
@RequestMapping("/api/sms")
@Api(description = "短信管理")
@CrossOrigin //跨域
@Slf4j
public class ApiSmsController {
  
    @Autowired
    private SmsService smsService;
  
    @Autowired
    private RedisTemplate redisTemplate;

    @GetMapping("send/{mobile}")
    public R getCode(@PathVariable String mobile) throws ClientException {
        //校验手机号是否合法
        if(StringUtils.isEmpty(mobile) || !FormUtils.isMobile(mobile)) {
            log.error("请输入正确的手机号码 ");
            throw new GuliException(ResultCodeEnum.LOGIN_PHONE_ERROR);
        }
        //生成验证码
        String checkCode = RandomUtils.getFourBitRandom();
        // 组装params参数的map
        HashMap<String, Object> map = new HashMap<>();
        map.put("code", checkCode);
        //发送验证码
        smsService.send(mobile, map);
        //将验证码存入redis缓存
        redisTemplate.opsForValue().set(mobile, checkCode, 5, TimeUnit.MINUTES); //5, TimeUnit.MINUTES)就是5分钟
        return R.ok().message("短信发送成功");
    }
}
```



重启sms服务，swagger测试成功

http://localhost:8150/swagger-ui.html



## 5.2 短信发送业务

接口：SmsService.java

```java
package com.atguigu.guli.service.sms.service;

public interface SmsService {
    void send(String mobile, String checkCode) throws ClientException;
}
```

实现：SmsServiceImpl.java

```java
package com.atguigu.guli.service.sms.service.impl;

@Service
@Slf4j
public class SmsServiceImpl implements SmsService {
  
    @Autowired
    private SmsProperties smsProperties;
  
    @Override
    public void send(String mobile, String checkCode) throws ClientException {
        //调用短信发送SDK，创建client对象
        DefaultProfile profile = DefaultProfile.getProfile(
                smsProperties.getRegionId(),
                smsProperties.getKeyId(),
                smsProperties.getKeySecret());
        IAcsClient client = new DefaultAcsClient(profile);
        //组装请求参数
        CommonRequest request = new CommonRequest();
        request.setSysMethod(MethodType.POST);
        request.setSysDomain("dysmsapi.aliyuncs.com");
        request.setSysVersion("2017-05-25");
        request.setSysAction("SendSms");
        request.putQueryParameter("RegionId", smsProperties.getRegionId());
        request.putQueryParameter("PhoneNumbers", mobile);
        request.putQueryParameter("SignName", smsProperties.getSignName());
        request.putQueryParameter("TemplateCode", smsProperties.getTemplateCode());
        Map<String, Object> param = new HashMap<>();
        param.put("code", checkCode);
        //将包含验证码的集合转换为json字符串
        Gson gson = new Gson();
        request.putQueryParameter("TemplateParam", gson.toJson(param));
        //发送短信
        CommonResponse response = client.getCommonResponse(request);
        //得到json字符串格式的响应结果
        String data = response.getData();
        //解析json字符串格式的响应结果
        HashMap<String, String> map = gson.fromJson(data, HashMap.class);
        String code = map.get("Code");
        String message = map.get("Message");
        //配置参考：短信服务->系统设置->国内消息设置
        //错误码参考：
        //https://help.aliyun.com/document_detail/101346.html?spm=a2c4g.11186623.6.613.3f6e2246sDg6Ry
        //控制所有短信流向限制（同一手机号：一分钟一条、一个小时五条、一天十条）
        if ("isv.BUSINESS_LIMIT_CONTROL".equals(code)) {
            log.error("短信发送过于频繁 " + "【code】" + code + ", 【message】" + message);
            throw new GuliException(ResultCodeEnum.SMS_SEND_ERROR_BUSINESS_LIMIT_CONTROL);
        }
        if (!"OK".equals(code)) {
            log.error("短信发送失败 " + " - code: " + code + ", message: " + message);
            throw new GuliException(ResultCodeEnum.SMS_SEND_ERROR);
        }
    }
}
```



# 6 实现用户注册功能

## 6.1 数据库设计

创建数据库：guli_ucenter

编码：utf8mb4

排序：utf8mb4_general_ci

```sql
create database db_yunzoukj_ucenter DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```



## 6.2 **数据表**

执行sql脚本

guli_ucenter.sql

# 7 创建用户中心微服务

## 7.1 创建模块

Artifact：service_ucenter

## 7.2 **配置 pom.xml**

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

## 7.3 配置application.yml

```yaml
server:
  port: 8160 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-ucenter # 服务名
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos服务地址
#spring:
  redis:
    host: 192.168.100.100
    port: 6379
    database: 0
    password: 123456 #默认为空
    lettuce:
      pool:
        max-active: 20  #最大连接数，负值表示没有限制，默认8
        max-wait: -1    #最大阻塞等待时间，负值表示没限制，默认-1
        max-idle: 8     #最大空闲连接，默认8
        min-idle: 0     #最小空闲连接，默认0
  datasource: # mysql数据库连接
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/guli_ucenter?serverTimezone=GMT%2B8
    username: root
    password: 123456
#spring:
  jackson: #返回json的全局时间格式
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl #mybatis日志
  mapper-locations: classpath:com/atguigu/guli/service/ucenter/mapper/xml/*.xml
```

## 7.4 logback-spring.xml

修改日志路径为 guli_log/ucenter

## 7.5 创建启动类

创建ServiceUcenterApplication.java

```java
package com.yunzoukj.yunzou.service.ucenter;

@SpringBootApplication
@ComponentScan({"com.atguigu.guli"})
@EnableDiscoveryClient
public class ServiceUcenterApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceUcenterApplication.class, args);
    }
}
```



## 7.6 MP代码生成器



# 8 用户注册

## 8.1 后端接口 引入工具类

common-util中引入工具类：MD5.java

## 8.2 定义RegisterVo

```java
package com.atguigu.guli.service.ucenter.entity.vo;
@Data
public class RegisterVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String nickname;
    private String mobile;
    private String password;
    private String code;
}
```

## 8.3 web层

创建ApiMemberController

```java
package com.atguigu.guli.service.ucenter.controller.api;

@Api(description = "会员管理")
@CrossOrigin
@RestController
@RequestMapping("/api/ucenter/member")
@Slf4j
public class ApiMemberController {
    @Autowired
    private MemberService memberService;
    @ApiOperation(value = "会员注册")
    @PostMapping("register")
    public R register(@RequestBody RegisterVo registerVo){
        memberService.register(registerVo);
        return R.ok();
    }
}
```

## 8.4 service层

接口：MemberService

```java
void register(RegisterVo registerVo);
```

实现：MemberServiceImpl

```java
@Autowired
private RedisTemplate redisTemplate;
/**
     * 会员注册
     * @param registerVo
     */
@Transactional(rollbackFor = Exception.class)
@Override
public void register(RegisterVo registerVo) {
    String nickname = registerVo.getNickname();
    String mobile = registerVo.getMobile();
    String password = registerVo.getPassword();
    String code = registerVo.getCode();
    //校验参数
    if (StringUtils.isEmpty(mobile)
        || !FormUtils.isMobile(mobile)
        || StringUtils.isEmpty(password)
        || StringUtils.isEmpty(code)
        || StringUtils.isEmpty(nickname)) {
        throw new GuliException(ResultCodeEnum.PARAM_ERROR);
    }
    //校验验证码
    String checkCode = (String)redisTemplate.opsForValue().get(mobile);
    if(!code.equals(checkCode)){
        throw new GuliException(ResultCodeEnum.CODE_ERROR);
    }
    //是否被注册
    QueryWrapper<Member> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("mobile", mobile);
    Integer count = baseMapper.selectCount(queryWrapper);
    if(count > 0){
        throw new GuliException(ResultCodeEnum.REGISTER_MOBLE_ERROR);
    }
    //注册
    Member member = new Member();
    member.setNickname(nickname);
    member.setMobile(mobile);
    member.setPassword(MD5.encrypt(password));
    member.setDisabled(false);
    member.setAvatar("https://guli-file-helen.oss-cn-beijing.aliyuncs.com/avatar/default.jpg");
    baseMapper.insert(member);
}
```

# 9 前端

## 9.1 api

创建 api/register.js

```js
import request from '~/utils/request'
export default {
  sendMessage(mobile) {
    return request({
      baseURL: 'http://localhost:8150',
      url: `/api/sms/send/${mobile}`,
      method: 'get'
    })
  },
  register(member) {
    return request({
      baseURL: 'http://localhost:8160',
      url: '/api/ucenter/member/register',
      method: 'post',
      data: member
    })
  }
}
```

## 9.2 获取验证码

pages/register.vue

```js
import registerApi from '~/api/register'
```

```js
// 获取验证码
getCodeFun() {
  // this.sending原为false,
  // 点击后立即使 this.sending == true，防止有人多次点击
  if (this.sending) { return }
  this.sending = true
  registerApi.sendMessage(this.member.mobile).then(response => {
    this.timeDown()
    this.$message({
      type: 'success',
      message: '短信发送成功'
    })
  })
},
// 倒计时
timeDown() {
  const result = setInterval(() => {
    this.codeText = this.second
    this.second--
    if (this.second < 0) {
      clearInterval(result)
      this.sending = false
      this.second = 60
      this.codeText = '获取验证码'
    }
  }, 1000)
},
```

## 9.3 注册

```javascript
// 注册
submitRegister() {
    memberApi.register(this.member).then(response => {
        // 提示注册成功
        this.$message({
            type: 'success',
            message: '注册成功'
        })
        this.$router.push({ path: '/login' })
    })
}
```



最后，想把项目完整无错的启动起来，是有技巧的，先不管前台门户，先把后端服务按照开发顺序一个个稳定的启动起来，最后在启动前台门户，不然的话会只有一句话：next server error,你自己找bug去吧



因为一小时内测试了好几次 容联云开发免费测试api，现在直接超时了，拒绝了，只能等明天早上来一波全站的完整的注册用户测试了