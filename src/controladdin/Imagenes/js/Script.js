function CargarImagenBase64(base64Image) {
    HtmlImg = '<img id="imgInterior"></img>';
    var controlAddIn = $("#controlAddIn");
    controlAddIn.html(HtmlImg);

    // Establece la imagen en base64 como fuente
    var img = $("#imgInterior");

    // Establece la imagen en base64 como fuente
    img.attr("src", "data:image/png;base64," + base64Image);
    img.attr("height", 100);
    img.attr("width", 100);
}
