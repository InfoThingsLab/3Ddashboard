const dgram = require('dgram');
const client = dgram.createSocket('udp4');

const host = '127.0.0.1';
const port = 3333;



client.on('message', (message, remote) => {
    console.log('Server: ' + message);
});


var firebase = require('firebase');

firebase.initializeApp({
    databaseURL: 'https://ddashboard-415e0.firebaseio.com'
});


firebase.database().ref('/').on('value', function (snapshot) {
    var message = JSON.stringify(snapshot.val()['alexa']);
    console.log("[sub]   " + 　message);
    client.send(message, 0, message.length, port, host, (err, bytes) => {
        if (err) {
            throw err;
        }

        //console.log('Message sent');
    });

});


/*
firebase.database().ref().child("hello") // creates a key called hello
    .set("world")                            // sets the key value to world
    .then(function (data) {
        console.log('Firebase data: ', data);
    })
    .catch(function (error) {
        console.log('Firebase error: ', error);
    });
*/
