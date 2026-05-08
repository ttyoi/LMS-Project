-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 192.168.0.130    Database: vuelmsone
-- ------------------------------------------------------
-- Server version	5.7.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance_status`
--

DROP TABLE IF EXISTS `attendance_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_status` (
  `att_sta_code` int(11) NOT NULL COMMENT '출결상태코드',
  `status` varchar(255) NOT NULL COMMENT '출결상태구분',
  PRIMARY KEY (`att_sta_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='출결 상태';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_status`
--

LOCK TABLES `attendance_status` WRITE;
/*!40000 ALTER TABLE `attendance_status` DISABLE KEYS */;
INSERT INTO `attendance_status` VALUES (0,'결석'),(1,'출석'),(2,'지각'),(3,'조퇴'),(4,'외출');
/*!40000 ALTER TABLE `attendance_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `course_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '강의ID',
  `title` varchar(255) NOT NULL COMMENT '강의명',
  `start_date` datetime NOT NULL COMMENT '개강일',
  `end_date` datetime NOT NULL COMMENT '종강일',
  `content` text COMMENT '수업내용',
  `notice` varchar(255) DEFAULT NULL COMMENT '강의공지사항',
  `plan` varchar(255) DEFAULT NULL COMMENT '강의계획',
  `cos_sta_code` int(11) NOT NULL COMMENT '강의신청상태코드',
  `class_id` bigint(20) NOT NULL COMMENT '강의실ID',
  `time_code` int(11) NOT NULL COMMENT '강의시간코드',
  `professor` varchar(255) DEFAULT NULL,
  `sub_prof` varchar(255) DEFAULT NULL,
  `course_isDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`course_id`),
  KEY `FK_course_class_TO_course` (`class_id`),
  KEY `FK_course_status_TO_course` (`cos_sta_code`),
  KEY `FK_course_time_TO_course` (`time_code`),
  KEY `FK_course_professor` (`professor`),
  KEY `FK_course_subprof` (`sub_prof`),
  CONSTRAINT `FK_course_class_TO_course` FOREIGN KEY (`class_id`) REFERENCES `course_class` (`class_id`),
  CONSTRAINT `FK_course_professor` FOREIGN KEY (`professor`) REFERENCES `tb_userinfo` (`loginID`),
  CONSTRAINT `FK_course_status_TO_course` FOREIGN KEY (`cos_sta_code`) REFERENCES `course_status` (`cos_sta_code`),
  CONSTRAINT `FK_course_subprof` FOREIGN KEY (`sub_prof`) REFERENCES `tb_userinfo` (`loginID`),
  CONSTRAINT `FK_course_time_TO_course` FOREIGN KEY (`time_code`) REFERENCES `course_time` (`time_code`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COMMENT='강의 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (1,'JAVA','2025-12-01 00:00:00','2026-02-01 00:00:00','자바를 잘 배워봅시다.','출석관리 1. 3일 이상 무단 결석시 강제 퇴실합니다. 2. 지각 3번시 1일 결석처리됩니다.','강의 후 미니프로젝트를 통해 자바를 활용할 수 있도록 합니다.',1,16,2,'happyjob_165576','happyjob_710254',0),(2,'vuejs','2026-02-02 00:00:00','2026-05-02 00:00:00','vuejs를 잘 배워봅시다.','출석관리 1. 3일 이상 무단 결석시 강제 퇴실합니다. 2. 지각 3번시 1일 결석처리됩니다.','강의 후 미니프로젝트를 통해 vuejs를 활용할 수 있도록 합니다.',1,1,2,'happyjob_710254','happyjob_935821',0),(3,'react','2025-05-03 00:00:00','2026-08-03 00:00:00','react를 잘 배워봅시다.','출석관리 1. 3일 이상 무단 결석시 강제 퇴실합니다. 2. 지각 3번시 1일 결석처리됩니다.','강의 후 미니프로젝트를 통해 react를 활용할 수 있도록 합니다.',1,2,1,'happyjob_935821','happyjob_482193',0),(5,'spirng boot','2025-12-10 00:00:00','2026-03-10 00:00:00','spirng boot','spirng boot','spirng boot',1,2,2,'happyjob_482193','happyjob_935821',0),(106,'html','2025-12-31 00:00:00','2026-03-31 00:00:00','html','html','html',1,3,2,'happyjob_482193','happyjob_560130',0),(107,'React','2026-02-13 00:00:00','2026-05-13 00:00:00','리액트입니다dd','리액트를 배웁시다','리액트를 배우겠습니다',1,4,1,'happyjob_165576','happyjob_644466',0),(108,'vue.js','2026-02-13 00:00:00','2026-05-13 00:00:00','dd','dd','dd',1,3,1,'happyjob_165576','happyjob_601176',0),(110,'vue.js','2026-02-20 00:00:00','2026-05-20 00:00:00','vue.js','vue.js를 배웁시다','없다',1,26,3,'happyjob_482193','happyjob_165576',1),(111,'등산','2027-12-20 00:00:00','2028-09-20 00:00:00','ㅇㅇ','ㅇㅇ','ㅇㅇ',0,4,2,'happyjob_482193','happyjob_301324',0),(112,'하프물범이 되는 방법','2027-01-20 00:00:00','2028-06-22 00:00:00','','','',0,5,3,'happyjob_165576','happyjob_560130',0),(113,'Python','2027-01-01 00:00:00','2027-06-03 00:00:00','파이썬 테스트용','이건 파이썬','파이썬 테스트영',1,28,3,'happyjob_165576','happyjob_580910',0),(114,'vue.js','2030-01-01 00:00:00','2030-05-07 00:00:00','23','23','23',0,24,1,'happyjob_165576','happyjob_482193',0),(117,'test','2026-04-24 00:00:00','2026-04-28 00:00:00','a','a','a',0,20,1,'happyjob_165576',NULL,1),(120,'test','2026-04-22 00:00:00','2026-04-29 00:00:00','a','a','a',0,11,1,'happyjob_165576',NULL,1),(121,'ssssss','2026-04-23 00:00:00','2026-04-29 00:00:00','a','a','a',0,18,1,'happyjob_165576',NULL,1),(122,'test12344','2026-04-22 00:00:00','2026-06-06 00:00:00','asdasd','sssss','zzzz',0,20,3,'happyjob_165576',NULL,1),(123,'test','2026-04-22 00:00:00','2026-06-18 00:00:00','','','',0,11,2,'happyjob_165576','happyjob_183438',1),(124,'영어 특강','2026-04-01 00:00:00','2026-04-25 00:00:00','같이 영어 공부 시작해요','','영어고래 앱을 통해 공부해봅시다.',1,20,3,'happyjob_165576','happyjob_549083',0),(125,'test2','2026-04-23 00:00:00','2026-05-21 00:00:00','aaa','ddd','sss',0,16,3,'happyjob_165576','happyjob_549083',0),(126,'aaaaaa','2026-04-23 00:00:00','2026-04-28 00:00:00','a','a','a',0,11,1,'happyjob_165576',NULL,1),(128,'zzzzzzzzz','2026-04-28 00:00:00','2026-05-09 00:00:00','','','',0,20,3,'happyjob_165576',NULL,0),(129,'atasda','2026-05-05 00:00:00','2026-05-22 00:00:00','aaa','aa','aa',0,16,2,'happyjob_165576','happyjob_504730',0);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_attendance`
--

DROP TABLE IF EXISTS `course_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_attendance` (
  `attendance_code` bigint(20) NOT NULL COMMENT '출결고유코드',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `date` datetime NOT NULL COMMENT '출결날짜',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `att_sta_code` int(11) NOT NULL COMMENT '출결상태코드',
  PRIMARY KEY (`attendance_code`,`course_id`),
  KEY `FK_attendance_status_TO_course_attendance` (`att_sta_code`),
  KEY `FK_course_TO_course_attendance` (`course_id`),
  KEY `FK_tb_userinfo_TO_course_attendance` (`loginID`),
  CONSTRAINT `FK_attendance_status_TO_course_attendance` FOREIGN KEY (`att_sta_code`) REFERENCES `attendance_status` (`att_sta_code`),
  CONSTRAINT `FK_course_TO_course_attendance` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_tb_userinfo_TO_course_attendance` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='강의 출결 관리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_attendance`
--

LOCK TABLES `course_attendance` WRITE;
/*!40000 ALTER TABLE `course_attendance` DISABLE KEYS */;
INSERT INTO `course_attendance` VALUES (1,1,'2025-12-05 06:27:24','rabbit99',1),(2,2,'2025-12-05 06:27:24','sunnyday',1),(3,1,'2025-12-05 06:27:24','rabbit99',1),(4,1,'2025-12-06 06:27:24','rabbit99',1),(5,1,'2025-12-07 06:27:24','rabbit99',1),(6,1,'2025-12-09 06:27:24','rabbit99',1),(7,1,'2025-12-10 06:27:24','rabbit99',1),(8,1,'2025-12-14 05:14:06','sunnyday',1),(9,1,'2025-12-14 05:14:06','sunnyday',1),(10,1,'2025-12-14 05:14:06','sunnyday',1),(11,1,'2025-12-14 05:14:06','sunnyday',1),(12,1,'2025-12-14 05:14:06','sunnyday',1),(13,1,'2025-12-14 05:49:17','sunnyday',2),(14,1,'2025-12-12 01:01:09','coolguy',3),(15,1,'2025-12-13 01:01:29','coolguy',1),(16,1,'2025-12-14 01:11:04','coolguy',1),(17,1,'2025-12-14 07:03:13','mintleaf',1),(18,1,'2025-12-14 07:03:13','mintleaf',2),(19,1,'2025-12-14 07:03:13','mintleaf',0),(20,1,'2025-12-14 07:03:13','ohhappy',0),(21,1,'2025-12-14 07:03:13','ohhappy',1),(22,1,'2025-12-14 07:03:13','ohhappy',0),(23,1,'2025-12-12 00:00:00','ohhappy',0),(23,3,'2025-12-12 06:15:41','rabbit99',0),(24,1,'2025-12-12 00:00:00','mintleaf',2),(24,3,'2025-12-12 06:15:41','sunnyday',1),(25,1,'2025-12-12 00:00:00','coolguy',3),(25,3,'2025-12-12 06:15:41','rabbit99',1),(26,1,'2025-12-12 00:00:00','ohhappy',1),(26,3,'2025-12-13 06:15:41','rabbit99',1),(27,1,'2025-12-12 00:00:00','mintleaf',2),(27,3,'2025-12-14 06:15:41','rabbit99',1),(28,1,'2025-12-12 00:00:00','coolguy',3),(28,3,'2025-12-16 06:15:41','rabbit99',1),(29,1,'2025-12-12 00:00:00','ohhappy',1),(29,3,'2025-12-17 06:15:41','rabbit99',1),(30,1,'2025-12-12 00:00:00','mintleaf',1),(30,3,'2025-12-17 06:15:41','sunnyday',1),(31,1,'2025-12-12 00:00:00','ohhappy',1),(31,3,'2025-12-17 06:15:41','sunnyday',1),(32,1,'2025-12-12 00:00:00','mintleaf',2),(32,3,'2025-12-17 06:15:41','sunnyday',1),(33,1,'2025-12-12 00:00:00','ohhappy',1),(33,3,'2025-12-17 06:15:41','sunnyday',1),(34,1,'2025-12-12 00:00:00','mintleaf',2),(34,3,'2025-12-17 06:15:42','sunnyday',1),(35,1,'2025-12-12 00:00:00','coolguy',3),(35,3,'2025-12-13 06:15:42','sunnyday',2),(36,1,'2025-12-12 00:00:00','ohhappy',1),(36,3,'2025-12-14 06:15:42','coolguy',2),(37,1,'2025-12-12 00:00:00','mintleaf',2),(37,3,'2025-12-15 06:15:42','coolguy',2),(38,1,'2025-12-12 00:00:00','ohhappy',1),(38,3,'2025-12-15 06:15:42','coolguy',1),(39,1,'2025-12-12 00:00:00','mintleaf',2),(39,3,'2025-12-15 06:15:42','mintleaf',1),(40,1,'2025-12-12 00:00:00','ohhappy',1),(40,3,'2025-12-15 06:15:42','mintleaf',2),(41,1,'2025-12-12 00:00:00','mintleaf',2),(41,3,'2025-12-15 06:15:42','mintleaf',0),(42,1,'2025-12-12 00:00:00','ohhappy',1),(42,3,'2025-12-15 06:15:42','ohhappy',3),(43,1,'2025-12-12 00:00:00','mintleaf',2),(43,3,'2025-12-15 06:15:42','ohhappy',1),(44,1,'2025-12-12 00:00:00','ohhappy',1),(44,3,'2025-12-15 06:15:42','ohhappy',0),(45,1,'2025-12-12 00:00:00','mintleaf',2),(46,1,'2025-12-12 00:00:00','ohhappy',1),(47,1,'2025-12-12 00:00:00','mintleaf',2),(48,1,'2025-12-12 00:00:00','ohhappy',1),(49,1,'2025-12-12 00:00:00','mintleaf',2),(50,1,'2025-12-12 00:00:00','ohhappy',1),(51,1,'2025-12-12 00:00:00','mintleaf',2),(52,1,'2025-12-12 00:00:00','ohhappy',1),(53,1,'2025-12-12 00:00:00','mintleaf',2),(54,1,'2025-12-12 00:00:00','ohhappy',1),(55,1,'2025-12-12 00:00:00','mintleaf',2),(56,1,'2025-12-12 00:00:00','ohhappy',1),(57,1,'2025-12-12 00:00:00','mintleaf',2),(58,1,'2025-12-12 00:00:00','ohhappy',1),(59,1,'2025-12-12 00:00:00','mintleaf',2),(60,1,'2025-12-12 00:00:00','ohhappy',1),(61,1,'2025-12-12 00:00:00','mintleaf',2),(62,1,'2025-12-12 00:00:00','coolguy',0),(63,1,'2025-12-12 00:00:00','ohhappy',1),(64,1,'2025-12-12 00:00:00','mintleaf',2),(65,1,'2025-12-12 00:00:00','coolguy',0),(66,1,'2025-12-12 00:00:00','ohhappy',0),(67,1,'2025-12-12 00:00:00','mintleaf',2),(68,1,'2025-12-12 00:00:00','coolguy',0),(69,1,'2025-12-12 00:00:00','ohhappy',1),(70,1,'2025-12-12 00:00:00','mintleaf',1),(71,1,'2025-12-12 00:00:00','coolguy',0),(72,1,'2025-12-12 00:00:00','ohhappy',1),(73,1,'2025-12-12 00:00:00','mintleaf',1),(74,1,'2025-12-12 00:00:00','coolguy',0),(75,1,'2025-12-12 00:00:00','ohhappy',1),(76,1,'2025-12-12 00:00:00','mintleaf',1),(77,1,'2025-12-12 00:00:00','coolguy',0),(78,1,'2025-12-12 00:00:00','ohhappy',1),(79,1,'2025-12-12 00:00:00','mintleaf',1),(80,1,'2025-12-12 00:00:00','coolguy',0),(81,1,'2025-12-12 00:00:00','ohhappy',1),(82,1,'2025-12-12 00:00:00','mintleaf',1),(83,1,'2025-12-12 00:00:00','coolguy',0),(84,1,'2025-12-12 00:00:00','ohhappy',4),(85,1,'2025-12-12 00:00:00','mintleaf',1),(86,1,'2025-12-12 00:00:00','coolguy',0),(87,1,'2025-12-12 00:00:00','ohhappy',1),(88,1,'2025-12-12 00:00:00','mintleaf',1),(89,1,'2025-12-12 00:00:00','ohhappy',1),(90,1,'2025-12-12 00:00:00','mintleaf',1),(91,1,'2025-12-12 00:00:00','coolguy',2),(92,1,'2025-12-12 00:00:00','ohhappy',1),(93,1,'2025-12-12 00:00:00','mintleaf',1),(94,1,'2025-12-12 00:00:00','coolguy',1),(95,3,'2025-12-12 00:00:00','sunnyday',1),(96,3,'2025-12-12 00:00:00','ohhappy',2),(97,3,'2025-12-12 00:00:00','mintleaf',2),(98,3,'2025-12-12 00:00:00','coolguy',2),(99,1,'2025-12-13 00:00:00','ohhappy',1),(100,1,'2025-12-13 00:00:00','mintleaf',1),(101,1,'2025-12-13 00:00:00','coolguy',1),(102,1,'2025-12-15 00:00:00','ohhappy',1),(103,1,'2025-12-15 00:00:00','mintleaf',1),(104,1,'2025-12-15 00:00:00','coolguy',1),(105,3,'2025-12-16 00:00:00','sunnyday',1),(106,3,'2025-12-16 00:00:00','ohhappy',2),(107,3,'2025-12-16 00:00:00','mintleaf',1),(108,3,'2025-12-16 00:00:00','coolguy',1),(109,1,'2025-12-16 00:00:00','ohhappy',1),(110,1,'2025-12-16 00:00:00','mintleaf',1),(111,1,'2025-12-16 00:00:00','coolguy',1),(112,5,'2026-02-13 17:28:56','qqqq',2),(113,5,'2026-02-13 17:29:08','hello',3),(114,5,'2026-02-13 17:29:11','qwe',1),(115,5,'2026-02-13 17:29:11','bluecat',1),(116,5,'2026-02-13 17:29:11','ohhappy',1),(117,5,'2026-02-13 17:29:11','mintleaf',1),(118,5,'2026-02-13 17:29:11','stuTest',1),(119,5,'2026-02-19 09:14:34','qqqq',3),(120,5,'2026-02-19 09:16:38','hello',0),(121,5,'2026-02-19 09:16:42','qwe',1),(122,5,'2026-02-19 09:16:42','bluecat',1),(123,5,'2026-02-19 09:16:42','ohhappy',1),(124,5,'2026-02-19 09:16:42','mintleaf',1),(125,5,'2026-02-19 09:16:42','stuTest',1),(126,5,'2026-02-20 15:11:04','qqqq',3),(127,5,'2026-02-20 15:11:09','hello',1),(128,5,'2026-02-20 15:11:09','qwe',1),(129,5,'2026-02-20 15:11:09','bluecat',1),(130,5,'2026-02-20 15:11:09','mintleaf',1),(131,5,'2026-02-20 15:11:09','stuTest',1),(132,1,'2026-04-08 00:00:00','sunnyday',0),(133,1,'2026-04-08 00:00:00','rabbit99',0),(134,1,'2026-04-09 00:00:00','sunnyday',0),(135,1,'2026-04-09 00:00:00','rabbit99',0),(136,1,'2026-04-15 00:00:00','sunnyday',4),(137,1,'2026-04-15 00:00:00','rabbit99',4),(138,1,'2026-04-16 00:00:00','sunnyday',1),(139,1,'2026-04-16 00:00:00','rabbit99',3),(140,1,'2026-04-20 00:00:00','sunnyday',1),(141,1,'2026-04-20 00:00:00','rabbit99',1),(142,1,'2026-04-20 00:00:00','ham',1),(143,1,'2026-04-19 00:00:00','sunnyday',3),(144,1,'2026-04-19 00:00:00','rabbit99',1),(145,1,'2026-04-19 00:00:00','ham',1),(146,108,'2026-04-20 00:00:00','coffee1',1),(147,108,'2026-04-20 00:00:00','bluecat',1),(148,108,'2026-04-20 00:00:00','sunnyday',1),(149,108,'2026-04-20 00:00:00','ohhappy',1),(150,108,'2026-04-20 00:00:00','rabbit99',1),(151,108,'2026-04-20 00:00:00','ham',1),(152,108,'2026-04-20 00:00:00','cooo',3),(153,108,'2026-02-17 00:00:00','coffee1',0),(154,108,'2026-02-17 00:00:00','bluecat',2),(155,108,'2026-02-17 00:00:00','sunnyday',1),(156,108,'2026-02-17 00:00:00','ohhappy',1),(157,108,'2026-02-17 00:00:00','rabbit99',0),(158,108,'2026-02-17 00:00:00','ham',4),(159,108,'2026-02-17 00:00:00','cooo',3),(160,108,'2026-02-16 00:00:00','coffee1',1),(161,108,'2026-02-16 00:00:00','bluecat',1),(162,108,'2026-02-16 00:00:00','sunnyday',3),(163,108,'2026-02-16 00:00:00','ohhappy',4),(164,108,'2026-02-16 00:00:00','rabbit99',0),(165,108,'2026-02-16 00:00:00','ham',1),(166,108,'2026-02-16 00:00:00','cooo',1),(167,108,'2026-04-17 00:00:00','coffee1',1),(168,108,'2026-04-17 00:00:00','bluecat',1),(169,108,'2026-04-17 00:00:00','sunnyday',2),(170,108,'2026-04-17 00:00:00','ohhappy',1),(171,108,'2026-04-17 00:00:00','rabbit99',2),(172,108,'2026-04-17 00:00:00','ham',1),(173,108,'2026-04-17 00:00:00','cooo',2),(174,108,'2026-04-16 00:00:00','coffee1',1),(175,108,'2026-04-16 00:00:00','bluecat',1),(176,108,'2026-04-16 00:00:00','sunnyday',1),(177,108,'2026-04-16 00:00:00','ohhappy',1),(178,108,'2026-04-16 00:00:00','rabbit99',1),(179,108,'2026-04-16 00:00:00','ham',1),(180,108,'2026-04-16 00:00:00','cooo',1),(181,108,'2026-04-15 00:00:00','coffee1',1),(182,108,'2026-04-15 00:00:00','bluecat',2),(183,108,'2026-04-15 00:00:00','sunnyday',2),(184,108,'2026-04-15 00:00:00','ohhappy',1),(185,108,'2026-04-15 00:00:00','rabbit99',1),(186,108,'2026-04-15 00:00:00','ham',2),(187,108,'2026-04-15 00:00:00','cooo',1),(188,108,'2026-04-14 00:00:00','coffee1',1),(189,108,'2026-04-14 00:00:00','bluecat',1),(190,108,'2026-04-14 00:00:00','sunnyday',1),(191,108,'2026-04-14 00:00:00','ohhappy',1),(192,108,'2026-04-14 00:00:00','rabbit99',1),(193,108,'2026-04-14 00:00:00','ham',1),(194,108,'2026-04-14 00:00:00','cooo',1),(195,108,'2026-04-13 00:00:00','coffee1',1),(196,108,'2026-04-13 00:00:00','bluecat',1),(197,108,'2026-04-13 00:00:00','sunnyday',1),(198,108,'2026-04-13 00:00:00','ohhappy',1),(199,108,'2026-04-13 00:00:00','rabbit99',1),(200,108,'2026-04-13 00:00:00','ham',4),(201,108,'2026-04-13 00:00:00','cooo',1),(202,108,'2026-04-10 00:00:00','coffee1',1),(203,108,'2026-04-10 00:00:00','bluecat',1),(204,108,'2026-04-10 00:00:00','sunnyday',1),(205,108,'2026-04-10 00:00:00','ohhappy',1),(206,108,'2026-04-10 00:00:00','rabbit99',0),(207,108,'2026-04-10 00:00:00','ham',1),(208,108,'2026-04-10 00:00:00','cooo',1),(209,108,'2026-04-09 00:00:00','coffee1',1),(210,108,'2026-04-09 00:00:00','bluecat',4),(211,108,'2026-04-09 00:00:00','sunnyday',3),(212,108,'2026-04-09 00:00:00','ohhappy',3),(213,108,'2026-04-09 00:00:00','rabbit99',1),(214,108,'2026-04-09 00:00:00','ham',1),(215,108,'2026-04-09 00:00:00','cooo',0),(216,108,'2026-04-21 00:00:00','coffee1',1),(217,108,'2026-04-21 00:00:00','bluecat',1),(218,108,'2026-04-21 00:00:00','sunnyday',1),(219,108,'2026-04-21 00:00:00','ohhappy',1),(220,108,'2026-04-21 00:00:00','rabbit99',1),(221,108,'2026-04-21 00:00:00','ham',1),(222,108,'2026-04-21 00:00:00','cooo',1),(223,108,'2026-04-21 00:00:00','testA',1),(224,108,'2026-04-22 00:00:00','coffee1',4),(225,108,'2026-04-22 00:00:00','bluecat',2),(226,108,'2026-04-22 00:00:00','sunnyday',1),(227,108,'2026-04-22 00:00:00','ohhappy',2),(228,108,'2026-04-22 00:00:00','rabbit99',1),(229,108,'2026-04-22 00:00:00','ham',4),(230,108,'2026-04-22 00:00:00','cooo',1),(231,108,'2026-04-22 00:00:00','testA',1),(232,108,'2026-04-24 00:00:00','coffee1',1),(233,108,'2026-04-24 00:00:00','bluecat',4),(234,108,'2026-04-24 00:00:00','sunnyday',2),(235,108,'2026-04-24 00:00:00','ohhappy',1),(236,108,'2026-04-24 00:00:00','rabbit99',4),(237,108,'2026-04-24 00:00:00','ham',4),(238,108,'2026-04-24 00:00:00','cooo',4),(239,108,'2026-04-24 00:00:00','testA',1),(240,108,'2026-04-23 00:00:00','coffee1',1),(241,108,'2026-04-23 00:00:00','bluecat',1),(242,108,'2026-04-23 00:00:00','sunnyday',0),(243,108,'2026-04-23 00:00:00','ohhappy',1),(244,108,'2026-04-23 00:00:00','rabbit99',0),(245,108,'2026-04-23 00:00:00','ham',1),(246,108,'2026-04-23 00:00:00','cooo',1),(247,108,'2026-04-23 00:00:00','testA',1),(248,108,'2026-04-27 00:00:00','coffee1',1),(249,108,'2026-04-27 00:00:00','bluecat',1),(250,108,'2026-04-27 00:00:00','sunnyday',4),(251,108,'2026-04-27 00:00:00','ohhappy',1),(252,108,'2026-04-27 00:00:00','rabbit99',1),(253,108,'2026-04-27 00:00:00','ham',1),(254,108,'2026-04-27 00:00:00','cooo',1),(255,108,'2026-04-27 00:00:00','testA',1);
/*!40000 ALTER TABLE `course_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_class`
--

DROP TABLE IF EXISTS `course_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_class` (
  `class_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '강의실ID',
  `class_name` varchar(255) DEFAULT NULL,
  `people_limit` int(11) NOT NULL COMMENT '인원수',
  `status` int(11) NOT NULL COMMENT '상태',
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COMMENT='강의실';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_class`
--

LOCK TABLES `course_class` WRITE;
/*!40000 ALTER TABLE `course_class` DISABLE KEYS */;
INSERT INTO `course_class` VALUES (1,'103',40,1),(2,'102',40,1),(3,'201',40,1),(4,'202',40,1),(5,'301',40,1),(6,'302',40,0),(7,'302',40,0),(8,'302',40,0),(9,'103',40,0),(10,'103',40,0),(11,'401',40,0),(12,'444',40,0),(13,'333',40,0),(14,'101',40,0),(15,'101',40,1),(16,'102',40,1),(17,'601',40,1),(18,'401',40,0),(19,'501',40,0),(20,'402',40,0),(21,'111',40,0),(22,'501',40,0),(23,'502',40,0),(24,'7777',40,0),(25,'403',40,1),(26,'501',40,1),(27,'303',30,1),(28,'555',35,0),(29,'555',40,0),(30,'5555',40,0),(31,'5555',40,0),(32,'104',11,1),(33,'602',10,0),(34,'603',20,0),(35,'111',40,0);
/*!40000 ALTER TABLE `course_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_materials`
--

DROP TABLE IF EXISTS `course_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_materials` (
  `materials_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '강의자료ID',
  `title` varchar(255) NOT NULL COMMENT '제목',
  `content` text COMMENT '내용',
  `register_date` datetime DEFAULT NULL COMMENT '작성일',
  `update_date` datetime DEFAULT NULL COMMENT '수정일',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `file_id` bigint(20) NOT NULL COMMENT '파일ID',
  PRIMARY KEY (`materials_id`),
  KEY `FK_file_TO_course_materials` (`file_id`),
  KEY `FK_course_TO_course_materials` (`course_id`),
  CONSTRAINT `FK_course_TO_course_materials` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_file_TO_course_materials` FOREIGN KEY (`file_id`) REFERENCES `file` (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COMMENT='강의 자료';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_materials`
--

LOCK TABLES `course_materials` WRITE;
/*!40000 ALTER TABLE `course_materials` DISABLE KEYS */;
INSERT INTO `course_materials` VALUES (42,'오늘은 내가 짜파게티 요리사','댕댕이가 해주는 짜파게티 먹을 사람??','2026-04-24 00:00:00',NULL,1,145),(45,'JAVA 핵심 기술 스택 학습 가이드 안내','','2026-04-24 00:00:00',NULL,1,150),(46,'React 핵심 기술 스택 학습 가이드 안내','','2026-04-24 00:00:00',NULL,107,151),(47,'하프물범은 배가 고파요','','2026-04-24 00:00:00',NULL,107,152),(48,'내가 최고의 하프 물범이야','','2026-04-24 00:00:00',NULL,112,153),(49,'용감한 햄스터가 되는 방법','토끼에게 쫄지말라.','2026-04-27 00:00:00',NULL,112,154),(52,'sdf','sdfsdfs',NULL,NULL,1,161);
/*!40000 ALTER TABLE `course_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_status`
--

DROP TABLE IF EXISTS `course_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_status` (
  `cos_sta_code` int(11) NOT NULL COMMENT '강의신청상태코드',
  `name` varchar(255) NOT NULL COMMENT '강의신청상태명',
  PRIMARY KEY (`cos_sta_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='강의 신청 상태';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_status`
--

LOCK TABLES `course_status` WRITE;
/*!40000 ALTER TABLE `course_status` DISABLE KEYS */;
INSERT INTO `course_status` VALUES (-1,'거절'),(0,'대기중'),(1,'활성화');
/*!40000 ALTER TABLE `course_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_time`
--

DROP TABLE IF EXISTS `course_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_time` (
  `time_code` int(11) NOT NULL COMMENT '강의시간코드',
  `start_time` varchar(40) DEFAULT NULL,
  `end_time` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`time_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='강의시간대';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_time`
--

LOCK TABLES `course_time` WRITE;
/*!40000 ALTER TABLE `course_time` DISABLE KEYS */;
INSERT INTO `course_time` VALUES (1,'9:00','12:00'),(2,'12:00','14:00'),(3,'14:00','17:00');
/*!40000 ALTER TABLE `course_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '파일ID',
  `size` int(11) NOT NULL COMMENT '파일사이즈',
  `type` varchar(255) DEFAULT NULL COMMENT '파일확장자',
  `name` varchar(255) NOT NULL COMMENT '파일명',
  `logical_path` varchar(255) NOT NULL COMMENT '논리저장경로',
  `physical_path` varchar(255) NOT NULL COMMENT '물리저장경로',
  PRIMARY KEY (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COMMENT='파일';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file`
--

LOCK TABLES `file` WRITE;
/*!40000 ALTER TABLE `file` DISABLE KEYS */;
INSERT INTO `file` VALUES (1,23000,NULL,'jdk-1.8','/serverfilefilecoursejdk-1.8,,,9db97045-1c77-493a-866f-bc16103f9037.pdf','\\192.168.0.89sharefolderfilecoursejdk-1.8,,,9db97045-1c77-493a-866f-bc16103f9037.pdf'),(14,0,NULL,'','C:/LMSProject/submit/','C:/LMSProject/submit/ac142914-ae6b-4869-9ba2-b6375d9ce618_'),(36,0,NULL,'','C:/LMSProject/submit/','C:/LMSProject/submit/c7505bbb-0111-410d-935d-c3ffefce85ee_'),(37,0,NULL,'','C:/LMSProject/submit/','C:/LMSProject/submit/c00f171e-f379-4d83-a29d-239b5d64983c_'),(38,0,NULL,'','C:/LMSProject/submit/','C:/LMSProject/submit/dec70154-e372-4c71-b4ef-74cd210c9c48_'),(39,0,NULL,'','C:/LMSProject/submit/','C:/LMSProject/submit/ecbd8766-9a86-4607-92f9-9d37e58c0682_'),(58,1593789,'pdf','테스트.pdf','C:\\FileRepository\\homework\\1468b420-2892-4e7e-a39f-ae66d7c21ecb_테스트.pdf','C:\\FileRepository\\homework\\1468b420-2892-4e7e-a39f-ae66d7c21ecb_테스트.pdf'),(59,1593789,NULL,'테스트.pdf','C:/LMSProject/submit/','C:/LMSProject/submit/6864458a-b0ba-442f-ae43-215f267dffeb_테스트.pdf'),(60,17964539,'pdf','포트폴리용 PPT.pdf','C:\\FileRepository\\homework\\9cde1724-1438-40fe-be24-c7c0ba90c04a_포트폴리용 PPT.pdf','C:\\FileRepository\\homework\\9cde1724-1438-40fe-be24-c7c0ba90c04a_포트폴리용 PPT.pdf'),(61,1593789,NULL,'테스트.pdf','C:/LMSProject/submit/','C:/LMSProject/submit/0f512a1f-cb16-47c8-bc12-1e9344c49f79_테스트.pdf'),(62,598883,'pptx','LMS_기확서v1.1.pptx','/materials\\1\\2025-12-15\\LMS_기확서v1.1,,,238d6e09-c6fe-4ac0-9c02-dc6c4715ac3a.pptx','Z:/LMSProject\\/materials\\1\\2025-12-15\\LMS_기확서v1.1,,,238d6e09-c6fe-4ac0-9c02-dc6c4715ac3a.pptx'),(64,2341376,'ppt','구인구직_화면정의서_V1.1.ppt','/materials\\104\\2025-12-15\\구인구직_화면정의서_V1.1,,,4e3a3180-cc5e-4a19-b3fd-44bbdff28b9e.ppt','Z:/LMSProject\\/materials\\104\\2025-12-15\\구인구직_화면정의서_V1.1,,,4e3a3180-cc5e-4a19-b3fd-44bbdff28b9e.ppt'),(65,12895,NULL,'vuejs_샘플.xlsx','C:/LMSProject/submit/','C:/LMSProject/submit/73a80193-6840-4309-939b-494bae5aff5a_vuejs_샘플.xlsx'),(66,13048,NULL,'springboot_샘플.xlsx','C:/LMSProject/submit/','C:/LMSProject/submit/64b8b87c-03b7-48bb-83a6-ae4ceb8e696e_springboot_샘플.xlsx'),(68,12895,NULL,'vuejs_샘플.xlsx','C:/LMSProject/submit/','C:/LMSProject/submit/f58617fd-edc7-4ccb-a9e0-54a44a5bdf70_vuejs_샘플.xlsx'),(70,60040,'webp','jyfakluns6g51.webp','C:\\FileRepository\\homework\\a8e5174f-6d66-4820-848d-46dc9c331493_jyfakluns6g51.webp','C:\\FileRepository\\homework\\a8e5174f-6d66-4820-848d-46dc9c331493_jyfakluns6g51.webp'),(71,5384,'jpg','images.jpg','C:\\FileRepository\\homework\\2e4603bb-9ad6-44db-b893-d5287adce596_images.jpg','C:\\FileRepository\\homework\\2e4603bb-9ad6-44db-b893-d5287adce596_images.jpg'),(72,51061,NULL,'IMG_4177.jpg','C:/LMSProject/submit/','C:/LMSProject/submit/fbc01822-b177-4125-b4c3-12727843d2e2_IMG_4177.jpg'),(73,60040,NULL,'jyfakluns6g51.webp','C:/LMSProject/submit/','C:/LMSProject/submit/c0e7e6d5-2eb5-4aa6-9998-6302b02e57ba_jyfakluns6g51.webp'),(74,10287,'jpg','IMG_6393.jpg','C:\\FileRepository\\homework\\f91d7bb1-93a1-4361-b314-a4d36e7e4c6c_IMG_6393.jpg','C:\\FileRepository\\homework\\f91d7bb1-93a1-4361-b314-a4d36e7e4c6c_IMG_6393.jpg'),(75,51061,'jpg','IMG_4177.jpg','C:\\FileRepository\\homework\\3c944dd5-f422-494b-8b80-88c97c0b1cf1_IMG_4177.jpg','C:\\FileRepository\\homework\\3c944dd5-f422-494b-8b80-88c97c0b1cf1_IMG_4177.jpg'),(76,12559,NULL,'images (2).jpg','C:/LMSProject/submit/','C:/LMSProject/submit/075fb281-0bf6-4af5-8f83-02db62431bbf_images (2).jpg'),(78,533286,'pdf','정보처리기사 필기 정리.pdf','/materials\\1\\2026-01-09\\정보처리기사 필기 정리,,,6fc6c7a5-f178-4bd7-8437-2f6882a9455d.pdf','//192.168.0.89/sharefolder/LMSProject\\/materials\\1\\2026-01-09\\정보처리기사 필기 정리,,,6fc6c7a5-f178-4bd7-8437-2f6882a9455d.pdf'),(79,573039,'png','GTP.png','materials/\\123\\null\\GTP,,,20d8d58d-e722-44de-a39c-1c7e0e20107d.png','//192.168.0.130/sharefolder/LMSProject/materials/\\materials/\\123\\null\\GTP,,,20d8d58d-e722-44de-a39c-1c7e0e20107d.png'),(88,505582,'pdf','2023 수제비 정보처리산업기사 필기 두음쌤.pdf','materials/\\1\\null\\2023 수제비 정보처리산업기사 필기 두음쌤,,,83d883ce-fa5d-4826-b480-189e1e204eba.pdf','//192.168.0.130/sharefolder/LMSProject/materials/\\materials/\\1\\null\\2023 수제비 정보처리산업기사 필기 두음쌤,,,83d883ce-fa5d-4826-b480-189e1e204eba.pdf'),(91,701311,'pdf','[이기적] 정보처리기사 필기(2024년 3회 기출문제)_unlocked.pdf','materials/\\3\\2026-02-18\\[이기적] 정보처리기사 필기(2024년 3회 기출문제)_unlocked,,,46bd8466-29e9-4c68-acf0-ac48fcf3ea5c.pdf','Z:/LMSProject\\3\\2026-02-18\\[이기적] 정보처리기사 필기(2024년 3회 기출문제)_unlocked,,,46bd8466-29e9-4c68-acf0-ac48fcf3ea5c.pdf'),(93,713118,'pdf','[이기적] 정보처리기사 필기(2024년 3회 기출문제) (1).pdf','assignments/156c85d5-71ee-4710-9a14-64f85d1fccb8_[이기적] 정보처리기사 필기(2024년 3회 기출문제) (1).pdf','//192.168.0.130/sharefolder/LMSProject/assignments/\\156c85d5-71ee-4710-9a14-64f85d1fccb8_[이기적] 정보처리기사 필기(2024년 3회 기출문제) (1).pdf'),(94,505582,'pdf','2023 수제비 정보처리산업기사 필기 두음쌤.pdf','assignments/6a7d4437-497d-4630-8f87-caffd190b4de_2023 수제비 정보처리산업기사 필기 두음쌤.pdf','//192.168.0.130/sharefolder/LMSProject/assignments/\\6a7d4437-497d-4630-8f87-caffd190b4de_2023 수제비 정보처리산업기사 필기 두음쌤.pdf'),(96,21114,'png','image1.png','/jquery_img/974c1892-1187-46ec-8536-c881b651a161_image1.png','C:\\jquery_img\\974c1892-1187-46ec-8536-c881b651a161_image1.png'),(98,21114,'png','image1.png','/jquery_img/b519fab4-8ac4-4f0b-b33c-1aeed4782a1f_image1.png','C:\\jquery_img\\b519fab4-8ac4-4f0b-b33c-1aeed4782a1f_image1.png'),(99,21114,NULL,'image1.png','/jquery_img/bd449414-6546-44cd-a483-9683b5f1ee8d_image1.png','C:\\jquery_img\\bd449414-6546-44cd-a483-9683b5f1ee8d_image1.png'),(100,1386,NULL,'image2.PNG','/jquery_img/f41f6d3f-79bf-47bf-a019-84fe6eccd794_image2.PNG','C:\\jquery_img\\f41f6d3f-79bf-47bf-a019-84fe6eccd794_image2.PNG'),(101,1386,NULL,'image2.PNG','/jquery_img/7760cada-4336-4936-86b7-4723df254863_image2.PNG','C:\\jquery_img\\7760cada-4336-4936-86b7-4723df254863_image2.PNG'),(102,2638,NULL,'image3.PNG','/jquery_img/e5c448a9-be76-4876-aa5e-a4c95f1d205e_image3.PNG','C:\\jquery_img\\e5c448a9-be76-4876-aa5e-a4c95f1d205e_image3.PNG'),(103,1386,NULL,'image2.PNG','/jquery_img/57b6ed9c-8095-42c0-9f18-e42790a81ef4_image2.PNG','C:\\jquery_img\\57b6ed9c-8095-42c0-9f18-e42790a81ef4_image2.PNG'),(104,1386,NULL,'image2.PNG','/jquery_img/3607cfed-656f-46bc-a7c6-b10919413170_image2.PNG','C:\\jquery_img\\3607cfed-656f-46bc-a7c6-b10919413170_image2.PNG'),(106,4600,'jpg','image4.jpg','/jquery_img/063c7615-6db5-4ef2-9025-a27a2dcc062a_image4.jpg','C:\\jquery_img\\063c7615-6db5-4ef2-9025-a27a2dcc062a_image4.jpg'),(107,3806,NULL,'image5.jpg','/jquery_img/6855d770-4d97-4d64-8a2d-31094789adb2_image5.jpg','C:\\jquery_img\\6855d770-4d97-4d64-8a2d-31094789adb2_image5.jpg'),(108,3806,NULL,'image5.jpg','/jquery_img/a9a23314-1d36-4559-81b0-97ce481a0bca_image5.jpg','C:\\jquery_img\\a9a23314-1d36-4559-81b0-97ce481a0bca_image5.jpg'),(109,1386,'PNG','image2.PNG','/jquery_img/5ea8a3e1-6c48-4514-8f08-216995dd7407_image2.PNG','C:\\jquery_img\\5ea8a3e1-6c48-4514-8f08-216995dd7407_image2.PNG'),(110,4600,NULL,'image4.jpg','/jquery_img/e79a5a4a-c78b-4943-8863-d0e5e7158131_image4.jpg','C:\\jquery_img\\e79a5a4a-c78b-4943-8863-d0e5e7158131_image4.jpg'),(111,2638,'PNG','image3.PNG','/jquery_img/502bdc8f-a1d4-4e4d-bfa0-44cfee2782eb_image3.PNG','C:\\jquery_img\\502bdc8f-a1d4-4e4d-bfa0-44cfee2782eb_image3.PNG'),(112,3806,NULL,'image5.jpg','/jquery_img/49f8ce9d-ee0f-47df-816b-0a7e5a4268bc_image5.jpg','C:\\jquery_img\\49f8ce9d-ee0f-47df-816b-0a7e5a4268bc_image5.jpg'),(113,4600,NULL,'image4.jpg','/jquery_img/f9704b9b-6808-4b46-81ca-072b12c01e37_image4.jpg','C:\\jquery_img\\f9704b9b-6808-4b46-81ca-072b12c01e37_image4.jpg'),(114,4600,NULL,'image4.jpg','/jquery_img/4e5f8b09-7316-48b0-b443-2c7ea525d595_image4.jpg','C:\\jquery_img\\4e5f8b09-7316-48b0-b443-2c7ea525d595_image4.jpg'),(115,3806,NULL,'image5.jpg','/jquery_img/cf8b6d19-b54e-46de-82fc-c601c7fbd5df_image5.jpg','C:\\jquery_img\\cf8b6d19-b54e-46de-82fc-c601c7fbd5df_image5.jpg'),(116,1386,NULL,'image2.PNG','/jquery_img/6e3cbe42-6d60-4a42-897d-72fd498b3a72_image2.PNG','C:\\jquery_img\\6e3cbe42-6d60-4a42-897d-72fd498b3a72_image2.PNG'),(117,5834,'xlsx','문제업로드_샘플.xlsx','/jquery_img/7e6672d3-1308-4644-912b-d6d172ae0415_문제업로드_샘플.xlsx','C:\\jquery_img\\7e6672d3-1308-4644-912b-d6d172ae0415_문제업로드_샘플.xlsx'),(118,5834,'xlsx','문제업로드_샘플.xlsx','/jquery_img/c2a9d8fd-757c-4b1a-8f69-e87d84e367f2_문제업로드_샘플.xlsx','C:\\jquery_img\\c2a9d8fd-757c-4b1a-8f69-e87d84e367f2_문제업로드_샘플.xlsx'),(119,3806,'jpg','image5.jpg','/jquery_img/98cb2c37-b6a5-4fe8-b90a-f8e13c0b0a0d_image5.jpg','C:\\jquery_img\\98cb2c37-b6a5-4fe8-b90a-f8e13c0b0a0d_image5.jpg'),(124,689974,'png','blurr1.png','/jquery_img/bb583e20-2e7e-4529-9ba0-c0cb6c81cc37_blurr1.png','C:\\jquery_img/bb583e20-2e7e-4529-9ba0-c0cb6c81cc37_blurr1.png'),(125,1250901,'png','blurr2.png','/jquery_img/915964be-1d2f-495b-8772-15d6a15e42ce_blurr2.png','C:\\jquery_img/915964be-1d2f-495b-8772-15d6a15e42ce_blurr2.png'),(126,34173,'pptx','테스트용.pptx','/jquery_img/129f5f69-350b-4ff8-9fa3-9855fb963c08_테스트용.pptx','C:\\jquery_img/129f5f69-350b-4ff8-9fa3-9855fb963c08_테스트용.pptx'),(127,793733,'png','blurr8.png','/jquery_img/64551440-efb6-4129-91f0-e2cc587e9f5e_blurr8.png','C:\\jquery_img/64551440-efb6-4129-91f0-e2cc587e9f5e_blurr8.png'),(128,3806,'jpg','image5.jpg','materials/\\5\\null\\image5,,,000d1598-b7fb-4098-8f6f-e8344f0faac2.jpg','Z:/LMSProject\\5\\null\\image5,,,000d1598-b7fb-4098-8f6f-e8344f0faac2.jpg'),(129,689974,NULL,'blurr1.png','/jquery_img/b11ead62-eccc-491c-9dc1-142464fbee44_blurr1.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/b11ead62-eccc-491c-9dc1-142464fbee44_blurr1.png'),(130,689974,NULL,'blurr1.png','/jquery_img/24e49fc7-0bca-4b18-ac0e-cf41aff4889c_blurr1.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/24e49fc7-0bca-4b18-ac0e-cf41aff4889c_blurr1.png'),(131,619688,NULL,'blurr9.png','/jquery_img/f6bc9481-c5ae-4c0e-8c5c-8c896fa74455_blurr9.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/f6bc9481-c5ae-4c0e-8c5c-8c896fa74455_blurr9.png'),(132,730629,NULL,'blurr5.png','/jquery_img/3e1895fd-3f8d-4479-a994-9a4e3440d304_blurr5.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/3e1895fd-3f8d-4479-a994-9a4e3440d304_blurr5.png'),(133,803466,NULL,'blurr12.png','/jquery_img/d3f9c658-813b-4b6b-82a2-e43d9f007a28_blurr12.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/d3f9c658-813b-4b6b-82a2-e43d9f007a28_blurr12.png'),(134,586961,NULL,'blurr15.png','/jquery_img/09148ed4-afb4-4c9a-9ae6-925cb78ba1a2_blurr15.png','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/09148ed4-afb4-4c9a-9ae6-925cb78ba1a2_blurr15.png'),(135,18280,'xlsx','시험문제_등록_샘플.xlsx','/jquery_img/bcd2a2b9-5960-44ae-aadf-557a5bee41fb_시험문제_등록_샘플.xlsx','C:\\jquery_img\\bcd2a2b9-5960-44ae-aadf-557a5bee41fb_시험문제_등록_샘플.xlsx'),(145,58862,'jpg','optimize.jpg','materials/e6a39e66-b5b2-4f0f-a38a-40deb67fa5c6.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\e6a39e66-b5b2-4f0f-a38a-40deb67fa5c6.jpg'),(146,58862,NULL,'optimize.jpg','/jquery_img/c03c78be-1d50-430a-9e0f-b8203f2948e9_optimize.jpg','C:\\jquery_img\\c03c78be-1d50-430a-9e0f-b8203f2948e9_optimize.jpg'),(147,58862,NULL,'optimize.jpg','/jquery_img/c059ca83-a1cf-458f-a59c-a4441f33c8ad_optimize.jpg','C:\\jquery_img\\c059ca83-a1cf-458f-a59c-a4441f33c8ad_optimize.jpg'),(150,440950,'jpg','2.jpg','materials/b15edb2b-94ab-44fe-85ce-1b0b93543173.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\b15edb2b-94ab-44fe-85ce-1b0b93543173.jpg'),(151,136606,'jpg','6.jpg','materials/9504ba43-9699-4bb1-9961-79fccb2e6f29.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\9504ba43-9699-4bb1-9961-79fccb2e6f29.jpg'),(152,5336,'jpg','3.jpg','materials/24adda18-8b4b-4830-89ca-5554aaa5e535.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\24adda18-8b4b-4830-89ca-5554aaa5e535.jpg'),(153,52546,'jpg','5.jpg','materials/918d9520-8e43-4c28-a7fd-821078cd116a.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\918d9520-8e43-4c28-a7fd-821078cd116a.jpg'),(154,56620,'jpg','f009o6fbt4w2ib73a68a.jpg','materials/5ae8f04b-e178-463d-b9f2-a25ba155d3f1.jpg','\\\\192.168.0.130\\sharefolder\\LMSProject\\materials\\5ae8f04b-e178-463d-b9f2-a25ba155d3f1.jpg'),(155,34173,NULL,'테스트용.pptx','/jquery_img/bb3f170e-baf4-4789-bd2c-4a8b1c42e0dd_테스트용.pptx','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/bb3f170e-baf4-4789-bd2c-4a8b1c42e0dd_테스트용.pptx'),(156,34173,'pptx','테스트용.pptx','/jquery_img/616136ef-cf60-4a09-bb99-5270b66cbb30_테스트용.pptx','C:\\jquery_img/616136ef-cf60-4a09-bb99-5270b66cbb30_테스트용.pptx'),(159,34173,'pptx','테스트용.pptx','/jquery_img/d132ba58-0f20-4348-ae96-4af9f9abb01f_테스트용.pptx','C:\\jquery_img/d132ba58-0f20-4348-ae96-4af9f9abb01f_테스트용.pptx'),(160,34173,NULL,'테스트용.pptx','/jquery_img/f26d9c99-30b6-432c-9179-15a9776ecfd0_테스트용.pptx','/Users/kimsangyoon/.SmartTomcat/backend/happyjob/C:\\jquery_img/f26d9c99-30b6-432c-9179-15a9776ecfd0_테스트용.pptx'),(161,21114,'png','image1.png','materials/\\1\\null\\image1,,,35bc8055-5221-45a9-acb2-fb0f87e214c8.png','Z:/LMSProject\\1\\null\\image1,,,35bc8055-5221-45a9-acb2-fb0f87e214c8.png');
/*!40000 ALTER TABLE `file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework`
--

DROP TABLE IF EXISTS `homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework` (
  `homework_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '과제코드',
  `content` varchar(255) NOT NULL COMMENT '과제내용',
  `title` varchar(255) NOT NULL COMMENT '과제명',
  `status` varchar(255) NOT NULL COMMENT '과제진행사항',
  `start_date` varchar(255) NOT NULL COMMENT '과제시작일',
  `end_date` varchar(255) NOT NULL COMMENT '과제종료일',
  `course_id` bigint(20) DEFAULT NULL,
  `loginID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`homework_code`),
  KEY `fk_homework_user` (`loginID`),
  KEY `fk_homework_course` (`course_id`),
  CONSTRAINT `fk_homework_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_homework_user` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 COMMENT='과제 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework`
--

LOCK TABLES `homework` WRITE;
/*!40000 ALTER TABLE `homework` DISABLE KEYS */;
INSERT INTO `homework` VALUES (228,'','수정테스트1','진행 예정','2026-02-01','2026-02-28',1,'happyjob_482193'),(229,'11','데이터 넘어가는지 테스트 ','진행 예정','2026-02-23','2026-02-28',1,'happyjob_482193'),(242,'마감','마감','진행 예정','2026-02-01','2026-02-07',1,'happyjob_482193'),(243,'','파일다운로드테스','진행 예정','2026-02-09','2026-02-17',1,'happyjob_482193'),(246,'아아 ','과제등록 19일자 테스트 ','진행 예정','2026-02-19','2026-02-28',3,'happyjob_482193'),(247,'111','111','진행 예정','2026-02-19','2026-02-28',5,'happyjob_482193'),(251,'아...ㅇㅇㄴㄴ','리액트','진행 예정','2026-03-16','2026-03-17',107,'happyjob_165576'),(252,'등산하자고 제발','등산하자','진행 예정','2026-03-16','2026-03-17',111,'happyjob_482193'),(260,'가자 했다고 ㅇㅇ','등산가자했다','진행 예정','2026-03-23','2026-03-24',111,'happyjob_482193'),(262,'졸리덩..','스프링부트','진행 예정','2026-03-17','2026-03-21',5,'happyjob_482193'),(263,'스프링스프링','부트부트','진행 예정','2026-04-12','2026-08-19',5,'happyjob_482193'),(265,'새로운과제','새로운 과제','진행 예정','2026-05-18','2026-09-22',5,'happyjob_482193'),(266,'ENDLESS','끝나지 않는 과제','진행 예정','2026-03-18','2026-03-31',5,'happyjob_482193'),(267,'','123','진행 예정','2026-03-25','2026-03-24',1,'happyjob_165576'),(268,'','VUE','진행 예정','2026-03-25','2026-03-26',108,'happyjob_165576'),(269,'리액트 과제','리액트 과제','진행 예정','2026-04-10','2026-07-28',3,'happyjob_482193'),(270,'','sssss','진행 예정','2026-04-16','2026-04-30',3,'happyjob_482193'),(271,'','이건테스트용44','진행 예정','2026-04-16','2026-04-17',111,'happyjob_482193'),(272,'','테스트트트','진행 예정','2026-04-16','2026-04-24',3,'happyjob_482193'),(279,'','Test','진행 예정','2026-04-02','2026-05-22',1,'happyjob_165576'),(280,'','무엇이든 제출 가능','진행 예정','2026-04-17','2026-07-23',1,'happyjob_165576'),(281,'','8888','진행 예정','2026-04-10','2026-05-04',107,'happyjob_165576'),(282,'','0909','진행 예정','2026-04-10','2026-05-10',107,'happyjob_165576'),(283,'','테스트용11','진행 예정','2026-04-14','2026-05-30',3,'happyjob_482193');
/*!40000 ALTER TABLE `homework` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework_file`
--

DROP TABLE IF EXISTS `homework_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework_file` (
  `hom_fil_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '과제파일코드',
  `type` varchar(255) NOT NULL COMMENT '과제제출파일타입',
  `homework_code` bigint(20) DEFAULT NULL COMMENT '과제코드',
  `submission_code` bigint(20) DEFAULT NULL,
  `file_id` bigint(20) NOT NULL COMMENT '파일ID',
  PRIMARY KEY (`hom_fil_code`),
  KEY `FK_file_TO_homework_file` (`file_id`),
  KEY `FK_homework_TO_homework_file` (`homework_code`),
  KEY `FK_submission_TO_homework_file` (`submission_code`),
  CONSTRAINT `FK_file_TO_homework_file` FOREIGN KEY (`file_id`) REFERENCES `file` (`file_id`),
  CONSTRAINT `FK_homework_TO_homework_file` FOREIGN KEY (`homework_code`) REFERENCES `homework` (`homework_code`),
  CONSTRAINT `FK_submission_TO_homework_file` FOREIGN KEY (`submission_code`) REFERENCES `submission` (`submission_code`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COMMENT='과제 파일';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework_file`
--

LOCK TABLES `homework_file` WRITE;
/*!40000 ALTER TABLE `homework_file` DISABLE KEYS */;
INSERT INTO `homework_file` VALUES (14,'STUDENT',263,47,107),(23,'STUDENT',262,46,116),(39,'STUDENT',280,53,147),(41,'HOMEWORK',282,NULL,156),(42,'HOMEWORK',283,NULL,159),(43,'STUDENT',280,54,160);
/*!40000 ALTER TABLE `homework_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructor_evaluation`
--

DROP TABLE IF EXISTS `instructor_evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructor_evaluation` (
  `evaluation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '평가ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `content` text NOT NULL COMMENT '내용',
  PRIMARY KEY (`evaluation_id`),
  KEY `FK_tb_userinfo_TO_instructor_evaluation` (`loginID`),
  CONSTRAINT `FK_tb_userinfo_TO_instructor_evaluation` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COMMENT='강사 평가';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor_evaluation`
--

LOCK TABLES `instructor_evaluation` WRITE;
/*!40000 ALTER TABLE `instructor_evaluation` DISABLE KEYS */;
INSERT INTO `instructor_evaluation` VALUES (12,'happyjob_935821','시간준수 철저함'),(13,'happyjob_482193','김태훈 테스트테스트테스트'),(14,'happyjob_710254','SQL 수업에 적극적  수정 가능'),(15,'happyjob_580910','야옹거림'),(16,'happyjob_560130','야옹야옹'),(17,'happyjob_308957',''),(18,'happyjob_165576','테스트ㅁㄴㅇㅁㄴㅇㅁㅇ'),(19,'happyjob_572311','ㅁㄴㅇㅁ'),(20,'happyjob_545565','ㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴ'),(21,'happyjob_846480','ㅁㄴㅇㅁㄴㅇㅁㅇㅁㄴㅇㅁㄴ'),(22,'happyjob_601176','ㅁㄴㅇㅁㄴㅇ'),(23,'happyjob_964842','ㅁㄴㅇㅁㅇ\n'),(24,'happyjob_759172','테스트1'),(25,'happyjob_571794',''),(26,'happyjob_497046',''),(27,'happyjob_139079',''),(28,'happyjob_428442',''),(29,'happyjob_755168',''),(30,'happyjob_533946',''),(31,'happyjob_281587','테스트'),(32,'happyjob_456363',''),(33,'happyjob_349478','활성 테스트'),(35,'happyjob_123456','강사 특이사항 입력12123'),(36,'happyjob_123123','평가중');
/*!40000 ALTER TABLE `instructor_evaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `notice_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '공지사항ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `title` varchar(255) NOT NULL COMMENT '제목',
  `user` varchar(255) NOT NULL COMMENT '작성자',
  `content` text NOT NULL COMMENT '내용',
  `reg_date` datetime NOT NULL COMMENT '등록일',
  `view_count` int(11) NOT NULL COMMENT '조회수',
  PRIMARY KEY (`notice_id`),
  KEY `FK_tb_userinfo_TO_notice` (`loginID`),
  CONSTRAINT `FK_tb_userinfo_TO_notice` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COMMENT='공지 사항';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (1,'admin','공지사항 오픈 안내하하2323','관리자','공지사항 게시판이 오픈되었습니다. 이건 테스트입니다12390','2025-11-20 09:00:00',46),(2,'admin','서비스 점검 안내','관리자','11월 21일 새벽 2시~4시 서비스 점검이 있습니다.','2025-11-20 10:15:00',31),(3,'admin','회원가입 이벤트 안내','관리자','신규 가입 회원 대상으로 이벤트를 진행합니다.','2025-11-21 08:30:00',21),(4,'admin','비밀번호 변경 권장','관리자','보안을 위해 비밀번호를 변경해 주세요.','2025-11-21 11:00:00',36),(5,'admin','문의 게시판 이용 안내','관리자','문의 게시판 이용 방법을 안내드립니다.','2025-11-22 09:20:00',11),(6,'admin','휴무 일정 안내','관리자','12월 1일은 전체 휴무일입니다.','2025-11-22 14:05:00',25),(7,'admin','포인트 적립 정책 변경','관리자','포인트 적립 비율이 변경되었습니다.','2025-11-23 10:10:00',15),(8,'admin','공지사항 작성 예시','관리자','테스트용 공지사항 예시입니다.','2025-11-23 16:45:00',10),(9,'admin','배송 지연 안내','관리자','물류 사정으로 일부 상품 배송이 지연됩니다.','2025-11-24 09:05:00',33),(10,'admin','시스템 업데이트 완료','관리자','시스템 업데이트가 정상적으로 완료되었습니다.','2025-11-24 13:30:00',25),(11,'admin','모바일 앱 출시 안내','관리자','ㅇㅇㅇㅇㅇㅇㅇㅇ모바일 앱이 새롭게 출시되었습니다.','2025-11-25 08:50:00',45),(12,'admin','개인정보 처리방침 변경','관리자','개인정보 처리방침이 일부 변경되었습니다.','2025-11-25 11:40:00',20),(13,'admin','이용 약관 변경 안내','관리자','이용 약관이 12월 1일부터 변경됩니다.','2025-11-26 09:10:00',21),(14,'admin','이벤트 당첨자 발표','관리자','11월 회원가입 이벤트 당첨자를 발표합니다.','2025-11-26 15:25:00',38),(15,'admin','정기점검 일정 사전 안내','관리자','다ㅁ','2025-11-27 09:00:00',28),(17,'admin','신규 기능 베타 테스트','관리자','신규 기능 베타 테스트 참가자를 모집합니다.','2025-11-28 10:30:00',36),(18,'admin','회원 정보 수정 안내','관리자','수정 마이페이지에서 회원 정보를 수정할 수 있습니다.88','2025-11-28 14:00:00',28),(19,'admin','FAQ 업데이트 안내','관리자','수정 자주 묻는 질문(FAQ)이 새로 업데이트되었습니다.','2025-11-29 09:40:00',31),(20,'admin','연말 이벤트 사전 공지','관리자','연말 맞이 대규모 이벤트가 예정되어 있습니다.','2025-11-29 16:20:00',59),(23,'admin','세번째 생성','관리자','헬로요 피플들','2025-12-03 03:49:16',22),(25,'admin','확인하기','관리자','확인하기 글쓰기ㅇㅇㅇㅇㅇ','2025-12-09 02:01:54',25),(28,'admin','test','관리자','tset','2026-01-08 02:59:40',45),(29,'admin','test','관리자','333','2026-01-12 01:40:59',23),(30,'admin','테스트1123123','관리자','이건 테스트입니다','2026-02-09 11:33:07',17),(32,'admin','오늘테스트해봅니다','관리자','하하이건테스트용하하하하2ㄴㅇㄴㅇ','2026-02-13 10:50:30',80),(36,'admin','안녕하세요1','관리자','공백 제거 확인해보겠습니다.1','2026-03-16 12:44:29',126),(38,'admin','줄바꿈 확인','관리자','ㅇㅈㅈㅈ\n1123\n3213123','2026-03-16 13:48:06',160),(43,'admin','저장확인','관리자','들여쓰기\n이상없음1','2026-03-17 11:56:00',136),(45,'admin','신규작성1','관리자','신규작성123','2026-04-28 11:28:26',2);
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qna_category`
--

DROP TABLE IF EXISTS `qna_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qna_category` (
  `category_code` varchar(255) NOT NULL COMMENT '카테고리코드',
  `name` varchar(255) NOT NULL COMMENT '카테고리이름',
  PRIMARY KEY (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Q&A 카테고리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qna_category`
--

LOCK TABLES `qna_category` WRITE;
/*!40000 ALTER TABLE `qna_category` DISABLE KEYS */;
INSERT INTO `qna_category` VALUES ('ACCOUNT','계정/로그인'),('ENROLL','수강관련'),('ETC','기타'),('LECTURE','강의내용'),('SYSTEM','시스템오류');
/*!40000 ALTER TABLE `qna_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qna_comment`
--

DROP TABLE IF EXISTS `qna_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qna_comment` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '댓글ID',
  `post_id` bigint(20) NOT NULL COMMENT '게시글ID',
  `content` text NOT NULL COMMENT '내용',
  `is_teacher` varchar(255) NOT NULL COMMENT '강사여부',
  `is_deleted` varchar(255) NOT NULL COMMENT '삭제여부',
  `created_at` datetime NOT NULL COMMENT '생성일자',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  PRIMARY KEY (`comment_id`,`post_id`),
  KEY `FK_qna_post_TO_qna_comment` (`post_id`),
  KEY `FK_tb_userinfo_TO_qna_comment` (`loginID`),
  CONSTRAINT `FK_qna_post_TO_qna_comment` FOREIGN KEY (`post_id`) REFERENCES `qna_post` (`post_id`),
  CONSTRAINT `FK_tb_userinfo_TO_qna_comment` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COMMENT='Q&A 댓글';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qna_comment`
--

LOCK TABLES `qna_comment` WRITE;
/*!40000 ALTER TABLE `qna_comment` DISABLE KEYS */;
INSERT INTO `qna_comment` VALUES (1,1,'저도 같은 증상이 있었습니다.','N','N','2025-10-11 09:00:00','rabbit99'),(2,1,'서버 점검 후 정상화되었습니다!','Y','N','2025-10-11 10:30:00','happyjob_482193'),(3,2,'과제 너무 어려워요ㅜㅠ','N','N','2025-10-12 11:00:00','mintleaf'),(4,2,'과제 난이도 관련해서 조정 검토하겠습니다.','Y','N','2025-10-12 12:45:00','happyjob_710254'),(5,3,'문의주신 사항 답변드립니다.','Y','N','2025-10-14 11:20:00','happyjob_935821'),(6,4,'흠 이게 어렵더라구요~.','N','N','2025-10-23 12:40:00','hello'),(7,4,'Oracle 관련 내용은 강의자료 참고해주세요.','Y','Y','2025-10-23 14:00:00','happyjob_482193'),(8,5,'헉 저두요!!ㅋㅋㅋㅋ','N','N','2025-11-02 11:20:00','coolguy'),(9,5,'지금은 정상 작동합니다.','Y','N','2025-11-02 12:30:00','happyjob_710254'),(10,6,'파이썬 시험 너무 어렵던데요','N','N','2025-11-03 15:30:00','bluecat'),(11,6,'시험 난이도 조정 검토하겠습니다.','Y','N','2025-11-03 16:00:00','happyjob_482193'),(12,7,'일정은 공지사항에 업로드했습니다.','Y','N','2025-11-14 15:10:00','happyjob_710254'),(13,5,'이상하다 또안되네','N','Y','2025-12-10 05:04:10','admin'),(14,20,'어디로~','N','N','2025-12-10 05:15:02','admin'),(15,20,'문의해야','N','N','2025-12-10 05:15:06','admin'),(16,20,'하지','N','Y','2025-12-10 05:15:09','admin'),(17,20,'하나요','N','Y','2025-12-10 05:15:16','admin'),(18,20,'할까요?','N','Y','2025-12-10 06:08:16','admin'),(19,20,'할까요?ㅠㅠ','N','N','2025-12-10 06:21:17','admin'),(20,5,'해결 완료!','N','Y','2025-12-10 06:22:49','admin'),(21,20,'내가 관리자인데','Y','Y','2025-12-10 06:38:07','admin'),(22,20,'댓글 한번더','Y','Y','2025-12-10 06:38:19','admin'),(23,8,'다시 시도해주세요','Y','N','2025-12-10 06:38:28','admin'),(24,20,'한번더','N','N','2025-12-10 06:45:10','admin'),(25,21,'비밀번호는','N','N','2025-12-10 06:45:51','admin'),(26,21,'비밀임','N','Y','2025-12-10 06:45:55','admin'),(27,9,'비밀입니다','N','N','2025-12-10 06:55:47','admin'),(28,10,'혼자하세요','Y','N','2025-12-10 07:33:18','happyjob_482193'),(29,11,'저두안열려요','N','N','2025-12-10 07:33:52','bluecat'),(30,21,'486','Y','Y','2025-12-11 01:04:11','happyjob_482193'),(31,23,'옛다 답글','Y','N','2025-12-11 01:44:07','happyjob_482193'),(32,11,'자료에 문제가 있었습니다. 다시 시도해보세요!','Y','N','2025-12-11 01:44:46','happyjob_482193'),(33,5,'고쳤습니다','N','N','2025-12-11 04:30:05','admin'),(34,25,'해결했ㅅ슨니다','Y','N','2025-12-16 01:31:21','happyjob_482193'),(35,24,'sp','N','N','2025-12-16 01:32:07','admin'),(36,25,'ddddd','N','Y','2025-12-16 02:06:35','admin'),(37,26,'작성은?','N','N','2026-02-12 11:18:30','admin'),(38,26,'가능합니다!','N','N','2026-02-12 11:18:33','admin'),(39,26,'냥ㅇ냥ㅎ','N','Y','2026-02-12 11:18:45','admin'),(40,26,'수정삭제도','N','N','2026-02-12 11:21:05','admin'),(41,26,'일단 가넝~','N','N','2026-02-12 11:21:09','admin'),(42,4,'화이팅','N','N','2026-02-12 12:24:30','admin'),(43,33,'야호','N','N','2026-02-12 16:51:01','admin'),(44,33,'호호호호','N','Y','2026-02-12 17:00:20','admin'),(45,35,'ㅎㅎ','N','N','2026-02-12 17:01:12','admin'),(46,31,'냐옹','N','N','2026-02-13 09:19:22','admin'),(47,31,'이제잘보이지','N','N','2026-02-13 14:31:14','admin'),(48,31,'ㅎ','N','Y','2026-02-13 14:31:16','admin'),(49,31,'ㅎㅎㅎ','N','N','2026-02-13 14:31:20','admin'),(50,35,'굿ㅎㅎ','N','Y','2026-02-13 15:23:12','admin'),(51,40,'넹~','Y','N','2026-02-19 15:14:21','happyjob_165576'),(52,40,'흐음?','Y','N','2026-02-19 15:17:53','happyjob_165576'),(53,39,'ㅎㅎㅎㅎ','Y','N','2026-02-19 15:31:58','happyjob_165576'),(54,41,'ㅎㅎㅎㅎㅎ?','N','N','2026-02-19 15:32:26','admin'),(55,39,'ㅎㅎ','N','N','2026-02-19 16:25:48','coolguy'),(56,46,'귀여워요~','N','N','2026-02-20 11:14:26','ham'),(57,46,'또 올려주세요~~~','Y','N','2026-02-20 11:16:38','happyjob_183438'),(58,46,'ㅎㅎ','Y','Y','2026-02-20 11:22:34','happyjob_183438'),(59,46,'ㅎㅎ','Y','Y','2026-02-20 11:22:34','happyjob_183438'),(60,46,'귀엽죠 ㅎㅎ','N','N','2026-02-20 11:36:09','coolguy'),(61,46,'넹~~','N','N','2026-02-20 11:39:15','admin'),(62,46,'우왓','Y','N','2026-02-20 11:47:00','happyjob_165576'),(63,47,'ㅎㅎㅎ','N','N','2026-02-20 15:20:46','admin'),(64,45,'set','N','N','2026-04-16 16:03:57','admin'),(65,56,'ㅅㄷㄱ쇼','N','N','2026-04-16 16:16:24','admin'),(66,57,'ㅂㅂㅂ','N','N','2026-04-16 16:16:46','admin'),(67,45,'화사','N','N','2026-04-16 16:28:00','admin'),(68,57,'ㅂㅂㅂ3333','N','N','2026-04-16 17:32:02','admin'),(69,56,'ㅅㄷㄱ쇼337','N','N','2026-04-16 17:35:07','admin'),(70,47,'ㅎㅎㅎ111','N','N','2026-04-16 17:41:13','admin'),(71,48,'333444','N','N','2026-04-16 17:59:09','admin'),(72,61,'3434','N','N','2026-04-17 10:30:54','admin'),(73,54,'답변해','N','N','2026-04-17 10:53:50','admin'),(74,62,'감기조심하세요ㅎㅎㅎ','N','N','2026-04-17 10:54:25','admin'),(75,63,'답변','N','N','2026-04-17 11:51:34','admin'),(76,69,'44444444','N','N','2026-04-17 15:15:25','admin'),(77,66,'ㅂㅂㅂㅂ','N','N','2026-04-17 15:19:23','admin'),(78,71,'ㅎㅎㅎ','N','N','2026-04-17 15:30:41','admin'),(79,73,'ㅎㅎㅎ','N','N','2026-04-17 15:34:26','admin'),(80,70,'ㅍㅍㅍㅍㅍ','N','N','2026-04-17 15:34:48','admin');
/*!40000 ALTER TABLE `qna_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qna_post`
--

DROP TABLE IF EXISTS `qna_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qna_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '게시글ID',
  `title` varchar(255) NOT NULL COMMENT '제목',
  `answer_status` varchar(255) NOT NULL COMMENT '답변상태',
  `content` text NOT NULL COMMENT '내용',
  `is_deleted` varchar(255) NOT NULL COMMENT '삭제여부',
  `created_at` datetime NOT NULL COMMENT '작성일자',
  `updated_at` datetime NOT NULL COMMENT '수정일자',
  `fil_ori_name` varchar(255) DEFAULT NULL COMMENT '원본파일명',
  `fil_sav_name` varchar(255) DEFAULT NULL COMMENT '저장파일명',
  `extends` varchar(255) DEFAULT NULL COMMENT '파일확장자',
  `size` int(11) DEFAULT NULL COMMENT '파일사이즈',
  `logical_path` varchar(255) DEFAULT NULL COMMENT '파일논리경로',
  `physical_path` varchar(255) DEFAULT NULL COMMENT '파일물리경로',
  `category_code` varchar(255) NOT NULL COMMENT '카테고리코드',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `request_target` varchar(50) DEFAULT NULL COMMENT '답변 요청 대상자 ID',
  PRIMARY KEY (`post_id`),
  KEY `FK_qna_category_TO_qna_post` (`category_code`),
  KEY `FK_tb_userinfo_TO_qna_post` (`loginID`),
  CONSTRAINT `FK_qna_category_TO_qna_post` FOREIGN KEY (`category_code`) REFERENCES `qna_category` (`category_code`),
  CONSTRAINT `FK_tb_userinfo_TO_qna_post` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COMMENT='Q&A 게시글';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qna_post`
--

LOCK TABLES `qna_post` WRITE;
/*!40000 ALTER TABLE `qna_post` DISABLE KEYS */;
INSERT INTO `qna_post` VALUES (1,'시험 접속 오류','Y','시험 접속 오류가 발생했습니다.','N','2025-10-11 08:20:00','2026-02-12 11:24:21',NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM','mintleaf','admin'),(2,'과제 문의,,,','Y','과제가 너무 어렵습니다.','Y','2025-10-12 10:11:00','2026-04-17 10:57:35',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','bluecat',NULL),(3,'문의드립니다~','Y','문의드립니다.','N','2025-10-14 09:35:00','2025-10-14 09:35:00',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','rabbit99',NULL),(4,'Oracle 질문','Y','오라클 관련 질문입니다.','N','2025-10-23 12:00:00','2026-02-12 11:24:13',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','coolguy','happyjob_482193'),(5,'사이트 문의','Y','사이트 오류가 있어 문의드립니다.','N','2025-11-02 11:00:00','2026-02-12 11:24:28',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','mintleaf','happyjob_165576'),(6,'파이썬 시험 관련 문의입니다.','Y','파이썬 시험 관련 문의입니다.','N','2025-11-03 15:00:00','2025-11-03 15:00:00',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','hello',NULL),(7,'수정 시험 일정 문의','Y','수정 시험 일정 문의드립니다.','N','2025-11-14 14:20:00','2025-12-11 04:27:16','admin.png','47549e9d-456c-406f-9d5e-477aa533d39e.png','.png',85121,'/upload/qna/','C:/LMSUpload/qna/','ENROLL','ohhappy',NULL),(8,'시험 접속 오류','Y','시험 페이지 접속이 안됩니다ㅠㅠ','N','2025-11-15 13:00:12','2025-12-11 01:32:17','img826.jpg','uuid_img826.jpg','jpg',1204,'/upload/qna','/var/upload/qna','SYSTEM','rabbit99',NULL),(9,'시험 범위 어떻게 되나요?','Y','시험 범위가 어디까지인가요?','N','2025-11-22 09:10:00','2025-11-22 09:10:00',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','mintleaf',NULL),(10,'프로젝트 질문','Y','프로젝트가 잘 안되는데 어떻게 해야 하나요? 같이해요ㅠㅠ','N','2025-11-25 10:00:00','2026-02-12 11:23:52',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','bluecat','happyjob_165576'),(11,'강의 자료가 안 열립니다.','Y','강의 자료를 클릭해도 열리지 않습니다. 확인 부탁드립니다.','N','2025-11-30 09:30:00','2026-02-12 11:24:34',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','rabbit99','happyjob_549083'),(12,'로그인이 자꾸 풀립니다.','N','로그인을 하면 몇 분 후 자동으로 로그아웃됩니다. 해결 방법이 있을까요?','N','2025-12-01 14:45:00','2026-02-12 11:23:45',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','sunnyday','happyjob_399612'),(13,'테스트  잘되나요','N','수정중입니다 파일도 첨부해볼게요','Y','2025-12-09 03:06:46','2025-12-09 06:36:58','qnaDetail.PNG','279b8547-6fed-4571-b0cf-c392b44b937a.PNG','.PNG',63285,'/upload/qna/','C:/LMSUpload/qna/','ACCOUNT','admin',NULL),(14,'삭제될까요','N','삭제되어야하는데','Y','2025-12-09 03:13:28','2025-12-09 03:30:09',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin',NULL),(15,'문제있나요','N','잇어용','Y','2025-12-09 05:20:09','2025-12-09 05:20:20',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',NULL),(16,'파일첨부해볼게용','N','어때용','Y','2025-12-09 06:22:58','2025-12-09 06:23:02',NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM','admin',NULL),(17,'파일첨부가 될까요','N','글쎄요','Y','2025-12-09 06:23:18','2025-12-09 06:23:51','qnaDetail.PNG','02464524-3772-44c5-9684-2a7aa5f9a8bc.PNG','.PNG',63285,'/upload/qna/','C:/LMSUpload/qna/','SYSTEM','admin',NULL),(18,'언제부터 수강 가능한가요?','N','내일부터 바로 듣고싶습니다','Y','2025-12-09 06:53:11','2025-12-10 07:14:31',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',NULL),(19,'게시글 삭제하고싶어요','N','기능 구현되면 알려주세요','Y','2025-12-09 07:10:00','2025-12-09 07:10:05','qnaDetail.PNG','dd9de3b9-7c0c-4c8e-93e1-fede668517fe.PNG','.PNG',63285,'/upload/qna/','C:/LMSUpload/qna/','ENROLL','admin',NULL),(20,'비밀번호 찾아주세요','Y','관리자도 혼자서는 어렵네요 ','Y','2025-12-09 07:24:33','2025-12-10 06:45:27',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',NULL),(21,'비밀번호 찾고싶어요','Y','비밀번호 뭐였지','Y','2025-12-10 06:45:44','2025-12-11 01:32:52','qnaDetail.PNG','70005783-88b4-4af1-9b70-7ccc81a4ccd5.PNG','.PNG',63285,'/upload/qna/','C:/LMSUpload/qna/','ACCOUNT','admin',NULL),(22,'비밀번호를 찾아주세요','N','비밀번호 486','N','2025-12-10 07:34:12','2026-02-12 17:14:20',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','bluecat','admin'),(23,'왜 답글 안달아주세요','Y','답글 달아주세요','N','2025-12-11 01:43:48','2025-12-11 01:43:48',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','bluecat',NULL),(24,'안녕하세요','Y','답변 달아주세요','Y','2025-12-15 07:51:28','2025-12-16 01:32:17','qnaDetail.PNG','91a4892c-2f0b-4bc9-bb15-727a6f677559.PNG','.PNG',63285,'/upload/qna/','C:/LMSUpload/qna/','ETC','bluecat',NULL),(25,'로그인이안되요','Y','냉무입니다','N','2025-12-16 01:30:00','2026-02-12 15:18:32','134128241294028069.jpg','329bfb95-06ec-4ce7-888d-95a86a29b4c3.jpg','jpg',2408512,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ACCOUNT','bluecat','happyjob_308957'),(26,'테스트용입니다','Y','아직 댓글 삭제가 안되욥','N','2026-02-12 10:53:49','2026-02-12 10:53:49',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin',''),(27,'답변 해주세요','N','관리자나 강사가 댓글을 달지 않으면 학생 댓글이 달리더라도 답변 대기상태입니다','N','2026-02-12 11:22:31','2026-02-12 11:22:31',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin','happyjob_165576'),(28,'마이크 테스트','N','아아','N','2026-02-12 11:22:43','2026-02-12 11:40:09',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin','admin'),(29,'관리자가 모두에게','N','문의합니당','N','2026-02-12 11:40:30','2026-02-13 15:24:29',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',''),(30,'미답변 모달 작업중','N','관리자는 전체 미답변문의를 확인할 수 있어야 함','N','2026-02-12 11:40:59','2026-02-12 11:40:59',NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM','admin',''),(31,'이거 사진게시물이지만 이제 에러안남','Y','드라이브 연결했기 때문~','N','2026-02-12 12:31:26','2026-02-19 17:16:13','134128241320224439.jpg','c33b46ae-6415-421e-bcec-3ac396fae559.jpg','jpg',1458632,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ACCOUNT','admin','happyjob_165576'),(32,'사진보이나요','N','ㅎ','N','2026-02-12 15:07:18','2026-02-12 15:07:18','134128241320224439.jpg','db9378fa-721a-43d3-a92c-53ace1d94e55.jpg','jpg',1458632,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ACCOUNT','admin','happyjob_165576'),(33,'잘되나요','Y','테스트용ㅎㅎ','Y','2026-02-12 16:18:53','2026-02-12 17:00:37',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','happyjob_165576','happyjob_710254'),(34,'관리자 지정 질문입니다','N','왜안보이니ㅠㅠ','N','2026-02-12 16:53:40','2026-02-19 14:59:12',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin','admin'),(35,'테스트중입니다아','Y','에러안떳으면','N','2026-02-12 17:01:00','2026-02-12 17:01:00',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',''),(36,'모두에게 뜨는 질문','N','질문대상자 지정 안했음','N','2026-02-13 15:24:00','2026-02-13 15:24:00',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',''),(37,'관리자에게 질문있음','N','냥냥~~','N','2026-02-13 15:24:13','2026-02-19 14:49:35',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin','admin'),(38,'성공','N','ㅠㅠㅠㅠ~','N','2026-02-13 17:43:18','2026-02-19 15:14:11',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','happyjob_165576',''),(39,'ㅎㅎ','Y','ㅎㅎㅎㅎ','N','2026-02-13 17:48:01','2026-02-19 14:58:24',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin','admin'),(40,'얏호','Y','보이시나요','N','2026-02-19 15:02:31','2026-02-19 15:02:31',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin','happyjob_165576'),(41,'아아 마이크테스트','Y','ㅎㅎ','Y','2026-02-19 15:32:21','2026-02-19 15:32:41',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin','happyjob_183438'),(42,'도와주세용','N','질문있어요','Y','2026-02-19 16:25:17','2026-02-19 16:25:27',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','coolguy','happyjob_165576'),(43,'도와주세용','N','질문있어요','Y','2026-02-19 16:25:17','2026-02-19 16:25:31',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','coolguy','happyjob_165576'),(44,'질문있어요','N','질문~','N','2026-02-19 16:25:42','2026-02-19 16:26:26','134128241294028069.jpg','8e30213b-0133-4a47-b534-2f8d6ecce3e6.jpg','jpg',2408512,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ENROLL','coolguy','happyjob_165576'),(45,'안녕하세요111','Y','111','N','2026-02-20 10:34:37','2026-04-16 17:56:53','134128241294028069.jpg','8a08862f-83d5-482d-84d5-a774e74713b9.jpg','jpg',2408512,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ACCOUNT','admin',NULL),(46,'다들 귀여운 제 고양이를 보세요','Y','냐옹','Y','2026-02-20 10:48:32','2026-04-17 10:57:13','고양이.png','57ca4fb1-55e2-4951-9207-1a62040d90e7.png','png',551507,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ENROLL','coolguy','happyjob_165576'),(47,'테스트','Y','ㅎㅎㅎㅎ','N','2026-02-20 15:19:36','2026-02-20 15:19:36','134139494902573137.jpg','03dc34ed-af9f-4d3e-80ee-6a83970b089f.jpg','jpg',1888945,'/qna01/','//192.168.0.130/sharefolder/LMSProject/qna01/','ACCOUNT','coolguy','happyjob_165576'),(48,'ㅅㄷㄴㅅ','Y','ㅅㄷㄴㅅ','N','2026-04-16 13:52:17','2026-04-16 13:52:17',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',NULL),(54,'수정해','Y','수정해','N','2026-04-16 14:50:22','2026-04-17 10:53:44',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(56,'test','Y','test','Y','2026-04-16 14:54:00','2026-04-17 11:00:09',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(57,'test57','Y','57','N','2026-04-16 14:55:12','2026-04-16 17:31:53',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(58,'1111','N','1111','N','2026-04-17 08:54:59','2026-04-17 08:54:59',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(59,'222','N','2222','N','2026-04-17 08:57:59','2026-04-17 08:57:59',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(60,'444','N','4444','Y','2026-04-17 09:17:17','2026-04-17 15:21:09',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(61,'1212','Y','1212','N','2026-04-17 10:30:43','2026-04-17 10:30:43',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',NULL),(62,'에치','Y','에치','N','2026-04-17 10:54:13','2026-04-17 10:54:13',NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM','admin',NULL),(63,'질문','Y','질문','N','2026-04-17 11:51:18','2026-04-17 11:51:18',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',NULL),(66,'123','Y','123','N','2026-04-17 14:14:40','2026-04-17 14:14:40',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','admin',NULL),(68,'ㅅㄷㄵㅅ','N','ㅅㄷㄴㄳ','Y','2026-04-17 15:05:22','2026-04-17 15:19:14',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',NULL),(69,'666622222222','Y','666611111111','Y','2026-04-17 15:15:18','2026-04-17 15:17:31',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',NULL),(70,'ㅇㅇㅇㅇ','Y','ㅇㅇㅇㅇ','N','2026-04-17 15:19:32','2026-04-17 15:19:32',NULL,NULL,NULL,NULL,NULL,NULL,'LECTURE','admin',NULL),(71,'ㅋㅋㅋ','Y','ㅋㅋㅋ','N','2026-04-17 15:20:55','2026-04-17 15:21:02',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin',NULL),(72,'ㅊㅊㅊ','N','ㅊㅊㅊ','Y','2026-04-17 15:30:28','2026-04-17 15:30:34',NULL,NULL,NULL,NULL,NULL,NULL,'ETC','admin',NULL),(73,'ㅇㅇㅇ','Y','ㅇㅇㅇ','Y','2026-04-17 15:34:20','2026-04-17 15:34:39',NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM','admin',NULL),(74,'제목','N','질문내용','Y','2026-04-28 11:16:57','2026-04-28 11:17:22',NULL,NULL,NULL,NULL,NULL,NULL,'ENROLL','admin',NULL),(75,'ㅅㄷㄴㅅ','N','ㅅㄷㄴㅅ','N','2026-04-28 11:18:13','2026-04-28 11:18:13',NULL,NULL,NULL,NULL,NULL,NULL,'ACCOUNT','ham',NULL);
/*!40000 ALTER TABLE `qna_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resume`
--

DROP TABLE IF EXISTS `resume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resume` (
  `resume_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `name` varchar(255) NOT NULL COMMENT '이력서이름',
  `logical_path` varchar(255) NOT NULL COMMENT '논리경로',
  `physical_path` varchar(255) NOT NULL COMMENT '물리경로',
  `extends` varchar(255) NOT NULL COMMENT '확장자',
  `size` int(11) NOT NULL COMMENT '사이즈',
  `create_at` timestamp NULL DEFAULT NULL COMMENT '생성시간',
  PRIMARY KEY (`resume_id`),
  KEY `FK_tb_userinfo_TO_resume` (`loginID`),
  CONSTRAINT `FK_tb_userinfo_TO_resume` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COMMENT='이력서';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resume`
--

LOCK TABLES `resume` WRITE;
/*!40000 ALTER TABLE `resume` DISABLE KEYS */;
INSERT INTO `resume` VALUES (14,'rabbit99','rabbit99_00d695d7-280b-4eee-a080-d43a3b37cd9c_기본이력서3.pdf','/resume/','\\\\192.168.0.130\\sharefolder\\LMSProject\\resume\\rabbit99_00d695d7-280b-4eee-a080-d43a3b37cd9c_기본이력서3.pdf','pdf',67090,'2025-12-12 07:27:29'),(24,'bluecat','bluecat_534bceb0-f495-404f-90c6-9bc7e93a6c2b_김지훈_이력서1234.docx','/resume/','\\\\192.168.0.130\\sharefolder\\LMSProject\\resume\\bluecat_534bceb0-f495-404f-90c6-9bc7e93a6c2b_김지훈_이력서1234.docx','docx',15664,'2026-01-09 01:43:18'),(26,'coolguy','coolguy_ed99a5b0-bbfb-4377-9ddc-e82353b7e1ca_coolguy_resume.pdf','/resume/','//192.168.0.130/sharefolder/LMSProject/resume/coolguy_ed99a5b0-bbfb-4377-9ddc-e82353b7e1ca_coolguy_resume.pdf','pdf',26199,'2026-02-09 05:41:55'),(28,'mintleaf','mintleaf_e15a3242-9a28-4127-a9d5-e2ea948f6f0b_jQuery.pdf','/resume/','\\\\192.168.0.130\\sharefolder\\LMSProject\\resume\\mintleaf_e15a3242-9a28-4127-a9d5-e2ea948f6f0b_jQuery.pdf','pdf',3931359,'2026-03-16 08:26:05'),(29,'sunnyday','sunnyday_678b4665-b352-4ec4-aedd-683cd4267102_jQuery.pdf','/resume/','\\\\192.168.0.130\\sharefolder\\LMSProject\\resume\\sunnyday_678b4665-b352-4ec4-aedd-683cd4267102_jQuery.pdf','pdf',3931359,'2026-03-16 08:26:19'),(39,'ohhappy','ohhappy_042f719b-9a8a-4df7-920a-2fb67b409bae_ohhappy_resume.pdf','/resume/','C:\\jquery_img\\resume\\ohhappy_042f719b-9a8a-4df7-920a-2fb67b409bae_ohhappy_resume.pdf','pdf',26622,'2026-03-25 01:21:39'),(40,'qwe123','qwe123_c4d007de-b897-47ba-8460-0cb0a9802172_ohhappy_resume.pdf','/resume/','C:\\jquery_img\\resume\\qwe123_c4d007de-b897-47ba-8460-0cb0a9802172_ohhappy_resume.pdf','pdf',26622,'2026-03-25 06:01:11'),(42,'testA','testA_676b8436-05f9-4e0c-a81e-06b2b20188ed_홍길동_이력서.pdf','/resume/','\\\\192.168.0.130\\sharefolder\\LMSProject\\resume\\testA_676b8436-05f9-4e0c-a81e-06b2b20188ed_홍길동_이력서.pdf','pdf',110100,'2026-04-21 00:14:14'),(45,'ham','ham_ab176115-2f14-4257-a7c7-ec06db735dd4_happjob.pdf','/resume/','C:\\Users\\admin\\lms_uploads\\resume\\ham_ab176115-2f14-4257-a7c7-ec06db735dd4_happjob.pdf','pdf',110100,'2026-04-27 03:38:24');
/*!40000 ALTER TABLE `resume` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '리뷰번호',
  `answer` text COMMENT '리뷰답변',
  `survey_id` bigint(20) NOT NULL COMMENT '설문번호',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  PRIMARY KEY (`review_id`),
  KEY `FK_survey_TO_review` (`survey_id`),
  KEY `FK_tb_userinfo_TO_review` (`loginID`),
  KEY `FK_course_TO_review` (`course_id`),
  CONSTRAINT `FK_course_TO_review` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_survey_TO_review` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`survey_id`),
  CONSTRAINT `FK_tb_userinfo_TO_review` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='강의 리뷰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_course`
--

DROP TABLE IF EXISTS `student_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_course` (
  `stu_cou_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '수강정보ID',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `stu_cou_sta_code` int(11) NOT NULL COMMENT '수강상태코드',
  PRIMARY KEY (`stu_cou_id`,`course_id`),
  KEY `FK_student_course_status_TO_student_course` (`stu_cou_sta_code`),
  KEY `FK_tb_userinfo_TO_student_course` (`loginID`),
  KEY `FK_course_TO_student_course` (`course_id`),
  CONSTRAINT `FK_course_TO_student_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_student_course_status_TO_student_course` FOREIGN KEY (`stu_cou_sta_code`) REFERENCES `student_course_status` (`stu_cou_sta_code`),
  CONSTRAINT `FK_tb_userinfo_TO_student_course` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COMMENT='수강 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_course`
--

LOCK TABLES `student_course` WRITE;
/*!40000 ALTER TABLE `student_course` DISABLE KEYS */;
INSERT INTO `student_course` VALUES (1,1,'rabbit99',0),(3,1,'sunnyday',0),(5,1,'coolguy',1),(6,1,'mintleaf',1),(7,1,'ohhappy',1),(8,3,'coolguy',1),(9,3,'mintleaf',1),(10,3,'ohhappy',1),(10,106,'ohhappy',1),(11,3,'sunnyday',1),(17,5,'hello',0),(18,5,'mintleaf',0),(20,5,'qqqq',0),(21,5,'qwe',0),(22,5,'stuTest',0),(38,5,'bluecat',0),(51,105,'rabbit99',0),(80,106,'bluecat',0),(86,5,'ham',0),(96,108,'ohhappy',0),(97,108,'ham',0),(98,108,'cooo',0),(99,108,'coffee1',0),(100,108,'bluecat',0),(101,1,'joooo',0),(102,108,'sunnyday',0),(103,108,'rabbit99',0),(104,1,'testA',0),(105,2,'testA',0),(106,3,'testA',0),(107,5,'testA',0),(108,106,'testA',0),(109,107,'testA',0),(110,108,'testA',0),(111,113,'testA',0),(115,1,'ham',0),(120,106,'ham',0),(121,124,'ham',0);
/*!40000 ALTER TABLE `student_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_course_status`
--

DROP TABLE IF EXISTS `student_course_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_course_status` (
  `stu_cou_sta_code` int(11) NOT NULL COMMENT '수강상태코드',
  `name` varchar(255) NOT NULL COMMENT '수강상태명',
  PRIMARY KEY (`stu_cou_sta_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='수강 상태';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_course_status`
--

LOCK TABLES `student_course_status` WRITE;
/*!40000 ALTER TABLE `student_course_status` DISABLE KEYS */;
INSERT INTO `student_course_status` VALUES (-1,'낙제'),(0,'수강중'),(1,'수강완료');
/*!40000 ALTER TABLE `student_course_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_test_answer`
--

DROP TABLE IF EXISTS `student_test_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_test_answer` (
  `question_no` int(11) NOT NULL COMMENT '문제번호',
  `period` int(11) NOT NULL COMMENT '차시',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `student_answer` int(11) DEFAULT NULL COMMENT '학생답안',
  PRIMARY KEY (`question_no`,`period`,`course_id`,`loginID`),
  KEY `FK_tb_userinfo_TO_student_test_answer` (`loginID`),
  CONSTRAINT `FK_tb_userinfo_TO_student_test_answer` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`),
  CONSTRAINT `FK_test_detail_TO_student_test_answer` FOREIGN KEY (`question_no`, `period`, `course_id`) REFERENCES `test_detail` (`question_no`, `period`, `course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='수강생별 시험답안';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_test_answer`
--

LOCK TABLES `student_test_answer` WRITE;
/*!40000 ALTER TABLE `student_test_answer` DISABLE KEYS */;
INSERT INTO `student_test_answer` VALUES (1,1,1,'ham',2),(1,1,1,'ohhappy',1),(1,2,1,'ham',1),(1,2,1,'ohhappy',2),(1,3,1,'ham',2),(1,7,1,'ham',1),(2,1,1,'ham',2),(2,1,1,'ohhappy',1),(2,2,1,'ham',1),(2,2,1,'ohhappy',3),(2,3,1,'ham',3),(2,7,1,'ham',2),(3,1,1,'ham',2),(3,1,1,'ohhappy',1),(3,2,1,'ham',1),(3,2,1,'ohhappy',3),(3,3,1,'ham',3),(3,7,1,'ham',3),(4,1,1,'ham',2),(4,1,1,'ohhappy',1),(4,2,1,'ham',3),(4,2,1,'ohhappy',2),(4,3,1,'ham',2),(4,7,1,'ham',3),(5,1,1,'ham',2),(5,1,1,'ohhappy',1),(5,2,1,'ham',3),(5,2,1,'ohhappy',2),(5,3,1,'ham',2),(5,7,1,'ham',2),(6,1,1,'ham',2),(6,1,1,'ohhappy',1),(6,2,1,'ham',3),(6,2,1,'ohhappy',2),(6,3,1,'ham',2),(6,7,1,'ham',2),(7,1,1,'ham',2),(7,1,1,'ohhappy',1),(7,2,1,'ham',3),(7,2,1,'ohhappy',3),(7,3,1,'ham',3),(7,7,1,'ham',3),(8,1,1,'ham',2),(8,1,1,'ohhappy',1),(8,2,1,'ham',3),(8,2,1,'ohhappy',3),(8,7,1,'ham',3),(9,1,1,'ham',2),(9,1,1,'ohhappy',1),(9,2,1,'ham',3),(9,2,1,'ohhappy',2),(9,7,1,'ham',3),(10,1,1,'ham',2),(10,1,1,'ohhappy',1),(10,2,1,'ham',3),(10,2,1,'ohhappy',3),(10,7,1,'ham',1);
/*!40000 ALTER TABLE `student_test_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_test_schedule`
--

DROP TABLE IF EXISTS `student_test_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_test_schedule` (
  `loginID` varchar(255) NOT NULL,
  `course_id` bigint(20) NOT NULL,
  `period` int(11) NOT NULL,
  `submit_date` datetime DEFAULT NULL,
  PRIMARY KEY (`loginID`,`course_id`,`period`),
  KEY `fk_sts_schedule` (`period`,`course_id`),
  CONSTRAINT `fk_sts_schedule` FOREIGN KEY (`period`, `course_id`) REFERENCES `test_schedule` (`period`, `course_id`),
  CONSTRAINT `fk_sts_user` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_test_schedule`
--

LOCK TABLES `student_test_schedule` WRITE;
/*!40000 ALTER TABLE `student_test_schedule` DISABLE KEYS */;
INSERT INTO `student_test_schedule` VALUES ('ham',1,1,'2026-04-28 10:34:25'),('ham',1,2,'2026-04-28 10:34:11'),('ham',1,3,'2026-04-27 09:14:12'),('ham',1,7,'2026-04-28 10:52:47'),('ohhappy',1,1,'2026-04-27 13:49:39'),('ohhappy',1,2,'2026-04-27 13:50:22');
/*!40000 ALTER TABLE `student_test_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission` (
  `submission_code` bigint(20) NOT NULL AUTO_INCREMENT,
  `score` int(11) DEFAULT NULL COMMENT '점수',
  `feedback` varchar(500) DEFAULT NULL COMMENT '피드백',
  `status` int(11) DEFAULT NULL COMMENT '제출상태',
  `date` datetime DEFAULT NULL COMMENT '제출날짜',
  `homework_code` bigint(20) NOT NULL COMMENT '과제코드',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `appeal_content` text,
  `appeal_reply` text,
  PRIMARY KEY (`submission_code`),
  KEY `FK_tb_userinfo_TO_submission` (`loginID`),
  KEY `FK_homework_TO_submission` (`homework_code`),
  CONSTRAINT `FK_homework_TO_submission` FOREIGN KEY (`homework_code`) REFERENCES `homework` (`homework_code`),
  CONSTRAINT `FK_tb_userinfo_TO_submission` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COMMENT='과제 제출';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission`
--

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
INSERT INTO `submission` VALUES (41,80,'80',1,'2026-02-20 15:15:21',229,'ohhappy','ㅇㅇ',NULL),(42,95,'잘했어요',1,'2026-02-10 14:58:10',243,'ohhappy','되나?',NULL),(43,85,'싫어요',1,'2026-02-10 18:16:11',228,'ohhappy','다시테스트','싫어요'),(44,80,'피드백 수정 ㅇㅇ',1,'2026-02-20 15:15:26',242,'ohhappy','ㅇㅇ','댈려나요'),(46,50,'50',1,'2026-03-18 14:52:48',262,'ohhappy',NULL,NULL),(47,15,'아쉽습니다.',1,'2026-03-18 11:56:27',263,'ohhappy',NULL,NULL),(48,70,'잘했어요',1,'2026-04-20 18:00:19',265,'ohhappy',NULL,NULL),(53,NULL,NULL,1,'2026-04-24 17:21:38',280,'ham',NULL,NULL),(54,NULL,NULL,1,'2026-04-28 10:42:30',280,'ohhappy',NULL,NULL);
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey` (
  `survey_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '설문번호',
  `title` varchar(255) NOT NULL COMMENT '설문제목',
  `created_at` datetime NOT NULL COMMENT '작성일',
  `view_count` bigint(20) NOT NULL COMMENT '조회수',
  `use_yn` varchar(255) NOT NULL COMMENT '사용여부',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  PRIMARY KEY (`survey_id`),
  KEY `FK_tb_userinfo_TO_survey` (`loginID`),
  KEY `FK_course_TO_survey` (`course_id`),
  CONSTRAINT `FK_course_TO_survey` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_tb_userinfo_TO_survey` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COMMENT='설문조사 응시정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey`
--

LOCK TABLES `survey` WRITE;
/*!40000 ALTER TABLE `survey` DISABLE KEYS */;
INSERT INTO `survey` VALUES (1,'설문등록','2026-04-24 14:41:26',8,'Y','admin',122),(2,'강의 선택','2026-04-24 14:41:48',7,'Y','admin',123),(3,'항목','2026-04-24 14:42:03',15,'Y','admin',114),(4,'지드래곤','2026-04-27 09:42:48',10,'Y','admin',112),(5,'123','2026-04-27 15:15:03',9,'Y','admin',126),(6,'1234','2026-04-27 15:16:04',9,'Y','admin',126),(7,'4444','2026-04-27 15:38:50',5,'Y','happyjob_165576',126),(8,'설문 등록','2026-04-27 15:50:36',3,'Y','admin',112),(9,'스프링 부트는 재미있는 수업인가?','2026-04-27 16:55:48',3,'Y','happyjob_165576',5),(10,'설문제목','2026-04-28 11:20:03',2,'Y','admin',112);
/*!40000 ALTER TABLE `survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_question`
--

DROP TABLE IF EXISTS `survey_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_question` (
  `question_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '문항번호',
  `content` text COMMENT '문항내용',
  `type` varchar(255) NOT NULL COMMENT '문항유형',
  `order` int(11) DEFAULT NULL COMMENT '문항순서',
  `survey_id` bigint(20) NOT NULL COMMENT '설문번호',
  PRIMARY KEY (`question_id`),
  KEY `FK_survey_TO_survey_question` (`survey_id`),
  CONSTRAINT `FK_survey_TO_survey_question` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`survey_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COMMENT='설문지 문항';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_question`
--

LOCK TABLES `survey_question` WRITE;
/*!40000 ALTER TABLE `survey_question` DISABLE KEYS */;
INSERT INTO `survey_question` VALUES (1,'설문등록1','TEXT',1,1),(2,'설문등록2','TEXT',2,1),(3,'설문등록3','TEXT',3,1),(4,'설문등록4','TEXT',4,1),(5,'설문등록5','TEXT',5,1),(6,'설문등록6','TEXT',6,1),(7,'강의 선택1','TEXT',1,2),(8,'강의 선택2','TEXT',2,2),(9,'강의 선택3','TEXT',3,2),(10,'강의 선택4','TEXT',4,2),(11,'강의 선택5','TEXT',5,2),(12,'항목','TEXT',1,3),(13,'항목','TEXT',2,3),(14,'항목','TEXT',3,3),(15,'항목','TEXT',4,3),(16,'항목','TEXT',5,3),(17,'항목','TEXT',6,3),(18,'항목','TEXT',7,3),(19,'지드래곤1','TEXT',1,4),(20,'지드래곤2','TEXT',2,4),(21,'지드래곤3','TEXT',3,4),(22,'123','TEXT',1,5),(23,'123','TEXT',2,5),(24,'123','TEXT',3,5),(25,'1234','TEXT',1,6),(26,'1234','TEXT',2,6),(27,'1234','TEXT',3,6),(28,'123','TEXT',1,7),(29,'123','TEXT',2,7),(30,'444','TEXT',3,7),(31,'설문 등록1','TEXT',1,8),(32,'설문 등록2','TEXT',2,8),(33,'설문 등록3','TEXT',3,8),(34,'설문 등록4','TEXT',4,8),(35,'설문 등록5','TEXT',5,8),(36,'이론도 재미있다','TEXT',1,9),(37,'코딩만 재미있다','TEXT',2,9),(38,'재미가 너무 없다','TEXT',3,9),(39,'너무 쉬워서 베울 팔요가 없다','TEXT',4,9),(40,'항목1','TEXT',1,10),(41,'항목2','TEXT',2,10),(42,'항목3','TEXT',3,10),(43,'항목4','TEXT',4,10),(44,'항목5','TEXT',5,10);
/*!40000 ALTER TABLE `survey_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_response`
--

DROP TABLE IF EXISTS `survey_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_response` (
  `response_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '응답번호',
  `score_value` int(11) DEFAULT NULL COMMENT '점수형응답',
  `text_value` varchar(500) DEFAULT NULL COMMENT '주관식응답',
  `created_at` datetime DEFAULT NULL COMMENT '응답일시',
  `survey_id` bigint(20) NOT NULL COMMENT '설문번호',
  `question_id` bigint(20) NOT NULL COMMENT '문항번호',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  PRIMARY KEY (`response_id`),
  KEY `FK_course_TO_survey_response` (`course_id`),
  KEY `FK_survey_TO_survey_response` (`survey_id`),
  KEY `FK_survey_question TO survey_reponse` (`question_id`),
  KEY `FK_tb_userinfo_TO_survey_response` (`loginID`),
  CONSTRAINT `FK_course_TO_survey_response` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `FK_survey_TO_survey_response` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`survey_id`),
  CONSTRAINT `FK_survey_question TO survey_reponse` FOREIGN KEY (`question_id`) REFERENCES `survey_question` (`question_id`),
  CONSTRAINT `FK_tb_userinfo_TO_survey_response` FOREIGN KEY (`loginID`) REFERENCES `tb_userinfo` (`loginID`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COMMENT='설문 응답';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_response`
--

LOCK TABLES `survey_response` WRITE;
/*!40000 ALTER TABLE `survey_response` DISABLE KEYS */;
INSERT INTO `survey_response` VALUES (163,NULL,NULL,'2026-04-27 15:21:24',4,21,112,'ham'),(164,NULL,NULL,'2026-04-27 15:39:00',7,29,126,'ham'),(165,NULL,NULL,'2026-04-28 11:21:18',10,40,112,'ham');
/*!40000 ALTER TABLE `survey_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_detail_code`
--

DROP TABLE IF EXISTS `tb_detail_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_detail_code` (
  `detail_code` varchar(20) NOT NULL COMMENT '상세코드',
  `group_code` varchar(20) NOT NULL COMMENT '그룹코드',
  `detail_name` varchar(200) DEFAULT NULL COMMENT '상세코드명',
  `note` varchar(2000) DEFAULT NULL COMMENT '주석',
  `use_yn` varchar(10) DEFAULT NULL COMMENT '사용여부',
  `regId` varchar(20) DEFAULT NULL COMMENT '등록자',
  `reg_date` datetime DEFAULT NULL COMMENT '등록일',
  `updateId` varchar(20) DEFAULT NULL COMMENT '수정자',
  `update_date` datetime DEFAULT NULL COMMENT '수정일',
  `sequence` int(3) DEFAULT NULL COMMENT '순서',
  `d_temp_field1` varchar(20) DEFAULT NULL COMMENT '임시필드1',
  `d_temp_field2` varchar(20) DEFAULT NULL COMMENT '임시필드2',
  `d_temp_field3` varchar(20) DEFAULT NULL COMMENT '임시필드3',
  `d_temp_field4` varchar(20) DEFAULT NULL COMMENT '임시필드4',
  PRIMARY KEY (`detail_code`,`group_code`),
  KEY `FK_tb_group_code_TO_tb_detail_code` (`group_code`),
  CONSTRAINT `FK_tb_group_code_TO_tb_detail_code` FOREIGN KEY (`group_code`) REFERENCES `tb_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='상세코드';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_detail_code`
--

LOCK TABLES `tb_detail_code` WRITE;
/*!40000 ALTER TABLE `tb_detail_code` DISABLE KEYS */;
INSERT INTO `tb_detail_code` VALUES ('-1','course_status','거절',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('-1','stu_cou_status','낙제',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('0','attend_status','결석',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('0','class_status','비활성화',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('0','course_status','대기중','기본값','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('0','stu_cou_status','수강중',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('0','test_status','비활성화','기본값','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','attend_status','출석',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','class_status','활성화','강의등록가능','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','course_status','활성화',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','course_time','9시~12시',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','stu_cou_status','수강완료',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1','test_status','활성화',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('2','attend_status','지각',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('2','course_time','12시~2시',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('3','attend_status','조퇴',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('3','course_time','2시~5시',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('4','attend_status','외출',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('A','category_code','계정/로그인','Account','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('A','homework_status','진행중','Active','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('A','user_role','관리자','Admin','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('C','category_code','수강관련','Course','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('class_name','cou_sea_code','강의실',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('course_id','cou_sea_code','강의번호',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('D','user_status','유예','Delay','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('E','category_code','기타','Etc','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('E','homework_status','마감','End','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('I','user_role','강사','Instructor','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('L','category_code','강의내용','Lecture','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','answer_status','미답변','No(기본값)','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','chk_temp_password','사용자 등록 비밀번호','No','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','is_deleted','삭제 X','No(기본값)','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','is_teacher','학생','No(기본값)','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','question_type','객관식','Number','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','submission_status','미제출','Not','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('N','use_yn','표시 X','No','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('name','cou_sea_code','교수명',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('P','homework_status','예정','Plan','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Q','user_status','탈퇴','Quit','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('R','hom_fil_type','강사가 올린 파일','Registered file','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('R','user_status','등록','Registration','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('S','category_code','시스템오류','System','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('S','hom_fil_type','학생이 올린 파일','Submitted file','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('S','submission_status','제출','Submit','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('S','user_role','학생','Student','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('T','question_type','주관식','Text','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('title','cou_sea_code','강의명',NULL,'Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Y','answer_status','답변완료','Yes','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Y','chk_temp_password','임시 비밀번호','Yes','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Y','is_deleted','삭제 O','Yes','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Y','is_teacher','강사','Yes','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Y','use_yn','표시 O','Yes','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tb_detail_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_group_code`
--

DROP TABLE IF EXISTS `tb_group_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_group_code` (
  `group_code` varchar(20) NOT NULL COMMENT '그룹코드',
  `group_name` varchar(200) DEFAULT NULL COMMENT '그룹코드명',
  `note` varchar(2000) DEFAULT NULL COMMENT '주석',
  `use_yn` varchar(10) DEFAULT NULL COMMENT '사용여부',
  `regId` varchar(20) DEFAULT NULL COMMENT '등록자',
  `reg_date` datetime DEFAULT NULL COMMENT '등록일',
  `updateId` varchar(20) DEFAULT NULL COMMENT '수정자',
  `update_date` datetime DEFAULT NULL COMMENT '수정일',
  `g_temp_field1` varchar(20) DEFAULT NULL COMMENT '임시필드1',
  `g_temp_field2` varchar(20) DEFAULT NULL COMMENT '임시필드2',
  `g_temp_field3` varchar(20) DEFAULT NULL COMMENT '임시필드3',
  PRIMARY KEY (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공통코드';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_group_code`
--

LOCK TABLES `tb_group_code` WRITE;
/*!40000 ALTER TABLE `tb_group_code` DISABLE KEYS */;
INSERT INTO `tb_group_code` VALUES ('answer_status','Q&A답변상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('attend_status','출결상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('category_code','Q&A카테고리',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('chk_temp_password','비밀번호유형',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('class_status','강의실상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('course_status','강의신청상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('course_time','강의시간대',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('cou_sea_code','강의검색코드',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('homework_status','과제진행사항',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('hom_fil_type','과제제출파일타입',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('is_deleted','Q&A삭제여부',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('is_teacher','강사답변여부',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('question_type','설문문항유형',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('stu_cou_status','수강상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('submission_status','과제제출여부',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('test_status','시험상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('user_role','사용자구분',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('user_status','사용자상태',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('use_yn','설문사용여부',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tb_group_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_notice`
--

DROP TABLE IF EXISTS `tb_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_notice` (
  `ntc_no` int(11) NOT NULL AUTO_INCREMENT COMMENT '공지번호',
  `ntc_title` varchar(255) NOT NULL COMMENT '제목',
  `ntc_content` text COMMENT '내용',
  `loginID` varchar(50) DEFAULT NULL COMMENT '작성자',
  `ntc_regdate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
  `file_name` varchar(255) DEFAULT NULL COMMENT '파일명',
  `logical_path` varchar(500) DEFAULT NULL COMMENT '논리경로',
  `physical_path` varchar(500) DEFAULT NULL COMMENT '실제경로',
  `file_size` bigint(20) DEFAULT NULL COMMENT '파일크기',
  `file_ext` varchar(10) DEFAULT NULL COMMENT '확장자',
  PRIMARY KEY (`ntc_no`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_notice`
--

LOCK TABLES `tb_notice` WRITE;
/*!40000 ALTER TABLE `tb_notice` DISABLE KEYS */;
INSERT INTO `tb_notice` VALUES (1,'테스트1','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(2,'테스트2','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(3,'테스트3','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(4,'테스트4','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(5,'테스트5','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(6,'테스트6','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(7,'테스트7','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(8,'테스트8','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(9,'테스트9','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(10,'테스트10','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(11,'테스트11','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(12,'테스트12','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(13,'테스트13','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(14,'테스트14','테스트입니다.','admin','2024-12-09 12:00:00',NULL,NULL,NULL,NULL,NULL),(15,'테스트15','테스트 수정2','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(16,'테스트16','TEST','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(17,'테스트17','신규 테스트','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(18,'테스트18','신규 테스트입니다.','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(19,'테스트19','지롱','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(20,'테스트20','신규등록테스트','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(21,'테스트21','테스트21입니다.','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(22,'테스트22','테스트입니다.','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(23,'테스트23','테스트입니다.','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(24,'테스트24','테스트입니다.','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(25,'테스트25','ㅁㅁㅁ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(26,'테스트26','ㅇㅇㅇ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(27,'테스트27','ㄱㄱㄱ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(28,'테스트28','ㄷㄷㄷㄷ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(29,'테스트29','ㄹㄹㄹㄹ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(30,'테스트30','ㅁㅁㅁㅁ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(31,'테스트31','ㅂㅂㅂㅂ','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(32,'테스트32','새로운내용','admin','2024-12-11 12:00:00',NULL,NULL,NULL,NULL,NULL),(33,'테스트33','ㅇㅇㅇㅇ1111111111','hwangg704','2024-07-24 12:00:00','스클립2','/server/file/notice','/server/file/notice',371469,'png'),(34,'테스트34','테스트입니다.','hwangg704','2025-07-24 12:00:00','스크립트1','/server/file/notice','/server/file/notice',371469,'png'),(35,'사회적경제행정학과','사회적경제행정학과','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(36,'테스트36','testset','admin','2025-10-27 12:00:00','happy.jpg',NULL,'Z:\\fileRepository\\notice\\happy.jpg',32099,'jpg'),(37,'테스트37','asdfasdads','admin','2025-10-27 12:00:00','happy2.jpg',NULL,'Z:\\fileRepository\\notice\\happy2.jpg',18990,'jpg'),(38,'테스트38','helotest','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(39,'테스트39','공지글 테스트','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(40,'테스트40','공지글 테스트','admin','2025-10-27 12:00:00','everland1.png',NULL,'Z:\\fileRepository\\notice\\everland1.png',118901,'png'),(41,'테스트41','테스트 20251027_33333','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(42,'테스트42','테스트 20251027','admin','2025-10-27 12:00:00','image-11820363.png',NULL,'/server/file/notice/image-11820363.png',171231,'png'),(43,'테스트43','테스트 20251027','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(44,'테스트44','테스트입니다','admin','2025-10-27 12:00:00','image-11820363.png',NULL,'/server/file/notice/image-11820363.png',132497,'png'),(45,'테스트45','테스트 20251027_4','admin','2025-10-27 12:00:00',NULL,NULL,NULL,NULL,NULL),(46,'테스트46','성공테스트입니다','admin','2025-10-27 12:00:00','everland1.jpg',NULL,'/server/file/notice/everland1.jpg',138990,'jpg');
/*!40000 ALTER TABLE `tb_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_userinfo`
--

DROP TABLE IF EXISTS `tb_userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_userinfo` (
  `loginID` varchar(255) NOT NULL COMMENT '사용자ID',
  `user_type` varchar(1) NOT NULL COMMENT '사용자구분',
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL COMMENT '비밀번호',
  `chk_tem_password` char(1) NOT NULL COMMENT '임시비밀번호 확인',
  `zipcode` varchar(255) DEFAULT NULL COMMENT '우편번호',
  `addr1` varchar(255) DEFAULT NULL COMMENT '주소1',
  `addr2` varchar(255) DEFAULT NULL COMMENT '주소2',
  `birthday` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL COMMENT '이메일',
  `edu_level` text COMMENT '학력',
  `career` text COMMENT '경력사항',
  `img_name` varchar(255) DEFAULT NULL COMMENT '이미지명',
  `img_logi_path` varchar(255) DEFAULT NULL COMMENT '이미지논리경로',
  `img_phy_path` varchar(255) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ret_date` timestamp NULL DEFAULT NULL COMMENT '탈퇴일',
  `status` char(1) NOT NULL COMMENT '사용자 상태구분',
  `logicalpath` varchar(500) DEFAULT NULL COMMENT '논리경로',
  PRIMARY KEY (`loginID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_userinfo`
--

LOCK TABLES `tb_userinfo` WRITE;
/*!40000 ALTER TABLE `tb_userinfo` DISABLE KEYS */;
INSERT INTO `tb_userinfo` VALUES ('admin','A','관리자','admin','N','12345','서울시 종로구','1층','198001011','010-1111-1111','admin@test.com',NULL,NULL,'admin.png','/profile/','Z://LMSProject/profile/admin.png','2025-12-04 05:18:04',NULL,'R',NULL),('bluecat','S','김지훈','123','Y','13529','경기 성남시 분당구 판교역로 166','카카오','200005011','010-2222-1111','bluecat@test.com',NULL,NULL,'bluecat_30ac1c78-2ae5-461c-a450-ca31bcbdb337.jfif','/profile/','Z:/LMSProject/profile/','2026-02-06 06:53:59',NULL,'D',NULL),('coffee1','S','김순대','H@CVVC7YgQ','Y','08381','서울 구로구 디지털로 273 (구로동, 에이스트윈타워2차)','2층 해피잡 기업연수원','200012233','017-1173-5618','happyjob00@java.com',NULL,NULL,NULL,NULL,NULL,'2026-02-05 07:01:37',NULL,'R',NULL),('coolguy','S','최윤석','123','N','67584','대구시 달서구','5동','200010021','010-6666-1111','coolguy@test.com',NULL,NULL,'coolguy_8997f6e4-e81a-434b-80a1-348f0db444d1.png','/profile/','//192.168.0.130/sharefolder/LMSProject/profile/','2025-12-10 07:24:10',NULL,'R',NULL),('cooo','S','홍길동','1234','N','','','','191111111','','ciffe@dd.com',NULL,NULL,NULL,NULL,NULL,'2026-02-20 05:17:00',NULL,'R',NULL),('ham','S','햄스터','123','N','21621','인천 남동구 도리미로 8 (도림동, 도림 아이파크)','쳇바퀴 2호','199902131','010-4567-4567','hamster@naver.com',NULL,NULL,'ham_ce508062-629c-41eb-bd9f-ebe13defc23f.jfif','/profile/','//192.168.0.130/sharefolder/LMSProject/profile/','2026-01-09 02:07:53',NULL,'R',NULL),('ham123','S','햄일이삼','123','N','13480','경기 성남시 분당구 대왕판교로 477','123','123456871','010-6352-6584','ham@gmail.com',NULL,NULL,NULL,NULL,NULL,'2026-03-23 05:14:26',NULL,'R',NULL),('ham2','S','햄햄','1212','N','08389','서울 구로구 디지털로26길 61 (구로동, 에이스하이엔드타워2차)','203호','199908072','010-0202-0303','hamster@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 06:54:58',NULL,'R',NULL),('happyjob_123123','I',NULL,'5^RiCBasRi','Y',NULL,NULL,NULL,NULL,NULL,'bungjun5230@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-03-25 09:26:08',NULL,'W',NULL),('happyjob_123456','I','박병준','1pKQ!&eYIw','Y','13480','경기 성남시 분당구 대왕판교로 477','123','231321321','010-1234-5678','pbkan4@gmail.com','123','123','happyjob_732455_870b1c10-6e16-49d6-93c4-160838689619.jpg','/profile/','C:/jquery_img/profile/','2026-03-23 14:30:12',NULL,'D',NULL),('happyjob_139079','I',NULL,'33QOZ#8x1l','Y',NULL,NULL,NULL,NULL,NULL,'rlcks7812@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:11:22',NULL,'D',NULL),('happyjob_165576','I','하프물범','1234','N','34672','대전 동구 판교1길 3 (판암동)','북극 남극','199902131','','hyeon12864@naver.com','남극 세종과학기지대학교','남극 세종과학기지 인턴\n남극 횡단 2회\n이글루 빨리 짓기 경연대회 입상','happyjob_165576_0ea563c9-6db7-4bd3-852b-1c2bff4b4009.png','/profile/','//192.168.0.130/sharefolder/LMSProject/profile/','2026-01-08 03:21:26',NULL,'R',NULL),('happyjob_183438','I','나는야사막여우','123','N','52339','경남 하동군 고전면 사막1길 5-3','사막 11호','199901111','010-4567-4567','hyeon12864@naver.com','사막 대학교 졸업','사막 횡단 1회','8ba182eb-df4e-4960-9515-cc20387662e1.jpeg','/profile/','Z://LMSProject/profile/8ba182eb-df4e-4960-9515-cc20387662e1.jpeg','2025-12-11 01:50:47',NULL,'R',NULL),('happyjob_281587','I',NULL,'!%tRJoSsML','Y',NULL,NULL,NULL,NULL,NULL,'hyeon12864@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:55:02','2026-02-06 05:55:02','Q',NULL),('happyjob_301324','I','병아리','123','N','28205','충북 청주시 상당구 가덕면 병암길 2','병아리 10호','199902131','010-1234-1234','hyeon12864@naver.com','양계장','양계장 1호','ce3f302d-34fa-434c-a425-e2cf4b574a04.png','/profile/','Z://LMSProject/profile/ce3f302d-34fa-434c-a425-e2cf4b574a04.png','2025-12-11 00:23:19',NULL,'R',NULL),('happyjob_308957','I','나는치타혹은퓨마','123','N','31770','충남 당진시 당진중앙2로 113 (읍내동)','퓨마일까 치타일까 11호','199902131','010-7894-4567','hyeon12864@naver.com','동물원 유치원 졸업\r\n동물원 중학교 졸업\r\n동물원 고등학교 졸업\r\n동물원 대학교 휴학','동물원 사육사 손가락 물기 5회\r\n다른 퓨마랑 싸워서 이김 2회\r\n','c99ddc45-95c6-4f29-a1fb-a1d5b868fdda.jpeg','/profile/','Z://LMSProject/profile/c99ddc45-95c6-4f29-a1fb-a1d5b868fdda.jpeg','2026-01-09 07:15:20','2026-01-09 07:15:20','Q',NULL),('happyjob_325118','I','이길동','1234','N','13480','경기 성남시 분당구 대왕판교로 477','','199909101','010-1234-6789','rlcks7812@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-04-28 11:26:54',NULL,'R',NULL),('happyjob_349478','I','테스트','123','N','08389','서울 구로구 디지털로26길 61','203호','199001021','010-2323-3434','kr123123003@naver.com','테스트','테스트','happyjob_349478_588a5835-3ab7-43c3-bbec-fcf4fa32ce8a.png','/profile/','/Volumes/sharefolder/LMSProject/profile/','2026-02-19 16:47:25',NULL,'R',NULL),('happyjob_399612','I','사진테스트','123','N','08334','서울 구로구 개봉로 4','개죽이 아파트 11호','199902131',NULL,'hyeon12864@naver.com','강아지 대학교','강아지 습성 강의','happyjob_399612_0c4eaf21-53df-4af2-8b0b-2ac25bc64481.jpeg','/profile/','Z:/LMSProject/profile/','2025-12-11 04:56:18',NULL,'R',NULL),('happyjob_428442','I',NULL,'lg9BCyd9$*','Y',NULL,NULL,NULL,NULL,NULL,'a50312900@gmail.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:11:26',NULL,'D',NULL),('happyjob_456363','I','ㅂㅈㄷ','123','N','58839','전남 신안군 안좌면 김환기길 1-1','123123ㅂㅈㄷㅂㅈㄷ','123123121','123-1231-1231','kr123123003@naver.com','123ㅂㅈㄷ','123ㅂㅈㄷ','happyjob_456363_c16d9871-e619-4812-9d62-f02115538f20.jpg','/profile/','C:/jquery_img/profile/','2026-02-12 11:18:17',NULL,'R',NULL),('happyjob_482193','I','김태훈','123','N','41068','대구 동구 첨단로 71','203호1111','198504141','010-1111-2222','test@test.com','한국대학교 소프트웨어 학과 졸업1\n한국대학요 소프트웨어 대학원 졸업을 함\n한국대학요 소프트웨어 대학원 졸업을 함','java script 기업강의 10회를 넘음\n한국대학요 소프트웨어 대학원 졸업을 함','happyjob_482193_406da3de-4902-49ec-8350-d49862ba2a29.jpg','/profile/','C:/jquery_img/profile/','2026-01-09 06:51:45',NULL,'R',NULL),('happyjob_497046','I',NULL,'Zx%$ko@4P!','Y',NULL,NULL,NULL,NULL,NULL,'hyeon12864@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:11:40',NULL,'D',NULL),('happyjob_504730','I','김바덕','123','N','','','203호','199912011','010-2323-2424','migamsu94@gmail.com','ㅇㄹㅇ','ㄹㅇㄴ','happyjob_504730_7230a9d1-fd45-4440-b08d-d06a32bd400e.png','/profile/','/Volumes/sharefolder/LMSProject/profile/','2026-02-20 14:21:40',NULL,'R',NULL),('happyjob_533946','I',NULL,'A1$0elCCpo','Y',NULL,NULL,NULL,NULL,NULL,'hyeon12864@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:11:48',NULL,'D',NULL),('happyjob_545565','I','수달인가해달인가','123','N','46048','부산 기장군 일광읍 물방길 98','나뭇가지집 1호','199902131',NULL,'hyeon12864@naver.com','나무 대학교','나무쌓기 12회','a33dc17b-cb7f-4ae4-b417-7eba2a0c04ec.jpeg','/profile/','Z://LMSProject/profile/a33dc17b-cb7f-4ae4-b417-7eba2a0c04ec.jpeg','2025-12-11 03:03:24',NULL,'R',NULL),('happyjob_549083','I','카피바라','123','N','05517','서울 송파구 바람드리길 6-3 (풍납동)','카피바라 11호','199902131','010-1234-1234','hyeon12864@naver.com','학력임','경력사항임','5c6cb2ae-4c90-4ce7-8c84-2285ec8a03ec.jpeg','/profile/','Z://LMSProject/profile/5c6cb2ae-4c90-4ce7-8c84-2285ec8a03ec.jpeg','2025-12-10 03:46:09',NULL,'R',NULL),('happyjob_560130','I','고양이다','123','N','10025','경기 김포시 월곶면 고양로 7','고양이 아파트 11호','199902131','010-1234-1234','hyeon12864@naver.com','학력 고양','경력사항 고양','f725fa81-ecef-4ca4-b444-25d7901cf153.png','/profile/','Z://LMSProject/profile/f725fa81-ecef-4ca4-b444-25d7901cf153.png','2025-12-10 03:19:50',NULL,'R',NULL),('happyjob_571794','I','테스트','123','N','13480','경기 성남시 분당구 대왕판교로 477','상세주소','200010101','010-0101-0101','hyeon12864@naver.com','학력정보','경력정보','happyjob_571794_5e2eca96-6525-48b9-8c8e-b0e27eb2c1a3.jpg','/profile/','C:/jquery_img/profile/','2026-02-06 06:52:30','2026-02-06 06:52:30','R',NULL),('happyjob_572311','I',NULL,'6xwsNq*JNa','Y',NULL,NULL,NULL,NULL,NULL,'hyeon12864@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 04:49:51','2026-02-06 04:49:51','Q',NULL),('happyjob_580910','I','고양이올시다','123','N','10546','경기 고양시 덕양구 간절로 77 (향동동)','고양이 빌라 1호','199902131','010-4567-4567','hyeon12864@naver.com','고양 학력','고양 경력사항','a70390dd-4a18-4048-8e4f-6de7e0bcb93d.png','/profile/','Z://LMSProject/profile/a70390dd-4a18-4048-8e4f-6de7e0bcb93d.png','2025-12-10 03:36:46',NULL,'R',NULL),('happyjob_601176','I','앉아있는새','123','N','05857','서울 송파구 새말로 27 (문정동)','새둥지 121호','199901012','010-1234-1234','hyeon12864@naver.com','버드 대학교','새둥지 건축','6253c623-8c4a-438a-a643-08b5c9973c95.jpeg','/profile/','Z://LMSProject/profile/6253c623-8c4a-438a-a643-08b5c9973c95.jpeg','2025-12-11 05:11:14',NULL,'R',NULL),('happyjob_620449','I',NULL,'o^!oJH$YT*','Y',NULL,NULL,NULL,NULL,NULL,'observerlife@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-03-18 16:06:08',NULL,'W',NULL),('happyjob_644466','I','김바덕','123','N','08389','서울 구로구 디지털로26길 61','203호','199412011','010-4949-2424','kr123123003@gmail.com','국립 오리대학교 학사','바나나 빨리먹기 대회 입상','happyjob_644466_e5e41b60-d3b6-4ce6-952b-1cc77863b8ba.png','/profile/','/Volumes/sharefolder/LMSProject/profile/','2026-02-11 17:13:44',NULL,'R',NULL),('happyjob_666663','I',NULL,'RUbq3fJ#aD','Y',NULL,NULL,NULL,NULL,NULL,'kr123123003@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-12 11:15:31',NULL,'W',NULL),('happyjob_710254','I','이성우','123','N','78945','부산시 중구','9층','199011291','010-3333-4444','in03@test.com','전남대학교 전자공학과 졸업','데이터 분석 2년 강의\nSQL·데이터 모델링 지도 경험','happyjob_710254.jpg','/profile/','Z://LMSProject/profile/happyjob_710254.jpg','2025-12-10 02:44:30',NULL,'R',NULL),('happyjob_755168','I',NULL,'IjgTf3YHVW','Y',NULL,NULL,NULL,NULL,NULL,'a50312900@gmail.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 05:55:11',NULL,'R',NULL),('happyjob_759172','I','qqq','123','N','','','','199902131',NULL,'hyeon12864@naver.com','','',NULL,NULL,NULL,'2026-02-06 04:56:34','2026-02-20 05:16:15','Q',NULL),('happyjob_846480','I','ㅂㅂ','123','N','','','','199902131','010-1234-1234','hyeon12864@naver.com','','',NULL,NULL,NULL,'2025-12-10 07:34:18',NULL,'R',NULL),('happyjob_935821','I','박지연','123','N','45678','경기도 성남시','502호','198708102','010-2222-3333','test@testtesttest.com','명지대학교 컴퓨터공학과 졸업','프론트엔드 5년 강의 경험\n프로젝트 리딩 경험','happyjob_935821.jpg','/profile/','Z://LMSProject/profile/happyjob_935821.jpg','2025-12-10 06:23:12',NULL,'R',NULL),('happyjob_964842','I','박병준','123','N','13480','경기 성남시 분당구 대왕판교로 477','123','111111111','010-1234-5678','hyeon12864@naver.com','','',NULL,NULL,NULL,'2026-02-06 05:12:40',NULL,'R',NULL),('happyjob_978966','I','김길호','qwe123!!','N','','','','199709161','010-6879-4564','rlcks7812@naver.com','','',NULL,NULL,NULL,'2026-04-27 12:08:52',NULL,'R',NULL),('hello','S','qqqqqqq','123','N','','','','199902131',NULL,'hello@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-04 14:52:22',NULL,'R',NULL),('joooo','S','강순대','1234','N','','','','191111111','','asdb@dd.com',NULL,NULL,NULL,NULL,NULL,'2026-02-10 06:34:56',NULL,'R',NULL),('mintleaf','S','이수정','123','N','23456','서울시 송파구','202호','199907152','010-3333-1111','mintleaf@test.com',NULL,NULL,'mintleaf.jpg','/profile/','Z://LMSProject/profile/mintleaf.jpg','2025-12-15 06:15:21',NULL,'R',NULL),('ohhappy','S','오민재','123','N','13480','경기 성남시 분당구 대왕판교로 477','101','199909091','010-7777-1111','ohhappy@test.com',NULL,NULL,'ohhappy_ba7a0483-e106-42c0-9b48-5307cf829be4.webp','/profile/','file:////192.168.0.130/sharefolder/LMSProject/profile/','2025-12-04 05:18:25',NULL,'R',NULL),('qqq1','S','qqa','123','N','34672','대전 동구 판교1길 3 (판암동)','sssszzzz','199902111','010-1234-1234','testtest2222@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-02-06 07:18:37',NULL,'R',NULL),('qqqq','S','q','123','N','','','','200002132',NULL,'hello3@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-09 01:24:42',NULL,'R',NULL),('qwe','S','qqq','123','N','','','','199902131',NULL,'qqq@naver.com',NULL,NULL,NULL,NULL,NULL,'2026-01-08 01:12:13',NULL,'R',NULL),('qwe123','S','박병준','123','N','13480','경기 성남시 분당구 대왕판교로 477','102','200010101','010-1234-5678','qwe123@gmail.com',NULL,NULL,'qwe123_ab92a17f-7323-418c-8a53-11666394eba2.jpg','/profile/','C:/jquery_img/profile/','2026-03-25 06:00:23',NULL,'D',NULL),('rabbit99','S','정해린','123','Y','98765','부산시 해운대구','12동','200103202','010-5555-1111','rabbit99@test.com',NULL,NULL,'rabbit99.jpg','/profile/','Z://LMSProject/profile/rabbit99.jpg','2026-02-06 00:17:47',NULL,'R',NULL),('stuTest','S','테스트학생','123','N','08389','서울 구로구 디지털로26길 5','','199606061',NULL,'cap019@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-09 04:33:25',NULL,'D',NULL),('sunnyday','S','박찬영','123','N','67890','서울시 마포구','301호','199812222','010-4444-1111','sunnyday@test.com',NULL,NULL,'sunnyday.png','/profile/','Z://LMSProject/profile/sunnyday.png','2025-12-04 05:18:33',NULL,'D',NULL),('test','S','test','NhfaFrlO9C','Y','','','','198502131',NULL,'test@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-05 05:53:11',NULL,'R',NULL),('test1','S','권태정','1234','N','08391','서울 구로구 도림천로 477 (구로동)','','199202011','010-3261-4322','gongyou202506@gmail.com',NULL,NULL,NULL,NULL,NULL,'2026-01-07 11:05:26',NULL,'R',NULL),('test111','S','나는테스트','dqlm8zsP%L','Y','08327','서울 구로구 가마산로 77 (구로동)','구로구로11호','199902131','010-1234-1234','hyeon12864@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-15 07:19:06',NULL,'R',NULL),('test2','S','qqq','123','N','','','','199902131','','j90729444@gmail.com',NULL,NULL,NULL,NULL,NULL,'2025-12-05 15:14:40',NULL,'R',NULL),('test22','S','qqqq','123','N','13590','경기 성남시 분당구 성남분당우체국사서함 1 ~ 200','212','199902131','010-1111-1111','hello10@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-11 09:19:28',NULL,'R',NULL),('test3','S','test계정','123','N','','','','199510301','','testabc@naver.com',NULL,NULL,'test3_57c0faa1-13ac-48ae-9b4e-705e27285707.jpg','/profile/','C:/jquery_img/profile/','2026-04-23 07:27:24',NULL,'R',NULL),('test55','S','qq','123','N','','','','196602131',NULL,'test2@naver.com',NULL,NULL,NULL,NULL,NULL,'2025-12-10 07:13:50','2025-12-10 07:13:50','Q',NULL),('testA','S','홍길동','123','N','34672','대전 동구 판교1길 3 (판암동)','북극 남극','199902151','010-1234-1234','sungcheol9920@gmail.com','','','testA_b8ce6b14-d24a-49a7-8ccf-0ed2ba581e20.avif','/profile/','//192.168.0.130/sharefolder/LMSProject/profile/','2026-04-20 00:13:32',NULL,'R',NULL),('testB','S','pak','123','N','08389','서울 구로구 디지털로26길 43','203호','200002201','010-1234-1234','sungcheol92220@gmail.com',NULL,NULL,NULL,NULL,NULL,'2026-04-28 01:24:00',NULL,'R',NULL),('testtesttest','S','test','123','N','13480','경기 성남시 분당구 대왕판교로 477','123','123412341','010-3518-6526','test@',NULL,NULL,NULL,NULL,NULL,'2026-03-19 03:03:03',NULL,'R',NULL),('testUsertestUser','S','테스트유저','123','N','13480','경기 성남시 분당구 대왕판교로 477','123123','200001011','010-2345-6789','test@test.testtest',NULL,NULL,NULL,NULL,NULL,'2026-03-18 08:22:05',NULL,'R',NULL);
/*!40000 ALTER TABLE `tb_userinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_detail`
--

DROP TABLE IF EXISTS `test_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_detail` (
  `question_no` int(11) NOT NULL COMMENT '문제번호',
  `period` int(11) NOT NULL COMMENT '차시',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `content` text NOT NULL COMMENT '지문',
  `option1` varchar(255) NOT NULL COMMENT '보기1',
  `option2` varchar(255) NOT NULL COMMENT '보기2',
  `option3` varchar(255) NOT NULL COMMENT '보기3',
  `option4` varchar(255) NOT NULL COMMENT '보기4',
  `answer` int(11) NOT NULL COMMENT '답안',
  `score` int(11) NOT NULL COMMENT '배점',
  `comment` text COMMENT '해설',
  PRIMARY KEY (`question_no`,`period`,`course_id`),
  KEY `FK_test_schedule_TO_test_detail` (`period`,`course_id`),
  CONSTRAINT `FK_test_schedule_TO_test_detail` FOREIGN KEY (`period`, `course_id`) REFERENCES `test_schedule` (`period`, `course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='강의별 시험문제';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_detail`
--

LOCK TABLES `test_detail` WRITE;
/*!40000 ALTER TABLE `test_detail` DISABLE KEYS */;
INSERT INTO `test_detail` VALUES (1,1,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,2,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,2,107,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,3,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,3,107,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,4,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,4,107,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,5,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,5,107,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,6,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,6,107,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(1,7,1,'React에서 상태를 관리하는 훅은?','useEffect','useState','useRef','useContext',2,10,'useState는 컴포넌트 상태를 관리합니다.'),(2,1,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,2,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,2,107,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,3,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,3,107,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,4,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,4,107,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,5,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,5,107,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,6,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,6,107,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(2,7,1,'Virtual DOM의 주요 장점은?','메모리 절약','보안 강화','렌더링 성능 최적화','서버 부하 감소',3,10,'Virtual DOM은 실제 DOM 조작을 최소화합니다.'),(3,1,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,2,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,2,107,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,3,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,3,107,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,4,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,4,107,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,5,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,5,107,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,6,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,6,107,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(3,7,1,'JSX란 무엇인가?','JavaScript 라이브러리','CSS 전처리기','JavaScript XML 문법 확장','HTTP 통신 방식',3,10,'JSX는 JavaScript에서 XML 형태의 문법을 사용할 수 있게 합니다.'),(4,1,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,2,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,2,107,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,3,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,3,107,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,4,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,4,107,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,5,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,5,107,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,6,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,6,107,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(4,7,1,'React 컴포넌트 간 데이터 전달 방식은?','state','props','context','ref',2,10,'부모에서 자식으로 props를 통해 데이터를 전달합니다.'),(5,1,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,2,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,2,107,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,3,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,3,107,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,4,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,4,107,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,5,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,5,107,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,6,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,6,107,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(5,7,1,'useEffect의 의존성 배열이 빈 배열일 때 실행 시점은?','매 렌더링마다','마운트 시 1회','언마운트 시','상태 변경 시마다',2,10,'빈 배열이면 컴포넌트 마운트 시 한 번만 실행됩니다.'),(6,1,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,2,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,2,107,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,3,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,3,107,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,4,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,4,107,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,5,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,5,107,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,6,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,6,107,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(6,7,1,'React에서 key prop이 필요한 이유는?','스타일 적용','리스트 항목 고유 식별','이벤트 처리','상태 초기화',2,10,'key는 React가 리스트 항목의 변경을 효율적으로 감지하기 위해 사용됩니다.'),(7,1,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,2,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,2,107,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,3,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,3,107,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,4,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,4,107,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,5,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,5,107,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,6,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,6,107,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(7,7,1,'함수형 컴포넌트에서 ref를 사용하는 훅은?','useState','useEffect','useRef','useMemo',3,10,'useRef는 DOM 참조나 렌더링 없이 값을 유지할 때 사용합니다.'),(8,1,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,2,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,2,107,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,3,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,3,107,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,4,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,4,107,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,5,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,5,107,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,6,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,6,107,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(8,7,1,'React에서 Context API의 주요 용도는?','서버 통신','전역 상태 공유','라우팅 처리','스타일 관리',2,10,'Context API는 컴포넌트 트리 전체에 데이터를 공유할 때 사용합니다.'),(9,1,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,2,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,2,107,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,3,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,3,107,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,4,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,4,107,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,5,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,5,107,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,6,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,6,107,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(9,7,1,'useMemo 훅의 목적은?','사이드 이펙트 처리','DOM 접근','값 메모이제이션으로 성능 최적화','상태 관리',3,10,'useMemo는 의존성이 바뀌지 않으면 이전 계산 결과를 재사용합니다.'),(10,1,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,2,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,2,107,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,3,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,3,107,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,4,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,4,107,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,5,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,5,107,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,6,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,6,107,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.'),(10,7,1,'React에서 조건부 렌더링에 주로 사용하는 연산자는?','||','&&','??','!',2,10,'&& 연산자로 조건이 true일 때만 컴포넌트를 렌더링할 수 있습니다.');
/*!40000 ALTER TABLE `test_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_schedule`
--

DROP TABLE IF EXISTS `test_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_schedule` (
  `period` int(11) NOT NULL COMMENT '차시',
  `course_id` bigint(20) NOT NULL COMMENT '강의ID',
  `date` datetime DEFAULT NULL COMMENT '시험날짜',
  `status` int(11) NOT NULL COMMENT '시험상태',
  `title` varchar(255) NOT NULL,
  `class_id` int(11) DEFAULT NULL COMMENT '시험 배정 강의실 (NULL이면 강의의 강의실 사용)',
  `start_date` date DEFAULT NULL COMMENT '응시 시작일',
  `end_date` date DEFAULT NULL COMMENT '응시 종료일',
  PRIMARY KEY (`period`,`course_id`),
  KEY `FK_course_TO_test_schedule` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='시험 일정';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_schedule`
--

LOCK TABLES `test_schedule` WRITE;
/*!40000 ALTER TABLE `test_schedule` DISABLE KEYS */;
INSERT INTO `test_schedule` VALUES (1,1,'2026-04-24 17:04:58',1,'JAVA 기초 1차 시험',NULL,'2026-03-01','2026-03-06'),(2,1,'2026-04-24 17:07:27',1,'JAVA 기초 2차 시험',NULL,'2026-04-09','2026-06-26'),(2,107,'2026-04-24 17:07:51',1,'React 기초 2차 시험',NULL,'2026-07-16','2026-10-16'),(3,1,'2026-04-24 17:42:07',1,'JAVA 기초 3차 시험',NULL,'2026-04-16','2026-04-30'),(3,107,'2026-04-27 08:32:20',1,'React 기초 3차 시험',NULL,'2026-04-06','2026-06-26'),(4,1,'2026-04-27 08:48:19',1,'JAVA 기초 4차 시험',NULL,'2026-04-27','2026-08-27'),(4,107,'2026-04-27 08:47:34',1,'React 기초 4차 시험',NULL,'2026-04-27','2026-08-21'),(5,1,'2026-04-27 08:48:44',1,'JAVA 기초 5차 시험',NULL,'2026-06-04','2026-08-28'),(5,107,'2026-04-27 08:47:56',1,'React 기초 5차 시험',NULL,'2026-04-27','2026-08-27'),(6,1,'2026-04-27 08:49:12',1,'JAVA 기초 6차 시험',NULL,'2026-06-25','2026-09-24'),(6,107,'2026-04-27 08:49:48',1,'React 기초 6차 시험',NULL,'2026-04-27','2026-08-01'),(7,1,'2026-04-27 08:50:14',1,'JAVA 기초 7차 시험',NULL,'2026-04-06','2026-10-01');
/*!40000 ALTER TABLE `test_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tm_mnu_mst`
--

DROP TABLE IF EXISTS `tm_mnu_mst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tm_mnu_mst` (
  `MNU_ID` varchar(5) NOT NULL COMMENT '메뉴ID',
  `HIR_MNU_ID` varchar(5) DEFAULT NULL COMMENT '상위메뉴ID',
  `MNU_NM` varchar(100) DEFAULT NULL COMMENT '메뉴명',
  `MNU_URL` varchar(500) DEFAULT NULL COMMENT '메뉴URL',
  `MNU_DVS_COD` varchar(1) DEFAULT NULL COMMENT '메뉴구분코드',
  `GRP_NUM` int(11) DEFAULT NULL COMMENT '그룹번호',
  `ODR` int(11) DEFAULT NULL COMMENT '순서',
  `LVL` smallint(6) DEFAULT NULL COMMENT '라벨',
  `MNU_ICO_COD` varchar(7) DEFAULT NULL COMMENT '메뉴아이콘코드',
  `USE_POA` varchar(1) DEFAULT NULL COMMENT '사용유무',
  `DLT_POA` varchar(1) DEFAULT NULL COMMENT '삭제유무',
  PRIMARY KEY (`MNU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴마스터';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tm_mnu_mst`
--

LOCK TABLES `tm_mnu_mst` WRITE;
/*!40000 ALTER TABLE `tm_mnu_mst` DISABLE KEYS */;
INSERT INTO `tm_mnu_mst` VALUES ('A1001','A1001','수강 관리',NULL,'A',1001,0,0,'menu000','Y','N'),('A1002','A1001','전체 강의 목록','/stu/courses','A',1001,1,1,'menu000','Y','N'),('A1003','A1001','나의 강의','/stu/my-courses','A',1001,2,1,'menu000','Y','N'),('B1001','B1001','학습 관리',NULL,'A',1002,0,0,'menu000','Y','N'),('B1002','B1001','학습 자료','/stu/materials','A',1002,1,1,'menu000','Y','N'),('B1003','B1001','과제 목록','/stu/assignments','A',1002,2,1,'menu000','Y','N'),('B1004','B1001','과제 결과','/stu/assignments-result','A',1002,3,1,'menu000','Y','N'),('B1005','B1001','시험 목록','/stu/exams','A',1002,4,1,'menu000','Y','N'),('C1001','C1001','커뮤니티',NULL,'A',1003,0,0,'menu000','Y','N'),('C1002','C1001','Q&A','/stu/qna','A',1003,1,1,'menu000','Y','N'),('C1003','C1001','설문 조사','/survey/survey.do','A',1003,2,1,'menu000','Y','N'),('C1004','C1001','공지 사항','/stu/notices','A',1003,3,1,'menu000','Y','N'),('D1001','D1001','마이페이지',NULL,'A',1004,0,0,'menu000','Y','N'),('D1002','D1001','마이페이지','/stu/my-page','A',1004,1,1,'menu000','Y','N'),('J1001','J1001','나의 강의 관리',NULL,'A',1005,0,0,'menu000','Y','N'),('J1002','J1001','강의 목록','/inst/course-list','A',1006,2,1,'menu000','Y','N'),('J1003','J1001','출석 관리','/inst/attendance','A',1005,3,1,'menu000','Y','N'),('J1004','J1001','강의 계획서','/inst/course-plan','A',1005,1,1,'menu000','Y','N'),('J1005','J1001','학습 자료','/inst/materials','A',1005,4,1,'menu000','Y','N'),('J1006','J1001','시험 목록','/inst/exams','A',1005,5,1,'menu000','Y','N'),('J1007','J1001','시험 등록','/inst/exam-register','A',1005,6,1,'menu000','Y','N'),('J1008','J1001','과제 목록','/inst/assignments','A',1005,7,1,'menu000','Y','N'),('J1009','J1001','제출된 과제 목록','/inst/submissions','A',1005,8,1,'menu000','Y','N'),('K1001','K1001','커뮤니티',NULL,'A',1006,0,0,'menu000','Y','N'),('K1002','K1001','Q&A','/inst/qna','A',1006,1,1,'menu000','Y','N'),('K1003','K1001','설문 조사','/survey/survey.do','A',1006,2,1,'menu000','Y','N'),('K1004','K1001','공지 사항','/inst/notices','A',1006,3,1,'menu000','Y','N'),('L1001','L1001','마이페이지',NULL,'A',1007,0,0,'menu000','Y','N'),('L1002','L1001','마이페이지','/inst/my-page','A',1007,1,1,'menu000','Y','N'),('T1001','T1001','대시보드',NULL,'A',1008,0,0,'menu000','Y','N'),('T1002','T1001','대시보드','/admin/dashboard','A',1008,1,1,'menu000','Y','N'),('U1001','U1001','시험 관리',NULL,'A',1009,0,0,'menu000','Y','N'),('U1002','U1001','시험 일정','/admin/exam/schedule','A',1009,1,1,'menu000','Y','N'),('U1003','U1001','시험 문제','/admin/test-exam','A',1009,2,1,'menu000','Y','N'),('V1001','V1001','강의 운영',NULL,'A',1010,0,0,'menu000','Y','N'),('V1002','V1001','강의 목록','/admin/courseManagement','A',1010,1,1,'menu000','Y','N'),('V1003','V1001','강의실 목록','/admin/classrooms','A',1010,2,1,'menu000','Y','N'),('X1001','X1001','사용자 관리',NULL,'A',1011,0,0,'menu000','Y','N'),('X1002','X1001','학생 목록','/admin/stu','A',1011,1,1,'menu000','Y','N'),('X1003','X1001','강사 목록','/admin/inst','A',1011,2,1,'menu000','Y','N'),('Y1001','Y1001','커뮤니티 관리',NULL,'A',1012,0,0,'menu000','Y','N'),('Y1002','Y1001','Q&A','/admin/qna','A',1012,1,1,'menu000','Y','N'),('Y1003','Y1001','설문 조사','/survey/survey.do','A',1012,2,1,'menu000','Y','N'),('Y1004','Y1001','공지 사항','/admin/notices','A',1012,3,1,'menu000','Y','N'),('Y1005','Y1001','설문 조사(관리자)','/survey/surveyA.do','A',1012,4,1,'menu000','Y','N');
/*!40000 ALTER TABLE `tm_mnu_mst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tn_usr_mnu_atrt`
--

DROP TABLE IF EXISTS `tn_usr_mnu_atrt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tn_usr_mnu_atrt` (
  `user_type` varchar(1) NOT NULL COMMENT '사용자타입',
  `MNU_ID` varchar(5) NOT NULL COMMENT '메뉴ID',
  PRIMARY KEY (`user_type`,`MNU_ID`),
  KEY `FK_tm_mnu_mst_TO_tn_usr_mnu_atrt` (`MNU_ID`),
  CONSTRAINT `FK_tm_mnu_mst_TO_tn_usr_mnu_atrt` FOREIGN KEY (`MNU_ID`) REFERENCES `tm_mnu_mst` (`MNU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 권한';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tn_usr_mnu_atrt`
--

LOCK TABLES `tn_usr_mnu_atrt` WRITE;
/*!40000 ALTER TABLE `tn_usr_mnu_atrt` DISABLE KEYS */;
INSERT INTO `tn_usr_mnu_atrt` VALUES ('S','A1001'),('S','A1002'),('S','A1003'),('S','B1001'),('S','B1002'),('S','B1003'),('S','B1004'),('S','B1005'),('S','C1001'),('S','C1002'),('S','C1003'),('S','C1004'),('S','D1001'),('S','D1002'),('I','J1001'),('I','J1002'),('I','J1003'),('I','J1004'),('I','J1005'),('I','J1006'),('I','J1007'),('I','J1008'),('I','J1009'),('I','K1001'),('I','K1002'),('I','K1003'),('I','K1004'),('I','L1001'),('I','L1002'),('A','T1001'),('A','T1002'),('A','U1001'),('A','U1002'),('A','U1003'),('A','V1001'),('A','V1002'),('A','V1003'),('A','X1001'),('A','X1002'),('A','X1003'),('A','Y1001'),('A','Y1002'),('A','Y1003'),('A','Y1004');
/*!40000 ALTER TABLE `tn_usr_mnu_atrt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'vuelmsone'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-28 15:11:49
