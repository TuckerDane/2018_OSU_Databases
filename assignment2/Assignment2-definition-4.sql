-- [x] For part one of this assignment you are to make a database with the following specifications and run the following queries
-- [x] Table creation queries should immedatley follow the drop table queries, this is to facilitate testing on my end

DROP TABLE IF EXISTS `works_on`;
DROP TABLE IF EXISTS `project`;
DROP TABLE IF EXISTS `client`;
DROP TABLE IF EXISTS `employee`;

-- [x] Create a table called client with the following properties:
	-- [x] id - an auto incrementing integer which is the primary key
	-- [x] first_name - a varchar with a maximum length of 255 characters, cannot be null
	-- [x] last_name - a varchar with a maximum length of 255 characters, cannot be null
	-- [x] dob - a date type (you can read about it here http://dev.mysql.com/doc/refman/5.0/en/datetime.html)
	-- [x] the combination of the first_name and last_name must be unique in this table

CREATE TABLE client (
    id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    dob date,
    UNIQUE (first_name, last_name)
);

-- [x] Create a table called employee with the following properties:
	-- [x] id - an auto incrementing integer which is the primary key
	-- [x] first_name - a varchar of maximum length 255, cannot be null
	-- [x] last_name - a varchar of maximum length 255, cannot be null
	-- [x] dob - a date type 
	-- [x] date_joined - a date type 
	-- [x] the combination of the first_name and last_name must be unique in this table

CREATE TABLE employee (
    id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    dob date,
    date_joined date,
    UNIQUE (first_name, last_name)
);

-- [x] Create a table called project with the following properties:
	-- [x] id - an auto incrementing integer which is the primary key
	-- [x] cid - an integer which is a foreign key reference to the client table
	-- [x] name - a varchar of maximum length 255, cannot be null
	-- [x] notes - a text type
	-- [x] the name of the project should be unique in this table

CREATE TABLE project (
    id int PRIMARY KEY AUTO_INCREMENT,
    cid int,
    name varchar(255) NOT NULL UNIQUE,
    notes text,
    FOREIGN KEY (cid) REFERENCES client(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- [x] Create a table called works_on with the following properties, this is a table representing a many-to-many relationship
	-- [x] between employees and projects:
	-- [x] eid - an integer which is a foreign key reference to employee
	-- [x] pid - an integer which is a foreign key reference to project
	-- [x] start_date - a date type 
	-- [x] the primary key is a combination of eid and pid

CREATE TABLE works_on (
    eid int,
    pid int,
    start_date date,
    FOREIGN KEY (eid) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (eid, pid)
);

-- [x] insert the following into the client table:

	-- [x] first_name: Sara
	-- [x] last_name: Smith
	-- [x] dob: 1/2/1970
	INSERT INTO client (first_name, last_name, dob) VALUES ("Sara", "Smith", '1970-01-02');

	-- [x] first_name: David
	-- [x] last_name: Atkins
	-- [x] dob: 11/18/1979
	INSERT INTO client (first_name, last_name, dob) VALUES ("David", "Atkins", '1979-11-18');

	-- [x] first_name: Daniel
	-- [x] last_name: Jensen
	-- [x] dob: 3/2/1985
	INSERT INTO client (first_name, last_name, dob) VALUES ("Daniel", "Jensen", '1985-03-02');


-- [x] insert the following into the employee table:

	-- [x] first_name: Adam
	-- [x] last_name: Lowd
	-- [x] dob: 1/2/1975
	-- [x] date_joined: 1/1/2009
	INSERT INTO employee (first_name, last_name, dob, date_joined) VALUES ("Adam", "Lowd", '1975-01-02', '2009-01-01');

	-- [x] first_name: Michael
	-- [x] last_name: Fern
	-- [x] dob: 10/18/1980
	-- [x] date_joined: 6/5/2013
	INSERT INTO employee (first_name, last_name, dob, date_joined) VALUES ("Michael", "Fern", '1980-10-18', '2013-06-05');

	-- [x] first_name: Deena
	-- [x] last_name: Young
	-- [x] dob: 3/21/1984
	-- [x] date_joined: 11/10/2013
	INSERT INTO employee (first_name, last_name, dob, date_joined) VALUES ("Deena", "Young", '1984-03-21', '2013-11-10');


-- [x] insert the following project instances into the project table 
-- [x] you should use a subquery to set up foriegn key referecnes, no hard coded numbers

	-- [x] cid - reference to first_name: Sara last_name: Smith
	-- [x] name - Diamond
	-- [x] notes - Should be done by Jan 2017
	INSERT INTO project (cid, name, notes) VALUES ((SELECT id FROM client WHERE first_name = "Sara" AND last_name = "Smith"), "Diamond", "Should be done by Jan 2017");

	-- [x] cid - reference to first_name: David last_name: Atkins
	-- [x] name - Eclipse
	-- [x] notes - NULL
	INSERT INTO project (cid, name, notes) VALUES ((SELECT id FROM client WHERE first_name = "David" AND last_name = "Atkins"), "Eclipse", NULL);

	-- [x] cid - reference to first_name: Daniel last_name: Jensen
	-- [x] name - Moon 
	-- [x] notes - NULL
	INSERT INTO project (cid, name, notes) VALUES ((SELECT id FROM client WHERE first_name = "Daniel" AND last_name = "Jensen"), "Moon", NULL);

-- [x] insert the following into the works_on table 
-- [x] use subqueries to look up data as needed:

	-- [x] employee: Adam Lowd
	-- [x] project: Diamond
	-- [x] start_date: 1/1/2012
	INSERT INTO works_on (eid, pid, start_date) VALUES ((SELECT id FROM employee WHERE first_name = "Adam" AND last_name = "Lowd"), (SELECT id FROM project WHERE name = "Diamond"), '2012-01-01');

	-- [x] employee: Michael Fern
	-- [x] project: Eclipse
	-- [x] start_date: 8/8/2013
	INSERT INTO works_on (eid, pid, start_date) VALUES ((SELECT id FROM employee WHERE first_name = "Michael" AND last_name = "Fern"), (SELECT id FROM project WHERE name = "Eclipse"), '2013-08-08');

	-- [x] employee: Michael Fern
	-- [x] project: Moon
	-- [x] start_date: 9/11/2014
	INSERT INTO works_on (eid, pid, start_date) VALUES ((SELECT id FROM employee WHERE first_name = "Michael" AND last_name = "Fern"), (SELECT id FROM project WHERE name = "Moon"), '2014-09-11');