var navControlContainer;
var navControl;
var quill;

$(document).ready(function () {
    CreateControl();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddinLoaded', null);
});

function LoadContents(Contents) {
    $("#editor").summernote('code', Contents);
}

function CreateControl() {
    navControlContainer = $("#controlAddIn");
    navControlContainer.append('<div id="editor"></div>');
    $("#editor").summernote({
        toolbar: [
            ['style', ['style', 'bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['Insert', ['picture', 'video', 'link', 'table', 'hr']],
            ['Misc', ['codeview']]
        ],
        disableResizeEditor: true,
        height: 240,
        callbacks: {
            onChange: function (contents, $editable) {
                //console.log('onChange:', contents, $editable);
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ContentChanged', [contents]);
            }
        }
    });
    $('.note-statusbar').hide();
}