request = require 'request'

module.exports = class ForecastFetcher

    ENTRY_POINT     = 'http://opendata-download-metfcst.smhi.se'
    CATEGORY        = 'pmp2g'
    VERSION         = '2'
    GEOTYPE         = 'point'
    LNG_POS         = 9
    LAT_POS         = 11
    MAX_DECIMALS    = 6
    
    morningHours = [5,6,7,8,9]
    foreNoonHours = [10,11,12]
    afterNoonHours = [13,14,15,16,17,18]
    eveningHours = [19,20,21,22]
    nightHours = [23,24,0,1,2,3,4]

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

    parseForecasts:(forecastData,currentDate)=>
        morningMeasurements = @getForecasts(forecastData,morningHours,currentDate)
        forenoonMeasurements = @getForecasts(forecastData,foreNoonHours,currentDate)
        afternoonMeasurements = @getForecasts(forecastData,afterNoonHours,currentDate)
        eveningMeasurements = @getForecasts(forecastData,eveningHours,currentDate)
        nightMeasurements = @getForecasts(forecastData,nightHours,currentDate)

        prognosis = {
            morning : @getPrognosis(morningMeasurements)
            forenoon: @getPrognosis(forenoonMeasurements)
            afternoon: @getPrognosis(afternoonMeasurements)
            evening: @getPrognosis(eveningMeasurements)
            night: @getPrognosis(nightMeasurements)
        }
        prognosis

    getForecasts:(forecastObj,hours,currentDate)=>
        forecasts = []
        for forecast in forecastObj.timeSeries
            date = new Date(forecast.validTime)
            if hours.indexOf(date.getHours())>=0 and currentDate.getDate() == date.getDate()
                forecastObject = {
                    date:date,
                }
                for parameter in forecast.parameters
                    switch parameter.name
                        when 't' 
                            forecastObject.temperature={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
                        when 'wd'
                            forecastObject.windDirection={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
                        when 'ws'
                            forecastObject.windSpeed={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
                        when 'tcc_mean'
                            forecastObject.cloudCover={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
                        when 'pmean'
                            forecastObject.precipitationMean={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
                        when 'pcat'
                            forecastObject.precipitationCategory={
                                value:parameter.values[0]
                                unit:parameter.unit
                            }
  
                forecasts.push(forecastObject)
        forecasts

    getPrognosis:(forecastData)=>
        temperature=[]
        windspeed=[]
        cloudCover=[]
        precipitation=[]
        prognosis={}
        
        for dataObject in forecastData
            temperature.push(dataObject.temperature.value)
            windspeed.push(dataObject.windSpeed.value)
            cloudCover.push(dataObject.cloudCover.value)
            precipitation.push(dataObject.precipitationMean.value)

        prognosis.temperature = @getMeanValueFromArray(temperature) if temperature.length>0
        prognosis.windspeed = @getMeanValueFromArray(windspeed) if windspeed.length>0
        prognosis.cloudCover = @getMeanValueFromArray(cloudCover) if cloudCover.length>0
        prognosis.precipitation = @getMeanValueFromArray(precipitation) if precipitation.length>0    
        if prognosis.temperature
            return prognosis
        else
            return null

    getMeanValueFromArray:(values)=>
        values.sort( (a,b)-> return a - b )
        half = Math.floor(values.length/2)
        if(values.length % 2)
            return values[half]
        else
            return (values[half-1] + values[half]) / 2.0



