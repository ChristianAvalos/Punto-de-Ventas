unit FormularioUsuarioPermisoFormulario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,System.Variants,
  System.Classes, Vcl.Graphics, System.StrUtils, DBAccess, MSAccess,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioPopupCRUDMaestro, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel, uniMemo, uniMultiItem, uniComboBox, uniListBox,
  uniLabel, uniBasicGrid, uniDBGrid, Data.DB, FormularioInfoPopupMaestro,
  uniImageList;

type
  TFrmUsuarioPermisoFormulario = class(TFrmInfoPopupMaestro)
    UniDBGridControl: TUniDBGrid;
    lnkSeleccionarTodos: TUniLabel;
    lnkDesmarcarTodos: TUniLabel;
    procedure btnCancelarClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure lnkSeleccionarTodosClick(Sender: TObject);
    procedure lnkDesmarcarTodosClick(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    procedure CargarControlesDisponibles;
    procedure CargarPermisosControlesUsuario;
    procedure OnShowCargarPermisoMasivo;
    procedure OnCloseGuardarPermisoMasivo;
    function ValidarMenuBtnExiste(NombreMenu: string): Boolean;

    var
      I : Integer;
  public
    { Public declarations }
  end;

function FrmUsuarioPermisoFormulario: TFrmUsuarioPermisoFormulario;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Main, DataModuleUsuario, UnitRecursoString,
  DataModuleComunUsuario,
  UnitMenuEventos, UnitVerificarModulo,
  //UnitLog,
  UnitDatos, UnitCodigosComunesDataModule,UnitCodigosComunes;

function FrmUsuarioPermisoFormulario: TFrmUsuarioPermisoFormulario;
begin
  Result := TFrmUsuarioPermisoFormulario(UniMainModule.GetFormInstance(TFrmUsuarioPermisoFormulario));
end;


procedure TFrmUsuarioPermisoFormulario.btnCancelarClick(Sender: TObject);
begin
  inherited;
  // Cerrar
  Close;
end;


procedure TFrmUsuarioPermisoFormulario.CargarControlesDisponibles;
begin

  ActivarTablaVirtual(Self.Name, DMComunUsuario.VTControl);

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.AfterPost := DMComunUsuario.VTControl.AfterPost;
  DMComunUsuario.VTControl.AfterPost := nil;

  // Dehabilito los controles para optimizar
  DMComunUsuario.VTControl.DisableControls;

  // Recorro el Arbol para localizar el menu y agrego el control
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    begin

      // Siempre que se trate de un control
      if Item.Data.Control = True then
      begin
        // Siempre y cuando sea dependiente del padre
        // if Item.Parent.Data.MenuItem.Name = DMComunUsuario.VTMenuObjetoComponente.Value then
        if Item.Parent.Data.ObjetoComponente = DMComunUsuario.VTMenuObjetoComponente.Value then
        begin
          // Agrego los objetos
          DMComunUsuario.VTControl.Append;
          DMComunUsuario.VTControlObjetoComponente.Value := Item.Data.Caption;
          DMComunUsuario.VTControlTipoComponente.Value := 'Control';
          DMComunUsuario.VTControl.Post;
        end;

      end;

    end);

  // Habilito de vuelta
  DMComunUsuario.VTControl.EnableControls;

  // Restauro los eventos
  DMComunUsuario.VTControl.AfterPost := DMComunUsuario.VTAux.AfterPost;
end;



procedure TFrmUsuarioPermisoFormulario.OnCloseGuardarPermisoMasivo;
  var
    I : Integer;
begin
   with DMComunUsuario do
  begin
    // solo hacer si esta activo
    if VTBotonAux.Active then
    begin
      VTControl.First;

      for I := 1 to DMComunUsuario.VTControl.RecordCount do
      begin
        if ValidarMenuBtnExiste(VTControlObjetoComponente.Value) = True then
        begin
           if VTBotonAux.Locate('ObjetoComponente',VTControlObjetoComponente.Value,[]) then
           begin
             VTBotonAux.Edit;
             VTBotonAuxPermitido.Value := VTControlPermitido.Value;
             VTBotonAux.Post;
           end;
        end
        else
        begin

          VTBotonAux.Append;
          VTBotonAuxPermitido.Value := VTControlPermitido.Value;
          VTBotonAuxIdMenuPadre.Value := VTControlIdMenuPadre.Value;
          VTBotonAuxObjetoComponente.Value := VTControlObjetoComponente.Value;
          VTBotonAuxTipoComponente.Value := VTControlTipoComponente.Value;
          VTBotonAuxTipoAcceso.Value := VTControlTipoAcceso.Value;
          VTBotonAux.Post;

        end;

        VTControl.Next;
      end;
      {$IFDEF DEBUG}
      VTBotonAux.First;
     // Log('');
      for I := 1 to VTBotonAux.RecordCount do
      begin
//        Log('---------------------' + IntToStr(I) + '---------------------');
//        Log(VTBotonAux.Name + ' ' + VTBotonAux.Fields[0].Name + ' := ' + VTBotonAux.Fields[0].AsString);
//        Log(VTBotonAux.Name + ' ' + VTBotonAux.Fields[1].Name + ' := ' + VTBotonAux.Fields[1].AsString);
//        Log(VTBotonAux.Name + ' ' + VTBotonAux.Fields[2].Name + ' := ' + VTBotonAux.Fields[2].AsString);
//        Log(VTBotonAux.Name + ' ' + VTBotonAux.Fields[3].Name + ' := ' + VTBotonAux.Fields[3].AsString);
//        Log(VTBotonAux.Name + ' ' + VTBotonAux.Fields[4].Name + ' := ' + VTBotonAux.Fields[4].AsString);

        VTBotonAux.Next;
      end;
      //Log('');
      {$ENDIF}
    end;
  end;



end;

procedure TFrmUsuarioPermisoFormulario.OnShowCargarPermisoMasivo;
var
  Aux, I: Integer;
begin

  if (DMComunUsuario.VTBotonAux.Active) then
  begin
    DMComunUsuario.VTControl.First;

    for I := 1 to DMComunUsuario.VTControl.RecordCount do
    begin

      DMComunUsuario.VTBotonAux.First;

      for Aux := 1 to DMComunUsuario.VTBotonAux.RecordCount do
      begin

        if (DMComunUsuario.VTControlObjetoComponente.Value = DMComunUsuario.VTBotonAuxObjetoComponente.Value) then
        begin
         // Log(DMComunUsuario.VTControlObjetoComponente.AsString + ' - '+DMComunUsuario.VTBotonAuxObjetoComponente.AsString);
          DMComunUsuario.VTControl.Edit;
          DMComunUsuario.VTControlPermitido.Value := DMComunUsuario.VTBotonAuxPermitido.Value;
          DMComunUsuario.VTControl.Post;

        end;

        DMComunUsuario.VTBotonAux.Next;
      end;
    end;
    DMComunUsuario.VTControl.Next;

  end;

end;


procedure TFrmUsuarioPermisoFormulario.CargarPermisosControlesUsuario;
var DataSet : TMSQuery;
begin

  case AnsiIndexStr(EnviadoDesdeFrm, ['FrmRol']) of

    0 : // FrmRol
    begin
//      DataSet := DMUsuario.MSRolOperacion;
//
//      DMComunUsuario.EnviadoDesdeFrm := EnviadoDesdeFrm;
//
//      DataSet.Close;
//      DataSet.ParamByName('IdRol').Value := DMUsuario.MSRolIdRol.Value;
//      DataSet.ParamByName('Modulo').Value := ObtenerNombreModulo;
    end;

    -1 :
    begin
       DataSet:=DMUsuario.MSPermisosDisponibles;

      // Cargo los permisos disponibles del usuario y selecciono aquellos que tengan permitido
      DataSet.Close;
      DataSet.ParamByName('IdUsuario').Value := DMUsuario.MSUsuarioIdUsuario.Value;
      DataSet.ParamByName('Modulo').Value := ObtenerNombreModulo;
      DataSet.ParamByName('TipoComponente').Value := 'Control';
    end;
  end;

  // Abro el dataset
  DataSet.Open;

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.AfterPost := DMComunUsuario.VTControl.AfterPost;
  DMComunUsuario.VTControl.AfterPost := nil;

  // Deshabilito el dataset
  DataSet.DisableControls;

  // Recorro los permisos disponibles
  while DataSet.Eof = False do
  begin

    // En caso de localizar un item dentro de los menus seleccionados, le marco los permisos
    if DMComunUsuario.VTControl.Locate('ObjetoComponente', DataSet.FieldByName('ObjetoComponente').value , []) = True then
    begin

       if DMComunUsuario.VTControl.State <> dsEdit then
      begin
        try
            DMComunUsuario.VTControl.Edit;
            DMComunUsuario.VTControlPermitido.Value := True;
            DMComunUsuario.VTControl.Post;

        except
          on E: Exception do
          begin
          //  Log(EExcepcion + Self.Name + ' CargarMenuControl ' + E.Message);
            MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
          end;
        end;
      end;

    end;

    // Salto al siguiente registro
    DataSet.Next;

  end;

  // Restauro los eventos
  DMComunUsuario.VTControl.AfterPost := DMComunUsuario.VTAux.AfterPost;
end;


procedure TFrmUsuarioPermisoFormulario.lnkDesmarcarTodosClick(Sender: TObject);
begin
  inherited;

  SeleccionarRegistros(DMComunUsuario.VTControlPermitido, False);

end;


procedure TFrmUsuarioPermisoFormulario.lnkSeleccionarTodosClick(
  Sender: TObject);
begin
  inherited;
  SeleccionarRegistros(DMComunUsuario.VTControlPermitido, True);
end;

procedure TFrmUsuarioPermisoFormulario.UniFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  // Al cerrar verifico si el dataset de permisos VT quedo en modo edicion
  if DMComunUsuario.VTControl.State in dsEditModes then
  begin
    DMComunUsuario.VTControl.Post;
  end;

  OnCloseGuardarPermisoMasivo;
end;

procedure TFrmUsuarioPermisoFormulario.UniFormShow(Sender: TObject);
begin
  inherited;
  CargarControlesDisponibles;
  CargarPermisosControlesUsuario;
  OnShowCargarPermisoMasivo;
end;


function TFrmUsuarioPermisoFormulario.ValidarMenuBtnExiste
  (NombreMenu: string): Boolean;
var
  I: Integer;
begin

  Result := False;
  for I := 1 to DMComunUsuario.VTBotonAux.RecordCount do
  begin
    if (DMComunUsuario.VTBotonAuxObjetoComponente.Value = NombreMenu) then
    begin
      Result := True;
      Break;
    end;
  end;

end;

end.

