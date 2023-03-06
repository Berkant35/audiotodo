const nodemailer = require('nodemailer')
const creds = require('./credentials/email_credentials.json')
const getLang = require(`./translator`)
const { getCurrentLang } = require('./get_current_lang')

const transporter = nodemailer.createTransport({
    service: 'yandex',
    host: 'smtp.yandex.ru/smtp.gmail.com',
    auth: creds,
});

const cp_reciever_emails = [
    'selam@catchpad.com.tr',
    'ahmet@catchpad.com.tr',
    'info@catchpad.com',
    'veli.cetinel@catchpad.com.tr'
];

exports.sendContactEmail = function (req) {
    var data = require("./forms/decodeContactForm")(req);

    var [langCode] = getCurrentLang(req);

    // read the file language/${langCode}.json
    var lang = getLang(langCode);

    const mails = [
        ...cp_reciever_emails.map(email => ({

            from: creds.user,
            to: email,
            subject: lang.we_recieved_new_message,
            text:
                lang.subject + ': ' + data.subject + '\n' +
                lang.full_name + ': ' + data.name + '\n' +
                lang.email + ': ' + data.email + '\n' +
                lang.message + ': ' + data.message,
        })),
        {
            from: creds.user,
            to: data.email,
            subject: lang.recieved_msg,
            text: lang.hello + ' ' + data.name + ',' + '\n\n' + lang.msg_sent_success + '\n\n' + lang.sincerely_cp_team,
        },
    ];

    sendEmls(mails);
}

exports.sendOrderEmail = function (req) {
    var data = require("./forms/decodeOrderForm")(req);

    var [langCode] = getCurrentLang(req);

    // read the file language/${langCode}.json
    var lang = getLang(langCode);

    const mails = [
        ...cp_reciever_emails.map(email => ({

            from: creds.user,
            to: email,
            subject: lang.we_recieved_new_order,
            text:
                lang.product_id + ': ' + data.prod_id + '\n' +
                lang.product_name + ': ' + data.prod_name + '\n' +
                lang.full_name + ': ' + data.name + '\n' +
                lang.email + ': ' + data.email,
        })),
        {
            from: creds.user,
            to: data.email,
            subject: lang.mail_order_taken_success,
            text:
                lang.hello + ' ' + data.name + ',' + '\n\n' +
                lang.mail_order_taken_success_desc + '\n\n' +
                lang.sincerely_cp_team,
        },
    ];

    sendEmls(mails);
}

function sendEmls(mails) {
    mails.forEach(mail => {
        transporter.sendMail(mail, (err, info) => {
            if (err) throw err;
            // console.log('Email sent: ' + info.response);
        });
    });
}