# part05-axios和elementui

# 1 axios的作用

axios 是一个独立于 Vue 的的项目，可以用于浏览器中 node.js 中发送ajax请求



# 2 axios实例

创建 axios_pro/ 文件夹



## 2.1 复制 js 资源

vue.min.js

axios.min.js



## 2.2 创建axios.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <div id="app">
        <button @click="getTeacherList()">获取讲师列表</button>

        <div style="background-color: pink; width: 100px; overflow: auto;"></div>
        <ul v-for="item in teacherList">
            <li>{{item.name}}--{{item.level}}</li>
        </ul>
    </div>

    <script src="js/vue/vue.min.js"></script>
    <script src="js/axios/axios.min.js"></script>
    <script>
        new Vue({
            el: "#app",
            data() {
                return {
                    teacherList: []
                }
            },
            methods: {
                async getTeacherList(){
                    console.log("access teacherList Api");
                    // 发送获取讲师列表的请求，结果被跨域禁止访问
                    const res = await axios.get("http://localhost:8110/admin/edu/teacher/list")
                    // console.log(res.data.data.items);
                    this.teacherList = res.data.data.items
                }
            },
        })
    </script>

</body>
</html>
```



## 2.3 引入js



## 2.4 测试

![image-20211017180602438](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211017180602438.png)



# 3 跨域

***为什么会出现跨域问题?***

- 出于浏览器同源策略限制：
  - 所谓同源(即指在同一个域)就是两个地址具有相同的协议(protocol) ,主机(host)和端口号(port)
  - 同源策略会阻止一个域的javascript脚本和另外一个域的内容进行交互
- 同源策略(Sameoriginpolicy)是一种约定,它是浏览器最核心也最基本的安全功能。

***解决跨域问题:***

```java
@CrossOrigin // 解决跨域问题
@Controller
```



# 4 分层开发思想

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <div id="app">
        <!-- <button @click="getTeacherList()">获取讲师列表</button> -->
        <button @click="getTeacherList2()">获取讲师列表</button>

        <div style="background-color: pink; width: 100px; overflow: auto;"></div>
        <ul v-for="item in teacherList">
            <li>{{item.name}}--{{item.level}}</li>
        </ul>
    </div>

    <script src="js/vue/vue.min.js"></script>
    <script src="js/axios/axios.min.js"></script>
    <script>
        new Vue({
            el: "#app",
            data() {
                return {
                    teacherList: []
                }
            },
            methods: {
                /* async getTeacherList(){
                    console.log("access teacherList Api");
                    // 发送获取讲师列表的请求，结果被跨域禁止访问
                    const res = await axios.get("http://localhost:8110/admin/edu/teacher/list")
                    // console.log(res.data.data.items);
                    this.teacherList = res.data.data.items
                }, */
                // 1 基础配置
                initRequest(){
                    return axios.create({
                        baseURL: "http://localhost:8110",
                        timeout: 5000
                    })
                },
                // 2 api调用
                teacherListApi(){
                    // request()是一个函数
                    let request = this.initRequest()
                    return request({
                        url: "/admin/edu/teacher/list",
                        method: "get"
                    })
                },
                // 3 数据渲染
                getTeacherList2 () {
                    console.log("do...getTeacherList2");
                    this.teacherListApi().then(res => {
                        this.teacherList = res.data.data.items
                    }).catch(err => console.log(err))
                }
                
            },
        })
    </script>

</body>
</html>
```



# 5 elementUI

官网： http://element-cn.eleme.io/#/zh-CN

## 5.1 引入脚本库

在axios文件夹中引入: elementui/lib/

## 5.2 引入elementCSS

```html
<!-- import elementCSS -->
<link rel="stylesheet" href="elementui/lib/theme-chalk/index.css">
```



## 5.3 引入elementJS

```html
<!-- import elementJS -->
<script src="elementui/lib/index.js"></script>
```



## 5.4 element-button

```html
<el-button>默认按钮</el-button>
<el-button type="primary">主要按钮</el-button>
<el-button type="success">成功按钮</el-button>
<el-button type="info">信息按钮</el-button>
<el-button type="warning">警告按钮</el-button>
<el-button type="danger">危险按钮</el-button>
```



## 5.5 element-table

```html
<template>
  <el-table
    :data="tableData"
    border
    style="width: 100%">
    <el-table-column
      fixed
      prop="date"
      label="日期"
      width="150">
    </el-table-column>
    <el-table-column
      prop="name"
      label="姓名"
      width="120">
    </el-table-column>
    <el-table-column
      prop="province"
      label="省份"
      width="120">
    </el-table-column>
    <el-table-column
      prop="city"
      label="市区"
      width="120">
    </el-table-column>
    <el-table-column
      prop="address"
      label="地址"
      width="300">
    </el-table-column>
    <el-table-column
      prop="zip"
      label="邮编"
      width="120">
    </el-table-column>
    <el-table-column
      fixed="right"
      label="操作"
      width="100">
      <template slot-scope="scope">
        <el-button @click="handleClick(scope.row)" type="text" size="small">查看</el-button>
        <el-button type="text" size="small">编辑</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
  export default {
    methods: {
      handleClick(row) {
        console.log(row);
      }
    },

    data() {
      return {
        tableData: [{
          date: '2016-05-02',
          name: '王小虎',
          province: '上海',
          city: '普陀区',
          address: '上海市普陀区金沙江路 1518 弄',
          zip: 200333
        }, {
          date: '2016-05-04',
          name: '王小虎',
          province: '上海',
          city: '普陀区',
          address: '上海市普陀区金沙江路 1517 弄',
          zip: 200333
        }, {
          date: '2016-05-01',
          name: '王小虎',
          province: '上海',
          city: '普陀区',
          address: '上海市普陀区金沙江路 1519 弄',
          zip: 200333
        }, {
          date: '2016-05-03',
          name: '王小虎',
          province: '上海',
          city: '普陀区',
          address: '上海市普陀区金沙江路 1516 弄',
          zip: 200333
        }]
      }
    }
  }
</script>
```

