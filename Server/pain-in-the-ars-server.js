var express     = require("express"),
    mongoose    = require("mongoose");

// configure express application
var app = express()

// connect to mongo database
var databaseURL = "mongodb://localhost/pain-in-the-ars-db"
mongoose.connect(databaseURL, {useNewUrlParser: true});

// configure highscores routes
var highscoresRoute = require("./routes/highscores");
app.use(highscoresRoute);

// start server on port 8666
var port = 8666
var host = "localhost"
var server = app.listen(port, host, () => {
    console.log(`Pain in the ARS server listening on port ${port} on ${host}`);
});