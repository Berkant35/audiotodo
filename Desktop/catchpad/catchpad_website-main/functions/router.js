const consts = require('./consts.json')
const getLang = require('./translator')

module.exports = (req) => {
    let sp = req.url.split('/');
    let emt = []
    for (const key in sp) {
        let val = sp[key]
        if (!val) continue;
        emt.push(val);
    }

    sp = emt;

    let url
    if (sp.length >= 2) {
        let copy = []
        // copy starting from 1, so avoid the lang code
        for (let index = 1; index < sp.length; index++) {
            const element = sp[index];
            copy.push(element);
        }
        url = copy.join('/')
    }

    let original = url

    const { getCurrentLang } = require('./get_current_lang');

    let [lang, langExists] = getCurrentLang(req);

    // if the 'lang' is not equal to the default lang, check for the key where
    // the value is url in require(`./translator`)(langCode);
    if (url && lang != consts.defaultLang) {
        let langFile = getLang(lang);
        // now get the langFile of consts.defaultLang
        let defaultLangFile = getLang(consts.defaultLang);

        let [u, id] = url.split('/')

        let urlKey = Object.keys(langFile).find(key => langFile[key] == u);

        // and set the url to the value of the key in the defaultLangFile
        u = defaultLangFile[urlKey]

        if (id)
            url = [u, id].join('/')
        else url = u;
    }

    return [original, url, lang, langExists];
}