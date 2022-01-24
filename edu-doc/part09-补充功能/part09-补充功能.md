# part09-补充功能

# 1 后端接口

TeacherController

```java
@ApiOperation("根据id列表删除讲师")
@DeleteMapping("batch-remove")
public R removeRows(
    @ApiParam(value = "讲师id列表", required = true)
    @RequestBody List<String> idList){
    boolean result = teacherService.removeByIds(idList);
    if(result){
        return R.ok().message("删除成功");
    }else{
        return R.error().message("数据不存在");
    }
}
```

测试Json列表数据格式

![image-20211024144202440](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211024144202440.png)



# 2 前端

## 2.1 api

teacher.js

```js
batchRemove(idList) {
    return request({
        url: '/admin/edu/teacher/batch-remove',
        method: 'delete',
        data: idList
    })
}
```

## 2.2 添加删除复选框

views/teacher/list.vue

```vue
<el-table-column type="selection"/>
```

## 2.3 添加删除按钮

```vue
<!-- 工具按钮 -->
<div style="margin-bottom: 10px">
    <el-button type="danger" size="mini" @click="batchRemove()">批量删除</el-button>
</div>
```

## 2.4 定义删除方法

```js
batchRemove() {

}
```

## 2.5 data中定义数据

```vue
multipleSelection: []// 批量删除选中的记录列表
```

## 2.6 表格组件中添加事件

```js
@selection-change="handleSelectionChange"
```

## 2.7 定义事件的回调函数

```js

// 当多选选项发生变化的时候调用
handleSelectionChange(selection) {
    console.log(selection)
    this.multipleSelection = selection
} 
```

## 2.8 完善removeRows方法

```js
// 批量删除
batchRemove() {
  console.log('removeRows......')
  if (this.multipleSelection.length === 0) {
    this.$message.warning('请选择要删除的记录！')
    return
  }
  this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    // 点击确定，远程调用ajax
    // 遍历selection，将id取出放入id列表
    var idList = []
    this.multipleSelection.forEach(item => {
      idList.push(item.id)
    })
    // 调用api
    return teacherApi.batchRemove(idList)
  }).then((response) => {
    this.fetchData()
    this.$message.success(response.message)
  }).catch(error => {
    if (error === 'cancel') {
      this.$message.info('取消删除')
    }
  })
}
```



# 3 自动完成

功能描述，场景：输入一个字 “周”，下拉列表选择所有姓周的老师，就是百度搜索里的下拉列表

## 3.1 后端接口

TeacherController

```java
@ApiOperation("根据左关键字查询讲师名列表")
@GetMapping("list/name/{key}")
public R selectNameListByKey(
    @ApiParam(value = "查询关键字", required = true)
    @PathVariable String key){
    List<Map<String, Object>> nameList = teacherService.selectNameListByKey(key);
    return R.ok().data("nameList", nameList);
}
```

TeacherService

接口

```java
List<Map<String, Object>> selectNameListByKey(String key);
```

实现

```java
@Override
public List<Map<String, Object>> selectNameListByKey(String key) {
    QueryWrapper<Teacher> queryWrapper = new QueryWrapper<>();
    queryWrapper.select("name");
    queryWrapper.likeRight("name", key);
    List<Map<String, Object>> list = baseMapper.selectMaps(queryWrapper);//返回值是Map列表
    return list;
}
```

## 3.2 前端整合

(1)api

teacher.js

```js
selectNameListByKey(key) {
    return request({
        url: `/admin/edu/teacher/list/name/${key}`,
        method: 'get'
    })
}
```

(2)组件

views/teacher/list.vue

**注意： value-key="name" 的设置**

```vue

<el-form-item>
    <!-- <el-input v-model="searchObj.name" placeholder="讲师名" /> -->
    <el-autocomplete
         v-model="searchObj.name"
         :fetch-suggestions="querySearch"
         :trigger-on-focus="false"
         class="inline-input"
         placeholder="讲师名称"
         value-key="name" />
</el-form-item>
```

```js
querySearch(queryString, cb) {
    teacherApi.selectNameListByKey(queryString).then(response => {
        cb(response.data.nameList)
    })
}
```

