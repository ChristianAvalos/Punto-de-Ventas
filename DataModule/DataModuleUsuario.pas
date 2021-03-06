unit DataModuleUsuario;
{$INCLUDE 'compilador.inc'}
interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, MSAccess,
   vcl.Dialogs, DAScript, MSScript, System.VarUtils, System.Variants, System.StrUtils,

  {$IFDEF WEB}
  uniGUIDialogs, uniMainMenu;
  {$ENDIF}
type
    TUsuarioRecord = record
    IdUsuario: integer;
    IdOrganizacion: Integer;
    LoginUsuario: string;
    Contrasena: string;
    NombresApellidos: string;
    Email: string;
    Foto: TBlobField;
    OcultarMenuSinAcceso: Boolean;
    LDAP: Boolean;



//    DocumentoNro: string;
//    IdPersonal: integer;
//    IdMedico: Integer;
//    IdPersona: integer;

//
//    AdministradorPortal: Boolean;
//    AdministradorRHMini: Boolean;
//    AdministradorMiddleware: Boolean;
//    AdministradorAutoservicio: Boolean;
//    Evaluador: Boolean;

//    IdOrganigrama: Integer;
//    IdConcesionario: Integer
    end;
  TDMUsuario = class(TDataModule)
    MSExisteUsuarios: TMSQuery;
    MSExisteUsuariosCantidadUsuarios: TIntegerField;
    MSUsuario: TMSQuery;
    DSUsuario: TDataSource;
    MSVerificarPermiso: TMSQuery;
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
    DSPermisosDisponibles: TDataSource;
    MSPermisosDisponibles: TMSQuery;
    MSPermisosDisponiblesIdPermiso: TIntegerField;
    MSPermisosDisponiblesIdUsuario: TIntegerField;
    MSPermisosDisponiblesModulo: TStringField;
    MSPermisosDisponiblesObjetoComponente: TStringField;
    MSPermisosDisponiblesTipoComponente: TStringField;
    MSPermisosDisponiblesTipoAcceso: TStringField;
    MSPermisosDisponiblesUrevFechaHora: TDateTimeField;
    MSPermisosDisponiblesUrevUsuario: TStringField;
    MSPermisosDisponiblesUrevCalc: TWideStringField;
    MSVerificarPermisoIdPermiso: TIntegerField;
    MSVerificarPermisoIdUsuario: TIntegerField;
    MSVerificarPermisoModulo: TStringField;
    MSVerificarPermisoObjetoComponente: TStringField;
    MSVerificarPermisoTipoComponente: TStringField;
    MSVerificarPermisoTipoAcceso: TStringField;
    MSVerificarPermisoUrevFechaHora: TDateTimeField;
    MSVerificarPermisoUrevUsuario: TStringField;
    MSVerificarPermisoUrevCalc: TWideStringField;
    MSInsertarOperacion: TMSQuery;
    MSBorrarPermiso: TMSSQL;
    MSRol: TMSQuery;
    MSRolIdRol: TIntegerField;
    MSRolDescripcion: TStringField;
    MSRolUrevUsuario: TStringField;
    MSRolUrevFechaHora: TDateTimeField;
    MSRolUrevCalc: TWideStringField;
    DSRol: TDataSource;
    MSRolOperacion: TMSQuery;
    MSRolOperacionIdRolOperacion: TIntegerField;
    MSRolOperacionIdRol: TIntegerField;
    MSRolOperacionIdOperacion: TIntegerField;
    MSRolOperacionUrevUsuario: TStringField;
    MSRolOperacionUrevFechaHora: TDateTimeField;
    MSRolOperacionUrevCalc: TWideStringField;
    MSRolOperacionIdModulo: TIntegerField;
    MSRolOperacionObjetoComponente: TStringField;
    MSRolOperacionTipoComponente: TStringField;
    MSRolOperacionCaption: TStringField;
    DSRolOperacion: TDataSource;
    MSInsertarRolOperacion: TMSQuery;
    MSVerificarOperacion: TMSQuery;
    MSBorrarOperacion: TMSQuery;
    MSUsuarioOcultarMenuSinAcceso: TBooleanField;
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
    procedure MSUsuarioAfterDelete(DataSet: TDataSet);
    procedure MSPermisosDisponiblesBeforePost(DataSet: TDataSet);
    procedure MSVerificarPermisoBeforeOpen(DataSet: TDataSet);
    procedure MSVerificarPermisoBeforePost(DataSet: TDataSet);
    procedure MSVerificarPermisoNewRecord(DataSet: TDataSet);
    procedure MSRolOperacionBeforeOpen(DataSet: TDataSet);
    procedure MSRolOperacionNewRecord(DataSet: TDataSet);
    procedure MSInsertarRolOperacionBeforeOpen(DataSet: TDataSet);
    procedure MSVerificarOperacionBeforeOpen(DataSet: TDataSet);
    procedure MSUsuarioBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    FEnviadoDesdeFrm, FUsuarioBorrar: string;
    Activo: Boolean;
  public
    { Public declarations }
  function VerificarPrivilegios(NombreObjeto: String; VerificarTipoAcceso: Boolean = False; MostrarAlertaPermiso: Boolean = True ;  Abortar : Boolean= true): Boolean;

  property UsuarioBorrar: string read FUsuarioBorrar write FUsuarioBorrar;
      var
    UsuarioRecord: TUsuarioRecord;

    published
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

function DMUsuario: TDMUsuario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal, UnitCodigosComunesDataModule, UnitVerificarModulo, UnitValidarUsuario,
   UnitRecursoString, UnitCodigosComunes, UnitCodigosComunesFormulario, UnitCodigosComunesString,
   SCrypt, FormularioUsuario, FormularioCRUDMaestro, UnitValidaciones, UnitOperacionesFotografia, Main, UnitEncriptacion,
   ServerModule,uniGUIApplication,UnitDatos,
    {$IFDEF WEB}
    FormularioAlerta;
    {$ENDIF}

function DMUsuario: TDMUsuario;
begin
  Result := TDMUsuario(UniMainModule.GetModuleInstance(TDMUsuario));
end;

procedure TDMUsuario.MSInsertarRolOperacionBeforeOpen(DataSet: TDataSet);
begin
  MSInsertarRolOperacion.ParamByName('Modulo').Value := ObtenerNombreModulo;
  MSInsertarRolOperacion.ParamByName('IdRol').Value := MSRolIdRol.Value;
end;

procedure TDMUsuario.MSPermisosDisponiblesBeforePost(DataSet: TDataSet);
begin
DMBeforePost(DataSet);
end;

procedure TDMUsuario.MSRolOperacionBeforeOpen(DataSet: TDataSet);
begin
MSRolOperacion.ParamByName('Modulo').Value := ObtenerNombreModulo;
MSRolOperacion.ParamByName('IdRol').Value := MSRolIdRol.Value;
end;

procedure TDMUsuario.MSRolOperacionNewRecord(DataSet: TDataSet);
begin
MSRolOperacionidRol.Value := MSRolIdRol.Value;
end;

procedure TDMUsuario.MSUsuarioAfterCancel(DataSet: TDataSet);
begin
  {$IFDEF WEB}
    DMAfterCancel(FrmUsuario);
  {$ENDIF}
end;

procedure TDMUsuario.MSUsuarioAfterDelete(DataSet: TDataSet);
begin
  // En caso que la seguridad del motor
  if LeerParametrosConfiguracionINI('APLICACION', 'Seguridad', False) = 'Motor' then
  begin
    // Borro el usuario
    if UsuarioBorrar <> '' then
    begin
      // Se deshabilita el usuario, pero no se borra
      CrearUsuarioSQLServer(UsuarioBorrar, Contrasena, False);
    end;
  end;
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
 // Activo: Boolean;
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
  DMBeforeDelete(FrmUsuario, TMSQuery(DataSet), 'Usuario.Usuario', MSUsuarioIdUsuario, True, True);
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

procedure TDMUsuario.MSUsuarioBeforeOpen(DataSet: TDataSet);
begin
AsignarIdOrganizacion(DataSet);
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
    // Determino si el usuario tiene o no contrase?a definida

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
  MSUsuarioOcultarMenuSinAcceso.Value := True;
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

procedure TDMUsuario.MSVerificarOperacionBeforeOpen(DataSet: TDataSet);
begin
MSVerificarOperacion.ParamByName('IdRol').Value := MSRolIdRol.Value;
end;

procedure TDMUsuario.MSVerificarPermisoBeforeOpen(DataSet: TDataSet);
begin
{$IFDEF WEB}
  TMSQuery(DataSet).ParamByName('Modulo').Value := ObtenerNombreModulo;
{$ENDIF}
end;

procedure TDMUsuario.MSVerificarPermisoBeforePost(DataSet: TDataSet);
begin
{$IFDEF WEB}
  MSVerificarPermisoModulo.Value := ObtenerNombreModulo;
{$ENDIF}
  DMBeforePost(DataSet);
end;

procedure TDMUsuario.MSVerificarPermisoNewRecord(DataSet: TDataSet);
begin
  // El Id del usuario maestro
  DMUsuario.MSVerificarPermisoIdUsuario.Value := DMUsuario.MSUsuarioIdUsuario.Value;

  // De acuerdo al modulo asigno el valor inicial
  DMUsuario.MSVerificarPermisoModulo.Value := ObtenerNombreModulo;
end;

function TDMUsuario.VerificarPrivilegios(NombreObjeto: String; VerificarTipoAcceso: Boolean = False;
MostrarAlertaPermiso: Boolean = True ;  Abortar : Boolean= true): Boolean;
//  Ej.
//  Boton : Self.Name + '.' + TUniButton(Sender).Name
//  Menu  : TUniMenuItem(Sender).Name
//  DMUsuario.VerificarPrivilegios(Self.Name + '.' + TUniButton(Sender).Name);
{$IFDEF DESKTOP}
var
  FrmAlerta: TFrmAlerta;
{$ENDIF}
begin

  MSVerificarPermiso.Close;
  MSVerificarPermiso.ParamByName('IdUsuario').Value := UsuarioRecord.IdUsuario;
  // Dependienco del Modulo paso el parametro restante
  MSVerificarPermiso.ParamByName('Modulo').Value := ObtenerNombreModulo;

  MSVerificarPermiso.ParamByName('ObjetoComponente').Value := NombreObjeto;
  MSVerificarPermiso.Open;

  //Si hay un permiso (en el query esta TOP 1, funciona bien, no tocar)
  if DMUsuario.MSVerificarPermiso.RecordCount = 1 then
  begin

    Result := True;

    // caso de verificar el tipo de Acceso, es True
    if VerificarTipoAcceso = True then
    begin
      // Si el acceso es solo lectura, emitira el aviso de contactar al usuario
      if MSVerificarPermisoTipoAcceso.Value = 'S?lo lectura' then
      begin
        Result := False;

        {$IFDEF WEB}
        if MostrarAlertaPermiso = True then
        begin
          FrmAlerta.ShowModal;
          if (Abortar) then  Abort;
        end;
        {$ENDIF}
      end;

    end


  end
  else // En caso que exista registro
    begin

      Result := False;

      if MostrarAlertaPermiso = True then
      begin
        {$IFDEF WEB}
        FrmAlerta.ShowModal;
        if (Abortar) then  Abort;
        {$ENDIF}

        {$IFDEF DESKTOP}
        FrmAlerta := TFrmAlerta.Create(nil);

        try
          FrmAlerta.ShowModal;
        finally
          FrmAlerta.Free;
        end;
        {$ENDIF}

      end;

    end;

  {$IFDEF WEB}
  //Si pudo logear, ingresar al sistema el acceso
  if Result = True then
  begin
    CapturarSesion(NombreObjeto);
  end;
  {$ENDIF}

end;

initialization
  RegisterModuleClass(TDMUsuario);

end.
