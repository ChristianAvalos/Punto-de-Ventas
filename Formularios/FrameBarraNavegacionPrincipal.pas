

unit FrameBarraNavegacionPrincipal;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniPanel, uniDBNavigator,
  uniButton, uniImageList, Vcl.DBCtrls;

type
  THackDBNavigator = class(TUniDBNavigator);

  TFmeBarraNavegacionPrincipal = class(TUniFrame)
    UniDBNavigator: TUniDBNavigator;
    tbtnBuscar: TUniButton;
    UniImageList: TUniImageList;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetupHackedNavigator(const Navigator: TUniDBNavigator; const Glyphs: TUniImageList);

  end;

implementation

{$R *.dfm}



procedure TFmeBarraNavegacionPrincipal.SetupHackedNavigator(
  const Navigator: TUniDBNavigator; const Glyphs: TUniImageList);
const
  Captions : array[TNavigateBtn] of string =
      ('Primero', 'Anterior', 'Siguiente', 'Ultimo', 'Nuevo',
       'Borrar', 'Editar', 'Guardar', 'Cancelar', 'Refrescar',
       'Aplicar cambios', 'Cancelar cambios');
  var
    btn : TNavigateBtn;
begin
  for btn := Low(TNavigateBtn) to High(TNavigateBtn) do
  with THackDBNavigator(Navigator).Buttons[btn] do
  begin
    //from the Captions const array
    Caption := Captions[btn];

    //the number of images in the Glyph property
   { NumGlyphs := 1;
    // Remove the old glyph.
    Glyph := nil;
    // Assign the custom one
    Glyphs.GetBitmap(Integer(btn),Glyph);
    // gylph above text
    Layout := blGlyphTop;

    // explained later
    OnMouseUp := HackNavMouseUp;}
  end;
end;


procedure TFmeBarraNavegacionPrincipal.UniFrameCreate(Sender: TObject);
begin
  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
       Self.Color := clWhite;
  {$ENDIF}
end;

end.
