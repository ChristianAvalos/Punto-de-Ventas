unit UnitVerificarModulo;
{$INCLUDE 'compilador.inc'}
interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils, uniGUITypes, uniGUIDialogs;
function FullPathConfiguracionINI(): string;
function LeerParametrosConfiguracionINI(Segmento: string; NombreParametro: string; MostrarAlerta: Boolean = True): string;
function ObtenerPuertoAplicacion: Integer;
procedure CargarParametrosConfiguracionINIPorDefecto(Segmento: string; NombreParametro: string);
function EscribirParametrosConfiguracionINI(Segmento: string; NombreParametro, Valor: string): string;
function ObtenerNombreModulo: string;

implementation

procedure CargarParametrosConfiguracionINIPorDefecto(Segmento: string; NombreParametro: string);
var
  FullPathExeApp: string;
begin

  // ==== Extrae la Ruta de .exe
  FullPathExeApp := ExtractFilePath(ParamStr(0));

  {$IFDEF UNIGUI_ISAPI}
  FullPathExeApp := UniServerModule.StartPath;
  {$ENDIF}


  // =========== MSSQLSERVER =============================

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'username') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'sa');
  end;

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'password') then
  begin
    //Anterior
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro+'OLD', '0}n???|q0');
    //Nuevo
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, '234DF829DC067C135C5F');

  end;

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'puerto') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, '1433');
  end;

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'server') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'localhost');
  end;

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'database') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'WebID');
  end;

  if (Segmento = 'MSSQLSERVER') and (NombreParametro = 'authentication') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'auServer');
  end;

  // =========== DEMO BaseDatos =============================
  // para pruebas
  if (Segmento = 'DEMO') and (NombreParametro = 'database') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'DEMO.vtg');
  end;

  // =========== APLICACION =============================
  if (Segmento = 'APLICACION') and (NombreParametro = 'puerto') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, '8077');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'titulo') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'Ninguno');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'MostrarTituloPuerto') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'NO');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'RecuperarCredencial')
  then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'NO');
  end;

  //WTF?? enserio crees que va a salir el logotipo???
  if (Segmento = 'APLICACION') and (NombreParametro = 'GraficoLogotipo') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro,  FullPathExeApp + 'files');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'ModoDemo') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'NO');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'Seguridad') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'Motor');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'Seguridad') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'Motor');
  end;

  //=================================== Acceso a otros Modulos =================

  if (Segmento = 'APLICACION') and (NombreParametro = 'URLAlmacen') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'http://localhost:8081');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'URLPatrimonio') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'http://localhost:8080');
  end;

  if (Segmento = 'APLICACION') and (NombreParametro = 'URLNomina') then
  begin
    EscribirParametrosConfiguracionINI(Segmento, NombreParametro, 'http://localhost:8077');
  end;
end;


function FullPathConfiguracionINI(): string;
begin

  // SolO el isapi se comporta de otra manera al leer el INI (ya que depende del servidor web
 // {$IFDEF UNIGUI_ISAPI}
  //Result := UniServerModule.StartPath + 'configuracion.ini';
  //{$ELSE}
  Result := TPath.GetDirectoryName(ParamStr(0)) + TPath.DirectorySeparatorChar + 'configuracion.ini';
  //{$ENDIF}

end;

function LeerParametrosConfiguracionINI(Segmento: string;
  NombreParametro: string; MostrarAlerta: Boolean = True): string;
var
  vArchivoIni: tIniFile;
  sMsg: string;
begin
  // Esta funcion lee los parametros de conexion de la base de datos de un fichero INI
  // Asigno el nombre del fichero INI

  vArchivoIni := tIniFile.Create(FullPathConfiguracionINI);

  // Intento recuperar los valores como resultado
  try

    try
      Result := vArchivoIni.ReadString(Segmento, NombreParametro, Result);

      // En caso que el valor de MostrarMensaje sea verdadero

      if Result = '' then
      begin
        // RhMini y AutoservicioDesktop no carga el valor por defecto
        {$IF NOT (DEFINED(RHMINI) OR
                  DEFINED(AUTOSERVICIODESKTOP))}
        CargarParametrosConfiguracionINIPorDefecto(Segmento, NombreParametro);
        {$ENDIF}
        Result := vArchivoIni.ReadString(Segmento, NombreParametro, Result);
      end;

      if MostrarAlerta = True then
      begin
        // En caso de los puertos vacios, emite alerta
        if Result = '' then
        begin

          sMsg := 'Error: [' + Segmento + '] ' + NombreParametro + ': Par?metro no definido en fichero de configuraci?n INI';


          {$IFDEF WEB}
          MessageDlg(sMsg, mtError, [mbOK]);
          {$ENDIF}
        end;
      end;

    except
      On E: Exception do
      begin
        //Log(EExcepcion + ' - LeerParametrosConfiguracionINI - ' + E.Message);

        {$IFDEF VCL}
          {$IFDEF DESKTOP}
          MessageDlg(EExcepcion + ' - LeerParametrosConfiguracionINI - ' + E.Message, mtError, [mbOK], 0);
          {$ENDIF}
        {$ENDIF}

        {$IFDEF FMX}
        MessageDlg(EExcepcion + ' - LeerParametrosConfiguracionINI - ' + E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        {$ENDIF}
      end;

    end;

  finally
    // Libero el fichero INI
    vArchivoIni.Free;
  end;

end;
function ObtenerPuertoAplicacion: Integer;
var
  PuertoFicheroINI: string;
begin

  // Leo la ruta del fichero ini
  PuertoFicheroINI := LeerParametrosConfiguracionINI('APLICACION', 'puerto');

  // Dependiendo si existe el valor del puerto
  if PuertoFicheroINI = '' then
  begin
    Result := 8077;
  end
  else
    begin
      Result := StrToInt(PuertoFicheroINI);
    end;

end;
function EscribirParametrosConfiguracionINI(Segmento: string; NombreParametro, Valor: string): string;
var
  vArchivoIni: tIniFile;
begin
  // Esta funcion lee los parametros de conexion de la base de datos de un fichero INI
  // Asigno el nombre del fichero INI
  vArchivoIni := tIniFile.Create(FullPathConfiguracionINI);

  // Intento recuperar los valores como resultado
  try
    try

      vArchivoIni.WriteString(Segmento, NombreParametro, Valor);
      Result := 'Escritura del archivo ini exitosa.';

    finally
      // Libero el fichero INI
      vArchivoIni.Free;
    end;

  except
    on E: Exception do
    begin
      Result := 'No se ha podido escribir';
      //Log(EExcepcion + E.Message);
    end;

  end;

end;

function ObtenerNombreModulo: string;
begin
  // Dependiendo del modulo indicado en el compilador condicional
  Result :=
  {$IFDEF PUNTOVENTAS} 'PUNTOVENTAS'; {$ENDIF}
//  {$IFDEF ALMACEN} 'Almacen'; {$ENDIF}
//  {$IFDEF COOPERATIVA} 'Cooperativa'; {$ENDIF}
//  {$IFDEF WEBID} 'WebID'; {$ENDIF}
//  {$IFDEF REPORTEDITOR} 'ReportEditor'; {$ENDIF}
//  {$IFDEF PATRIMONIO} 'Patrimonio'; {$ENDIF}
//  {$IFDEF DOCUMENTALLITE} 'DocumentalLite'; {$ENDIF}
//  {$IFDEF DOCUMENTALTRACK} 'DocumentalTrack'; {$ENDIF}
//  {$IFDEF CAPTURE} 'Capture'; {$ENDIF}
//  {$IFDEF WORKFLOW} 'Workflow'; {$ENDIF}
//  {$IFDEF PRINTDIRECT} 'PrintDirect'; {$ENDIF}
//  {$IFDEF NOTIFICACIONSERVER} 'NotificacionServidor'; {$ENDIF}
//  {$IFDEF CMDUTILS} 'CmdUtils'; {$ENDIF}
//  {$IFDEF MIDDLEWARESERVER} 'MiddlewareServer'; {$ENDIF}
//  {$IFDEF NOMINA} 'Nomina'; {$ENDIF}
//  {$IFDEF CONSOLA} 'Consola'; {$ENDIF}
//  {$IFDEF DOCSOPTIMIZER} 'DocsOptimizer'; {$ENDIF}
//  {$IFDEF PROYECTOVACIO} 'ProyectoVacio'; {$ENDIF}
//  {$IFDEF RHKIT} 'RHKit'; {$ENDIF}
//  {$IFDEF RHMINI} 'RHMini'; {$ENDIF}
//  {$IFDEF ECRM} 'Ecrm'; {$ENDIF}
//  {$IFDEF FINANZAS} 'Finanzas'; {$ENDIF}
//  {$IFDEF TURNOSCONTROLADOR} 'TurnosControlador'; {$ENDIF}
//  {$IFDEF TURNOSCORE} 'TurnosCore'; {$ENDIF}
//  {$IFDEF TURNOSSCREEN} 'TurnosScreen'; {$ENDIF}
//  {$IFDEF RAPY} 'RAPY'; {$ENDIF}
//  {$IFDEF DOCUMENTALAPP} 'DocumentalApp'; {$ENDIF}
//  {$IFDEF AUTOSERVICIOAPP} 'AutoservicioApp'; {$ENDIF}
//  {$IFDEF RELEVAAPP} 'RelevaApp'; {$ENDIF}
//  {$IFDEF AUTOSERVICIOWEB} 'AutoservicioWeb'; {$ENDIF}
//  {$IFDEF AUTOSERVICIODESKTOP} 'AutoservicioDesktop'; {$ENDIF}
//  {$IFDEF TRAMITEWEB} 'TramiteWeb'; {$ENDIF}
//  {$IFDEF MICROCHIPAPP} 'MicrochipApp'; {$ENDIF}
//  {$IFDEF RHRELOJ} 'RHReloj'; {$ENDIF}
//  {$IFDEF AUDITORIA} 'Auditoria'; {$ENDIF}
//  {$IFDEF PRODUCTCRAWLER} 'ProductCrawler'; {$ENDIF}
//  {$IFDEF PRODUCTSERVER} 'ProductServer'; {$ENDIF}
//  {$IFDEF PRODUCTAPP} 'ProductApp'; {$ENDIF}
//  {$IFDEF DYNAMICSLINK} 'DynamicsLink'; {$ENDIF}
//  {$IFDEF UOC} 'UOC'; {$ENDIF}
//  {$IFDEF CONTABILIDAD} 'Contabilidad'; {$ENDIF}
//  {$IFDEF MECIP} 'MECIP'; {$ENDIF}
//  {$IFDEF RUCAUTOMATE} 'RucAutomate'; {$ENDIF}
//  {$IFDEF SYNCRELOJ} 'SyncReloj'; {$ENDIF}
//  {$IFDEF MINIGUI} 'MiniGUI'; {$ENDIF}
//  {$IFDEF MINIMONITOR} 'Minimonitor'; {$ENDIF}
//  {$IFDEF WORKER} 'Worker'; {$ENDIF}
//  {$IFDEF WIOT} 'WIoT'; {$ENDIF};

end;

end.
