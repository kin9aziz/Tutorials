var express = require('express');
var app = express();
var fs = require("fs");

app.get('/listUsers', function (req, res) {
   fs.readFile( __dirname + "/" + "users.json", 'utf8', function (err, data) {
      console.log( data );
      res.end( data );
   });
})

app.post('/addUser', function (req, res) {
	let body = '';
    req.on('data', chunk => {
        body += chunk.toString(); // convert Buffer to string
    });
    req.on('end', () => {
        console.log(body);
        
		// First read existing users.
		fs.readFile( __dirname + "/" + "users.json", 'utf8', function (err, data) {
			data = JSON.parse( data );

			var userID = Math.round(new Date().getTime()/1000);
			var userName = JSON.parse(body).name;
			var newUser = {
				"id": userID,
				"name" : userName
			}

			data.push(newUser)
			console.log(data);

			fs.writeFile(__dirname + "/" + "users.json", JSON.stringify(data), (err) => {
			  if (err) throw err;
			  console.log('The file has been saved!');
			});

			res.end(JSON.stringify({"id": userID}));
		});

        
    });
})

app.put('/updateUser', function (req, res) {
	let body = '';
    req.on('data', chunk => {
        body += chunk.toString(); // convert Buffer to string
    });
    req.on('end', () => {
        console.log(body);
        
		// First read existing users.
		fs.readFile( __dirname + "/" + "users.json", 'utf8', function (err, data) {
			data = JSON.parse( data );

			var user = JSON.parse(body);
			var userID = user.id;
			var userName = user.name;

			for(var i = 0; i < data.length; i++) {
				if (data[i].id == userID) {
					data[i].name = userName;
					break;
				}
			}

			console.log(data);

			fs.writeFile(__dirname + "/" + "users.json", JSON.stringify(data), (err) => {
			  if (err) throw err;
			  console.log('The file has been saved!');
			});

			res.end(JSON.stringify({"id": userID}));
		});
    });
})

app.delete('/deleteUser/:id', function (req, res) {
	fs.readFile( __dirname + "/" + "users.json", 'utf8', function (err, data) {
		data = JSON.parse( data );
		for(var i = 0; i < data.length; i++) {
			if (data[i].id == req.params.id) {
				data.splice(i, 1);
				break;
			}
		}	

		fs.writeFile(__dirname + "/" + "users.json", JSON.stringify(data), (err) => {
		  if (err) throw err;
		  console.log('The file has been saved!');
		});
		
		res.end(JSON.stringify({"id": req.params.id}));
	});
})

var server = app.listen(8081, function () {
   var host = server.address().address
   var port = server.address().port
   console.log("Users server listening at http://%s:%s", host, port)
})