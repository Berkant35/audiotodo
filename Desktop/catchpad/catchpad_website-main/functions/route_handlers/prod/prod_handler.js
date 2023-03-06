const prds = require('../../products.json');
const { getCurrentLang } = require('../../get_current_lang')
const getLang = require('../../translator')
const setupProd = require('./setup_prod')

module.exports = (req, _res, fileName) => {
    let [langCode] = getCurrentLang(req);

    // fileName = (prod or urun)/(product name)
    // the product name is id at the same time

    let sp = fileName.split('/')
    // so we wanna get the id from the fileName
    let id = sp[1];

    // now we wanna query products from products.json
    let products = prds.prods;

    // and get the product with the id we got from the fileName
    let product = products.find(p => p.id == id);

    // if the product is not found, we'll return null
    if (!product)
        return null

    let lang = getLang(langCode)
    product = setupProd([product], langCode, lang)[0]

    let data = { prod: product }

    return [data, sp[0]]
}