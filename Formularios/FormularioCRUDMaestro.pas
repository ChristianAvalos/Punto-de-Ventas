

unit FormularioCRUDMaestro;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Data.DB, MSAccess, uniFileUpload,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FrameBarraEstado, FrameBarraNavegacionPrincipal,
  uniGUIFrame, FrameBarraInformacionOrganizacionUsuario, uniGUIBaseClasses,
  uniStatusBar, uniToolBar, ServerModule, uniGUIApplication, uniImageList,
  System.DateUtils, System.StrUtils;

type
    TFrmCRUDMaestro = class(TUniForm)
    FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario;
    FmeBarraNavegacionPrincipal: TFmeBarraNavegacionPrincipal;
    UniStatusBar: TUniStatusBar;
    uNativeImg: TUniNativeImageList;
    procedure UniFormCreate(Sender: TObject);
    procedure FmeBarraNavegacionPrincipaltbtnBuscarClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure FmeBarraNavegacionPrincipalCreate(Sender: TObject);
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

function FrmCRUDMaestro: TFrmCRUDMaestro;

implementation

{$R *.dfm}

uses
  MainModule, UnitCodigosComunesFormulario, UnitRecursoString, UnitCodigosComunesDataModule,
  UnitValidaciones, DataModulePrincipal,// FormularioJiraReportarIncidencia,
  UnitSoporte;


function FrmCRUDMaestro: TFrmCRUDMaestro;
begin
  Result := TFrmCRUDMaestro(UniMainModule.GetFormInstance(TFrmCRUDMaestro));
end;


procedure TFrmCRUDMaestro.FmeBarraNavegacionPrincipalCreate(Sender: TObject);
begin
  FmeBarraNavegacionPrincipal.UniFrameCreate(Sender);
end;


procedure TFrmCRUDMaestro.FmeBarraNavegacionPrincipaltbtnBuscarClick
  (Sender: TObject);
begin
  if TMSQuery(FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource.DataSet).Active then
  begin
    if TMSQuery(FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource.DataSet).State in dsEditModes then
    begin
      Self.MessageDlg('Ediccion', mtWarning, [mbOK]);
      Abort;
    end;
  end;
end;


procedure TFrmCRUDMaestro.UniFormAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
begin
  EventoAjax(Sender, Self, EventName, Params);
end;


procedure TFrmCRUDMaestro.UniFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    // Verificar la operacion antes de salir
  if FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource <> nil then
  //VerificarAbandonarOperacion(TMSQuery(FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource.DataSet), Self, Action);
end;


procedure TFrmCRUDMaestro.UniFormCreate(Sender: TObject);
begin
 //AgregarBotonSoporte(Self);

  DestacarCampos(Self);

  LocalizarEspanolUniFileUpload(Self);

  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
       FormularioWhite(Self);
  {$ENDIF}


  // Asigno etiquetas al Hint de cada boton en el Navegador
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[0].setTooltip("Primer registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[1].setTooltip("Anterior registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[2].setTooltip("Siguiente registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[3].setTooltip("Ultimo registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[4].setTooltip("Nuevo registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[5].setTooltip("Borrar registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[6].setTooltip("Editar registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[7].setTooltip("Guardar registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[8].setTooltip("Cancelar registro")');
  UniSession.AddJS(FmeBarraNavegacionPrincipal.UniDBNavigator.JSName +  '.items.items[9].setTooltip("Actualizar registro")');


end;


procedure TFrmCRUDMaestro.UniFormShow(Sender: TObject);
begin
  // Ir al ultimo registro
  if FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource <> nil then
  begin
    DeshabilitarControles(Self);

    IrUltimoRegistro(TMSQuery(FmeBarraNavegacionPrincipal.UniDBNavigator.DataSource.DataSet), Self);
  end;

  //Muevo los Label para que se ajuste la organizacion,
  FmeBarraInformacionOrganizacionUsuario.lblEtiquetaUsuario.Left := (Self.Width -110);
  FmeBarraInformacionOrganizacionUsuario.lblUsuario.Left := (Self.Width -68);

  //lblOrganizacion
  FmeBarraInformacionOrganizacionUsuario.lblOrganizacion.Width := (FmeBarraInformacionOrganizacionUsuario.lblEtiquetaUsuario.Left-80);

end;

end.
