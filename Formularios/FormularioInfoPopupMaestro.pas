unit FormularioInfoPopupMaestro;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,System.DateUtils, System.StrUtils, uniFileUpload,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniButton, uniBitBtn, uniGUIBaseClasses, uniPanel,
  uniImageList;

type
  TFrmInfoPopupMaestro = class(TUniForm)
    UniPanelBotonesVertical: TUniPanel;
    UniPanelBotonesHorizontal: TUniPanel;
    btnCerrar: TUniBitBtn;
    UniNativeImageList: TUniNativeImageList;
    UniImageList: TUniNativeImageList;
    procedure btnCerrarClick(Sender: TObject);
    procedure UniFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure UniFormToolClick(Sender: TUniCustomButtonItem);
  private
    { Private declarations }
    FEnviadoDesdeFrm: string;
  public
    { Public declarations }

  published
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

function FrmInfoPopupMaestro: TFrmInfoPopupMaestro;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, UnitCodigosComunesFormulario,
  //FormularioJiraReportarIncidencia,
  UnitSoporte;

function FrmInfoPopupMaestro: TFrmInfoPopupMaestro;
begin
  Result := TFrmInfoPopupMaestro(UniMainModule.GetFormInstance(TFrmInfoPopupMaestro));
end;


procedure TFrmInfoPopupMaestro.btnCerrarClick(Sender: TObject);
begin
  // Este es un potencial problema a resolver
  Close;
end;


procedure TFrmInfoPopupMaestro.UniFormAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
begin
  EventoAjax(Sender, Self, EventName, Params);
end;


procedure TFrmInfoPopupMaestro.UniFormCreate(Sender: TObject);
begin
  AgregarBotonSoporte(Self);

  DestacarCampos(Self);
end;


procedure TFrmInfoPopupMaestro.UniFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Deteccion de presion de teclas
  case Key of
    13: // 'Enter', // Detecto si se ha presionado las teclas Ctrl + Enter
      if ssCtrl in Shift then
      begin
        Close;
      end;
  end;

end;


procedure TFrmInfoPopupMaestro.UniFormToolClick(Sender: TUniCustomButtonItem);
var
  i: integer;
begin
//  with Self.WebForm do
//  begin
//    JSInterface.JSCode('html2canvas(document.querySelector("#' + JSId +'")).then(function(canvas) {ajaxRequest('#1', "getData", ["base64Data="+canvas.toDataURL()])});');
//  end;
//
//  if Sender.ButtonId = 0 then
//  begin
//    // Envio archivos adjuntos
//    for i := 0 to Self.ComponentCount - 1 do
//    begin
//      if Self.Components[i].ClassType = TUniFileUpload then
//      begin
//        if TUniFileUpload(Self.Components[i]).Files[0].Success = True then
//        begin
//          FrmJiraReportarIncidencia.AgregatAdjunto(TUniFileUpload(Self.Components[i]).Files[0].OriginalFileName,
//                                                   TUniFileUpload(Self.Components[i]).Files[0].CacheFile);
//        end;
//
//      end;
//    end;
//
//    FrmJiraReportarIncidencia.EnviadoDesdeFrm := Self.Name;
//    FrmJiraReportarIncidencia.ShowModal();
//  end;
end;

end.
