$(function() {
    $.getJSON('../assets/municipalities.json', function(data) {
        $('#municipality').autocomplete({
            source: data
        });
    });

    $('#municipality').focus(function() {
        var field = $(this);
        if (field.val() == field.attr('value'))
            field.val('');
    });
});
