const db = require('../db')
const { lookup } = require('geoip-lite');

async function increaseUtmReadCount(req, utmN) {

    // our structure is like this:
    // utmLinksReads Collection / [id] doc / reads Collection
    // we wanna go down until the reads collection, creating 
    // the things if they don't exist in each step
    var utmLinksReads = db.collection('utmLinksReads');

    // first create the document with utm_id
    let utmDoc = utmLinksReads.doc(utmN)

    // if utmDoc doesn't exist, create it
    try {
        await utmDoc.create({})
    } catch (e) {
        // console.log('doc create failed')
    }

    // then, read the reads collection
    let reads = utmDoc.collection('reads')

    var val = {
        createdAt: new Date(),
    }

    let add = await reads.add(val)
    // console.log('added ', add)
}

module.exports = async (req, res) => {
    // parse the url, which will be in the form of:
    // /route_name . if it does not match this, we 
    // will return undefined
    var url = req.path.split('/');
    var routeName = url[1];

    if (url.length > 2) {
        return undefined;
    }

    // now, we wanna query the 'utmLinks' collection
    // to find the routeName
    // the utmLinks collection's docs have the following structure:

    try {
        // the static utm_links.json is 
        // a temporary solution, we will replace it with
        // firestore data later..
        // read the file utm_links.json
        // {
        //   'createdAt': Date
        //   'creatorEmail': string
        //   'name': string
        //   'url': string
        // }
        // our [routeName] should match [name] of the doc
        let utms = require('../utm_links.json')

        if (!utms || !utms.length) {
            return undefined;
        }

        let utm = utms.find(utm => utm.name == routeName)

        if (!utm) {
            return undefined;
        }

        // if we found the doc,
        // then we'll redirect to the url
        res.redirect(utm.url)
        try {
            await increaseUtmReadCount(req, utm.name);
        } catch (error) {
            // console.log("after redirectError")
            console.error(error)
        }
    } catch (error) {
        console.error(error)
        return undefined;
    }
}