fs          = require 'fs'
url         = require 'url'
request     = require 'request'
querystring = require 'querystring'

module.exports = class LocationFinder

    BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'
    
    constructor: (@apiKey) ->
        @cachedLocations = {}
 
    find: (code, municipality, callback) =>
        if @cachedLocations[code]
            console.log 'Kommunens plats fanns i cachen!'
            callback @cachedLocations[code]
        else
            console.log 'Hämtar kommunens plats!'
            urlString = @getUrlString municipality
            request urlString, (error, response, body) =>
                if not error and response.statusCode == 200
                    result = JSON.parse body
                    # Lägg in felhantering här...
                    location = result.results[0].geometry.location
                    @cachedLocations[code] =
                        lat: location.lat
                        lng: location.lng
                    callback location
                else if error
                    callback { error: "Ett fel uppstod: #{error.message}"}
                else
                    callback { error: "Servern svarade med kod #{response.statusCode.toString()}."}

    getUrlString: (municipality) ->
        queryObject = 
            address: municipality
            key: @apiKey
        
        query = '?' + querystring.stringify queryObject

        url.resolve BASE_URL, query