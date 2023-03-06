const consts = require('./consts.json');

const supportedLangs = ['en', 'tr'];

var getCurrentLangEx = function (req) {
    // lang is either the head of the url 'www.example.com/lang_name/xxx'
    // or the value of defaultLang
    let ln = req.path.split('/')[1].split('/')[0];

    var langExists = ln && ln.length == 2 && supportedLangs.includes(ln);

    var lang = langExists ? ln : consts.defaultLang;

    return [lang, langExists];
};

exports.getCurrentLang = getCurrentLangEx;

exports.getReverseLang = function (req) {
    var [langCode] = getCurrentLangEx(req);
    return reverseLang(langCode);
}

exports.reverseLang = function (lang) {
    return (lang == 'en') ? 'tr' : 'en';
}

exports.country2Alpha = function (lang) {
    return (lang == 'en') ? 'us' : 'tr';
}

exports.containsLang = function (word) {
    for (var i = 0; i < supportedLangs.length; i++) {
        if (word.includes('/' + supportedLangs[i] + '/')) {
            return true
        }
    }

    return false
}
