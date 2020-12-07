-- MySQL dump 10.16  Distrib 10.2.31-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: Auth
-- ------------------------------------------------------
-- Server version	10.2.31-MariaDB-1:10.2.31+maria~bionic

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
-- Current Database: `Auth`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `Auth` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `Auth`;

--
-- Table structure for table `EnumClearanceLevel`
--

DROP TABLE IF EXISTS `EnumClearanceLevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EnumClearanceLevel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clearance` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EnumClearanceLevel`
--

LOCK TABLES `EnumClearanceLevel` WRITE;
/*!40000 ALTER TABLE `EnumClearanceLevel` DISABLE KEYS */;
INSERT INTO `EnumClearanceLevel` VALUES (1,'Admin'),(2,'User');
/*!40000 ALTER TABLE `EnumClearanceLevel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GUID` varchar(36) NOT NULL,
  `userName` varchar(256) NOT NULL,
  `emailId` varchar(256) NOT NULL,
  `password` longtext NOT NULL,
  `firstName` varchar(256) DEFAULT NULL,
  `lastName` varchar(256) DEFAULT NULL,
  `createdOn` datetime NOT NULL,
  `clearanceLevel` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userName_UNIQUE` (`userName`),
  KEY `FK_User_ClearanceLevel_EnumClearanceLevel_idx` (`clearanceLevel`),
  CONSTRAINT `FK_User_ClearanceLevel_EnumClearanceLevel` FOREIGN KEY (`clearanceLevel`) REFERENCES `EnumClearanceLevel` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (20,'bb529386-37ca-11eb-81e7-0242ac130003','admin','admin@gmail.com','$2b$12$Q0qjlTJ6gSFWspsBV.aWmOP6MySMRLnLaGMR/abgSWgNq2kqEuJze','Admin','1','2020-12-06 13:55:43',1),(21,'81c3eaf6-37cb-11eb-81e7-0242ac130003','john','John@gmail.com','$2b$12$wkJq3kZUhMm3otvVOSxllOiDa1SqSiRRuf3NmLAETxJk4xgmZxYs2','John','Doe','2020-12-06 14:01:15',2),(22,'31914ed2-37df-11eb-81e7-0242ac130003','catherine','Catherine@gmail.com','$2b$12$ySLCtKjBaDpc58Y51QIzAOZG07efcNZVP7Egwo/xuSmqK3u4vY.YK','Catherine','1','2020-12-07 02:33:57',2),(23,'48147e2c-37df-11eb-81e7-0242ac130003','betsy','Betsy@gmail.com','$2b$12$ovoY2tNvDb4x.lLXUhPRe.8CY6mCL4IXyMSXRFZ9gq7R4Jslg/iHq','Betsy','1','2020-12-07 02:34:35',2);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'Auth'
--
/*!50003 DROP PROCEDURE IF EXISTS `CreateUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `CreateUser`(
	inUserName varchar(256),
    inEmailId varchar(256),
    inPassword varchar(256),
    inFirstName varchar(256),
    inLastName varchar(256),
    inClearanceLevel int
)
BEGIN
	Insert into `User` (
		GUID,
        userName,
        emailId,
        `password`,
        firstName,
        lastName,
        clearanceLevel,
        createdOn)
    Select
		uuid(),
        inUserName,
        inEmailId,
        inPassword,
        inFirstName,
        inLastName,
        inClearanceLevel,
        utc_timestamp();
	
    Select
		id as userId,
		GUID as userGUID,
        userName,
        emailId,
        `password`,
        firstName,
        lastName,
        clearanceLevel
    from `User`
    where id = last_insert_id();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetUserDetails`(
	inEmailId varchar(256)
)
BEGIN
	Select 
    id as userId,
	userName,
    `password`,
    clearanceLevel
    from `User`
    where emailId = inEmailId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `BookLibrary`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `BookLibrary` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `BookLibrary`;

--
-- Table structure for table `Book`
--

DROP TABLE IF EXISTS `Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GUID` varchar(36) NOT NULL,
  `name` varchar(256) NOT NULL,
  `authorName` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `GUID_UNIQUE` (`GUID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book`
--

LOCK TABLES `Book` WRITE;
/*!40000 ALTER TABLE `Book` DISABLE KEYS */;
INSERT INTO `Book` VALUES (1,'93189fb4-3523-11eb-a08a-0242ac130003','Mein Kampf','Adolf Hitler'),(2,'9318a8f0-3523-11eb-a08a-0242ac130003','Play It as It Lays','Joan Didion'),(3,'250d4d5c-35eb-11eb-b6ef-0242ac130003','Book 1','IDK'),(4,'0f19aa19-35ec-11eb-b6ef-0242ac130003','book 2','author 2');
/*!40000 ALTER TABLE `Book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BookReview`
--

DROP TABLE IF EXISTS `BookReview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BookReview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GUID` varchar(36) NOT NULL,
  `bookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `review` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_BookId_Book_idx` (`bookId`),
  KEY `FK_BookReview_UserId_User_idx` (`userId`),
  CONSTRAINT `FK_BookReview_BookId_Book` FOREIGN KEY (`bookId`) REFERENCES `Book` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_BookReview_UserId_User` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BookReview`
--

LOCK TABLES `BookReview` WRITE;
/*!40000 ALTER TABLE `BookReview` DISABLE KEYS */;
INSERT INTO `BookReview` VALUES (3,'1a6070d9-37ce-11eb-81e7-0242ac130003',1,21,'Mast!!'),(4,'235a8745-37e1-11eb-81e7-0242ac130003',1,23,'Ok');
/*!40000 ALTER TABLE `BookReview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Favorites`
--

DROP TABLE IF EXISTS `Favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GUID` varchar(36) NOT NULL,
  `bookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_Favorites_BookId_Book_idx` (`bookId`),
  KEY `FK_Favorites_UserId_User_idx` (`userId`),
  CONSTRAINT `FK_Favorites_BookId_Book` FOREIGN KEY (`bookId`) REFERENCES `Book` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_Favorites_UserId_User` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorites`
--

LOCK TABLES `Favorites` WRITE;
/*!40000 ALTER TABLE `Favorites` DISABLE KEYS */;
INSERT INTO `Favorites` VALUES (2,'6b5394f7-37cd-11eb-81e7-0242ac130003',1,21);
/*!40000 ALTER TABLE `Favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReadHistory`
--

DROP TABLE IF EXISTS `ReadHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReadHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GUID` varchar(36) NOT NULL,
  `bookId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `markedOn` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ReadHistory_BookId_Book_idx` (`bookId`),
  KEY `FK_ReadHistory_UserId_User_idx` (`userId`),
  CONSTRAINT `FK_ReadHistory_BookId_Book` FOREIGN KEY (`bookId`) REFERENCES `Book` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ReadHistory_UserId_User` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReadHistory`
--

LOCK TABLES `ReadHistory` WRITE;
/*!40000 ALTER TABLE `ReadHistory` DISABLE KEYS */;
INSERT INTO `ReadHistory` VALUES (1,'bb64db6c-37cd-11eb-81e7-0242ac130003',1,21,'2020-12-06 14:17:11');
/*!40000 ALTER TABLE `ReadHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `GUID` varchar(36) NOT NULL,
  `userName` varchar(256) NOT NULL,
  `emailId` varchar(256) NOT NULL,
  `password` longtext NOT NULL,
  `firstName` varchar(256) DEFAULT NULL,
  `lastName` varchar(256) DEFAULT NULL,
  `clearanceLevel` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `GUID_UNIQUE` (`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (20,'bb529386-37ca-11eb-81e7-0242ac130003','admin','admin@gmail.com','$2b$12$Q0qjlTJ6gSFWspsBV.aWmOP6MySMRLnLaGMR/abgSWgNq2kqEuJze','Admin','1',1),(21,'81c3eaf6-37cb-11eb-81e7-0242ac130003','john','John@gmail.com','$2b$12$wkJq3kZUhMm3otvVOSxllOiDa1SqSiRRuf3NmLAETxJk4xgmZxYs2','John','Doe',2),(22,'31914ed2-37df-11eb-81e7-0242ac130003','catherine','Catherine@gmail.com','$2b$12$ySLCtKjBaDpc58Y51QIzAOZG07efcNZVP7Egwo/xuSmqK3u4vY.YK','Catherine','1',2),(23,'48147e2c-37df-11eb-81e7-0242ac130003','betsy','Betsy@gmail.com','$2b$12$ovoY2tNvDb4x.lLXUhPRe.8CY6mCL4IXyMSXRFZ9gq7R4Jslg/iHq','Betsy','1',2);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'BookLibrary'
--
/*!50003 DROP PROCEDURE IF EXISTS `CreateBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `CreateBook`(
    inBookName varchar(256),
    inAuthorName varchar(256))
BEGIN
	Insert into Book (GUID, name, authorName)
    Select uuid(), inBookName, inAuthorName;
    
    Select bookGUID
    from Book
    where id = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateBookReview` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `CreateBookReview`(
	inBookGUID varchar(36),
    inReview varchar(4096),
    inUserId int
)
BEGIN
	declare _bookId int default 0;
    declare _reviewGUID varchar(36) default uuid();

	Select id into _bookId
    from Book
    where GUID = inBookGUID;
    
    if _bookId = 0 then
		signal sqlstate '01001' set message_text = "Book not found";
	else
		Insert into BookReview (GUID, bookId, userId, review)
		Select _reviewGUID, _bookId, inUserId, inReview;
        
        Select _reviewGUID;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `CreateUser`(
	inUserId int,
    inUserGUID varchar(36),
	inUserName varchar(256),
    inEmailId varchar(256),
    inPassword varchar(256),
    inFirstName varchar(256),
    inLastName varchar(256),
    inClearanceLevel int
)
BEGIN
	Insert into `User` (
		id,
		GUID,
        userName,
        emailId,
        `password`,
        firstName,
        lastName,
        clearanceLevel)
    Select
		inUserId,
		inUserGUID,
        inUserName,
        inEmailId,
        inPassword,
        inFirstName,
        inLastName,
        inClearanceLevel;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `DeleteBook`(
	inBookGUID varchar(36)
)
BEGIN
	Delete from Book
    where GUID = inBookGUID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllBooks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetAllBooks`()
BEGIN
	Select GUID, name, authorName
    from Book;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetBookReviews` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetBookReviews`(
	inBookGUID varchar(36)
)
BEGIN
	Select
		C.GUID as bookGUID,
		C.name as bookName,
        A.review,
        B.userName
    from BookReview A
    inner join `User` B
		on A.userId = B.id
	inner join Book C
		on A.bookId = C.id
	where C.GUID = inBookGUID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MarkAsFavorite` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `MarkAsFavorite`(
	inUserId int,
    inBookGUID varchar(36)
)
BEGIN
    declare _bookId int default 0;

	Select id into _bookId
    from Book
    where GUID = inBookGUID;
    
    if _bookId = 0 then
		signal sqlstate '01001' set message_text = "Book not found";
	else
		Insert into Favorites (GUID, bookId, userId)
		Select uuid(), _bookId, inUserId;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MarkAsRead` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `MarkAsRead`(
	inUserId int,
    inBookGUID varchar(36)
)
BEGIN
	declare _bookId int default 0;

	Select id into _bookId
    from Book
    where GUID = inBookGUID;
    
    if _bookId = 0 then
		signal sqlstate '01001' set message_text = "Book not found";
	else
		Insert into ReadHistory (GUID, bookId, userId, markedOn)
		Select uuid(), _bookId, inUserId, utc_timestamp();
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateBook`(
	inBookGUID varchar(36),
    inBookName varchar(256),
    inAuthorName varchar(256)
)
BEGIN
	Update Book
    set name = inBookName,
    authorName = inAuthorName
    where GUID = inBookGUID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-07  3:55:46
