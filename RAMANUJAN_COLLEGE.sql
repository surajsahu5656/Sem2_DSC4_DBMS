CREATE DATABASE RAMANUJAN_COLLEGE;

USE RAMANUJAN_COLLEGE;

CREATE TABLE STUDENT(
ROLL_NO CHAR(6) PRIMARY KEY NOT NULL,
STUDENTNAME VARCHAR(20),                                                                                                                                                                                                                                                                                                                                                                                                                                          
COURSE VARCHAR(	16),
DOB DATE NOT NULL);

CREATE TABLE SOCIETY (
SOCID CHAR(6) PRIMARY KEY NOT NULL ,
SOCNAME	VARCHAR(20) ,
MENTORNAME VARCHAR(15),
TOTALSEATS  INT UNSIGNED);

CREATE TABLE ENROLLMENT (
ROLL_NO  CHAR(6) ,
SID CHAR(6) NOT NULL,
DATEOFENROLLMENT DATE,
FOREIGN KEY (ROLL_NO) REFERENCES STUDENT (ROLL_NO),
FOREIGN KEY (SID) REFERENCES SOCIETY(SOCID));


#1. RETRIEVE NAMES OF STUDENT ENROLLED IN ANY SOCIETY.
SELECT STUDENTNAME 
FROM STUDENT
WHERE ROLL_NO IN (
    SELECT ROLL_NO
    FROM ENROLLMENT);


#2. RETRIEVE ALL SOIETY NAMES
SELECT  SOCNAME 
FROM SOCIETY;


#3. RETRIEVE STUDENT NAME FORM STUDENT TABLE WHOSE NAME STARTING WITH LETTER "A"
SELECT STUDENTNAME 
FROM STUDENT 
WHERE STUDENTNAME LIKE 'A%' ; 


#4. RETRIEVE STUDENT'S DETAILS STUDYING IN COURSE "COMPUTERSCIENCE" OR "CHEMISTRY"
SELECT * FROM STUDENT 
WHERE COURSE LIKE "CHEMISTRY" OR COURSE LIKE 'C.S.';


#5. RETRIEVE STUDENT NAME WHOSE ROLLNO EITHER START WITH 'X' OR 'Z' AND ENDS WITH "9"
SELECT STUDENTNAME 
FROM STUDENT  
WHERE( ROLL_NO LIKE'X%' OR  ROLL_NO LIKE 'Z%' ) AND  ( ROLL_NO LIKE "%9" );


#7. UPDATE SOCIETY TABLE FOR MENTOR NAME OF A SPECIFIC SOCIETY
UPDATE SOCIETY 
SET MENTORNAME ="RAHUL KUMAR" 
WHERE MENTORNAME ="RAHUL" ;

 
#8. FIND SOCIETY NAMES  IN WHICH MORE THAN FIVE STUDENTS  HAVE ENROLLED
SELECT SOCNAME
FROM SOCIETY
WHERE SOCIETY.SOCID = (
	SELECT SID
    FROM ENROLLMENT
	GROUP BY SID
    HAVING (count(distinct roll_no))>5);


#9. FIND THE NAME OF YOUNGEST  STUDENT ENROLLED IN SOCIETY "NSS"
SELECT   STUDENTNAME 
FROM STUDENT
WHERE STUDENT.ROLL_NO IN (
	SELECT ROLL_NO 
	FROM ENROLLMENT 
	WHERE SID="16" ) 
	ORDER BY DOB ASC LIMIT 2;


#10. FIND THE MOST POPULAR SOCIETY NAME (ON BASIS  OF ENROLLED STUDENT )
SELECT SOCNAME  
FROM SOCIETY 
WHERE SOCIETY.SOCID = (
   SELECT SID 
   FROM ENROLLMENT 
   GROUP BY SID
   ORDER BY COUNT(DISTINCT ROLL_NO) DESC LIMIT 1);
   
   
#11. FIND THE NAME OF TWO LEAST POPULAR SOCIETIES (ON  THE BASIS OF ENROLLED STUDENT )
SELECT SOCNAME 
FROM SOCIETY 
WHERE SOCIETY.SOCID in  ( SELECT SID 
   FROM ENROLLMENT 
   GROUP BY SID
   ORDER BY COUNT(  ROLL_NO) ASC LIMIT 2);


#12. FIND STUDENT NAME WHO ARE NOT ENROLLED IN ANY SOCIETY
SELECT STUDENTNAME 
FROM STUDENT 
WHERE STUDENT.ROLL_NO !=(SELECT ROLL_NO FROM ENROLLMENT );


#13. FIND STUDENT NAMES ENROLLED IN  ATLEAST TWO SOCITIES  
SELECT STUDENTNAME 
FROM STUDENT 
WHERE STUDENT.ROLL_NO=(SELECT ROLL_NO FROM ENROLLMENT
WHERE  ENROLLMENT.SID=(SELECT SOCID FROM SOCIETY)
   GROUP BY ROLL_NO
   ORDER BY COUNT(SID)ASC LIMIT 1 );
   
   
#14. FIND THE SOCIETY NAME IN WHICH MAXIMUM STUDENT ARE ENROLLED
SELECT SOCNAME 
FROM SOCIETY
WHERE SOCIETY.SOCID = (SELECT SID 
   FROM ENROLLMENT 
   GROUP BY SID
   ORDER BY COUNT(DISTINCT ROLL_NO ) DESC LIMIT 1);


#15. FIND ALL STUDENTS NAME WHO HAVE  ENROLLED IN ANY SOCIETY AND  SOCIETY NAME IN WHICH ATLEST ON STUDENT HAS ENROLLED
SELECT   STUDENTNAME 
FROM STUDENT
WHERE ( STUDENT.ROLL_NO IN (SELECT ROLL_NO FROM ENROLLMENT));
SELECT SOCNAME FROM SOCIETY
WHERE  SOCIETY.SOCID IN (SELECT SID FROM ENROLLMENT GROUP BY SID 
HAVING COUNT(ROLL_NO )>=1);


#16. FIND THE STUDENT NAMES WHO HAVE ENROLLED IN ANY OF THE THREE SOCITETIES 'DEBATING '.' DANCE'. AND' SASHAKT'
SELECT STUDENTNAME FROM  STUDENT 
WHERE (STUDENT.ROLL_NO IN (SELECT ROLL_NO FROM ENROLLMENT 
WHERE SID ="17 "OR SID="18" OR SID="19"));


#17. FIND SOCIETY NAMES SUCH THAT ITS MENTOR HAS A NAME WITH "GUPTA" IN IT.
SELECT SOCNAME FROM SOCIETY 
WHERE MENTORNAME LIKE "%GUPTA%";


#18. FIND SOCIETY NAMES  IN WHICH THE  NUMBER OF ENROLLED  STUDENTS IS ONLY 10% OF IT CAPACITY 
SELECT SOCNAME FROM SOCIETY 
WHERE SOCIETY. SOCID IN (SELECT SID FROM ENROLLMENT
GROUP BY SID
HAVING  COUNT( ROLL_NO) =((SELECT TOTALSEATS FROM SOCIETY WHERE SOCIETY.SOCID= ENROLLMENT.SID) *(0.1) ));


#19. DISPLAY  THE VACANT SEAT FOR  EACH  SOCIETY 
SELECT SOCNAME,(SOCIETY.TOTALSEATS-COUNT(ROLL_NO)) AS VACANT_SEATS FROM ENROLLMENT
INNER JOIN SOCIETY ON SOCIETY.SOCID = ENROLLMENT.SID
GROUP BY SID;


#20. INCERMENT TOTAL SEAT OF SOCIETY BY 10%
SELECT SOCNAME,(SOCIETY.TOTALSEATS+((TOTALSEATS)*(0.1))) AS VACANT_SEATS FROM ENROLLMENT
INNER JOIN SOCIETY ON SOCIETY.SOCID = ENROLLMENT.SID
GROUP BY SID;


#21. ADD ENROLLMENT FEE PAID( YES/NO) FIELD IN THE ENROLLMENT TABLE
ALTER TABLE ENROLLMENT 
ADD ENROLLMENT_FEE_PAID  VARCHAR(5);
ALTER TABLE ENROLLMENT 
RENAME COLUMN ENROLLMENT_FEE_PAID TO ENROLLMENT_FEE_PAID;


#22. UPDATE DATE OF ENROLLMENT OF SOCIETY  IF SI TO 2018-01-15 "S2" TO CURRET DATE AND "S3" TO 2018-01-02
UPDATE ENROLLMENT 
SET DATEOFENROLLMENT 
=CASE SID
WHEN "S1" THEN '2018-01-15'
WHEN "S2" THEN CURRENT_DATE()
WHEN "S3" THEN '2018-01-02'
ELSE DATEOFENROLLMENT 
END
WHERE SID IN("S1","S2","S3");


#23. CREATE A VIEW TO KEEP TRACK OF SOCIETY NAMES WITH THE TOTAL NUMBER OF STUDENT ENROLLMENT  IN IT	
DROP VIEW VIEW_OF_SOCIETY;
CREATE VIEW VIEW_OF_SOCIETY AS
SELECT SOCNAME,(COUNT(ROLL_NO)) AS TOTAL_ROLL_NO FROM ENROLLMENT
INNER JOIN SOCIETY ON SOCIETY.SOCID = ENROLLMENT.SID
GROUP BY SID;
SELECT*FROM VIEW_OF_SOCIETY;


#24. FIND STUDENT NAME ENROLLED IN ALL THE SOEIETIES.
SELECT STUDENTNAME 
FROM STUDENT 
INNER JOIN ENROLLMENT ON  ENROLLMENT.ROLL_NO = STUDENT.ROLL_NO
WHERE SID = "123"AND "13"AND"14"AND "15" AND "16" AND"17" AND"18"AND"19"AND "S1" AND "S2" AND "S3";


#25. COUNT NUMBER OF SOCIETY WITH MORE THAN 5 STUDENT IN IT
SELECT SOCNAME 
FROM ENROLLMENT 
INNER JOIN SOCIETY ON SOCIETY.SOCID=ENROLLMENT.SID
GROUP BY SID
HAVING COUNT(ROLL_NO)>5;


#26 ADD COLUMN MOILE NUMBER IN STUDENT TABLE WITH DEFAULT VALUE "9999999999"
ALTER TABLE STUDENT
ADD COLUMN MOBILE_NO BIGINT DEFAULT  9999999999; 



#27 FIND THE TOTAL NUMBER OF STUDETS WHOSE AGE IS >20 YEARS
SELECT COUNT(STUDENTNAME) AS STUDENT_ABOVE_20_YEARS
FROM STUDENT
WHERE (CURRENT_DATE() )-(DOB)>20;


#28 FIND  NAMES  FO STUDENTS WHO ARE  BORN IN 2001 AND ARE ENROLLED IN AT LEAST SOCIETY 
SELECT  (STUDENTNAME) 
FROM STUDENT 
INNER JOIN ENROLLMENT ON (ENROLLMENT.ROLL_NO)=STUDENT.ROLL_NO
WHERE DOB LIKE "2001%";


#29 COUNT ALL SOCIETIES WHOSE NAME STARTS WITH "S" AND END WITH "T: AND AT LEAST 5 STUDENTS ARE ENROLLED IN THE SOCIETY.
SELECT COUNT( DISTINCT SOCNAME),SOCNAME
FROM SOCIETY 
INNER JOIN ENROLLMENT ON ENROLLMENT.SID=SOCIETY.SOCID
GROUP BY SID
HAVING SOCNAME LIKE "A%" AND SOCNAME LIKE "%A" AND COUNT(SID)>5;


#30 DISPLAY THE FOLLOWING INFORMATION:- (SOCIETY NAME ,MENTOR TOTAL CAPACIETY TOTAL ENROLLED ,UNFILLED SEATS)
SELECT SOCNAME,MENTORNAME,TOTALSEATS,(TOTALSEATS -(COUNT(ROLL_NO)))AS UNFILLED_SEATS,COUNT(ROLL_NO)AS TOTAL_ENROLLED
FROM SOCIETY
INNER JOIN ENROLLMENT ON ENROLLMENT.SID=SOCIETY.SOCID
GROUP BY SOCID;
