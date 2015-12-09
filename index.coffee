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

config = JSON.parse fs.readFileSync('./config.json', 'utf8')
municipalityCodes = JSON.parse fs.readFileSync('./data/municipalityCodes.json', 'utf8')
locationFinder = new LocationFinder(config.apiKey)
forecastFetcher = new ForecastFetcher()

app.get '/', (req, res) ->
    res.render 'index', {}

app.post '/', (req, res) ->
    name = req.body.municipality.toLowerCase().trim()
    code = municipalityCodes[name]
    
    if code
        locationFinder.find code, name, (location) ->
            forecastFetcher.getForecast location, (forecast) ->
                console.log forecast
        res.render 'index', { municipality: req.body.municipality }
    else
        res.render 'index', { error: "Det finns ingen kommun som heter #{req.body.municipality}." }

app.listen process.env.PORT or 3000