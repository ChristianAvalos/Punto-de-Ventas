

unit UnitCodigosComunes;

{$INCLUDE 'compilador.inc'}

interface

uses
  // ======== Desktop ==========
  {$IFDEF DESKTOP}
  // Unit de DevExpress
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxRibbonSkins, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxRibbonPainter,
  cxClasses, Vcl.DBGrids,
  ImgList, cxCheckBox, cxProgressBar, dxBarExtItems, cxBarEditItem,
  cxButtonEdit, cxContainer, cxEdit, cxStyles, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxNavigator, cxDBData, cxBlobEdit,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxMemo, cxDBEdit, cxMaskEdit, cxCalendar, cxTextEdit,
  cxDBNavigator, cxMRUEdit, dxdbtrel, cxButtons, dxSkinsdxStatusBarPainter,
  dxStatusBar, dxSpellCheckerDialogs,
  {$ENDIF}


  // ========= Web ==============
  {$IFDEF WEB}
  MainModule, ServerModule, UniGuiApplication,
  uniGUIForm, uniDBMemo,uniDBGrid, uniDBCheckBox, uniLabel,
  UniDBEdit, UniDBLookupComboBox, UniDBDateTimePicker, uniDBComboBox,
  uniImage, FormularioCRUDMaestro, uniStatusBar,uniButton,
  uniEdit, uniCombobox, uniMemo,  uniCheckBox,
  uniDateTimePicker, uniGuiTypes, UniRadioButton, uniGroupBox,
  uniGUIAbstractClasses, uniPanel, uniGuiClasses, uniGuiFrame,uniImageList,
  UniSpinEdit,
  {$ENDIF}

  // ===== Genericos ========
  System.SysUtils, TypInfo, Vcl.Dialogs, Vcl.ActnList, System.Classes, VirtualTable,
  Data.DB, MSAccess, Vcl.Controls, System.StrUtils,
  System.DateUtils, Vcl.Graphics, Vcl.Forms, System.Variants, Winapi.Windows,

  // Exportacion de reportes
  frxClass, frxExportPDF, frxExportHTML,

  // Otros
  UnitRecursoString;//, DataModuleReporte;

type
  TEnumUtils = class
    class function GetAs<T>(pValor: String): T;
    class function EnumToInt<T>(const enValue: T): Integer;
    class function EnumToString<T>(enValue: T): string;
  end;

const
  UnassignedDate = -693594;

  function NombreMes(mes: integer): string;
  function NumeroMes(mes: string): integer;

  function NombreDia(dia: Integer): string;

  function ObtenerFecha: String;

  function FechaDeSQLTimeStamp(date: TSQLTimeStampField): TDateTime;
  function ExistProp(Instance: TObject; const PropName: string): Boolean;
  function SetPropAsString(AObj: TObject; const PropName, Value: String): Boolean;
  function GetRTTIControlInfo(AControl: TPersistent; propList:TStrings;  AProperty: string): PPropInfo;
  function IsEmptyOrNull(const Value: Variant): Boolean;

  {$IFDEF WEB}
  function CompareInt(List: TStringList; Index1, Index2: Integer): Integer;
  function CompareDates(List: TStringList; Index1, Index2: Integer): Integer;
  function CompareDouble(List: TStringList; Index1, Index2: Integer): Integer;
  {$ENDIF}

  procedure ActivarTablaVirtual(Lugar: string; TablaVirtual: TVirtualTable; ClearDataset: Boolean = true);
  procedure CargarDataSetsMain();

  {$IFDEF DESKTOP}
  procedure CargarCombo(Combo: TcxComboBox; Campo: TField);
  {$ENDIF}


  {$IFDEF WEB}
  procedure CambiarEstadosCheckBox(CheckBoxes: array of TUniCheckBox; Marcado: Boolean = True; Encendido: Boolean = True);
  procedure CargarLiveCombo(Combo: TUniComboBox; Query: TMSQuery; NombreParametroSTR, NombreParametroID: string;
  ParametroId: Integer=0; ParametroTexto: string=''; Result: TStrings=nil; DesdeComa: Boolean = False);
  procedure CargarCombo(Combo: TUniComboBox; Campo: TField) overload;
  procedure CargarCombo(Combo: TUniComboBox; Campo: TField; Organigrama: string) overload;
  {$ENDIF}

  function HextoInt(HexStr: string):integer;
  function ObtenerCampoEntreCaracter(Tabla: TDataSet; Campo : TField ; Caracter : String = ','): string;
  function ObtenerSumatoriaCampo(Tabla: TDataSet; Campo : TField): string;
  procedure CopiarDataSetAVirtualTable(DataSet: TDataset; VirtualTable : TDataset; HacerClear: Boolean = True; CopiarCampos : Boolean = False);
  procedure CopiarCamposDataSetAVirtualTable(DataSet : TDataset; VirtualTable: TDataset);
  function DiasHabiles(const FechaInicial, FechaFinal: TDateTime): Integer; overload;
  function DiasHabiles(const FechaInicial: TDateTime; CantidadDias: Integer): TDateTime; overload;


implementation

uses
  DataModulePrincipal,
  //DataModuleExportacionDatos,

  {$IFDEF SDAC}
  DataModuleUsuario,
  //DataModuleComunUsuario,

  {$IF NOT (DEFINED(RUCAUTOMATE)
       OR DEFINED(DYNAMICSLINK) )}
    //DataModuleComunGlobal,
  //  DataModuleComunComercial,
   // DataModuleFirma,
    {$ENDIF}

  //UnitOrganizacionSeleccionada,
  {$ENDIF}

  UnitVerificarModulo,// UnitLog,
  //UnitOperacionesSO,
  UnitCodigosComunesString,
   //UnitDatos,
  UnitValidaciones,

  {$IFDEF WEB}
    {$IFNDEF DYNAMICSLINK}
  // FormularioSeleccionModeloFirmaLogotipo,
    {$ENDIF}
  {$ENDIF}


  //UnitAuditoria,
 // UnitCodigosComunesImpresion,
  UnitCodigosComunesDataModule;

{$REGION 'Varias'}

function NombreMes(mes: integer): string;
const
  Meses: array [1 .. 12] of string = ('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo',
    'Junio', 'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre');
begin
  Result := Meses[mes];
end;


function NumeroMes(mes: string): integer;
var
  i: integer;
const
  Meses: array [1 .. 12] of string = ('enero', 'febrero', 'marzo', 'abril', 'mayo',
    'junio', 'julio', 'agosto', 'setiembre', 'octubre', 'noviembre', 'diciembre');
begin
  for i := 1 to 12 do
    begin
      if UpperCase(mes) = UpperCase(Meses[i]) then
        Result := i;
    end;
end;


function NombreDia(dia: Integer): string;
const
  Dias: array [1 .. 7] of string = ('Lunes', 'Martes', 'Miercoles', 'Jueves',
                                    'Viernes', 'S?bado', 'Domingo');
begin
  Result := Dias[dia];
end;

function FechaDeSQLTimeStamp(date: TSQLTimeStampField): TDateTime;
var
  fechaString: string;
begin
  fechaString := date.Value.Day.ToString+'/';
  fechaString := fechaString+date.Value.Month.ToString+'/';
  fechaString := fechaString+date.Value.Year.ToString+' ';
  fechaString := fechaString+date.Value.Hour.ToString+':';
  fechaString := fechaString+date.Value.Minute.ToString+':';
  fechaString := fechaString+date.Value.Second.ToString;

  Result := VarToDateTime(fechaString);
end;



function ExistProp(Instance: TObject; const PropName: string): Boolean;
var
  PropInfo: PPropInfo;
begin
  // Devuelve si existe o no una propiedad en un Objeto (RTTI).
  // Busca la propiedad y devuelve segun si la estructura = nil
  PropInfo := GetPropInfo(Instance, PropName);
  Result := not(PropInfo = nil);
end;


function SetPropAsString(AObj: TObject; const PropName, Value: String): Boolean;
var
  PInfo: PPropInfo;
begin
  { :Asigna valor a una propiedad a trav?s del Nombre (RTTI). }
  // Intentamos acceder (con un puntero) a la info. de la propiedad
  PInfo := GetPropInfo(AObj.ClassInfo, PropName);
  Result := PInfo <> nil;
  // Se ha obtenido la informaci?n...
  if (Result) then
    begin
      // Se ha encontrado la propiedad con ?ste nombre; Chequear el tipo...
      if (PInfo^.Proptype^.Kind = tkString) or
        (PInfo^.Proptype^.Kind = tkLString) then
        begin
          // Asignar el valor de tipo String
          SetStrProp(AObj, PInfo, Value);
        end
      else if (PInfo^.Proptype^.Kind = tkInteger) then
        begin
          // Asignar el valor...
          if (PInfo^.Proptype^.Name = 'TColor') then
            begin
                SetOrdProp(AObj, PInfo, StringToColor(Value));
            end
          else if (PInfo^.Proptype^.Name = 'TCursor') then
            begin
                SetOrdProp(AObj, PInfo, StringToCursor(Value));
            end
          else
            begin
                SetOrdProp(AObj, PInfo, StrToInt(Value));
            end;
        end
      else if (PInfo^.Proptype^.Kind = tkEnumeration) then
        begin
          // Bloque de proteccion
          try
            if (PInfo^.Proptype^ = TypeInfo(System.Boolean)) then
              begin
                  SetOrdProp(AObj, PInfo, StrToInt(Value));
              end
            else
              begin
                  SetOrdProp(AObj, PInfo, StrToInt(Value));
              end;
          except
            raise;
          end;
        end
      else
        begin
            Result := False;
        end;
    end
  else
    begin
      // No se ha encontrado la propiedad con ese nombre
      Result := False;
    end;
end;


function GetRTTIControlInfo(AControl: TPersistent; propList:TStrings;  AProperty: string): PPropInfo;
var
   i: integer;
   props: PPropList;
   tData: PTypeData;
begin
  {:Obtener la informaci?n de una propiedad a partir de la clase y el nombre;
  Ademas devuelve la lista de todas las propiedades de ese control.}

   // Inicial
   Result := nil;
   // No asignado el control ==> Salimos
   if (AControl = nil) or (AControl.ClassInfo = nil) then begin
    Exit;
   end;
   // Obtener la informaci?n
   tData := GetTypeData(AControl.ClassInfo);
   // Tipo desconocido o sin propiedades ==> Salimos
   if (tData = nil) or (tData^.PropCount = 0) then
   	Exit;
    GetMem(props, tData^.PropCount * SizeOf(Pointer));
   try
   	 GetPropInfos(AControl.ClassInfo, props);
      for i := 0 to tData^.PropCount - 1 do
      begin
        propList.Add(Props^[i]^.Name);
        with Props^[i]^ do begin
            if (Name = AProperty) then begin
          result := Props^[i];
          end;
              end;
      end;
   finally
      FreeMem(props);
   end;
end;


function IsEmptyOrNull(const Value: Variant): Boolean;
begin
  Result := VarIsClear(Value) or VarIsEmpty(Value) or VarIsNull(Value) or (VarCompareValue(Value, Unassigned) = vrEqual);
  if (not Result) and VarIsStr(Value) then
    Result := Value = '';
end;


procedure CargarDataSetsMain();
begin

{$IFDEF DESKTOP}
  {$IFNDEF RUCAUTOMATE}
    if DMComunGlobal = nil then
    begin
      Application.CreateForm(TDMComunGlobal, DMComunGlobal);
    end;

    if DMComunUsuario = nil then
    begin
      Application.CreateForm(TDMComunUsuario, DMComunUsuario);
    end;

    if DMComunComercial = nil then
    begin
      Application.CreateForm(TDMComunComercial, DMComunComercial);
    end;

    if DMUsuario = nil then
    begin
      Application.CreateForm(TDMUsuario, DMUsuario);
    end;

    if DMFirma = nil then
    begin
      Application.CreateForm(TDMFirma, DMFirma);
    end;
  {$ENDIF}
{$ENDIF}

{$IFDEF ALMACEN}
  ActivarDataSets('MainForm', [DMComunComercial.MSTipoCliente,
                               DMComunComercial.MSTipoCondicionPago,
                               DMComunComercial.MSGrupoProveedor,
                               DMComunComercial.MSProveedor,
                               DMComunComercial.MSGrupoCliente,
                               DMComunComercial.MSCliente,
                               DMComunComercial.MSPrecio,
                               DMComunComercial.MSPrecioIncCosto,
                               DMComunComercial.MSDefinicionEntradaNotaAdjudicacion,
                               DMComunComercial.MSCondicionPago,
                               DMComunComercial.MSTipoModoAplicarIVA
                               ]);
{$ENDIF}


  {$IF NOT (DEFINED(RUCAUTOMATE)
         OR DEFINED(DYNAMICSLINK) )}
      ActivarDataSets('MainForm', [DMUsuario.MSUsuario],False);
      // DMUsuario.OmitirEstadoControles := False;
      ActivarDataSets('MainForm', [DMUsuario.MSVerificarPermiso]);
//      DMComunUsuario.VTMenu.Active := True;
//      ActivarDataSets('MainForm', [DMUsuario.MSPermisosDisponibles,
//                                   DMFirma.MSDefinicionFirma,
//                                   DMFirma.MSDefinicionFirmaReporte]);
  {$ENDIF}

end;




procedure ActivarTablaVirtual(Lugar: string; TablaVirtual: TVirtualTable; ClearDataset: Boolean = True);
// se debe pasar el nombre del datamodule y los dataset a activar
// EJ.:   ActivarTablaVirtual(self.name,TablaVirtual);
begin
  if (TVirtualTable(TablaVirtual) is TVirtualTable) then
  begin
    try
      if not(TVirtualTable(TablaVirtual).Active) then
      begin
        TVirtualTable(TablaVirtual).Active := True;
      end;

      //  Close ,    Clear ,   Open
      TVirtualTable(TablaVirtual).Close;

      TVirtualTable(TablaVirtual).Filtered := False;
      if ClearDataset then
      begin
        TVirtualTable(TablaVirtual).Clear;
      end;

      TVirtualTable(TablaVirtual).Open;

    except
      on E: Exception do
      begin
        //Log('Error al activar Tabla-Virtual ' + TablaVirtual.Name + ' en ' +  Lugar + ' Error' + E.Message);
      end;
    end;

  end;
end;



function CompareInt(List: TStringList; Index1, Index2: Integer): Integer;
var
  d1, d2: Integer;
  r1, r2: Boolean;

  function IsInt(AString : string; var AInteger : Integer): Boolean;
  var
    Code: Integer;
  begin
    Val(AString, AInteger, Code);
    Result := (Code = 0);
  end;

begin
  r1 :=  IsInt(List[Index1], d1);
  r2 :=  IsInt(List[Index2], d2);
  Result := ord(r1 or r2);
  if Result <> 0 then
  begin
    if d1 < d2 then
      Result := -1
    else if d1 > d2 then
      Result := 1
    else
     Result := 0;
  end else
   Result := lstrcmp(PChar(List[Index1]), PChar(List[Index2]));
end;


function CompareDouble(List: TStringList; Index1, Index2: Integer): Integer;
var
  d1, d2: Double;
begin

  if List[Index1] = '' then
  begin
    d1 := -1500000000;
  end
  else
    begin
      d1 := StrToFloat(List[Index1]);
    end;

  if List[Index2] = '' then
  begin
    d2 := -1500000000;
  end
  else
    begin
      d2 := StrToFloat(List[Index2]);
    end;

  if d1 < d2 then
    Result := -1
  else if d1 > d2 then Result := 1
  else
    Result := 0;
end;


function CompareDates(List: TStringList; Index1, Index2: Integer): Integer;
var
  d1, d2: TDateTime;
begin

  if List[Index1] = '' then
  begin
    d1 := StrToDateTime('01/01/1500');
  end
  else
    begin
      d1 := StrToDateTime(List[Index1]);
    end;

  if List[Index2] = '' then
  begin
    d2 := StrToDateTime('01/01/1500');
  end
  else
    begin
      d2 := StrToDateTime(List[Index2]);
    end;

  if d1 < d2 then
  begin
    Result := -1
  end
  else
    begin
      if d1 > d2 then
      begin
        Result := 1
      end
      else
        begin
          Result := 0;
        end;
    end;
end;


function CompareString(List : TStringList; Index1, Index2 : integer) : integer;
begin
  Result := AnsiCompareText(List.Names[Index1], List.Names[Index2]);
  // If you want to sort equal strings then on the Values
  if Result = 0 then Result := AnsiCompareText(List.ValueFromIndex[Index1], List.ValueFromIndex[Index2]);
  // Or if you want to keep the original order
  if Result = 0 then Result := integer(List.Objects[Index1])-integer(List.Objects[Index2]);
end;
{$ENDREGION}



{$IFDEF DESKTOP}
procedure CargarCombo(Combo: TcxComboBox; Campo: TField);
begin
  Combo.Properties.Items.Clear;

  // Muevo al primer registro
  ActivarDataSets('CargarCombo' , [Campo.DataSet]);

  // Cargo al combo los items
  if not(Campo.DataSet.IsEmpty) then
  begin
    Campo.DataSet.First;
    while not(Campo.DataSet.Eof) do
    begin
      Combo.Properties.Items.Add(Campo.Value);
      Campo.DataSet.Next;
    end;
  end
  else
  begin
    Combo.Properties.Items.Add('');
  end;

  // Seleccion el primer registro
  Combo.ItemIndex := 0;

end;
{$ENDIF}



function HextoInt(HexStr:string):integer;
const Hex : array['A'..'F'] of integer = (10,11,12,13,14,15);
var
  i: integer;
begin

   Result:=0;
   for i := 1 to Length(HexStr) do
     if HexStr[i] < 'A' then Result := Result * 16 + Ord(HexStr[i]) - 48
                        else Result := Result * 16 + Hex[HexStr[i]];
end;



function ObtenerCampoEntreCaracter(Tabla : TDataSet; Campo : TField ; Caracter : String = ','): string;
     {se le pasa la tabla y el campo,
    devuelde los campos entre comas para usar en la consulta  In (xxx,xxx,xxx)
    ej : ObtenerDatosTabla(VTRevaluoDepreciacionRotulado, VTRevaluoDepreciacionRotuladoIdBienDetalle);
    se envia en caracter si se quiere entre comas ',' o barra '/'
    }
begin
    ActivarDataSets('ObtenerCampoEntreCaracter' , [Tabla] , False);

    Tabla.DisableControls;

    Tabla.First;

    while not(Tabla.Eof) do
    begin
      // la lista va entre comas, verifico si es el ultimo registro,
      // esto es para evitar que agregue la coma final al string
      if Tabla.RecNo = Tabla.RecordCount then
      begin
        Result := Result + Campo.AsString;
      end
      else
      begin
        Result := Result + Campo.AsString + Caracter;
      end;

      Tabla.Next;
    end;

    Tabla.EnableControls;

end;



function ObtenerSumatoriaCampo(Tabla: TDataSet; Campo: TField): string;
var
    i: integer;
    sumatoria: Currency;
    sumatoriaStr: String;
begin
    try
      sumatoria := 0;
      Tabla.DisableControls;

      Tabla.First;
      while not(Tabla.Eof) do
      begin
        //si no es nulo suma
        if not( Tabla.FieldByName(Campo.FieldName).IsNull) then
        begin
          sumatoria := sumatoria + Tabla.FieldByName(Campo.FieldName).Value;
        end;
        Tabla.Next;
      end;
      Tabla.EnableControls;
      sumatoriaStr := Format('%2.0n', [(sumatoria) + 0.0]);
      Result := sumatoriaStr;
    except
      on E: Exception do
      begin
      //  Log('ObtenerSumatoriaCampo ' + E.Message);
      end;

    end;
end;


procedure CopiarCamposDataSetAVirtualTable(DataSet: TDataset; VirtualTable: TDataset);
var
  x: integer;
begin

  try

    TVirtualTable(VirtualTable).Close;
    TVirtualTable(VirtualTable).Clear;
    TVirtualTable(VirtualTable).Open;

    if DataSet.Active = False then DataSet.Open;


    for X := 0 to DataSet.FieldCount -1 do
    begin

      with VirtualTable.FieldDefs do
      begin

        with AddFieldDef do
        begin
          Name     := DataSet.Fields[x].FieldName;
          DataType := DataSet.Fields[x].DataType;
          Size     := DataSet.Fields[x].Size;
          DisplayName := DataSet.Fields[x].FieldName;
        end;

      end;
    end;

    VirtualTable.Filtered := False;
    VirtualTable.Close;
    VirtualTable.Open;

  except // En caso que ocurra una exepcion
    on E: Exception do
    begin
      // Cargo la excepcion al log
     // Log(EExcepcion+ 'CopiarDataSetAVirtualTable: ' + e.Message );
      abort;
    end;
  end;
end;


procedure CopiarDataSetAVirtualTable(DataSet: TDataset; VirtualTable: TDataset; HacerClear: Boolean = True; CopiarCampos: Boolean = False);
var
  x: integer;
begin

  try

    TVirtualTable(VirtualTable).Close;

    if (HacerClear) then
    begin
      TVirtualTable(VirtualTable).Clear;
    end;

    TVirtualTable(VirtualTable).Open;

    if DataSet.Active = False then DataSet.Open;

    // Deshabilito los controles
    DataSet.DisableControls;

    DataSet.First;

    while not(DataSet.Eof) do
    begin
      VirtualTable.Append;

      //verifica que existan los campos
      For X := 0 to DataSet.FieldCount -1 do
      begin

        if ( VirtualTable.FindField(DataSet.Fields[x].FieldName) <> nil ) then
        begin

          VirtualTable.FieldByName(DataSet.Fields[x].FieldName).Value :=  DataSet.Fields[x].Value;

        end;

      end;
      VirtualTable.Post;

      DataSet.Next;
    end;

    // Rehabilito los controles
    DataSet.EnableControls;

    VirtualTable.Close;
    VirtualTable.Open;

  except // En caso que ocurra una exepcion
    on E: Exception do
    begin
      // Cargo la excepcion al log
      //Log(EExcepcion+ 'CopiarDataSetAVirtualTable: ' + e.Message );
      abort;
    end;
  end;
end;


{$IFDEF WEB}
procedure CambiarEstadosCheckBox(CheckBoxes: array of TUniCheckBox; Marcado: Boolean = True; Encendido: Boolean = True);
var
i: integer;
begin
  for i := 0 to Length(CheckBoxes)-1 do
    begin
      CheckBoxes[i].Checked := Marcado;
      CheckBoxes[i].Enabled := Encendido;
    end;

end;



procedure CargarLiveCombo(Combo: TUniComboBox; Query: TMSQuery; NombreParametroSTR, NombreParametroID: string; ParametroId: Integer=0; ParametroTexto: string=''; Result: TStrings=nil; DesdeComa: Boolean = False);
// CargarLiveCombo(cboLivePrograma, DMPrograma.MSLivePrograma, 'Descripcion', 'IdPrograma',0, QueryString, Result);
var
position: Integer;
begin
  if DesdeComa then
    begin
      ParametroTexto := ReverseString(ParametroTexto);
      position := ansipos(',', ParametroTexto);
      if position = 0 then
        begin
          ParametroTexto := ReverseString(ParametroTexto);
        end
        else
        begin
          ParametroTexto := copy(ParametroTexto, 1, position-1);
          ParametroTexto := ReverseString(ParametroTexto);
        end;
    end;


  Combo.Clear;

  Query.Close;

  Query.ParamByName(NombreParametroSTR).Value := ParametroTexto;

  if NombreParametroID<>'' then
    begin
      Query.ParamByName(NombreParametroID).Value := ParametroId;
        if ParametroId = 0 then
          Query.ParamByName(NombreParametroID).Clear;
    end;

  if ParametroTexto = '' then
    Query.ParamByName(NombreParametroSTR).Clear;

  Query.Open;

  if Query.RecordCount>0 then
    begin
      Query.First;
      while not Query.Eof do
        begin
          if Result = nil then
            begin
              Combo.Items.Add(Query.FieldByName(NombreParametroSTR).AsString);
            end
            else
            begin
              Result.Add(Query.FieldByName(NombreParametroSTR).AsString);
            end;

          Query.Next;
        end;
      end;

  if ParametroTexto = '' then
    Combo.Text :=  Query.FieldByName(NombreParametroSTR).AsString;
end;
{$ENDIF}



{$IFDEF WEB}
procedure CargarCombo(Combo: TUniComboBox; Campo: TField);
begin
  // Limpio el combo
  Combo.Items.Clear;

  // Deshabilito la actualizacion de controles, para que sea mas rapido
  Campo.DataSet.DisableControls;

  //
  ActivarDataSets('CargarCombo', [Campo.DataSet]);
  // Muevo al ultimo registro
  Campo.DataSet.First;

  // Cargo al combo los items
  while Campo.DataSet.Eof = False do
  begin
    Combo.Items.Add(Campo.Value);
    Campo.DataSet.Next;
  end;

  // Muevo al primer registro
  Campo.DataSet.First;

  // Rehabilito la actualizacion de controles
  Campo.DataSet.EnableControls;

  // Seleccion el primer registro
  Combo.ItemIndex := 0;
end;


procedure CargarCombo(Combo: TUniComboBox; Campo: TField ; Organigrama: string );
var
    varORga : string;
begin
  varORga :=  Campo.AsString;

  Organigrama :=  TrimLeft(TrimRight(Copy(Organigrama, 0, (Pos('+',Organigrama)-2))));
  // Limpio el combo
  Combo.Items.Clear;

  // Deshabilito la actualizacion de controles, para que sea mas rapido
  Campo.DataSet.DisableControls;

  //
  ActivarDataSets('CargarCombo', [Campo.DataSet],True);

  // Muevo al ultimo registro
  Campo.DataSet.First;

  // Cargo al combo los items
  while Campo.DataSet.Eof = False do
  begin
    Combo.Items.Add(Campo.Value);
    Campo.DataSet.Next;
  end;

  // Muevo al primer registro
  Campo.DataSet.First;

  // Rehabilito la actualizacion de controles
  Campo.DataSet.EnableControls;

  // Selecciono el organigrama que estoy utilizando
  if (Combo.Items.IndexOf(Organigrama) = -1) then
  begin
    Combo.ItemIndex := Combo.Items.IndexOf(varORga);
  end
  else
  begin
    Combo.ItemIndex := Combo.Items.IndexOf(Organigrama);
  end;
end;


{$ENDIF}


function DiasHabiles(const FechaInicial, FechaFinal: TDateTime): Integer;
var
  CurrDate: TDateTime;
  StartDate, EndDate: TDateTime;
begin
  // Obtiene la cantidad de dias habiles entre dos fechas
  // Falta descontar si hay feriados
  if FechaFinal > FechaInicial then
  begin
    StartDate := FechaInicial;
    EndDate := FechaFinal;
  end
  else
    begin
      StartDate := FechaFinal;
      EndDate := FechaInicial;
    end;

  CurrDate := StartDate;
  Result := 0;

  while (CurrDate <= EndDate) do
  begin
    if DayOfTheWeek(CurrDate) < 6 then
      Inc(Result);
    CurrDate := CurrDate + 1;
  end;
end;


function DiasHabiles(const FechaInicial: TDateTime; CantidadDias: Integer): TDateTime;
var
  i: integer;
begin

  Result := FechaInicial;

  for i := 0 to CantidadDias - 1 do
  begin
    if DayOfWeek(Result) in [2, 3, 4, 5, 6] then
    begin
      Result := IncDay(Result, 1);
    end;
  end;

end;

{ TEnumUtils }

// Convierto un string a un enumerado, utilizando clase generics
class function TEnumUtils.GetAs<T>(pValor: String): T;
var
  Tipo: PTypeInfo;
  Temp: Integer;
  PTemp: Pointer;
begin
   Tipo := TypeInfo(T);
   Temp := GetEnumValue(Tipo, pValor);
   PTemp := @Temp;
   Result := T(PTemp^);
end;


// Convierto un enumerado a un string
class function TEnumUtils.EnumToString<T>(enValue: T): string;
begin
  Result := GetEnumName(TypeInfo(T), EnumToInt(enValue));
end;


class function TEnumUtils.EnumToInt<T>(const enValue: T): Integer;
begin
   Result := 0;
   Move(enValue, Result, sizeOf(enValue));
end;

function ObtenerFecha: String;
var
  anho, mes, dia, hora, minuto, segundo, ms: word;
begin
  // Mover esto a codigos comunes
  DecodeDate(Now, anho, mes, dia);
  DecodeTime(Now, hora, minuto, segundo, ms);
  Result := IntToStr(anho) + IntToStr(mes) + IntToStr(dia) + '-' + IntToStr(Hora) + IntToStr(Minuto) + IntToStr(Segundo);
end;


end.
