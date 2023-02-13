const mongoose = require('mongoose')

const dbUrl = process.env.MONGO_DB_URL;

//Yeni sürümler ile çalışmalar yürüttüğün zaman bu opsiyonu false olarak ayarlamanda fayda var.
mongoose.set('strictQuery', true);


mongoose.connect(
    dbUrl, {useNewUrlParser: true, useUnifiedTopology: true})
    .then(() => console.log("connected to db"))
    .catch((err) => console.log('Err', err))

module.exports = mongoose
