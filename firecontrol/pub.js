var https = require('https');
var firebaseHost = "ddashboard-415e0.firebaseio.com";
function fbGet(key) {
    return new Promise((resolve, reject) => {
        var options = {
            hostname: firebaseHost,
            port: 443,
            path: key + ".json",
            method: 'GET'
        };
        var req = https.request(options, function (res) {
            res.setEncoding('utf8');
            var body = '';
            res.on('data', function (chunk) {
                body += chunk;
            });
            res.on('end', function () {
                resolve(JSON.parse(body))
            });
        });
        req.end();
        req.on('error', reject);
    });
}

function fbPut(key, value) {
    return new Promise((resolve, reject) => {
        var options = {
            hostname: firebaseHost,
            port: 443,
            path: key + ".json",
            method: 'PUT'
        };

        var req = https.request(options, function (res) {
            res.setEncoding('utf8');
            var body = '';
            res.on('data', function (chunk) {
                body += chunk;
            });
            res.on('end', function () {
                resolve(body)
            });
        });
        req.end(JSON.stringify(value));
        req.on('error', reject);
    });
}

var postData = {
    time: new Date(),
    intend: 'welcome',
};

fbPut("/alexa", postData).then(res => {
    console.log("wrote to database");
    //context.succeed();  // important that you don't call succeed until you are called back 
})