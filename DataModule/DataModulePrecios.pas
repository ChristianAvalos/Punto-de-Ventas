unit DataModulePrecios;

interface

uses
  SysUtils, Classes, Data.DB, MemDS, DBAccess, MSAccess, Vcl.Dialogs;

type
  TDMPrecios = class(TDataModule)
    MSPrecio: TMSQuery;
    DSPrecio: TDataSource;
    MSPrecioIdPrecio: TIntegerField;
    MSPrecioIdOrganizacion: TIntegerField;
    MSPrecioMoneda: TStringField;
    MSPrecioDescripcion: TStringField;
    MSPrecioUrevUsuario: TStringField;
    MSPrecioUrevFechaHora: TDateTimeField;
    MSPrecioUrevCalc: TWideStringField;
    procedure MSPrecioAfterCancel(DataSet: TDataSet);
    procedure MSPrecioAfterPost(DataSet: TDataSet);
    procedure MSPrecioBeforeDelete(DataSet: TDataSet);
    procedure MSPrecioBeforeEdit(DataSet: TDataSet);
    procedure MSPrecioBeforeInsert(DataSet: TDataSet);
    procedure MSPrecioBeforeOpen(DataSet: TDataSet);
    procedure MSPrecioBeforePost(DataSet: TDataSet);
    procedure MSPrecioBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure MSPrecioNewRecord(DataSet: TDataSet);
    procedure MSPrecioPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMPrecios: TDMPrecios;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal, FrmDefinicionListaPrecios, UnitCodigosComunesFormulario, UnitValidaciones, UnitRecursoString, UnitCodigosComunesDataModule, UnitDatos;

function DMPrecios: TDMPrecios;
begin
  Result := TDMPrecios(UniMainModule.GetModuleInstance(TDMPrecios));
end;

procedure TDMPrecios.MSPrecioAfterCancel(DataSet: TDataSet);
begin
DeshabilitarControles(FrmDefinicionPrecio);
end;

procedure TDMPrecios.MSPrecioAfterPost(DataSet: TDataSet);
begin
  DeshabilitarControles(FrmDefinicionPrecio);
  FrmDefinicionPrecio.uniStatusBar.Panels.Add.Text := ERegistroGuardado;
end;

procedure TDMPrecios.MSPrecioBeforeDelete(DataSet: TDataSet);
begin
  // Verifico si hay datos relacionados antes de eliminar
  VerificarDatoTablaRelacionada('Definicion.Precio', MSPrecioIdPrecio, FrmDefinicionPrecio);
end;

procedure TDMPrecios.MSPrecioBeforeEdit(DataSet: TDataSet);
begin
  HabilitarControles(FrmDefinicionPrecio);
  FrmDefinicionPrecio.uniStatusBar.Panels.Add.Text := ERegistroEdicion;
end;

procedure TDMPrecios.MSPrecioBeforeInsert(DataSet: TDataSet);
begin
  HabilitarControles(FrmDefinicionPrecio);
end;

procedure TDMPrecios.MSPrecioBeforeOpen(DataSet: TDataSet);
begin
  AsignarIdOrganizacion(DataSet);
end;

procedure TDMPrecios.MSPrecioBeforePost(DataSet: TDataSet);
begin
  // Validaciones antes de guardar
  ValidarCampo(FrmDefinicionPrecio, MSPrecioMoneda, ESeleccioneMoneda);
  ValidarCampo(FrmDefinicionPrecio, MSPrecioDescripcion, EEscribaDescripcion);
  dmBeforePost(DataSet);
end;

procedure TDMPrecios.MSPrecioBeforeUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
  // Activo este parametro solo cuando producto insert
  if MSPrecio.State = dsInsert then
  begin
    Params.ParamByName('IdPrecio').ParamType := ptInputOutput;
  end;
end;

procedure TDMPrecios.MSPrecioNewRecord(DataSet: TDataSet);
begin
  // Establecer valores por defecto
  MSPrecioIdOrganizacion.Value := varOrganizacionID;
end;

procedure TDMPrecios.MSPrecioPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  // Muestro mensajes de error en caso que se produzca
  FrmDefinicionPrecio.MessageDlg(E.Message, mtError, [mbOK]);
  Action := daAbort;
end;

initialization
  RegisterModuleClass(TDMPrecios);

end.
