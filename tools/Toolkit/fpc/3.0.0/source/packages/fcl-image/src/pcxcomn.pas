unit pcxcomn;

{$mode objfpc}{$H+}

interface

type

  TRGB = packed record
    Red, Green, Blue: byte;
  end;

  TPCXHeader = record
    FileID:   byte;                      // signature $0A fichiers PCX, $CD fichiers SCR
    Version:  byte;                     // 0: version 2.5
    // 2: 2.8 avec palette
    // 3: 2.8 sans palette
    // 5: version 3
    Encoding: byte;                    // 0: non compresser
    // 1: encodage RLE
    BitsPerPixel: byte;                // nombre de bits par pixel de l'image: 1, 4, 8, 24
    XMin,                              // abscisse de l'angle sup�rieur gauche
    YMin,                              // ordonn�e de l'angle sup�rieur gauche
    XMax,                              // abscisse de l'angle inf�rieur droit
    YMax,                              // ordonn�e de l'angle inf�rieur droit
    HRes,                              // r�solution horizontale en dpi
    VRes:     word;                        // r�solution verticale en dpi
    ColorMap: array[0..15] of TRGB;    // Palette
    Reserved,                          // R�serv�
    ColorPlanes: byte;                 // Nombre de plans de couleur
    BytesPerLine,                      // Nombre de bits par ligne
    PaletteType: word;                 // Type de palette
    //      1: couleur ou N/B
    //      2: d�grad� de gris
    Fill:     array[0..57] of byte;        // Remplissage
  end;

implementation

end.
