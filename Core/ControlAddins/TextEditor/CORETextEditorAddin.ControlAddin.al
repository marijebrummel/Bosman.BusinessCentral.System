controladdin "CORE Text Editor Addin"
{
    StyleSheets = 'Core/ControlAddins/TextEditor/css/style.css',
    'https://netdna.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.css',
    'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.css';
    RequestedHeight = 320;
    MinimumHeight = 320;
    MinimumWidth = 400;
    RequestedWidth = 400;
    VerticalShrink = false;
    HorizontalStretch = true;
    Scripts = 'https://code.jquery.com/jquery-3.3.1.min.js',
              'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.5/umd/popper.js',
              'https://netdna.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.js',
              'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote.js',
              'Core/ControlAddins/TextEditor/js/startup.js';

    procedure LoadContents(Contents: Text);

    event AddinLoaded();
    event ContentChanged(Contents: Text);
}