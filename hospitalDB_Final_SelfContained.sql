-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital
-- ------------------------------------------------------
-- Server version	5.7.19-log

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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointment` (
  `start_time` time NOT NULL,
  `appt_date` date NOT NULL,
  `p_id` int(11) NOT NULL,
  `d_id` int(11) NOT NULL,
  `r_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`start_time`,`appt_date`,`p_id`,`d_id`),
  KEY `appt_fk_patient` (`p_id`),
  KEY `appt_fk_doctor` (`d_id`),
  KEY `appt_fk_room` (`r_id`),
  CONSTRAINT `appt_fk_doctor` FOREIGN KEY (`d_id`) REFERENCES `doctor` (`e_id`),
  CONSTRAINT `appt_fk_patient` FOREIGN KEY (`p_id`) REFERENCES `patient` (`p_id`),
  CONSTRAINT `appt_fk_room` FOREIGN KEY (`r_id`) REFERENCES `room` (`r_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES ('11:00:00','2017-12-05',1,2,1),('11:30:00','2017-12-07',1,2,1);
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER appointment_before_insert
  BEFORE INSERT ON appointment
  FOR EACH ROW
BEGIN
  
  DECLARE type_of_room VARCHAR(50);
    
    SELECT r_type
		INTO type_of_room
			FROM room r
				WHERE r.r_id = NEW.r_id;

	IF check_valid_appointment(NEW.start_time, NEW.appt_date, NEW.p_id, NEW.d_id, NEW.r_id) = 0
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Overlapping appointment date/time with another appointment or procedure.';
	ELSEIF type_of_room != 'patient'
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Wrong type of room.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `department_id` int(11) NOT NULL AUTO_INCREMENT,
  `department_name` varchar(50) DEFAULT NULL,
  `dep_head` int(11) DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  KEY `department_fk_employee` (`dep_head`),
  CONSTRAINT `department_fk_employee` FOREIGN KEY (`dep_head`) REFERENCES `employee` (`e_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Physician',1);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnosis`
--

DROP TABLE IF EXISTS `diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diagnosis` (
  `diag_id` int(11) NOT NULL AUTO_INCREMENT,
  `mc_id` int(11) DEFAULT NULL,
  `p_id` int(11) DEFAULT NULL,
  `d_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`diag_id`),
  KEY `diagnosis_fk_patient` (`p_id`),
  KEY `diagnosis_fk_doctor` (`d_id`),
  KEY `diagnosis_fk_medical_condition` (`mc_id`),
  CONSTRAINT `diagnosis_fk_doctor` FOREIGN KEY (`d_id`) REFERENCES `doctor` (`e_id`),
  CONSTRAINT `diagnosis_fk_medical_condition` FOREIGN KEY (`mc_id`) REFERENCES `medical_condition` (`mc_id`),
  CONSTRAINT `diagnosis_fk_patient` FOREIGN KEY (`p_id`) REFERENCES `patient` (`p_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnosis`
--

LOCK TABLES `diagnosis` WRITE;
/*!40000 ALTER TABLE `diagnosis` DISABLE KEYS */;
INSERT INTO `diagnosis` VALUES (1,1,1,2),(2,2,1,2),(3,3,2,3);
/*!40000 ALTER TABLE `diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `doctor` (
  `e_id` int(11) NOT NULL,
  `department_id` int(11) DEFAULT NULL,
  `max_pat_num` int(11) DEFAULT '3',
  PRIMARY KEY (`e_id`),
  KEY `doctor_fk_department` (`department_id`),
  CONSTRAINT `doctor_fk_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `doctor_fk_employee` FOREIGN KEY (`e_id`) REFERENCES `employee` (`e_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (2,1,3),(3,1,3);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER doctor_before_delete
  BEFORE DELETE ON doctor
  FOR EACH ROW
BEGIN
  
	IF doctor_has_patients(OLD.e_id) = 1
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Doctor has assigned patients.  Transfer patients before removal.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
  `e_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `cell_num` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`e_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Admin','Admin',100000,'978-774-1234','admin@gmail.com'),(2,'Doc','1',90000,'978-774-1235','doc1@gmail.com'),(3,'Doc','2',95000,'978-774-5555','doc2@gmail.com');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER employee_before_update
  BEFORE UPDATE ON employee
  FOR EACH ROW
BEGIN
  
	IF NEW.email != OLD.email
  THEN
	IF invalid_employee_email(OLD.e_id, NEW.email) = 1
		THEN
			SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
			SET MESSAGE_TEXT = 'Email already in use or blank.  Choose new email.';
		END IF;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medical_condition`
--

DROP TABLE IF EXISTS `medical_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medical_condition` (
  `mc_id` int(11) NOT NULL AUTO_INCREMENT,
  `mc_name` varchar(50) DEFAULT NULL,
  `mc_desc` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`mc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_condition`
--

LOCK TABLES `medical_condition` WRITE;
/*!40000 ALTER TABLE `medical_condition` DISABLE KEYS */;
INSERT INTO `medical_condition` VALUES (1,'Fever','Temperature over 100 degrees F'),(2,'Flu','Fever, chills, vomitting, etc.'),(3,'Strep Throat','Sore throat, loss of voice');
/*!40000 ALTER TABLE `medical_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_procedure`
--

DROP TABLE IF EXISTS `medical_procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medical_procedure` (
  `proc_desc` varchar(100) DEFAULT NULL,
  `p_id` int(11) NOT NULL,
  `d_id` int(11) NOT NULL,
  `proc_date` date NOT NULL,
  `proc_time` time NOT NULL,
  `r_id` int(11) NOT NULL,
  PRIMARY KEY (`p_id`,`d_id`,`proc_date`,`proc_time`,`r_id`),
  KEY `medical_procedure_fk_doctor` (`d_id`),
  KEY `medical_procedure_fk_room` (`r_id`),
  CONSTRAINT `medical_procedure_fk_doctor` FOREIGN KEY (`d_id`) REFERENCES `doctor` (`e_id`),
  CONSTRAINT `medical_procedure_fk_patient` FOREIGN KEY (`p_id`) REFERENCES `patient` (`p_id`),
  CONSTRAINT `medical_procedure_fk_room` FOREIGN KEY (`r_id`) REFERENCES `room` (`r_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_procedure`
--

LOCK TABLES `medical_procedure` WRITE;
/*!40000 ALTER TABLE `medical_procedure` DISABLE KEYS */;
INSERT INTO `medical_procedure` VALUES ('Remove leg tumor',1,2,'2001-05-20','11:00:00',4),('Remove arm tumor',1,2,'2017-12-28','01:00:00',4);
/*!40000 ALTER TABLE `medical_procedure` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER medicalprocedure_before_insert
  BEFORE INSERT ON medical_procedure
  FOR EACH ROW
BEGIN
  
  DECLARE type_of_room VARCHAR(50);
    
    SELECT r_type
		INTO type_of_room
			FROM room r
				WHERE r.r_id = NEW.r_id;

	IF check_valid_appointment(NEW.proc_time, NEW.proc_date, NEW.p_id, NEW.d_id, NEW.r_id) = 0
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Overlapping medical procedure date/time with another procedure or appointment.';
	ELSEIF type_of_room != 'operating'
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Wrong type of room.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medication`
--

DROP TABLE IF EXISTS `medication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medication` (
  `med_id` int(11) NOT NULL AUTO_INCREMENT,
  `med_name` varchar(50) DEFAULT NULL,
  `med_desc` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`med_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medication`
--

LOCK TABLES `medication` WRITE;
/*!40000 ALTER TABLE `medication` DISABLE KEYS */;
INSERT INTO `medication` VALUES (1,'Vicodin','Pain relief'),(2,'Keppra','Seizure Medicine'),(3,'Super Advil','Makes headaches go away');
/*!40000 ALTER TABLE `medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient` (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) DEFAULT NULL,
  `sex` enum('m','f') DEFAULT NULL,
  `height_inch` int(11) DEFAULT NULL,
  `weight_lbs` int(11) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `cell_num` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `emergency_num` varchar(15) DEFAULT NULL,
  `doc_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`p_id`),
  UNIQUE KEY `email` (`email`),
  KEY `patient_fk_doctor` (`doc_id`),
  CONSTRAINT `patient_fk_doctor` FOREIGN KEY (`doc_id`) REFERENCES `doctor` (`e_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Pat1','Patient1','m',65,150,'1996-08-22','978-979-6098','patient1@gmail.com','911',2),(2,'Pat2','Patient2','f',60,100,'1976-09-22','978-777-7000','patient2@gmail.com','911',2),(3,'Pat3','Patient3','f',62,120,'1970-10-10','617-777-7800','patient3@gmail.com','911',2),(4,'Pat5','Patient5','m',70,250,'1978-11-01','617-777-5000','pat5_patient5@gmail.com','911',3);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER patient_before_insert
  BEFORE INSERT ON patient
  FOR EACH ROW
BEGIN

  
  IF too_many_patients(NEW.doc_id) = 1 THEN
    SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
      SET MESSAGE_TEXT = 'This doctor has too many patients.  Select different doctor.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER patient_before_update
  BEFORE UPDATE ON patient
  FOR EACH ROW
BEGIN
  
  IF NEW.doc_id != OLD.doc_id
  THEN
		IF too_many_patients(NEW.doc_id) = 1
		THEN
			SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
			SET MESSAGE_TEXT = 'Selected doctor has too many patients.  Please choose new doctor.';
		END IF;
	END IF;

  
  IF NEW.email != OLD.email
  THEN
	IF invalid_email(OLD.p_id, NEW.email) = 1
		THEN
			SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
			SET MESSAGE_TEXT = 'Email already in use or blank.  Choose new email.';
		END IF;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prescription` (
  `presc_id` int(11) NOT NULL AUTO_INCREMENT,
  `med_id` int(11) DEFAULT NULL,
  `p_id` int(11) DEFAULT NULL,
  `d_id` int(11) DEFAULT NULL,
  `date_prescribed` date DEFAULT NULL,
  `date_expired` date DEFAULT NULL,
  PRIMARY KEY (`presc_id`),
  KEY `prescription_fk_patient` (`p_id`),
  KEY `prescription_fk_doctor` (`d_id`),
  KEY `prescription_fk_medication` (`med_id`),
  CONSTRAINT `prescription_fk_doctor` FOREIGN KEY (`d_id`) REFERENCES `doctor` (`e_id`),
  CONSTRAINT `prescription_fk_medication` FOREIGN KEY (`med_id`) REFERENCES `medication` (`med_id`),
  CONSTRAINT `prescription_fk_patient` FOREIGN KEY (`p_id`) REFERENCES `patient` (`p_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,1,2,'2017-11-28','2017-12-28');
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room` (
  `r_id` int(11) NOT NULL AUTO_INCREMENT,
  `r_type` enum('patient','operating') DEFAULT NULL,
  PRIMARY KEY (`r_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,'patient'),(2,'patient'),(3,'patient'),(4,'operating'),(5,'operating'),(6,'operating');
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hospital'
--

--
-- Dumping routines for database 'hospital'
--
/*!50003 DROP FUNCTION IF EXISTS `check_valid_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_valid_appointment`(
	s_time TIME,
    a_date DATE,
	patient_id INT,
    doctor_id INT,
    room_id INT
) RETURNS tinyint(1)
BEGIN
	DECLARE valid BOOLEAN DEFAULT 1;
    DECLARE person_apt_time TIME;
    DECLARE person_apt_date DATE;
    
    DECLARE patient_apt_cursor CURSOR FOR
		SELECT start_time, appt_date FROM appointment WHERE p_id = patient_id;
        
	DECLARE patient_proc_cursor CURSOR FOR
		SELECT proc_time, proc_date FROM medical_procedure WHERE p_id = patient_id;
    
    DECLARE doc_apt_cursor CURSOR FOR
		SELECT start_time, appt_date FROM appointment WHERE d_id = doctor_id;
    
    DECLARE doc_proc_cursor CURSOR FOR
		SELECT proc_time, proc_date FROM medical_procedure WHERE d_id = doctor_id;
    
    DECLARE room_apt_cursor CURSOR FOR
		SELECT start_time, appt_date FROM appointment WHERE r_id = room_id;
    
    DECLARE room_proc_cursor CURSOR FOR
		SELECT proc_time, proc_date FROM medical_procedure WHERE r_id = room_id;
    
    OPEN patient_apt_cursor;
    BEGIN
    
		DECLARE row_not_found TINYINT DEFAULT FALSE;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
    
		FETCH patient_apt_cursor INTO person_apt_time, person_apt_date;
		WHILE row_not_found = FALSE DO
		
		IF a_date = person_apt_date AND (s_time < DATE_ADD(person_apt_time, INTERVAL 30 MINUTE)) 
		AND (s_time > DATE_SUB(person_apt_time, INTERVAL 15 MINUTE))
		THEN SELECT 0 INTO valid;
		END IF;
		
		FETCH patient_apt_cursor INTO person_apt_time, person_apt_date;
		END WHILE;
    
    END;
    CLOSE patient_apt_cursor;
    
    OPEN patient_proc_cursor;
    BEGIN
		DECLARE row_not_found TINYINT DEFAULT FALSE;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
		FETCH patient_proc_cursor INTO person_apt_time, person_apt_date;
		WHILE row_not_found = FALSE DO
		
		IF a_date = person_apt_date AND (s_time < DATE_ADD(person_apt_time, INTERVAL 1 HOUR)) 
		AND (s_time > DATE_SUB(person_apt_time, INTERVAL 15 MINUTE))
		THEN SELECT 0 INTO valid;
		END IF;
		
		FETCH patient_proc_cursor INTO person_apt_time, person_apt_date;
		END WHILE;
    END;
    CLOSE patient_proc_cursor;
    
    OPEN doc_apt_cursor;
    BEGIN
    	DECLARE row_not_found TINYINT DEFAULT FALSE;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
		FETCH doc_apt_cursor INTO person_apt_time, person_apt_date;
        WHILE row_not_found = FALSE DO
		
		IF a_date = person_apt_date AND (s_time < DATE_ADD(person_apt_time, INTERVAL 1 HOUR)) 
		AND (s_time > DATE_SUB(person_apt_time, INTERVAL 15 MINUTE))
		THEN SELECT 0 INTO valid;
		END IF;
        
        FETCH doc_apt_cursor INTO person_apt_time, person_apt_date;
		END WHILE;
    END;
    CLOSE doc_apt_cursor;
    
    OPEN doc_proc_cursor;
    BEGIN
		DECLARE row_not_found TINYINT DEFAULT FALSE;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
    
		FETCH doc_proc_cursor INTO person_apt_time, person_apt_date;
		WHILE row_not_found = FALSE DO
		
		IF a_date = person_apt_date AND (s_time < DATE_ADD(person_apt_time, INTERVAL 1 HOUR)) 
		AND (s_time > DATE_SUB(person_apt_time, INTERVAL 15 MINUTE))
		THEN SELECT 0 INTO valid;
		END IF;
		
		FETCH doc_proc_cursor INTO person_apt_time, person_apt_date;
		END WHILE;
    END;
    CLOSE doc_proc_cursor;
    
	OPEN room_apt_cursor;
    BEGIN
		DECLARE row_not_found TINYINT DEFAULT FALSE;
    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
		FETCH room_apt_cursor INTO person_apt_time, person_apt_date;
        WHILE row_not_found = FALSE DO
		
		IF a_date = person_apt_date AND (s_time < DATE_ADD(person_apt_time, INTERVAL 1 HOUR)) 
		AND (s_time > DATE_SUB(person_apt_time, INTERVAL 15 MINUTE))
		THEN SELECT 0 INTO valid;
		END IF;
        
        FETCH room_apt_cursor INTO person_apt_time, person_apt_date;
		END WHILE;
    END;
    CLOSE room_apt_cursor;
    
    return valid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `doctor_has_patients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `doctor_has_patients`(
	id INT
) RETURNS tinyint(1)
BEGIN
	DECLARE num_patients INT;
    
    SELECT COUNT(DISTINCT p_id)
		INTO num_patients
			FROM patient
				WHERE doc_id = id;
                
    
    RETURN (num_patients != 0);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_num_patients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_num_patients`(
	doctor_id INT
) RETURNS int(11)
BEGIN
	DECLARE num_patients INT;
    
    SELECT COUNT(DISTINCT p_id)
		INTO num_patients
			FROM patient
				WHERE doc_id = doctor_id;
                
    
    RETURN num_patients;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `invalid_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `invalid_email`(
	id INT,
	new_email VARCHAR(50)
) RETURNS tinyint(1)
BEGIN

	DECLARE pat_cur_email VARCHAR(50);
    DECLARE count_new_email INT;
    
    SELECT email
		INTO pat_cur_email
			FROM patient
				WHERE p_id = id;
                
	SELECT COUNT(email)
		INTO count_new_email
			FROM patient p
				WHERE p.email = new_email;
	
    IF pat_cur_email = new_email
    THEN RETURN FALSE;
    ELSEIF count_new_email > 0 OR new_email = ''
    THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `invalid_employee_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `invalid_employee_email`(
	id INT,
	new_email VARCHAR(50)
) RETURNS tinyint(1)
BEGIN

	DECLARE emp_cur_email VARCHAR(50);
    DECLARE count_new_email INT;
    
    SELECT email
		INTO emp_cur_email
			FROM employee
				WHERE e_id = id;
                
	SELECT COUNT(email)
		INTO count_new_email
			FROM employee e
				WHERE e.email = new_email;
	
    IF emp_cur_email = new_email
    THEN RETURN FALSE;
    ELSEIF count_new_email > 0 OR new_email = ''
    THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `too_many_patients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `too_many_patients`(
	id INT
) RETURNS tinyint(1)
BEGIN
	DECLARE patients_for_doc INT;
    DECLARE max_pat INT;
    
    SELECT COUNT(DISTINCT p_id)
		INTO patients_for_doc
			FROM patient
				WHERE doc_id = id;
                
	SELECT max_pat_num
		INTO max_pat
			FROM doctor
				WHERE e_id = id;
    
    RETURN patients_for_doc >= max_pat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_appointment`(
	start_time TIME,
    appt_date DATE,
    p_id INT,
    d_id INT,
    r_id INT
)
BEGIN

	INSERT INTO appointment (start_time, appt_date, p_id, d_id, r_id)
			VALUES (start_time, appt_date, p_id, d_id, r_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_diagnosis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_diagnosis`(
	condition_id INT,
    patient_id INT,
    doctor_id INT
)
BEGIN

	 INSERT INTO diagnosis (mc_id, p_id, d_id)
     VALUE (condition_id, patient_id, doctor_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_doctor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_doctor`(
	admin_creator_id INT,
	fname VARCHAR(50),
    lname VARCHAR(50),
    salary INT,
    cell_num VARCHAR(15),
    email VARCHAR(50)
)
BEGIN
	DECLARE dept_id INT;
    DECLARE new_docs_e_id INT;
    
    SELECT department_id
		INTO dept_id
			FROM department
				WHERE dep_head = admin_creator_id;

	INSERT INTO employee (fname, lname, salary, cell_num, email)
			VALUES (fname, lname, salary, cell_num, email);
            
	SELECT MAX(e_id)
		INTO new_docs_e_id
			FROM employee;
				
	INSERT INTO doctor (e_id, department_id) VALUES (new_docs_e_id , dept_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_patient`(
	fname VARCHAR(50),
    lname VARCHAR(50),
    sex ENUM('m', 'f'),
    height_inch INT(11),
    weight_lbs INT(11),
    dob DATE,
    cell_num VARCHAR(15),
    email VARCHAR(50),
    emergency_num VARCHAR(15),
    doc_id INT
)
BEGIN

	 INSERT INTO patient (fname, lname, sex, height_inch, weight_lbs, dob, cell_num, email, emergency_num, doc_id)
			VALUE (fname, lname, sex, height_inch, weight_lbs, dob, cell_num, email, emergency_num, doc_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_prescription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_prescription`(
	medication_id INT, 
    patient_id INT, 
    doctor_id INT, 
    date_prescribed DATE, 
    date_expired DATE
)
BEGIN

	INSERT INTO prescription (med_id, p_id, d_id, date_prescribed, date_expired)
			VALUES (medication_id, patient_id, doctor_id, date_prescribed, date_expired);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_procedure`(
	proc_desc VARCHAR(100),
    p_id INT,
    d_id INT,
    proc_date DATE,
	proc_time TIME,
    r_id INT
)
BEGIN

	INSERT INTO medical_procedure (proc_desc, p_id, d_id, proc_date, proc_time, r_id)
			VALUES (proc_desc, p_id, d_id, proc_date, proc_time, r_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_admin_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_admin_info`(
	id INT
)
BEGIN

	SELECT CONCAT(e.fname, ' ', e.lname) AS admin_name, dep.department_name, e.salary, e.cell_num AS phone, e.email
		FROM employee e JOIN department dep ON (dep_head = e_id)
			WHERE e.e_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_department_doctors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_department_doctors`(
	id INT
)
BEGIN
 DECLARE admin_dep_id INT;
 
 SELECT department_id
    INTO admin_dep_id
		FROM department
			WHERE dep_head = id;
                
	
	SELECT CONCAT('Dr. ', fname, ' ', lname) as doctor_name, salary, cell_num AS phone,
    email, get_num_patients(d.e_id) AS number_of_patients
		FROM employee e JOIN doctor d USING (e_id)
			WHERE admin_dep_id = d.department_id ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_doctors_patient_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_doctors_patient_info`(
	id INT
)
BEGIN
	
	SELECT CONCAT(p.fname, ' ', p.lname) AS patient_name, dob, sex, height_inch, weight_lbs, 
     p.cell_num AS phone, p.email, p.emergency_num AS emergency_contact
		FROM patient p JOIN employee d ON (doc_id = e_id)
			WHERE e_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_doctor_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_doctor_info`(
	id INT
)
BEGIN

	SELECT CONCAT('Dr. ', e.fname, ' ', e.lname) AS doctor_name, dep.department_name, e.salary, e.cell_num AS phone, e.email
		FROM doctor d JOIN employee e USING (e_id) JOIN department dep USING (department_id)
			WHERE d.e_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_patient_diagnosis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_patient_diagnosis`(
	id INT
)
BEGIN

	SELECT mc_name AS medical_condition, mc_desc AS description
		FROM patient p JOIN diagnosis d USING (p_id) JOIN medical_condition m ON (d.mc_id = m.mc_id) 
			WHERE p_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_patient_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_patient_info`(
	id INT
)
BEGIN

	SELECT CONCAT(p.fname, ' ', p.lname) AS patient_name, dob, sex, height_inch, weight_lbs, 
    CONCAT(d.fname, ' ', d.lname) AS doctor_name, p.cell_num AS phone, p.email, p.emergency_num AS emergency_contact
		FROM patient p JOIN employee d ON (doc_id = e_id)
			WHERE p_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_patient_prescriptions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_patient_prescriptions`(
	id INT
)
BEGIN

	SELECT m.med_name AS medication_name, m.med_desc AS description, pr.date_prescribed, pr.date_expired
		FROM patient p JOIN prescription pr USING (p_id) JOIN medication m ON (pr.med_id = m.med_id)
			WHERE p_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_patient_procedure_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_patient_procedure_history`(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure
		FROM patient p JOIN medical_procedure mp USING (p_id)
			WHERE p_id = id AND proc_date < CURDATE();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_total_dep_salaries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_dep_salaries`(
	id INT
)
BEGIN
 DECLARE admin_dep_id INT;
 
 SELECT department_id
    INTO admin_dep_id
		FROM department
			WHERE dep_head = id;
                
	
	SELECT SUM(salary) AS total_department_salaries
		FROM employee e JOIN doctor d USING (e_id)
			WHERE admin_dep_id = d.department_id ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_upcoming_doc_appt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_upcoming_doc_appt`(
	id INT
)
BEGIN

	SELECT start_time, appt_date AS date_of_appointment, CONCAT(p.fname, ' ', p.lname) AS patient
		FROM patient p JOIN appointment a USING (p_id) JOIN doctor d ON (a.d_id = d.e_id)
			WHERE d.e_id = id AND appt_date >= CURDATE();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_upcoming_doc_proc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_upcoming_doc_proc`(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure, CONCAT(p.fname, ' ', p.lname) AS patient
		FROM patient p JOIN medical_procedure mp USING (p_id) JOIN doctor d ON (mp.d_id = d.e_id)
			WHERE d.e_id = id AND proc_date >= CURDATE();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_upcoming_patient_appt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_upcoming_patient_appt`(
	id INT
)
BEGIN

	SELECT start_time, appt_date AS date_of_appointment, CONCAT(e.fname, ' ', e.lname) AS doctor
		FROM patient p JOIN appointment a USING (p_id) JOIN employee e ON (a.d_id = e.e_id)
			WHERE p_id = id AND appt_date >= CURDATE();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_upcoming_patient_proc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_upcoming_patient_proc`(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure, CONCAT(e.fname, ' ', e.lname) AS doctor
		FROM patient p JOIN medical_procedure mp USING (p_id) JOIN employee e ON (mp.d_id = e.e_id)
			WHERE p_id = id AND proc_date >= CURDATE();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_doctor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_doctor`(
	id INT
)
BEGIN
            
	DELETE FROM doctor WHERE e_id = id;
    DELETE FROM employee WHERE e_id = id;

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

-- Dump completed on 2017-12-08 16:40:18
