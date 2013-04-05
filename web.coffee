gzippo = require('gzippo')
express = require('express')

app = express()
app.use gzippo.staticGzip "#{__dirname}/dist"
app.listen process.env.PORT || 5000