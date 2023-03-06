const fs = require('fs');
const glob = require('glob');

var language_dict = {};

// load all language files
glob.sync('./language/*.json').forEach(function (file) {
    let dash = file.split("/");
    if (dash.length == 3) {
        let dot = dash[2].split(".");
        if (dot.length == 2) {
            let lang = dot[0];
            fs.readFile(file, function (err, data) {
                let dt = data.toString();
                let par = JSON.parse(dt);

                // we have normal files like 'en.json',
                // and external like 'en_routes.json'
                lang = lang.split("_")[0]

                // if language_dict has already this language
                // we merge it with the new one
                if (language_dict[lang]) {
                    for (let key in par) {
                        language_dict[lang][key] = par[key];
                    }
                } else {
                    language_dict[lang] = par;
                }
            });
        }
    }
});

module.exports = (lang_id) => {
    // get language_dict[lang_id] and combine it with
    // language_dict[shared]

    let lang = language_dict[lang_id];
    let shared = language_dict['shared'];
    let result = {};
    for (let key in lang) {
        result[key] = lang[key];
    }
    for (let key in shared) {
        result[key] = shared[key];
    }

    return result;
}