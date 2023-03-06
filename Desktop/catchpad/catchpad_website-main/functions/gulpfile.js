// gulpfile.js
const gulp = require("gulp");
const sharpResponsive = require("gulp-sharp-responsive");

const _root = "../root_assets"

const out = "./public/assets/dist"

const convertSingleFile = async (path) => {
    let ext = getExtension(path)

    // FOR SOME REASON GULP DOES NOT WANT TO
    // ACCEPT 'JPG' LIKE WHY?????????
    // IDK BUT THIS IS A WORKAROUND AND
    // I DONT SEE A PROBLEM CURRENTLY...
    ext = ext === 'jpg' ? 'jpeg' : ext
    return await gulp.src(path)
        .pipe(sharpResponsive({
            formats: [
                // original extension
                { width: 640, format: ext, rename: { suffix: "-sm" } },
                { width: 768, format: ext, rename: { suffix: "-md" } },
                { width: 1024, format: ext, rename: { suffix: "-lg" } },
                { width: 1280, format: ext, rename: { suffix: "-xl" } },
                { width: 1920, format: ext, rename: { suffix: "-xxl" } },
                // webp
                { width: 640, format: "webp", rename: { suffix: "-sm" } },
                { width: 768, format: "webp", rename: { suffix: "-md" } },
                { width: 1024, format: "webp", rename: { suffix: "-lg" } },
                { width: 1280, format: "webp", rename: { suffix: "-xl" } },
                { width: 1920, format: "webp", rename: { suffix: "-xxl" } },
                // avif
                { width: 640, format: "avif", rename: { suffix: "-sm" } },
                { width: 768, format: "avif", rename: { suffix: "-md" } },
                { width: 1024, format: "avif", rename: { suffix: "-lg" } },
                { width: 1280, format: "avif", rename: { suffix: "-xl" } },
                { width: 1920, format: "avif", rename: { suffix: "-xxl" } },
            ]
        }))
        .pipe(gulp.dest(out + removeRootAndEx(path)))
}

const removeRootAndEx = (file) => {

    let f = file.replace(_root, "")

    let ind = f.indexOf(".")
    if (ind !== -1) {
        f = f.substring(0, ind)
    }

    return f
}

function getExtension(file) {
    let sp = file.split(".")
    return sp[sp.length - 1]
}

const extensionsIs = (file, extension) => {
    return getExtension(file) === extension
}

const processFile = async (file) => {
    // if has an extension and is an image
    if (file.split(".").length > 1 &&
        (extensionsIs(file, "png") || extensionsIs(file, "jpg") || extensionsIs(file, "jpeg"))) {
        await convertSingleFile(file)
    }
}

const img = async () => {
    let folders = require("glob").sync(_root + "/**/*")
    // exclude everything under `out` folder
    folders = folders.filter(f => f.indexOf(out) === -1)

    folders.forEach(async (f) => await processFile(f))
}

module.exports = { img }