module.exports = (req, res) => {
    const file = `public/assets/presentation.pdf`; // ${__dirname}
    res.download(file); // Set disposition and send it.
}