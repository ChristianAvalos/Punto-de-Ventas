

unit FrameBarraEstado;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniToolBar, uniGUIBaseClasses,
  uniStatusBar;

type
  TFmeBarraEstado = class(TUniFrame)
    UniStatusBar: TUniStatusBar;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



procedure TFmeBarraEstado.UniFrameCreate(Sender: TObject);
begin
  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
        UniStatusBar.Color := clWhite;
        Self.Color := clWhite;
  {$ENDIF}
end;

end.
