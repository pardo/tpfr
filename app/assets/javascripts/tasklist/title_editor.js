$(function(){
    var $editor = $("#editor-name");
    var $actions = $editor.find(".editor-actions")
    var $save = $actions.find("[action=save]")
    var $cancel = $actions.find("[action=cancel]")
    var $field = $editor.find("[editable]")
    var originalValue = "";
    var originalValue = "";
    
    $field.click(function(e){
        $field.attr("contenteditable", "true");
        $actions.show();
        originalValue = $field.text();
    })
    
    $cancel.click(function(e){
        $field.removeAttr("contenteditable");
        $actions.hide();
        $field.text(originalValue);
    })

    $save.click(function(){
        $actions.hide();
        $field.removeAttr("contenteditable");
        $.ajax({
            url: $field.attr("action"),
            method: "put",
            data: { name: $field.text() }
        }).then(function(){
            Materialize.toast('Updated', 5000);
        }, function(){
            Materialize.toast('Invalid name', 5000);
            $field.text(originalValue);
        });
    });

    $(".copy-url").click(function(){
        if (copyTextToClipboard(window.location.href)) {
            Materialize.toast('Url copied to clipboard', 2000);
        }
    });

});