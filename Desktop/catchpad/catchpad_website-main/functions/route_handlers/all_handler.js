const getLang = require('../translator');
const cpImg = require('../comps/cp_img');
const { reverseLang, setCurrentLang, country2Alpha } = require('../get_current_lang');
const consts = require('../consts.json');

module.exports = async (req, res) => {
    var additionalData = {}

    // if the route contains '.', it means it's a file
    if (req.path.indexOf('.') > -1) {
        // if the route is a file, we'll send it to the client
        return res.end();
    }

    var [originalFileName, fileName, langCode, langExists] = require('../router')(req);

    // if !langExists, then, we wanna run utm_handler, 
    // it will redirect to the url, or return undefined
    if (!langExists) {
        // if the url is '/', we'll redirect to the home page
        if (req.path === '/') {
            return res.redirect('/' + langCode);
        }

        var utmRed = await require('../route_handlers/utm_handler')(req, res);

        if (utmRed) {
            res.end()
            return;
        }
    }

    let lang = getLang(langCode)
    let defLang = getLang(consts.defaultLang)

    function render(filen, lang) {
        res.set('Cache-Control', 'public, max-age=31557600'); // one year
        res.render(filen, lang, function (err, html) {
            console.log('rendering', filen, lang);
            // in any error case, we'll send the home page
            if (err) {
                return renderHome()
            }

            // when you see any occurence of '<CPIMG' in html,
            // in the "path" attribute, you'll find the path to the image,
            // it may also have a "class" attribute, if you wanna add a class to the image
            // but it is not mandatory,
            // and it has a closing "/>"
            html = html.replace(/<CPIMG\s*path="(.*?)"\s*(alt="(.*?)")?\s*(class="(.*?)")?\s*\/>/gi, function (match, path, altAttr, alt, classAttr, className) {
                return cpImg(path, alt, className);
            });

            res.send(html);
        })
    }

    const renderHome = () => {
        render(consts.default_route_name, defLang)
    }

    if (!langExists)
        langCode = consts.defaultLang;
    fileName = fileName || consts.default_route_name;

    // if the fileName has extension, we'll remove it
    if (fileName.indexOf('.') > -1)
        fileName = fileName.split('.')[0];

    if (originalFileName) {

        // /products
        if (originalFileName === lang['routes_products']) {
            [additionalData, fileName] = require('./prod/prod_list_handler')(req, res, fileName);
        }
        // /product/:id
        else if (originalFileName.split('/')[0] === lang['routes_product']) {
            let e = require('./prod/prod_handler')(req, res, fileName);

            if (e)
                [additionalData, fileName] = e


            if (!additionalData) return renderHome()
        }

    }

    // additionalData is a map, if it is not null, we wanna merge it with lang
    if (additionalData) {
        lang = Object.assign(lang, additionalData);
    }

    // we wanna add the key 'lang' and 'reverse_lang' to the lang object
    lang['lang'] = langCode;
    let rev = reverseLang(langCode);
    lang['reverse_lang'] = rev;
    lang['reverse_country'] = country2Alpha(rev);

    render(fileName, lang)
}
