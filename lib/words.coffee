exports.getWordForCloudCover = (cloudCover) ->
    if cloudCover <= 1
        'klart'
    else if cloudCover <= 4
        'halvklart'
    else if cloudCover <= 6
        'mest mulet'
    else
        'mulet'