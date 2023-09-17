controladdin "Imagen"
{
    MinimumWidth = 100;
    RequestedHeight = 100;
    HorizontalShrink = true;
    HorizontalStretch = true;

    Scripts = 'src/controlAddIn/Imagenes/js/Script.js', 'https://code.jquery.com/jquery-3.6.0.min.js';
    StartupScript = 'src/controlAddIn/Imagenes/js/Startup.js';

    event ControlAddInReady();

    procedure CargarImagenBase64(base64Image: Text);
}