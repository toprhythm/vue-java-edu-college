/*
 Navicat Premium Data Transfer

 Source Server         : 216.127.184.152
 Source Server Type    : MySQL
 Source Server Version : 50735
 Source Host           : 216.127.184.152:3306
 Source Schema         : db_yunzoukj_cms

 Target Server Type    : MySQL
 Target Server Version : 50735
 File Encoding         : 65001

 Date: 20/12/2021 14:49:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cms_ad
-- ----------------------------
DROP TABLE IF EXISTS `cms_ad`;
CREATE TABLE `cms_ad` (
  `id` char(19) NOT NULL DEFAULT '' COMMENT 'ID',
  `title` varchar(20) DEFAULT '' COMMENT '标题',
  `type_id` char(19) NOT NULL COMMENT '类型ID',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片地址',
  `color` varchar(10) DEFAULT NULL COMMENT '背景颜色',
  `link_url` varchar(500) DEFAULT '' COMMENT '链接地址',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='广告推荐';

-- ----------------------------
-- Records of cms_ad
-- ----------------------------
BEGIN;
INSERT INTO `cms_ad` VALUES ('1', '广告1', '1', 'http://kr.shanghai-jiuxin.com/file/2021/0914/ab926848c699875fa2e2803f935190b8.jpg', '11', '11', 0, '2021-11-12 11:35:10', '2021-11-12 11:35:14');
INSERT INTO `cms_ad` VALUES ('1459002410674851841', '广告3', '1', 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/ad/2021/11/12/3a4dadda-16ab-4628-8ef4-6ae8d41fc503.jpg', '#FF0000', 'http://www.163.com', 0, '2021-11-12 11:37:36', '2021-11-12 11:37:36');
INSERT INTO `cms_ad` VALUES ('2', '广告2', '2', 'http://kr.shanghai-jiuxin.com/file/2021/0914/small4b869066d0c72423c01fe2243e37e6a1.jpg', '12', '12', 0, '2021-11-12 11:35:49', '2021-11-12 11:35:52');
COMMIT;

-- ----------------------------
-- Table structure for cms_ad_type
-- ----------------------------
DROP TABLE IF EXISTS `cms_ad_type`;
CREATE TABLE `cms_ad_type` (
  `id` char(19) NOT NULL COMMENT 'ID',
  `title` varchar(20) NOT NULL COMMENT '标题',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推荐位';

-- ----------------------------
-- Records of cms_ad_type
-- ----------------------------
BEGIN;
INSERT INTO `cms_ad_type` VALUES ('1', '首页幻灯片', '2021-11-12 10:44:19', '2021-11-12 10:44:30');
INSERT INTO `cms_ad_type` VALUES ('2', '首页通栏广告', '2021-11-12 10:44:50', '2021-11-12 10:44:54');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
