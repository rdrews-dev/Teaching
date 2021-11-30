function [] = ExportFigRd(FileName,WidthInCm,HeightInCm,FontSize)

    options.units = 'centimeters';
    options.FontMode = 'Fixed'; %This line and next are the important bit
    options.FixedFontSize = FontSize;
    options.Width = WidthInCm;
    options.Height = HeightInCm;
    %options.PaperOrientation = 'Landscape';
    options.format = 'png'; %or whatever options you'd like
    options.FontName = 'arial'; 
    options.Renderer = 'painters';
    hgexport(gcf,FileName,options);
    try
        system(['/Library/TeX/texbin/pdfcrop/pdfcrop ', FileName])
    catch 
        display('I tried cropping the pdf and it did not work. Do it manually'); 
    end
        
end