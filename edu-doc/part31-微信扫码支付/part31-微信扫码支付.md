# part31-微信扫码支付

# 1 **方式一** 开通微信支付

**第一步：注册公众号**

https://mp.weixin.qq.com/ 类型须为：服务号

请根据营业执照类型选择以下主体注册：个体工商户| 企业/公司| 政府| 媒体| 其他类型

**第二步：认证公众号**

公众号认证后才可申请微信支付，认证费：300元/次。

**第三步：注册商户号**

https://pay.weixin.qq.com PC网站接入支付

**第四步：账户验证**

step1：汇款验证

step2：等待审核，1-2个工作日

![image-20211117175005624](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211117175005624.png)

**第五步：签署协议**

![image-20211117175030458](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211117175030458.png)

**第六步：关联APPID**

将微信公众号appid关联至商户平台：

产品中心 ==> APPID授权管理 ==> 申请账号关联

**第七步：设置API秘钥**

账户中心 ==>API安全 ==> API秘钥 ==> 设置API秘钥





# 2 方式二，开通微信支付

**第一步：注册公众号**

https://mp.weixin.qq.com/ 类型须为：服务号

请根据营业执照类型选择以下主体注册：个体工商户| 企业/公司| 政府| 媒体| 其他类型

**第二步：认证公众号**

公众号认证后才可申请微信支付，认证费：300元/次。

**第三步：提交资料申请微信支付**

登录公众平台，点击左侧菜单【微信支付】，开始填写资料等待审核，审核时间为1-5个工作日内。

**第四步：开户成功，登录商户平台进行账户验证**

资料审核通过后，请登录联系人邮箱查收商户号和密码，并登录商户平台填写财付通备付金打的小额资金数额，完成账户验证。

**第五步：签署协议**

本协议为线上电子协议，签署后方可进行交易及资金结算，签署完立即生效。

第六步：设置API秘钥账户中心 ==>API安全 ==> API秘钥 ==> 设置API秘钥



# 3 开发文档

## 3.1 **场景介绍**

参考官方文档：https://pay.weixin.qq.com/wiki/doc/api/index.html Native支付

用户扫描商户展示在各种场景的二维码进行支付。

**步骤1：**商户根据微信支付的规则，为不同商品生成不同的二维码，展示在各种场景，用于用户扫描购买。

**步骤2：**用户使用微信“扫一扫”扫描二维码后，获取商品支付信息，引导用户完成支付。

**步骤3：**用户确认支付，输入支付密码。

**步骤4：**支付完成后会提示用户支付成功，商户后台得到支付成功的通知。

# 4 开发步骤

**推荐使用模式二**

## 4.1 模式一

参考流程：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_4

商户后台系统根据微信支付规则链接生成二维码，链接中带固定参数productid（可定义为产品标识或订单号）。用户扫码后，微信支付系统将productid和用户唯一标识(openid)回调商户后台系统(需要设置支付回调URL)，商户后台系统根据productid生成支付交易，最后微信支付系统发起用户支付流程。

## 4.2 模式二

参考流程：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_5（时序图中红色部分是需要我们开发的内容）

模式二与模式一相比，流程更为简单，不依赖设置的回调支付URL。商户后台系统先调用微信支付的统一下单接口，微信后台系统返回链接参数code_url，商户后台系统将code_url值生成二维码图片，用户使用微信客户端扫码后发起支付。注意：code_url有效期为2小时，过期后扫码不能再发起支付。

# 5 **微信支付接口规则**

微信支付接口调用的整体思路：按API要求组装参数，以XML方式发送（POST）给微信支付接口（URL）,微信支付接口也是以XML方式给予响应。

了解参考官方文档：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=4_1



- 协议规则
- 参数规定
- 安全规范

使用sdk可以简化接口的调用



# 6 生成支付二维码并且支付

## 6.1 准备 添加微信支付SDK

**方式一：**service_trade中添加依赖：

```xml
<dependencies>
    <!--微信支付-->
    <dependency>
        <groupId>com.github.wxpay</groupId>
        <artifactId>wxpay-sdk</artifactId>
        <version>0.0.3</version>
    </dependency>
</dependencies>
```

**方式二：**将下载的sdk源码放入service_trade源码目录中

![image-20211117175355130](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211117175355130.png)

## 6.2 配置yml参数

支付账户相关参数：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=3_1

```yaml
weixin:
  pay:
    #关联的公众号appid
    appId: wxf913bfa3a2c7eeeb
    #商户号
    partner: 1543338551
    #商户key
    partnerKey: atguigu3b0kn9g5v426MKfHQH7X8rKwb
    #回调地址
    notifyUrl: http://imhelen.free.idcfengye.com/api/trade/weixin-pay/callback/notify 
```

**配置后启动ngrok内网穿透工具**

## 6.3 **参数读取工具类**

```java
package com.atguigu.guli.service.trade.util;

@Data
@Component
@ConfigurationProperties(prefix="weixin.pay")
public class WeixinPayProperties {
    private String appId;
    private String partner;
    private String partnerKey;
    private String notifyUrl;
}
```

## 6.4 辅助业务方法

OrderService：getOrderByOrderNo 根据订单号查询订单

接口：

```java
Order getOrderByOrderNo(String orderNo);
```

实现：

```java
public Order getOrderByOrderNo(String orderNo) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("order_no", orderNo);
    return baseMapper.selectOne(queryWrapper);
}
```

# 7 生成支付二维码

## 7.1 统一下单接口文档

https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1

调用统一下单接口，根据返回值中的code_url在前端使用javascript工具生成支付二维码

## 7.2 业务层

接口：创建 WeixinPayService：createNative

```java
package com.atguigu.guli.service.order.service;
public interface WeixinPayService {
    Map<String, Object> createNative(String orderNo, String remoteAddr);
}
```

实现：

```java
package com.atguigu.guli.service.trade.service.impl;

@Service
@Slf4j
public class WeixinPayServiceImpl implements WeixinPayService {
    @Autowired
    private OrderService orderService;
    @Autowired
    private WeixinPayProperties weixinPayProperties;
    @Override
    public Map<String, Object> createNative(String orderNo, String remoteAddr) {
        try{
            //根据课程订单号获取订单
            Order order = orderService.getOrderByOrderNo(orderNo);
            //调用微信api接口：统一下单（支付订单）
            HttpClientUtils client = new HttpClientUtils("https://api.mch.weixin.qq.com/pay/unifiedorder");
            //组装接口参数
            Map<String, String> params = new HashMap<>();
            params.put("appid", weixinPayProperties.getAppId());//关联的公众号的appid
            params.put("mch_id", weixinPayProperties.getPartner());//商户号
            params.put("nonce_str", WXPayUtil.generateNonceStr());//生成随机字符串
            params.put("body", order.getCourseTitle());
            params.put("out_trade_no", orderNo);
            //注意，这里必须使用字符串类型的参数（总金额：分）
            String totalFee = order.getTotalFee().intValue() + "";
            params.put("total_fee", totalFee);
            params.put("spbill_create_ip", remoteAddr);
            params.put("notify_url", weixinPayProperties.getNotifyUrl());
            params.put("trade_type", "NATIVE");
            //将参数转换成xml字符串格式：生成带有签名的xml格式字符串
            String xmlParams = WXPayUtil.generateSignedXml(params, weixinPayProperties.getPartnerKey());
            log.info("\n xmlParams：\n" + xmlParams);
            client.setXmlParam(xmlParams);//将参数放入请求对象的方法体
            client.setHttps(true);//使用https形式发送
            client.post();//发送请求
            String resultXml = client.getContent();//得到响应结果
            log.info("\n resultXml：\n" + resultXml);
            //将xml响应结果转成map对象
            Map<String, String> resultMap = WXPayUtil.xmlToMap(resultXml);
            //错误处理
            if("FAIL".equals(resultMap.get("return_code")) || "FAIL".equals(resultMap.get("result_code"))){
                log.error("微信支付统一下单错误 - "
                        + "return_code: " + resultMap.get("return_code")
                        + "return_msg: " + resultMap.get("return_msg")
                        + "result_code: " + resultMap.get("result_code")
                        + "err_code: " + resultMap.get("err_code")
                        + "err_code_des: " + resultMap.get("err_code_des"));
                throw new GuliException(ResultCodeEnum.PAY_UNIFIEDORDER_ERROR);
            }
            //组装需要的内容
            Map<String, Object> map = new HashMap<>();
            map.put("result_code", resultMap.get("result_code"));//响应码
            map.put("code_url", resultMap.get("code_url"));//生成二维码的url
            map.put("course_id", order.getCourseId());//课程id
            map.put("total_fee", order.getTotalFee());//订单总金额
            map.put("out_trade_no", orderNo);//订单号
            return map;
        } catch (Exception e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.PAY_UNIFIEDORDER_ERROR);
        }
    }
}
```



## 7.3 web层

创建 ApiWeixinPayController：createNative

```java
package com.atguigu.guli.service.trade.controller.api;

@RestController
@RequestMapping("/api/trade/weixin-pay")
@Api(description = "网站微信支付")
@CrossOrigin //跨域
@Slf4j
public class ApiWeixinPayController {
    @Autowired
    private WeixinPayService weixinPayService;
    @GetMapping("create-native/{orderNo}")
    public R createNative(@PathVariable String orderNo, HttpServletRequest request) {
        String remoteAddr = request.getRemoteAddr();
        Map map = weixinPayService.createNative(orderNo, remoteAddr);
        return R.ok().data(map);
    }
}
```



# 8 **支付前端**

## 8.1 安装二维码生成器

```js
npm install vue-qriously@1.1.1
```

## 8.2 配置插件

在plugins下创建vue-qriously-plugin.js

```js
import Vue from 'vue'
import VueQriously from 'vue-qriously'
Vue.use(VueQriously)
```

nuxt.config.js中配置

```js
plugins: [
    { src: '~/plugins/vue-qriously-plugin.js', ssr: true }
],
```

## 8.3 api

创建 api/pay.js

```js
import request from '~/utils/request'

export default {
  createNative(orderNo) {
    return request({
      baseURL: 'http://localhost:8170',
      url: `/api/trade/weixin-pay/create-native/${orderNo}`,
      method: 'get'
    })
  }
}
```

## 8.4 订单页面

html：

```html
<el-button :disabled="!agree" type="danger" @click="toPay()">去支付</el-button>
```

脚本：

```js

methods: {
    toPay() {
        if (this.agree) {
            this.$router.push({ path: '/pay/' + this.order.orderNo })
        }
    }
}

```

## 8.5 支付页面

创建pages/pay/_id.vue

```html
<template>
  <div class="cart py-container">
    <!--主内容-->
    <div class="checkout py-container  pay">
      <div class="checkout-tit" style="width: 1050px; margin: 0 auto; padding: 10px 0;">
        <h4 class="fl tit-txt"><span class="success-info">支付申请提交成功，请您及时付款！订单号：{{ payObj.out_trade_no }}</span>
        </h4>
        <span class="fr"><em class="sui-lead">应付金额：</em><em class="orange money">￥{{ payObj.total_fee/100 }}</em></span>
        <div class="clearfix"/>
      </div>
      <div class="checkout-steps">
        <div class="fl weixin">微信支付</div>
        <div class="fl sao">
          <div class="fl code">
            <!-- <img id="qrious" src="~/assets/img/erweima.png" alt=""> -->
            <qriously :value="payObj.code_url" :size="338"/>
          </div>
          <div style="color: red; text-align:center;">请使用微信扫一扫</div>  
        </div>
        <div class="clearfix"/>
        <!-- <p><a href="pay.html" target="_blank"> 其他支付方式</a></p> -->
      </div>
    </div>
  </div>
</template>
<script>
import payApi from '~/api/pay'
export default {
  async asyncData(page) {
    const response = await payApi.createNative(page.route.params.id)
    return {
      payObj: response.data
    }
  }
  // 在created中获取数据，报告Invalid prop: type check failed for prop "value".
  // created() {
  //   payApi.createNative(this.$route.params.id).then(response => {
  //     this.payObj = response.data
  //   })
  // }
}
</script>
```



# 9 支付回调

## 9.1 准备 配置ngrok

将ngrok映射到本地8170端口，并启动

## 9.2 添加工具类

在common_util中添加工具类

```java
StreamUtils.java
```



# 10 **支付回调**

## 10.1 **回调方法**

该链接是通过【统一下单API】中提交的参数notify_url设置，如果链接无法访问，商户将无法接收到微信通知。

参考文档：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_7&index=8

ApiWeixinPayController

```java
@Autowired
private WeixinPayProperties weixinPayProperties;
@Autowired
private OrderService orderService;
/**
     * 支付回调：注意这里是【post】方式
     */
@PostMapping("callback/notify")
public String wxNotify(HttpServletRequest request, HttpServletResponse response) throws Exception {
    System.out.println("callback/notify 被调用");
    // 获得通知结果
    ServletInputStream inputStream = request.getInputStream();
    String notifyXml = StreamUtils.inputStream2String(inputStream, "utf-8");
    System.out.println("xmlString = " + notifyXml);
    // 定义响应对象
    HashMap<String, String> returnMap = new HashMap<>();
    // 签名验证：防止伪造回调
    if (WXPayUtil.isSignatureValid(notifyXml, weixinPayProperties.getPartnerKey())) {
        // 解析返回结果
        Map<String, String> notifyMap = WXPayUtil.xmlToMap(notifyXml);
        //判断支付是否成功
        if("SUCCESS".equals(notifyMap.get("result_code"))){
            // 校验订单金额是否一致
            String totalFee = notifyMap.get("total_fee");
            String outTradeNo = notifyMap.get("out_trade_no");
            Order order = orderService.getOrderByOrderNo(outTradeNo);
            if(order != null && order.getTotalFee().intValue() == Integer.parseInt(totalFee)){
                // 判断订单状态：保证接口调用的幂等性，如果订单状态已更新直接返回成功响应
                // 幂等性：无论调用多少次结果都是一样的
                if(order.getStatus() == 1){
                    returnMap.put("return_code", "SUCCESS");
                    returnMap.put("return_msg", "OK");
                    String returnXml = WXPayUtil.mapToXml(returnMap);
                    response.setContentType("text/xml");
                    log.warn("通知已处理");
                    return returnXml;
                }else{
                    // 更新订单支付状态，并返回成功响应
                    orderService.updateOrderStatus(notifyMap);
                    returnMap.put("return_code", "SUCCESS");
                    returnMap.put("return_msg", "OK");
                    String returnXml = WXPayUtil.mapToXml(returnMap);
                    response.setContentType("text/xml");
                    log.info("支付成功，通知已处理");
                    return returnXml;
                }
            }
        }
    }
    // 校验失败，返回失败应答
    returnMap.put("return_code", "FAIL");
    returnMap.put("return_msg", "");
    String returnXml = WXPayUtil.mapToXml(returnMap);
    response.setContentType("text/xml");
    log.warn("校验失败");
    return returnXml;
}
```



## 10.2 更新订单状态

更新订单支付状态并记录支付日志，将微信返回的支付结果全部记录进数据库的json字段中

```java
接口：OrderService
```

```java
void updateOrderStatus(Map<String, String> map);
```

实现：OrderServiceImpl

```java
@Autowired
private PayLogMapper payLogMapper;
@Transactional(rollbackFor = Exception.class)
@Override
public void updateOrderStatus(Map<String, String> map) {
    //更新订单状态
    String orderNo = map.get("out_trade_no");
    Order order = this.getOrderByOrderNo(orderNo);
    order.setStatus(1);//支付成功
    baseMapper.updateById(order);
    //记录支付日志
    PayLog payLog = new PayLog();
    payLog.setOrderNo(orderNo);
    payLog.setPayTime(new Date());
    payLog.setPayType(1);//支付类型
    payLog.setTotalFee(Long.parseLong(map.get("total_fee")));//总金额(分)
    payLog.setTradeState(map.get("result_code"));//支付状态
    payLog.setTransactionId(map.get("transaction_id"));
    payLog.setAttr(new Gson().toJson(map));
    payLogMapper.insert(payLog);
}
```



# 11 查询支付状态业务层

## 11.1 业务层

接口：OrderService

```java
boolean queryPayStatus(String orderNo);
```

实现：OrderServiceImpl

```java
@Override
public boolean queryPayStatus(String orderNo) {
    QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("order_no", orderNo);
    Order order = baseMapper.selectOne(queryWrapper);
    return order.getStatus() == 1;
}
```

## 11.2 web层

ApiOrderController：queryPayStatus

```java
@GetMapping("/query-pay-status/{orderNo}")
public R queryPayStatus(@PathVariable String orderNo) {
    boolean result = orderService.queryPayStatus(orderNo);
    if (result) {//支付成功
        return R.ok().message("支付成功");
    }
    return R.setResult(ResultCodeEnum.PAY_RUN);//支付中
}
```

# 12 前端整合

## 12.1 api

api/order.js

```js
queryPayStatus(orderNo) {
    return request({
        baseURL: 'http://localhost:8170',
        url: `/api/trade/order/query-pay-status/${orderNo}`,
        method: 'get'
    })
}
```

## 12.2 **axios响应拦截**

utils/request.js中的response响应拦截器

```js
else if (res.code === 25000) { // 支付中
  return response.data // 不显示错误信息
}
```

## 12.3 支付页面

pages/pay/_id.vue

```js
import orderApi from '~/api/order'
```

```js
data() {
    return {
      timer: null // 定时器
    }
},
// created的时候就查询支付状态，没有必要，因为二维码页面尚未渲染，不可能支付成功
mounted() {
    // 启动定时器
    this.timer = setInterval(() => {
      this.queryPayStatus()
    }, 3000)
},
methods: {
    // 查询订单状态
    queryPayStatus() {
      orderApi.queryPayStatus(this.payObj.out_trade_no).then(response => {
        console.log('查询订单状态：' + response.code)
        // 支付成功后的页面跳转
        if (response.success) {
          this.$message.success(response.message)
          console.log('清除定时器')
          clearInterval(this.timer)
          // 三秒后跳转到课程详情页面观看视频
          setTimeout(() => {
            this.$router.push({ path: '/course/' + this.payObj.course_id })
          }, 3000)
        }
      })
    }
}
```

# 13 修改课程销量

## 13.1 service层

接口：service_edu中CourseService

```java
void updateBuyCountById(String id);
```

实现：CourseServiceImpl

```java
@Override
public void updateBuyCountById(String id) {
    Course course = baseMapper.selectById(id);
    course.setBuyCount(course.getBuyCount() + 1);
    this.updateById(course);
}
```

## 13.2 web层

ApiCourseController

```java

@ApiOperation("根据课程id更改销售量")
@GetMapping("inner/update-buy-count/{id}")
public R updateBuyCountById(
    @ApiParam(value = "课程id", required = true)
    @PathVariable String id){
    courseService.updateBuyCountById(id);
    return R.ok();
}
```



# 14 远程调用接口

## 14.1 Feign接口

接口：service_trade 中 EduCourseService

```java
@GetMapping("/api/edu/course/inner/update-buy-count/{id}")
R updateBuyCountById(@PathVariable("id") String id);
```

## 14.2 熔断器

EduCourseServiceFallBack

```java
@Override
public R updateBuyCountById(String id) {
    log.error("熔断器被执行");
    return R.error();
}
```

## 14.3 调用

OrderServiceImpl

```java
@Transactional(rollbackFor = Exception.class)
@Override
public void updateOrderStatus(Map<String, String> map) {
    //更新订单状态
    ......
    //记录支付日志
    ......
    //更新课程销量：有问题直接熔断
    eduCourseService.updateBuyCountById(order.getCourseId());
}
```





# 15 可用的支付key

```yaml
# 贴一个隔壁找的支付key，现在是2021.5.7可用
weixin:
  pay:
    #关联的公众号appid
    appId: wx74862e0dfcf69954
    #商户号
    partner: 1558950191
    #商户key
    partnerKey: T6m9iK73b0kn9g5v426MKfHQH7X8rKwb
    #回调地址
    #notifyUrl: 填自己的
    notifyUrl: http://yunzouedu.free.idcfengye.com/api/trade/weixin-pay/callback/notify
```

http://yunzouedu.free.idcfengye.com

隧道id: 183511247195

# 16 mac启动ngrok

```shell
```

### 如何在Mac上使用ngrok？

1. 下载Mac版ngrok：https://ngrok.cc/download.html
2. 解压，Cd 到ngrok
3. 启动

```shell
#启动一个隧道
./sunny clientid 隧道id

# 这个clientid就是clientid，没有其他意思在里面
./sunny clientid 183511247195

#启动多个隧道
./sunny clientid 隧道id,隧道id

#要想后台运行可以使用 setsid 命令
setsid ./sunny clientid 隧道id &
```



