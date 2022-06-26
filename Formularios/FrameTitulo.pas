

unit FrameTitulo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, pngimage, uniImage, uniGUIBaseClasses, uniLabel,
  uniPanel, uniCanvas;

type
  TFmeTitulo = class(TUniFrame)
    lblTituloPrincipal: TUniLabel;
    ImagenTitular: TUniImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
