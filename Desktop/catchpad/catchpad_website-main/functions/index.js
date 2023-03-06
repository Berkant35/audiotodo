const express = require('express');
const cookieParser = require('cookie-parser');
const compression = require('compression');
// https://www.youtube.com/watch?v=LOeioOKUKI8
const functions = require('firebase-functions');
const exphbs = require('express-handlebars');
const fs = require('fs');
const db = require('./db');
const mkdirp = require('mkdirp');

const app = express();

// https://gist.github.com/benw/3824204
var partialsDir = __dirname + '/views/partials';
var filenames = fs.readdirSync(partialsDir);
var partials = {}
filenames.map(function (filename) {
    var matches = /^([^.]+).handlebars$/.exec(filename);
    if (!matches) {
        return;
    }
    var name = matches[1];
    var template = fs.readFileSync(partialsDir + '/' + filename, 'utf8');
    partials[name] = template;
})

app.engine('handlebars', exphbs.engine({
    defaultLayout: 'main',
    //layoutsDir: '/views/layouts',
    helpers: {
        times: function (n, block) {
            var accum = '';
            for (var i = 1; i <= n; ++i)
                accum += block.fn(i);
            return accum;
        }
    },
    partials: partials
}));

app.set('view engine', 'handlebars');
app.use(cookieParser());
app.use(compression());
// https://stackoverflow.com/a/27237873/12555423
app.use(express.urlencoded({ extended: true }));

// what we're doing here is translating html files
// by replacing the text with the translated text
// and then sending the file to the client
// https://phrase.com/blog/posts/nodejs-tutorial-on-creating-multilingual-web-app/
app.get('/presentation', require('./route_handlers/download_pdf_handler') /* function (req, res) {
    res.render('presentation', { layout: 'pdf_layout' , path: 'public/assets/presentation.pdf'});
} */);
app.get('/sunum', require('./route_handlers/download_pdf_handler')/* function (req, res) {
    res.render('presentation', { layout: 'pdf_layout' , path: 'public/assets/presentation.pdf'});
} */);
app.get('/presentation/download', require('./route_handlers/download_pdf_handler'));
app.get('/sunum/indir', require('./route_handlers/download_pdf_handler'));
app.get('*', require('./route_handlers/all_handler'));

app.post(/\/.+\/contact/g, require('./route_handlers/contact_form_handler'));
app.post(/\/.+\/order/g, require('./route_handlers/order_form_handler'));
app.post(/\/.+\/news_letter/g, require('./route_handlers/mail_letter_form_handler'));



// https://www.youtube.com/watch?v=LOeioOKUKI8
exports.app = functions.https.onRequest(app);