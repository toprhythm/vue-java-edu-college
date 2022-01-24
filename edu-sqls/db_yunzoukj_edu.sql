/*
 Navicat Premium Data Transfer

 Source Server         : 216.127.184.152
 Source Server Type    : MySQL
 Source Server Version : 50735
 Source Host           : 216.127.184.152:3306
 Source Schema         : db_yunzoukj_edu

 Target Server Type    : MySQL
 Target Server Version : 50735
 File Encoding         : 65001

 Date: 20/12/2021 14:49:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for edu_chapter
-- ----------------------------
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

-- ----------------------------
-- Records of edu_chapter
-- ----------------------------
BEGIN;
INSERT INTO `edu_chapter` VALUES ('1458032768418471938', '1458032708263763969', '第一章 三才剑法', 0, '2021-11-09 19:24:36', '2021-11-09 19:24:36');
INSERT INTO `edu_chapter` VALUES ('1458235785608626178', '1458235744282148866', '第一章 月夕花晨', 0, '2021-11-10 08:51:19', '2021-11-10 08:51:19');
INSERT INTO `edu_chapter` VALUES ('1458626191131348993', '1458626134323695618', '第一章 月夕花晨', 0, '2021-11-11 10:42:39', '2021-11-11 10:42:39');
COMMIT;

-- ----------------------------
-- Table structure for edu_comment
-- ----------------------------
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

-- ----------------------------
-- Table structure for edu_course
-- ----------------------------
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

-- ----------------------------
-- Records of edu_course
-- ----------------------------
BEGIN;
INSERT INTO `edu_course` VALUES ('1458032708263763969', '10', '1458032025573679106', '1458032022759301121', '月夕花晨', 0.20, 123, 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/cover/2021/11/09/6af87615-bc13-48e6-bd79-d24cb3d28f06.jpeg', 1, 34, 1, 'Normal', '2021-11-09 19:24:21', '2021-11-18 14:08:08');
INSERT INTO `edu_course` VALUES ('1458235744282148866', '4', '1458032025573679106', '1458032022759301121', '周111', 0.10, 12, 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/cover/2021/11/10/c5252aec-a28c-44f4-aaf4-96fd61c19be7.jpeg', 1, 6, 1, 'Normal', '2021-11-10 08:51:09', '2021-11-18 12:20:42');
INSERT INTO `edu_course` VALUES ('1458626134323695618', '10', '1458032041394593794', '1458032034054561793', '爬取财商课程', 0.00, 123, 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/cover/2021/11/11/daa4e226-37c4-4c59-9487-cbc24af7d0b4.jpeg', 0, 13, 1, 'Normal', '2021-11-11 10:42:25', '2021-11-18 12:15:54');
COMMIT;

-- ----------------------------
-- Table structure for edu_course_collect
-- ----------------------------
DROP TABLE IF EXISTS `edu_course_collect`;
CREATE TABLE `edu_course_collect` (
  `id` char(19) NOT NULL COMMENT '收藏ID',
  `course_id` char(19) NOT NULL COMMENT '课程讲师ID',
  `member_id` char(19) NOT NULL DEFAULT '' COMMENT '课程专业ID',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='课程收藏';

-- ----------------------------
-- Records of edu_course_collect
-- ----------------------------
BEGIN;
INSERT INTO `edu_course_collect` VALUES ('1460447089752698881', '1458032708263763969', '1459700192091983873', '2021-11-16 11:18:15', '2021-11-16 11:18:15');
INSERT INTO `edu_course_collect` VALUES ('1460447365473660929', '1458626134323695618', '1459700192091983873', '2021-11-16 11:19:20', '2021-11-16 11:19:20');
COMMIT;

-- ----------------------------
-- Table structure for edu_course_description
-- ----------------------------
DROP TABLE IF EXISTS `edu_course_description`;
CREATE TABLE `edu_course_description` (
  `id` char(19) NOT NULL COMMENT '课程ID',
  `description` text COMMENT '课程简介',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程简介';

-- ----------------------------
-- Records of edu_course_description
-- ----------------------------
BEGIN;
INSERT INTO `edu_course_description` VALUES ('1458032708263763969', '<p>123</p>', '2021-11-09 19:24:22', '2021-11-13 13:04:15');
INSERT INTO `edu_course_description` VALUES ('1458235744282148866', '<p>12</p>', '2021-11-10 08:51:09', '2021-11-11 10:51:02');
INSERT INTO `edu_course_description` VALUES ('1458626134323695618', '<p>123</p>', '2021-11-11 10:42:25', '2021-11-11 11:31:33');
COMMIT;

-- ----------------------------
-- Table structure for edu_subject
-- ----------------------------
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

-- ----------------------------
-- Records of edu_subject
-- ----------------------------
BEGIN;
INSERT INTO `edu_subject` VALUES ('1458032022759301121', '后端开发', '0', 0, '2021-11-09 19:21:38', '2021-11-09 19:21:38');
INSERT INTO `edu_subject` VALUES ('1458032025573679106', 'Java', '1458032022759301121', 0, '2021-11-09 19:21:38', '2021-11-09 19:21:38');
INSERT INTO `edu_subject` VALUES ('1458032029776371713', 'Python', '1458032022759301121', 0, '2021-11-09 19:21:39', '2021-11-09 19:21:39');
INSERT INTO `edu_subject` VALUES ('1458032034054561793', '前端开发', '0', 0, '2021-11-09 19:21:41', '2021-11-09 19:21:41');
INSERT INTO `edu_subject` VALUES ('1458032036755693570', 'HTML/CSS', '1458032034054561793', 0, '2021-11-09 19:21:41', '2021-11-09 19:21:41');
INSERT INTO `edu_subject` VALUES ('1458032041394593794', 'JavaScript', '1458032034054561793', 0, '2021-11-09 19:21:42', '2021-11-09 19:21:42');
INSERT INTO `edu_subject` VALUES ('1458032046184488961', '云计算', '0', 0, '2021-11-09 19:21:43', '2021-11-09 19:21:43');
INSERT INTO `edu_subject` VALUES ('1458032048961118210', 'Docker', '1458032046184488961', 0, '2021-11-09 19:21:44', '2021-11-09 19:21:44');
INSERT INTO `edu_subject` VALUES ('1458032055642644481', 'Linux', '1458032046184488961', 0, '2021-11-09 19:21:46', '2021-11-09 19:21:46');
INSERT INTO `edu_subject` VALUES ('1458032059925028865', '系统/运维', '0', 0, '2021-11-09 19:21:47', '2021-11-09 19:21:47');
INSERT INTO `edu_subject` VALUES ('1458032066153570305', 'Linux', '1458032059925028865', 0, '2021-11-09 19:21:48', '2021-11-09 19:21:48');
INSERT INTO `edu_subject` VALUES ('1458032071794909185', 'Windows', '1458032059925028865', 0, '2021-11-09 19:21:49', '2021-11-09 19:21:49');
INSERT INTO `edu_subject` VALUES ('1458032074542178305', '数据库', '0', 0, '2021-11-09 19:21:50', '2021-11-09 19:21:50');
INSERT INTO `edu_subject` VALUES ('1458032078740676609', 'MySQL', '1458032074542178305', 0, '2021-11-09 19:21:51', '2021-11-09 19:21:51');
INSERT INTO `edu_subject` VALUES ('1458032083534766082', 'MongoDB', '1458032074542178305', 0, '2021-11-09 19:21:52', '2021-11-09 19:21:52');
INSERT INTO `edu_subject` VALUES ('1458032087594852353', '大数据', '0', 0, '2021-11-09 19:21:53', '2021-11-09 19:21:53');
INSERT INTO `edu_subject` VALUES ('1458032091625578497', 'Hadoop', '1458032087594852353', 0, '2021-11-09 19:21:54', '2021-11-09 19:21:54');
INSERT INTO `edu_subject` VALUES ('1458032095635333121', 'Spark', '1458032087594852353', 0, '2021-11-09 19:21:55', '2021-11-09 19:21:55');
INSERT INTO `edu_subject` VALUES ('1458032098370019329', '人工智能', '0', 0, '2021-11-09 19:21:56', '2021-11-09 19:21:56');
INSERT INTO `edu_subject` VALUES ('1458032101104705538', 'Python', '1458032098370019329', 0, '2021-11-09 19:21:56', '2021-11-09 19:21:56');
INSERT INTO `edu_subject` VALUES ('1458032104510480386', '编程语言', '0', 0, '2021-11-09 19:21:57', '2021-11-09 19:21:57');
INSERT INTO `edu_subject` VALUES ('1458032108587343874', 'Java', '1458032104510480386', 0, '2021-11-09 19:21:58', '2021-11-09 19:21:58');
COMMIT;

-- ----------------------------
-- Table structure for edu_teacher
-- ----------------------------
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

-- ----------------------------
-- Records of edu_teacher
-- ----------------------------
BEGIN;
INSERT INTO `edu_teacher` VALUES ('1', '刘德华', '毕业于师范大学数学系，热爱教育事业，执教数学思维6年有余', '具备深厚的数学思维功底、丰富的小学教育经验，授课风格生动活泼，擅长用形象生动的比喻帮助理解、简单易懂的语言讲解难题，深受学生喜欢', 2, 'https://online-teach-file-helen.oss-cn-beijing.aliyuncs.com/avatar/2019/11/25/03.jpg', 10, '2019-10-29', 0, '2018-03-30 17:15:57', '2019-04-28 05:02:18');
INSERT INTO `edu_teacher` VALUES ('10', '唐嫣', '北京师范大学法学院副教授', '北京师范大学法学院副教授、清华大学法学博士。自2004年至今已有9年的司法考试培训经验。长期从事司法考试辅导，深知命题规律，了解解题技巧。内容把握准确，授课重点明确，层次分明，调理清晰，将法条法理与案例有机融合，强调综合，深入浅出。', 1, 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/avatar/2021/11/11/2a891890-4bc3-429a-b9f0-e5d035a8b25b.jpg', 20, '2019-10-29', 0, '2018-04-03 14:32:19', '2021-11-11 11:11:17');
INSERT INTO `edu_teacher` VALUES ('2', '周润发', '中国人民大学附属中学数学一级教师', '中国科学院数学与系统科学研究院应用数学专业博士，研究方向为数字图像处理，中国工业与应用数学学会会员。参与全国教育科学“十五”规划重点课题“信息化进程中的教育技术发展研究”的子课题“基与课程改革的资源开发与应用”，以及全国“十五”科研规划全国重点项目“掌上型信息技术产品在教学中的运用和开发研究”的子课题“用技术学数学”。', 2, 'https://guli-file-helen.oss-cn-beijing.aliyuncs.com/avatar/2020/04/14/f606ed5b-1d46-43a1-945c-3e1b3b58fc0a.jpg', 1, '2019-10-28', 0, '2018-03-30 18:28:26', '2020-04-14 17:40:36');
INSERT INTO `edu_teacher` VALUES ('3', '钟汉良', '钟汉良钟汉良钟汉良钟汉良', '中教一级职称。讲课极具亲和力。', 1, 'http://guli-file.oss-cn-beijing.aliyuncs.com/avatar/2019/02/26/250bab5f-bbd6-49ab-80c3-7413ce806e83.jpg', 2, '2019-10-29', 0, '2018-03-31 09:20:46', '2019-02-22 02:01:27');
INSERT INTO `edu_teacher` VALUES ('4', '周杰伦', '长期从事考研政治课讲授和考研命题趋势与应试对策研究。考研辅导新锐派的代表。', '政治学博士、管理学博士后，北京师范大学马克思主义学院副教授。多年来总结出了一套行之有效的应试技巧与答题方法，针对性和实用性极强，能帮助考生在轻松中应考，在激励的竞争中取得高分，脱颖而出。', 1, 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/avatar/2021/11/10/c8f5e7e8-cd00-4a02-a5cd-dddb21231c8e.jpg', 1, '2019-10-27', 0, '2018-04-03 14:13:51', '2021-11-10 08:40:42');
INSERT INTO `edu_teacher` VALUES ('5', '陈伟霆', '人大附中2009届毕业生', '北京大学数学科学学院2008级本科生，2012年第八届学生五四奖章获得者，在数学领域取得多项国际国内奖项，学术研究成绩突出。曾被两次评为北京大学三好学生、一次评为北京大学三好标兵，获得过北京大学国家奖学金、北京大学廖凯原奖学金、北京大学星光国际一等奖学金、北京大学明德新生奖学金等。', 1, '', 1, '2019-10-29', 0, '2018-04-03 14:15:36', '2019-02-22 02:01:29');
INSERT INTO `edu_teacher` VALUES ('6', '姚晨', '华东师范大学数学系硕士生导师，中国数学奥林匹克高级教练', '曾参与北京市及全国多项数学活动的命题和组织工作，多次带领北京队参加高中、初中、小学的各项数学竞赛，均取得优异成绩。教学活而新，能够调动学生的学习兴趣并擅长对学生进行思维点拨，对学生学习习惯的养成和非智力因素培养有独到之处，是一位深受学生喜爱的老师。', 1, '', 1, '2019-10-29', 0, '2018-04-01 14:19:28', '2019-02-22 02:01:29');
INSERT INTO `edu_teacher` VALUES ('7', '胡歌', '考研政治辅导实战派专家，全国考研政治命题研究组核心成员。', '法学博士，北京师范大学马克思主义学院副教授，专攻毛泽东思想概论、邓小平理论，长期从事考研辅导。出版著作两部，发表学术论文30余篇，主持国家社会科学基金项目和教育部重大课题子课题各一项，参与中央实施马克思主义理论研究和建设工程项目。', 2, '', 8, '2019-09-04', 0, '2018-04-03 14:21:03', '2019-02-22 02:01:30');
INSERT INTO `edu_teacher` VALUES ('8', '谢娜', '资深课程设计专家，专注10年AACTP美国培训协会认证导师', '十年课程研发和培训咨询经验，曾任国企人力资源经理、大型外企培训经理，负责企业大学和培训体系搭建；曾任专业培训机构高级顾问、研发部总监，为包括广东移动、东莞移动、深圳移动、南方电网、工商银行、农业银行、民生银行、邮储银行、TCL集团、清华大学继续教育学院、中天路桥、广西扬翔股份等超过200家企业提供过培训与咨询服务，并担任近50个大型项目的总负责人。', 1, '', 10, '2019-10-29', 0, '2018-04-03 14:23:33', '2019-11-23 08:38:09');
COMMIT;

-- ----------------------------
-- Table structure for edu_video
-- ----------------------------
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

-- ----------------------------
-- Records of edu_video
-- ----------------------------
BEGIN;
INSERT INTO `edu_video` VALUES ('1458032873108299778', '1458032708263763969', '1458032768418471938', '第一节 平刺', 'b4703b05730f438ca3179ae2b7605ed1', 'ylszEncrypt.mp4', 0, 0, 0, 0, 'Empty', 0, 1, '2021-11-09 19:25:01', '2021-11-09 19:25:01');
INSERT INTO `edu_video` VALUES ('1458235894622781442', '1458235744282148866', '1458235785608626178', '第一节 三才剑法', '237b9746ca0e499f8dbe7cbcd5af0cb6', 'ylszEncrypt.mp4', 0, 0, 0, 0, 'Empty', 0, 1, '2021-11-10 08:51:45', '2021-11-10 08:51:45');
INSERT INTO `edu_video` VALUES ('1458626282596536322', '1458626134323695618', '1458626191131348993', '第一节 三才剑法', NULL, NULL, 0, 0, 0, 0, 'Empty', 0, 1, '2021-11-11 10:43:00', '2021-11-11 10:43:00');
INSERT INTO `edu_video` VALUES ('1458638173691666433', '1458032708263763969', '1458032768418471938', '第二节 双手剑术', '0a41ec32e4d3486281cf08ed46332ea4', 'yilishazi.mp4', 0, 0, 1, 0, 'Empty', 0, 1, '2021-11-11 11:30:15', '2021-11-11 11:30:15');
INSERT INTO `edu_video` VALUES ('1458638588202147842', '1458626134323695618', '1458626191131348993', '第二节 爬虫', 'bcc49cd4f2e743298d253c8a4ffe53b6', 'ylszEncrypt.mp4', 0, 0, 1, 0, 'Empty', 0, 1, '2021-11-11 11:31:54', '2021-11-11 11:31:54');
INSERT INTO `edu_video` VALUES ('1459386691301584898', '1458032708263763969', '1458032768418471938', '第三节 若依剑舞', 'a5180b254ee4474c94e0d7d8ac51b9b5', 'tianxin22.mp4', 0, 0, 1, 0, 'Empty', 0, 1, '2021-11-13 13:04:36', '2021-11-13 13:04:36');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
