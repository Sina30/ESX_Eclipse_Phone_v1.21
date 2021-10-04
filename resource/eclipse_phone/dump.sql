-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               10.4.17-MariaDB - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Дамп структуры базы данных plumeesx_86bbe6
CREATE DATABASE IF NOT EXISTS `plumeesx_86bbe6` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `plumeesx_86bbe6`;

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_8dynasty
CREATE TABLE IF NOT EXISTS `eclipse_phone_8dynasty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `text` varchar(50) DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `image` varchar(50) DEFAULT NULL,
  `playerPhone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_ambulance_calls
CREATE TABLE IF NOT EXISTS `eclipse_phone_ambulance_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerName` varchar(50) DEFAULT NULL,
  `PlayerPhone` varchar(50) DEFAULT NULL,
  `Message` varchar(50) DEFAULT NULL,
  `Date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_anon_chat
CREATE TABLE IF NOT EXISTS `eclipse_phone_anon_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(50) DEFAULT NULL,
  `text` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_bleeter
CREATE TABLE IF NOT EXISTS `eclipse_phone_bleeter` (
  `messageId` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(500) NOT NULL DEFAULT '0',
  `author` varchar(500) DEFAULT NULL,
  `authorImage` varchar(500) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `date` varchar(500) DEFAULT NULL,
  `authorPhone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`messageId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_bleeter_logins
CREATE TABLE IF NOT EXISTS `eclipse_phone_bleeter_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `playerPhone` varchar(50) DEFAULT NULL,
  `login` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_coded_chat
CREATE TABLE IF NOT EXISTS `eclipse_phone_coded_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(50) DEFAULT NULL,
  `to` varchar(50) DEFAULT NULL,
  `text` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_contacts
CREATE TABLE IF NOT EXISTS `eclipse_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `phoneNumber` varchar(50) DEFAULT NULL,
  `contacts` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_messages
CREATE TABLE IF NOT EXISTS `eclipse_phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` tinyint(4) DEFAULT NULL,
  `readed` tinyint(4) DEFAULT NULL,
  `numb` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `playerphone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_police_calls
CREATE TABLE IF NOT EXISTS `eclipse_phone_police_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerName` varchar(50) DEFAULT NULL,
  `PlayerPhone` varchar(50) DEFAULT NULL,
  `Message` varchar(50) DEFAULT NULL,
  `Date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

-- Дамп структуры для таблица plumeesx_86bbe6.eclipse_phone_weazel
CREATE TABLE IF NOT EXISTS `eclipse_phone_weazel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `subtitle` varchar(50) DEFAULT NULL,
  `material` varchar(50) DEFAULT NULL,
  `image` varchar(50) DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Экспортируемые данные не выделены.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
