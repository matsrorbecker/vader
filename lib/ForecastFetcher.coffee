request = require 'request'

module.exports = class ForecastFetcher

    ENTRY_POINT     = 'http://opendata-download-metfcst.smhi.se'
    CATEGORY        = 'pmp2g'
    VERSION         = '2'
    GEOTYPE         = 'point'
    LNG_POS         = 9
    LAT_POS         = 11
    MAX_DECIMALS    = 6
    
    constructor: () ->
        @urlArray = []
        @urlArray.push ENTRY_POINT
        @urlArray.push 'api'
        @urlArray.push 'category'
        @urlArray.push CATEGORY
        @urlArray.push 'version'
        @urlArray.push VERSION
        @urlArray.push 'geotype'
        @urlArray.push GEOTYPE
        @urlArray.push 'lon'
        @urlArray.push ''
        @urlArray.push 'lat'
        @urlArray.push ''
        @urlArray.push 'data.json'
        
    getForecast: (location, callback) =>
        @urlArray[LNG_POS] = location.lng.toFixed(MAX_DECIMALS)
        @urlArray[LAT_POS] = location.lat.toFixed(MAX_DECIMALS)
        urlString = @urlArray.join '/'
        
        request urlString, (error, response, body) =>
            if not error and response.statusCode == 200
                forecast = JSON.parse body
                # Lägg in felhantering här...
                callback forecast
            else if error
                callback { error: "Ett fel uppstod: #{error.message}"}
            else
                callback { error: "Servern svarade med kod #{response.statusCode.toString()}."}

    getMorningForecast:(forecastObj,currentDate)=>
        morningHours = [5,6,7,8,9]
        morningForecast = []
        forecasts = forecastObj.timeSeries
        for forecast in forecasts
            date = new Date(forecast.validTime)
            if morningHours.indexOf(date.getHours())>=0 and currentDate.getDate() == date.getDate()
                console.log 'temperature: '+JSON.stringify(forecast)
                forecastObject = {
                    date:date,
                }
                for parameter in forecast.parameters
                    if parameter.name=='t'
                        forecastObject.temperature={
                            value:parameter.values[0],
                            unit:parameter.unit
                    else if 
  
                morningForecast.push(forecastObject)
        morningForecast






