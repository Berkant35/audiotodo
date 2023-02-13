


const loginGet = (req, res) => {

    console.log("Login Get")

    res.json({
        "status" : 404,
    })

}

const loginPost = async(req, res) => {
    console.log("loginPost")
}

const signUpGet = (req, res) => {
    console.log("signUpGet")
}

const signUpPost = (req, res) => {
    console.log("signUpPost")
}
const logOutGet = (req, res) => {
    console.log("logOutGet")
}

module.exports = {
    loginGet,
    loginPost,
    signUpGet,
    signUpPost,
    logOutGet
}
