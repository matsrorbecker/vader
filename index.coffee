fs =                require 'fs'
path =              require 'path'
express =           require 'express'
bodyParser =        require 'body-parser'
LocationFinder =    require './lib/LocationFinder'
ForecastFetcher =   require './lib/ForecastFetcher'

app = express()

app.set 'view engine', 'jade'
app.set 'views', path.join __dirname, 'views'
app.use express.static path.join __dirname, 'public'
app.use bodyParser.urlencoded { extended: false }

app.locals.getWordForCloudCover =       require('./lib/words').getWordForCloudCover
app.locals.getWordForWindSpeed =        require('./lib/words').getWordForWindSpeed
app.locals.getWordForPrecipitation =    require('./lib/words').getWordForPrecipitation

config = JSON.parse fs.readFileSync('./config.json', 'utf8')
municipalityCodes = JSON.parse fs.readFileSync('./data/municipalityCodes.json', 'utf8')
locationFinder = new LocationFinder(config.apiKey)
forecastFetcher = new ForecastFetcher()

todaysForecast = {}


app.get '/', (req, res) ->
    res.render 'index', {}

app.post '/', (req, res) ->
    name = req.body.municipality.toLowerCase().trim()
    code = municipalityCodes[name]
    if code
        locationFinder.find code, name, (location) ->
            forecastFetcher.getForecast location, (forecast) ->
                currentDate = new Date()
                todaysForecast = forecastFetcher.parseForecasts(forecast,currentDate)
                res.render 'index', { 
                    municipality: req.body.municipality 
                    todaysForecast: todaysForecast
                }
    else
        res.render 'index', { error: "Det finns ingen kommun som heter #{req.body.municipality}." }

app.post '/weather', (req, res) ->
    name = req.body.city.toLowerCase().trim()
    code = municipalityCodes[name]
    if code
        locationFinder.find code, name, (location) ->
            forecastFetcher.getForecast location, (forecast) ->
                currentDate = new Date()
                todaysForecast = forecastFetcher.parseForecasts(forecast,currentDate)
                console.log("ANSWERING WITH : "+JSON.stringify(todaysForecast))
                res.send(todaysForecast)
    else
        res.send('todaysForecast')

app.listen process.env.PORT or 3000

