SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

DROP DATABASE `ebill`;
CREATE DATABASE IF NOT EXISTS `ebill` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `ebill`;

-- Table structure for table `user`

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(14) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `pass` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserting data for table `admin`

INSERT INTO admin (name,email,pass) VALUES
("admin1","bhakti@bijli.com","admin"),
("admin2","vrushali@bijli.com","admin");

-- Table structure for table `user`

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(14) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  `name` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `pass` varchar(20) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserting data for table `user`

INSERT INTO user (name,email,phone,pass,address) VALUES
("Vijaya","vij@gmail.com",9654327656,"qwerty","Jamia nagar"),
("Shri","Shri@gmail.com",999999999,"qwerty","Ghaziabad"),
("Anaya","anayal@gmail.com",9888888888,"qwerty","Batla House"),
("Manoj","manoj@gmail.com",9777777777,"qwerty","Shaheen Bagh"),
("abc","abc@gmail.com",9666666666,"qwerty","Jamia"),
("xyz","xyz@gmail.com",9999988888,"qwerty","Dwarka");

-- Table structure for table `bill`

DROP TABLE IF EXISTS `bill`;
CREATE TABLE IF NOT EXISTS `bill` (
  `id` int(14) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `aid` int(14) NOT NULL,
  `uid` int(14) NOT NULL,
  `units` int(10) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(10) NOT NULL,
  `bdate` date NOT NULL,
  `ddate` date NOT NULL,
  FOREIGN KEY (aid) REFERENCES admin(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (uid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- stored procedure to handle duedate and amount(units*rateperunit)

-- Table structure for table `transaction`

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` int(14) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `bid` int(14) NOT NULL ,
  `payable` decimal(10,2) NOT NULL,
  `pdate` DATE ,
  `status` varchar(10) NOT NULL,
  FOREIGN KEY (bid) REFERENCES bill(id) ON DELETE CASCADE ON UPDATE CASCADE
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for table `complaint`

DROP TABLE IF EXISTS `complaint`;
CREATE TABLE IF NOT EXISTS `complaint` (
  `id` int(14) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` int(14) NOT NULL,
  `aid` int(14) NOT NULL,
  `complaint` varchar(140) NOT NULL,
  `status` varchar(40) NOT NULL,
  FOREIGN KEY (aid) REFERENCES admin(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (uid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for table `unitsRate`

DROP TABLE IF EXISTS `unitsRate`;
CREATE TABLE IF NOT EXISTS `unitsRate` (
  `sno` int(1),
  `twohundred` int(14) NOT NULL,
  `fivehundred` int(14) NOT NULL,
  `thousand` int(14) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserting data for table `unitsRate`

INSERT INTO unitsRate VALUES(1,2,5,10);

-- STORED PROCEDURE TO MULTIPLY UNITS * RATE TO GET AMOUNT

DELIMITER $$
DROP PROCEDURE IF EXISTS `unitstoamount`;
$$
CREATE PROCEDURE `unitstoamount`( IN units INT(14) , OUT result INT(14))
BEGIN
   
    DECLARE a INT(14) DEFAULT 0;
    DECLARE b INT(14) DEFAULT 0;
    DECLARE c INT(14) DEFAULT 0;

    SELECT twohundred FROM unitsRate INTO a ;
    SELECT fivehundred FROM unitsRate INTO b ;
    SELECT thousand FROM unitsRate INTO c  ;

    IF units<200
    then
        SELECT a*units INTO result;
    
    ELSEIF units<500
    then
        SELECT (a*200)+(b*(units-200)) INTO result;
    ELSEIF units > 500
    then
        SELECT (a*200)+(b*(300))+(c*(units-500)) INTO result;
    END IF;

END $$
DELIMITER ;
-- CALL UNITSTOAMOUNT BY : CALL unitstoamount(700,@x)// 

-- FUNCTION TO GET CURRENT DATE(1ST OF MONTH)

DELIMITER $$
DROP FUNCTION IF EXISTS `curdate1`;
$$
CREATE FUNCTION `curdate1`()
returns int
BEGIN
    DECLARE x INT;
    SET x = DAYOFMONTH(CURDATE());
    IF (x=1)
    THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END $$
DELIMITER ;
