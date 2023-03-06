const db = require("./db");

const contact_forms = "contact_forms"
const order_forms = "order_forms"
const maililng_list = "mailing_list"

// adds the contact form to firestore
exports.addContactForm = async function (req) {
    var data = require("./forms/decodeContactForm")(req);

    let contactForm = Object.assign(data, { date: new Date() })

    var docId = (contactForm.date.getTime() / 1000).toString();
    // add to firestore
    const docRef = db.collection(contact_forms).doc(docId);

    // try docRef.set(contactForm), if successful, return true, else return false
    try {
        await docRef.set(contactForm);
        return true;
    } catch (error) {
        // console.log("fb error" + error);
        return false;
    }
}

// adds the order form to firestore
exports.addOrderForm = async function (req) {
    var data = require("./forms/decodeOrderForm")(req);

    let orderForm = Object.assign(data, { date: new Date() })

    var docId = (orderForm.date.getTime() / 1000).toString();

    // add to firestore
    const docRef = db.collection(order_forms).doc(docId);

    // try docRef.set(orderForm), if successful, return true, else return false
    try {
        await docRef.set(orderForm);
        return true;
    } catch (error) {
        // console.log("fb error" + error);
        return false;
    }
}

// adds the mailing list form to firestore
exports.addMailingListForm = async function (req) {
    var data = require("./forms/decodeMailLetterForm")(req);

    let mailLetterForm = Object.assign(data, { date: new Date() })

    var docId = (mailLetterForm.date.getTime() / 1000).toString();

    // add to firestore
    const docRef = db.collection(maililng_list).doc(docId);

    // try docRef.set(orderForm), if successful, return true, else return false
    try {
        await docRef.set(mailLetterForm);
        return true;
    } catch (error) {
        // console.log("fb error" + error);
        return false;
    }
}