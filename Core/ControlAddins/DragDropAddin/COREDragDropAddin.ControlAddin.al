controladdin "CORE Drag Drop Addin"
{
    StartupScript = 'Core/ControlAddins/DragDropAddin/js/startup.js';
    StyleSheets = 'Core/ControlAddins/DragDropAddin/css/style.css';
    RequestedHeight = 200;
    MinimumHeight = 200;
    VerticalShrink = false;
    HorizontalStretch = true;
    Scripts = 'Core/ControlAddins/DragDropAddin/js/jquery-1.11.0.min.js',
              'Core/ControlAddins/DragDropAddin/js/jquery-ui.min.js';

    event ReadData(Data: JsonObject);

    event AddinLoaded();
}