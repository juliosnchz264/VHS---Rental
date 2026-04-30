/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 192.168.1.168    Database: videoclub
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `actor`
--

DROP TABLE IF EXISTS `actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `actor` (
  `id_actor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_actor`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actor`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `actor` WRITE;
/*!40000 ALTER TABLE `actor` DISABLE KEYS */;
INSERT INTO `actor` VALUES
(1,'Leonardo DiCaprio'),
(2,'Tom Hanks'),
(3,'Scarlett Johansson'),
(4,'Brad Pitt'),
(5,'Margot Robbie'),
(6,'Christian Bale'),
(7,'Penélope Cruz'),
(8,'Antonio Banderas'),
(9,'Timothée Chalamet'),
(10,'Zendaya'),
(11,'Robert De Niro'),
(12,'Uma Thurman'),
(13,'Samuel L. Jackson'),
(14,'Ryan Gosling'),
(15,'Emma Stone'),
(16,'Cillian Murphy'),
(17,'Florence Pugh'),
(18,'Josh Hartnett');
/*!40000 ALTER TABLE `actor` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `cinta`
--

DROP TABLE IF EXISTS `cinta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cinta` (
  `id_cinta` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `id_pelicula` int(11) NOT NULL,
  PRIMARY KEY (`id_cinta`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_pelicula` (`id_pelicula`),
  CONSTRAINT `cinta_ibfk_1` FOREIGN KEY (`id_pelicula`) REFERENCES `pelicula` (`id_pelicula`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `cinta` WRITE;
/*!40000 ALTER TABLE `cinta` DISABLE KEYS */;
INSERT INTO `cinta` VALUES
(1,'P0001-C001',1),
(2,'P0001-C002',1),
(3,'P0001-C003',1),
(4,'P0002-C001',2),
(5,'P0002-C002',2),
(6,'P0003-C001',3),
(7,'P0003-C002',3),
(8,'P0004-C001',4),
(9,'P0004-C002',4),
(10,'P0005-C001',5),
(11,'P0005-C002',5),
(12,'P0005-C003',5),
(13,'P0006-C001',6),
(14,'P0006-C002',6),
(15,'P0007-C001',7),
(16,'P0007-C002',7),
(17,'P0008-C001',8),
(18,'P0008-C002',8),
(19,'P0008-C003',8),
(20,'P0009-C001',9),
(21,'P0009-C002',9),
(22,'P0009-C003',9),
(23,'P0010-C001',10),
(24,'P0010-C002',10),
(25,'P0011-C001',11),
(26,'P0011-C002',11),
(27,'P0011-C003',11),
(28,'P0011-C004',11),
(29,'P0011-C005',11);
/*!40000 ALTER TABLE `cinta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `director`
--

DROP TABLE IF EXISTS `director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `director` (
  `id_director` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_director`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `director`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `director` WRITE;
/*!40000 ALTER TABLE `director` DISABLE KEYS */;
INSERT INTO `director` VALUES
(1,'Christopher Nolan'),
(2,'Steven Spielberg'),
(3,'Quentin Tarantino'),
(4,'Martin Scorsese'),
(5,'Hayao Miyazaki'),
(6,'Pedro Almodóvar'),
(7,'Denis Villeneuve'),
(8,'Greta Gerwig');
/*!40000 ALTER TABLE `director` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `genero`
--

DROP TABLE IF EXISTS `genero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `genero` (
  `id_genero` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` enum('Acción','Comedia','Drama','Terror','Ciencia Ficción','Romance','Aventura','Animación','Documental','Suspenso') NOT NULL,
  PRIMARY KEY (`id_genero`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genero`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `genero` WRITE;
/*!40000 ALTER TABLE `genero` DISABLE KEYS */;
INSERT INTO `genero` VALUES
(1,'Acción'),
(2,'Comedia'),
(3,'Drama'),
(4,'Terror'),
(5,'Ciencia Ficción'),
(6,'Romance'),
(7,'Aventura'),
(8,'Animación'),
(9,'Documental'),
(10,'Suspenso');
/*!40000 ALTER TABLE `genero` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `gustaActor`
--

DROP TABLE IF EXISTS `gustaActor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gustaActor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_socio` int(11) NOT NULL,
  `id_actor` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gustaActor` (`id_socio`,`id_actor`),
  KEY `id_actor` (`id_actor`),
  CONSTRAINT `gustaActor_ibfk_1` FOREIGN KEY (`id_socio`) REFERENCES `socio` (`id_socio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gustaActor_ibfk_2` FOREIGN KEY (`id_actor`) REFERENCES `actor` (`id_actor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gustaActor`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `gustaActor` WRITE;
/*!40000 ALTER TABLE `gustaActor` DISABLE KEYS */;
INSERT INTO `gustaActor` VALUES
(1,1,16),
(6,4,1),
(4,5,5),
(5,5,14),
(2,6,4),
(3,6,12);
/*!40000 ALTER TABLE `gustaActor` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `gustaDirector`
--

DROP TABLE IF EXISTS `gustaDirector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gustaDirector` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_socio` int(11) NOT NULL,
  `id_director` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gustaDirector` (`id_socio`,`id_director`),
  KEY `id_director` (`id_director`),
  CONSTRAINT `gustaDirector_ibfk_1` FOREIGN KEY (`id_socio`) REFERENCES `socio` (`id_socio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gustaDirector_ibfk_2` FOREIGN KEY (`id_director`) REFERENCES `director` (`id_director`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gustaDirector`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `gustaDirector` WRITE;
/*!40000 ALTER TABLE `gustaDirector` DISABLE KEYS */;
INSERT INTO `gustaDirector` VALUES
(3,5,8),
(1,6,3),
(2,6,5);
/*!40000 ALTER TABLE `gustaDirector` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `gustaGenero`
--

DROP TABLE IF EXISTS `gustaGenero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gustaGenero` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_socio` int(11) NOT NULL,
  `id_genero` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gustaGenero` (`id_socio`,`id_genero`),
  KEY `id_genero` (`id_genero`),
  CONSTRAINT `gustaGenero_ibfk_1` FOREIGN KEY (`id_socio`) REFERENCES `socio` (`id_socio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gustaGenero_ibfk_2` FOREIGN KEY (`id_genero`) REFERENCES `genero` (`id_genero`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gustaGenero`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `gustaGenero` WRITE;
/*!40000 ALTER TABLE `gustaGenero` DISABLE KEYS */;
INSERT INTO `gustaGenero` VALUES
(1,1,3),
(5,4,5),
(4,5,2),
(3,6,1),
(2,6,10);
/*!40000 ALTER TABLE `gustaGenero` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `pelicula`
--

DROP TABLE IF EXISTS `pelicula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelicula` (
  `id_pelicula` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(100) NOT NULL,
  `numCopia` int(11) DEFAULT 0,
  `copiasDisp` int(11) DEFAULT 0,
  `id_genero` int(11) DEFAULT NULL,
  `id_director` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_pelicula`),
  KEY `id_genero` (`id_genero`),
  KEY `id_director` (`id_director`),
  CONSTRAINT `pelicula_ibfk_1` FOREIGN KEY (`id_genero`) REFERENCES `genero` (`id_genero`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `pelicula_ibfk_2` FOREIGN KEY (`id_director`) REFERENCES `director` (`id_director`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pelicula`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `pelicula` WRITE;
/*!40000 ALTER TABLE `pelicula` DISABLE KEYS */;
INSERT INTO `pelicula` VALUES
(1,'Inception',3,3,5,1),
(2,'Interstellar',2,2,5,1),
(3,'Pulp Fiction',2,2,3,3),
(4,'Kill Bill',2,2,1,3),
(5,'Forrest Gump',3,3,3,2),
(6,'El viaje de Chihiro',2,2,8,5),
(7,'Volver',2,2,3,6),
(8,'Dune',3,3,5,7),
(9,'Barbie',3,3,2,8),
(10,'La La Land',2,2,6,8),
(11,'Oppenheimer',5,5,3,1);
/*!40000 ALTER TABLE `pelicula` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `rel_PrestActual`
--

DROP TABLE IF EXISTS `rel_PrestActual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rel_PrestActual` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechaPrestamo` date NOT NULL,
  `id_socio` int(11) NOT NULL,
  `id_cinta` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_cinta` (`id_cinta`),
  KEY `id_socio` (`id_socio`),
  CONSTRAINT `rel_PrestActual_ibfk_1` FOREIGN KEY (`id_socio`) REFERENCES `socio` (`id_socio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rel_PrestActual_ibfk_2` FOREIGN KEY (`id_cinta`) REFERENCES `cinta` (`id_cinta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rel_PrestActual`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `rel_PrestActual` WRITE;
/*!40000 ALTER TABLE `rel_PrestActual` DISABLE KEYS */;
/*!40000 ALTER TABLE `rel_PrestActual` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `rel_PrestDevuelto`
--

DROP TABLE IF EXISTS `rel_PrestDevuelto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rel_PrestDevuelto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechaDev` date NOT NULL,
  `id_socio` int(11) NOT NULL,
  `id_cinta` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_socio` (`id_socio`),
  KEY `id_cinta` (`id_cinta`),
  CONSTRAINT `rel_PrestDevuelto_ibfk_1` FOREIGN KEY (`id_socio`) REFERENCES `socio` (`id_socio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rel_PrestDevuelto_ibfk_2` FOREIGN KEY (`id_cinta`) REFERENCES `cinta` (`id_cinta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rel_PrestDevuelto`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `rel_PrestDevuelto` WRITE;
/*!40000 ALTER TABLE `rel_PrestDevuelto` DISABLE KEYS */;
INSERT INTO `rel_PrestDevuelto` VALUES
(1,'2026-04-27',1,25),
(2,'2026-04-28',6,13),
(3,'2026-04-30',5,20),
(4,'2026-04-30',4,1);
/*!40000 ALTER TABLE `rel_PrestDevuelto` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `rel_Reparto`
--

DROP TABLE IF EXISTS `rel_Reparto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rel_Reparto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_actor` int(11) NOT NULL,
  `id_pelicula` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_reparto` (`id_actor`,`id_pelicula`),
  KEY `id_pelicula` (`id_pelicula`),
  CONSTRAINT `rel_Reparto_ibfk_1` FOREIGN KEY (`id_actor`) REFERENCES `actor` (`id_actor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rel_Reparto_ibfk_2` FOREIGN KEY (`id_pelicula`) REFERENCES `pelicula` (`id_pelicula`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rel_Reparto`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `rel_Reparto` WRITE;
/*!40000 ALTER TABLE `rel_Reparto` DISABLE KEYS */;
INSERT INTO `rel_Reparto` VALUES
(1,1,1),
(6,2,5),
(10,5,9),
(7,7,7),
(8,9,8),
(9,10,8),
(2,11,2),
(3,12,3),
(5,12,4),
(4,13,3),
(11,14,9),
(12,14,10),
(13,15,10),
(14,16,11),
(15,17,11),
(16,18,11);
/*!40000 ALTER TABLE `rel_Reparto` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `socio`
--

DROP TABLE IF EXISTS `socio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `socio` (
  `id_socio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_socio`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socio`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `socio` WRITE;
/*!40000 ALTER TABLE `socio` DISABLE KEYS */;
INSERT INTO `socio` VALUES
(1,'María García López','666111222','C/ Mayor 12, Palma'),
(2,'Juan Martínez Ruiz','677333444','Av. Jaime III 45, Palma'),
(3,'Laura Fernández Soto','688555666','C/ Sindicat 8, Palma'),
(4,'Carlos Rodríguez Vidal','699777888','Pg. del Born 22, Palma'),
(5,'Ana Sánchez Pons','655999000','C/ Sant Miquel 5, Palma'),
(6,'Julio','691149988','Calle Rafael Rodriguez Mendez'),
(7,'Frank Reyes','682112843','Calle Aragon'),
(8,'Eduardo Sanchez','666111999','C/ Tomas Forteza, 11'),
(9,'Marco Sanchez','666111999','C/ Manacor, 13');
/*!40000 ALTER TABLE `socio` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-30 11:39:06
