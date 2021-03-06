

unit FormularioPopupCRUDMaestro;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, uniFileUpload,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIForm, uniBitBtn,
  uniButton, System.DateUtils, System.StrUtils, uniGUIBaseClasses, uniPanel,
  uniImageList;

type
  TFrmPopupCRUDMaestro = class(TUniForm)
    UniPanelBotonesVertical: TUniPanel;
    UniPanelBotonesHorizontal: TUniPanel;
    btnAceptar: TUniBitBtn;
    btnCancelar: TUniBitBtn;
    uNativeImg: TUniNativeImageList;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
  private
    { Private declarations }
    FEnviadoDesdeFrm: string;
  public
    { Public declarations }
  published
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

function FrmPopupCRUDMaestro: TFrmPopupCRUDMaestro;

implementation

{$R *.dfm}

uses
  MainModule, UnitSoporte, UnitCodigosComunesFormulario;
 // FormularioJiraReportarIncidencia,



function FrmPopupCRUDMaestro: TFrmPopupCRUDMaestro;
begin
  Result := TFrmPopupCRUDMaestro(UniMainModule.GetFormInstance(TFrmPopupCRUDMaestro));
end;


procedure TFrmPopupCRUDMaestro.UniFormAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
begin
  EventoAjax(Sender, Self, EventName, Params);
end;


procedure TFrmPopupCRUDMaestro.UniFormCreate(Sender: TObject);
begin

  AgregarBotonSoporte(Self);

  DestacarCampos(Self);

  LocalizarEspanolUniFileUpload(Self);

  {$IFDEF RAPY}
  FormularioWhite(Self);
  {$ENDIF}

end;


end.
