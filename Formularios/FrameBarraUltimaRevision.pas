
unit FrameBarraUltimaRevision;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniDBText, uniGUIBaseClasses, uniLabel;

type
  TFmeBarraUltimaRevision = class(TUniFrame)
    lblUltimaRevision: TUniLabel;
    txtUrev: TUniDBText;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



procedure TFmeBarraUltimaRevision.UniFrameCreate(Sender: TObject);
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

