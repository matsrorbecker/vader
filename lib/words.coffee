exports.getWordForCloudCover = (cloudCover) ->
    if cloudCover <= 1
        'klart'
    else if cloudCover <= 4
        'halvklart'
    else if cloudCover <= 6
        'mest mulet'
    else
        'mulet'

exports.getWordForWindSpeed = (windSpeed) ->
    if windSpeed <= 3.3
        'svaga vindar'
    else if windSpeed <= 7.9
        'måttliga vindar'
    else if windSpeed <= 13.8
        'friska vindar'
    else if windSpeed <= 24.4
        'hårda vindar'
    else if windSpeed <= 32.6
        'stormvindar'
    else
        'orkanvindar'

exports.getWordForPrecipitation = (precipitationCategories) ->
    precipitationWords = []
    if 1 in precipitationCategories
        precipitationWords.push 'snö'
    if 2 in precipitationCategories
        precipitationWords.push 'snöblandat regn'
    if 3 in precipitationCategories
        precipitationWords.push 'regn'
    if 4 in precipitationCategories
        precipitationWords.push 'duggregn'
    if 5 in precipitationCategories
        precipitationWords.push 'underkylt regn'
    if 6 in precipitationCategories
        precipitationWords.push 'underkylt duggregn'

    if precipitationWords.length > 1
        precipitationWords = precipitationWords.join ', '
        index = precipitationWords.lastIndexOf(',')
        precipitationWords = precipitationWords.substring(0, index) + ' och' + precipitationWords.substring(index + 1) + ','
    else if precipitationWords.length == 1
        precipitationWords.toString() + ','
    else
        ''

