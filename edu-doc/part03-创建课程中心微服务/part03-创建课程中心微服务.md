# part03-创建课程中心微服务



# 1 数据库设计

1. ## 数据库

创建数据库：<font size=4 color="red">yunzoukj_edu</font>

字符集： <font size=4 color="red">utf8mb4</font>

字符排序规则: <font size=4 color="red">utf8mb4_general_ci</font>

![image-20211013124048829](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013124048829.png)



2. ## **数据表**

执行sql脚本

<font size=4 color="red">guli_edu.sql</font>

```sql
/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.7.21-log : Database - guli_edu
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `edu_chapter` */

DROP TABLE IF EXISTS `edu_chapter`;

CREATE TABLE `edu_chapter` (
  `id` char(19) NOT NULL COMMENT '章节ID',
  `course_id` char(19) NOT NULL COMMENT '课程ID',
  `title` varchar(50) NOT NULL COMMENT '章节名称',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '显示排序',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程';

/*Data for the table `edu_chapter` */

/*Table structure for table `edu_comment` */

DROP TABLE IF EXISTS `edu_comment`;

CREATE TABLE `edu_comment` (
  `id` char(19) NOT NULL COMMENT '讲师ID',
  `course_id` char(19) NOT NULL DEFAULT '' COMMENT '课程id',
  `teacher_id` char(19) NOT NULL DEFAULT '' COMMENT '讲师id',
  `member_id` char(19) NOT NULL DEFAULT '' COMMENT '会员id',
  `nickname` varchar(50) DEFAULT NULL COMMENT '会员昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '会员头像',
  `content` varchar(500) DEFAULT NULL COMMENT '评论内容',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论';

/*Data for the table `edu_comment` */

/*Table structure for table `edu_course` */

DROP TABLE IF EXISTS `edu_course`;

CREATE TABLE `edu_course` (
  `id` char(19) NOT NULL COMMENT '课程ID',
  `teacher_id` char(19) NOT NULL COMMENT '课程讲师ID',
  `subject_id` char(19) NOT NULL COMMENT '课程专业ID',
  `subject_parent_id` char(19) NOT NULL COMMENT '课程专业父级ID',
  `title` varchar(50) NOT NULL COMMENT '课程标题',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '课程销售价格，设置为0则可免费观看',
  `lesson_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总课时',
  `cover` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '课程封面图片路径',
  `buy_count` bigint(10) unsigned NOT NULL DEFAULT '0' COMMENT '销售数量',
  `view_count` bigint(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览数量',
  `version` bigint(20) unsigned NOT NULL DEFAULT '1' COMMENT '乐观锁',
  `status` varchar(10) NOT NULL DEFAULT 'Draft' COMMENT '课程状态 Draft未发布  Normal已发布',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_title` (`title`),
  KEY `idx_subject_id` (`subject_id`),
  KEY `idx_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程';

/*Data for the table `edu_course` */

/*Table structure for table `edu_course_collect` */

DROP TABLE IF EXISTS `edu_course_collect`;

CREATE TABLE `edu_course_collect` (
  `id` char(19) NOT NULL COMMENT '收藏ID',
  `course_id` char(19) NOT NULL COMMENT '课程讲师ID',
  `member_id` char(19) NOT NULL DEFAULT '' COMMENT '课程专业ID',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程收藏';

/*Data for the table `edu_course_collect` */

/*Table structure for table `edu_course_description` */

DROP TABLE IF EXISTS `edu_course_description`;

CREATE TABLE `edu_course_description` (
  `id` char(19) NOT NULL COMMENT '课程ID',
  `description` text COMMENT '课程简介',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程简介';

/*Data for the table `edu_course_description` */

/*Table structure for table `edu_subject` */

DROP TABLE IF EXISTS `edu_subject`;

CREATE TABLE `edu_subject` (
  `id` char(19) NOT NULL COMMENT '课程类别ID',
  `title` varchar(10) NOT NULL COMMENT '类别名称',
  `parent_id` char(19) NOT NULL DEFAULT '0' COMMENT '父ID',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序字段',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程科目';

/*Data for the table `edu_subject` */

/*Table structure for table `edu_teacher` */

DROP TABLE IF EXISTS `edu_teacher`;

CREATE TABLE `edu_teacher` (
  `id` char(19) NOT NULL COMMENT '讲师ID',
  `name` varchar(20) NOT NULL COMMENT '讲师姓名',
  `intro` varchar(500) NOT NULL DEFAULT '' COMMENT '讲师简介',
  `career` varchar(500) DEFAULT NULL COMMENT '讲师资历,一句话说明讲师',
  `level` int(10) unsigned NOT NULL COMMENT '头衔 1高级讲师 2首席讲师',
  `avatar` varchar(255) DEFAULT NULL COMMENT '讲师头像',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `join_date` date DEFAULT NULL COMMENT '入驻时间',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='讲师';

/*Data for the table `edu_teacher` */

insert  into `edu_teacher`(`id`,`name`,`intro`,`career`,`level`,`avatar`,`sort`,`join_date`,`is_deleted`,`gmt_create`,`gmt_modified`) values ('1','刘德华','毕业于师范大学数学系，热爱教育事业，执教数学思维6年有余','具备深厚的数学思维功底、丰富的小学教育经验，授课风格生动活泼，擅长用形象生动的比喻帮助理解、简单易懂的语言讲解难题，深受学生喜欢',2,'https://online-teach-file-helen.oss-cn-beijing.aliyuncs.com/avatar/2019/11/25/03.jpg',10,'2019-10-29',0,'2018-03-30 17:15:57','2019-04-28 05:02:18'),('10','唐嫣','北京师范大学法学院副教授','北京师范大学法学院副教授、清华大学法学博士。自2004年至今已有9年的司法考试培训经验。长期从事司法考试辅导，深知命题规律，了解解题技巧。内容把握准确，授课重点明确，层次分明，调理清晰，将法条法理与案例有机融合，强调综合，深入浅出。',1,'http://guli-file.oss-cn-beijing.aliyuncs.com/avatar/2019/02/27/073eb5d2-f5f4-488a-82ed-aec8a5289a5d.png',20,'2019-10-29',0,'2018-04-03 14:32:19','2019-02-22 02:01:26'),('2','周润发','中国人民大学附属中学数学一级教师','中国科学院数学与系统科学研究院应用数学专业博士，研究方向为数字图像处理，中国工业与应用数学学会会员。参与全国教育科学“十五”规划重点课题“信息化进程中的教育技术发展研究”的子课题“基与课程改革的资源开发与应用”，以及全国“十五”科研规划全国重点项目“掌上型信息技术产品在教学中的运用和开发研究”的子课题“用技术学数学”。',2,'https://guli-file-helen.oss-cn-beijing.aliyuncs.com/avatar/2020/04/14/f606ed5b-1d46-43a1-945c-3e1b3b58fc0a.jpg',1,'2019-10-28',0,'2018-03-30 18:28:26','2020-04-14 17:40:36'),('3','钟汉良','钟汉良钟汉良钟汉良钟汉良','中教一级职称。讲课极具亲和力。',1,'http://guli-file.oss-cn-beijing.aliyuncs.com/avatar/2019/02/26/250bab5f-bbd6-49ab-80c3-7413ce806e83.jpg',2,'2019-10-29',0,'2018-03-31 09:20:46','2019-02-22 02:01:27'),('4','周杰伦','长期从事考研政治课讲授和考研命题趋势与应试对策研究。考研辅导新锐派的代表。','政治学博士、管理学博士后，北京师范大学马克思主义学院副教授。多年来总结出了一套行之有效的应试技巧与答题方法，针对性和实用性极强，能帮助考生在轻松中应考，在激励的竞争中取得高分，脱颖而出。',1,'https://online-teach-file-helen.oss-cn-beijing.aliyuncs.com/avatar/2019/11/25/fee1e99f-8852-4da0-a256-9732e55bb608.jpg',1,'2019-10-27',0,'2018-04-03 14:13:51','2019-10-29 19:52:46'),('5','陈伟霆','人大附中2009届毕业生','北京大学数学科学学院2008级本科生，2012年第八届学生五四奖章获得者，在数学领域取得多项国际国内奖项，学术研究成绩突出。曾被两次评为北京大学三好学生、一次评为北京大学三好标兵，获得过北京大学国家奖学金、北京大学廖凯原奖学金、北京大学星光国际一等奖学金、北京大学明德新生奖学金等。',1,'',1,'2019-10-29',0,'2018-04-03 14:15:36','2019-02-22 02:01:29'),('6','姚晨','华东师范大学数学系硕士生导师，中国数学奥林匹克高级教练','曾参与北京市及全国多项数学活动的命题和组织工作，多次带领北京队参加高中、初中、小学的各项数学竞赛，均取得优异成绩。教学活而新，能够调动学生的学习兴趣并擅长对学生进行思维点拨，对学生学习习惯的养成和非智力因素培养有独到之处，是一位深受学生喜爱的老师。',1,'',1,'2019-10-29',0,'2018-04-01 14:19:28','2019-02-22 02:01:29'),('7','胡歌','考研政治辅导实战派专家，全国考研政治命题研究组核心成员。','法学博士，北京师范大学马克思主义学院副教授，专攻毛泽东思想概论、邓小平理论，长期从事考研辅导。出版著作两部，发表学术论文30余篇，主持国家社会科学基金项目和教育部重大课题子课题各一项，参与中央实施马克思主义理论研究和建设工程项目。',2,'',8,'2019-09-04',0,'2018-04-03 14:21:03','2019-02-22 02:01:30'),('8','谢娜','资深课程设计专家，专注10年AACTP美国培训协会认证导师','十年课程研发和培训咨询经验，曾任国企人力资源经理、大型外企培训经理，负责企业大学和培训体系搭建；曾任专业培训机构高级顾问、研发部总监，为包括广东移动、东莞移动、深圳移动、南方电网、工商银行、农业银行、民生银行、邮储银行、TCL集团、清华大学继续教育学院、中天路桥、广西扬翔股份等超过200家企业提供过培训与咨询服务，并担任近50个大型项目的总负责人。',1,'',10,'2019-10-29',0,'2018-04-03 14:23:33','2019-11-23 08:38:09');

/*Table structure for table `edu_video` */

DROP TABLE IF EXISTS `edu_video`;

CREATE TABLE `edu_video` (
  `id` char(19) NOT NULL COMMENT '视频ID',
  `course_id` char(19) NOT NULL COMMENT '课程ID',
  `chapter_id` char(19) NOT NULL COMMENT '章节ID',
  `title` varchar(50) NOT NULL COMMENT '节点名称',
  `video_source_id` varchar(100) DEFAULT NULL COMMENT '云端视频资源',
  `video_original_name` varchar(100) DEFAULT NULL COMMENT '原始文件名称',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序字段',
  `play_count` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '播放次数',
  `is_free` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否可以试听：0收费 1免费',
  `duration` float NOT NULL DEFAULT '0' COMMENT '视频时长（秒）',
  `status` varchar(20) NOT NULL DEFAULT 'Empty' COMMENT '状态',
  `size` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '视频源文件大小（字节）',
  `version` bigint(20) unsigned NOT NULL DEFAULT '1' COMMENT '乐观锁',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_chapter_id` (`chapter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程视频';

/*Data for the table `edu_video` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

```





# 2 数据库设计规约

**注意：**数据库设计规约并不是数据库设计的严格规范，根据不同团队的不同要求设计

<font size=4 color="red">本项目参考《阿里巴巴Java开发手册》：五、MySQL数据库</font>

1、库名与应用名称尽量一致

2、表名、字段名必须使用小写字母或数字，禁止出现数字开头，

3、表名不使用复数名词

4、表的命名最好是加上“业务名称_表的作用”。如，edu_teacher

5、表必备三字段：id, gmt_create, gmt_modified

6、单表行数超过 500 万行或者单表容量超过 2GB，才推荐进行分库分表。 说明：如果预计三年后的数据量根本达不到这个级别，请不要在创建表时就分库分表。 

7、表达是与否概念的字段，必须使用 <font size=4 color="red">is_xxx</font> 的方式命名，数据类型是 unsigned tinyint （1 表示是，0 表示否）。 

说明：任何字段如果为非负数，必须是 unsigned。

注意：POJO 类中的任何布尔类型的变量，都不要加 is 前缀。数据库表示是与否的值，使用 tinyint 类型，坚持 is_xxx 的 命名方式是为了明确其取值含义与取值范围。 

正例：表达逻辑删除的字段名 is_deleted，1 表示删除，0 表示未删除。 

8、小数类型为 decimal，禁止使用 float 和 double。 说明：float 和 double 在存储的时候，存在精度损失的问题，很可能在值的比较时，得到不 正确的结果。如果存储的数据范围超过 decimal 的范围，建议将数据拆成整数和小数分开存储。

9、如果存储的字符串长度几乎相等，使用 char 定长字符串类型。 

10、varchar 是可变长字符串，不预先分配存储空间，长度不要超过 5000，如果存储长度大于此值，定义字段类型为 text，独立出来一张表，用主键来对应，<font size=4 color="red">避免影响其它字段索引效率</font>。

11、唯一索引名为 uk_字段名(unique key)；普通索引名则为 idx_字段名(index)。

说明：uk_ 即 unique key；idx_ 即 index 的简称

12、不得使用外键与级联，一切外键概念必须在应用层解决。外键与级联更新适用于单机低并发，不适合分布式、高并发集群；级联更新是强阻塞，存在数据库更新风暴的风险；外键影响数据库的插入速度。 



# 3 Mybatis-Plus代码生成器

<font size=4 color="red">Talk is cheap, Show me the code.    能说算不上什么,有本事就把你的代码给我看看。</font>



1. ## 创建代码生成器

<font size=4 color="red">service_edu的test目录中创建代码生成器 CodeGenerator.java</font>

```java
public class CodeGenerator {
  
    @Test
    public void genCode() {
        String prefix = "db_"; // 定义数据库前缀
        String moduleName = "edu"; // 定义模块名
        // 1、创建代码生成器
        AutoGenerator mpg = new AutoGenerator();
        // 2、全局配置
        GlobalConfig gc = new GlobalConfig();
        String projectPath = System.getProperty("user.dir");
        gc.setOutputDir(projectPath + "/src/main/java");
        gc.setAuthor("topthyrhm");
        gc.setOpen(false); //生成后是否打开资源管理器
//        gc.setFileOverride(false); //重新生成时文件是否覆盖
        gc.setServiceName("%sService"); //去掉Service接口的首字母I
        gc.setIdType(IdType.ASSIGN_ID); //主键策略
        gc.setDateType(DateType.ONLY_DATE);//定义生成的实体类中日期类型
        gc.setSwagger2(true);//开启Swagger2模式
        mpg.setGlobalConfig(gc);
        // 3、数据源配置
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setUrl("jdbc:mysql://localhost:3306/" + prefix + "yunzoukj_" + moduleName + "?serverTimezone=GMT%2B8");
        dsc.setDriverName("com.mysql.cj.jdbc.Driver");
        dsc.setUsername("root");
        dsc.setPassword("root");
        dsc.setDbType(DbType.MYSQL);
        mpg.setDataSource(dsc);
        // 4、包配置
        PackageConfig pc = new PackageConfig();
        pc.setModuleName(moduleName); //模块名
        pc.setParent("com.yunzoukj.yunzou.service");
        pc.setController("controller");
        pc.setEntity("entity");
        pc.setService("service");
        pc.setMapper("mapper");
        mpg.setPackageInfo(pc);
        // 5、策略配置
        StrategyConfig strategy = new StrategyConfig();
        strategy.setNaming(NamingStrategy.underline_to_camel);//数据库表映射到实体的命名策略
        strategy.setTablePrefix(moduleName + "_");//设置表前缀不生成
        strategy.setColumnNaming(NamingStrategy.underline_to_camel);//数据库表字段映射到实体的命名策略
        strategy.setEntityLombokModel(true); // lombok 模型 @Accessors(chain = true) setter链式操作
        strategy.setLogicDeleteFieldName("is_deleted");//逻辑删除字段名
        strategy.setEntityBooleanColumnRemoveIsPrefix(true);//去掉布尔值的is_前缀
        //自动填充
        TableFill gmtCreate = new TableFill("gmt_create", FieldFill.INSERT);
        TableFill gmtModified = new TableFill("gmt_modified", FieldFill.INSERT_UPDATE);
        ArrayList<TableFill> tableFills = new ArrayList<>();
        tableFills.add(gmtCreate);
        tableFills.add(gmtModified);
        strategy.setTableFillList(tableFills);
        strategy.setRestControllerStyle(true); //restful api风格控制器
        strategy.setControllerMappingHyphenStyle(true); //url中驼峰转连字符
        mpg.setStrategy(strategy);
        // 6、执行
        mpg.execute();
    }
}
```

2. ## **执行代码生成器**

<font size=4 color="red">XxxServiceImpl 继承了 ServiceImpl 类，并且MP为我们在ServiceImpl中注入了 baseMapper</font>



# 4 优化代码生成器

1. <font size=4 color="red">在common/service_base中创建BaseEntity</font>

```java

package com.yunzoukj.yunzou.service.base.model;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class BaseEntity implements Serializable {

    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "讲师ID")
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @ApiModelProperty(value = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @ApiModelProperty(value = "更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;

}
```

2. ## **设置SuperClass**

```java
//设置BaseEntity
strategy.setSuperEntityClass("com.yunzoukj.yunzou.service.base.model.BaseEntity");
// 填写BaseEntity中的公共字段
strategy.setSuperEntityColumns("id", "gmt_create", "gmt_modified");

//把上面两行代码复制到CodeGenerator.java的最底下
```

3. ## 删除原来的生成的com/,重新执行gencode()

发现所有实体类都继承了BaseEntity，并且ID，创建时间，更新时间都没了，继承自BaseEntity

4. ## 修改entity

<font size=4 color="red">Teacher.java 和 Video.java 中引入缺少的 @TableField 的包</font>



# 5 讲师管理程序开发

1. # 启动应用程序

2. ## 创建application.yml文件

```yaml
server:
  port: 8110 # 服务端口
spring:
  profiles:
    active: dev # 环境设置
  application:
    name: service-edu # 服务名
  datasource: # mysql数据库连接
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/db_yunzoukj_edu?characterEncoding=utf-8&serverTimezone=GMT%2B8
    username: root
    password: root
#mybatis日志
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

```

3. ## 创建SpringBoot配置文件

<font size=4 color="red">在service_base中创建MybatisPlusConfig</font>

```java

package com.yunzoukj.yunzou.service.base.config;

import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@EnableTransactionManagement
@Configuration
@MapperScan("com.yunzoukj.yunzou.service.*.mapper")
public class MybatisPlusConfig {

    /**
     * 分页插件
     */
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }
    
}
```

4. ## 创建SpringBoot启动类

```java
package com.yunzoukj.yunzou.service.edu;

@SpringBootApplication
@ComponentScan({"com.yunzoukj.yunzou"})// 扩大扫描范围 yunzou.servive.*.*.java
public class ServiceEduApplication {
  
    public static void main(String[] args) {
        SpringApplication.run(ServiceEduApplication.class, args);
    }
  
}
```

5. ## 运行启动类

查看控制台8110端口是否成功启动



# 6 讲师列表API

1. ## 编写讲师管理接口

修改TeacherController的包名，<font size=4 color="red">添加 ".admin"</font>

修改TeacherController的@RequestMapping，<font size=4 color="red">添加 "/admin"</font>

```java
package com.yunzoukj.yunzou.service.edu.controller.admin;

/**
 * <p>
 * 讲师 前端控制器
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
@RestController
@RequestMapping("/admin/edu/teacher")
public class TeacherController {

    @Autowired
    private TeacherService teacherService;

    @GetMapping("list")
    public List<Teacher> listAll(){
        return teacherService.list();
    }

}


```

浏览器查看: localhost:8110/admin/edu/teacher/list

2. ## 统一返回的json时间格式 

默认情况下json时间格式带有时区，并且是世界标准时间，和我们的时间差了八个小时

```yaml
#spring:
  jackson: #返回json的全局时间格式
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
```



Teacher.java 的 joinDate字段添加数据类型转换，可以覆盖全局配置,就是教师的参加时间只有日期，没有时间

```java
@JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd")
```



3. ## 重启程序

浏览器 localhost:8110/admin/edu/teacher/list

![image-20211013185520229](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013185520229.png)



# 7 逻辑删除API

1. ## 添加删除方法

TeacherController添加removeById方法

```java
@DeleteMapping("remove/{id}")
public boolean removeById(@PathVariable String id){
    return teacherService.removeById(id);
}
```

2. ## 使用postman测试删除

3. list

![image-20211013190459108](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013190459108.png)

delete

![image-20211013190518591](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013190518591.png)





# 8 Swagger2

1. # Swagger2介绍 

https://swagger.io/

前后端分离开发模式中，api文档是最好的沟通方式。

Swagger 是一个规范和完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务。

​	1 及时性<font size=4 color="red"> (接口变更后，能够及时准确地通知相关前后端开发人员)</font>

​	2 规范性 <font size=4 color="red">(并且保证接口的规范性，如接口的地址，请求方式，参数及响应格式和错误信息)</font>

​	3 一致性<font size=4 color="red"> (接口信息一致，不会出现因开发人员拿到的文档版本不一致，而出现分歧)</font>

​	4 可测性 <font size=4 color="red">(直接在接口文档上进行测试，以方便理解业务)</font>



- <font size=4 color="red">前端工程师编写接口文档（使用swagger2编辑器或其他接口生成工具）</font>
- <font size=4 color="red">交给后端工程师</font>
- <font size=4 color="red">根据swagger文档编写后端接口</font>
- <font size=4 color="red">最终根据生成的swagger文件进行接口联调</font>



2. # 配置Swagger2

2.1 common中添加依赖

```xml
<!--swagger-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.7.0</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.7.0</version>
</dependency>
```

2.2 创建Swagger2配置文件

<font size=4 color="red">在service_base中创建Swagger2Config</font>

```java
package com.yunzoukj.yunzou.service.base.config;

@Configuration
@EnableSwagger2
public class Swagger2Config {
    @Bean
    public Docket webApiConfig(){
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("webApi")
                .apiInfo(webApiInfo())
                .select()
                //只显示api路径下的页面
                .paths(Predicates.and(PathSelectors.regex("/api/.*")))
                .build();
    }

    @Bean
    public Docket adminApiConfig(){
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("adminApi")
                .apiInfo(adminApiInfo())
                .select()
                //只显示admin路径下的页面
                .paths(Predicates.and(PathSelectors.regex("/admin/.*")))
                .build();
    }
    private ApiInfo webApiInfo(){
        return new ApiInfoBuilder()
                .title("网站-API文档")
                .description("本文档描述了网站微服务接口定义")
                .version("1.0")
                .contact(new Contact("toprhythm", "http://edu.yunzoukj.com", "2573424062@qq.com"))
                .build();
    }
    private ApiInfo adminApiInfo(){
        return new ApiInfoBuilder()
                .title("后台管理系统-API文档")
                .description("本文档描述了后台管理系统微服务接口定义")
                .version("1.0")
                .contact(new Contact("toprhythm", "http://edu.yunzoukj.com", "2573424062@qq.com"))
                .build();
    }
}
```

2.3 设置Entity的Example值 Teacher

```java
@ApiModelProperty(value = "入驻时间", example="2021-01-01")
private Date joinDate;
```

![image-20211013192532720](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013192532720.png)

2.4 设置ApiOperation("根据ID删除讲师") TeacherController

```java
@ApiOperation("所有讲师列表")
@GetMapping("list")
public List<Teacher> listAll(){
  return teacherService.list();
}

@ApiOperation("根据ID删除讲师")
@DeleteMapping("remove/{id}")
public boolean removeById(@ApiParam(value = "讲师ID", required = true) @PathVariable String id){
  return teacherService.removeById(id);
}

```

![image-20211013192729370](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013192729370.png)

2.5 @Api

```java
@Api(description = "讲师管理")
@RestController
@RequestMapping("/admin/edu/teacher")
public class TeacherController {
```

![image-20211013193030967](https://gitee.com/toprhythm/imagebed/raw/master/picgoimagebebrepo/image-20211013193030967.png)

2.6 重启服务器查看接口

http://localhost:8110/swagger-ui.html



# 9 Swagger2常见注解

1. ## API模型

entity的实体类中可以添加一些自定义设置，例如：

定义样例数据

```java
@ApiModelProperty(value = "入驻时间", example = "2010-01-01")
@JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd")
private Date joinDate;
@ApiModelProperty(value = "创建时间", example = "2019-01-01 8:00:00")
@TableField(fill = FieldFill.INSERT)
private Date gmtCreate;
@ApiModelProperty(value = "更新时间", example = "2019-01-01 8:00:00")
@TableField(fill = FieldFill.INSERT_UPDATE)
private Date gmtModified;
```

2. ## 定义接口说明和参数说明

```java
定义在类上：@Api
定义在方法上：@ApiOperation
定义在参数上：@ApiParam
```



```java
package com.yunzoukj.yunzou.service.edu.controller.admin;

/**
 * <p>
 * 讲师 前端控制器
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
@Api(description = "讲师管理")
@RestController
@RequestMapping("/admin/edu/teacher")
public class TeacherController {

    @Autowired
    private TeacherService teacherService;

    @ApiOperation("所有讲师列表")
    @GetMapping("list")
    public List<Teacher> listAll(){
        return teacherService.list();
    }

    @ApiOperation("根据ID删除讲师")
    @DeleteMapping("remove/{id}")
    public boolean removeById(@ApiParam(value = "讲师ID", required = true) @PathVariable String id){
        return teacherService.removeById(id);
    }

}


```



至此 Swagger2 整合完成



# 10 SpringBoot整合热部署

Ø 1 什么是热部署？ 修改java类或页而或者静态文件,不需要手动重启 原理:类加载器

Ø 2 需要安装Idea整合 整合Lombok插件，

Ø 3 <font size=4 color="red">service_edu/ pom.xml</font>

```xml
<!--SpringBoot热部署配置 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

Ø 4 “Files” -> “settings” ->”Build,Execution,Deploment” -> “Compiler” -> 勾选 “Buid Project automaticly”

Ø 5 “Shift + Command + ALT + / ”,选择“Registry”，选中打钩：compiler.automake.allow.when.app.running'

Ø 5 成功了，修改完java文件保存后等两三秒刷新一下就好了

 



