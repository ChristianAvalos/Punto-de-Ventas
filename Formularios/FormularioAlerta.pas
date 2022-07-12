
unit FormularioAlerta;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniButton, uniBitBtn,
  uniGUIFrame, FrameTitulo, uniLabel, Vcl.Imaging.pngimage, uniImage;

type
  TFrmAlerta = class(TUniForm)
    FmeTitulo: TFmeTitulo;
    btnAceptar: TUniBitBtn;
    lblLinea1: TUniLabel;
    lblLinea2: TUniLabel;
    imgGrafico: TUniImage;
    procedure btnAceptarClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmAlerta: TFrmAlerta;

implementation

{$R *.dfm}

uses
  MainModule, UnitCodigosComunesFormulario;

function FrmAlerta: TFrmAlerta;
begin
  Result := TFrmAlerta(UniMainModule.GetFormInstance(TFrmAlerta));
end;

procedure TFrmAlerta.btnAceptarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAlerta.UniFormCreate(Sender: TObject);
begin
  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
       FormularioWhite(Self);
  {$ENDIF}
end;

end.
