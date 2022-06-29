
unit UnitOperacionesFotografia;

{$INCLUDE 'compilador.inc'}

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Dialogs, Data.DBConsts,
  System.StrUtils, System.Variants,
  LuxandFaceSDK,
   Data.DB,
  VirtualTable, frxClass, System.Rtti,
  System.IOUtils,

  {$IFDEF SDAC}
  MSAccess,
  {$ENDIF}

  {$IFDEF FIREDAC}
  FireDAC.Comp.Client,
  {$ENDIF}

  {$IFDEF DESKTOP}
  cxMemo, cxImage, Vcl.ExtCtrls, Vcl.Forms, Vcl.StdCtrls,
  {$ENDIF}

  {$IFDEF SERVICE}
  Vcl.ExtCtrls,
  {$ENDIF}

  {$IFDEF WEB}
  uniGUIDialogs, uniGUIForm, uniImage,
  {$ENDIF}

  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg, Vcl.Graphics,

  {$IFDEF AUTOSERVICIODESKTOP}
  scGPImages,
  {$ENDIF}

  // Units de ImageEn
  ievect, hyiedefs, imageenview;

const
  MinGraphicSize = 44; //we may test up to & including the 11th longword

type
  TFormatoImagen = (JPG, PNG, BMP);
  TTipoObjetoFondo = (TObjetoNoDefinido, TObjetoSiluetaPersona, TObjetoAeronave, TObjetoAerodromo, TObjetoRelojBiometrico, TObjetoHuellaDactilar, TObjetoArticulo);

  TFaceRecord = record
    Template: FSDK_FaceTemplate;
    Mensaje: string;
  end;

  {$IF DEFINED(DESKTOP) OR DEFINED(SERVICE)}
    // Autoserviciodesktop utiliza otro componente para cargar las fos
    {$IFDEF AUTOSERVICIODESKTOP}
      TImagePerfil = class(TscGPImage);
    {$ELSE}
      // Para los demas proyectos utilizo el estandar
      TImagePerfil = class(TImage);
    {$ENDIF}
  {$ENDIF}

  {$IFDEF WEB}
    TImagePerfil = class(TUniImage);
  {$ENDIF}

  {$REGION 'Documentation'}
  /// <summary>
  ///   Inicializa la licencia para el tratamiento de detecci�n de rostros
  ///   usando FaceSDK
  /// </summary>
  {$ENDREGION}
  procedure InicializarLicencia;
  function ObjetoFondo(TipoObjetoFondo: TTipoObjetoFondo): string;

  function Max(x: extended; y: extended): Double;

  function CrearRecorteRostro(FileName: string; Destino: string; ChromaKey: Boolean = False; Tolerancia: Double = 0.21; Memo: TObject = nil): Boolean;

  {$REGION 'Documentation'}
  /// <summary>
  ///   Extrae el valor del template y devuelve un string. El template se puede
  ///   utilizar para tareas de reconocimiento facial.
  /// </summary>
  /// <param name="FileName">
  ///   Nombre del archivo
  /// </param>
  {$ENDREGION}
  function ExtraerTemplate(FileName: string): TFaceRecord;
  {$IFDEF NODEF}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Procesa la fotografia, obteniendo el Template para tareas de
  ///   reconocimiento facial. Se aplica s�lo a fotografias de rostros
  /// </summary>
  /// <param name="IdObjetoFotografia">
  ///   <para>
  ///     El Identity del objeto que contiene la fotografia
  ///   </para>
  ///   <para>
  ///     Ejemplo
  ///   </para>
  ///   <para>
  ///     Valores de
  ///   </para>
  ///   <list type="bullet">
  ///     <item>
  ///       IdPersonalFoto = 15
  ///     </item>
  ///   </list>
  ///   <para>
  ///     Donde el valor a pasar es 15
  ///   </para>
  /// </param>
  {$IFDEF NODEF}{$ENDREGION}{$ENDIF}
  function ProcesarFoto(IdObjetoFotografia: Integer): Boolean;

  function EmparejarRostro(DataSetQuery: TDataSet; DataSetVirtual: TDataSet; FileName: string; IdPersonal: integer = 0): Boolean; overload;
  function EmparejarRostro(TemplateField: TBlobField; FileName: string): Boolean; overload;

  procedure ColocarFotografiaReporte(Reporte: TfrxReport; ObjetoPictureView: string; QueryFotografia: TDataset; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False; ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido); overload;
  procedure ColocarFotografiaReporte(Reporte: TfrxReport; ObjetoPictureView: string; PathArchivo: string; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido); overload;

  function FindGraphicClass(const Buffer; const BufferSize: Int64; out GraphicClass: TGraphicClass): Boolean; overload;
  function FindGraphicClass(Stream: TStream; out GraphicClass: TGraphicClass): Boolean; overload;

  function IsJpegFile(AStream: TFileStream): Boolean;
  function IsBmpFile(AStream: TFileStream): Boolean;
  function IsPngFile(AStream: TFileStream): Boolean;

  function SubirFotografia(Dataset: TDataSet; IdRegistro: integer; Campo: string; AStream: TFileStream; Formato: TFormatoImagen = JPG): Boolean;
  {$REGION 'Documentation'}
  /// <summary>
  ///   Carga fotografias en un dataset virtual para su tratamiento con
  ///   bindings de datos
  /// </summary>
  /// <param name="QueryFoto">
  ///   Consulta que contiene las referencias de fotografias
  /// </param>
  /// <param name="TablaVirtual">
  ///   El dataset virtual donde se guardan las fotografias
  /// </param>
  /// <param name="IdRegistro">
  ///   El identificador del registro que hace referencia
  /// </param>
  {$ENDREGION}
  function RecuperarFoto(QueryFoto: TDataSet; CampoJPG: String; TablaVirtual: TVirtualTable; CampoBMP: String; IdRegistro: integer): Boolean;

  {$IFDEF WEB}
  procedure RotarIzquierda(Imagen  : TUniImage) ;
  procedure RotarDerecha(Imagen  : TUniImage) ;
  procedure VoltearHorizontal(Imagen  : TUniImage) ;
  procedure VoltearVertical(Imagen  : TUniImage) ;
  procedure Zoom(Imagen  : TUniImage; Zoom : Integer) ;
  {$ENDIF}

  {$REGION 'Documentation'}
  /// <summary>
  ///   Esta funcion carga una foto visualmente en un objeto TuniImage
  /// </summary>
  /// <param name="CampoFotografia">
  ///   Campo que contendra la fotografia
  /// </param>
  /// <param name="QueryFotografia">
  ///   El Dataset que contiene que query de consulta de fotos
  /// </param>
  /// <param name="CampoIdFotografia">
  ///   <para>
  ///     EL campo que contiene el Identity de la foto
  ///   </para>
  ///   <para>
  ///     Ejemplo
  ///   </para>
  ///   <para>
  ///     IdPersonaFoto
  ///   </para>
  /// </param>
  /// <param name="CampoIdObjeto">
  ///   <para>
  ///     EL campo que contiene el Identity del objeto
  ///   </para>
  ///   <para>
  ///     Ejemplo
  ///   </para>
  ///   <para>
  ///     IdPersona
  ///   </para>
  /// </param>
  /// <param name="Repositorio">
  ///   El path donde se guardan las fotos fisicamente
  /// </param>
  /// <param name="UsarCrop">
  ///   Si se usa Crop para el recorte y ajuste (solo v�lido en casos que
  ///   existan rostros)
  /// </param>
  /// <param name="FotoActual">
  ///   El objeto TUniImage
  /// </param>
  {$ENDREGION}
  procedure CargarFotografia(CampoFotografia: TBlobField; QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False; ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido); overload;
  {$IFDEF WEB}
  procedure CargarFotografia(FotoActual: TUniImage; QueryFotografia: TMSQuery; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False; ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido); overload;
  procedure DescargarFotografia(QueryFotografia: TMSQuery; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False);
  {$ENDIF}

  {$REGION 'Documentation'}
  /// <summary>
  ///   Agrega referencia (registro en la base de datos, que se utilizar� para
  ///   construir una ruta a la fotografia fisica en el disco) de una foto, a
  ///   un dataset, devolviendo el Id (Primary Key), de la foto recien guardada
  ///   en el dataset (solo se guardan los id de referencias).
  /// </summary>
  /// <param name="QueryFotografia">
  ///   El objeto dataset que contiene el query de la foto
  /// </param>
  /// <param name="CampoIdFotografia">
  ///   <para>
  ///     Campo del Primary Key a devolver valor
  ///   </para>
  ///   <para>
  ///     Ejemplo <br />IdPersonalFoto <br />
  ///   </para>
  /// </param>
  /// <param name="CampoIdObjeto">
  ///   <para>
  ///     Campo del objeto
  ///   </para>
  ///   <para>
  ///     Ejemplo
  ///   </para>
  ///   <para>
  ///     IdPersonal
  ///   </para>
  /// </param>
  {$ENDREGION}
  function AgregarFotografia(QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField): integer;
  {$REGION 'Documentation'}
  /// <summary>
  ///   Elimina una referencia en la base de datos de una fotografia
  /// </summary>
  /// <param name="QueryFotografia">
  ///   El query que contiene la consulta a de la tabla de fotos
  /// </param>
  /// <param name="CampoIdFotografia">
  ///   El campo de Primary Key
  /// </param>
  /// <param name="ValorIdFotografia">
  ///   Valor a Eliminar
  /// </param>
  {$ENDREGION}
  function EliminarFotografia(QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; ValorIdFotografia: Integer): Boolean;

  procedure CargarFotoPerfil(FotoPerfil: TImagePerfil; IdPersonal: Integer = -1; DocumentoNro: string = ''; UsarLinkDatos: Boolean = False; MiniaturaCircular: Boolean = True);
  procedure FotoCircular(Foto: TBlobField; FotoPerfil: TImagePerfil; MiniaturaCircular: Boolean); overload;
  procedure FotoCircular(PathArchivoFoto: string; FotoPerfil: TImagePerfil; MiniaturaCircular: Boolean); overload;

  procedure CrearFotoReloj(IdPersonal: integer; IdPersonalFoto: integer);
  procedure CrearFotoPerfil(IdPersonal: integer; IdPersonalFoto: integer);
  procedure AplicarChromeKey(FullPath: string; Tolerancia: Double = 0.21);

  {$IFDEF DESKTOP}
  procedure CargarFotografiaDefault(ObjetoImage: TcxImage);
  {$ENDIF}

  {$IFDEF AUTOSERVICIODESKTOP}
  procedure CargarFotoPerfilDefault(ObjetoImage: TscGPImage);
  {$ENDIF}

implementation

uses
  UnitRecursoString,
 // UnitLog,
  //UnitOperacionesSO,

  {$IFDEF RHKIT}
  DataModuleFoto,
  {$ENDIF}

  {$IFDEF WEB}
  ServerModule, UniGUIApplication,
  {$ENDIF}

 // UnitRepositorio,
  DataModulePrincipal,
  UnitAuditoria,
 // UnitLogParametro,

  {$IFDEF SDAC}
  DataModuleUsuario,
  {$ENDIF}

  {$IF DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(AUTOSERVICIODESKTOP)}
       DataModuleAutoservicio,
  {$ENDIF}

  // En caso que sean aplicaciones de escritorio o el autoservicio
  {$IF (DEFINED(AUTOSERVICIOWEB) OR
        DEFINED(RHMINI) OR
        DEFINED(RHKIT) OR
        DEFINED(REPORTEDITOR) OR
        DEFINED(AUTOSERVICIODESKTOP) OR
        DEFINED(RHRELOJ) OR
        DEFINED(PRODUCTCRAWLER) OR
        DEFINED(PRODUCTSERVER) OR
        DEFINED(WORKFLOW) OR
        DEFINED(ECRM) OR
        DEFINED(SYNCRELOJ) )}
    UnitOperacionesMiddleware,
    {$ENDIF}

  {$IF DEFINED(MIDDLEWARESERVER))}
    FormularioPrincipal,
    {$ENDIF}

  UnitDatos,
   //UnitArchivos,
   UnitCodigosComunesDataModule;

procedure InicializarLicencia;
var
  LicenciaKey: String;
begin
  // Key de Licencia

  // Version 7.2.0
  LicenciaKey := 'fVrFCzYC5wOtEVspKM/zfLWVcSIZA4RNqx74s+QngdvRiCC7z7MHlSf2w3+OUyAZkTFeD4kSpfVPcRVIqAKWUZzJG975b/P4HNNzpl11edXGIyGrTO/DImoZksDSRs6wktvgr8lnNCB5IukIPV5j/jBKlgL5aqiwSfyCR8UdC9s=';

  // Version 7.2.1
  //LicenciaKey := 'fVrFCzYC5wOtEVspKM/zfLWVcSIZA4RNqx74s+QngdvRiCC7z7MHlSf2w3+OUyAZkTFeD4kSpfVPcRVIqAKWUZzJG975b/P4HNNzpl11edXGIyGrTO/DImoZksDSRs6wktvgr8lnNCB5IukIPV5j/jBKlgL5aqiwSfyCR8UdC9s=';

  if FSDK_ActivateLibrary(PAnsiChar(AnsiString(LicenciaKey))) <> FSDKE_OK then
  begin
   // Log('Error en la activaci�n de la licencia. Error activating FaceSDK');

    {$IFDEF DESKTOP}
    MessageDlg('Error en la activaci�n de la licencia. Error activating FaceSDK', mtError, [mbOK], 0);
    {$ENDIF}

    Abort;
  end;

   //Inicializo las librerias
  FSDK_Initialize('');
   //Ajusto los parametros de deteccion de rostros
  FSDK_SetFaceDetectionParameters(true, true, 256);

end;


function ObjetoFondo(TipoObjetoFondo: TTipoObjetoFondo): string;
begin
  // Para referencias Color Gris de los objetos #99a8a8

  // Establezco el fondo del objeto segun el criterio definido
  case TipoObjetoFondo of
    TObjetoNoDefinido:
    begin
      // El objeto por defecto
      Result := 'ObjetoNoDefinido';
    end;

    TObjetoSiluetaPersona:
    begin
      Result := 'SiluetaPersona';
    end;

    TObjetoAeronave:
    begin
      // Se usa en RAN
      Result := 'Aeronave';
    end;

    TObjetoAerodromo:
    begin
      // Se usa en RAN
      Result := 'Aerodromo';
    end;

    TObjetoRelojBiometrico:
    begin
      // Se usa para el fondo de reloj biometrico
      Result := 'RelojBiometrico';
    end;

    TObjetoHuellaDactilar:
    begin
      // Se usa para el fondo de huella dactilar
      Result := 'HuellaDactilar';
    end;

    TObjetoArticulo:
    begin
      Result := 'Articulo';
    end;
  end;
end;


function Max(x: extended; y: extended): Double;
begin
  if (x >= y) then
  begin
    Result := x;
  end
  else
  begin
    Result := y;
  end;
end;


function CrearRecorteRostro(FileName: string; Destino: string; ChromaKey: Boolean = False; Tolerancia: Double = 0.21; Memo: TObject = nil): Boolean;
//    Ej.   CrearRecorteRostro(ArchivoTmpDestino + '.jpg', ArchivoTmpDestino + 'crop_.jpg')
var
  imageHandle, image2Handle: integer;
  FacePosition: TFacePosition;
  x1, x2, y1, y2: integer;
  maxWidth, maxHeight: integer;
begin

  // Verifico si se puede cargar la imagen
  if FSDK_LoadImageFromFile(@imageHandle, PAnsiChar(AnsiString(FileName))) <> FSDKE_OK then
  begin
   // Log(EErrorCargaArchivoFoto + ' - ' + FileName);
    Result := False;
  end
  else
    begin
      // Detecto el rostro en el archivo cargo
      if FSDK_DetectFace(imageHandle, @FacePosition) <> FSDKE_OK then
      begin
        // Muestro error al cargar el rostro
       // Log('UnitOperacionesFotografia fcn CrearRecorteRostro - FSDK_DetectFace -'+ EErrorDetectarRostro + ' - ' + FileName);
        Result := False;
      end
      else
        begin
          // Creo una nueva imagen del rostro
          FSDK_CreateEmptyImage(@image2Handle);

            // Establezco el tamano a realizar el recorte
            x1 := FacePosition.xc - Round(1.6 * FacePosition.w / 2);
            y1 := FacePosition.yc - Round(1.8 * FacePosition.w / 2);
            x2 := FacePosition.xc + Round(1.6 * FacePosition.w / 2);
            y2 := FacePosition.yc + Round(1.8 * FacePosition.w / 2);

          // Copio el contenido a una nueva imagen
          FSDK_CopyRect(imageHandle, x1, y1, x2, y2, image2Handle);

          // Parametros de tamano maximo
          maxWidth := 337;
          maxHeight := 450;

          // Cambio el tamano de la imagen
          FSDK_ResizeImage(image2Handle,
                          Max((maxWidth + 0.4) / (x2 - x1 + 1), (maxHeight + 0.4) / (y2 + y1 + 1)),
                          imageHandle);

          // Establezo el tamano de la imagen a ser guardado
          FSDK_SetJpegCompressionQuality(95);

          // Guardo la liben en destino
          if FSDK_SaveImageToFile(imageHandle, PAnsiChar(AnsiString(Destino))) <> FSDKE_OK then
          begin
            Result := False;
            // Guardo el error
           // Log(EErrorGuardarArchivoDestino + ' - ' + Destino);

            {$IFDEF DESKTOP}
            if Memo = nil then
            begin
              MessageDlg(EErrorGuardarArchivoDestino + ' - ' + Destino, mtError, [mbOK], 0);;
            end
            else
              begin
                TcxMemo(Memo).Lines.Add(EErrorGuardarArchivoDestino + ' - ' + Destino);
              end;
            {$ENDIF}

          end
          else
            begin
              // Si se guarda todo OK
              Result := True;

             // Log('Fichero de recorte OK: ' + Destino);

              {$IFDEF DESKTOP}
                if Memo = nil then
                begin
                  MessageDlg('Fichero de recorte OK: ' + Destino, mtInformation, [mbOK], 0);
                end
                else
                  begin
                    TcxMemo(Memo).Lines.Add('Fichero de recorte OK: ' + Destino);
                  end;
              {$ENDIF}
            end;

        end;

      // Libero los objetos
      FSDK_FreeImage(imageHandle);
      FSDK_FreeImage(image2Handle);
    end;

   // Remover fondo de la foto, siempre y cuando exista un rostro en fondo
   if Result = True then
   begin
     if ChromaKey = True then
     begin
       // Remuevo el fondo de la foto
       AplicarChromeKey(Destino, Tolerancia);
     end;
   end;

end;



function ExtraerTemplate(FileName: string): TFaceRecord;
var
  imageHandle: integer;
  //Template: FSDK_FaceTemplate;
  r: integer;
begin

  // Cargo la imagen en el manejador
 // r := FSDK_LoadImageFromFile(@imageHandle, PAnsiChar(AnsiString(FileName)));

//  if r <> FSDKE_OK then
//  begin
//    Result.Mensaje := 'Error al cargar la fotografia';
//  end
//  else
//    begin
//      // Obtengo el template a partir de imagen recortada
//      r := FSDK_GetFaceTemplate(imageHandle, @Template);
//
//      // Detecto si hay un template valido
//      if r <> FSDKE_OK then
//      begin
//        Result.Mensaje := 'Template Error';
//      end
//      else
//        begin
//
//          try
//
//            Result.Template := Template;
//            Result.Mensaje := 'Template OK';
//
//          except
//            on E: Exception do
//            begin
//              Result.Mensaje := EExcepcion + E.Message;
//            end;
//
//          end;
//
//        end;
//
//    end;

end;


function ProcesarFoto(IdObjetoFotografia: Integer): Boolean;
var
  FaceRecord: TFaceRecord;

  RepositorioFotoPath, FileName: string;
  CampoBlob: TBlobField;
  BlobStream: TStream;

  {$IFDEF FIREDAC}
    DataSet: TFDQuery;
  {$ENDIF}

  {$IFDEF SDAC}
    DataSet: TMSQuery;
  {$ENDIF}

  CampoIdObjeto, CampoIdFotografia: string;
  QuerySelect, QueryUpdate: string;
begin

  // Establezco la ruta de fotos, que contiene los las fotos con rostros
  {$IFDEF FIREDAC}
    RepositorioFotoPath := UnitRepositorio.ObtenerRepositorio(RH).Valor + '\Foto\';

    CampoIdObjeto := 'IdPersonal';
    CampoIdFotografia := 'IdPersonalFoto';
    QuerySelect := 'SELECT * FROM Legajo.PersonalFoto WHERE IdPersonalFoto = :IdPersonalFoto';
    QueryUpdate := 'UPDATE Legajo.PersonalFoto SET IdPersonal = :IdPersonal, UrevUsuario = :UrevUsuario, UrevFechaHora = :UrevFechaHora, Template = :Template, EstadoFoto = :EstadoFoto WHERE IdPersonalFoto = :Old_IdPersonalFoto';
  {$ENDIF}


  {$IFDEF SDAC}
    {$IF DEFINED(NOMINA)
      OR DEFINED(RHKIT)
      OR DEFINED(TRAMITEWEB)
      OR DEFINED(MIDDLEWARESERVER) }
    RepositorioFotoPath := UnitRepositorio.ObtenerRepositorio(RH).Valor + '\Foto\';

    // Establezco los parametros
    CampoIdObjeto := 'IdPersonal';
    CampoIdFotografia := 'IdPersonalFoto';
    QuerySelect := 'SELECT * FROM Legajo.PersonalFoto WHERE IdPersonalFoto = :IdPersonalFoto';
    QueryUpdate := 'UPDATE Legajo.PersonalFoto SET IdPersonal = :IdPersonal, UrevUsuario = :UrevUsuario, UrevFechaHora = :UrevFechaHora, Template = :Template, EstadoFoto = :EstadoFoto, Version = :Version WHERE IdPersonalFoto = :Old_IdPersonalFoto';
    {$ENDIF}

    {$IFDEF RAPY}
    RepositorioFotoPath := UnitRepositorio.ObtenerRepositorio(RAPY).Valor + '\Foto\';

    // Establezco los parametros
    CampoIdObjeto := 'IdPersona';
    CampoIdFotografia := 'IdPersonaFoto';
    QuerySelect := 'SELECT * FROM RAN.PersonaFoto WHERE IdPersonaFoto = :IdPersonaFoto';
    QueryUpdate := 'UPDATE RAN.PersonaFoto SET IdPersona = :IdPersona, UrevUsuario = :UrevUsuario, UrevFechaHora = :UrevFechaHora, Template = :Template, EstadoFoto = :EstadoFoto, Version = :Version WHERE IdPersonaFoto = :Old_IdPersonaFoto';
    {$ENDIF}
  {$ENDIF}

  // Creo el dataset en memoria
  {$IFDEF FIREDAC}
    DataSet := TFDQuery.Create(nil);
    DataSet.Connection := DMPrincipal.FDConnection;
  {$ENDIF}

  {$IFDEF SDAC}
    DataSet := TMSQuery.Create(nil);
    DataSet.Connection := DMPrincipal.MSConnection;
  {$ENDIF}


  // Dentro de un bloque try que al finalizar se elimina el objeto
  try
    {$IFDEF FIREDAC}
      // Sobreescribo y personalizo los comandos updates
      DataSet.SQL.Add(QuerySelect);
      DataSet.ParamByName('IDPERSONALFOTO').DataType := ftInteger;
    {$ENDIF}

    {$IFDEF SDAC}
      DataSet.SQL.Add(QuerySelect);
      DataSet.SQLUpdate.Add(QueryUpdate);
    {$ENDIF}

    // Consulto la foto previamente procesada
    DataSet.Close;
    DataSet.ParamByName(CampoIdFotografia).Value := IdObjetoFotografia;
    DataSet.Open;

    // Establezo el nombre del fichero
    FileName := DataSet.FieldByName(CampoIdObjeto).AsString + '\Crop\' + DataSet.FieldByName(CampoIdFotografia).AsString + '.jpg';

    // Edito el reigstro
    DataSet.Edit;

    // Verifico si existe el archivo crop
    if FileExists(RepositorioFotoPath + FileName) = True then
    begin

      // Extraigo el record
      FaceRecord := UnitOperacionesFotografia.ExtraerTemplate(RepositorioFotoPath + FileName);

        // Si el template es OK guardo
        if FaceRecord.Mensaje = 'Template OK' then
        begin
          try
            // Guardo el mensaje y el record
            CampoBlob := DataSet.FieldByName('Template') as TBlobField;
            BlobStream := DataSet.CreateBlobStream(CampoBlob, bmWrite);

            // Grabo en Stream con el record
            try
             // BlobStream.Write(FaceRecord.Template, SizeOf(FaceRecord.Template));
            finally
              BlobStream.Free;
            end;

            DataSet.FieldByName('EstadoFoto').Value := FaceRecord.Mensaje;
            //DataSet.FieldByName('Version').Value := FaceSDKVersion;

            // Devuelvo como procesado
            Result := True;

          except // Capturo excepcion y devuelvo no procesado
            on E: Exception do
            begin
              //Log(EExcepcion + E.Message);
              Result := False;
            end;

          end;
        end
        else
          begin
            // Guardo el mensaje
            DataSet.FieldByName('EstadoFoto').Value := FaceRecord.Mensaje;
          end;
    end
    else   // Si no existe el archivo crop, pero si el original, devuelvo no procesado
      begin
        DataSet.FieldByName('EstadoFoto').Value := 'Crop no existe';
        Result := False;
      end;

    // Hago post en el dataset
    DataSet.Post;

  finally
     // Destruyo el objeto
    DataSet.Free;
  end;
end;



function EmparejarRostro(DataSetQuery: TDataSet; DataSetVirtual: TDataSet; FileName: string; IdPersonal: integer = 0): Boolean;
var
  RHPath, AuxFileName: string;
  FaceRecord: TFaceRecord;
  //Template: FSDK_FaceTemplate;
  CampoBlob : TBlobField;
  BlobStream : TStream;
  Respuesta: integer;
  Similitud: Single;
begin

  // Cargo el repositorio que contiene las fotos
 // RHPath := UnitRepositorio.ObtenerRepositorio(RH).Valor + '\Foto\';

  // Limpio el dataset virtual
  DataSetVirtual.Close;
  DataSetVirtual.Open;

  {$IFDEF DESKTOP}
  TVirtualTable(DataSetVirtual).Clear;
  {$ENDIF}

  // Obtengo el template de un archivo
  FaceRecord := UnitOperacionesFotografia.ExtraerTemplate(FileName);

  // Dependiendo del tipo de busqueda de rostros, si tiene el numero de Documento es 1:1, sino es 1:N
  if IdPersonal <> 0 then
  begin
    // Consulto las fotos disponibles
    DataSetQuery.Close;

    // Por defecto es SDAC
    {$IFDEF SDAC}
    TMSQuery(DataSetQuery).ParamByName('IdPersonal').Value := IdPersonal;
    {$ENDIF}

    // En caso que sea DSServer, lo procesare con firedac
    {$IFDEF FIREDAC}
    TFDQuery(DataSetQuery).ParamByName('IdPersonal').Value := IdPersonal;
    {$ENDIF}

    DataSetQuery.Open;

    // Si hay datos en la consulta
    if DataSetQuery.RecordCount > 0 then
    begin
      // Desactivo el movimiento de los controles
      DataSetQuery.DisableControls;
      DataSetVirtual.DisableControls;

      while DataSetQuery.Eof = False do
      begin

        // Establezo el nombre del fichero
        AuxFileName := DataSetQuery.FieldByName('IdPersonal').AsString + '\Crop\' + DataSetQuery.FieldByName('IdPersonalFoto').AsString+ '.jpg';

         try
            // Agrego las fotos que se vayan encontrando
            DataSetVirtual.Append;
            DataSetVirtual.FieldByName('IdPersonalFoto').Value := DataSetQuery.FieldByName('IdPersonalFoto').Value;
            DataSetVirtual.FieldByName('IdPersonal').Value := DataSetQuery.FieldByName('IdPersonal').Value;
            DataSetVirtual.FieldByName('EstadoFoto').Value := DataSetQuery.FieldByName('EstadoFoto').Value;
            DataSetVirtual.FieldByName('UrevUsuario').Value := DataSetQuery.FieldByName('UrevUsuario').Value;
            DataSetVirtual.FieldByName('UrevFechaHora').Value := DataSetQuery.FieldByName('UrevFechaHora').Value;

            // Realizo las comparaciones
            if DataSetQuery.FieldByName('Template').IsBlob then
            begin
              CampoBlob := DataSetQuery.FieldByName('Template') as TBlobField;
              BlobStream := DataSetQuery.CreateBlobStream(CampoBlob, bmRead);
              try
               // BlobStream.Read(Template, SizeOf(FSDK_FaceTemplate));
              finally
                BlobStream.Free;
              end;
            end;

            // Reseteo la variable de similitud
            Similitud := 0;

            // Comparo las fotos
          //  Respuesta := FSDK_MatchFaces(@FaceRecord.Template, @Template, @Similitud);

            //Guardo la similitud de la foto
            DataSetVirtual.FieldByName('Similitud').Value := Similitud;

            // Verifico si existe el archivo crop
            if TFile.Exists(RHPath + AuxFileName) = True then
            begin
              {$IFDEF DESKTOP}

                {$IFDEF RHKIT}
                  DMFoto.VTCompararRostroFotoCrop.LoadFromFile(RHPath + AuxFileName);
                {$ENDIF}

              {$ENDIF}
            end;

            // Hago post del dataset
            DataSetVirtual.Post;

          except
            on E: Exception do
            begin
             // Log(EExcepcion + E.Message);
            end;

          end;

        // Salto al siguiente registro
        DataSetQuery.Next;
      end;

      // Reactivo el movimiento de los controles
      DataSetQuery.EnableControls;
      DataSetVirtual.EnableControls;

    end;


  end
  else  // En caso que no se utilice el DocumentoNro, es para busquedas 1:N
    begin

        // Realizo consulta sobre todas las fotos disponibles
        DataSetQuery.Close;

        {$IFDEF SDAC}
        TMSQuery(DataSetQuery).MacroByName('Condicion').Value := 'EstadoFoto = ''Template OK''';
        {$ENDIF}

        // En caso que sea DSServer, lo procesare con firedac
        {$IFDEF FIREDAC}
        TFDQuery(DataSetQuery).ParamByName('IdPersonal').Value := IdPersonal;
        {$ENDIF}

        DataSetQuery.Open;

        // Deshabilito los controles, esto permite recorrer mas rapido
        DataSetQuery.DisableControls;

        // Recorro el dataset, mientras existan registro
        while DataSetQuery.Eof = False do
        begin

            // Realizo las comparaciones de las fotos
           if DataSetQuery.FieldByName('Template').IsBlob then
           begin
              CampoBlob := DataSetQuery.FieldByName('Template') as TBlobField;
              BlobStream := DataSetQuery.CreateBlobStream(CampoBlob, bmRead);
              try
            //    BlobStream.Read(Template, SizeOf(FSDK_FaceTemplate));
              finally
                BlobStream.Free;
              end;
           end;

           // Reseteo la variable de similitud
           Similitud := 0;

           // Comparo las fotos
           //Respuesta := FSDK_MatchFaces(@FaceRecord.Template, @Template, @Similitud);

           // Si la similitud es mayor a 0.9, es que corresponde a la foto
           //entonces cargo el dataset virtual para mostrar los registros
           if Similitud >= 0.9 then
           begin
              // Establezo el nombre del fichero
              AuxFileName := DataSetQuery.FieldByName('IdPersonal').AsString + '\Crop\' + DataSetQuery.FieldByName('IdPersonalFoto').AsString+ '.jpg';

              DataSetVirtual.Append;
              DataSetVirtual.FieldByName('IdPersonalFoto').Value := DataSetQuery.FieldByName('IdPersonalFoto').Value;
              DataSetVirtual.FieldByName('IdPersonal').Value := DataSetQuery.FieldByName('IdPersonal').Value;
              DataSetVirtual.FieldByName('EstadoFoto').Value := DataSetQuery.FieldByName('EstadoFoto').Value;
              DataSetVirtual.FieldByName('UrevUsuario').Value := DataSetQuery.FieldByName('UrevUsuario').Value;
              DataSetVirtual.FieldByName('UrevFechaHora').Value := DataSetQuery.FieldByName('UrevFechaHora').Value;

              //Guardo la similitud de la foto
              DataSetVirtual.FieldByName('Similitud').Value := Similitud;

              // Verifico si existe el archivo crop
              if TFile.Exists(RHPath + AuxFileName) = True then
              begin
                {$IFDEF DESKTOP}
                  {$IFDEF RHKIT}
                  DMFoto.VTCompararRostroFotoCrop.LoadFromFile(RHPath + AuxFileName);
                  {$ENDIF}
                {$ENDIF}
              end;

              // Post en el dataset
              DataSetVirtual.Post;

           end;

           // Salto al siguiente
           DataSetQuery.Next;
        end;


        // Habilito de vuelta los controles
        DataSetQuery.EnableControls;
        DataSetVirtual.EnableControls;

    end;


    // En caso que haya registros que consultar
    if DataSetVirtual.RecordCount > 0 then
    begin
      // En caso que el ultimo registro, o sea la ultima foto registrada
      // Corresponde a un nivel de similitud superior a 0.9, entonces se indicara como resultado true
      if DataSetVirtual.FieldByName('Similitud').Value > 0.9 then
      begin
        Result := True;
      end
      else
        begin
          Result := False;
        end;
    end;

end;




function EmparejarRostro(TemplateField: TBlobField; FileName: string): Boolean;
var
  FaceRecord: TFaceRecord;
  Respuesta: integer;
  Similitud: Single;

  //Template: FSDK_FaceTemplate;
  BlobStream : TStream;
begin
  // Obtengo el template de un archivo
  FaceRecord := UnitOperacionesFotografia.ExtraerTemplate(FileName);

  // Reseteo la variable de similitud
  Similitud := 0;

  // Realizo las comparaciones
  BlobStream := TemplateField.DataSet.CreateBlobStream(TemplateField, bmRead);
  try
  //  BlobStream.Read(Template, SizeOf(FSDK_FaceTemplate));
  finally
    BlobStream.Free;
  end;

  // Comparo las fotos
 // Respuesta := FSDK_MatchFaces(@FaceRecord.Template, @Template, @Similitud);

  // Si la similitud es mayor a 0.9, es que corresponde a la foto
  if Similitud >= 0.9 then
  begin
    Result := True;
  end
  else
    begin
      Result := False;
    end;

end;


procedure ColocarFotografiaReporte(Reporte: TfrxReport; ObjetoPictureView: string; QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False; ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido);
{
  ColocarFotografiaReporte(DMCertificadoTrabajoReporte.frCertificadoTrabajo, 'Foto',
                           DMPersonalFotografia.MSConsultarFoto,
                           MSCertificadoTrabajoReimprimirIdPersonalFoto,
                           MSCertificadoTrabajoReimprimirIdPersonal,
                           ObtenerRepositorio(RH).Valor +
                           TPath.DirectorySeparatorChar +
                           'Foto' +
                           TPath.DirectorySeparatorChar,
                           True, True, TObjetoSiluetaPersona);
                           }
var
  PathArchivoFoto: string;
  Png: TPngImage;
  ExisteFoto: TfrxPictureView;
begin

  try
    // Consulto la foto en la base de datos, si es modo historico se supone que
    // ya se abrio la consulta anteriormente
    if ReabrirQuery = True then
    begin
      QueryFotografia.Close;

      {$IFDEF SDAC}
      TCustomMSDataSet(QueryFotografia).ParamByName(CampoIdObjeto.FieldName).Value := CampoIdObjeto.Value;
      {$ENDIF}

      //LogParameter('ColocarFotografiaReporte'+ TCustomMSDataSet(QueryFotografia).Name,TCustomMSDataSet(QueryFotografia));

      QueryFotografia.Open;
    end;

    if (QueryFotografia.RecordCount = 0) then
    begin
      {$IF DEFINED(AUTOSERVICIOWEB) OR DEFINED(RHMINI)}
        {$IFDEF DEBUG}
        Log('ColocarFotografiaReporte UnitOperacionesMiddleware.DescargarFotografia | ' + CampoIdObjeto.FieldName + ' : '+CampoIdObjeto.AsString + ' - ' +CampoIdFotografia.FieldName + ' - ' + CampoIdFotografia.AsString +' - '+ PathArchivoFoto);
        {$ENDIF}
      // Descargo la foto en la carpeta de repositorio local
      UnitOperacionesMiddleware.DescargarFotografia(CampoIdObjeto.Value, CampoIdFotografia.Value, PathArchivoFoto, 'Crop');

      //ReabrirQuery
      QueryFotografia.Close;
      QueryFotografia.Open;
      {$ENDIF}
    end;

    // Si existe registro, procedere a cargar la foto del repositorio
    if QueryFotografia.RecordCount > 0 then
    begin
      // Dependiendo si se usa crop o no
      if UsarCrop = True then
      begin
        PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\Crop\' + QueryFotografia.FindField(CampoIdFotografia.FieldName).AsString + '.jpg';
      end
      else
        begin
          PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' + QueryFotografia.FindField(CampoIdFotografia.FieldName).AsString + '.jpg';
        end;

      {$IFDEF DEBUG}
      //  Log('ColocarFotografiaReporte - PathArchivoFoto | ' + PathArchivoFoto + ' Reporte ' + Reporte.Name );
      {$ENDIF}

      // Verifico si existe el archivo
      if TFile.Exists(PathArchivoFoto) = True then
      begin
        {$IFDEF DEBUG}
       // Log('ColocarFotografiaReporte - TFile.Exists(PathArchivoFoto) | ' + PathArchivoFoto + ' Reporte ' + Reporte.Name );
        {$ENDIF}

        ExisteFoto := TfrxPictureView(Reporte.FindObject(ObjetoPictureView));

        // Verifico que exista la foto en el reporte para cargar
        if not(ExisteFoto = nil) then
        begin
          // Cargo la fotografia, en el objeto grafico del reporte
          (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.LoadFromFile(PathArchivoFoto);
        end;

      end
      else
        begin
          try
            //Si no existe el archivo, se carga la imagen
            Png := TPngImage.Create;
            Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
            (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.Graphic := Png;
          finally
            // Libero el objeto finalmente
            Png.Free;
          end;
        end;
    end
    else
      begin
        try
          //cargo la imagen default, dependiendo del objeto seleccionado
          Png := TPngImage.Create;
          Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
          (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.Graphic := Png;
        finally
          // Libero el objeto finalmente
          Png.Free;
        end;
      end;
  except
    on E: Exception do
    begin
      {$IFDEF WEB}
      UniServerModule.Logger.AddLog('ColocarFotografiaReporte - ' + EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message + ' PathArchivoFoto '+PathArchivoFoto + ' QueryFotografia ' + QueryFotografia.Name);
      {$ENDIF}

      {$IFDEF DESKTOP}
      Log('ColocarFotografiaReporte - ' + EExcepcion + E.Message + ' PathArchivoFoto '+PathArchivoFoto + ' QueryFotografia ' + QueryFotografia.Name);
      {$ENDIF}

      {$IFDEF SERVICE}
      Log('ColocarFotografiaReporte - ' + EExcepcion + E.Message + ' PathArchivoFoto'+PathArchivoFoto);
      {$ENDIF}

      try
        //cargo la imagen default, dependiendo del objeto seleccionado
        Png := TPngImage.Create;
        Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
        (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.Graphic := Png;
      finally
        // Libero el objeto finalmente
        Png.Free;
      end;
    end;

  end;
end;


procedure ColocarFotografiaReporte(Reporte: TfrxReport; ObjetoPictureView: string; PathArchivo: string; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido);
{
  ColocarFotografiaReporte( frConsultaAsistenciaEstandar, 'Foto',
                            ObtenerRepositorio(RepositorioLocal).Valor + 'fotoperfil' +
                            TPath.DirectorySeparatorChar +
                            DMAsistencia.MSConsultaAsistenciaEstandarIdPersonalFoto.AsString + '.jpg',
                            TObjetoSiluetaPersona);
}
var
  Png: TPngImage;
begin
  {$IFDEF DEBUG}
 // Log('ColocarFotografiaReporte | PathArchivo ' + PathArchivo);
  {$ENDIF}

  // Verifico si existe el archivo
  if TFile.Exists(PathArchivo) = True then
  begin
    try
      // Cargo la fotografia, en el objeto grafico del reporte
      (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.LoadFromFile(PathArchivo);
    except
      on E: Exception do
      begin
        {$IFDEF WEB}
        UniServerModule.Logger.AddLog('ColocarFotografiaReporte - ' + EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message + ' Reporte ' + Reporte.Name + ' ObjetoPictureView ' + ObjetoPictureView + ' PathArchivo ' + PathArchivo);
        {$ENDIF}

        {$IFDEF DESKTOP}
        Log('ColocarFotografiaReporte - ' + EExcepcion + E.Message + ' Reporte ' + Reporte.Name + ' ObjetoPictureView ' + ObjetoPictureView + ' PathArchivo ' + PathArchivo);
        {$ENDIF}

        {$IFDEF SERVICE}
        Log('ColocarFotografiaReporte - ' + EExcepcion + E.Message + ' Reporte ' + Reporte.Name + ' ObjetoPictureView ' + ObjetoPictureView + ' PathArchivo ' + PathArchivo);
        {$ENDIF}

        try
          //cargo la imagen default, dependiendo del objeto seleccionado
          Png := TPngImage.Create;
          Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
          (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.Graphic := Png;
        finally
          // Libero el objeto finalmente
          Png.Free;
        end;

      end;

    end;

  end
  else
    begin
      try
        //Si no existe el archivo, se carga la imagen
        Png := TPngImage.Create;
        Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
        (Reporte.FindObject(ObjetoPictureView) as TfrxPictureView).Picture.Graphic := Png;
      finally
        // Libero el objeto finalmente
        Png.Free;
      end;
    end;

end;


function RecuperarFoto(QueryFoto: TDataSet; CampoJPG: String; TablaVirtual: TVirtualTable; CampoBMP: String; IdRegistro: integer): Boolean;
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
  StreamTemporal: TStream;
begin

  Result := False;

  // Abro y cierro el dataset para recuperar las fotos
  QueryFoto.Close;
  {$IFDEF SDAC}
  TCustomMSDataSet(QueryFoto).Params[0].Value := IdRegistro;
  {$ENDIF}
  QueryFoto.Open;

    if QueryFoto.RecordCount > 0 then
    begin
      // Creo los objetos en moemoria para manipular la foto
      StreamTemporal := TMemoryStream.Create;
      Bmp := TBitmap.Create;
      Jpg := TJPEGImage.Create;

      try
        // Cargo en la variable JPG la foto JPG guardada en la tabla

        // Asigno el contenido del campo con Foto JPG a la vriable BMP y luego salvo en un stream
        if not QueryFoto.FieldByName(CampoJPG).IsNull then
          begin
            Jpg.Assign(QueryFoto.FieldByName(CampoJPG));
            Bmp.Assign(Jpg);
            Bmp.SaveToStream(StreamTemporal);
          end;

        if TablaVirtual.Active = False then
        begin
          TablaVirtual.Open;
        end;

        // Limpio la tabla virtual y luego cargo en el campo de FotoBMP la foto convertirda
        TablaVirtual.Clear;
        TablaVirtual.Append;
        (TablaVirtual.FieldByName(CampoBMP) as TBlobField).LoadFromStream(StreamTemporal);
        TablaVirtual.Post;

      finally
        // Libero la memoria
        Jpg.Free;
        Bmp.Free;
        StreamTemporal.Free;
      end;
    end;
end;


function FindGraphicClass(const Buffer; const BufferSize: Int64; out GraphicClass: TGraphicClass): Boolean; overload;
var
  LongWords: array[Byte] of LongWord absolute Buffer;
  Words: array[Byte] of Word absolute Buffer;
begin
  GraphicClass := nil;
  Result := False;
  if BufferSize < MinGraphicSize then Exit;
  case Words[0] of
    $4D42: GraphicClass := TBitmap;
    $D8FF: GraphicClass := TJPEGImage;
    $4949: if Words[1] = $002A then GraphicClass := TWicImage; //i.e., TIFF
    $4D4D: if Words[1] = $2A00 then GraphicClass := TWicImage; //i.e., TIFF
  else
    if Int64(Buffer) = $A1A0A0D474E5089 then
      GraphicClass := TPNGImage
    else if LongWords[0] = $9AC6CDD7 then
      GraphicClass := TMetafile
    else if (LongWords[0] = 1) and (LongWords[10] = $464D4520) then
      GraphicClass := TMetafile
    else if StrLComp(PAnsiChar(@Buffer), 'GIF', 3) = 0 then
      GraphicClass := TGIFImage
    else if Words[1] = 1 then
      GraphicClass := TIcon;
  end;
  Result := (GraphicClass <> nil);
end;


function FindGraphicClass(Stream: TStream; out GraphicClass: TGraphicClass): Boolean; overload;
var
  Buffer: PByte;
  CurPos: Int64;
  BytesRead: Integer;
begin
  if Stream is TCustomMemoryStream then
  begin
    Buffer := TCustomMemoryStream(Stream).Memory;
    CurPos := Stream.Position;
    Inc(Buffer, CurPos);
    Result := FindGraphicClass(Buffer^, Stream.Size - CurPos, GraphicClass);
    Exit;
  end;
  GetMem(Buffer, MinGraphicSize);
  try
    BytesRead := Stream.Read(Buffer^, MinGraphicSize);
    Stream.Seek(-BytesRead, soCurrent);
    Result := FindGraphicClass(Buffer^, BytesRead, GraphicClass);
  finally
    FreeMem(Buffer);
  end;
end;


function IsJpegFile(AStream: TFileStream): Boolean;
const
  RightBuf: array[0..3] of Byte = ($FF, $D8, $FF, $D9);
var
  Buf: array[0..3] of Byte;
  AuxStream: TStream;
begin

  // Creo el objeto
  AuxStream := TMemoryStream.Create;

  try
    // Copio a un nuevo stream para evitar tocar
    AuxStream.CopyFrom(AStream, AStream.Size);

    FillChar(Buf, 4, 0);
    with AuxStream do
    begin
      Position := 0;
      ReadBuffer(Buf[0], 2);
      Position := Size - 2;
      ReadBuffer(Buf[2], 2);

      // Libero el objeto
      Free;
    end;

    // Devuelvo el resultado
    Result := CompareMem(@RightBuf[0], @Buf[0], 4);

  except
    on E: Exception do
    begin
      //Log(EExcepcion + E.Message);
    end;
  end;

end;


function IsBmpFile(AStream: TFileStream): Boolean;
const
  RightBuf: array[0..1] of Byte = ($42, $4D);
var
  Buf: array[0..1] of Byte;
  AuxStream: TStream;
begin

  // Creo el objeto
  AuxStream := TMemoryStream.Create;

  try
    // Copio a un nuevo stream para evitar tocar
    AuxStream.CopyFrom(AStream, AStream.Size);

    FillChar(Buf, 2, 0);
    with AuxStream do
    begin
      Position := 0;
      ReadBuffer(Buf[0], 2);

      // Libero el objeto
      Free;
    end;

    // Devuelvo el resultado
    Result := CompareMem(@RightBuf[0], @Buf[0], 2);

  except
    on E: Exception do
    begin
     // Log(EExcepcion + E.Message);
    end;
  end;
end;


function IsPngFile(AStream: TFileStream): Boolean;
const
  RightBuf: array[0..7] of Byte = ($89, $50 ,$4e, $47, $0d, $0a, $1a ,$0a);
var
  Buf: array[0..7] of Byte;
  AuxStream: TStream;
begin

  // Creo el objeto
  AuxStream := TMemoryStream.Create;

  try
    // Copio a un nuevo stream para evitar tocar
    AuxStream.CopyFrom(AStream, AStream.Size);

    FillChar(Buf, 8, 0);
    with AuxStream do
    begin
      Position := 0;
      ReadBuffer(Buf[0], 7);

      // Libero el objeto
      Free;
    end;

    // Devuelvo el resultado
    Result := CompareMem(@RightBuf[0], @Buf[0], 7);

  except
    on E: Exception do
    begin
     // Log(EExcepcion + E.Message);
    end;
  end;
end;


function SubirFotografia(Dataset: TDataSet; IdRegistro: integer; Campo: string; AStream: TFileStream; Formato: TFormatoImagen = JPG): Boolean;
var
  VerificarFormato: Boolean;
begin

  // Dependiendo del formato se verifica si archivo subido es valido
  case Formato of
    JPG: VerificarFormato := IsJpegFile(AStream);

    PNG: VerificarFormato := IsPngFile(AStream);

    BMP: VerificarFormato := IsBmpFile(AStream);
  end;

  if VerificarFormato = True then
  begin
    try
      Dataset.Close;
      {$IFDEF SDAC}
      TMSQuery(Dataset).Params[0].Value := IdRegistro;
      {$ENDIF}
      Dataset.Open;


      if Dataset.State <> dsEdit then
      begin
        Dataset.Edit;
      end;

      (Dataset.FieldByName(Campo) as TBlobField).LoadFromStream(AStream);

      // Hago post
      Dataset.Post;

      Result := True;
    except
      on E : Exception do
      begin
        {$IFDEF WEB}
        //UniServerModule.Logger.AddLog('SubirFotografia '+EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message + ' Dataset '+Dataset.Name );
       // Log(E.Message);
        {$ENDIF}
      end;

    end;

  end
  else
    begin
      // Devuelvo false que no se pudo
      {$IFDEF WEB}
      //MessageDlg(EFormatoImagenInvalido, mtError, [mbOK]);
      {$ENDIF}

      Result := False;
    end;

end;

{$IFDEF WEB}
procedure RotarIzquierda(Imagen  : TUniImage) ;
var
  IE: TImageEnVect;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    bmp.Assign(Imagen.Picture.Bitmap);
    IE := TImageEnVect.Create(nil);
    IE.Bitmap.Assign(bmp);
    Ie.Proc.Rotate(90);
    IE.Proc.ClearAllRedo;
    Imagen.Picture.Bitmap.Assign(IE.Bitmap);
    Imagen.Stretch:= true;
    Imagen.Refresh;
  finally
    bmp.Free;
    IE.Free;
  end;
end;

{$ENDIF}

{$IFDEF WEB}
procedure RotarDerecha(Imagen: TUniImage) ;
var
  IE: TImageEnVect;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    bmp.Assign(Imagen.Picture.Bitmap);
    IE := TImageEnVect.Create(nil);
    IE.Bitmap.Assign(bmp);
    Ie.Proc.Rotate(-90);
    IE.Proc.ClearAllRedo;
    Imagen.Picture.Bitmap.Assign(IE.Bitmap);
    Imagen.Stretch := true;
    Imagen.Refresh;
  finally
    bmp.Free;
    IE.Free;
  end;
end;
{$ENDIF}

{$IFDEF WEB}
procedure VoltearHorizontal(Imagen  : TUniImage) ;
var
  IE: TImageEnVect;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    bmp.Assign(Imagen.Picture.Bitmap);
    IE := TImageEnVect.Create(nil);
    IE.Bitmap.Assign(bmp);
    IE.Proc.Flip(fdHorizontal);
    IE.Proc.ClearAllRedo;

    Imagen.Picture.Bitmap.Assign(IE.Bitmap);
    Imagen.Stretch := true;

    Imagen.Refresh;
  finally
    bmp.Free;
    IE.Free;
  end;
end;
{$ENDIF}

{$IFDEF WEB}
procedure VoltearVertical(Imagen  : TUniImage) ;
var
  IE: TImageEnVect;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    bmp.Assign(Imagen.Picture.Bitmap);

    IE := TImageEnVect.Create(nil);
    IE.Bitmap.Assign(bmp);

    IE.Proc.Flip(fdVertical);
    IE.Proc.ClearAllRedo;

    Imagen.Picture.Bitmap.Assign(IE.Bitmap);
    Imagen.Stretch := true;
    Imagen.Refresh;
  finally
    bmp.Free;
    IE.Free;
  end;
end;
{$ENDIF}

 {$IFDEF WEB}
 procedure Zoom(Imagen : TUniImage; Zoom : Integer) ;
var
  IE: TImageEnVect;
  bmp: TBitmap;
  newWidth, newHeight: Integer;
begin
  try
    Imagen.Stretch      := false;
    Imagen.Proportional := false;

    bmp := TBitmap.Create;
    bmp.Assign(Imagen.Picture.Bitmap);
    IE := TImageEnVect.Create(nil);
    IE.Bitmap.Assign(bmp);
    {
    400%
    200%
    100%
    50%
    25%
    12%
    Ajustar
    }

    {procedure ImageResize(newWidth, newHeight: Integer; HorizAlign: TIEHAlign = iehLeft; VertAlign: TIEVAlign = ievTop; FillAlpha: Integer = 255);}

    case Zoom of
      0:   //400%
      begin
        IE.Proc.ImageResize(bmp.Width * 4, bmp.Height * 4);
      end;

      1:   //200%
      begin
//        IE.Zoom := 200;
        IE.Proc.ImageResize(bmp.Width * 2, bmp.Height * 2);
      end;

      2:    //100%
      begin
//        IE.Zoom := 100;
        IE.Proc.ImageResize(bmp.Width * 1, bmp.Height * 1);
      end;

      3:    //50%
      begin
//        IE.Zoom := 50;
        IE.Proc.ImageResize( round(bmp.Width * 0.5),  round(bmp.Height * 0.5));
      end;

      4:     //25%
      begin
//        IE.Zoom := 25;
        IE.Proc.ImageResize(round(bmp.Width * 0.25), round(bmp.Height * 0.25));
      end;

      5:    //12%
      begin
//        IE.Zoom := 12;
        IE.Proc.ImageResize(round(bmp.Width * 0.12), round(bmp.Height * 0.12));
      end;

      6:    //Ajustar
      begin
//        IE.Fit();
        Imagen.Stretch := true;
        Imagen.Proportional := true;
      end;
    end;

//    IE.Proc.ClearAllRedo;
    Imagen.Picture.Bitmap.Assign(IE.Bitmap);

    Imagen.Refresh;
  finally
    bmp.Free;
    IE.Free;
  end;
end;
{$ENDIF}



procedure CargarFotografia(CampoFotografia: TBlobField; QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False; ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido);
var
  PathArchivoFoto: string;
  Png: TPngImage;
  MsImagen: TMemoryStream;
begin
  try
    // Consulto la foto en la base de datos, si es modo historico se supone que
    // ya se abrio la consulta anteriormente
    if ReabrirQuery = True then
    begin
      QueryFotografia.Close;

      {$IFDEF SDAC}
      if QueryFotografia is TMSQuery then
      begin
        TMSQuery(QueryFotografia).ParamByName(CampoIdObjeto.FieldName).Value := CampoIdObjeto.Value;
      end;
      {$ENDIF}

      {$IFDEF FIREDAC}
      if QueryFotografia is TFDQuery then
      begin
        TFDQuery(QueryFotografia).ParamByName(CampoIdObjeto.FieldName).Value := CampoIdObjeto.Value;
      end;
      {$ENDIF}

      QueryFotografia.Open;
    end;


    // Si existe registro, procedere a cargar la foto del repositorio
    if QueryFotografia.RecordCount > 0 then
    begin
      // Dependiendo si se usa crop o no
      if UsarCrop = True then
      begin
        PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\Crop\' + CampoIdFotografia.AsString + '.jpg';
      end
      else
        begin
          PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' + CampoIdFotografia.AsString + '.jpg';
        end;

      // Verifico si existe el archivo
      if FileExists(PathArchivoFoto) = True then
      begin
        // Cargo la fotografia
        CampoFotografia.LoadFromFile(PathArchivoFoto);
      end;
    end
    else
      begin
        try
          //cargo la imagen default, dependiendo del objeto seleccionado
          Png := TPngImage.Create;
          Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));

          // Creo un objeto stream
          MsImagen := TMemoryStream.create;
          MsImagen.Position := 0;

          // Guardo la imagen en en el stream
          Png.SaveToStream(MsImagen);
          MsImagen.Position := 0;

          // En campo blob guardo la imagen
          with CampoFotografia as TBlobField do
            LoadFromStream(MsImagen);

          // Libero el objeto stream
          FreeAndNil(MsImagen);


        finally
          // Libero el objeto finalmente
          Png.Free;
        end;
      end;

  except
    on E: Exception do
    begin

      //Log('CargarFotografia '+EExcepcion + E.Message);

      try
        //cargo la imagen default, dependiendo del objeto seleccionado
        Png := TPngImage.Create;
        Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));

        try
          //cargo la imagen default, dependiendo del objeto seleccionado
          Png := TPngImage.Create;
          Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));

          // Creo un objeto stream
          MsImagen := TMemoryStream.create;
          MsImagen.Position := 0;

          // Guardo la imagen en en el stream
          Png.SaveToStream(MsImagen);
          MsImagen.Position := 0;

          // En campo blob guardo la imagen
          with CampoFotografia as TBlobField do
            LoadFromStream(MsImagen);

          // Libero el objeto stream
          FreeAndNil(MsImagen);


        finally
          // Libero el objeto finalmente
          Png.Free;
        end;

      finally
        // Libero el objeto finalmente
        Png.Free;
      end;

    end;

  end;

end;


{$IFDEF WEB}
procedure DescargarFotografia(QueryFotografia: TMSQuery; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False);
var
  PathArchivoFoto: string;
begin

  try
    // Si existe registro, procedere a cargar la foto del repositorio
    if QueryFotografia.RecordCount > 0 then
    begin
      // Dependiendo si se usa crop o no
      if UsarCrop = True then
      begin
        PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\Crop\' + CampoIdFotografia.AsString + '.jpg';
      end
      else
        begin
          PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' + CampoIdFotografia.AsString + '.jpg';
        end;
    end;

      // Verifico si existe el archivo
    if FileExists(PathArchivoFoto) = True then
    begin
      // Descargo el archivo
     // UniSession.SendFile(PathArchivoFoto, RenombreFichero(PathArchivoFoto));
    end
    else
      begin
      //  Log('DescargarFotografia - No Existe la Foto ' + PathArchivoFoto);
      end;

  except
    on E: Exception do
    begin
      UniServerModule.Logger.AddLog('DescargarFotografia '+EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
    end;

  end;

end;


procedure CargarFotografia(FotoActual: TUniImage; QueryFotografia: TMSQuery; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField; Repositorio: string; UsarCrop: Boolean = False;
                           ReabrirQuery: Boolean = True; TipoObjetoFondo: TTipoObjetoFondo = TObjetoNoDefinido);
var
  PathArchivoFoto: string;
  Png: TPngImage;
  JPGImage: TJPEGImage;
  Bitmap: TBitmap;
begin

  try
    // Consulto la foto en la base de datos, si es modo historico se supone que
    // ya se abrio la consulta anteriormente
    AsignarPrincipal('UnitOperacionesFotografia.CargarFotografia', [QueryFotografia] );

    if ReabrirQuery = True then
    begin
      QueryFotografia.Close;
      QueryFotografia.ParamByName(CampoIdObjeto.FieldName).Value := CampoIdObjeto.Value;
      QueryFotografia.Open;
    end;


    // Si existe registro, procedere a cargar la foto del repositorio
    if QueryFotografia.RecordCount > 0 then
    begin

      case TipoObjetoFondo of
        TObjetoSiluetaPersona:
        begin
          // Dependiendo si se usa crop o no
          if UsarCrop = True then
          begin
            PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\Crop\' + CampoIdFotografia.AsString + '.jpg';
          end
          else
            begin

              // Ruta por defecto del archivo
              PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' + CampoIdFotografia.AsString + '.jpg';

              if TFile.Exists(PathArchivoFoto) = False then
              begin
                PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\Original\' + CampoIdFotografia.AsString + '.jpg';
              end;

            end;
        end;

        TObjetoRelojBiometrico:
        begin
          PathArchivoFoto := Repositorio + '\' + CampoIdFotografia.AsString + '.jpg';
        end;

        TObjetoHuellaDactilar:
        begin
          PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' +
                                               CampoIdFotografia.AsString + '.bmp';
        end;

        else  // Otros tipos de fotos
        begin
          PathArchivoFoto := Repositorio + QueryFotografia.FieldByName(CampoIdObjeto.FieldName).AsString + '\' +
                                               CampoIdFotografia.AsString + '.jpg';

        end;

      end;


      // Verifico si existe el archivo
      if FileExists(PathArchivoFoto) = True then
      begin

        // Obtengo la extension del archivo en un case y actuo en consecuencia
        case AnsiIndexStr(TPath.GetExtension(PathArchivoFoto), ['.jpg', '.bmp']) of
          0: // Jpg
          begin
            // Creo el objeto en memoria
            JPGImage := TJPEGImage.Create;
            try
              // Creo el objeto JPG, y cargo el archivo
              JPGImage.LoadFromFile(PathArchivoFoto);

              // Cargo la fotografia
              FotoActual.Picture.Graphic := JPGImage;
            finally
              // Libero el objeto luego de usar
              JPGImage.Free;
            end;
          end;

          1: // bmp
          begin
            // Creo el objeto en memoria
            Bitmap := TBitmap.Create;
            try
              // Cargo el objeto bmp en el objeto
              Bitmap.LoadFromFile(PathArchivoFoto);

              // Cargo la fotografia
              FotoActual.Picture.Graphic := Bitmap;
            finally
              // Libero el objeto
              Bitmap.Free;
            end;
          end;

        end;


      end
      else
        begin
          try
            //En caso que no Exista el objeto
            Png := TPngImage.Create;
            Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
            FotoActual.Picture.Graphic := Png;
          finally
          //  Log('CargarFotografia, No Existe la Foto '+ PathArchivoFoto);
            // Libero el objeto finalmente
            Png.Free;
          end;
        end;

    end
    else
      begin
        try
          //cargo la imagen default, dependiendo del objeto seleccionado
          Png := TPngImage.Create;
          Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
          FotoActual.Picture.Graphic := Png;
        finally
          // Libero el objeto finalmente
          Png.Free;
        end;
      end;
  except
    on E: Exception do
    begin
      UniServerModule.Logger.AddLog('CargarFotografia '+ EExcepcion + 'UnitOperacionesFotografia.CargarFotografia. Nombre:' + CampoIdObjeto.FieldName +' Valor: '+ CampoIdObjeto.AsString , UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
      try
        //cargo la imagen default, dependiendo del objeto seleccionado
        Png := TPngImage.Create;
        Png.LoadFromResourceName(HInstance, ObjetoFondo(TipoObjetoFondo));
        FotoActual.Picture.Graphic := Png;
      finally
        // Libero el objeto finalmente
        Png.Free;
      end;
    end;

  end;
end;
{$ENDIF}


procedure CargarFotoPerfil(FotoPerfil: TImagePerfil; IdPersonal: Integer = -1; DocumentoNro: string = ''; UsarLinkDatos: Boolean = False; MiniaturaCircular: Boolean = True);
var
  PathArchivoFoto: string;
begin

  // Solo si es autoservicio Desktop es requerido esto
  {$IFDEF AUTOSERVICIODESKTOP}
    if DMAutoservicio = nil then
    begin
      Application.CreateForm(TDMAutoservicio, DMAutoservicio);
    end;
  {$ENDIF}

  try
    // Si uso el Link de Datos, esto permite utilizar datos de personal desde otra base de datos
    // Por ejemplo Giraduria y RH tienen distintas bases de datos
    if UsarLinkDatos = True then
    begin

      {$IF DEFINED(AUTOSERVICIOWEB) OR
           DEFINED(AUTOSERVICIODESKTOP)}
           // Es solo para salud?
      DMAutoservicio.MSConnectionLink.Connect;

      // Limpio los parametros del dataset
      VaciarParametros([DMAutoservicio.MSConsultarFoto]);
      DMAutoservicio.MSConsultarFoto.ParamByName('DocumentoNroConLetra').Value := DocumentoNro;
      DMAutoservicio.MSConsultarFoto.Open;

      if DMAutoservicio.MSConsultarFoto.RecordCount > 0 then
      begin
        // Establezco el path de la fotografia
        PathArchivoFoto := ObtenerRepositorio(RepositorioLocal).Valor + 'fotoperfil' + TPath.DirectorySeparatorChar +
                           DMAutoservicio.MSConsultarFotoIdPersonalFoto.AsString + '.jpg';
      end;

      // Verifico si existe la fotografia
      if TFile.Exists(PathArchivoFoto) = False then
      begin
        // Descargo la foto en la carpeta de repositorio local
        UnitOperacionesMiddleware.DescargarFotografia(DMAutoservicio.MSConsultarFotoIdPersonal.Value,
                            DMAutoservicio.MSConsultarFotoIdPersonalFoto.Value,
                            PathArchivoFoto,
                            'Crop');
      end;

      // Asigno la fotografia a partir del archivo
      FotoCircular(PathArchivoFoto, TImagePerfil(FotoPerfil), MiniaturaCircular);

      {$ENDIF}

    end
    else  // No usa Link de datos
      begin

        {$IFNDEF MIDDLEWARESERVER}
        // Si el Id Personal se trata de -1 se cargara el perfil de usuario actual
        if IdPersonal = -1 then
        begin
          // Verifico si el datamodule de usuario esta creado
          if DMUsuario <> nil then
          begin
            FotoCircular(DMUsuario.UsuarioRecord.Foto, TImagePerfil(FotoPerfil), MiniaturaCircular);
          end;

        end
        else
          begin
            //Consulto la foto en la base de datos, la ultima foto
//            DMUsuario.MSConsultarFoto.Close;
//            DMUsuario.MSConsultarFoto.ParamByName('IdPersonal').Value := IdPersonal;
//            DMUsuario.MSConsultarFoto.Open;

            // Si existe registro, procedere a cargar la foto del repositorio
//            if DMUsuario.MSConsultarFoto.RecordCount > 0 then
//            begin
//              {$IFDEF DESKTOP}
//              // Descargo la foto mediante middleware server
//              PathArchivoFoto := ObtenerRepositorio(RepositorioLocal).Valor + 'fotoperfil' + TPath.DirectorySeparatorChar +
//                                 DMUsuario.MSConsultarFotoIdPersonalFoto.AsString + '.jpg';
//
//              // Verifico si existe la fotografia
//              if TFile.Exists(PathArchivoFoto) = False then
//              begin
//
//                {$IF NOT( DEFINED(MIDDLEWARESERVER) OR
//                          DEFINED(CAPTURE) )}
//                // Descargo la foto en la carpeta de repositorio local
//                UnitOperacionesMiddleware.DescargarFotografia(DMUsuario.MSConsultarFotoIdPersonal.Value,
//                                    DMUsuario.MSConsultarFotoIdPersonalFoto.Value,
//                                    PathArchivoFoto,
//                                    'Crop');
//                {$ENDIF}
//              end;
//              {$ENDIF}
//
//              {$IFDEF WEB}
//              // Establezco la ruta al fichero
//              PathArchivoFoto := ObtenerRepositorio(RH).Valor + '\Foto\' + DMUsuario.MSConsultarFotoIdPersonal.AsString + '\Crop\' + DMUsuario.MSConsultarFotoIdPersonalFoto.AsString + '.jpg';
//              {$ENDIF}
//            end;

            // Asigno la fotografia a partir del archivo
            FotoCircular(PathArchivoFoto, TImagePerfil(FotoPerfil), MiniaturaCircular);
          end;

        {$ENDIF}
      end;


  except
    on E: Exception do
    begin
      {$IFDEF WEB}
      UniServerModule.Logger.AddLog('CargarFotoPerfil '+ EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
      {$ENDIF}

      {$IFDEF DESKTOP}
      Log(EExcepcion + E.Message);
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}
    end;

  end;
end;


procedure FotoCircular(Foto: TBlobField; FotoPerfil: TImagePerfil; MiniaturaCircular: Boolean);
var
  MsImagen: TStream;
  JPGImage: TImageEnView;
begin

  if Assigned(Foto) = True then
  begin

    // Verifico si el campo no es nulo
    if Foto.IsNull = False then
    begin

      try
        // Creo el objeto en memoria
        JPGImage := TImageEnView.Create(nil);

        try
          // Creo un objeto stream, con la foto actual
          MsImagen := Foto.DataSet.CreateBlobStream(Foto, bmRead);

          // Cargo la imagen en el objeto JPG
          JPGImage.IO.LoadFromStreamJpeg(MsImagen);

          // Si tiene la miniatura circular, lo recorto
          if MiniaturaCircular = True then
          begin
            // Establezco un tamano estandar para escalar
            JPGImage.Width := 80;
            JPGImage.Height := 80;

            // Ajusto la fotografia
            JPGImage.Fit(False);

            // Dibujo un circulo y selecciono
            JPGImage.SelectEllipse(Round(JPGImage.Width / 2) - 4, Round(JPGImage.Height /2) - 2, JPGImage.Width - 14, JPGImage.Height - 10);

            // Corto el circulo para que quede la foto
            JPGImage.Proc.CropSel();
            JPGImage.Deselect;
          end;

          // Relleno la foto de perfil
          FotoPerfil.Picture.Bitmap.Assign(JPGImage.Bitmap);

        finally
          // Libero el objeto luego de usar
          JPGImage.Free;

          // Libero el objeto stream
          FreeAndNil(MsImagen);

        end;

      except
        on E: Exception do
        begin
        //  Log(EExcepcion + E.Message);
        end;

      end;

    end;

  end;
end;


procedure FotoCircular(PathArchivoFoto: string; FotoPerfil: TImagePerfil; MiniaturaCircular: Boolean);
var
  JPGImage: TImageEnView;
begin

  // Verifico si existe el archivo
  if TFile.Exists(PathArchivoFoto) = True then
  begin

    try
      // Creo el objeto en memoria
      JPGImage := TImageEnView.Create(nil);

      try
        // Creo el objeto JPG, y cargo el archivo
        JPGImage.IO.LoadFromFileJpeg(PathArchivoFoto);

        // Si tiene la miniatura circular, lo recorto
        if MiniaturaCircular = True then
        begin
          // Establezco un tamano estandar para escalar
          JPGImage.Width := 80;
          JPGImage.Height := 80;

          // Ajusto la fotografia
          JPGImage.Fit(False);

          // Dibujo un circulo y selecciono
          JPGImage.SelectEllipse(Round(JPGImage.Width / 2) - 4, Round(JPGImage.Height /2) - 2, JPGImage.Width - 14, JPGImage.Height - 10);

          // Corto el circulo para que quede la foto
          JPGImage.Proc.CropSel();
          JPGImage.Deselect;
        end;

        // Relleno la foto de perfil
        FotoPerfil.Picture.Bitmap.Assign(JPGImage.Bitmap);

      finally
        // Libero el objeto luego de usar
        JPGImage.Free;
      end;

    except
      on E: Exception do
      begin
       // Log(EExcepcion + E.Message);
      end;

    end;


  end;

end;




function AgregarFotografia(QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; CampoIdObjeto: TIntegerField): integer;
begin
  // Si no esta activo el dataset lo activo
  if QueryFotografia.Active = False then
  begin
    {$IFDEF SDAC}
    TCustomMSDataSet(QueryFotografia).ParamByName(CampoIdFotografia.FieldName).Value := -1;
    {$ENDIF}
    QueryFotografia.Open;
  end;


  try
    // Agrego la referencia de la foto
    QueryFotografia.Append;
    QueryFotografia.FieldByName(CampoIdObjeto.FieldName).Value := CampoIdObjeto.AsInteger;

    // Cargo los valores de auditoria, resolver el tema de auditoria de Middleware
    {$IFDEF NOT MIDDLEWARESERVER}
    CargarValoresAuditoria(QueryFotografia);
    {$ENDIF}

    // Hago post
    QueryFotografia.Post;

    // Devuelvo los datos
    Result := CampoIdFotografia.Value;

  except
    on E: Exception do
    begin
      {$IFDEF WEB}
      UniServerModule.Logger.AddLog('AgregarFotografia ' + EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
      {$ENDIF}

      {$IFDEF DESKTOP}
      Log('AgregarFotografia ' + EExcepcion + E.Message);
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}

      Abort;

    end;

  end;
end;


function EliminarFotografia(QueryFotografia: TDataSet; CampoIdFotografia: TIntegerField; ValorIdFotografia: Integer): Boolean;
begin

  try

    // Consulto si existe la foto mencionada
    QueryFotografia.Close;
    {$IFDEF SDAC}
    TCustomMSDataSet(QueryFotografia).ParamByName(CampoIdFotografia.FieldName).AsInteger := ValorIdFotografia;
    {$ENDIF}
    QueryFotografia.Open;

    // En caso que exista datos de la foto
    if QueryFotografia.RecordCount > 0 then
    begin
      QueryFotografia.Delete;

      // Devuelvo resultado
      Result := True;
    end;

  except
    on E: Exception do
    begin
      Result := false;

      {$IFDEF WEB}
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
      UniServerModule.Logger.AddLog('EliminarFotografia '+EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
      {$ENDIF}

      {$IFDEF DESKTOP}
      Log(EExcepcion + E.Message);
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}

      Abort;

    end;

  end;
end;


procedure CrearFotoReloj(IdPersonal: integer; IdPersonalFoto: integer);
var
  JPGImage: TImageEnView;
  PathFotoCrop, PathFotoReloj: string;
  NuevoHeight, NuevoWidth: integer;
  PorcentajeTamano: Extended;
  CorteBorde: integer;
begin

//  // Establezco los path
//  PathFotoCrop := ObtenerRepositorio(RH).Valor + TPath.DirectorySeparatorChar + 'Foto' + TPath.DirectorySeparatorChar +
//                  IntToStr(IdPersonal) + TPath.DirectorySeparatorChar + 'Crop' + TPath.DirectorySeparatorChar + IntToStr(IdPersonalFoto) + '.jpg';
//
//  PathFotoReloj := ObtenerRepositorio(RH).Valor + TPath.DirectorySeparatorChar + 'Foto' + TPath.DirectorySeparatorChar +
//                   IntToStr(IdPersonal) + TPath.DirectorySeparatorChar + 'Reloj' + TPath.DirectorySeparatorChar + IntToStr(IdPersonalFoto) + '.jpg';
//
//  try
//    // Verifico si existe el archivo, si no existe
//    if TFile.Exists(PathFotoReloj) = False then
//    begin
//
//      // Creo la estructura de reloj
//      CrearCarpetaEstructuraArchivo(ObtenerRepositorio(RH).Valor + TPath.DirectorySeparatorChar + 'Foto' + TPath.DirectorySeparatorChar, IdPersonal, TRostro);
//
//      try
//        // Creo el objeto en memoria
//        JPGImage := TImageEnView.Create(nil);
//
//        // Cargo la foto
//        JPGImage.IO.LoadFromFile(PathFotoCrop);
//
//        // Ajusto el tama�o
//        JPGImage.Fit(True);
//
//        // El tamano estandar para el reloj es 120 x 174
//        // Realizo los calculos de recortes, manteniendo el aspecto de la imagen
//        PorcentajeTamano := 174 * 100 / JPGImage.IEBitmap.Height;
//        NuevoHeight := Round(JPGImage.IEBitmap.Height * PorcentajeTamano / 100);
//        NuevoWidth := Round(JPGImage.IEBitmap.Width * PorcentajeTamano / 100);
//
//        // Reajusto el tamano de la imagen
//        JPGImage.IEBitmap.Resample(NuevoWidth, NuevoHeight, rfNone, True);
//
//        // Establezco ahora los cortes bordes, (obtengo la mitad del area de corte de cada lado
//        CorteBorde := Round((JPGImage.IEBitmap.Width - 120) / 2);
//
//        // LOs bordes que se cortan se deben multiplicar por negativo
//        JPGImage.IEBitmap.Resize(CorteBorde * -1, 0, CorteBorde * -1, 0, 255);
//
//        // Guardo la imagen final, en formato jpg
//        JPGImage.IO.SaveToFileJpeg(PathFotoReloj);
//
//      finally
//        // Libero el objeto luego de usar
//        JPGImage.Free;
//      end;
//
//    end;

//  except
//    on E: Exception do
//    begin
//      Log(EExcepcion + E.Message);
//
//      {$IFDEF DESKTOP}
//
//          // En caso que se trate de aplicaciones de serivicio en modo desktop para depurar
//         {$IF NOT (DEFINED(SYNCRELOJ)
//             OR DEFINED(MIDDLEWARESERVER))}
//            MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
//          {$ENDIF}
//
//      {$ENDIF}
//
//   end;

 // end;
end;


procedure CrearFotoPerfil(IdPersonal: integer; IdPersonalFoto: integer);
var
  JPGImage: TImageEnView;
  PathFotoCrop, PathFotoPerfil: string;
begin

  // Establezco los path
//  PathFotoCrop := ObtenerRepositorio(RH).Valor + '\Foto\' + IntToStr(IdPersonal) + '\Crop\' + IntToStr(IdPersonalFoto) + '.jpg';
//  PathFotoPerfil := ObtenerRepositorio(RH).Valor + '\Foto\' + IntToStr(IdPersonal) + '\Perfil\' + IntToStr(IdPersonalFoto) + '.jpg';

  try
    // Verifico si existe el archivo, si no existe
    if TFile.Exists(PathFotoPerfil) = False then
    begin

      // Creo la estructura de reloj
      //CrearCarpetaEstructuraArchivo(ObtenerRepositorio(RH).Valor + '\Foto\', IdPersonal, TRostro);

      try
        // Creo el objeto en memoria
        JPGImage := TImageEnView.Create(nil);

        // Cargo la foto
        JPGImage.IO.LoadFromFile(PathFotoCrop);

        // Establezco un tamano estandar para escalar
        JPGImage.Width := 80;
        JPGImage.Height := 80;

        // Ajusto la fotografia
        JPGImage.Fit(False);

        // Dibujo un circulo y selecciono
        JPGImage.SelectEllipse(Round(JPGImage.Width / 2) - 4, Round(JPGImage.Height /2) - 2, JPGImage.Width - 14, JPGImage.Height - 10);

        // Corto el circulo para que quede la foto
        JPGImage.Proc.CropSel();
        JPGImage.Deselect;

        // Guardo la imagen final, en formato jpg
        JPGImage.IO.SaveToFileJpeg(PathFotoPerfil);

      finally
        // Libero el objeto luego de usar
        JPGImage.Free;
      end;

    end;

  except
    on E: Exception do
    begin
      //Log(EExcepcion + E.Message);
      {$IFDEF DESKTOP}
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}
    end;

  end;
end;


procedure AplicarChromeKey(FullPath: string; Tolerancia: Double = 0.21);
var
  ImageEnView: TImageEnView;
  //Tolerance: Double;
  KeyColorRGB: TRGB;
begin

  try
    try
      // Creo el objeto
      ImageEnView := TImageEnView.Create(nil);

      // Cargo la imagen
      ImageEnView.IO.LoadFromFileJpeg(FullPath);
      ImageEnView.Fit(False);

      // Obtengo los parametros
      //Tolerance := 0.21;
      KeyColorRGB := ImageEnView.Proc.GuessChromaKeyColor();

      // Remuevo el Fondo
     // Log('Remuevo el fondo de la fotografia: ' + FullPath);
      ImageEnView.Proc.RemoveChromaKey( KeyColorRGB, Tolerancia, 30, 2, 0 );

      // Guardo la foto
      ImageEnView.IO.SaveToFileJpeg(FullPath);

    finally
      // Libero los objetos
      ImageEnView.Free;
    end;


  except
    on E: Exception do
    begin
     // Log(EExcepcion + E.Message);
      {$IFDEF DESKTOP}
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}
    end;

  end;


end;


{$IFDEF DESKTOP}
procedure CargarFotografiaDefault(ObjetoImage: TcxImage);
var
  Png: TPngImage;
begin
  try
    //cargo la imagen default, dependiendo del objeto seleccionado
    Png := TPngImage.Create;
    Png.LoadFromResourceName(HInstance, ObjetoFondo(TObjetoSiluetaPersona));
    ObjetoImage.Picture.Graphic := Png;
  finally
    // Libero el objeto finalmente
    Png.Free;
  end;
end;
{$ENDIF}


{$IFDEF AUTOSERVICIODESKTOP}
procedure CargarFotoPerfilDefault(ObjetoImage: TscGPImage);
var
  Png: TPngImage;
begin
  try
    //cargo la imagen default, dependiendo del objeto seleccionado
    Png := TPngImage.Create;
    Png.LoadFromResourceName(HInstance, 'UsuarioPerfilAzul');
    ObjetoImage.Picture.Graphic := Png;
  finally
    // Libero el objeto finalmente
    Png.Free;
  end;
end;
{$ENDIF}

end.
