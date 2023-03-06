
const { addContactForm } = require("../fb");
const { sendContactEmail } = require("../email");

module.exports = (req, res) => {
    addContactForm(req).then(function (result) {
        if (result) {
            sendContactEmail(req);

            res.send('200');
        } else {
            res.send(result);
        }
    });
}