-- MySQL dump 10.13  Distrib 8.4.10, for Linux (x86_64)
--
-- Host: localhost    Database: MiConjuntoTECHDB
-- ------------------------------------------------------
-- Server version	8.4.10

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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `id_admin` int NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_admin`),
  CONSTRAINT `Admin_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `Usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Anuncio`
--

DROP TABLE IF EXISTS `Anuncio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Anuncio` (
  `id_anuncio` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(150) DEFAULT NULL,
  `contenido` text,
  `fecha_publicacion` date DEFAULT NULL,
  `estado` enum('ACTIVO','ELIMINADO') DEFAULT NULL,
  `id_admin` int DEFAULT NULL,
  PRIMARY KEY (`id_anuncio`),
  KEY `id_admin` (`id_admin`),
  CONSTRAINT `Anuncio_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `Admin` (`id_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Anuncio`
--

LOCK TABLES `Anuncio` WRITE;
/*!40000 ALTER TABLE `Anuncio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Anuncio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Casa`
--

DROP TABLE IF EXISTS `Casa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Casa` (
  `id_casa` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(150) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `tamano` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_casa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Casa`
--

LOCK TABLES `Casa` WRITE;
/*!40000 ALTER TABLE `Casa` DISABLE KEYS */;
/*!40000 ALTER TABLE `Casa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Documento`
--

DROP TABLE IF EXISTS `Documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Documento` (
  `id_documento` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(150) DEFAULT NULL,
  `documento_url` varchar(255) DEFAULT NULL,
  `id_admin` int DEFAULT NULL,
  PRIMARY KEY (`id_documento`),
  KEY `id_admin` (`id_admin`),
  CONSTRAINT `Documento_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `Admin` (`id_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Documento`
--

LOCK TABLES `Documento` WRITE;
/*!40000 ALTER TABLE `Documento` DISABLE KEYS */;
/*!40000 ALTER TABLE `Documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Mensaje`
--

DROP TABLE IF EXISTS `Mensaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Mensaje` (
  `id_mensaje` int NOT NULL AUTO_INCREMENT,
  `contenido` text,
  `fecha_envio` datetime DEFAULT NULL,
  `id_emisor` int DEFAULT NULL,
  `id_receptor` int DEFAULT NULL,
  PRIMARY KEY (`id_mensaje`),
  KEY `id_emisor` (`id_emisor`),
  KEY `id_receptor` (`id_receptor`),
  CONSTRAINT `Mensaje_ibfk_1` FOREIGN KEY (`id_emisor`) REFERENCES `Usuario` (`id_usuario`),
  CONSTRAINT `Mensaje_ibfk_2` FOREIGN KEY (`id_receptor`) REFERENCES `Usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mensaje`
--

LOCK TABLES `Mensaje` WRITE;
/*!40000 ALTER TABLE `Mensaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `Mensaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PQRS`
--

DROP TABLE IF EXISTS `PQRS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PQRS` (
  `id_pqrs` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('PETICION','QUEJA','RECLAMO') DEFAULT NULL,
  `descripcion` text,
  `fecha_creacion` date DEFAULT NULL,
  `estado` enum('ABIERTA','EN_PROCESO','RESUELTA') DEFAULT NULL,
  `respuesta` text,
  `fecha_resolucion` date DEFAULT NULL,
  `id_residente` int DEFAULT NULL,
  `id_admin` int DEFAULT NULL,
  PRIMARY KEY (`id_pqrs`),
  KEY `id_residente` (`id_residente`),
  KEY `id_admin` (`id_admin`),
  CONSTRAINT `PQRS_ibfk_1` FOREIGN KEY (`id_residente`) REFERENCES `Residente` (`id_residente`),
  CONSTRAINT `PQRS_ibfk_2` FOREIGN KEY (`id_admin`) REFERENCES `Admin` (`id_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PQRS`
--

LOCK TABLES `PQRS` WRITE;
/*!40000 ALTER TABLE `PQRS` DISABLE KEYS */;
/*!40000 ALTER TABLE `PQRS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Residente`
--

DROP TABLE IF EXISTS `Residente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Residente` (
  `id_residente` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `id_casa` int DEFAULT NULL,
  `tipo` enum('PROPIETARIO','ARRENDATARIO') DEFAULT NULL,
  PRIMARY KEY (`id_residente`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_casa` (`id_casa`),
  CONSTRAINT `Residente_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario` (`id_usuario`),
  CONSTRAINT `Residente_ibfk_2` FOREIGN KEY (`id_casa`) REFERENCES `Casa` (`id_casa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Residente`
--

LOCK TABLES `Residente` WRITE;
/*!40000 ALTER TABLE `Residente` DISABLE KEYS */;
/*!40000 ALTER TABLE `Residente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` enum('ADMIN','RESIDENTE') DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'MiConjuntoTECHDB'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-22 16:37:19
