$(document).ready(function () {
    document.getElementById("controlAddIn").innerHTML = '<textarea class="boxsizingBorder" id="exportviewer"></textarea>';
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("AddinLoaded");
});

var editor = null;
function LoadData(data) {
    var stringified = data;

    if (data) {
        try {
            var jsonObj = JSON.parse(data);
            stringified = JSON.stringify(jsonObj, undefined, 2);
        } catch (e) {
            stringified = vkbeautify.xml(data);
        }
    }

    var myTextArea = document.getElementById('exportviewer');
    myTextArea.value = stringified;

    CodeMirror.fromTextArea(myTextArea, {
        value: myTextArea.value,
        mode: 'application/json',
        theme: 'neo',
        lineNumbers: true,
        lineWrapping: true,
        readOnly: true,
        cursorBlinkRate: -1
    });
}