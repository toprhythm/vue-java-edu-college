# part08-阿里云OSS



# 1 注册账户，注册aliyunoss服务



# 2 创建Bucket

![image-20211021074033880](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021074033880.png)





公共读：对文件写操作需要进行身份验证；可以对文件进行匿名读。

选择公共读，其他都不开通，然后创建



# 3 手动测试传一张图片

创建 cover/ 文件夹

上传图片

![image-20211021074604541](/Users/mac/Library/Application Support/typora-user-images/image-20211021074604541.png)



# 4 创建AccessKey

点击创建子用户（更安全）

点击创建用户

![image-20211021075656635](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021075656635.png)

用户登录名称: yunzouedu@1091283490135731.onaliyun.com 

AccessKey ID(访问账号):		LTAI5tJKfWCCd7uwCnkhYoaM

AccessKey Secret(访问秘钥):	OFejxoxQmMGB5TlFYPj50GKtyb7CgS



# 5 给用户分配权限

![image-20211021080147770](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021080147770.png)



# 6 在OSS的概览页右下角找到“Bucket管理”，点击“OSS学习路径”

点击Java SDK



# 7 创建测试oSS项目

## 7.1 创建Maven项目

com.yunzoukj

aliyun_oss

## 7.2 配置pom

```xml
<dependencies>
    <!--aliyunOSS-->
    <dependency>
        <groupId>com.aliyun.oss</groupId>
        <artifactId>aliyun-sdk-oss</artifactId>
        <version>3.1.0</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
</dependencies>

```

## 7.3 确认常量值

（1）endpoint（外网访问）：选择某一个bucket，在bucket主页面查找 oss-cn-beijing.aliyuncs.com

（2）bucketName

（3）accessKeyId

（4）accessKeySecret

## 7.4 测试用例

(1)创建Bucket

```java
public class OSSTests {

    // Endpoint以杭州为例，其它Region请按实际情况填写。
    String endpoint = "oss-cn-beijing.aliyuncs.com";
    // 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录 https://ram.console.aliyun.com 创建RAM账号。
    String accessKeyId = "LTAI5tJKfWCCd7uwCnkhYoaM";
    String accessKeySecret = "OFejxoxQmMGB5TlFYPj50GKtyb7CgS";
    String bucketName = "yunzou-edu";
    @Test
    public void testCreateBucket() {
        // 创建OSSClient实例。
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
        // 创建CreateBucketRequest对象。
        CreateBucketRequest createBucketRequest = new CreateBucketRequest(bucketName);
        // 创建存储空间。
        ossClient.createBucket(createBucketRequest);
        // 关闭OSSClient。
        ossClient.shutdown();
    }

}
```



(2)判断bucket是否存在

```java
@Test
public void testExist() {
    // 创建OSSClient实例。
    OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
    boolean exists = ossClient.doesBucketExist(bucketName);
    System.out.println(exists);
    // 关闭OSSClient。
    ossClient.shutdown();
}
```

(3)设置bucket访问权限

```java

@Test
public void testAccessControl() {
    // 创建OSSClient实例。
    OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
    // 设置存储空间的访问权限为：公共读。
    ossClient.setBucketAcl(bucketName, CannedAccessControlList.PublicRead);
    // 关闭OSSClient。
    ossClient.shutdown();
}
```



# 8  创建service_oss微服务

## 8.1 创建模块

![image-20211021082657910](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021082657910.png)



## 8.2 配置pom.xml

检查一下guli_parent中的aliyun-sdk-oss的版本，切换到3.8.0

```xml

<dependencies>
    <!--aliyunOSS-->
    <dependency>
        <groupId>com.aliyun.oss</groupId>
        <artifactId>aliyun-sdk-oss</artifactId>
    </dependency>
</dependencies>
```

## 8.3 创建application.yml

```yaml
server:
  port: 8120 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-oss # 服务名
aliyun:
  oss:
    endpoint: oss-cn-beijing.aliyuncs.com # 你的endponit
    keyid: LTAI5tJKfWCCd7uwCnkhYoaM # 你的阿里云keyid
    keysecret: OFejxoxQmMGB5TlFYPj50GKtyb7CgS # 你的阿里云keysecret
    #bucket可以在控制台创建，也可以使用java代码创建，注意先测试bucket是否已被占用
    bucketname: yunzou-edu  # 你的bucketName   
```

## 8.5 logback-spring.xml

修改日志路径为 guli_log/oss

## 8.6 创建启动类

创建ServiceOssApplication.java

```java
package com.yunzoukj.yunzou.service.oss;

@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)//取消数据源自动配置
@ComponentScan({"com.yunzoukj.yunzou"})
public class ServiceOssApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceOssApplication.class, args);
    }
}
```



# 9 实现文件上传

## 9.1 从配置文件读取常量

创建常量读取工具类：OssProperties.java

```java
package com.yunzoukj.yunzou.service.oss.util;

@Data
@Component
//注意prefix要写到最后一个 "." 符号之前
@ConfigurationProperties(prefix="aliyun.oss")
public class OssProperties {
  
    private String endpoint;
    private String keyid;
    private String keysecret;
    private String bucketname;
}
```

## 9.2 文件上传业务

创建Service接口：FileService.java

```java
package com.yunzoukj.yunzou.service.oss.service;

public interface FileService {
    /**
     * 文件上传至阿里云
     */
    String upload(InputStream inputStream, String module, String originalFilename);
}
```

实现：FileServiceImpl.java

参考SDK中的：Java->上传文件->简单上传->流式上传->上传文件流

```java
@Service
public class FileServiceImpl implements FileService {
    @Autowired
    private OssProperties ossProperties;
    @Override
    public String upload(InputStream inputStream, String module, String originalFilename) {
        String endpoint = ossProperties.getEndpoint();
        String keyid = ossProperties.getKeyid();
        String keysecret = ossProperties.getKeysecret();
        String bucketname = ossProperties.getBucketname();
        //判断oss实例是否存在：如果不存在则创建，如果存在则获取
        OSS ossClient = new OSSClientBuilder().build(endpoint, keyid, keysecret);
        if (!ossClient.doesBucketExist(bucketname)) {
            //创建bucket
            ossClient.createBucket(bucketname);
            //设置oss实例的访问权限：公共读
            ossClient.setBucketAcl(bucketname, CannedAccessControlList.PublicRead);
        }
        //构建日期路径：avatar/2019/02/26/文件名
        String folder = new DateTime().toString("yyyy/MM/dd");
        //文件名：uuid.扩展名
        String fileName = UUID.randomUUID().toString();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String key = module + "/" + folder + "/" + fileName + fileExtension;
        //文件上传至阿里云
        ossClient.putObject(ossProperties.getBucketname(), key, inputStream);
        // 关闭OSSClient。
        ossClient.shutdown();
        //返回url地址
        return "https://" + bucketname + "." + endpoint + "/" + key;
    }
}
```

## 9.3 **控制层**

创建controller：FileController.java，重启并在Swagger中测试

```java
@Api(description="阿里云文件管理")
@CrossOrigin //跨域
@RestController
@RequestMapping("/admin/oss/file")
public class FileController {
    @Autowired
    private FileService fileService;
    /**
     * 文件上传
     * @param file
     */
    @ApiOperation("文件上传")
    @PostMapping("upload")
    public R upload(
            @ApiParam(value = "文件", required = true)
            @RequestParam("file") MultipartFile file,
            @ApiParam(value = "模块", required = true)
            @RequestParam("module") String module) throws IOException {
        InputStream inputStream = file.getInputStream();
        String originalFilename = file.getOriginalFilename();
        String uploadUrl = fileService.upload(inputStream, module, originalFilename);
        //返回r对象
        return R.ok().message("文件上传成功").data("url", uploadUrl);
    }
}
```

## 9.4 测试

![image-20211021085727705](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021085727705.png)

![image-20211021085758646](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211021085758646.png)







# 10 **整合上传组件**

## 10.1 定义页面组件模板

src/views/teacher/form.vue：参考案例文档

```vue

<!-- 讲师头像 -->
<el-form-item label="讲师头像">
    <el-upload
               :show-file-list="false"
               :on-success="handleAvatarSuccess"
               :before-upload="beforeAvatarUpload"
               class="avatar-uploader"
               action="http://localhost:8120/admin/oss/file/upload?module=avatar">
        <img v-if="teacher.avatar" :src="teacher.avatar">
        <i v-else class="el-icon-plus avatar-uploader-icon"/>
    </el-upload>
</el-form-item>
```

css：参考案例文档

```vue

<style>
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .avatar-uploader img {
    width: 178px;
    height: 178px;
    display: block;
  }
</style>
```

## 10.2 定义页面组件脚本

```js
// 上传成功回调
handleAvatarSuccess(res, file) {
  // console.log(res)
  this.teacher.avatar = res.data.url
  // 强制重新渲染
  this.$forceUpdate()
},
// 上传校验
beforeAvatarUpload(file) {
  const isJPG = file.type === 'image/jpeg'
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isJPG) {
    this.$message.error('上传头像图片只能是 JPG 格式!')
  }
  if (!isLt2M) {
    this.$message.error('上传头像图片大小不能超过 2MB!')
  }
  return isJPG && isLt2M
}
```



# 11 **文件上传异常分析**

## 11.1 制造异常

将application.yml文件中的keyid改成错误的值，运行程序，执行上传阿里云sdk内部会抛出异常，并打印相关错误日志



## 11.2 异常处理方案

方案1：异常处理器中捕获相关异常

方案2：自定义异常，异常处理器中捕获自定义异常



## 11.3 **自定义异常处理**

(1)**创建自定义异常类**

service-base模块中创建com.atguigu.guli.service.base.exception包，

创建GuliException.java通用异常类 继承 RuntimeException，RuntimeException 对代码没有侵入性

```java
package com.atguigu.guli.service.base.exception;
@Data
public class GuliException extends RuntimeException {
    //状态码
    private Integer code;
    /**
     * 接受状态码和消息
     * @param code
     * @param message
     */
    public GuliException(Integer code, String message) {
        super(message);
        this.code=code;
    }
    /**
     * 接收枚举类型
     * @param resultCodeEnum
     */
    public GuliException(ResultCodeEnum resultCodeEnum) {
        super(resultCodeEnum.getMessage());
        this.code = resultCodeEnum.getCode();
    }
}
```

(2)添加异常处理方法

GlobalExceptionHandler.java中添加

```java
@ExceptionHandler(GuliException.class)
@ResponseBody
public R error(GuliException e){
    log.error(ExceptionUtils.getMessage(e));
    return R.error().message(e.getMessage()).code(e.getCode());
}
```

(3)修改FileController

在类上添加日志注解

```java
@Slf4j
```

业务中需要的位置抛出GuliException

```java
public R upload(...) {
    try {
        ......
    } catch (Exception e){
        log.error(ExceptionUtils.getMessage(e));
        throw new GuliException(ResultCodeEnum.FILE_UPLOAD_ERROR);
    }
}

```

## 11.4 打印完整的异常信息

GuliException类中重写toString方法

```java
@Override
public String toString() {
    return "GuliException{" +
        "code=" + code +
        ", message=" + this.getMessage() +
        '}';
}
```



# 12 前端错误处理

## 12.1 统一异常错误处理

```java
// 上传成功回调
handleAvatarSuccess(res, file) {
    console.log(res)
    if (res.success) {
        // console.log(res)
        this.teacher.avatar = res.data.url
        // 强制重新渲染
        this.$forceUpdate()
    } else {
        this.$message.error('上传失败 （非20000）')
    }
},
```

## 12.2 http异常错误处理

注册事件

```vue
<el-upload :on-error="handleAvatarError">
```

事件函数,把eduoss停止，在测试

```vue

// 错误处理
handleAvatarError() {
    console.log('error')
    this.$message.error('上传失败（http失败）')
}
```

判断

```js
    // 上传成功回调
    handleAvatarSuccess(res, file) {
      if (res.success) {
        // console.log(res)
        this.teacher.avatar = res.data.url
        // 强制重新渲染
        this.$forceUpdate()
      } else {
        this.$message.error('上传失败!(非20000)')
      }
    },
```

