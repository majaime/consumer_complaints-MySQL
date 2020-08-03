/* Initially, any existing schema with the same name is removed
and a new schema is created, and chosen as the working schema */
DROP SCHEMA consumer_complaints;
CREATE SCHEMA consumer_complaints;
USE consumer_complaints;

/* Creating a matching table with columns in the ".csv" file */
CREATE TABLE complaints (
	`Date received` varchar(255) NOT NULL, /* Date here is created as a string and
											later will be changed to DATE parameter*/
	`Product` varchar(360) NULL,
    `Sub-product` varchar(255) NULL,
    `Issue` varchar(255) NULL,
	`Sub-issue` varchar(255) NULL,
	`Consumer complaint narrative` varchar(255) NULL,
	`Company public response` varchar(255) NULL,
    `Company` varchar(255) NULL,
    `State` varchar(255) NULL,
	`ZIP code` varchar(255) NULL,
	`Tags` varchar(255) NULL,
	`Consumer consent provided?` varchar(255) NULL,
	`Submitted via` varchar(255) NULL,
	`Date sent to company` varchar(255) NULL,
	`Company response to consumer` varchar(255) NULL,
	`Timely response?` varchar(255) NULL,
	`Consumer disputed?` varchar(255) NULL,
	`Complaint ID` varchar(255) NOT NULL,
    PRIMARY KEY (`Date received`)
);

/* Importing data from ".csv" file into the above table */
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/complaints.csv'
INTO TABLE complaints
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* Making a new column, changing "Date received" to DATE parameter,
removing the inital column, and then renaming the new column to "Date received" */
ALTER TABLE complaints
ADD `Date` DATE FIRST;
UPDATE complaints
SET Date = STR_TO_DATE(`Date received`,'%c/%e/%Y');

ALTER TABLE complaints
DROP COLUMN `Date received`;

ALTER TABLE complaints
RENAME COLUMN `Date` TO `Date received`;


/* Extracting the data according to the criteria in the problem statement */
CREATE TABLE report AS
	(SELECT LOWER(`Product`) AS Product, 2019 AS Year, COUNT(Product) AS `Total Complaints`,
		2 AS `Companies Total`, ROUND(100*2/COUNT(Product)) AS `Percentage`
	FROM complaints
	WHERE  `Date received` BETWEEN "2019-01-01" AND "2020-01-01"
		AND	`Product` = "Credit reporting, credit repair services, or other personal consumer reports")
    
    UNION
	
    (SELECT LOWER(`Product`) AS Product, 2020 AS Year, COUNT(Product) AS `Total Complaints`,
		1 AS `Companies Total`, ROUND(100*1/COUNT(Product)) AS `Percentage`
	FROM complaints
	WHERE  `Date received` > "2020-01-01"
		AND	`Product` = "Credit reporting, credit repair services, or other personal consumer reports")  
	
    UNION
	
    (SELECT LOWER(`Product`) AS Product, 2019 AS Year, COUNT(Product) AS `Total Complaints`,
		1 AS `Companies Total`,  ROUND(100*1/COUNT(Product)) AS `Percentage`
	FROM complaints
	WHERE  `Date received` > "2019-01-01"
		AND	`Product` = "Debt collection");

/* Recording the extracted data in a ".csv" file */
SELECT *
FROM report
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/report.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ','
ESCAPED BY '"' 
LINES TERMINATED BY '\n';