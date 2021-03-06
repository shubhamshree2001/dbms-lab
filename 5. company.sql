
EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY,SUPERSSN,DNO)
DEPARTMENT(DNO,DNAME,MGRSSN,MGRSTARTDATE)
DLOCATION(DNO,DLOC)
PROJECT(PNO,PNAME,PLOCATION,DNO)
WORKS_ON(SSN,PNO,HOURS)

1.Make a list of all project members for
 projects that involve an employee whose name is SCOTT either as a worker or as a manager of the department that controls the project. 
Show the resulting salry for employee working on IOT project is given a 10% raise.

3.Find the sum of salaries of all employees of ‘ACCOUNTS’ department as well as the MAX(SAL),MIN(SAL),AVG(SAL) in this department.
.Retrive the name of each employee who works on all the projects controlled  by department 
   no. 5.(use NOT EXISTS ) operator.

5.For each department that has more than 5 employees retrieve the dno and no. of its employees who are making more than 6,00,000.

..........................................................................................................................................................
CREATE TABLE EMPLOYEE(
SSN NUMBER(3) PRIMARY KEY,
NAME VARCHAR(20),
ADDRESS VARCHAR(20),
SEX CHAR(1),
SALARY NUMBER(10,2),
SUPERSSN NUMBER(3) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
DNO NUMBER(2) );

CREATE TABLE DEPARTMENT(
DNO NUMBER(2) PRIMARY KEY,
DNAME VARCHAR(20),
MGRSSN NUMBER(3) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
MGRSTARTDATE DATE);

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DNO) REFERENCES DEPARTMENT(DNO) ON DELETE CASCADE;

CREATE TABLE DLOCATION(
DNO NUMBER(3) REFERENCES DEPARTMENT(DNO) ON DELETE CASCADE,
DLOC VARCHAR(20),
PRIMARY KEY(DNO,DLOC));

CREATE TABLE PROJECT(
PNO NUMBER(3) PRIMARY KEY,
PNAME VARCHAR(20),
PLOCATION VARCHAR(20),
DNO NUMBER(3) REFERENCES DEPARTMENT(DNO) ON DELETE CASCADE);

CREATE TABLE WORKS_ON(
SSN NUMBER(3) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
PNO NUMBER(3) REFERENCES PROJECT(PNO) ON DELETE CASCADE,
HOURS NUMBER(1),
PRIMARY KEY(SSN,PNO));

INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(11,'VISHAL','BANGLORE','M',500000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(12,'SCOTT','DELHI','M',800000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(13,'SHREYAN','BANGLORE','M',500000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(14,'SAIRIN','BANGLORE','F',900000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(15,'GOPAL','BANGLORE','M',700000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(16,'NEELU','BANARAS','M',500000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(17,'SHUBHAM','BANGLORE','M',500000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(18,'SHIVA','BANGLORE','M',400000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(19,'SHLOK','BANGLORE','M',100000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(20,'SANGAM','BANGLORE','M',600000);
INSERT INTO EMPLOYEE(SSN,NAME,ADDRESS,SEX,SALARY) VALUES(21,'SAM','BANGLORE','M',600020);

INSERT INTO DEPARTMENT VALUES(1,'ACCOUNTS',11,'11-JUN-2020');
INSERT INTO DEPARTMENT VALUES(2,'PR',14,'11-JUN-2019');
INSERT INTO DEPARTMENT VALUES(3,'HR',13,'11-JUN-2018');
INSERT INTO DEPARTMENT VALUES(4,'TEC',12,'11-JUN-2010');
INSERT INTO DEPARTMENT VALUES(5,'RESEARCH',18,'11-JUN-2011');

UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=1 WHERE SSN=11;
UPDATE EMPLOYEE SET SUPERSSN=11 , DNO=4 WHERE SSN=12;
UPDATE EMPLOYEE SET SUPERSSN=NULL, DNO=3 WHERE SSN=13;
UPDATE EMPLOYEE SET SUPERSSN=15 , DNO=2 WHERE SSN=14;
UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=4  WHERE SSN=15;
UPDATE EMPLOYEE SET SUPERSSN=15 , DNO=4 WHERE SSN=16;
UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=4 WHERE SSN=17;
UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=5 WHERE SSN=18;
UPDATE EMPLOYEE SET SUPERSSN= 20 , DNO=4 WHERE SSN=19;
UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=4 WHERE SSN=20;
UPDATE EMPLOYEE SET SUPERSSN=NULL , DNO=1 WHERE SSN=21;



INSERT INTO PROJECT VALUES(101,'IOT','BANGLORE',1);
INSERT INTO PROJECT VALUES(102,'ML','BANGLORE',2);
INSERT INTO PROJECT VALUES(103,'CLOUD','BANGLORE',3);
INSERT INTO PROJECT VALUES(104,'WEB','BANGLORE',5);
INSERT INTO PROJECT VALUES(105,'AND','BANGLORE',5);
INSERT INTO PROJECT VALUES(106,'FLU','BANGLORE',4);
INSERT INTO PROJECT VALUES(107,'XANGO','BANGLORE',4);
INSERT INTO PROJECT VALUES(108,'AWS','BANGLORE',5);

INSERT INTO DLOCATION VALUES(1,'DELHI');

INSERT INTO DLOCATION VALUES(2,'BANGLORE');

INSERT INTO DLOCATION VALUES(3,'BANGLORE');

INSERT INTO DLOCATION VALUES(4,'BANGLORE');

INSERT INTO DLOCATION VALUES(5,'BANGLORE');


INSERT INTO WORKS_ON VALUES(11,101,6);
INSERT INTO WORKS_ON VALUES(12,102,6);
INSERT INTO WORKS_ON VALUES(13,104,6);
INSERT INTO WORKS_ON VALUES(13,105,6);
INSERT INTO WORKS_ON VALUES(13,108,6);
INSERT INTO WORKS_ON VALUES(15,106,6);
INSERT INTO WORKS_ON VALUES(16,107,6);
INSERT INTO WORKS_ON VALUES(17,108,6);

.............................................................................................................................................................................................................................................................
.............................................................................................
                                                                                                       .......................................................................................................
--1
(SELECT P.PNO FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
WHERE P.DNO=D.DNO AND E.SSN=D.MGRSSN AND E.NAME='SCOTT')
UNION
(
SELECT P1.PNO FROM PROJECT P1,WORKS_ON W, EMPLOYEE E1
WHERE P1.PNO=W.PNO AND E1.SSN=W.SSN AND E1.NAME='SCOTT');


--2
SELECT E.NAME , 1.1*E.SALARY AS HIKE_SAL FROM PROJECT P , WORKS_ON W, EMPLOYEE E
WHERE P.PNO=W.PNO AND E.SSN=W.SSN AND P.PNAME='IOT';

--3            
            
SELECT MAX(E.SALARY) AS MAX_SAL, SUM(E.SALARY) AS SUM_SAL,
MIN(E.SALARY) AS MIN_SAL , AVG(E.SALARY) AS AVG_SAL  FROM EMPLOYEE E , DEPARTMENT D
WHERE E.DNO=D.DNO AND D.DNAME='ACCOUNTS';

            
            
--4
SELECT E.NAME FROM EMPLOYEE E  WHERE
NOT EXISTS( (SELECT P.PNO FROM PROJECT P WHERE P.DNO=5) MINUS (SELECT W.PNO FROM WORKS_ON W WHERE 
E.SSN=W.SSN));



--5
 SELECT DNO , COUNT(*) AS NO_OF_EMP FROM EMPLOYEE
WHERE Salary>600000 and dno in(
       select dno from employee group by(dno)
        having count(*)>5)
    group by dno;

