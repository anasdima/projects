CREATE TABLE Φοιτητής (
User_name varchar(20),
ΑΜ varchar2(15) CONSTRAINT pk_AEM PRIMARY KEY AM,
Επίθετο varchar2(25) NOT NULL,
Όνομα varchar2(20) NOT NULL,
Ημερ_Γεν date NOT NULL,
Φύλο char(1) NOT NULL CONSTRAINT gender_type CHECK(Φύλο ='Α' or Φύλο = 'Γ'),
Διεύθυνση varchar2(100) NOT NULL,
Πόλη varchar2(20) NOT NULL,
Ταχ_Κωδ number NOT NULL CONSTRAINT digits_PostalCode Check(Ταχ_Κωδ > 9999 and Ταχ_Κωδ < 100000),
Τηλ number NOT NULL CONSTRAINT digits_PhoneNumber Check(Τηλ > 999999999 and Τηλ < 10000000000),
Email varchar2(50) NOT NULL CONSTRAINT uk_email UNIQUE
CONSTRAINT uk_name UNIQUE(Επίθετο,Όνομα)
);

CREATE TABLE Τμήμα (
Τμήμα_Κωδ number NOT NULL CONSTRAINT pk_DeptCode PRIMARY KEY,
Τμήμα_Όνομα varchar2(25) NOT NULL CONSTRAINT uk_Dept UNIQUE
);

CREATE TABLE Εισηγητής (
Εισηγητής_Κωδ varchar2(20) CONSTRAINT pk_ProffCode PRIMARY KEY,
Επίθετο varchar2(25) NOT NULL,
Όνομα varchar2(50) NOT NULL,
Θέση varchar2(25) NOT NULL CONSTRAINT proffpos CHECK(Θέση='ΚΑΘΗΓΗΤΗΣ' or Θέση='ΑΝΑΠΛΗΡΩΤΗΣ' or Θέση='ΕΠΙΚΟΥΡΟΣ' or Θέση='ΛΕΚΤΟΡΑΣ')
Τηλ number NOT NULL CONSTRAINT digits_PhoneNumber Check(Τηλ > 999999999 and Τηλ < 10000000000),
Email varchar2(50) NOT NULL, CONSTRAINT uk_email UNIQUE
CONSTRAINT uk_name UNIQUE(Επίθετο,Όνομα)
);

CREATE TABLE Εισηγητής_Τμήμα (
Εισηγητής_κωδ varchar2(20) FOREIGN KEY REFERENCES Εισηγητής(Εισηγητής_Κωδ),
Τμήμα varchar2(25) FOREIGN KEY REFERENCES Τμήμα(Τμήμα_Όνομα)
CONSTRAINT pk_ProffDept PRIMARY KEY (Εισηγητής_κωδ,Τμήμα)
);

CREATE TABLE Μάθημα (
Τίτλος char(60),
Περιγραφή varchar2(200),
Τμήμα varchar2(20) FOREIGN KEY REFERENCES Τμήμα(Τμήμα_Όνομα)
CONSTRAINT pk_TitleDept PRIMARY KEY (Τίτλος,Τμήμα)
);

CREATE TABLE Πρόγραμμα (
Πρόγραμμα_Κωδ varchar2(20) CONSTRAINT pk_ScheduleCode PRIMARY KEY,
Περιγραφή varchar2(200) NOT NULL,
Ημέρα number NOT NULL,
Έναρξη date NOT NULL,
Διάρκεια number NOT NULL
);

CREATE TABLE Αίθουσα (
Αίθουσα_Κωδ varchar2(20) CONSTRAINT pk_HallCode PRIMARY KEY,
Περιγραφή varchar2(25),
Πρόγραμμα varchar2(20) FOREIGN KEY REFERENCES Πρόγραμμα(Πρόγραμμα_Κωδ),
Τοποθεσία varchar2(25) NOT NULL,
Αριθμ_φοιτητών varchar2(2) NOT NULL
);

CREATE TABLE Τοποθεσία_Αίθουσας (
Κτίριο number,
Αίθουσα varchar2(25) FOREIGN KEY REFERENCES Αίθουσα(Περιγραφή)
CONSTRAINT pk_BuildHall PRIMARY KEY (Κτίριο,Αίθουσα)
);

CREATE TABLE Τάξη (
Τάξη_Id varchar2(5) CONSTRAINT pk_ClassCode PRIMARY KEY,
Τμήμα varchar2(20) FOREIGN KEY REFERENCES Τμήμα(Τμήμα_Όνομα),
Πρόγραμμα varchar2(20) FOREIGN KEY REFERENCES Πρόγραμμα(Πρόγραμμα_Κωδ),
Εισηγητής varchar2(20) FOREIGN KEY REFERENCES Εισηγητής(Εισηγητής_Κωδ),
Μάθημα char(60) FOREIGN KEY REFERENCES Μάθημα(Τίτλος),
Εξάμηνο varchar2(6) NOT NULL,
Σχολ_Χρονιά varchar2(15)
);

CREATE TABLE Βαθμολογία (
User_name varchar(20) FOREIGN KEY REFERENCES Φοιτητής(User_name),
ΑΕΜ_Φοιτητή varchar2(15) FOREIGN KEY REFERENCES Φοιτητής(ΑΜ),
Τίτλος_Μαθήματος char(60) FOREIGN KEY REFERENCES Μάθημα(Τίτλος),
Βαθμός number CONSTRAINT digits_Grade Check(Βαθμός > 0 and Βαθμός < 11),
Ημερομ_Βαθμολ date
CONSTRAINT pk_Grade PRIMARY KEY (AEM_Φοιτητή,Μάθημα,Βαθμός)
);


CREATE VIEW my_grades AS SELECT * FROM Βαθμολογία WHERE User_name=user;
CREATE VIEW my_profile AS SELECT * FROM Φοιτητής WHERE User_name=user;
CREATE VIEW proffesor_public AS SELECT Εισηγητής_κωδ,Όνομα,Επίθετο,Θέση,Email FROM Εισηγητής

CREATE PROCEDURE edit_profile (addr in varchar2,city in varchar2, postal_code in number, email in varchar2) AS
BEGIN
UPDATE Φοιτητής
SET Διεύθυνση=addr,Πόλη=city,Ταχ_Κωδ=postal_code,Email=email
WHERE User_name=user
END edit_profile;

CREATE PROCEDURE update_dept_in_lesson (lesson in char, dept in varchar2)
BEGIN
UPDATE Μάθημα
SET Τμήμα=dept
WHERE Τίτλος=lesson
END update_dept_in_lesson;

CREATE PROCEDURE update_schedule_in_hall (hall in varchar2, schedule in varchar2)
BEGIN
UPDATE Αίθουσα
SET Πρόγραμμα=schedule
WHERE Αίθουσα_Κωδ=hall
END update_schedule_in_hall;

CREATE ROLE Φοιτητής NOT IDENTIFIED
CREATE USER Φοιτητής_i IDENTIFIED BY secret_i
GRANT SELECT ON my_grades,my_profile,proffesor_public,Τμήμα,Εισηγητής_Τμήμα,Μάθημα,Πρόγραμμα,Αίθουσα,Τοποθεσία_Αίθουσας,Τάξη TO Φοιτητής;
GRANT EXECUTE ON edit_profile TO Φοιτητής
GRANT Φοιτητής TO Φοιτητής_i

CREATE USER Υπεύθυνος_Γραμματείας IDENTIFIED BY secret1
GRANT SELECT,INSERT,UPDATE,DELETE ON Φοιτητής,Τμήμα,Εισηγητής,Εισηγητής_Τμήμα,Μάθημα,Πρόγραμμα,Αίθουσα,Τοποθεσία_Αίθουσας,Τάξη,Βαθμολογία ΤΟ Υπεύθυνος_Γραμματείας

CREATE USER Υπεύθυνος_Τμημάτων_Προγραμμάτων IDENTIFIED BY secret2
GRANT SELECT ON Τμήμα,professor_public,Εισηγητής_Τμήμα,Μάθημα,Πρόγραμμα,Αίθουσα,Τάξη TO Υπεύθυνος_Γραμματείας
GRANT EXECUTE ON update_schedule_in_hall TO Υπεύθυνος_Τμημάτων_Προγραμμάτων
GRANT UPDATE,INSERT,DELETE ON Πρόγραμμα,Τάξη TO Υπεύθυνος_Γραμματείας
