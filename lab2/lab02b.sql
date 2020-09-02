/*
    Michael Ramage
    CSC 362
    Lab 02
    William Bailey
*/

/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS school;

/* Database does not exist, so create it*/
CREATE DATABASE school; 

/* Use 'school' database */
USE school;

/* Create a table for 'instructors' */
CREATE TABLE instructors (
    PRIMARY KEY (instructor_id),
    instructor_id INT AUTO_INCREMENT,
    inst_first_name VARCHAR(20),
    inst_last_name VARCHAR(20),
    campus_phone VARCHAR(20)
);

/* Insert new data into the 'instructors' table */
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) 
VALUES ("Kira", "Bently", "363-9948"),
       ("Timothy", "Ennis", "527-4992"),
       ("Shannon", "Black", "336-5992"),
       ("Estela", "Rosales", "322-6992");


