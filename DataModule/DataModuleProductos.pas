unit DataModuleProductos;

interface

uses
  SysUtils, Classes, Data.DB, MemDS, DBAccess, MSAccess, Vcl.Dialogs;

type
  TDMProductos = class(TDataModule)
    MSProducto: TMSQuery;
    MSProductoIdProducto: TIntegerField;
    MSProductoIdOrganizacion: TIntegerField;
    MSProductoIdTipoProducto: TIntegerField;
    MSProductoIdGrupoProducto: TIntegerField;
    MSProductoDescripcion: TStringField;
    MSProductoCodigoBarra: TStringField;
    MSProductoSerie: TBooleanField;
    MSProductoLote: TBooleanField;
    MSProductoMemo: TStringField;
    MSProductoIVA_Porcentaje: TFloatField;
    MSProductoIdUnidadMedida: TIntegerField;
    MSProductoSeriePrefijo: TStringField;
    MSProductoUrevUsuario: TStringField;
    MSProductoUrevFechaHora: TDateTimeField;
    MSProductoCodigoAGenerar: TIntegerField;
    MSProductoUrevCalc: TWideStringField;
    DSProducto: TDataSource;
    MSProductoFamiliaDescripcion: TStringField;
    MSProductoPrecios: TMSQuery;
    DSProductoPrecios: TDataSource;
    MSProductoPreciosIdProductoPrecio: TIntegerField;
    MSProductoPreciosIdProducto: TIntegerField;
    MSProductoPreciosIdPrecio: TIntegerField;
    MSProductoPreciosIdMoneda: TIntegerField;
    MSProductoPreciosMonto: TCurrencyField;
    MSProductoPreciosUrevUsuario: TStringField;
    MSProductoPreciosUrevFechaHora: TDateTimeField;
    MSProductoPreciosUrevCalc: TWideStringField;
    MSProductoPreciosMoneda: TStringField;
    MSProductoPreciosPrecio: TStringField;
    procedure MSProductoAfterCancel(DataSet: TDataSet);
    procedure MSProductoAfterPost(DataSet: TDataSet);
    procedure MSProductoAfterScroll(DataSet: TDataSet);
    procedure MSProductoBeforeDelete(DataSet: TDataSet);
    procedure MSProductoBeforeEdit(DataSet: TDataSet);
    procedure MSProductoBeforeInsert(DataSet: TDataSet);
    procedure MSProductoBeforeOpen(DataSet: TDataSet);
    procedure MSProductoBeforePost(DataSet: TDataSet);
    procedure MSProductoBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure MSProductoNewRecord(DataSet: TDataSet);
    procedure MSProductoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure MSProductoPreciosBeforeOpen(DataSet: TDataSet);
    procedure MSProductoPreciosBeforePost(DataSet: TDataSet);
    procedure MSProductoPreciosBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure MSProductoPreciosNewRecord(DataSet: TDataSet);
    procedure MSProductoPreciosPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMProductos: TDMProductos;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal, UnitCodigosComunesDataModule, FormularioProductos, UnitCodigosComunesFormulario, UnitDatos, UnitAuditoria, UnitRecursoString, UnitValidaciones;

function DMProductos: TDMProductos;
begin
  Result := TDMProductos(UniMainModule.GetModuleInstance(TDMProductos));
end;

procedure TDMProductos.MSProductoAfterCancel(DataSet: TDataSet);
begin
  DeshabilitarControles(FrmProductos);

end;

procedure TDMProductos.MSProductoAfterPost(DataSet: TDataSet);
begin
  DMAfterPost(FrmProductos);
end;

procedure TDMProductos.MSProductoAfterScroll(DataSet: TDataSet);
begin
//ActivarDataSetsDetalle([MSArticuloPrecio, MSArticuloPosicion, MSArticuloContable], MSArticuloIdArticulo);
ActivarDataSetsDetalle([MSProductoPrecios], MSProductoIdProducto);
end;

procedure TDMProductos.MSProductoBeforeDelete(DataSet: TDataSet);
begin
  DMBeforeDelete(FrmProductos, TMSQuery(DataSet),'Almacen.Producto', MSProductoIdProducto,
                  True, True, False, False);
end;

procedure TDMProductos.MSProductoBeforeEdit(DataSet: TDataSet);
begin
DMBeforeEdit(FrmProductos);
end;

procedure TDMProductos.MSProductoBeforeInsert(DataSet: TDataSet);
begin
//VerificarExisteDatos(DMComunAlmacen.MSGrupoArticulo, FrmArticulo, ENoDefineGrupoArticulo);
HabilitarControles(FrmProductos);
end;

procedure TDMProductos.MSProductoBeforeOpen(DataSet: TDataSet);
begin
AsignarIdOrganizacion(DataSet);
end;

procedure TDMProductos.MSProductoBeforePost(DataSet: TDataSet);
begin

  // Validaciones antes de guardar
  ValidarCampo(FrmProductos, MSProductoDescripcion, EEscribaDescripcion);
  ValidarCampo(FrmProductos, MSProductoIdGrupoProducto, ESeleccioneGrupoProducto);
  ValidarCampo(FrmProductos, MSProductoIdTipoProducto, ESeleccioneTipoProducto);
  ValidarCampo(FrmProductos, MSProductoIVA_Porcentaje, EEscribaIVA);
  // En caso que sea nulo se pone en vacio
  if MSProductoCodigoBarra.IsNull = True then
  begin
    MSProductoCodigoBarra.Value := '';
  end;
  // Cargo valores de auditoria
  CargarValoresAuditoria(DataSet);
end;

procedure TDMProductos.MSProductoBeforeUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
  // Activo este parametro solo cuando producto insert
  if MSProducto.State = dsInsert then
  begin
    Params.ParamByName('IdProducto').ParamType := ptInputOutput;
  end;
end;

procedure TDMProductos.MSProductoNewRecord(DataSet: TDataSet);
begin
  MSProductoIdOrganizacion.Value := varOrganizacionID;
  // Valores por defecto
  MSProductoIdTipoProducto.Value := 1;
  MSProductoIdUnidadMedida.Value := 1;
  MSProductoIVA_Porcentaje.Value := 10;
  MSProductoCodigoBarra.Value := '0';

  // Cargo valores de auditoria
  CargarValoresAuditoria(DataSet);
end;

procedure TDMProductos.MSProductoPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
 DMPostError(FrmProductos, E, Action);
end;

procedure TDMProductos.MSProductoPreciosBeforeOpen(DataSet: TDataSet);
begin
  AsignarPrincipal(Self.Name, [DataSet]);
  AsignarIdOrganizacion(DataSet);
end;

procedure TDMProductos.MSProductoPreciosBeforePost(DataSet: TDataSet);
begin
  // Validaciones antes de guardar
//  ValidarCampo(FrmArticuloPrecio, MSArticuloPrecioIdPrecio, EseleccionePrecio);
//  ValidarCampo(FrmArticuloPrecio, MSArticuloPrecioIdMoneda, ESeleccioneMoneda);
//  ValidarCampo(FrmArticuloPrecio, MSArticuloPrecioMonto, EEscribaUnValor);


  CargarValoresAuditoria(DataSet);
end;

procedure TDMProductos.MSProductoPreciosBeforeUpdateExecute(
  Sender: TCustomMSDataSet; StatementTypes: TStatementTypes; Params: TMSParams);
begin
   // Activo este parametro solo cuando producto insert
  if MSProductoPrecios.State = dsInsert then
  begin
    Params.ParamByName('IdProductoPrecio').ParamType := ptInputOutput;
  end;
end;

procedure TDMProductos.MSProductoPreciosNewRecord(DataSet: TDataSet);
begin
  MSProductoPreciosIdProducto.Value := MSProductoIdProducto.Value;
  MSProductoPreciosIdMoneda.Value := 1;
  MSProductoPreciosIdProductoPrecio.Value := 1;
end;

procedure TDMProductos.MSProductoPreciosPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  // Muestro mensajes de error en caso que se produzca
  FrmProductos.MessageDlg(E.Message, mtError, [mbOK]);
  // Capturo en el archivo de log, el error
  Action := daAbort;
end;

initialization
  RegisterModuleClass(TDMProductos);

end.
