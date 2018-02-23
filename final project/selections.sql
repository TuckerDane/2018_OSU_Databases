-- select everything inside of the backpack
SELECT I.name FROM item I
INNER JOIN item_container IC ON I.item_id=IC.contained_item_id
WHERE IC.container_item_id=1;

-- select everything inside of the cooler
SELECT I.name FROM item I
INNER JOIN item_container IC ON I.item_id=IC.contained_item_id
WHERE IC.container_item_id=2;

-- select everything inside of the pelican case
SELECT I.name FROM item I
INNER JOIN item_container IC ON I.item_id=IC.contained_item_id
WHERE IC.container_item_id=3;

-- find the weight of a specific item

-- find the weight of the contents of an item

-- find the sum of the weight of contents of an item

-- find the sum plus the weight of an item and its contents

-- find the above, nested

-- find the weight of all items inside of the bakcpack, including the backpack


-- find the weight of all items inside of the pelican case, including nested containers and including the pelican case

-- select only food items: The id,name, weight, protein, carbs, calories
SELECT I.item_id, I.name, I.weight, F.calories, F.fat, F.protein FROM item I
INNER JOIN item_food F ON I.item_id=F.item_id;

-- select only equipment items: The id, name, weight, manufacture date, expiration date, and description
SELECT I.item_id, I.name, I.weight, I.manufactureDate, I.expirationDate, E.description FROM item I
INNER JOIN item_equipment E ON I.item_id=E.item_id;

-- select only container names
SELECT I.item_id, I.name FROM item I
INNER JOIN item_container C ON I.item_id=C.container_item_id;
-- select contained names from containers
SELECT I.item_id, I.name FROM item I
INNER JOIN item_container C ON I.item_id=C.contained_item_id;

-- select names of containers and their contents
SELECT CTR.name AS "container", CTD.name AS "contents" FROM
(SELECT I1.item_id, I1.name, IC1.container_item_id FROM item I1 INNER JOIN item_container IC1 ON I1.item_id=IC1.container_item_id) as CTR
INNER JOIN
(SELECT I2.item_id, I2.name, IC2.container_item_id, IC2.contained_item_id FROM item I2 INNER JOIN item_container IC2 ON I2.item_id=IC2.contained_item_id) as CTD ON CTR.container_item_id=CTD.container_item_id
GROUP BY CTD.item_id
ORDER BY CTR.item_id;



INSERT INTO item (name, weight) VALUES ("test food", 2); INSERT INTO item_food ( item_id, calories, fat, protein) VALUES ((SELECT MAX(item_id) FROM item), 2, 2, 2);