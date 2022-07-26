unit DataModuleCondiciondePago;

interface

uses
  SysUtils, Classes, Data.DB, MemDS, DBAccess, MSAccess, uniGUIForm, Vcl.Dialogs;

type
  TDMCondiciondePago = class(TDataModule)
    MSCondicionPago: TMSQuery;
    MSCondicionPagoIdCondicionPago: TIntegerField;
    MSCondicionPagoIdOrganizacion: TIntegerField;
    MSCondicionPagoDescripcion: TStringField;
    MSCondicionPagoUrevUsuario: TStringField;
    MSCondicionPagoUrevFechaHora: TDateTimeField;
    MSCondicionPagoUrevCalc: TWideStringField;
    DSCondicionPago: TDataSource;
    MSCondicionPagoTipoPago: TStringField;
    DSBuscadorCondicionPago: TDataSource;
    MSBuscadorCondicionPago: TMSQuery;
    MSBuscadorCondicionPagoIdCondicionPago: TIntegerField;
    MSBuscadorCondicionPagoDescripcion: TStringField;
    MSBuscadorCondicionPagoTipoPago: TStringField;
    procedure MSCondicionPagoAfterCancel(DataSet: TDataSet);
    procedure MSCondicionPagoAfterPost(DataSet: TDataSet);
    procedure MSCondicionPagoBeforeDelete(DataSet: TDataSet);
    procedure MSCondicionPagoBeforeEdit(DataSet: TDataSet);
    procedure MSCondicionPagoBeforeInsert(DataSet: TDataSet);
    procedure MSCondicionPagoBeforeOpen(DataSet: TDataSet);
    procedure MSCondicionPagoBeforePost(DataSet: TDataSet);
    procedure MSCondicionPagoNewRecord(DataSet: TDataSet);
    procedure MSCondicionPagoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure MSCondicionPagoBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMCondiciondePago: TDMCondiciondePago;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal, UnitCodigosComunesFormulario,
  FormularioCRUDMaestro, UnitValidaciones, UnitRecursoString, UnitCodigosComunesDataModule,
  FormularioCondicionPago, DataModuleComunUsuario;

function DMCondiciondePago: TDMCondiciondePago;
begin
  Result := TDMCondiciondePago(UniMainModule.GetModuleInstance(TDMCondiciondePago));
end;

procedure TDMCondiciondePago.MSCondicionPagoAfterCancel(DataSet: TDataSet);
begin
  DeshabilitarControles(FrmCondiciondePago);
end;

procedure TDMCondiciondePago.MSCondicionPagoAfterPost(DataSet: TDataSet);
begin
 DeshabilitarControles(FrmCondiciondePago);
 FrmCondiciondePago.uniStatusBar.Panels.Add.Text := ERegistroGuardado;
 DMAfterPost(FrmCondiciondePago);
end;

procedure TDMCondiciondePago.MSCondicionPagoBeforeDelete(DataSet: TDataSet);
begin
  VerificarDatoTablaRelacionada('Definicion.CondicionPago', MSCondicionPagoIdCondicionPago, FrmCondiciondePago);
end;

procedure TDMCondiciondePago.MSCondicionPagoBeforeEdit(DataSet: TDataSet);
begin
  HabilitarControles(FrmCondiciondePago);
  FrmCondiciondePago.uniStatusBar.Panels.Add.Text := ERegistroEdicion;
end;

procedure TDMCondiciondePago.MSCondicionPagoBeforeInsert(DataSet: TDataSet);
begin
HabilitarControles(FrmCondiciondePago);
end;

procedure TDMCondiciondePago.MSCondicionPagoBeforeOpen(DataSet: TDataSet);
begin
//MSCondicionPago.Params.ParamByName('IdOrganizacion').Value := 1;
end;

procedure TDMCondiciondePago.MSCondicionPagoBeforePost(DataSet: TDataSet);
begin
  ValidarCampo(FrmCondiciondePago, MSCondicionPagoTipoPago, ESeleccioneTipoCondicionPago);
  ValidarCampo(FrmCondiciondePago, MSCondicionPagoDescripcion, EEscribaDescripcion);

  DMBeforePost(DataSet);


end;

procedure TDMCondiciondePago.MSCondicionPagoBeforeUpdateExecute(
  Sender: TCustomMSDataSet; StatementTypes: TStatementTypes; Params: TMSParams);
begin
  // Activo este parametro solo cuando producto insert
  if MSCondicionPago.State = dsInsert then
  begin
    Params.ParamByName('IdCondicionPago').ParamType := ptInputOutput;
  end;
end;

procedure TDMCondiciondePago.MSCondicionPagoNewRecord(DataSet: TDataSet);
begin
MSCondicionPagoIdOrganizacion.Value := varOrganizacionID;
end;

procedure TDMCondiciondePago.MSCondicionPagoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  // Muestro mensajes de error en caso que se produzca
  FrmCondiciondePago.MessageDlg(E.Message, mtError, [mbOK]);
  Action := daAbort;
end;

initialization
  RegisterModuleClass(TDMCondiciondePago);

end.
