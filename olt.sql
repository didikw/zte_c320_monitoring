/*


 Source Server         : yyy on xxx
 Source Server Type    : MariaDB

 Source Host           : xxx
 Source Schema         : olt

 Target Server Type    : MariaDB
 Target Server Version : 100329
 File Encoding         : 65001

*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for lokasi
-- ----------------------------
DROP TABLE IF EXISTS `lokasi`;
CREATE TABLE `lokasi`  (
  `idlokasi` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_lokasi` timestamp(0) NULL DEFAULT NULL,
  `lokasi` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idlokasi`) USING BTREE,
  INDEX `waktulokasi`(`waktu_lokasi`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129606 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for offlineterakhir
-- ----------------------------
DROP TABLE IF EXISTS `offlineterakhir`;
CREATE TABLE `offlineterakhir`  (
  `idoffline` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_offline` timestamp(0) NULL DEFAULT NULL,
  `offlineterakhir` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idoffline`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129606 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for oltrx
-- ----------------------------
DROP TABLE IF EXISTS `oltrx`;
CREATE TABLE `oltrx`  (
  `idoltrx` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_query` timestamp(0) NULL DEFAULT NULL,
  `oltrx` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idoltrx`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for onlineterakhir
-- ----------------------------
DROP TABLE IF EXISTS `onlineterakhir`;
CREATE TABLE `onlineterakhir`  (
  `idonline` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_online` timestamp(0) NULL DEFAULT NULL,
  `lastonline` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idonline`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129606 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for onu
-- ----------------------------
DROP TABLE IF EXISTS `onu`;
CREATE TABLE `onu`  (
  `idonu_query` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_query_onu` timestamp(0) NULL DEFAULT NULL,
  `onurx` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `onutx` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idonu_query`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129606 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for status
-- ----------------------------
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status`  (
  `idstatus` bigint(255) NOT NULL AUTO_INCREMENT,
  `waktu_status` timestamp(0) NULL DEFAULT NULL,
  `status` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idstatus`) USING BTREE,
  INDEX `waktustatus`(`waktu_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129606 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for rx_onu_pertanian
-- ----------------------------
DROP VIEW IF EXISTS `rx_onu_pertanian`;
CREATE ALGORITHM = UNDEFINED DEFINER = `librenms`@`%` SQL SECURITY DEFINER VIEW `rx_onu_pertanian` AS select `lokasi`.`lokasi` AS `lokasi`,`onu`.`waktu_query_onu` AS `waktu_query_onu`,round(trim(leading 'INTEGER: ' from `onu`.`onurx`) * 0.002 - 30,2) AS `onurx_` from (`onu` join `lokasi` on(`onu`.`idonu_query` = `lokasi`.`idlokasi`)) where `lokasi`.`lokasi` = 'STRING: "pertanian"';

-- ----------------------------
-- View structure for statusolt
-- ----------------------------
DROP VIEW IF EXISTS `statusolt`;
CREATE ALGORITHM = UNDEFINED DEFINER = `librenms`@`%` SQL SECURITY DEFINER VIEW `statusolt` AS select `lokasi`.`idlokasi` AS `idlokasi`,`lokasi`.`waktu_lokasi` AS `waktu_lokasi`,`lokasi`.`lokasi` AS `lokasi`,`status`.`status` AS `status`,`offlineterakhir`.`offlineterakhir` AS `offlineterakhir`,`onlineterakhir`.`lastonline` AS `lastonline`,round(trim(leading 'INTEGER: ' from `onu`.`onurx`) * 0.002 - 30,3) AS `rx_onu_dBm`,round(trim(leading 'INTEGER: ' from `onu`.`onutx`) * 0.002 - 30,3) AS `tx_onu_dBm` from ((((`lokasi` join `status` on(`status`.`idstatus` = `lokasi`.`idlokasi`)) join `offlineterakhir` on(`offlineterakhir`.`idoffline` = `lokasi`.`idlokasi`)) join `onlineterakhir` on(`onlineterakhir`.`idonline` = `lokasi`.`idlokasi`)) join `onu` on(`onu`.`idonu_query` = `lokasi`.`idlokasi`)) order by 1 desc limit 35;

SET FOREIGN_KEY_CHECKS = 1;
