module.exports = function(){
    var express = require('express');
    var router = express.Router();

    function getItems(res, mysql, context, complete){
        mysql.pool.query("SELECT item_id, name, weight, manufactureDate, expirationDate FROM item", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.item = results;
            complete();
        });
    }

    function getFood(res, mysql, context, complete){
        mysql.pool.query("SELECT I.item_id, I.name, I.weight, F.calories, F.fat, F.protein FROM item I INNER JOIN item_food F ON I.item_id=F.item_id", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.food = results;
            complete();
        });
    }    

    function getEquipment(res, mysql, context, complete){
        mysql.pool.query("SELECT I.item_id, I.name, I.weight, I.manufactureDate, I.expirationDate, E.description FROM item I INNER JOIN item_equipment E ON I.item_id=E.item_id", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.equipment = results;
            complete();
        });
    }   

    function getContainers(res, mysql, context, complete){
        mysql.pool.query("SELECT CTR.name AS 'container', CTD.name AS 'contents', CTD.item_id FROM (SELECT I1.item_id, I1.name, IC1.container_item_id FROM item I1 INNER JOIN item_container IC1 ON I1.item_id=IC1.container_item_id) as CTR INNER JOIN (SELECT I2.item_id, I2.name, IC2.container_item_id, IC2.contained_item_id FROM item I2 INNER JOIN item_container IC2 ON I2.item_id=IC2.contained_item_id) as CTD ON CTR.container_item_id=CTD.container_item_id GROUP BY CTD.item_id ORDER BY CTR.item_id", function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.container = results;
            complete();
        });
    } 

    function getItem(res, mysql, context, id, complete){
        var sql = "SELECT item_id, name, weight, manufactureDate, expirationDate FROM item WHERE item_id = ?";
        var inserts = [id];
        mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.item = results[0];
            complete();
        });
    }

    /*Display all items. Requires web based javascript to delete users with AJAX*/

    router.get('/', function(req, res){
        var callbackCount = 0;
        var context = {};
        context.jsscripts = ["js/deleteitem.js", "js/removeitem.js"];
        var mysql = req.app.get('mysql');
        getFood(res, mysql, context, complete);
        getEquipment(res, mysql, context, complete);
        getContainers(res, mysql, context, complete);
        getItems(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 4){
                res.render('pack', context);
            }

        }
    });

    /* Display one item for the specific purpose of updating it */

    router.get('/:id', function(req, res){
        callbackCount = 0;
        var context = {};
        context.jsscripts = ["js/updateitem.js"];
        var mysql = req.app.get('mysql');
        getItem(res, mysql, context, req.params.id, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('update-item', context);
            }

        }
    });

    /* Adds a food item, redirects to the pack page after adding */

    router.post('/addFood', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO item (name, weight) VALUES (?, ?)";
        var sql2 = "INSERT INTO item_food ( item_id, calories, fat, protein) VALUES ((SELECT MAX(item_id) FROM item), ?, ?, ?)";
        var inserts = [req.body.foodName, req.body.foodWeight, req.body.calories, req.body.fat, req.body.protein];
        var inserts2 = [req.body.calories, req.body.fat, req.body.protein]

        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{

            }
        });
        sql = mysql.pool.query(sql2,inserts2,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/pack');
            }
        });
    });

    /* Adds an equipment item, redirects to the pack page after adding */

    router.post('/addEquipment', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO item (name, weight, manufactureDate, expirationDate) VALUES (?, ?, ?, ?)";
        var sql2 = "INSERT INTO item_equipment (item_id, description) VALUES ((SELECT MAX(item_id) FROM item), ?)";
        var inserts = [req.body.equipmentName, req.body.equipmentWeight, req.body.equipmentManDate, req.body.equipmentExpDate];
        var inserts2 = [req.body.equipmentDescription];

        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{

            }
        });
        sql = mysql.pool.query(sql2,inserts2,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/pack');
            }
        });
    });

    /* Packs equipment item, redirects to the pack page after adding */

    router.post('/packItem', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO item_container (container_item_id, contained_item_id) VALUES (?, ?)";
        var inserts = [req.body.container, req.body.contents];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.redirect('/pack');
            }
        });
    });

    /* The URI that update data is sent to in order to update an item */

    router.put('/:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "UPDATE item SET name=?, weight=? WHERE item_id=?";
        var inserts = [req.body.name, req.body.weight, req.params.id];
        sql = mysql.pool.query(sql,inserts,function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }else{
                res.status(200);
                res.end();
            }
        });
    });

    /* Route to delete an item, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/item:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM item WHERE item_id = ?";
        var inserts = [req.params.id];
        sql = mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.status(400);
                res.end();
            }else{
                res.status(202).end();
            }
        });
    });

    /* Route to remove an item from a container, simply returns a 202 upon success. Ajax will handle this. */

    router.delete('/contents:id', function(req, res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM item_container WHERE contained_item_id = ?";
        var inserts = [req.params.id];
        sql = mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.status(400);
                res.end();
            }else{
                res.status(202).end();
            }
        });
    });

    return router;
}();
