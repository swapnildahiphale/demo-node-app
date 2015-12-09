var http = require("http");
var os = require('os');
var counter = 0;
http.createServer(function (request, response) {
   response.writeHead(200, {'Content-Type': 'text/plain'});
   var hostname = os.hostname();
   response.write("\n\n This page is viewd  " + counter +" times.");
   response.write('\n\n Hostname from where app is being served is : ' + hostname );

   response.write("\n\n The version is : V2");
   response.end();
   if(request.url == "/")
   	 counter = counter + 1;
}).listen(3000);

// Console will print the message
console.log('Server running at http://127.0.0.1:3000/');
