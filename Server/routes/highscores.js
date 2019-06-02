var express     = require("express"),
    router      = express.Router(),
    Highscore   = require("../models/highscore");

// post highscore
router.post('/highscore/:name/:score', function(req, res){
    var name = req.params.name;
    var score = req.params.score;

    if(!name || !score){
        return res.status(400).send('Bad request');
    }

    var highscore = new Highscore({name: name, score: score});
    highscore.save((err) => {
        if (err){
            console.error(err);
            return res.status(500).send('Internal error');
        }
        return res.status(200).send('Success');
    });
});

// get highscores
router.get('/highscore', function(req, res){

    var numToReturn = Number(req.query.num);

    if (!numToReturn){
        return res.status(400).send('Bad request');
    }

    Highscore.find({}, null, {limit: numToReturn, sort: {score: -1}}, (err, highscores) => {
        if (err){
            console.error(err);
            return res.status(500).send('Internal error');
        }
        return res.status(200).json(highscores);
    });
});

module.exports = router;