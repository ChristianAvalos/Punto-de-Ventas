unit UnitArchivos;

{$INCLUDE 'compilador.inc'}

interface

uses
  System.Types, System.NetEncoding,

{$IFDEF WEB}
  UniGuiApplication, ServerModule, uniGUIDialogs, uniGUIForm, uniGUITypes,
  DataModuleUsuario,
{$ENDIF}
  System.Classes, WinApi.Windows, UnitCodigosComunesString,
  System.SysUtils, System.IOUtils;

type
  TGrupoArchivo = (Biometrico, Imagen, IPWorks, Javascript);

function BorrarArchivo(Archivo: String): Boolean;
function CopiarArchivosPathExtension(Path, Extension, PathDestino: String; Cantidad: Integer = 0; CaracteresOmitir: String = ''): Boolean;
procedure FindFiles(StartDir, FileMask: string; recursively: Boolean; var FilesList: TStringList);
function CopiarArchivo(Archivo, Destino: String): string;
function VerificarValidoLogotipoFondo(): Boolean;
function VerificarValidoLogotipoAplicacion(): Boolean;
function EncodeFile(const FileName: string): AnsiString;
procedure DecodeFile(const base64: String; const FileName: string);
function VerificarArchivosRequeridos(GrupoArchivo: TArray<TGrupoArchivo>; out MsgArchivoFaltante: string): Boolean;
function ObtenerMime(NombreArchivo : String) : String;

{$IFDEF WEB}
function PathNombreFicheroTemporal(): string;
function RenombreFichero(FullPath: string): string;
function DescargarTemplateExcel(Template: string): Boolean;
{$ENDIF}

implementation

uses UnitRecursoString, UnitVerificarModulo;

{$IFDEF WEB}

function PathNombreFicheroTemporal(): string;
begin
// Tomado del ejemplo indicado por el fabricante
// http://forums.unigui.com/index.php?/topic/4190-i-need-help-in-how-to-load-pdf-file-in-uniurlframe1url/
  Result := UniServerModule.LocalCachePath + UniApplication.UniSession.SessionID + IntToStr(Random(100000)) + '_';
end;


function RenombreFichero(FullPath: string): string;
begin
  Result := IncludeTrailingPathDelimiter(TPath.GetDirectoryName(FullPath)) +
  // Path con delimitador
    TPath.GetFileNameWithoutExtension(FullPath) + '_' +
  // Nombre de archivo sin extension
    DMUsuario.UsuarioRecord.LoginUsuario + '_' + // Nombre de usuario
    FormatDateTime('dd-mm-yyyy_hhnnss', Now) + // Fecha y hora actual
    TPath.GetExtension(FullPath); // Extension
end;


function DescargarTemplateExcel(Template: string): Boolean;
var
  FullPathTemplate: string;
begin
  // Establezco el nombre del archivo
 // FullPathTemplate := UnitRepositorio.ObtenerRepositorio(TemplateExcel).Valor + TPath.DirectorySeparatorChar + Template;

  // Verifico si existe el archivo solicitado
  if TFile.Exists(FullPathTemplate) = True then
  begin
    UniSession.SendFile(FullPathTemplate);
    Result := True;
  end
  else
    begin
      Result := False;
   //   MessageDlg(EArchivoNoEncontrado + Template, mtError, [mbOK]);
    end;
end;
{$ENDIF}


procedure DecodeFile(const base64: String; const FileName: string);
var
  stream: TBytesStream;
begin
  stream := TBytesStream.Create(TNetEncoding.Base64.DecodeStringToBytes(base64));
  try
    stream.SaveToFile(Filename);
  finally
    stream.Free;
  end;
end;


function EncodeFile(const FileName: string): AnsiString;
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    stream.LoadFromFile(Filename);
    Result := AnsiString(TNetEncoding.Base64.EncodeBytesToString(stream.Memory, stream.Size));
  finally
    stream.Free;
  end;
end;


function VerificarValidoLogotipoFondo(): Boolean;
var
  GraficoFondo: string;
begin

  // Reseteo el resultado como falso
  Result := False;

  // Cargo el grafico de fondo
  GraficoFondo := LeerParametrosConfiguracionINI('LOGOTIPO', 'GraficoFondo', False);

  // Si es distinto de vacio
  if GraficoFondo <> '' then
  begin
    // Verifico si existe o es un path valido
    if TFile.Exists(GraficoFondo) = True then
    begin
      // Verifico si el path propuesto tiene extension png (debe ser image transparente)
      if TPath.GetExtension(GraficoFondo) = '.png' then
      begin
        // Devuelvo resultado
        Result := True;
      end;
    end;

  end;
end;

function VerificarValidoLogotipoAplicacion(): Boolean;
var
  GraficoLogotipo: string;
begin

  // Reseteo el resultado como falso
  Result := False;

  // Cargo el grafico de fondo
  GraficoLogotipo := LeerParametrosConfiguracionINI('APLICACION', 'GraficoLogotipo', False);

  // Si es distinto de vacio
  if GraficoLogotipo <> '' then
  begin
    // Verifico si existe o es un path valido
    if TFile.Exists(GraficoLogotipo) = True then
    begin
      // Verifico si el path propuesto tiene extension png (debe ser image transparente)
      if TPath.GetExtension(GraficoLogotipo) = '.png' then
      begin
        // Devuelvo resultado
        Result := True;
      end;
    end;

  end;
end;



function BorrarArchivo(Archivo: String): Boolean;
begin
  try
    TFile.Delete(Archivo);
    //Log(EBorradoArchivoImpresion + Archivo);
  except
    on E: Exception do
   //   Log(EErrorBorrarArchivo + E.Message);
  end;
end;


procedure FindFiles(StartDir, FileMask: string; recursively: Boolean;
  var FilesList: TStringList);
const
  MASK_ALL_FILES = '*.*';
  CHAR_POINT = '.';
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: Integer;
begin
  if not DirectoryExists(StartDir) then
    CreateDir(StartDir);
  if (StartDir[length(StartDir)] <> '\') then
  begin
    StartDir := StartDir + '\';
  end;

  // Crear la lista de ficheos en el directorio StartDir (no directorios!)
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  // MIentras encuentre
  while IsFound do
  begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;

  FindClose(SR);

  // Recursivo?
  if (recursively) then
  begin
    // Build a list of subdirectories
    DirList := TStringList.Create;
    // proteccion
    try
      IsFound := FindFirst(StartDir + MASK_ALL_FILES, faAnyFile, SR) = 0;
      while IsFound do
      begin
        if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> CHAR_POINT) then
          DirList.Add(StartDir + SR.Name);
        IsFound := FindNext(SR) = 0;
      end;
      FindClose(SR);

      // Scan the list of subdirectories
      for i := 0 to DirList.Count - 1 do
        FindFiles(DirList[i], FileMask, recursively, FilesList);
    finally
      DirList.Free;
    end;
  end;
end;



function CopiarArchivo(Archivo, Destino: String): string;
var
  DestName: String;
begin
  try
    DestName := Destino + ExtractFileName(Archivo);

    // Si no existe el archivo lo creo
    if TDirectory.Exists(IncludeTrailingPathDelimiter (TPath.GetDirectoryName(DestName))) = False then
    begin
      TDirectory.CreateDirectory(IncludeTrailingPathDelimiter(TPath.GetDirectoryName(DestName)));
    end;

    // Copio el archivo
    TFile.Copy(Archivo, DestName);

   // Log(ECopiadoArchivo + Archivo + ' a la ruta ' + DestName);

    // Devuelvo el resultado
    Result := DestName;

  except
    on E: Exception do
    begin
     // Log(EExcepcion + E.Message);
      Result := EExcepcion + E.Message;
    end;
  end;
end;


function CopiarArchivosPathExtension(Path, Extension, PathDestino: String; Cantidad: Integer = 0; CaracteresOmitir: String = ''): Boolean;
var
  varArchivosCopiar: TStringList;
  i, LimiteArchivos, ArchivosExistentes, Diferencia, c: Integer;
  DestName, NewName: string;
  varCaracteresOmitir: TArray<string>;
begin
  // Procederemos a copiar archivos temporales de operaciones anteriores.
  // Si la cantidad pasada es positiva, copiara esa cantidad
  // si la cantidad pasada es 0 copiara todos
  try
    // Creo la variable Archivo que alojara el nombre del archivo
    varArchivosCopiar := TStringList.Create;

    varCaracteresOmitir := CaracteresOmitir.split(['|']);

    // Borrador de archivos
    begin
      // Buscamos archivos con extensión MP4 y cargamos a la variable Archivos
      FindFiles(Path, '*.' + Extension, False, varArchivosCopiar);

      varArchivosCopiar.Sorted := True;
      varArchivosCopiar.Sort;

      if Cantidad < 0 then
      begin
        Abort;
      end
      else
      begin
        ArchivosExistentes := varArchivosCopiar.Count;
        Diferencia := Cantidad;
      end;

      if Diferencia = 0 then
        Diferencia := ArchivosExistentes;

      if Diferencia > ArchivosExistentes then
        Diferencia := ArchivosExistentes;

      // Recorremos la variable de archivos y borramos los archivos mencionados
      for i := 0 to Diferencia - 1 do
      begin
        try
          DestName := PathDestino + ExtractFileName(varArchivosCopiar[i]);
          NewName := DestName;
          if CaracteresOmitir <> '' then
          begin
            for c := 0 to High(varCaracteresOmitir) do
              NewName := StringReplace(NewName, varCaracteresOmitir[c], '', [rfReplaceAll]);
          end;

          CopyFile(PChar(varArchivosCopiar[i]), PChar(DestName), False);
          RenameFile(DestName, NewName);
        //  Log('UniArchivo ' + ECopiadoArchivoImpresion + varArchivosCopiar[i]);
        except
          on E: Exception do
         //  Log('UniArchivo ' + EErrorCopiarArchivo + E.Message);
        end;
      end;
    end;

  finally
    varArchivosCopiar.Free;
  end;
end;


function VerificarArchivosRequeridos(GrupoArchivo: TArray<TGrupoArchivo>; out MsgArchivoFaltante: string): Boolean;
const
  DriverBiometrico: TArray<string> = ['commpro.dll', 'comms.dll', 'plcommpro.dll',
                              'plcomms.dll', 'plrscagent.dll', 'plrscomm.dll',
                              'pltcpcomm.dll', 'plusbcomm.dll', 'rscagent.dll',
                              'rscomm.dll', 'tcpcomm.dll', 'usbcomm.dll',
                              'usbstd.dll', 'zkemkeeper.dll', 'zkemsdk.dll'];
  {$IFDEF WIN32}
  LibreriaImagen: TArray<string> = ['facesdk.dll', 'ielib32.dll'];
  {$ENDIF}

  {$IFDEF WIN64}
  LibreriaImagen: TArray<string> = ['facesdk.dll', 'ielib64.dll'];
  {$ENDIF}

  LibreriaIpWorks: TArray<string> = ['ipworks20.dll', 'ipworkscloud20'];

  ArchivosJavascript: TArray<string> = ['files\BadgeText.js',
                                        'files\html2canvas.js',
                                        'files\html2canvas.min.js',
                                        'files\printdirect.js',
                                        'files\sgcWebSockets.js',
                                        'files\sgcWebSockets.min.js',
                                        'files\TweenMax.min.js'];
var
  Item: string;
  ItemGrupoArchivo: TGrupoArchivo;
  ArchivosFaltantes: TArray<string>;
  GrupoSeleccionado: TArray<string>;
begin

  // Recorro el arreglo y selecciono el item, y de acuerdo al item
  // se selecoina la constante de archivos
  for ItemGrupoArchivo in GrupoArchivo do
  begin
    case ItemGrupoArchivo of
      Biometrico: GrupoSeleccionado:= DriverBiometrico;
      Imagen: GrupoSeleccionado:= LibreriaImagen;
      IPWorks: GrupoSeleccionado:= LibreriaIpWorks;
      Javascript: GrupoSeleccionado:= ArchivosJavascript;
    end;

    // Recorro los archivos, dependiendo del item seleccionado
    for Item in GrupoSeleccionado do
    begin
      // Verifico si existe el archivo
      if TFile.Exists(ExtractFilePath(ParamStr(0)) + Item) = False then
      begin
        SetLength(ArchivosFaltantes, Length(ArchivosFaltantes) + 1);
        ArchivosFaltantes[High(ArchivosFaltantes)] := Item;
      end;
    end;
  end;

  // Si alguno de los archivos sumo algun valor
  if Length(ArchivosFaltantes) = 0 then
  begin
    Result := True;
  end
  else
    begin
      // Devuelvo el mensaje de faltante y guardo en el log
      MsgArchivoFaltante := String.Join(', ', ArchivosFaltantes);
     // Log('UnitArchivo_' + MsgArchivoFaltante);
      // Retorno booleano para el control del programa
      Result := False;
    end;
end;

function ObtenerMime(NombreArchivo : String) : String;
var Extension : String;
begin
  Extension:= ExtractFileExt (NombreArchivo);

  if ((Extension = '.jpg') or (Extension = '.jpeg') or (Extension = '.png')) then
  begin
    Result := EMimeJPG;
  end;

  if Extension = '.xls' then
  begin
    Result := EMimeXLS;
  end;

  if Extension = '.xlsx' then
  begin
    Result := EMimeXLSX;
  end;

  if Extension = '.pdf' then
  begin
    Result := EMimePDF;
  end;

  if Extension = '.doc' then
  begin
    Result := EMimeDOC;
  end;

end;

end.
