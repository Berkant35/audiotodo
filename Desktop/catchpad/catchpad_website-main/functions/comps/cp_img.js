module.exports = (path, alt, className) => {
    // we wanna get the name of the image,
    // the structure is like this:
    // "{folderName}/{imageName}.{extension}"
    // so we'll split each part
    let parts = path.split('/');
    let imageNameWExtension = parts[parts.length - 1];
    let imageName = imageNameWExtension.split('.')[0];
    let extension = imageNameWExtension.split('.')[1];

    let folderName = parts.slice(0, parts.length - 1).join('/');

    const assePath = "assets"

    let p = "/" + [assePath, "dist", folderName, imageName, imageName].join('/')

    const sizesN = ['sm', 'md', 'lg', 'xl', 'xxl'];
    const sizesQ = [640, 768, 1024, 1280, 1920];

    let st = ''
    const formats = ['avif', 'webp', extension]

    formats.forEach((ext) => {
        for (let i = 0; i < sizesN.length; i++) {
            var sizeN = sizesN[i];
            var sizeQ = sizesQ[i];

            st += `<source srcset="${p}-${sizeN}.${ext}" media="(max-width: ${sizeQ}px)" type="image/${ext}" />`
        }
    })

    return `
    <picture ${className ? "class=" + "\"" + className + "\"" : ""}>
        ${st}
        <!-- original fallback -->
        <img src="${p}-xxl.${extension}" ${className ? "class=" + "\"" + className + "\"" : ""} alt="${alt ? alt : ""}" />
    </picture>
    `
}