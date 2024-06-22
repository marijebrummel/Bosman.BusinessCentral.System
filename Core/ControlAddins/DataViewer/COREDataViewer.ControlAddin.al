namespace Own.Core.Helpers;

controladdin "CORE Data Viewer"
{
    VerticalStretch = true;
    HorizontalStretch = true;
    MinimumHeight = 300;//453;
    RequestedHeight = 300;

    Scripts = 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js', //'https://code.jquery.com/jquery-1.9.1.min.js',
              'Core/ControlAddins/DataViewer/js/codemirror.js',
              'Core/ControlAddins/DataViewer/js/script.js',
              'Core/ControlAddins/DataViewer/js/vkbeautify.js';

    StyleSheets = 'Core/ControlAddins/DataViewer/css/codemirror.css',
                  'Core/ControlAddins/DataViewer/css/htmleditor.css',
                  'Core/ControlAddins/DataViewer/css/style.css';

    procedure LoadData(Data: Text);

    event AddinLoaded();
}