## About
This SQL script was created for CS 3200: Database Design at Northeastern University. The main focus of the assignment was to make a database that allowed a user to perform a variety of tasks, view data, and handle errors. This database was designed as a simple medical portal for patients, doctors, and hospital administrators. To make our database more interactive, we created a simple front-end site as well. 

#### Interacting with Database:
1. Go to http://hospitalproject.atwebpages.com/
2. Ability to login as 3 different views
    * Patient
    * Doctor
    * Admin
3. For Patient login, use following emails:
    * pat1@gmail.com
    * pat2@gmail.com
    * pat3@gmail.com
    * pat4@gmail.com
4. For Doctor login, use following emails:
    * doc1@gmail.com
    * doc2@gmail.com
5. For Admin login, use following email:
    * admin@gmail.com 
  


#### Error Throwing/Trigger Tests
1. Adding too many patients to same doctor
    * Doctors are only allowed 3 patients
2. Removing doctor with patients still assigned
    *  Will get error saying doctor cannot be removed
    * Doctors can only be removed if they no longer have patients
3. Prevent updating doctor to doctor with too many patients
    * Doctors are only allowed 3 patients
    * Will get error saying doctor has too many patients
4. Prevent scheduling conflict
    *  Scheduling conflicts can occur for patients and doctors between appointments and procedures
    * Scheduling conflicts occur when an appointment is made 15 minutes too soon to another appointment on the same day up to 30 minutes after the appointment time, as well as 15 minutes too soon to a procedure, and 1 hour after the procedure time
    * Will get scheduling conflict error
5. Updating Email
    * Whenever updating an email, for any of the views, if the field is left blank, the original email address will be kept. If it is the same email as another patient or employee, it will not change the email.

**Other Info:**
Date Format: YYYY-MM-DD
Time Format: 00:00:00