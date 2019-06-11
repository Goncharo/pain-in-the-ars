var mongoose    = require("mongoose");

var HighscoreSchema = new mongoose.Schema({
    name:       String,
    score:      Number
});

module.exports = mongoose.model("Highscore", HighscoreSchema);