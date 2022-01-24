# Part02-创建项目



# 1 工程结构

- <font size=6 color="#48b885">yunzou_parent：根目录（父工程），管理四个子模块：</font>

- - <font size=4 color="#48b885">**canal_client**</font>：canal数据库表同步模块（统计同步数据）

  - <font size=4 color="#48b885">**common**</font>：公共模块父节点

  - - <font size=4 color="red">common_util</font>：工具类模块，所有模块都可以依赖于它
    - <font size=4 color="red">service_base</font>：service服务的base包，包含service服务的公共配置类，所有service模块依赖于它
    - <font size=4 color="red">spring_security</font>：认证与授权模块，需要认证授权的service服务依赖于它

  - <font size=4 color="#48b885">**infrastructure**</font>：基础服务模块父节点

  - - <font size=4 color="red">api_gateway</font>：api网关服务

  - <font size=4 color="#48b885">**service**</font>：api接口服务父节点

  - - <font size=4 color="red">service_edu</font>：教学相关api接口服务
    - <font size=4 color="red">service_oss</font>：阿里云oss api接口服务
    - <font size=4 color="red">service_acl</font>：用户权限管理api接口服务（用户管理、角色管理和权限管理等）
    - <font size=4 color="red">service_cms</font>：cms api接口服务
    - <font size=4 color="red">service_sms</font>：短信api接口服务
    - <font size=4 color="red">service_trade</font>：订单和支付相关api接口服务
    - <font size=4 color="red">service_statistics</font>：统计报表api接口服务
    - <font size=4 color="red">service_ucenter</font>：会员api接口服务
    - <font size=4 color="red">service_vod</font>：视频点播api接口服务



# 2 创建父工程guli_parent

> 1 创建Spring Boot项目

使用 <font size=4 color="red">Spring Initializr</font> 快速初始化一个 <font size=4 color="red">Spring Boot</font> 项目

Group：<font size=4 color="red">com.yunzoukj</font> 

Artifact：<font size=4 color="red">yunzoukj_parent</font> 

> 2 删除src目录

> 3 配置SpringBoot版本

```xml
<version>2.2.1.RELEASE</version>
```

> 4 配置pom依赖版本号

```xml
<properties>
    <java.version>1.8</java.version>
    <mybatis-plus.version>3.3.1</mybatis-plus.version>
    <velocity.version>2.0</velocity.version>
    <swagger.version>2.7.0</swagger.version>
    <aliyun.oss.version>3.1.0</aliyun.oss.version>
    <jodatime.version>2.10.1</jodatime.version>
    <commons-fileupload.version>1.3.1</commons-fileupload.version>
    <commons-io.version>2.6</commons-io.version>
    <commons-lang.version>3.9</commons-lang.version>
    <httpclient.version>4.5.1</httpclient.version>
    <jwt.version>0.7.0</jwt.version>
    <aliyun-java-sdk-core.version>4.3.3</aliyun-java-sdk-core.version>
    <aliyun-java-sdk-vod.version>2.15.2</aliyun-java-sdk-vod.version>
    <aliyun-sdk-vod-upload.version>1.4.11</aliyun-sdk-vod-upload.version>
    <fastjson.version>1.2.28</fastjson.version>
    <gson.version>2.8.2</gson.version>
    <json.version>20170516</json.version>
    <commons-dbutils.version>1.7</commons-dbutils.version>
    <canal.client.version>1.1.0</canal.client.version>
    <docker.image.prefix>zx</docker.image.prefix>
    <alibaba.easyexcel.version>2.1.1</alibaba.easyexcel.version>
    <apache.xmlbeans.version>3.1.0</apache.xmlbeans.version>
</properties>
```

> 5 配置pom依赖管理

```xml
<dependencyManagement>
    <dependencies>
        <!--Spring Cloud-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Hoxton.SR1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-alibaba-dependencies</artifactId>
            <version>2.1.0.RELEASE</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!--mybatis-plus 持久层-->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>${mybatis-plus.version}</version>
        </dependency>
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-generator</artifactId>
            <version>${mybatis-plus.version}</version>
        </dependency>
        <!-- velocity 模板引擎, Mybatis Plus 代码生成器需要 -->
        <dependency>
            <groupId>org.apache.velocity</groupId>
            <artifactId>velocity-engine-core</artifactId>
            <version>${velocity.version}</version>
        </dependency>
        <!--swagger-->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>${swagger.version}</version>
        </dependency>
        <!--swagger ui-->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>${swagger.version}</version>
        </dependency>
        <!--aliyunOSS-->
        <dependency>
            <groupId>com.aliyun.oss</groupId>
            <artifactId>aliyun-sdk-oss</artifactId>
            <version>${aliyun.oss.version}</version>
        </dependency>
        <!--日期时间工具-->
        <dependency>
            <groupId>joda-time</groupId>
            <artifactId>joda-time</artifactId>
            <version>${jodatime.version}</version>
        </dependency>
        <!--文件上传-->
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>${commons-fileupload.version}</version>
        </dependency>
        <!--commons-io-->
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>${commons-io.version}</version>
        </dependency>
        <!--commons-lang3-->
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>${commons-lang.version}</version>
        </dependency>
        <!--httpclient-->
        <dependency>
            <groupId>org.apache.httpcomponents</groupId>
            <artifactId>httpclient</artifactId>
            <version>${httpclient.version}</version>
        </dependency>
        <!-- JWT -->
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt</artifactId>
            <version>${jwt.version}</version>
        </dependency>
        <!--aliyun-->
        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-core</artifactId>
            <version>${aliyun-java-sdk-core.version}</version>
        </dependency>
        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-vod</artifactId>
            <version>${aliyun-java-sdk-vod.version}</version>
        </dependency>
        <!--<dependency>-->
        <!--<groupId>com.aliyun</groupId>-->
        <!--<artifactId>aliyun-sdk-vod-upload</artifactId>-->
        <!--<version>${aliyun-sdk-vod-upload.version}</version>-->
        <!--</dependency>-->
        <!--json-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>${fastjson.version}</version>
        </dependency>
        <dependency>
            <groupId>org.json</groupId>
            <artifactId>json</artifactId>
            <version>${json.version}</version>
        </dependency>
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>${gson.version}</version>
        </dependency>
        <dependency>
            <groupId>commons-dbutils</groupId>
            <artifactId>commons-dbutils</artifactId>
            <version>${commons-dbutils.version}</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba.otter</groupId>
            <artifactId>canal.client</artifactId>
            <version>${canal.client.version}</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>easyexcel</artifactId>
            <version>${alibaba.easyexcel.version}</version>
        </dependency>
        <dependency>
            <groupId>org.apache.xmlbeans</groupId>
            <artifactId>xmlbeans</artifactId>
            <version>${apache.xmlbeans.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

> 6 至此，创建项目完成



# 3 创建父模块common

1. ## 创建模块

在<font size=4 color="red">yunzoukj_parent</font>下创建<font size=4 color="red">普通maven</font>模块

Group：<font size=4 color="red">com.yunzoukj</font>

Artifact：<font size=4 color="red">common</font>

2. ## 删除src目录

3. ## 配置pom

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--mybatis-plus-->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
    </dependency>
    <!--lombok用来简化实体类：需要安装lombok插件-->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
    <!--swagger-->
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
    </dependency>
</dependencies>
```



# 4 创建common下的模块common_util

在<font size=4 color="red">common</font>下创建普通maven模块

Group：<font size=4 color="red">com.yunzoukj</font>

Artifact：<font size=4 color="red">common_util</font>

**注意：项目路径**

<font size=4 color="red">xx/yunzoukj_parent/common/common_util</font>

![image-20211013121234470](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013121234470.png)



# 5 创建common下的模块service_base

1. ## 创建模块

在<font size=4 color="red">common</font>下创建普通maven模块

Group：<font size=4 color="red">com.yunzoukj</font>

Artifact：<font size=4 color="red">service_base</font>

**注意：项目路径**

<font size=4 color="red">xx/yunzoukj_parent/common/service_base</font>

![image-20211013121413056](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013121413056.png)

2. ## 配置pom

```xml
<dependencies>
     <dependency>
         <groupId>com.yunzoukj</groupId>
         <artifactId>common_util</artifactId>
         <version>0.0.1-SNAPSHOT</version>
     </dependency>
</dependencies>
```



<font size=4 color="red">依赖jar包是可以继承的，因为common的pom里有，所以service_base的pom里有</font>

![image-20211013121810403](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013121810403.png)



# 6 创建父模块service

1. ## 创建模块

在<font size=4 color="red">yunzoukj_parent</font>下创建普通maven模块

Group：<font size=4 color="red">com.yunzoukj</font>

Artifact：<font size=4 color="red">service</font>

2. ## 删除src目录

3. ## 配置pom

```xml
<dependencies>
    <dependency>
        <groupId>com.yunzoukj</groupId>
        <artifactId>service_base</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--mybatis-plus-->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
    </dependency>
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-generator</artifactId>
    </dependency>
    <!--mysql-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>
    <!-- velocity 模板引擎, Mybatis Plus 代码生成器需要 -->
    <dependency>
        <groupId>org.apache.velocity</groupId>
        <artifactId>velocity-engine-core</artifactId>
    </dependency>
    <!--swagger-->
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
    </dependency>
    <!--日期时间工具-->
    <dependency>
        <groupId>joda-time</groupId>
        <artifactId>joda-time</artifactId>
    </dependency>
    <!--lombok用来简化实体类：需要安装lombok插件-->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
    <dependency>
        <groupId>commons-fileupload</groupId>
        <artifactId>commons-fileupload</artifactId>
    </dependency>
    <!--httpclient-->
    <dependency>
        <groupId>org.apache.httpcomponents</groupId>
        <artifactId>httpclient</artifactId>
    </dependency>
    <!--commons-io-->
    <dependency>
        <groupId>commons-io</groupId>
        <artifactId>commons-io</artifactId>
    </dependency>
    <!--json-->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>fastjson</artifactId>
    </dependency>
    <dependency>
        <groupId>org.json</groupId>
        <artifactId>json</artifactId>
    </dependency>
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
        <exclusions>
            <exclusion>
                <groupId>org.junit.vintage</groupId>
                <artifactId>junit-vintage-engine</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
</dependencies>
```



# 7 创建service下的模块service_edu

在<font size=4 color="red">service</font>下创建普通maven模块

Group：<font size=4 color="red">com.yunzoukj</font>

Artifact：<font size=4 color="red">service_edu</font>

**注意：项目路径**

![image-20211013122638873](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013122638873.png)



<font size=4 color="red">service_edu继承了service的所有依赖，所以不用配置POM</font>



