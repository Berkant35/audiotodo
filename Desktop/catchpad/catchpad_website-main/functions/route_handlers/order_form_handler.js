
const { addOrderForm } = require("../fb");
const { sendOrderEmail } = require("../email");

module.exports = (req, res) => {
    addOrderForm(req).then(function (result) {
        if (result) {
            sendOrderEmail(req);

            res.send('200');
        } else {
            res.send(result);
        }
    });
}