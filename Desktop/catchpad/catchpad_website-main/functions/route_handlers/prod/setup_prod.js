const fs = require('fs')
const path = require('path')

const publicS = '../../public'
const assetsS = 'assets/dist'
const prodsS = 'prods'
const sharedS = 'shared'

const publicP = path.resolve(__dirname, publicS)
const dir = path.join(publicP, '/' + [assetsS, prodsS].join('/'))
const sharedPath = path.join(dir, sharedS)

const is_img = (path) => {
    const extensions = ['.png', '.jpg', '.jpeg', '.gif', '.svg']
    return path.indexOf('.') > -1 && extensions.some(ext => path.endsWith(ext))
}

module.exports = (prods, langCode, lang) => {

    let sharedfolder
    try {
        sharedfolder = fs.readdirSync(sharedPath).map(f => [prodsS, sharedS, f].join('/'))
    } catch (error) {
        sharedfolder = []
    }

    return prods.map(prod => {
        // our sub folders are contained in path/[prod.id] folder,
        // and path/shared folder
        // so we wanna read the sub folders
        const idPath = path.join(dir, prod.id)

        let idfolder
        try {
            idfolder = fs.readdirSync(idPath).map(f => [prodsS, prod.id, f].join('/'))
        } catch (error) {
            idfolder = []
        }

        // we wanna add all properties in prod[langName] to the prod object
        // if it exists, else, we'll add an empty object
        prod = Object.assign(prod, prod[langCode] || {})

        let discount = prod.discount
        let base = prod.base_price
        let currency = prod.currency

        if (discount !== undefined && discount !== null && discount !== '' && discount > 0) {
            prod.new_price = base - base * (discount / 100)
            prod.old_price = base
        } else {
            prod.new_price = base
        }

        prod.currency_symbol = currency

        prod.images = [...idfolder, ...sharedfolder]

        return prod
    })
}