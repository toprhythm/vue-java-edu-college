# Part04-非业务统一处理



# 1 统一返回结果

项目中我们会将响应封装成json返回，一般我们会将所有接口的数据格式统一， 使前端(iOS Android, Web)对数据的操作更一致、轻松。

一般情况下，统一返回数据格式没有固定的格式，只要能描述清楚返回的数据状态以及要返回的具体数据就可以。但是一般会包含状态码、返回消息、数据这几部分内容

例如，我们的系统要求返回的基本数据格式如下：

**列表：**

```java
{
  "success": true,
  "code": 20000,
  "message": "成功",
  "data": {
    "items": [
      {
        "id": "1",
        "name": "刘德华",
        "intro": "毕业于师范大学数学系，热爱教育事业，执教数学思维6年有余"
      }
    ]
  }
}
```

**分页：**

```java

{
  "success": true,
  "code": 20000,
  "message": "成功",
  "data": {
    "total": 17,
    "rows": [
      {
        "id": "1",
        "name": "刘德华",
        "intro": "毕业于师范大学数学系，热爱教育事业，执教数学思维6年有余"
      }
    ]
  }
}
```

**没有返回数据：**

```java
{
  "success": true,
  "code": 20000,
  "message": "成功",
  "data": {}
}
```

**失败：**

```java
{
  "success": false,
  "code": 20001,
  "message": "失败",
  "data": {}
}
```

因此，我们定义统一结果

```java
{
  "success": 布尔, //响应是否成功
  "code": 数字, //响应码
  "message": 字符串, //返回消息
  "data": HashMap //返回数据，放在键值对中
}
```

## 1 定义统一返回结果 

1. ## 创建返回码定义枚举类

在common_util中

创建包：com.yunzoukj.yunzou.common.base.result

创建枚举类： ResultCodeEnum.java

```java
package com.yunzoukj.yunzou.common.base.result;


@Getter
@ToString
public enum ResultCodeEnum {

    SUCCESS(true, 20000,"成功"),
    UNKNOWN_REASON(false, 20001, "未知错误"),

    BAD_SQL_GRAMMAR(false, 21001, "sql语法错误"),
    JSON_PARSE_ERROR(false, 21002, "json解析异常"),
    PARAM_ERROR(false, 21003, "参数不正确"),

    FILE_UPLOAD_ERROR(false, 21004, "文件上传错误"),
    FILE_DELETE_ERROR(false, 21005, "文件刪除错误"),
    EXCEL_DATA_IMPORT_ERROR(false, 21006, "Excel数据导入错误"),

    VIDEO_UPLOAD_ALIYUN_ERROR(false, 22001, "视频上传至阿里云失败"),
    VIDEO_UPLOAD_TOMCAT_ERROR(false, 22002, "视频上传至业务服务器失败"),
    VIDEO_DELETE_ALIYUN_ERROR(false, 22003, "阿里云视频文件删除失败"),
    FETCH_VIDEO_UPLOADAUTH_ERROR(false, 22004, "获取上传地址和凭证失败"),
    REFRESH_VIDEO_UPLOADAUTH_ERROR(false, 22005, "刷新上传地址和凭证失败"),
    FETCH_PLAYAUTH_ERROR(false, 22006, "获取播放凭证失败"),

    URL_ENCODE_ERROR(false, 23001, "URL编码失败"),
    ILLEGAL_CALLBACK_REQUEST_ERROR(false, 23002, "非法回调请求"),
    FETCH_ACCESSTOKEN_FAILD(false, 23003, "获取accessToken失败"),
    FETCH_USERINFO_ERROR(false, 23004, "获取用户信息失败"),
    LOGIN_ERROR(false, 23005, "登录失败"),

    COMMENT_EMPTY(false, 24006, "评论内容必须填写"),

    PAY_RUN(false, 25000, "支付中"),
    PAY_UNIFIEDORDER_ERROR(false, 25001, "统一下单错误"),
    PAY_ORDERQUERY_ERROR(false, 25002, "查询支付结果错误"),

    ORDER_EXIST_ERROR(false, 25003, "课程已购买"),

    GATEWAY_ERROR(false, 26000, "服务不能访问"),

    CODE_ERROR(false, 28000, "验证码错误"),

    LOGIN_PHONE_ERROR(false, 28009, "手机号码不正确"),
    LOGIN_MOBILE_ERROR(false, 28001, "账号不正确"),
    LOGIN_PASSWORD_ERROR(false, 28008, "密码不正确"),
    LOGIN_DISABLED_ERROR(false, 28002, "该用户已被禁用"),
    REGISTER_MOBLE_ERROR(false, 28003, "手机号已被注册"),
    LOGIN_AUTH(false, 28004, "需要登录"),
    LOGIN_ACL(false, 28005, "没有权限"),
    SMS_SEND_ERROR(false, 28006, "短信发送失败"),
    SMS_SEND_ERROR_BUSINESS_LIMIT_CONTROL(false, 28007, "短信发送过于频繁");


    private Boolean success;

    private Integer code;

    private String message;

    ResultCodeEnum(Boolean success, Integer code, String message) {
        this.success = success;
        this.code = code;
        this.message = message;
    }
}

```



2. ## 创建结果类

com.yunzoukj.yunzou.common.base.result 中创建类 R.java

```java
package com.yunzoukj.yunzou.common.base.result;

import java.util.HashMap;
import java.util.Map;

/**
 * @author helen
 * @since 2019/12/25
 */
@Data
@ApiModel(value = "全局统一返回结果")
public class R {

    @ApiModelProperty(value = "是否成功")
    private Boolean success;

    @ApiModelProperty(value = "返回码")
    private Integer code;

    @ApiModelProperty(value = "返回消息")
    private String message;

    @ApiModelProperty(value = "返回数据")
    private Map<String, Object> data = new HashMap<String, Object>();

    public R(){}

    public static R ok(){
        R r = new R();
        r.setSuccess(ResultCodeEnum.SUCCESS.getSuccess());
        r.setCode(ResultCodeEnum.SUCCESS.getCode());
        r.setMessage(ResultCodeEnum.SUCCESS.getMessage());
        return r;
    }

    public static R error(){
        R r = new R();
        r.setSuccess(ResultCodeEnum.UNKNOWN_REASON.getSuccess());
        r.setCode(ResultCodeEnum.UNKNOWN_REASON.getCode());
        r.setMessage(ResultCodeEnum.UNKNOWN_REASON.getMessage());
        return r;
    }

    public static R setResult(ResultCodeEnum resultCodeEnum){
        R r = new R();
        r.setSuccess(resultCodeEnum.getSuccess());
        r.setCode(resultCodeEnum.getCode());
        r.setMessage(resultCodeEnum.getMessage());
        return r;
    }

    public R success(Boolean success){
        this.setSuccess(success);
        return this;
    }

    public R message(String message){
        this.setMessage(message);
        return this;
    }

    public R code(Integer code){
        this.setCode(code);
        return this;
    }

    public R data(String key, Object value){
        this.data.put(key, value);
        return this;
    }

    public R data(Map<String, Object> map){
        this.setData(map);
        return this;
    }
}

```



3. # 修改Controller中的返回结果

修改service_edu的TeacherController

列表:

```java
@ApiOperation("所有讲师列表")
@GetMapping("list")
public R listAll(){
  List<Teacher> list = teacherService.list();
  return R.ok().data("items", list).message("获取讲师成功");
}
```

删除:

```java
@ApiOperation("根据ID删除讲师")
@DeleteMapping("remove/{id}")
public R removeById(@ApiParam(value = "讲师的ID", required = true) @PathVariable String id){
  boolean delResult = teacherService.removeById(id);
  if(delResult){
    return R.ok().message("删除成功");
  }else{
    return R.error().message("数据不存在");
  }
}
```

## 2 重启测试





# 2 分页和条件查询

## 1 分页

1. ## 分页Controller方法

TeacherController中添加分页方法

```java
@ApiOperation("分页讲师列表")
@GetMapping("list/{page}/{limit}")
public R listPage(@ApiParam(value = "当前页码", required = true) @PathVariable Long page,
                  @ApiParam(value = "每页记录数", required = true) @PathVariable Long limit){
    Page<Teacher> pageParam = new Page<>(page, limit);
    IPage<Teacher> pageModel = teacherService.page(pageParam);
    List<Teacher> records = pageModel.getRecords();
    long total = pageModel.getTotal();
    return  R.ok().data("total", total).data("rows", records);
}
```

2. ## Swagger中测试





## 2 条件查询

根据讲师名称name，讲师头衔level、讲师入驻时间查询

1. ## 创建查询对象

创建包：com.yunzoukj.yunzou.service.edu.entity.vo

创建类：TeacherQueryVo

```java
package com.atguigu.guli.service.edu.entity.vo;
@Data
public class TeacherQueryVo implements Serializable {
  
    private static final long serialVersionUID = 1L;
    private String name;
    private Integer level;
    private String joinDateBegin;
    private String joinDateEnd;
}
```



2. ## service

接口:

```java
package com.atguigu.guli.service.edu.service;
public interface TeacherService extends IService<Teacher> {
  
    IPage<Teacher> selectPage(Long page, Long limit, TeacherQueryVo teacherQueryVo);
}
```

实现:

```java
package com.atguigu.guli.service.edu.service.impl;

@Service
public class TeacherServiceImpl extends ServiceImpl<TeacherMapper, Teacher> implements TeacherService {
  
    @Override
    public IPage<Teacher> selectPage(Long page, Long limit, TeacherQueryVo teacherQueryVo) {
        Page<Teacher> pageParam = new Page<>(page, limit);
        QueryWrapper<Teacher> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("sort");
        if (teacherQueryVo == null){
            return baseMapper.selectPage(pageParam, queryWrapper);
        }
        String name = teacherQueryVo.getName();
        Integer level = teacherQueryVo.getLevel();
        String begin = teacherQueryVo.getJoinDateBegin();
        String end = teacherQueryVo.getJoinDateEnd();
        if (!StringUtils.isEmpty(name)) {
            //左%会使索引失效
            queryWrapper.likeRight("name", name);
        }
        if (level != null) {
            queryWrapper.eq("level", level);
        }
        if (!StringUtils.isEmpty(begin)) {
            queryWrapper.ge("join_date", begin);
        }
        if (!StringUtils.isEmpty(end)) {
            queryWrapper.le("join_date", end);
        }
        return baseMapper.selectPage(pageParam, queryWrapper);
    }
}
```



3. controller

TeacherController中修改 index方法：

增加参数TeacherQueryVo teacherQueryVo，非必选

```
teacherService.page 修改成 teacherService.selectPage，并传递teacherQueryVo参数
```

```java
@GetMapping("list/{page}/{limit}")
public R listPage(@ApiParam(value = "当前页码", required = true) @PathVariable Long page,
                  @ApiParam(value = "每页记录数", required = true) @PathVariable Long limit,
                  @ApiParam("讲师列表查询对象") TeacherQueryVo teacherQueryVo){
    IPage<Teacher> pageModel = teacherService.selectPage(page, limit, teacherQueryVo);
    List<Teacher> records = pageModel.getRecords();
    long total = pageModel.getTotal();
    return  R.ok().data("total", total).data("rows", records);
}
```

3. ## Swagger中测试



# 3 新增和修改

## 1 自动填充 

service_base中

创建包：com.yunzoukj.yunzou.service.base.handler

创建自动填充处理类：CommonMetaObjectHandler

```java
package com.atguigu.guli.service.base.handler;

@Component
public class CommonMetaObjectHandler implements MetaObjectHandler {
  
    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("gmtCreate", new Date(), metaObject);
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }
}
```

## 2 定义API

service_edu中新增controller方法

1. ## 新增

```java
@ApiOperation("新增讲师")
@PostMapping("save")
public R save(@ApiParam(value = "讲师对象", required = true) @RequestBody Teacher teacher){
    boolean result = teacherService.save(teacher);
    if (result) {
        return R.ok().message("保存成功");
    } else {
        return R.error().message("保存失败");
    }
}
```

2. ## 根据id修改

```java
@ApiOperation("更新讲师")
@PutMapping("update")
public R updateById(@ApiParam(value = "讲师对象", required = true) @RequestBody Teacher teacher){
    boolean result = teacherService.updateById(teacher);
    if(result){
        return R.ok().message("修改成功");
    }else{
        return R.error().message("数据不存在");
    }
}
```

3. ## 根据id获取

```java
@ApiOperation("根据id获取讲师信息")
@GetMapping("get/{id}")
public R getById(@ApiParam(value = "讲师ID", required = true) @PathVariable String id){
    Teacher teacher = teacherService.getById(id);
    if(teacher != null){
        return R.ok().data("item", teacher);
    }else{
        return R.error().message("数据不存在");
    }
}
```

4. swagger测试，测试新增，删掉gmtcreate，gmtupdate，id；测试修改，删掉gmtcreate，gmtupdate，必须有id；



# 4 统一异常处理

## 1 制造异常

1. Teacher.java中屏蔽下面代码

```java
// @TableField(value = "is_deleted")
private Boolean deleted;
```

2. Swagger中测试

测试列表查询功能，查看结果

![image-20211017072054248](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211017072054248.png)

3. 什么是统一异常处理

我们想让异常结果也显示为统一的返回结果对象，并且统一处理系统的异常信息，那么需要统一异常处理



## 2 统一异常处理

1. ## 创建统一异常处理器

service-base中handler包中，

创建统一异常处理类：GlobalExceptionHandler.java：

```java
package com.atguigu.guli.service.base.handler;

@ControllerAdvice
public class GlobalExceptionHandler {
  
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public R error(Exception e){
        e.printStackTrace();
        return R.error();
    }
}
```

2. ## 测试

返回统一错误结果

![image-20211017072449662](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211017072449662.png)

3. # 处理特定异常

3.1添加异常处理方法

GlobalExceptionHandler.java中添加

```java

@ExceptionHandler(BadSqlGrammarException.class)
@ResponseBody
public R error(BadSqlGrammarException e){
    e.printStackTrace();
    return R.setResult(ResultCodeEnum.BAD_SQL_GRAMMAR);
}
```

3.2 测试

![image-20211017072737639](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211017072737639.png)

3.3 恢复制造的异常

```java
@TableField(value = "is_deleted")
private Boolean deleted;
```



## 3 另一个例子

1. ## 制造异常

在swagger中测试新增讲师方法，输入非法的json参数，得到 HttpMessageNotReadableException

2. ## 添加异常处理方法

GlobalExceptionHandler.java中添加

```java

@ExceptionHandler(HttpMessageNotReadableException.class)
@ResponseBody
public R error(HttpMessageNotReadableException e){
  
    e.printStackTrace();
    return R.setResult(ResultCodeEnum.JSON_PARSE_ERROR);
}
```

3. ## 测试

故意让两行json之间没有逗号，导致异常

![image-20211017073116757](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211017073116757.png)

# 5 自定义异常

TODO



# 6 日志 

1. ## 什么是日志

通过日志查看程序的运行过程，运行信息，异常信息等

2. ## 配置日志级别

日志记录器（Logger）的行为是分等级的。如下表所示：

分为：<font size=4 color="blue">FATAL、ERROR、WARN、INFO、DEBUG</font>

默认情况下，spring boot从控制台打印出来的日志级别只有INFO及以上级别，可以配置日志级别

```yaml
# 设置日志级别
logging:
  level:
    root: ERROR
```

这种方式能将ERROR级别以及以上级别的日志打印在控制台上

3. # Logback日志

spring boot内部使用Logback作为日志实现的框架。

Logback和log4j非常相似，如果你对log4j很熟悉，那对logback很快就会得心应手。

logback相对于log4j的一些优点：https://blog.csdn.net/caisini_vc/article/details/48551287

4. ## 配置logback日志

**删除application.yml中的日志配置**

**安装idea彩色日志插件：grep console**

resources 中创建 logback-spring.xml （默认日志的名字，必须是这个名字）

```java
<?xml version="1.0" encoding="UTF-8"?>
<configuration  scan="true" scanPeriod="10 seconds">
    <contextName>logback</contextName>
    <property name="log.path" value="/Users/mac/Desktop/codebase/toprhythm_java8_code/toprhythm_college/java/yunzoukj_parent/service/service_edu/src/main/resources/yunzou_log/edu" />
    <!--控制台日志格式：彩色日志-->
    <!-- magenta:洋红 -->
    <!-- boldMagenta:粗红-->
    <!-- cyan:青色 -->
    <!-- white:白色 -->
    <!-- magenta:洋红 -->
    <property name="CONSOLE_LOG_PATTERN"
              value="%yellow(%date{yyyy-MM-dd HH:mm:ss}) |%highlight(%-5level) |%blue(%thread) |%blue(%file:%line) |%green(%logger) |%cyan(%msg%n)"/>
    <!--文件日志格式-->
    <property name="FILE_LOG_PATTERN"
              value="%date{yyyy-MM-dd HH:mm:ss} |%-5level |%thread |%file:%line |%logger |%msg%n" />
    <!--编码-->
    <property name="ENCODING"
              value="UTF-8" />
    <!--输出到控制台-->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <!--日志级别-->
            <level>DEBUG</level>
        </filter>
        <encoder>
            <!--日志格式-->
            <Pattern>${CONSOLE_LOG_PATTERN}</Pattern>
            <!--日志字符集-->
            <charset>${ENCODING}</charset>
        </encoder>
    </appender>
    <!--输出到文件-->
    <appender name="INFO_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!--日志过滤器：此日志文件只记录INFO级别的-->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>INFO</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_info.log</file>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset>
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 每天日志归档路径以及格式 -->
            <fileNamePattern>${log.path}/info/log-info-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
    </appender>
    <appender name="WARN_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 日志过滤器：此日志文件只记录WARN级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>WARN</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_warn.log</file>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset> <!-- 此处设置字符集 -->
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.path}/warn/log-warn-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
    </appender>
    <appender name="ERROR_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 日志过滤器：此日志文件只记录ERROR级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_error.log</file>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
            <charset>${ENCODING}</charset> <!-- 此处设置字符集 -->
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.path}/error/log-error-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
    </appender>
    <!--开发环境-->
    <springProfile name="dev">
        <!--可以灵活设置此处，从而控制日志的输出-->
        <root level="DEBUG">
            <appender-ref ref="CONSOLE" />
            <appender-ref ref="INFO_FILE" />
            <appender-ref ref="WARN_FILE" />
            <appender-ref ref="ERROR_FILE" />
        </root>
    </springProfile>
    <!--生产环境-->
    <springProfile name="pro">
        <root level="ERROR">
            <appender-ref ref="ERROR_FILE" />
        </root>
    </springProfile>
</configuration>
```

5. ## 节点说明

- <property>：定义变量

- <appender>：定义日志记录器

- - <filter>：定义日志过滤器
  - <rollingPolicy>：定义滚动策略

- <springProfile>：定义日志适配的环境

- - <root>：根日志记录器

6. ## 控制日志级别

通过在开发环境设置以下<root>节点的 level 属性的值，调节日志的级别

```xml
<!--开发环境-->
<springProfile name="dev">
    <!--可以灵活设置此处，从而控制日志的输出-->
    <root level="DEBUG">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="INFO_FILE" />
        <appender-ref ref="WARN_FILE" />
        <appender-ref ref="ERROR_FILE" />
    </root>
</springProfile>
```

在controller的listAll方法中输出如下日志，调节日志级别查看日志开启和关闭的效果

```xml
log.info("所有讲师列表....................");
```



7. # 错误日志处理

## 用日志记录器记录错误日志

GlobalExceptionHandler.java 中

类上添加注解

```java
 @Slf4j
```

修改异常输出语句

```java
//e.printStackTrace();
log.error(e.getMessage());
```

8. ## 输出日志堆栈信息

**为了保证日志的堆栈信息能够被输出，我们需要定义工具类**

common_util中创建ExceptionUtil.java工具类

修改异常输出语句

```java
//e.printStackTrace();
//log.error(e.getMessage());
log.error(ExceptionUtils.getMessage(e));
```

ExcepUtils

```java
package com.yunzoukj.yunzou.common.base.exception;


import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * @author helen
 * @since 2019/9/25
 */
public class ExceptionUtils {

    public static String getMessage(Exception e) {
        StringWriter sw = null;
        PrintWriter pw = null;
        try {
            sw = new StringWriter();
            pw = new PrintWriter(sw);
            // 将出错的栈信息输出到printWriter中
            e.printStackTrace(pw);
            pw.flush();
            sw.flush();
        } finally {
            if (sw != null) {
                try {
                    sw.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            if (pw != null) {
                pw.close();
            }
        }
        return sw.toString();
    }
}


```

