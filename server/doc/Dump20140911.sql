CREATE DATABASE  IF NOT EXISTS `zhuanqian` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `zhuanqian`;
-- MySQL dump 10.13  Distrib 5.6.17, for osx10.6 (i386)
--
-- Host: 123.57.9.112    Database: zhuanqian
-- ------------------------------------------------------
-- Server version	5.5.36-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `db_exchange_log`
--

DROP TABLE IF EXISTS `db_exchange_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_exchange_log` (
  `user_id` varchar(255) NOT NULL COMMENT '用户id',
  `time` int(11) unsigned NOT NULL COMMENT '时间',
  `type` smallint(5) unsigned NOT NULL COMMENT '兑换类型',
  `account` varchar(255) NOT NULL COMMENT '账户',
  `num` int(11) unsigned NOT NULL COMMENT '兑换数量',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_task_log`
--

DROP TABLE IF EXISTS `db_task_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_task_log` (
  `user_id` varchar(255) NOT NULL COMMENT '用户id',
  `time` int(11) unsigned NOT NULL COMMENT '完成时间',
  `channel` int(6) unsigned NOT NULL COMMENT '渠道',
  `trand_no` varchar(255) NOT NULL COMMENT '交易流水号',
  `app_name` varchar(255) NOT NULL COMMENT '应用名称',
  `score` int(11) unsigned DEFAULT NULL COMMENT '获得积分'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_user`
--

DROP TABLE IF EXISTS `db_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_user` (
  `id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '用户id',
  `score_current` int(11) unsigned NOT NULL COMMENT '用户剩余积分',
  `score_total` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户历史总积分',
  `account` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '支付宝账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-11  2:12:39
