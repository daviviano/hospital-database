DROP DATABASE IF EXISTS hospital;

CREATE DATABASE hospital;

USE hospital;


DROP FUNCTION IF EXISTS too_many_patients;

DELIMITER //

CREATE FUNCTION too_many_patients
(
	id INT
)
RETURNS BOOLEAN
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

END //

DELIMITER ;

DROP FUNCTION IF EXISTS doctor_has_patients;

DELIMITER //

CREATE FUNCTION doctor_has_patients
(
	id INT
)
RETURNS BOOLEAN
BEGIN
	DECLARE num_patients INT;
    
    SELECT COUNT(DISTINCT p_id)
		INTO num_patients
			FROM patient
				WHERE doc_id = id;
                
    
    RETURN (num_patients != 0);

END //

DELIMITER ;

DROP FUNCTION IF EXISTS get_num_patients;

DELIMITER //

CREATE FUNCTION get_num_patients
(
	doctor_id INT
)
RETURNS INT
BEGIN
	DECLARE num_patients INT;
    
    SELECT COUNT(DISTINCT p_id)
		INTO num_patients
			FROM patient
				WHERE doc_id = doctor_id;
                
    
    RETURN num_patients;

END //

DELIMITER ;


DROP FUNCTION IF EXISTS check_valid_appointment;

DELIMITER //

CREATE FUNCTION check_valid_appointment
(
	s_time TIME,
    a_date DATE,
	patient_id INT,
    doctor_id INT,
    room_id INT
)
RETURNS BOOLEAN
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

END //

DELIMITER ;


DROP FUNCTION IF EXISTS invalid_email;

DELIMITER //

CREATE FUNCTION invalid_email
(
	id INT,
	new_email VARCHAR(50)
)
RETURNS BOOLEAN
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

END //

DELIMITER ;

DROP FUNCTION IF EXISTS invalid_employee_email;

DELIMITER //

CREATE FUNCTION invalid_employee_email
(
	id INT,
	new_email VARCHAR(50)
)
RETURNS BOOLEAN
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

END //

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_patient_info;

DELIMITER //

CREATE PROCEDURE get_patient_info
(
	id INT
)
BEGIN

	SELECT CONCAT(p.fname, ' ', p.lname) AS patient_name, dob, sex, height_inch, weight_lbs, 
    CONCAT(d.fname, ' ', d.lname) AS doctor_name, p.cell_num AS phone, p.email, p.emergency_num AS emergency_contact
		FROM patient p JOIN employee d ON (doc_id = e_id)
			WHERE p_id = id;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_patient_diagnosis;

DELIMITER //

CREATE PROCEDURE get_patient_diagnosis
(
	id INT
)
BEGIN

	SELECT mc_name AS medical_condition, mc_desc AS description
		FROM patient p JOIN diagnosis d USING (p_id) JOIN medical_condition m ON (d.mc_id = m.mc_id) 
			WHERE p_id = id;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_patient_procedure_history;

DELIMITER //

CREATE PROCEDURE get_patient_procedure_history
(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure
		FROM patient p JOIN medical_procedure mp USING (p_id)
			WHERE p_id = id AND proc_date < CURDATE();

END //

DELIMITER ;

 
 DROP PROCEDURE IF EXISTS get_patient_prescriptions;

DELIMITER //

CREATE PROCEDURE get_patient_prescriptions
(
	id INT
)
BEGIN

	SELECT m.med_name AS medication_name, m.med_desc AS description, pr.date_prescribed, pr.date_expired
		FROM patient p JOIN prescription pr USING (p_id) JOIN medication m ON (pr.med_id = m.med_id)
			WHERE p_id = id;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_upcoming_patient_proc;

DELIMITER //

CREATE PROCEDURE get_upcoming_patient_proc
(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure, CONCAT(e.fname, ' ', e.lname) AS doctor
		FROM patient p JOIN medical_procedure mp USING (p_id) JOIN employee e ON (mp.d_id = e.e_id)
			WHERE p_id = id AND proc_date >= CURDATE();

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_upcoming_patient_appt;

DELIMITER //

CREATE PROCEDURE get_upcoming_patient_appt
(
	id INT
)
BEGIN

	SELECT start_time, appt_date AS date_of_appointment, CONCAT(e.fname, ' ', e.lname) AS doctor
		FROM patient p JOIN appointment a USING (p_id) JOIN employee e ON (a.d_id = e.e_id)
			WHERE p_id = id AND appt_date >= CURDATE();

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_upcoming_doc_proc;

DELIMITER //

CREATE PROCEDURE get_upcoming_doc_proc
(
	id INT
)
BEGIN

	SELECT proc_desc AS medical_procedure , proc_date AS date_of_procedure, proc_time AS time_of_procedure, CONCAT(p.fname, ' ', p.lname) AS patient
		FROM patient p JOIN medical_procedure mp USING (p_id) JOIN doctor d ON (mp.d_id = d.e_id)
			WHERE d.e_id = id AND proc_date >= CURDATE();

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_upcoming_doc_appt;

DELIMITER //

CREATE PROCEDURE get_upcoming_doc_appt
(
	id INT
)
BEGIN

	SELECT start_time, appt_date AS date_of_appointment, CONCAT(p.fname, ' ', p.lname) AS patient
		FROM patient p JOIN appointment a USING (p_id) JOIN doctor d ON (a.d_id = d.e_id)
			WHERE d.e_id = id AND appt_date >= CURDATE();

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_upcoming_doc_appt;

DELIMITER //

CREATE PROCEDURE get_upcoming_doc_appt
(
	id INT
)
BEGIN

	SELECT start_time, appt_date AS date_of_appointment, CONCAT(p.fname, ' ', p.lname) AS patient
		FROM patient p JOIN appointment a USING (p_id) JOIN doctor d ON (a.d_id = d.e_id)
			WHERE d.e_id = id AND appt_date >= CURDATE();

END //

DELIMITER ;
-- ------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_doctor_info;

DELIMITER //

CREATE PROCEDURE get_doctor_info
(
	id INT
)
BEGIN

	SELECT CONCAT('Dr. ', e.fname, ' ', e.lname) AS doctor_name, dep.department_name, e.salary, e.cell_num AS phone, e.email
		FROM doctor d JOIN employee e USING (e_id) JOIN department dep USING (department_id)
			WHERE d.e_id = id;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_doctors_patient_info;

DELIMITER //

CREATE PROCEDURE get_doctors_patient_info
(
	id INT
)
BEGIN
	
	SELECT CONCAT(p.fname, ' ', p.lname) AS patient_name, dob, sex, height_inch, weight_lbs, 
     p.cell_num AS phone, p.email, p.emergency_num AS emergency_contact
		FROM patient p JOIN employee d ON (doc_id = e_id)
			WHERE e_id = id;

END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE add_diagnosis
(
	condition_id INT,
    patient_id INT,
    doctor_id INT
)
BEGIN

	 INSERT INTO diagnosis (mc_id, p_id, d_id)
     VALUE (condition_id, patient_id, doctor_id);

END //

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS add_patient;

DELIMITER //

CREATE PROCEDURE add_patient
(
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

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS add_appointment;

DELIMITER //

CREATE PROCEDURE add_appointment
(
	start_time TIME,
    appt_date DATE,
    p_id INT,
    d_id INT,
    r_id INT
)
BEGIN

	INSERT INTO appointment (start_time, appt_date, p_id, d_id, r_id)
			VALUES (start_time, appt_date, p_id, d_id, r_id);

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS add_procedure;

DELIMITER //

CREATE PROCEDURE add_procedure
(
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

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS add_prescription;

DELIMITER //

CREATE PROCEDURE add_prescription
(
	medication_id INT, 
    patient_id INT, 
    doctor_id INT, 
    date_prescribed DATE, 
    date_expired DATE
)
BEGIN

	INSERT INTO prescription (med_id, p_id, d_id, date_prescribed, date_expired)
			VALUES (medication_id, patient_id, doctor_id, date_prescribed, date_expired);

END //

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS add_doctor;

DELIMITER //

CREATE PROCEDURE add_doctor
(
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

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS remove_doctor;

DELIMITER //

CREATE PROCEDURE remove_doctor
(
	id INT
)
BEGIN
            
	DELETE FROM doctor WHERE e_id = id;
    DELETE FROM employee WHERE e_id = id;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_department_doctors;

DELIMITER //

CREATE PROCEDURE get_department_doctors
(
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
END //

DELIMITER ;



DROP PROCEDURE IF EXISTS get_total_dep_salaries;

DELIMITER //

CREATE PROCEDURE get_total_dep_salaries
(
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
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS get_admin_info;

DELIMITER //

CREATE PROCEDURE get_admin_info
(
	id INT
)
BEGIN

	SELECT CONCAT(e.fname, ' ', e.lname) AS admin_name, dep.department_name, e.salary, e.cell_num AS phone, e.email
		FROM employee e JOIN department dep ON (dep_head = e_id)
			WHERE e.e_id = id;

END //

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------

CREATE TABLE room
(
	r_id	INT	PRIMARY KEY	AUTO_INCREMENT,
    r_type	ENUM('patient', 'operating')
);

CREATE TABLE employee
(
	e_id	int	PRIMARY KEY	auto_increment,
    fname	VARCHAR(50),
    lname	VARCHAR(50),
    salary	INT,
    cell_num	VARCHAR(15),
    email		VARCHAR(50) UNIQUE
);

CREATE TABLE department
(
	department_id	INT PRIMARY KEY AUTO_INCREMENT,
    department_name	VARCHAR(50),
    dep_head		INT, -- refer to doc_id
    
    CONSTRAINT department_fk_employee FOREIGN KEY (dep_head) REFERENCES employee (e_id)
);

CREATE TABLE doctor
(
	e_id			INT	PRIMARY KEY,
    department_id 	INT,
    max_pat_num		INT DEFAULT 3,
    
    CONSTRAINT doctor_fk_department FOREIGN KEY (department_id) REFERENCES department (department_id),
    CONSTRAINT doctor_fk_employee FOREIGN KEY (e_id) REFERENCES employee (e_id)
);

CREATE TABLE patient 
(
	p_id			INT PRIMARY KEY AUTO_INCREMENT,
    fname	 		VARCHAR(50),
    lname			VARCHAR(50),
    sex				ENUM('m', 'f'),
    height_inch		INT,
    weight_lbs		INT,
    dob				DATE,
    cell_num		VARCHAR(15),
    email			VARCHAR(50) UNIQUE,
    emergency_num	VARCHAR(15),
    doc_id			INT,
    
    CONSTRAINT patient_fk_doctor FOREIGN KEY (doc_id) REFERENCES doctor (e_id)
);

CREATE TABLE appointment
(
	start_time TIME,
    appt_date DATE,
    p_id INT,
    d_id INT,
    r_id INT,
    
    PRIMARY KEY (start_time, appt_date, p_id, d_id),
    CONSTRAINT appt_fk_patient FOREIGN KEY (p_id) REFERENCES patient (p_id),
    CONSTRAINT appt_fk_doctor FOREIGN KEY (d_id) REFERENCES doctor (e_id),
    CONSTRAINT appt_fk_room FOREIGN KEY (r_id) REFERENCES room (r_id)
);

CREATE TABLE medical_condition
(
	mc_id	INT PRIMARY KEY auto_increment,
    mc_name	VARCHAR(50),
    mc_desc	VARCHAR(200)
);

CREATE TABLE diagnosis
(
	diag_id		INT  PRIMARY KEY  AUTO_INCREMENT,
    mc_id	INT,
    p_id		INT,
    d_id		INT,
    
    CONSTRAINT diagnosis_fk_patient FOREIGN KEY (p_id) REFERENCES patient (p_id),
    CONSTRAINT diagnosis_fk_doctor FOREIGN KEY (d_id) REFERENCES doctor (e_id),
	CONSTRAINT diagnosis_fk_medical_condition FOREIGN KEY (mc_id) REFERENCES medical_condition (mc_id)
);

CREATE TABLE medical_procedure
(
	proc_desc	VARCHAR(100),
    p_id		int,
    d_id		INT,
    proc_date		DATE,
    proc_time	TIME,
    r_id		INT,
    
    PRIMARY KEY(p_id, d_id, proc_date, proc_time, r_id),
    CONSTRAINT medical_procedure_fk_patient FOREIGN KEY (p_id) REFERENCES patient (p_id),
	CONSTRAINT medical_procedure_fk_doctor FOREIGN KEY (d_id) REFERENCES doctor (e_id),
	CONSTRAINT medical_procedure_fk_room FOREIGN KEY (r_id) REFERENCES room (r_id)
);

CREATE TABLE medication
(
	med_id INT PRIMARY KEY AUTO_INCREMENT,
    med_name VARCHAR(50),
    med_desc VARCHAR(50)
);

CREATE TABLE prescription
(
	presc_id	int PRIMARY KEY AUTO_INCREMENT,
    med_id  INT,
    p_id		INT,
    d_id 		INT,
    date_prescribed	DATE,
    date_expired	DATE,
    
     CONSTRAINT prescription_fk_patient FOREIGN KEY (p_id) REFERENCES patient (p_id),
     CONSTRAINT prescription_fk_doctor FOREIGN KEY (d_id) REFERENCES doctor (e_id),
     CONSTRAINT prescription_fk_medication FOREIGN KEY (med_id) REFERENCES medication (med_id)
);

-- ------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS patient_before_insert;

DELIMITER //

CREATE TRIGGER patient_before_insert
  BEFORE INSERT ON patient
  FOR EACH ROW
BEGIN

  
  IF too_many_patients(NEW.doc_id) = 1 THEN
    SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
      SET MESSAGE_TEXT = 'This doctor has too many patients.  Select different doctor.';
  END IF;
END//

DELIMITER ;

DROP TRIGGER IF EXISTS appointment_before_insert;

DELIMITER //

CREATE TRIGGER appointment_before_insert
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
END//

DELIMITER ;

DROP TRIGGER IF EXISTS medicalprocedure_before_insert;

DELIMITER //

CREATE TRIGGER medicalprocedure_before_insert
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
END//

DELIMITER ;

DROP TRIGGER IF EXISTS patient_before_update;

DELIMITER //

CREATE TRIGGER patient_before_update
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
END//

DELIMITER ;


DROP TRIGGER IF EXISTS doctor_before_delete;

DELIMITER //

CREATE TRIGGER doctor_before_delete
  BEFORE DELETE ON doctor
  FOR EACH ROW
BEGIN
  
	IF doctor_has_patients(OLD.e_id) = 1
    THEN
		SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
		SET MESSAGE_TEXT = 'Doctor has assigned patients.  Transfer patients before removal.';
  END IF;
END//

DELIMITER ;

DROP TRIGGER IF EXISTS employee_before_update;

DELIMITER //

CREATE TRIGGER employee_before_update
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
END//

DELIMITER ;


-- ------------------------------------------------------------------------------------------------------
-- 	BELOW IS ALL USED FOR TESTING.  DATA BELOW IS DIFFERENT THAN WEBSITE DATABASE


-- Creates Admin (employee that isn't doctor - will be department head)
INSERT INTO employee (fname, lname, salary, cell_num, email) VALUES ('Admin', 'Admin', 100000, '978-774-1234', 'admin@gmail.com');

-- Creates Neurology department and assigns employee1 ("Admin") as its head
INSERT INTO department (department_name, dep_head) VALUES('Physician', 1);

-- Creates 2 doctors in the Neurology department due to first field (dep. head adding them)
CALL add_doctor(1, 'Doc', '1', 90000, '978-774-1235', 'doc1@gmail.com');
CALL add_doctor(1, 'Doc', '2', 95000, '978-774-5555', 'doc2@gmail.com');

-- Creates 3 'patient' rooms and 3 'operating' rooms
INSERT INTO room (r_type) VALUES ('patient');
INSERT INTO room (r_type) VALUES ('patient');
INSERT INTO room (r_type) VALUES ('patient');
INSERT INTO room (r_type) VALUES ('operating');
INSERT INTO room (r_type) VALUES ('operating');
INSERT INTO room (r_type) VALUES ('operating');

-- Adds 3 patients to db, assigning them to doctor1
CALL add_patient('Pat1', 'Patient1', 'm', 65, 150, '1996-08-22', '978-979-6098', 'patient1@gmail.com', '911', 2);
CALL add_patient('Pat2', 'Patient2', 'f', 60, 100, '1976-09-22', '978-777-7000', 'patient2@gmail.com', '911', 2);
CALL add_patient('Pat3', 'Patient3', 'f', 62, 120, '1970-10-10', '617-777-7800', 'patient3@gmail.com', '911', 2);

-- If un-commented, below patient will not be added due to too many patients for that doctor
-- CALL add_patient('Pat4', 'Patient4', 'm', 72, 200, '1971-11-01', '617-777-7822', 'patient4@gmail.com', '911', 2);

-- Adds 1 patients to db, assigns them to doctor2
CALL add_patient('Pat5', 'Patient5', 'm', 70, 250, '1978-11-01', '617-777-5000', 'pat5_patient5@gmail.com', '911', 3);
-- If un-commented, below update will not work because doc1 will have too many patients if given Pat5
-- UPDATE patient SET doc_id = 2 WHERE p_id = 4;

-- Medical conditions harcoded into database for diagnosing purposes
INSERT INTO medical_condition (mc_name, mc_desc) VALUES ('Fever', 'Temperature over 100 degrees F');
INSERT INTO medical_condition (mc_name, mc_desc) VALUES ('Flu', 'Fever, chills, vomitting, etc.');
INSERT INTO medical_condition (mc_name, mc_desc) VALUES ('Strep Throat', 'Sore throat, loss of voice');

-- Adds 'Fever' and 'Flu' to Pat1, Adds 'Strep Throat' to Pat2
CALL add_diagnosis(1, 1, 2);
CALL add_diagnosis(2, 1, 2);
CALL add_diagnosis(3, 2, 3);

-- Adds old medical procedure to Pat1's history
CALL add_procedure('Remove leg tumor', 1, 2, '2001-05-20', '11:00:00', 4);
-- If uncommented, next add fails due to time overlap
-- CALL add_procedure('Will not work - time', 1, 2, '2001-05-20', '11:20:00', 4);

CALL add_procedure('Remove arm tumor', 1, 2, '2017-12-28', '01:00:00', 4);
-- If uncommented, next add fails due to invalid room type
-- CALL add_procedure('Remove arm tumor', 1, 2, '2017-12-30', '01:00:00', 1);

-- Medication harcoded into database for prescribing purposes
INSERT INTO medication (med_name, med_desc) VALUES ('Vicodin', 'Pain relief');
INSERT INTO medication (med_name, med_desc) VALUES ('Keppra', 'Seizure Medicine');
INSERT INTO medication (med_name, med_desc) VALUES ('Super Advil', 'Makes headaches go away');

-- Doc1 prescribes Pat1 to 'Vicodin'
CALL add_prescription(1, 1, 2, '2017-11-28', '2017-12-28');

-- Adds appointment to Pat1
CALL add_appointment('11:00:00', '2017-12-05', 1, 2, 1);
-- If uncommented, next call does not add due to time constraint
-- CALL add_appointment('11:25:00', '2017-12-05', 1, 2, 1);

-- Adds appointment to Pat1
CALL add_appointment('11:30:00', '2017-12-07', 1, 2, 1);
-- If uncommented, next call does not add due to invalid room
-- CALL add_appointment('11:00:00', '2017-12-06', 1, 2, 4);


-- GETTERS:
-- Gets upcoming appointments for Pat1
-- CALL get_upcoming_patient_appt(1);
-- Gets upcoming appointments for Doc1
-- CALL get_upcoming_doc_appt(2);

-- Gets upcoming procedures for Pat1
-- CALL get_upcoming_patient_proc(1);
-- Gets upcoming procedures for Doc1
-- CALL get_upcoming_doc_proc(2);

-- CALL get_patient_info(1);
-- CALL get_patient_diagnosis(1);
-- CALL get_patient_procedure_history(1);
-- CALL get_patient_prescriptions(1);
-- CALL get_doctor_info(2);
-- CALL get_doctors_patient_info(2);
-- CALL get_department_doctors(1);
-- CALL get_total_dep_salaries(1);
-- CALL get_admin_info(1);














