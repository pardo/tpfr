$(function(){
    function update($el, data, return_promise){
        var action = $el.parents("[action]").attr("action");
        var type = $el.parents("[type]").attr("type");
        data.type = type;
        var promise = $.ajax({
            url: action,
            method: "put",
            data: data
        })
        if (return_promise) {
            return promise
        }
        promise.then(function(){
            Materialize.toast('Updated', 2000);
        }, function(){
            Materialize.toast('Not able to save it', 5000);
        });
    }

    $("[editable=state]").each(function(){
        var $el =$(this);
        $el.find("[name=state]").on("change", function(){
            update($el, {
                state: $(this).val()
            });
        });
    });
    

// var connectSlider = document.getElementById('slider-connect');



    $("[editable=progress]").each(function(){
        var $el =$(this);
        var $slider = $el.find("[slider]");

        noUiSlider.create($slider[0], {
            start: parseInt($slider.attr("slider")),
            step: 1,
            range: {
                'min': 0,
                'max': 100
            },
            format: wNumb({
                decimals: 0
            })
        });

        var deboundedUpdate = _.debounce(update, 1000);

        $slider[0].noUiSlider.on('change', function(handle, start, end ) {
            deboundedUpdate($el, {
                progress_state: end
            });
        });
    });

    $("[editable=description]").each(function(){
        var $el =$(this);
        var $field = $el.find("p");
        var $actions = $el.find(".actions");
        var $save = $el.find("[action=save]");
        var $cancel = $el.find("[action=cancel]");
        var originalValue = $field.text();

        $field.click(function(e){
            $field.attr("contenteditable", "true");
            $actions.show();
            originalValue = $field.text();
        });

        $cancel.click(function(e){
            $field.removeAttr("contenteditable");
            $actions.hide();
            $field.text(originalValue);
        })

        $save.click(function(){
            $actions.hide();
            $field.removeAttr("contenteditable");
            update($el, {
                description: $field.text()
            }, true).then(function(){
                Materialize.toast('Updated', 2000);
            }, function(){
                Materialize.toast('Description must be less than 256 characters', 5000);
                $field.text(originalValue);
            });
        });

    });


    $("[editable=dates]").each(function(){
        var $el =$(this);
        
        var $inputStart = $el.find('[name="start_date"]').pickadate();
        var $inputEnd = $el.find('[name="end_date"]').pickadate();
        var pickerStart = $inputStart.pickadate('picker');
        var pickerEnd = $inputEnd.pickadate('picker');
        var viewStart = $el.find('[action="changeStart"]');
        var viewEnd = $el.find('[action="changeEnd"]');

        var skipUpdate = true
        var updateTaskDates = _.debounce(function(){
            if (skipUpdate) { return }
            update($el, {
                start_date: pickerStart.get('value'),
                end_date: pickerEnd.get('value')
            });
        }, 300);

        setTimeout(function(){
            skipUpdate = false
        }, 500);

        viewStart.click(function(){
            setTimeout(pickerStart.open, 100);
        });
        viewEnd.click(function(){
            setTimeout(pickerEnd.open, 100);
        });
        
        pickerEnd.set('min', 1);
        pickerStart.set('min', true);

        pickerStart.on('set', function(event) {
            if ( event.select ) {
                viewStart.text(pickerStart.get('value'));                
                var to = new Date(event.select);
                if (to > pickerEnd.get("max").obj) {
                    //shoulnd happen this
                    return false
                }
                to.setDate(to.getDate()+1);
                pickerEnd.set('min',  to);
                updateTaskDates();
            }
        });

        pickerEnd.on('set', function(event) {
            if ( event.select ) {
                viewEnd.text(pickerEnd.get('value'));
                var from = new Date(event.select);
                if (from < pickerEnd.get("min").obj) {
                    //shoulnd happen this
                    return false
                }
                from.setDate(from.getDate()-1);
                pickerStart.set('max', from );
                updateTaskDates();                
            }
        });

        if ( pickerStart.get('value') ) {
            var start = moment(pickerStart.get('value')); 
            if (start.isBefore(new Date())) {
                pickerStart.set('min', start.toDate());            
            }
            pickerStart.set('select', start.toDate());
        }
        if ( pickerEnd.get('value') ) {
            pickerEnd.set('select', moment(pickerEnd.get('value')).toDate());
        }

        pickerStart.render(true)
        pickerEnd.render(true)
    });


    
});