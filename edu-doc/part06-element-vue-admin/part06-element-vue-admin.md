# part06-element-vue-admin



# 1 解压安装element-vue-admin完整版

是完整版的那个的，921KB，解压到axios_pro同级目录

**GitHub地址：**https://github.com/PanJiaChen/vue-element-admin

**项目在线预览：** https://panjiachen.gitee.io/vue-element-admin



# 2 安装node依赖

```shell
npm i

#added 1477 packages from 1597 contributors in 42.516s
```



# 3 查看Package.json的scripts

```json
  "scripts": {
    "dev": "cross-env BABEL_ENV=development webpack-dev-server --inline --progress --config build/webpack.dev.conf.js", # 启动开发环境
    "build:prod": "cross-env NODE_ENV=production env_config=prod node build/build.js",
    "build:sit": "cross-env NODE_ENV=production env_config=sit node build/build.js",
    "lint": "eslint --ext .js,.vue src",
    "test": "npm run lint",
    "precommit": "lint-staged",
    "svgo": "svgo -f src/icons/svg --config=src/icons/svgo.yml"
  },
```



# 4 启动项目

```shell
npm run dev

# I  Your application is running here: http://localhost:9527
```

![image-20211018074929901](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018074929901.png)



# 5 解压安装简化版element-vue-admin

重命名成yunzou_admin

```shell
npm i  # 安装node依赖
#added 1339 packages from 804 contributors in 31.996s

npm run dev # 启动前端项目

```

打开浏览器，项目地址，点击登录，发现报错

![image-20211018075620031](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018075620031.png)

模拟数据平台，不可用的，我们在自己的后端，写一个模拟的登录接口，和前端axios对接，联合调试



# 6 eslint的启用

VSCODE安装以下插件：

- Chinese
- ESLint # 语法检查工具
- LiveServer
- Node.js Modules Intellisense # 在import语句中自动完成Node.js模块
- Vetur # data+tab直接生成data函数,结尾加逗号
- VueHelper



点击settings，点击settings.json加上

```json
"editor.codeActionsOnSave": {
  "source.fixAll.eslint": true,// 在保存的时候检查和自动修复
},
```



# 7 修改项目端口

修改 config/index.js

```js
port: 9528,
useEslint: true,# 启用eslint语法检查
```



# 8 Eslint规则说明

官网： http://eslint.cn/docs/user-guide/getting-started

## 8.1 规则说明

.eslintrc文件

```js
{
  rules: {
    semi: [2, 'never'], // 不使用分号，否则报错
    quotes: [2, 'single'], // 使用单引号，否则报错
  }
}
```

"semi" 和 "quotes" 是 ESLint 中 规则 的名称。第一个值是错误级别，可以使下面的值之一：

- "off" or 0 - 关闭规则
- "warn" or 1 - 将规则视为一个警告
- "error" or 2 - 将规则视为一个错误

## 8.2 语法规则

本项目的语法规则包括：

- 两个字符缩进
- 使用单引号
- 语句后不可以写分号
- 等

![image-20211018082208906](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018082208906.png)

能看到这些说明我们vscode的eslint插件生效了

按下 command + S 保存并且修复你的编程失误

.eslintrc.js

```js
"vue/max-attributes-per-line": [2, {
  "singleline": 3, // 一行最多允许有3个属性
  "multiline": {
    "max": 1, // 超过三个每行显示一个属性,美化代码
    "allowFirstLine": false
  }
```

![image-20211018083314879](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018083314879.png)



# 9 前端项目结构

## 9.1 目录结构

vue-element-admin-master（拥有完整的功能的插件）

```shell
├── build                      // 构建相关  
├── config                     // 配置相关
├── src                        // 源代码
│   ├── api                    // 所有请求
│   ├── assets                 // 主题 字体等静态资源
│   ├── components             // 全局公用组件
│   ├── directive              // 全局指令
│   ├── filtres                // 全局 filter
│   ├── icons                  // 项目所有 svg icons
│   ├── lang                   // 国际化 language
│   ├── mock                   // 项目mock 模拟数据
│   ├── router                 // 路由
│   ├── store                  // 全局 store管理
│   ├── styles                 // 全局样式
│   ├── utils                  // 全局公用方法
│   ├── vendor                 // 公用vendor
│   ├── views                   // view
│   ├── App.vue                // 入口页面
│   ├── main.js                // 入口 加载组件 初始化等
│   └── permission.js          // 权限管理
├── static                     // 第三方不打包资源
│   └── Tinymce                // 富文本
├── .babelrc                   // babel-loader 配置
├── .eslintrc.js                // eslint 配置项
├── .gitignore                 // git 忽略项
├── favicon.ico                // favicon图标
├── index.html                 // html模板
└── package.json               // package.json
```

## 9.2 关键文件

vue-admin-template-master（源码相对简单，我们的后台管理系统基于这个版本）

(1) package.js

npm项目的核心配置文件，包含项目信息，项目依赖，项目启动相关脚本

- 启动项目的命令： npm run dev

- dev脚本：webpack-dev-server --inline --progress --config build/webpack.dev.conf.js

- - webpack-dev-server：一个小型的基于Node.js的http服务器，可以运行前端项目
  - --inline：一种启动模式
  - --progress：显示启动进度
  - --config build/webpack.dev.conf.js：指定webpack配置文件所在位置

![image-20211018083857206](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018083857206.png)

（2）build/webpack.dev.conf.js

webpack配置文件，包含项目在开发环境打包和运行的相关配置

- webpack.dev.conf.js 中引用了 webpack.base.conf.js
- webpack.base.conf.js 中定义了项目打包的入口文件

![image-20211018083956719](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018083956719.png)

![image-20211018084017909](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084017909.png)

在HtmlWebpackPlugin配置html模板，生成的js就会自动插入到模板中，如下面的配置。

因此生成的js文件会被自动插入到名为index.html的页面中

![image-20211018084046417](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084046417.png)

（3）index.html

![image-20211018084109866](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084109866.png)

![image-20211018084128923](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084128923.png)

（4）src/main.js

项目js入口文件，项目的所有前端功能都在这个文件中引入和定义，并初始化全局的Vue对象

![image-20211018084206718](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084206718.png)

（5）config/dev.env.js

定义全局常量值

![image-20211018084242906](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084242906.png)

![image-20211018084258170](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084258170.png)

因此，在项目中的任意位置可以直接使用 process.env.BASE_API 常量表示后端接口的主机地址

（6）src/utils/request.js

引入axios模块，定义全局的axios实例，并导出模块

![image-20211018084332403](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084332403.png)

（7）src/api/login.js

引用request模块，调用远程api

![image-20211018084400734](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084400734.png)



# 10 模拟登录接口

(1) 重启项目： Command + C npm run dev

(2) ![image-20211018084956059](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018084956059.png)

(3) edu_service LoginController

```java
package com.yunzoukj.yunzou.service.edu.controller;

import com.yunzoukj.yunzou.common.base.result.R;
import org.springframework.web.bind.annotation.*;

@CrossOrigin // 允许跨域
@RestController // 返回json数据
@RequestMapping("/user") // 浏览器路径前缀
public class LoginController {

    @PostMapping("login")
    public R doLogin() {
        return R.ok().data("token", "admin");
    }

    /**
     * 获取用户信息
     * @return
     */
    @GetMapping("info")
    public R doInfo() {
        return R.ok()
                .data("name", "admin")
                .data("roles", "[admin]")
                .data("avatar", "https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg");
    }

    @PostMapping("logout")
    public R doLogout() {
        return R.ok();
    }

}

```



# 11 Vue中路由的定义

## 11.1 锚点的概念

案例：百度百科

特点：单页Web应用，预先加载页面内容

形式：url#锚点

## 11.2 路由的作用

Vue.js 路由允许我们通过锚点定义不同的 URL， 达到访问不同的页面的目的，每个页面的内容通过延迟加载渲染出来。

通过 Vue.js 可以实现多视图的单页Web应用（single page web application，SPA）

## 11.3 路由实例

**创建文件夹router_pro/**

## 11.4 复制js资源

vue.min.js

vue-router.min.js

## 11.5 创建 路由.html

## 11.6 引入js

```js
<script src="vue.min.js"></script>
<script src="vue-router.min.js"></script>
```

## 11.7 编写html

```html
<div id="app">
    <h1>Hello App!</h1>
    <p>
        <!-- <router-link> 默认会被渲染成一个 `<a>` 标签 -->
        <!-- 通过传入 `to` 属性指定链接. -->
        <router-link to="/">首页</router-link>
        <router-link to="/student">会员管理</router-link>
        <router-link to="/teacher">讲师管理</router-link>
    </p>
    <!-- 路由出口 -->
    <!-- 路由匹配到的组件将渲染在这里 -->
    <router-view></router-view>
</div>
```

## 11.8 编写js

```js
<script>
    // 1. 定义（路由）组件。
    // 复杂的组件也可以从独立的vue文件中引入
    const Welcome = { template: '<div>欢迎</div>' }
    const Student = { template: '<div>student list</div>' }
    const Teacher = { template: '<div>teacher list</div>' }
    // 2. 定义路由
    // 每个路由应该映射一个组件。
    const routes = [
        { path: '/', redirect: '/welcome' }, //设置默认指向的路径
        { path: '/welcome', component: Welcome },
        { path: '/student', component: Student },
        { path: '/teacher', component: Teacher }
    ]
    // 3. 创建 router 实例，然后传 `routes` 配置
    const router = new VueRouter({
        routes // （缩写）相当于 routes: routes
    })
    // 4. 创建和挂载根实例。
    // 从而让整个应用都有路由功能
    new Vue({
        el: '#app',
        router
    })
    // 现在，应用已经启动了！
</script>
```



# 12 **组件定义**

## 12.1 创建vue组件

在src/views文件夹下创建以下文件夹和文件

![image-20211018091445991](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211018091445991.png)

修改 src/router/index.js 文件，重新定义constantRouterMap

**注意：**每个路由的name不能相同

```js
export const constantRouterMap = [
  { path: '/login', component: () => import('@/views/login/index'), hidden: true },
  { path: '/404', component: () => import('@/views/404'), hidden: true },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    name: 'Dashboard',
    hidden: true,
    children: [{
      path: 'dashboard',
      component: () => import('@/views/dashboard/index')
    }]
  },
  // 讲师管理
  {
    path: '/teacher',
    component: Layout,
    redirect: '/teacher/list',
    name: 'Teacher',
    meta: { title: '讲师管理' },
    children: [
      {
        path: 'list',
        name: 'TeacherList',
        component: () => import('@/views/teacher/list'),
        meta: { title: '讲师列表' }
      },
      {
        path: 'create',
        name: 'TeacherCreate',
        component: () => import('@/views/teacher/form'),
        meta: { title: '添加讲师' }
      },
      {
        path: 'edit/:id',
        name: 'TeacherEdit',
        component: () => import('@/views/teacher/form'),
        meta: { title: '编辑讲师' },
        hidden: true
      }
    ]
  },
  { path: '*', redirect: '/404', hidden: true }
]
```

# 13 其他配置修改

## **1、项目名称**

将vue-admin-template-master重命名为guli_admin

## 2、端口号

在 config/index.js中修改

```js
port: 9528,
```

## 3、国际化设置

src/main.js，第7行，修改语言为 zh-CN，使用中文语言环境，例如：日期时间组件

```js
import locale from 'element-ui/lib/locale/lang/zh-CN' // lang i18n
```

## 4、入口页面

index.html

```html
<title>谷粒学院后台管理系统</title>
```

## **5、登录页**

src/views/login/index.vue，第4行

```html
<h3 class="title">谷粒学院后台管理系统</h3>
```