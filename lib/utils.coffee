# Returns a random integer between min (included) and max (included)
exports.getRandomInteger = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

exports.getRandomElement = (array) ->
    array[exports.getRandomInteger(0, array.length - 1)]
    
# Converts number (integer) to string, in accordance with the rules in TT-språket
# Note that this function also removes minus signs
exports.getNumberString = (number) ->
    numberStrings = [
        'noll'
        'en'
        'två'
        'tre'
        'fyra'
        'fem'
        'sex'
        'sju'
        'åtta'
        'nio'
        'tio'
        'elva'
        'tolv'
    ]
    
    number = Math.abs(number)
    if number <= 12
        numberStrings[number]
    else if number >= 1000
        exports.formatThousands(number)
    else
        number.toString()

# Extracts time from Date object, returns string in format HH.MM, e.g. '18.32'
exports.getTimeString = (time) ->
    h = time.getHours()
    m = time.getMinutes()
    if m < 10 then m = '0' + m
    h + '.' + m
    
# Converts percentage (float) to a nicely formatted string, e.g. 1.745 -> '1,7'
# Note that this function also removes minus signs
exports.formatPercentage = (percentage, decimals = 1) ->
    Math.abs(percentage).toFixed(decimals).replace('.', ',')
    
# Converts/formats thousands (number), e.g 9816666 -> '9 816 666'
# Note that this function also removes minus signs
exports.formatThousands = (thousands) ->
    Math.abs(thousands).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ')
    
exports.capitalizeFirstLetter = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
    
