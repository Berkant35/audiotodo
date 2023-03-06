// read the file named 'products.json',
const products = require('../../products.json');
const { getCurrentLang } = require('../../get_current_lang')
const getLang = require('../../translator')
const setupProd = require('./setup_prod')

module.exports = (req, _res, fileName) => {
    let [langCode] = getCurrentLang(req)
    let lang = getLang(langCode)

    // read the list of products
    // with key 'prods'
    let prodList = products.prods || [];

    prodList = setupProd(prodList, langCode, lang)

    let data = { prods: prodList }

    return [data, fileName]
}