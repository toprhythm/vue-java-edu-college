/*
 Navicat Premium Data Transfer

 Source Server         : 216.127.184.152
 Source Server Type    : MySQL
 Source Server Version : 50735
 Source Host           : 216.127.184.152:3306
 Source Schema         : db_yunzoukj_trade

 Target Server Type    : MySQL
 Target Server Version : 50735
 File Encoding         : 65001

 Date: 20/12/2021 14:52:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for trade_order
-- ----------------------------
DROP TABLE IF EXISTS `trade_order`;
CREATE TABLE `trade_order` (
  `id` char(19) NOT NULL DEFAULT '',
  `order_no` varchar(20) NOT NULL DEFAULT '' COMMENT '订单号',
  `course_id` varchar(19) NOT NULL DEFAULT '' COMMENT '课程id',
  `course_title` varchar(100) DEFAULT NULL COMMENT '课程名称',
  `course_cover` varchar(255) DEFAULT NULL COMMENT '课程封面',
  `teacher_name` varchar(20) DEFAULT NULL COMMENT '讲师名称',
  `member_id` varchar(19) NOT NULL DEFAULT '' COMMENT '会员id',
  `nickname` varchar(50) DEFAULT NULL COMMENT '会员昵称',
  `mobile` varchar(11) DEFAULT NULL COMMENT '会员手机',
  `total_fee` decimal(20,2) DEFAULT NULL COMMENT '订单金额（分）',
  `pay_type` tinyint(3) DEFAULT NULL COMMENT '支付类型（1：微信 2：支付宝）',
  `status` tinyint(3) DEFAULT NULL COMMENT '订单状态（0：未支付 1：已支付）',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_order_no` (`order_no`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单';

-- ----------------------------
-- Records of trade_order
-- ----------------------------
BEGIN;
INSERT INTO `trade_order` VALUES ('1460941587029106689', '20211117200311075', '1458235744282148866', '周111', 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/cover/2021/11/10/c5252aec-a28c-44f4-aaf4-96fd61c19be7.jpeg', '周杰伦', '1459700192091983873', 'zwq123', '18974017944', 10.00, 1, 1, 0, '2021-11-17 20:03:12', '2021-11-17 20:04:31');
INSERT INTO `trade_order` VALUES ('1460942476431269890', '20211117200644651', '1458032708263763969', '月夕花晨', 'https://yunzou-edu.oss-cn-beijing.aliyuncs.com/cover/2021/11/09/6af87615-bc13-48e6-bd79-d24cb3d28f06.jpeg', '唐嫣', '1459700192091983873', 'zwq123', '18974017944', 20.00, 1, 1, 0, '2021-11-17 20:06:44', '2021-11-17 20:07:54');
COMMIT;

-- ----------------------------
-- Table structure for trade_pay_log
-- ----------------------------
DROP TABLE IF EXISTS `trade_pay_log`;
CREATE TABLE `trade_pay_log` (
  `id` char(19) NOT NULL DEFAULT '',
  `order_no` varchar(20) NOT NULL DEFAULT '' COMMENT '订单号',
  `pay_time` datetime DEFAULT NULL COMMENT '支付完成时间',
  `total_fee` bigint(20) DEFAULT NULL COMMENT '支付金额（分）',
  `transaction_id` varchar(30) DEFAULT NULL COMMENT '交易流水号',
  `trade_state` char(20) DEFAULT NULL COMMENT '交易状态',
  `pay_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '支付类型（1：微信 2：支付宝）',
  `attr` text COMMENT '其他属性',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
  `gmt_create` datetime NOT NULL COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付日志表';

-- ----------------------------
-- Records of trade_pay_log
-- ----------------------------
BEGIN;
INSERT INTO `trade_pay_log` VALUES ('1460934770358091777', '20211116104939363', '2021-11-17 19:36:07', 10, '4200001183202111170614629495', 'SUCCESS', 1, '{\"transaction_id\":\"4200001183202111170614629495\",\"nonce_str\":\"Iq6BE6Y3hwbjS2ddEy186gADMr9p61Ic\",\"bank_type\":\"PSBC_DEBIT\",\"openid\":\"oHwsHuM4o2PjZggPDHpgqGp2sNYc\",\"sign\":\"8EBBE4B0E9CEDEDC40258D6C7562291C\",\"fee_type\":\"CNY\",\"mch_id\":\"1558950191\",\"cash_fee\":\"10\",\"out_trade_no\":\"20211116104939363\",\"appid\":\"wx74862e0dfcf69954\",\"total_fee\":\"10\",\"trade_type\":\"NATIVE\",\"result_code\":\"SUCCESS\",\"time_end\":\"20211117193602\",\"is_subscribe\":\"N\",\"return_code\":\"SUCCESS\"}', 0, '2021-11-17 19:36:07', '2021-11-17 19:36:07');
INSERT INTO `trade_pay_log` VALUES ('1460939566003699714', '20211117195341407', '2021-11-17 19:55:10', 20, '4200001179202111170282064386', 'SUCCESS', 1, '{\"transaction_id\":\"4200001179202111170282064386\",\"nonce_str\":\"GiLhh0kWARSovcJ3xHRRMnLADq8qNOis\",\"bank_type\":\"PSBC_DEBIT\",\"openid\":\"oHwsHuM4o2PjZggPDHpgqGp2sNYc\",\"sign\":\"F149C706CA9A8D691A3BD2FF670E14B7\",\"fee_type\":\"CNY\",\"mch_id\":\"1558950191\",\"cash_fee\":\"20\",\"out_trade_no\":\"20211117195341407\",\"appid\":\"wx74862e0dfcf69954\",\"total_fee\":\"20\",\"trade_type\":\"NATIVE\",\"result_code\":\"SUCCESS\",\"time_end\":\"20211117195506\",\"is_subscribe\":\"N\",\"return_code\":\"SUCCESS\"}', 0, '2021-11-17 19:55:10', '2021-11-17 19:55:10');
INSERT INTO `trade_pay_log` VALUES ('1460941920597909506', '20211117200311075', '2021-11-17 20:04:32', 10, '4200001170202111179276865365', 'SUCCESS', 1, '{\"transaction_id\":\"4200001170202111179276865365\",\"nonce_str\":\"8Pppe5qsC9TBTCq98VBKDn5UXCBX82sh\",\"bank_type\":\"PSBC_DEBIT\",\"openid\":\"oHwsHuM4o2PjZggPDHpgqGp2sNYc\",\"sign\":\"FE4DD6FE8C3956335DD2798E177EC1B8\",\"fee_type\":\"CNY\",\"mch_id\":\"1558950191\",\"cash_fee\":\"10\",\"out_trade_no\":\"20211117200311075\",\"appid\":\"wx74862e0dfcf69954\",\"total_fee\":\"10\",\"trade_type\":\"NATIVE\",\"result_code\":\"SUCCESS\",\"time_end\":\"20211117200427\",\"is_subscribe\":\"N\",\"return_code\":\"SUCCESS\"}', 0, '2021-11-17 20:04:32', '2021-11-17 20:04:32');
INSERT INTO `trade_pay_log` VALUES ('1460942775673888770', '20211117200644651', '2021-11-17 20:07:55', 20, '4200001167202111176795540572', 'SUCCESS', 1, '{\"transaction_id\":\"4200001167202111176795540572\",\"nonce_str\":\"hC09z4aLADLrARKWVOxzXsjchAlHEAWD\",\"bank_type\":\"PSBC_DEBIT\",\"openid\":\"oHwsHuM4o2PjZggPDHpgqGp2sNYc\",\"sign\":\"7A55EB3E2C180E32839525367B0C84F2\",\"fee_type\":\"CNY\",\"mch_id\":\"1558950191\",\"cash_fee\":\"20\",\"out_trade_no\":\"20211117200644651\",\"appid\":\"wx74862e0dfcf69954\",\"total_fee\":\"20\",\"trade_type\":\"NATIVE\",\"result_code\":\"SUCCESS\",\"time_end\":\"20211117200750\",\"is_subscribe\":\"N\",\"return_code\":\"SUCCESS\"}', 0, '2021-11-17 20:07:55', '2021-11-17 20:07:55');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
