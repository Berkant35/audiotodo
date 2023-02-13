const express = require('express')
const morgan = require('morgan')
const config = require('./config')
const cors = require('cors')


///SECURE
require('dotenv').config()

const app = express()

require('./db/db_connection')

app.set('view engine', 'ejs')

//app.use(express.json)
app.use(express.urlencoded({extended:true}))
app.use(cors())
app.use(morgan("tiny")) // log the request for debugging

//Routes
const authRoutes = require('./routes/auth')

//istek api auth ile başlayınca tetiklenir.

app.use('/api/auth',authRoutes)





app.listen(3000 || config.port, () => console.log(`Server running on port ${config.port}`));
