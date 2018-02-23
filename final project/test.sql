-- ITEM TABLE

DROP TABLE IF EXISTS `item`;
CREATE TABLE item (
    `item_id` int PRIMARY KEY AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `weight` int,
    `manufactureDate` date,
    `expirationDate` date
) ENGINE=InnoDB;

-- insert into item table
LOCK TABLES `item` WRITE;
INSERT INTO `item` (`name`, `weight`, `manufactureDate`, `expirationDate`) 
VALUES  ("Backpack", 5, NULL, NULL),						-- 1
    	("Cooler", 10, NULL, NULL),							-- 2
    	("Pelican Case", 7, NULL, NULL),					-- 3
    	("Harness", 1, "2011-01-01", "2016-01-01"),			-- 4
    	("Climbing Shoes", 5, "2017-01-01", "2017-02-01"),	-- 5
    	("Helmet", 1, "2017-02-22", "2018-08-13"),			-- 6
    	("Potatos", 5, NULL, NULL),							-- 7
    	("Clif Bars", 1, NULL, NULL);						-- 8
UNLOCK TABLES;

-- FOOD TABLE

DROP TABLE IF EXISTS `item_food`;
CREATE TABLE item_food (
  `item_id` int PRIMARY KEY NOT NULL,
  `calories` int,
  `fat` int,
  `protein` int,
  FOREIGN KEY (`item_id`) REFERENCES `item`(`item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert food item information
LOCK TABLES `item_food` WRITE;
INSERT INTO `item_food` (`item_id`, `calories`, `fat`, `protein`) 
VALUES  (7, 100, 200, 0), (8, 150, 70, 30);
UNLOCK TABLES;

-- EQUIPMENT TABLE

DROP TABLE IF EXISTS `item_equipment`;
CREATE TABLE item_equipment (
  `item_id` int PRIMARY KEY NOT NULL,
  `description` varchar(255),
  FOREIGN KEY (`item_id`) REFERENCES `item`(`item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert equipment item information
LOCK TABLES `item_equipment` WRITE;
INSERT INTO `item_equipment` (`item_id`, `description`) 
VALUES  (1, "carry stuff!"), (2, "keep stuff cool"), (3, "storage"), (4, "holding you as you climb"), (5, "sticking to the wall"), (6, "protect your noggin");
UNLOCK TABLES;

-- CONTAINER TABLE

DROP TABLE IF EXISTS `item_container`;
CREATE TABLE item_container (
  `container_item_id` int,
  `contained_item_id` int PRIMARY KEY,
  FOREIGN KEY (`container_item_id`) REFERENCES `item`(`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`contained_item_id`) REFERENCES `item`(`item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert contents into container items
LOCK TABLES `item_container` WRITE;
INSERT INTO `item_container` (`container_item_id`, `contained_item_id`) 
VALUES  (1, 4), (1, 5), (1, 6), (2, 7), (3, 1);
UNLOCK TABLES;