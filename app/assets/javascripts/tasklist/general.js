$(function(){
    $('select').material_select();
    $('.modal').modal();

    (function bindDatepickers(){
        var $inputStart = $('.datepicker.start_date').pickadate();
        var $inputEnd = $('.datepicker.end_date').pickadate();
        var pickerStart = $inputStart.pickadate('picker')
        var pickerEnd = $inputEnd.pickadate('picker')

        if (!pickerStart || !pickerEnd) { return }
        
        pickerStart.set('min', true);
        pickerEnd.set('min', 1);

        pickerStart.on('set', function(event) {
            if ( event.select ) {
                var to = new Date(event.select);
                to.setDate(to.getDate()+1);
                pickerEnd.set('min',  to);
            }
        });
        pickerEnd.on('set', function(event) {
            if ( event.select ) {
                var from = new Date(event.select);
                from.setDate(from.getDate()-1);
                pickerStart.set('max', from )
            }
        });
    })();

});