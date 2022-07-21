unit UnitMenuEventos;

{$INCLUDE 'compilador.inc'}

interface

uses
  Vcl.StdCtrls, System.Classes, System.SysUtils, System.IniFiles,
  System.MaskUtils, System.Variants, Vcl.Forms, Winapi.Windows,
  System.DateUtils, uniGUITypes, uniGUIAbstractClasses, uniPanel,
  uniGUIClasses, uniGUIForm, Vcl.Dialogs, uniMainMenu,
  uniComboBox, uniLabel, Vcl.Controls, System.Rtti, System.TypInfo,
  Vcl.Graphics, uniTreeMenu, System.IOUtils, System.StrUtils;

const

  {$IF DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE) OR
       DEFINED(AUTOSERVICIOWEB)}
  TipoComponenteMenu = 'MenuPanel';
  {$ELSE}
  TipoComponenteMenu = 'Menu';
  {$ENDIF}

type
  TInteger=NativeInt;

  TNode<T>=class
  public
  type
    // <0 : A<B
    //  0 : A=B
    // >0 : A>B
    TCompareProc=reference to function(const A,B:TNode<T>):Integer;

  private
  type
    TTypeItem=TNode<T>;

  var
    FItems : TArray<TNode<T>>;

    {$IFDEF AUTOREFCOUNT}[Weak]{$ENDIF}
    FParent : TNode<T>;

    procedure Adopt(const Item:TNode<T>);
    procedure Extract(const Index: TInteger; const ACount: TInteger=1);
    function Get(const Index:TInteger):TNode<T>; inline;
    function GetIndex:TInteger;
    function GetLevel:TInteger;
    function ItemsCopy:TArray<TNode<T>>;
    procedure Orphan;
    procedure PrivateSort(const ACompare: TCompareProc; const l,r:TInteger);
    procedure SetParent(const Value:TNode<T>);
  public
  type
    TNodeProc=reference to procedure(const Item:TNode<T>);

  var
    Data : T;

    Constructor Create(const AData:T); overload;
    Destructor Destroy; override;

    function Add(const AData:T):TNode<T>;
    procedure Clear; inline;
    function Count:TInteger; inline;
    function Empty:Boolean; inline;
    procedure Exchange(const Index1,Index2:TInteger);
    procedure Delete(const Index:TInteger; const ACount:TInteger=1);
    procedure ForEach(const AProc:TNodeProc; const Recursive:Boolean=True);
    procedure Sort(const ACompare:TCompareProc; const Recursive:Boolean=True);

    property Index:TInteger read GetIndex;
    property Item[const Index:TInteger]:TNode<T> read Get; default;
    property Items:TArray<TNode<T>> read FItems;
    property Level:TInteger read GetLevel;
    property Parent:TNode<T> read FParent write SetParent;
  end;



type
  TMenuItemRecord = record
    MenuItem: TUniMenuItem;
    ObjetoComponente: string;
    SoportaTipoAcceso: Boolean;
    Caption: string;
    OmitirPermiso: Boolean;
    Permitido: Boolean;
    Control: Boolean;
  end;

var
  Arbol: TNode<TMenuItemRecord>;

  procedure CargarMenuEstandar(Menu: TUniMenuItem; Padre: TUniMenuItem = nil);

  procedure CargarMenuControles;
  procedure AgregarMenuControl(MenuPadre: string; NombreControl: string);

  procedure OcultarMenuSinAcceso;
  procedure OcultarUnMenu(TreeMenu: TUniTreeMenu; Menu: TUniMenuItems; Indice: Integer);

  procedure procMenuHerramientasOrganizacion;
  procedure procMenuHerramientasUsuarios;

  procedure OcultarLineaMenus(Menu: TUniMainMenu);
  procedure MostrarTodosMenus(Menu: TUniMainMenu);

  procedure CargarLogotipoFondo;
  procedure CargarBienvenida;


implementation

uses
  DataModuleUsuario, FormularioOrganizacion, FormularioUsuario, Main,
  UnitCodigosComunesString, DataModulePrincipal, UnitVerificarModulo,
  UnitArchivos,
  // FormularioInicioLogotipo,
   UnitEncriptacion,
  //FormularioInicioBienvenido,
   UnitCodigosComunesFormulario, SCrypt;


{ TNode<T> }

// Creates a new Node
Constructor TNode<T>.Create(const AData: T);
begin
  inherited Create;
  Data:=AData;
end;

// Remove and destroy all children nodes, then remove Self from Parent
Destructor TNode<T>.Destroy;
begin
  Clear;
  Orphan;
  inherited;
end;

// Returns children node at Index position
function TNode<T>.Get(const Index: TInteger): TNode<T>;
begin
  result:=FItems[Index];
end;

// Returns the number of children nodes
function TNode<T>.Count: TInteger;
begin
  result:=Length(FItems);
end;

// Adds a new node and sets its AData
function TNode<T>.Add(const AData: T): TNode<T>;
begin
  result:=TNode<T>.Create(AData);
  Adopt(result);
end;

// Remove and destroy all children nodes
procedure TNode<T>.Clear;
begin
  Delete(0,Count);
  FItems:=nil;
end;

// Removes ACount items from the array, starting at Index position (without destroying them)
procedure TNode<T>.Extract(const Index, ACount: TInteger);
{$IF CompilerVersion<=28}
var t : TInteger;
{$ENDIF}
begin
  {$IF CompilerVersion>28}
  System.Delete(FItems,Index,ACount);
  {$ELSE}
  t:=Count-ACount;

  if t-Index>0 then
     System.Move(FItems[Index+ACount],FItems[Index],SizeOf(TObject)*(t-Index));

  SetLength(FItems,t);
  {$IFEND}
end;

// Removes and destroys children nodes from Index position (ACount default = 1)
procedure TNode<T>.Delete(const Index, ACount: TInteger);
var t : TInteger;
begin
  // Destroy nodes
  for t:=Index to Index+ACount-1 do
  begin
    FItems[t].FParent:=nil;
    FItems[t].Free;
  end;

  Extract(Index,ACount);
end;

// Returns True when this node has no children nodes
function TNode<T>.Empty:Boolean;
begin
  result:=Count=0;
end;

// Swap children nodes at positions: Index1 <---> Index2
procedure TNode<T>.Exchange(const Index1, Index2: TInteger);
var tmp : TNode<T>;
begin
  tmp:=FItems[Index1];
  FItems[Index1]:=FItems[Index2];
  FItems[Index2]:=tmp;
end;

function TNode<T>.ItemsCopy:TArray<TNode<T>>;
var t : TInteger;
begin
  SetLength(result,Count);

  for t:=0 to Count-1 do
      result[t]:=FItems[t];
end;

// Calls AProc for each children node (optionally recursive)
procedure TNode<T>.ForEach(const AProc: TNodeProc; const Recursive: Boolean);
var t : TInteger;
    N : TTypeItem;
    tmp : TArray<TTypeItem>;
begin
  tmp:=ItemsCopy;

  t:=0;

  while t<Length(tmp) do
  begin
    N:=tmp[t];

    if N<>nil then
    begin
      AProc(N);

      if Recursive then
         N.ForEach(AProc);
    end;

    Inc(t);
  end;
end;

// Returns the Index position of Self in Parent children list
function TNode<T>.GetIndex: TInteger;
var t : TInteger;
begin
  if FParent<>nil then
     for t:=0 to FParent.Count-1 do
         if FParent[t]=Self then
            Exit(t);

  result:=-1;
end;

// Returns the number of parents in the hierarchy up to top of tree
function TNode<T>.GetLevel: TInteger;
begin
  if FParent=nil then
     result:=0
  else
     result:=FParent.Level+1;
end;

// Adds Item to children list, sets Item Parent = Self
procedure TNode<T>.Adopt(const Item: TNode<T>);
var
  l: TInteger;
begin
  Item.FParent := Self;

  // Pending: Capacity
  l := Count;
  SetLength(FItems, l + 1);
  FItems[l] := Item;
end;

// Removes itself from Parent children list
procedure TNode<T>.Orphan;
begin
  if FParent<>nil then
     FParent.Extract(Index);
end;

// Sets or changes the Parent node of Self
procedure TNode<T>.SetParent(const Value: TNode<T>);
begin
  if FParent<>Value then
  begin
    Orphan;

    FParent:=Value;

    if FParent<>nil then
       FParent.Adopt(Self);
  end;
end;

// Internal. Re-order nodes using QuickSort algorithm
procedure TNode<T>.PrivateSort(const ACompare: TCompareProc;
  const l, r: TInteger);
var
  i: TInteger;
  j: TInteger;
  x: TInteger;
begin
  i := l;
  j := r;
  x := (i + j) shr 1;

  while i < j do
  begin
    while ACompare(Self[x], Self[i]) > 0 do
      Inc(i);
    while ACompare(Self[x], Self[j]) < 0 do
      dec(j);

    if i < j then
    begin
      Exchange(i, j);

      if i = x then
        x := j
      else if j = x then
        x := i;
    end;

    if i <= j then
    begin
      Inc(i);
      dec(j)
    end;
  end;

  if l < j then
    PrivateSort(ACompare, l, j);

  if i < r then
    PrivateSort(ACompare, i, r);
end;

// Re-order children items according to a custom ACompare function
procedure TNode<T>.Sort(const ACompare: TCompareProc; const Recursive: Boolean);
var t : TInteger;
begin
  if Count>1 then
  begin
    PrivateSort(ACompare,0,Count-1);

    // Optionally, re-order all children-children... nodes
    if Recursive then
       for t:=0 to Count-1 do
           Items[t].Sort(ACompare,Recursive);
  end;
end;



procedure CargarMenuEstandar(Menu: TUniMenuItem; Padre: TUniMenuItem = nil);
var
  i: Integer;
  AuxMenu: TMenuItemRecord;
begin
  // Para cada elemento del menu
  for i := 0 To (Menu.Count - 1) Do
  begin
    // Verifico si se trata de un menu con tag que soporta permiso
    if Menu.Items[i].Tag <> 1 then
    begin

      // Verifico si el caption no se trata de una linea
      if not( AnsiStartsStr('-', Menu.Items[i].Caption) ) then
      begin

        // Cargo el menu auxiliar
        AuxMenu.MenuItem := Menu.Items[i];
        AuxMenu.ObjetoComponente := Menu.Items[i].Name;
        AuxMenu.Caption := Menu.Items[i].Caption;
        AuxMenu.Permitido := False;
        AuxMenu.OmitirPermiso := False;
        AuxMenu.Control := False;

        // Dependiendo si el menu soporta tipos de accesos
        if Menu.Items[i].Tag = 2 then
        begin
          AuxMenu.SoportaTipoAcceso := True;
        end
        else
          begin
            // En caso contrario, no lo soporta
            AuxMenu.SoportaTipoAcceso := False;
          end;

        // Si no tiene un padre, se trata de un menu principal
        if Padre <> nil then
        begin

          // Si tiene padre, recorro el arbol, y lo busco
          Arbol.ForEach(
            procedure(const Item: TNode<TMenuItemRecord>)
            begin
              // Cuando lo encuentro, lo agrego
              if Item.Data.MenuItem.Name = Padre.Name then
              begin
                // Item.Parent.Add(AuxMenu);
                Item.Add(AuxMenu);
              end
              else
              begin
                // Si no salgo del ciclo
                Exit;
              end;

            end);

        end
        else
          begin
            Arbol.Add(AuxMenu);
          end;

      end;
    end;

    // Llamada recursiva para los submenus
    if Menu.Items[i].Count > 0 Then
    begin
      // Ahora indico que tendra padre
      CargarMenuEstandar(Menu.Items[i], Menu.Items[i]);
    end;
  End;

end;


procedure CargarMenuControles;
//validar Boton
//// Ejemplo
//  DMUsuario.VerificarPrivilegios(Self.Name + '.' + TUniButton(Sender).Name);
begin
{$IFDEF PATRIMONIO}
  //Frm MovimientoBien Multiple
  AgregarMenuControl('mnuOperacionesMovimientoBienesMultiple', 'FrmMovimientoBienMultiple.btnEnviarBaja');
  AgregarMenuControl('mnuOperacionesMovimientoBienesMultiple', 'FrmMovimientoBienMultiple.btnDesfiniquitar');

  // Frm MovimientoBien
  AgregarMenuControl('mnuOperacionesMovimientoBienes', 'FrmMovimientoBien.btnFiniquitar');
  AgregarMenuControl('mnuOperacionesMovimientoBienes', 'FrmMovimientoBien.btnDesfiniquitar');
  AgregarMenuControl('mnuOperacionesMovimientoBienes', 'FrmMovimientoBien.btnActualizarTraspasoBien');

  // Frm Alta
  AgregarMenuControl('mnuOperacionesAltaBienes', 'FrmAlta.btnAdicional');

  // Frm Donacion
  AgregarMenuControl('mnuOperacionesDonacionBienes', 'FrmDonacion.btnAdicional');

  // Frm Compra
  AgregarMenuControl('mnuOperacionesCompraBienes', 'FrmCompra.btnAdicional');

  //Frm FC11
  AgregarMenuControl('mnuOperacionesMovimientoInternoBienesFC11', 'FrmFC11.btnDesfiniquitar');

    // Cargo los datos en el array de permisos
  AgregarMenuControl('mnuFicherosConsultaBien', 'FrmConsultaBienGeneral.BuscadorExtendido');
  AgregarMenuControl('mnuFicherosConsultaBien', 'FrmConsultaBienGeneral.GrillaColumnasAdicionales');

  //SICO
  AgregarMenuControl('mnuFicherosSICOExtenso', 'FrmSICOFicheroExtenso.btnInfomeSicoAvanceUsuario');

  //FrmBien
  AgregarMenuControl('mnuFicherosBienes', 'FrmBien.btnEliminarAlta');
  AgregarMenuControl('mnuFicherosBienes', 'FrmBien.btnEditarDetalle');

  //FrmBienDetalle
  AgregarMenuControl('mnuFicherosBienes', 'FrmBienDetalle.btnDescargarEjemploHacienda');
  AgregarMenuControl('mnuFicherosBienes', 'FrmBienDetalle.btnProcesar');
  AgregarMenuControl('mnuFicherosBienes', 'FrmBienDetalle.btnAgregar');
  AgregarMenuControl('mnuFicherosBienes', 'FrmBienDetalle.btnEditar');
  AgregarMenuControl('mnuFicherosBienes', 'FrmBienDetalle.btnEliminar');

    //Frm Adquisicion
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnDesfiniquitar');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnRotuladoGeneracionFC04');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.AjustarVentanaPantallaCompleta');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnFicheroBien');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnMovimientoBien');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnEliminarRotuladoUno');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnEliminarRotuladoTodo');
  AgregarMenuControl('mnuOperacionesAdquisicionBienes', 'FrmAdquisicion.btnEliminarRotuladoMBU');

  // Procesar invenario
  AgregarMenuControl('mnuOperacionesInventarioFisico', 'FrmInventarioFisicoBien.btnProcesar');

{$ENDIF}

  // Creo los menus personalizados
{$IFDEF NOMINA}
  // FrmAsignacionPlanFinancieroSTR
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnLiberarNT');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnLiberarPlanilla');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.lblEjecutarPlanFinanciero');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnAsignarSTR');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnEjecutar');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnEstadoPlanilla');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnLimpiarSTR');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendido.btnLiberarPersona');

  // FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes.btnLiberarLinea');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes.lnkCambiarIVA');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes.lnkTransferirPlanActual');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes.lnkCambiarFuente');
  AgregarMenuControl('mnuOperacionesPlanFinancieroAsignacionPlanFinancieroSTR', 'FrmAsignacionPlanFinancieroSTRExtendidoPorPlanes.lnkSepararPendientes');

  //FrmFicherorenovacion de contratos
  AgregarMenuControl('mnuFicheroRenovacion', 'FrmFicheroTmpContrato.btneliminar');

  ///////////////////////  FrmPersonal
  // TabFuncion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFuncion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFuncion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFuncion.BtnNuevo');
  // tabDireccion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDireccion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDireccion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDireccion.BtnNuevo');
  // tabComunicacion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabComunicacion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabComunicacion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabComunicacion.BtnNuevo');
  // tabGrupoFamiliar
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabGrupoFamiliar.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabGrupoFamiliar.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabGrupoFamiliar.BtnNuevo');
  // tabAutorizaciones
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabAutorizaciones.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabAutorizaciones.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabAutorizaciones.BtnNuevo');
  // tabHorario
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabHorario.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabHorario.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabHorario.BtnNuevo');
  // tabRemuneracion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabRemuneracion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabRemuneracion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabRemuneracion.BtnNuevo');
  // tabFormacion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFormacion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFormacion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabFormacion.BtnNuevo');
  // tabLaboral
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabLaboral.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabLaboral.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabLaboral.BtnNuevo');
  // tabDocumento
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDocumento.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDocumento.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabDocumento.BtnNuevo');
 // tabCuentaBancaria
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCuentaBancaria.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCuentaBancaria.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCuentaBancaria.BtnNuevo');
  // tabCapacitacion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCapacitacion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCapacitacion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabCapacitacion.BtnNuevo');
  // tabMovimiento
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabMovimiento.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabMovimiento.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabMovimiento.BtnNuevo');


  // becas
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabBecas.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabBecas.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.tabBecas.BtnNuevo');

  //Ajustar Ventana Pantalla Completa      mnuHerramientaDatosPersonales
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.AjustarVentanaPantallaCompleta');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.mnuHerramientaDatosPersonales');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonal.mnuOperacionesRelevamientosCargaMasivaDocumentos');


  ///////////////////////  FrmPersonal Funcion
  //tabBonificacion
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabBonificacion.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabBonificacion.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabBonificacion.BtnNuevo');

  //tabCategoria
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabCategoria.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabCategoria.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabCategoria.BtnNuevo');

  //tabContrato
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabContrato.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabContrato.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabContrato.BtnNuevo');

  //tabHistorico--cambio de unidad presupuestaria
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabHistorico.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabHistorico.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabHistorico.BtnNuevo');

   //tabDescuento
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabDescuento.btnBorrar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabDescuento.btnEditar');
  AgregarMenuControl('mnuFicherosLegajos', 'FrmPersonalFuncion.tabDescuento.BtnNuevo');

  //Asistencia Hora Extras
  AgregarMenuControl('mnuFicherosAsistenciaHoraExtra', 'FrmAsistenciaHoraExtra.chkAgregarNomina');
  AgregarMenuControl('mnuFicherosAsistenciaHoraExtra', 'FrmAsistenciaHoraExtra.btnGenerarRERA');

  //Frm Consulta Hora Extra
  AgregarMenuControl('mnuFicherosAsistenciaConsultaHorasExtras', 'FrmConsultaHoraExtra.mnuEnviarAPago');
  AgregarMenuControl('mnuFicherosAsistenciaConsultaHorasExtras', 'FrmConsultaHoraExtra.mnuPpHorasExtrasEliminarTodos');

  //Consulta Autorizacion Remuneracion
  AgregarMenuControl('mnuFicherosAsistenciaConsultaAutorizacionRemuneracion', 'FrmConsultaAutorizacionRemuneracion.btnGenerarAutorizacion');

  //Multas
  AgregarMenuControl('mnuFicherosMultaMultas', 'FrmMultas.chkAgregarNomina');
  AgregarMenuControl('mnuOperacionesMultasGenerarMultas', 'FrmGenerarMultas.mnuActualizarDesdeExcel');

  //Categoria
  AgregarMenuControl('mnuDefinicionesCategoriaFichero', 'FrmCategoriaNomina.btnCopiarAnexoSgtAno');

  // FrmNomina
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnAgregarDetalle');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnDuplicarDetalle');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnEntradaEditarDetalle');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnEntradaBorrarDetalle');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnJubilacion');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnIPS');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnIVA10');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnIVA3');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnRE');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnAgregarSeguroMedico');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnFiniquitar');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnDesfiniquitar');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNominaDetalle.lnkAvanzadas');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.btnAvanzadas');
  AgregarMenuControl('mnuOperacionesLiquidacionesSalario', 'FrmNomina.chkExcluirDescuentos');

  // FrmDescuentoJudicial
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnJudicialesAgregarDetalle');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnJudicialesEditarDetalle');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnJudicialesEliminarDetalle');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.lnkGenerarDetalles');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnImprimir');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnFiniquitar');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnDesfiniquitar');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnCancelar');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnPendiente');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnEdicionMasiva');
  AgregarMenuControl('mnuOperacionesJudicialesFichero', 'FrmDescuentoJudicial.btnInsertarJudicialNOMINAsalario');

  // FrmCrudos
  AgregarMenuControl('mnuOperacionesComplementos', 'FrmCrudos.btnCrudoEliminarDetalle');

  // FrmGenerarNotaTransferencia
  AgregarMenuControl('mnuOperacionesGenerarNotaTransferencia', 'FrmGenerarNotaTransferencia.btnEliminarNT');
  AgregarMenuControl('mnuOperacionesGenerarNotaTransferencia', 'FrmGenerarNotaTransferencia.btnRevertirNT');
  AgregarMenuControl('mnuOperacionesGenerarNotaTransferencia', 'FrmGenerarNotaTransferencia.btnRectificarNT');

  // FrmGenerarNomina
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomina.btnGenerar');
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomiFrmDescuentoJudicialna.btnBorradoDescuento');
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomina.btnBorradoDescuento');
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomina.mnuRetenciones');
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomina.mnuDescuento');
  AgregarMenuControl('mnuOperacionesGenerarLiquidaciones', 'FrmGenerarNomina.mnuGenerarImportarPagoLote');

  //FrmConsultaAsistenciaBorrar
  AgregarMenuControl('mnuOperacionesAsistenciaConsultaAsistenciaBorrar', 'FrmConsultaAsistenciaBorrar.mnuBorrarMarcacion');
  AgregarMenuControl('mnuOperacionesAsistenciaConsultaAsistenciaBorrar', 'FrmConsultaAsistenciaBorrar.mnuBorrartodaslasmarcaciones');

  //Cheque
  AgregarMenuControl('mnuOperacionesCheques', 'FrmExtraccionCuentaCorriente.BtnEliminar');
  // Chequera (eta en ficheros), el nombre esta mal
  AgregarMenuControl('mnuOperacionChequeras', 'FrmChequera.BtnEliminar');

  //capacitacion
  AgregarMenuControl('mnuOperacionesCapacitacionFichero', 'FrmCapacitacion.btnProcesar');

  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnConsultar');
  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnPresupuesto');
  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnTesoreria');
  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnSecretaria');

  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnCargarResolucion');
  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnActualizarPago');
  AgregarMenuControl('mnuOperacionesCapacitacionConsultaCapacitacion', 'FrmConsultaCapacitacion.btnAsignarConcepto');

  // constancia
  AgregarMenuControl('mnuConstanciaLaboral', 'FrmConstanciaLaboral.btnEmisionManual');

  //FrmFicheroViatico
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.btnFiniquitarIndividual');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.btnFiniquitarLegajoNro');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.mnuGrillaEliminarViatico');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.btnFiniquitarTodos');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.btnPendiente');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.btnCancelado');
  AgregarMenuControl('mnuFicherosViaticosFichero', 'FrmFicheroViatico.mnuActualizarDuplicados');

  //fichero contrato
  AgregarMenuControl('mnuFicheroContratosGeneral', 'FrmFicheroContrato_v2.mnuInsertarLiquidacin');
  AgregarMenuControl('mnuFicheroContratosGeneral', 'FrmFicheroContrato_v2.mnuCorregirLinea');
  AgregarMenuControl('mnuFicheroContratosGeneral', 'FrmFicheroContrato_v2.mnuCorregirLineaImputado');

  AgregarMenuControl('mnuFicheroContratosGeneral', 'FrmFicheroContrato.mnuDescargarArchivo');
  AgregarMenuControl('mnuFicheroContratosGeneral', 'FrmFicheroContrato.btnArchivar');

  //certificado Trabajo
  AgregarMenuControl('mnuOperacionesCertificadoTrabajo', 'FrmCertificadoTrabajo.btnImprimir');
  AgregarMenuControl('mnuOperacionesCertificadoTrabajo', 'FrmCertificadoTrabajo.btnEliminar');

  // Descuento Personal
  AgregarMenuControl('mnuOperacionesDescuentosDescuentoEntidades', 'FrmDescuentoEntidades.btnAsignarStrNro');
  AgregarMenuControl('mnuOperacionesDescuentosDescuentoEntidades', 'FrmDescuentoEntidades.mnuModificarGrupoConcepto');

  AgregarMenuControl('mnuFicheroRetencionIVA', 'FrmRetencionIVA.btnProcesar');

  // Sincronizar datos
  AgregarMenuControl('mnuOperacionesSincronizarDatos', 'FrmBiometricoSincronizarDatos.mnuOtrasTareasOpcionesAvanzadas');
  AgregarMenuControl('mnuOperacionesSincronizarDatos', 'FrmBiometricoSincronizarDatos.mnuOtrasTareasRecolectarRostro');
  AgregarMenuControl('mnuOperacionesSincronizarDatos', 'FrmBiometricoSincronizarDatos.mnuOtrasTareasRecolectarHuella');


{$ENDIF}


  //DocumentalLite
{$IFDEF DOCUMENTALLITE}

  //NuevoExpediente
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumento_v2.DocumentoEditar');
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumento_v2.DocumentoEliminar');
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumento_v2.btnConsultor');
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumentoMovimiento.btnFiniquitarMovimiento');
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumentoMovimiento.btnArchivoFisico');
  AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumento_v2.mnuHistoricoImpresion');

  //DefinicionesOrganigrama
  AgregarMenuControl('mnuPanelDefinicionesOrganigrama', 'FrmVistaGrillaOrganigrama.btnIraFicha');
  AgregarMenuControl('mnuPanelDefinicionesOrganigrama', 'FrmVistaGrillaOrganigrama.btnAsignarUsuario');
  AgregarMenuControl('mnuPanelDefinicionesOrganigrama', 'FrmVistaGrillaOrganigrama.btnUsuarioRama');
  AgregarMenuControl('mnuPanelDefinicionesOrganigrama', 'FrmVistaGrillaOrganigrama.btnCopiarOrganigramaUsuario');

  //mnuHistoricoImpresion
{$ENDIF}

  //  RAPY
{$IFDEF RAPY}
  AgregarMenuControl('mnuListadoExmenMdico', 'FrmFicheroExamenMedico.btnIrAFicha');
  AgregarMenuControl('mnuFicheroPersona', 'FrmPersona.btnEliminar');
{$ENDIF}

  //  FINANZAS
{$IFDEF FINANZAS}
  AgregarMenuControl('mnuFicherosAnticipoParaGastos', 'FrmPresupuestoAnticipo.btnDesfiniquitar');

  AgregarMenuControl('mnuFicherosRendicionCuentaDocumentoDigital', 'FrmRendicionCuentaDocumento.btnAgregar');
  AgregarMenuControl('mnuFicherosRendicionCuentaDocumentoDigital', 'FrmRendicionCuentaDocumento.mnuAdjuntarMasivo');
  AgregarMenuControl('mnuFicherosRendicionCuentaDocumentoDigital', 'FrmRendicionCuentaDocumento.btnEditar');
  AgregarMenuControl('mnuFicherosRendicionCuentaDocumentoDigital', 'FrmRendicionCuentaDocumento.btnEliminar');
{$ENDIF}

end;


procedure AgregarMenuControl(MenuPadre: string; NombreControl: string);
// Ej.  Botones : AgregarMenuControl('mnuPanelNuevoExpediente', 'FrmDocumento_v2.btnConsultor');
var
  AuxMenu: TMenuItemRecord;
begin

  // Cargo el menu auxiliar
  AuxMenu.ObjetoComponente := NombreControl;
  AuxMenu.Caption := NombreControl;
  AuxMenu.Permitido := False;
  AuxMenu.OmitirPermiso := True;
  AuxMenu.Control := True;

  // Recorro el Arbol para localizar el menu y agrego el control
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    begin
      if Item.Data.ObjetoComponente = MenuPadre then
      begin
        // Cargo el menu auxiliar
        Item.Add(AuxMenu);
      end
      else
      begin
        // Salgo del ciclo si no encuentro el item
        Exit;
      end;

    end);
end;


procedure procMenuHerramientasOrganizacion;
begin
  // Se le tiene que pasar el nombre del objeto que se quiere verificar si tiene permiso
  // en este caso es un menu
  if DMUsuario.VerificarPrivilegios('mnuHerramientasOrganizacion') = True then
  begin
    FrmOrganizacion.Show;
  end;
end;


procedure OcultarMenuSinAcceso;
var
  i: Integer;
begin

  // Cargo los permisos disponibles del usuario y selecciono aquellos que tengan permitido
  DMUsuario.MSPermisosDisponibles.Close;
  DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Value := DMUsuario.UsuarioRecord.IdUsuario;
  DMUsuario.MSPermisosDisponibles.ParamByName('Modulo').Value := ObtenerNombreModulo;
  DMUsuario.MSPermisosDisponibles.ParamByName('TipoComponente').Value := TipoComponenteMenu;

  // Abro el dataset
  DMUsuario.MSPermisosDisponibles.Open;

  // Recorro el arbol de menu
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    var
      ObjetoComponente: string;
    begin
      // Si no esta omitido como permiso, lo cargo
      if Item.Data.OmitirPermiso = False then
      begin

        ObjetoComponente := Item.Data.ObjetoComponente;

        // Si Se encuentra el permiso el en dataset, hacerlo permitido
        if DMUsuario.MSPermisosDisponibles.Locate('ObjetoComponente', ObjetoComponente, []) = True then
        begin
          Item.Data.Permitido := True;
        end
        else
          begin
            Item.Data.Permitido := False;
          end;

          // En caso que se trate del menu herramientas, y sea el usuario administrador siempre debera estar visible
          if Item.Data.ObjetoComponente = 'mnuHerramientasUsuarios' then
            begin
              if DMUsuario.UsuarioRecord.LoginUsuario = 'Admin' then
              begin
                Item.Data.Permitido := True;
              end;

            end;
      end;

    end);



  // Segundo paso separar los items que seran visibles
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    var
      Aux, Aux2: integer;
    begin

      aux:= 0;
      Aux2:= 0;

      if Item.Data.Control = False then
      begin
        // Aqui vamos a saber el hijo auxiliar

        // Si tiene hijos
        if Item.Count > 0 then
        begin

          // Recorro los subitems
          Item.ForEach(procedure(const XItem: TNode<TMenuItemRecord>)
          begin

            if Xitem.Data.Control = False then
            begin
              Aux := Aux + 1;

              // Si no hay ninguno permitido
              if xitem.Data.Permitido = True then
              begin
                aux2 := aux2 + 1;
              end;
            end;

          end);

        end;

        if aux = 0 then
        begin
          if Item.Data.Permitido = True then
          begin
            Item.Data.MenuItem.Visible := True;
          end
          else
            begin
              Item.Data.MenuItem.Visible := False;
            end;
        end;

        if aux2 = 0 then
        begin
          if Item.Data.Permitido = True then
          begin
            Item.Data.MenuItem.Visible := True;
          end
          else
            begin
              Item.Data.MenuItem.Visible := False;
            end;
        end;


      end;

    end);
end;


procedure OcultarUnMenu(TreeMenu: TUniTreeMenu; Menu: TUniMenuItems; Indice: Integer);
var
  I: Integer;
  _llist: string;
begin
  with TreeMenu do
  begin
    Menu.Items[Indice].Visible := False;

    _llist := '';
    for I := 0 to Menu.Items.Count-1 do
      if not Menu.Items[I].Visible then
        if _llist='' then _llist := '"'+Menu.Items[I].Caption+'"'
        else _llist := _llist + ',"' + Menu.Items[I].Caption+'"';

    if _llist<>'' then
    begin
      JSInterface.JSCall('getStore().clearFilter', []);
      JSInterface.JSCode(#1'.getStore().filterBy(function (record){ if (['+ _llist +'].indexOf(record.get("text"))>-1) return false; else return true;});');
    end
    else
      JSInterface.JSCall('getStore().clearFilter', []);
  end;
end;

procedure OcultarLineaMenus(Menu: TUniMainMenu);

  procedure ProcesarMenuItem(AMenu: TUniMenuItem);
  var
    i: integer;
  begin

    // Recorro en un ciclo el menu
    for i := 0 to AMenu.Count - 1 do
    begin

      // En caso que el caption tenga una linea
      if AMenu[i].Caption = '-' then
      begin
        AMenu[i].Visible := False;
      end;

      // Vuelvo a procesar recursivamente
      ProcesarMenuItem(AMenu[i]);
    end;

  end;
begin

  // Recorro el menu, recursivamente
  ProcesarMenuItem(Menu.Items);
end;


procedure MostrarTodosMenus(Menu: TUniMainMenu);

  procedure ProcesarMenuItem(AMenu: TUniMenuItem);
  var
    i: integer;
  begin

    // Recorro en un ciclo el menu
    for i := 0 to AMenu.Count - 1 do
    begin
      // Hago visible el menu
      AMenu[i].Visible := True;

      // Vuelvo a procesar recursivamente
      ProcesarMenuItem(AMenu[i]);
    end;

  end;
begin

  // Recorro el menu, recursivamente
  ProcesarMenuItem(Menu.Items);
end;


procedure procMenuHerramientasUsuarios;
begin
  // Verifico que en caso que sea el admin, salto de largo
  if (DMUsuario.UsuarioRecord.LoginUsuario <> 'Admin') then
  begin
    // Se le tiene que pasar el nombre del objeto que se quiere verificar si tiene permiso
    // en este caso es un menu
    if DMUsuario.VerificarPrivilegios('mnuHerramientasUsuarios') = True then
    begin
      FrmUsuario.EnviadoDesdeFrm := 'MainForm';
      FrmUsuario.Show;
    end;
  end
  else
    begin
      // Muestro directamente la pantalla de usuarios
      FrmUsuario.EnviadoDesdeFrm := 'MainForm';
      FrmUsuario.Show;
    end;
end;


procedure CargarLogotipoFondo;
begin
  {$IF DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE) OR
       DEFINED(AUTOSERVICIOWEB)}
      // Verifico la validez del archivo de fondo para poder mostrar
      if VerificarValidoLogotipoFondo = True then
      begin
        CerrarFormulariosAbiertos(FrmInicioLogotipo);
        FrmInicioLogotipo.Parent := MainForm.UniContainerPanel;
        FrmInicioLogotipo.Show();
        MainForm.lblTituloPanelVentana.Caption := '';
        MainForm.PanelVentana.Visible := True;

      end // Si no es valido oculto el panel ventana
      else
        begin
          MainForm.PanelVentana.Visible := False;
        end;
  {$ENDIF}

  {$IF DEFINED(RAPY) OR
       DEFINED(AUDITORIA) }
  CerrarFormulariosAbiertos(FrmInicioLogotipo);
  MainForm.UniContainerPanel.Visible := True;
  FrmInicioLogotipo.Parent := MainForm.UniContainerPanel;
  FrmInicioLogotipo.Show();
  {$ENDIF}
end;


procedure CargarBienvenida;
begin
  // La bievenida solo se carga si no tiene LDAP (o sea es solo BD Interno)
  if DMUsuario.UsuarioRecord.LDAP = False then
  begin

    // Si no existe ningun inicio de sesion ejecuto la pantalla de inicio de bienvenida
    begin

      // Si la contrasena es por defecto
      if DMUsuario.UsuarioRecord.Contrasena = '123456' then
      begin
       // FrmInicioBienvenido.ShowModal();
      end

    end;

  end;
end;




end.
