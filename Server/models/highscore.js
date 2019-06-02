var mongoose    = require("mongoose");

var HighscoreSchema = new mongoose.Schema({
    name:       String,
    score:      String
});

module.exports = mongoose.model("Highscore", HighscoreSchema);