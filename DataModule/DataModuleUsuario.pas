unit DataModuleUsuario;
{$INCLUDE 'compilador.inc'}
interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, MSAccess,
   vcl.Dialogs, DAScript, MSScript, System.VarUtils, System.Variants, System.StrUtils;

type
    TUsuarioRecord = record
    IdUsuario: integer;
    LoginUsuario: string;
    Contrasena: string;

    Email: string;
    NombresApellidos: string;
    DocumentoNro: string;
    IdPersonal: integer;
    IdMedico: Integer;
    IdPersona: integer;
    Foto: TBlobField;
    OcultarMenuSinAcceso: Boolean;
    AdministradorPortal: Boolean;
    AdministradorRHMini: Boolean;
    AdministradorMiddleware: Boolean;
    AdministradorAutoservicio: Boolean;
    Evaluador: Boolean;
    LDAP: Boolean;
    IdOrganigrama: Integer;
    IdConcesionario: Integer
    end;
  TDMUsuario = class(TDataModule)
    MSExisteUsuarios: TMSQuery;
    MSExisteUsuariosCantidadUsuarios: TIntegerField;
    MSUsuario: TMSQuery;
    DSUsuario: TDataSource;
    MSVerificarPermiso: TMSQuery;
    IntegerField2: TIntegerField;
    DSVerificarPermiso: TDataSource;
    MSUsuarioIdUsuario: TIntegerField;
    MSUsuarioIdOrganizacion: TIntegerField;
    MSUsuarioNombreUsuario: TStringField;
    MSUsuarioContrasena: TStringField;
    MSUsuarioEmail: TStringField;
    MSUsuarioActivo: TBooleanField;
    MSUsuarioNombresApellidos: TStringField;
    MSUsuarioFoto: TBlobField;
    MSUsuarioDocumentoNro: TStringField;
    MSUsuarioObservacion: TStringField;
    MSUsuarioUrevUsuario: TStringField;
    MSUsuarioUrevFechaHora: TDateTimeField;
    MSUsuarioUrevCalc: TWideStringField;
    MSScriptCrearUsuario: TMSScript;
    MSScriptBorrarUsuario: TMSScript;
    MSUsuarioPasswordStatus: TStringField;
    MSCambiarMiContrasena: TMSQuery;
    MSUsuarioTemplate: TBlobField;
    procedure MSUsuarioAfterCancel(DataSet: TDataSet);
    procedure MSUsuarioAfterPost(DataSet: TDataSet);
    procedure MSUsuarioAfterUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure MSUsuarioBeforeDelete(DataSet: TDataSet);
    procedure MSUsuarioBeforeEdit(DataSet: TDataSet);
    procedure MSUsuarioBeforeInsert(DataSet: TDataSet);
    procedure MSUsuarioBeforePost(DataSet: TDataSet);
    procedure MSUsuarioBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure MSUsuarioNewRecord(DataSet: TDataSet);
    procedure MSUsuarioPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure MSUsuarioCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    FEnviadoDesdeFrm, FUsuarioBorrar: string;

  public
    { Public declarations }

  property UsuarioBorrar: string read FUsuarioBorrar write FUsuarioBorrar;
      var
    UsuarioRecord: TUsuarioRecord;
    Activo: Boolean;
    published
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

function DMUsuario: TDMUsuario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal, UnitCodigosComunesDataModule, UnitVerificarModulo, UnitValidarUsuario,
   UnitRecursoString, UnitCodigosComunes, UnitCodigosComunesFormulario, UnitCodigosComunesString, SCrypt, FormularioUsuario, FormularioCRUDMaestro, UnitValidaciones, UnitOperacionesFotografia, Main;

function DMUsuario: TDMUsuario;
begin
  Result := TDMUsuario(UniMainModule.GetModuleInstance(TDMUsuario));
end;

procedure TDMUsuario.MSUsuarioAfterCancel(DataSet: TDataSet);
begin
  {$IFDEF WEB}
    DMAfterCancel(FrmUsuario);
  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioAfterPost(DataSet: TDataSet);
begin
  {$IFDEF WEB}
    DMAfterPost(FrmUsuario);

    // Refresco los datos del usuario actual, si coincide con que hago de hacer post
  if DMUsuario.MSUsuarioIdUsuario.Value = DMUsuario.UsuarioRecord.IdUsuario then
  begin
    // Actualizo primero el record actual del usuario
    DMUsuario.UsuarioRecord.LoginUsuario := DMUsuario.MSUsuarioNombreUsuario.Value;

    // Actualizo el dataset
    DMPrincipal.MSVerificarUsuario.Close;
    DMPrincipal.MSVerificarUsuario.ParamByName('NombreUsuario').AsString := DMUsuario.UsuarioRecord.LoginUsuario;
    DMPrincipal.MSVerificarUsuario.Open;
    // Actualizo la foto actual
    DMUsuario.UsuarioRecord.Foto := DMPrincipal.MSVerificarUsuarioFoto;
    CargarFotoPerfil(TImagePerfil(MainForm.imgFotoUsuario));
    end;

  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioAfterUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
var
  //Activo: Boolean;
  NombreUsuario: string;

begin
  if (StatementTypes = [stInsert]) then
  begin
    NombreUsuario := Params.ParamByName('NombreUsuario').AsString;
    Activo := Params.ParamByName('Activo').AsBoolean;

    // En caso que la seguridad del motor
    if LeerParametrosConfiguracionINI('APLICACION', 'Seguridad', False) = 'Motor' then
    begin
      // Creo el usuario con la contrasena por default
        CrearUsuarioSQLServer(NombreUsuario, '123456', Activo);
    end;

  end;
end;
end;

procedure TDMUsuario.MSUsuarioBeforeDelete(DataSet: TDataSet);
begin
  UsuarioBorrar := MSUsuarioNombreUsuario.Value;

  {$IFDEF WEB}
 //   DMBeforeDelete(FrmUsuario, TMSQuery(DataSet), 'Usuario.Usuario', MSUsuarioIdUsuario, True, True);
  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioBeforeEdit(DataSet: TDataSet);
begin
  {$IFDEF WEB}
    DMBeforeEdit(FrmUsuario);
  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioBeforeInsert(DataSet: TDataSet);
begin
  {$IFDEF WEB}
    DMBeforeInsert(FrmUsuario);
  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioBeforePost(DataSet: TDataSet);
begin
  // Hago trim con el nombre de usuario, siempre y cuando no sea el administrador
  if MSUsuarioNombreUsuario.Value <> 'Admin' then
  begin
    MSUsuarioNombreUsuario.Value := LowerCase(Trim(MSUsuarioNombreUsuario.Value));
  end;
  {$IFDEF WEB}
  // Valido los parametros de usuario
  ValidarCampo(FrmUsuario, MSUsuarioNombreUsuario, 'Escriba usuario', StringVacio);
  VerificarValorRepetido('Usuario.Usuario', [MSUsuarioNombreUsuario], FrmUsuario, 'Usuario ya existe', True);
  ValidarCampo(FrmUsuario, MSUsuarioNombresApellidos , 'Escriba nombre o apellido', StringVacio);
   {$ENDIF}

     // Valido que no introduzcan caracteres raros
  if CaracteresASCIIEstandar(MSUsuarioNombreUsuario.Value) = False then
  begin
    {$IFDEF WEB}
    FrmUsuario.MessageDlg(EUsuarioCaracterInvalido, mtError, [mbOK]);
    {$ENDIF}

    {$IFDEF DESKTOP}
    MessageDlg(EUsuarioCaracterInvalido, mtError, [mbOK], 0);
    {$ENDIF}

    Abort;
  end;
  DMBeforePost(DataSet);
end;

procedure TDMUsuario.MSUsuarioBeforeUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
  DMBeforeUpdateExecute(Sender, Params);
end;

procedure TDMUsuario.MSUsuarioCalcFields(DataSet: TDataSet);
begin
    // Determino si el usuario tiene o no contraseņa definida

    if MSUsuarioContrasena.Value = '' then
    begin
      MSUsuarioPasswordStatus.Value := 'No establecida' ;
    end
    else
      begin
        MSUsuarioPasswordStatus.Value := 'Establecida';
      end;

end;

procedure TDMUsuario.MSUsuarioNewRecord(DataSet: TDataSet);

begin
  MSUsuarioIdOrganizacion.Value := 1;
  MSUsuarioActivo.Value := True;
  // Parametro por defecto del usuario
   MSUsuarioContrasena.Value := TScrypt.HashPassword('123456');
end;

procedure TDMUsuario.MSUsuarioPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  {$IFDEF WEB}
    DMPostError(FrmUsuario, E, Action);
  {$ENDIF}
end;

initialization
  RegisterModuleClass(TDMUsuario);

end.
