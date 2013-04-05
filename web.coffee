gzippo = require('gzippo')
express = require('express')

app = express.createServer(express.logger())
app.use(gzippo.staticGzip(__dirname + '/dist'))
app.listen(process.env.PORT || 5000)