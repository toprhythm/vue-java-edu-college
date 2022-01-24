# part27-用户认证

# 1 准备

## 1.1 引入依赖

common-util中引入jwt依赖

```xml
<dependencies>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt</artifactId>
    </dependency>
    <dependency>
        <groupId>joda-time</groupId>
        <artifactId>joda-time</artifactId>
    </dependency>
</dependencies>
```

## 1.2 引入工具类

common-util中引入工具类：JwtUtils.java、JwtInfo.java



# 2 用户登录接口

## 2.1 定义LoginVo

service_ucenter中定义vo

```java
package com.atguigu.guli.service.ucenter.entity.vo;
@Data
public class LoginVo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String mobile;
    private String password;
}
```

## 2.2 **service实现登录**

接口：MemberService

```java
String login(LoginVo loginVo);
```

实现：MemberServiceImpl

```java
@Override
public String login(LoginVo loginVo) {
    String mobile = loginVo.getMobile();
    String password = loginVo.getPassword();
    //校验参数
    if (StringUtils.isEmpty(mobile)
        || !FormUtils.isMobile(mobile)
        || StringUtils.isEmpty(password)) {
        throw new GuliException(ResultCodeEnum.PARAM_ERROR);
    }
    //校验手机号
    QueryWrapper<Member> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("mobile", mobile);
    Member member = baseMapper.selectOne(queryWrapper);
    if(member == null){
        throw new GuliException(ResultCodeEnum.LOGIN_MOBILE_ERROR);
    }
    //校验密码
    if(!MD5.encrypt(password).equals(member.getPassword())){
        throw new GuliException(ResultCodeEnum.LOGIN_PASSWORD_ERROR);
    }
    //检验用户是否被禁用
    if(member.getDisabled()){
        throw new GuliException(ResultCodeEnum.LOGIN_DISABLED_ERROR);
    }
    JwtInfo jwtInfo = new JwtInfo();
    jwtInfo.setId(member.getId());
    jwtInfo.setNickname(member.getNickname());
    jwtInfo.setAvatar(member.getAvatar());
    String jwtToken = JwtUtils.getJwtToken(jwtInfo, 1800);
    return jwtToken;
}
```

## 2.3 登录接口

ApiMemberController

```java
@ApiOperation(value = "会员登录")
@PostMapping("login")
public R login(@RequestBody LoginVo loginVo) {
    String token = memberService.login(loginVo);
    return R.ok().data("token", token);
}
```

# 3 **前端整合**

## 3.1 安装cookie模块

```js
npm install js-cookie@2.2.0
```

## 3.2 api

创建api/login.js

```js
import request from '~/utils/request'
// import cookie from 'js-cookie'
export default {
  submitLogin(user) {
    return request({
      baseURL: 'http://localhost:8160',
      url: '/api/ucenter/member/login',
      method: 'post',
      data: user
    })
  }
}
```

## 3.3 页面脚本

pages/login.vue

引入模块

```js
import cookie from 'js-cookie'
import loginApi from '~/api/login'
```

登录脚本

```js
methods: {
    // 登录
    submitLogin() {
        // 执行登录
        loginApi.submitLogin(this.user).then(response => {
            // 登录成功后将jwtToken写入cookie
            cookie.set('guli_jwt_token', response.data.token, { domain: 'localhost' })
            //跳转到首页
            window.location.href = '/'
        })
    }
}
```

## 3.4 测试

查看cookie中存储了jwtToken的值

![image-20211114105316799](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211114105316799.png)



# 4 获取用户信息接口

## 4.1 web层

ApiMemberController

```java
@ApiOperation(value = "根据token获取登录信息")
@GetMapping("get-login-info")
public R getLoginInfo(HttpServletRequest request){
    try{
        JwtInfo jwtInfo = JwtUtils.getMemberIdByJwtToken(request);
        return R.ok().data("userInfo", jwtInfo);
    }catch (Exception e){
        log.error("解析用户信息失败，" + e.getMessage());
        throw new GuliException(ResultCodeEnum.FETCH_USERINFO_ERROR);
    }
}
```

## 4.2 测试

注意：因为需要在请求中传递header参数，因此可以在postman中测试

![image-20211114111155767](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211114111155767.png)

```shell
   "data": {
        "userInfo": {
            "id": "1459700192091983873",
            "nickname": "zwq123",
            "avatar": "https://guli-file-helen.oss-cn-beijing.aliyuncs.com/avatar/default.jpg"
        }
    }
```



# 5 前端整合

## 5.1 api

api/login.api

```js
getLoginInfo() {
    return request({
        baseURL: 'http://localhost:8160',
        url: '/api/ucenter/member/get-login-info',
        method: 'get',
        // 通过请求头发送token
        headers: { 'token': cookie.get('guli_jwt_token') }
    })
}
```

## 5.2 **获取用户信息的脚本**

components/AppHeader.vue

```html
<script>
import loginApi from '~/api/login'
import cookie from 'js-cookie'
export default {
  data() {
    return {
      userInfo: null
    }
  },
  created() {
    this.getUserInfo()
  },
  methods: {
    getUserInfo() {
      // 如果cookie中token不存在，则不显示用户信息
      if (!cookie.get('guli_jwt_token')) {
        return
      }
      // 如果token存在，则根据token解析用户登录信息
      loginApi.getLoginInfo().then(response => {
        // 渲染页面
        this.userInfo = response.data.userInfo
      })
    }
  }
}
</script>
```

## 5.3 **登录后显示用户信息**

```html
<li v-if="!userInfo" id="no-login">
    <a href="/login" title="登录">
        <em class="icon18 login-icon">&nbsp;</em>
        <span class="vam ml5">登录</span>
    </a>
    |
    <a href="/register" title="注册">
        <span class="vam ml5">注册</span>
    </a>
</li>
<li v-if="userInfo" id="is-login-one" class="mr10">
     <a id="headerMsgCountId" href="#" title="消息">
         <em class="icon18 news-icon">&nbsp;</em>
     </a>
     <q class="red-point">&nbsp;</q>
</li>
<li v-if="userInfo" id="is-login-two" class="h-r-user">
    <a href="/ucenter" title>
        <img
             :src="userInfo.avatar"
             width="30"
             height="30"
             class="vam picImg"
             alt>
        <span id="userName" class="vam disIb">{{ userInfo.nickname }}</span>
    </a>
    <a href="javascript:void(0);" title="退出" class="ml5">退出</a>
</li>
<!-- /未登录显示第1 li；登录后显示第2，3 li -->
```

## 5.4 登出

html注册事件

```html
<a href="javascript:void(0);" title="退出" class="ml5" 
   @click="logout()">退出</a>
```

登出脚本

```js
logout() {
    cookie.set('guli_jwt_token', '', { domain: 'localhost' })
    // 跳转页面
    window.location.href = '/'
}
```

# 6 前端拦截器

## 6.1 统一发送header

让所有请求都自动在header中携带token：

utils/request.js中修改请求拦截器，此时login.js中不用传递header信息

```js
import cookie from 'js-cookie'
service.interceptors.request.use(
  config => {
    // debugger
    if (cookie.get('guli_jwt_token')) { // 如果cookie中包含guli_token
      // 则发送后端api请求的时候携带token
      config.headers['token'] = cookie.get('guli_jwt_token')
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)
```

## 6.2 用户信息获取失败处理

utils/request.js

在响应拦截器中显示错误消息

```js
response => {
    /**
       * code为非20000是抛错 可结合自己业务进行修改
       */
    const res = response.data
    if (res.code === 20000) { // 成功
        return response.data
    } else if (res.code === 23004) { // 获取用户信息失败
        // 清除cookie
        cookie.set('guli_jwt_token', '', { domain: 'localhost' })
        return response.data //不显示错误信息
    } else {
        Message({
            message: res.message,
            type: 'error',
            duration: 5 * 1000
        })
        return Promise.reject('error')
    }
}
```

