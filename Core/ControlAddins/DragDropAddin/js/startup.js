var navControlContainer;
var navControl;

$(document).ready(function () {
    CreateControl();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddinLoaded', null);
});

function CreateControl() {
    navControlContainer = $("#controlAddIn");
    navControlContainer.append('<div class="wrapper"><div id="drop-files" ondragover="return false"></div></div></div>');
    navControl = $("#drop-files");

    jQuery.event.props.push('dataTransfer');

    navControl.bind('drop', function (e) {
        var files = e.dataTransfer.files;        
        $.each(files, function (index, file) {
            var fileName = file.name;          
            if (file.size < 10485760) {
                var fileReader = new FileReader();
                fileReader.onload = (function (file) {
                    var contentType = fileReader.result.split(',')[0];
                    var base64Content = fileReader.result.split(',')[1];
                    var droppedFile = { FileName: fileName, ContentType: contentType, Data: base64Content };
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
                        "ReadData", 
                        [droppedFile]);
                });

                fileReader.readAsDataURL(file);

            } else {
                var droppedFile = { FileName: fileName, Data: '' };
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
                    "ReadData", 
                    [droppedFile]
                );
            }
        });
    });

    navControl.bind('dragenter', function (e) {
        e.dataTransfer.dragEffect = "copy";
        $(this).css({ 'border': '1px solid #0F6FC6' });
        return false;
    });
    navControl.bind('drop', function () {
        $(this).css({ 'border': '1px solid #FFFFFF' });
        return false;
    });
    navControl.bind('dragleave', function () {
        $(this).css({ 'border': '1px solid #FFFFFF' });
        return false;
    });
};