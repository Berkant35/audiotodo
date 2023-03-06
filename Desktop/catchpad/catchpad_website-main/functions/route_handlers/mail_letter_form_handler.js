const { addMailingListForm } = require("../fb");

module.exports = (req, res) => {
    addMailingListForm(req).then(function(result) {
        if (result) {
            res.send('200');
        } else {
            res.send(result);
        }
    });
}