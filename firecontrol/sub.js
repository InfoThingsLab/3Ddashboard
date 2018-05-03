var firebase = require('firebase');

firebase.initializeApp({
    databaseURL: 'https://ddashboard-415e0.firebaseio.com'
});


firebase.database().ref('/').on('value', function (snapshot) {
    console.log(snapshot.val()['alexa']);
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
