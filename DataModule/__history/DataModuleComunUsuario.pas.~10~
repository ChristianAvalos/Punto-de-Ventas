unit DataModuleComunUsuario;

{$INCLUDE 'compilador.inc'}

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS,  Vcl.Dialogs, DBAccess, MSAccess,
  {$IFDEF WEB}
  uniGUIDialogs, uniMainMenu,
  {$ENDIF}

  VirtualTable, System.StrUtils;


type
  TDMComunUsuario = class(TDataModule)
    VTMenu: TVirtualTable;
    DSMenu: TDataSource;
    VTMenuObjetoComponente: TStringField;
    VTMenuCaption: TStringField;
    VTMenuPermitido: TBooleanField;
    VTMenuTipoAcceso: TStringField;
    VTMenuSoportaTipoAcceso: TBooleanField;
    VTAux: TVirtualTable;
    VTMenuTipoComponente: TStringField;
    VTMenuObjetosHijos: TIntegerField;
    VTMenuNivel: TIntegerField;
    VTMenuIdMenu: TStringField;
    VTMenuIdMenuPadre: TStringField;
    VTMenuControl: TBooleanField;
    VTMenuControlesHijos: TIntegerField;
    VTMenuIcono: TStringField;
    VTControl: TVirtualTable;
    DSControl: TDataSource;
    VTControlPermitido: TBooleanField;
    VTControlObjetoComponente: TStringField;
    VTControlTipoComponente: TStringField;
    VTControlObjetosHijos: TIntegerField;
    VTControlIdMenuPadre: TStringField;
    VTControlTipoAcceso: TStringField;
    VTMenuControlesHijosPermitido: TIntegerField;
    VTUsuario: TVirtualTable;
    VTUsuarioIdUsuario: TIntegerField;
    VTBotonAux: TVirtualTable;
    VTBotonAuxObjetoComponente: TStringField;
    VTBotonAuxPermitido: TBooleanField;
    VTBotonAuxTipoComponente: TStringField;
    VTBotonAuxObjetosHijos: TIntegerField;
    VTBotonAuxIdMenuPadre: TStringField;
    VTBotonAuxTipoAcceso: TStringField;
    DSRol: TDataSource;
    MSRol: TMSQuery;
    MSRolIdRol: TIntegerField;
    MSRolDescripcion: TStringField;
    MSUsuario: TMSQuery;
    MSModulo: TMSQuery;
    DSUsuario: TDataSource;
    DSModulo: TDataSource;
    MSUsuarioIdUsuario: TIntegerField;
    MSUsuarioNombreUsuario: TStringField;
    MSModuloIdModulo: TIntegerField;
    MSModuloDescripcion: TStringField;
    procedure VTMenusBeforePost(DataSet: TDataSet);
    procedure VTMenuAfterPost(DataSet: TDataSet);
    procedure VTMenuCalcFields(DataSet: TDataSet);
    procedure VTControlAfterPost(DataSet: TDataSet);
    procedure VTControlCalcFields(DataSet: TDataSet);
    procedure MSUsuarioBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    FEnviadoDesdeFrm: string;

  public
    { Public declarations }
    procedure CargarOperaciones;
    procedure PermisosCRUD(Dataset: TDataSet);
    procedure PermisosOperacionesCRUD(Dataset: TDataSet);

  published
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

  // Compilador condicional cuando el DataModule se ejecuta en escritorio / servicio
  {$IF DEFINED(DESKTOP) OR DEFINED(SERVICE)}
  var DMComunUsuario: TDMComunUsuario;
  {$ENDIF}

  // Compilador condicional cuando el DataModule se ejecuta en Web
  {$IFDEF WEB}
  function DMComunUsuario: TDMComunUsuario;
  {$ENDIF}


implementation

{$R *.dfm}

uses
  DataModulePrincipal,

  {$IFDEF WEB}
  UniGUIVars, uniGUIMainModule, MainModule, UniGUIApplication, ServerModule,
  FormularioUsuarioPermiso,UnitMenuEventos,
  {$ENDIF}

  //UnitLog,
   DataModuleUsuario, UnitVerificarModulo,
  UnitRecursoString, UnitAuditoria, UnitCodigosComunesDataModule,
  UnitCodigosComunesString, UnitCodigosComunes, UnitDatos;
  // UnitLogParametro;


{$IFDEF WEB}
function DMComunUsuario: TDMComunUsuario;
begin
  Result := TDMComunUsuario(UniMainModule.GetModuleInstance(TDMComunUsuario));
end;
{$ENDIF}


procedure TDMComunUsuario.CargarOperaciones;
var
  I: Integer;
begin
  {$IFDEF WEB}

  // Cargo el menu definido en el Virtual Table para visualizar
  ActivarTablaVirtual(Self.Name, DMComunUsuario.VTMenu);

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.AfterPost := DMComunUsuario.VTMenu.AfterPost;
  DMComunUsuario.VTMenu.AfterPost := nil;

  // Dehabilito los controles para optimizar
  DMComunUsuario.VTMenu.DisableControls;


//  if Arbol = nil then
//  begin
//     Arbol := TNode<TMenuItemRecord>.Create;
//  end;

  // Recorro el arbol de menu, y voy cargando objetos
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    var
      TieneObjetosHijos, TieneHijosControles, TieneHijosControlesPermitidos: integer;
    begin
      // Si no esta omitido como permiso, lo cargo
      if (Item.Data.OmitirPermiso = False) then
      begin

        DMComunUsuario.VTMenu.Append;

        // En caso que el parent no sea el principal
        if Item.Parent.Index <> -1 then
        begin
          // El IdMenu
          DMComunUsuario.VTMenuIdMenu.Value := IntToStr(Item.Level) + IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Index) + NumeroTextoOrden(Item.Index);

          // El IdMenuPadre
          case Item.Level of
            2: // Nivel 2
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Index);
            end;

            3: // Nivel 3 (Se agrega dos niveles de parent)
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Parent.Level) + IntToStr(Item.Parent.Parent.Index) + NumeroTextoOrden(Item.Parent.Index);
            end;

            4: // Nivel 4 (Se agrega tres niveles de parent)
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Parent.Level) + IntToStr(Item.Parent.Parent.Index) + NumeroTextoOrden(Item.Parent.Index);
            end;
          end;

        end
        else
          begin
            // En caso que no tenga parent, o sea e principal
            DMComunUsuario.VTMenuIdMenu.Value := IntToStr(Item.Level) + IntToStr(Item.Index);
            DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Index);
          end;


        DMComunUsuario.VTMenuObjetoComponente.Value := Item.Data.MenuItem.Name;

        DMComunUsuario.VTMenuCaption.Value := Item.Data.Caption;
        DMComunUsuario.VTMenuPermitido.Value := False;
        DMComunUsuario.VTMenuSoportaTipoAcceso.Value := Item.Data.SoportaTipoAcceso;
        DMComunUsuario.VTMenuTipoComponente.Value := TipoComponenteMenu;

        DMComunUsuario.VTMenuNivel.Value := Item.Level;

        // Si se trata del nivel 4, no se contaran los items
        TieneObjetosHijos := 0;
        TieneHijosControles := 0;
        TieneHijosControlesPermitidos := 0;

        Item.ForEach(
          procedure(const SubItem: TNode<TMenuItemRecord>)
          begin

            if SubItem.Data.OmitirPermiso = False then
            begin
              TieneObjetosHijos := TieneObjetosHijos + 1;
            end;

            if SubItem.Data.Control = True then
            begin
              TieneHijosControles := TieneHijosControles + 1;

              // Verifico si hay datos en los controles
              if DMUsuario.MSPermisosDisponibles.RecordCount > 0 then
              begin
                // Localizo y encuentro los controles permitidos
                if DMUsuario.MSPermisosDisponibles.Locate('ObjetoComponente', SubItem.Data.Caption, []) then
                begin
                  TieneHijosControlesPermitidos := TieneHijosControlesPermitidos + 1;
                end;
              end;

            end;

          end);

        DMComunUsuario.VTMenuObjetosHijos.Value := TieneObjetosHijos;
        DMComunUsuario.VTMenuControlesHijos.Value := TieneHijosControles;
        DMComunUsuario.VTMenuControlesHijosPermitido.Value := TieneHijosControlesPermitidos;


        {$IFDEF DOCUMENTALLITE}
        //Oculto las opciones de liquidación en los clientes que no sean 'SEAM'
        if not(DMPrincipal.NombreCliente = 'SEAM') then
        begin
          if (Pos('PanelFichero', Item.Data.ObjetoComponente) <> 0) then
          begin
            DMComunUsuario.VTMenu.Cancel;
          end
        end;

        if (Pos('mnuPanelInicio', Item.Data.ObjetoComponente) <> 0) then
        begin
          DMComunUsuario.VTMenu.Cancel;
        end;
        {$ENDIF}

        //=================================================
        if DMComunUsuario.VTMenu.State in dsEditModes then
        begin
          DMComunUsuario.VTMenu.Post;
        end;
      end;

    end);

  //inserto
  DMComunUsuario.VTMenu.First;

  while not(DMComunUsuario.VTMenu.eof) do
  begin


    VaciarParametros(DMUsuario.MSInsertarOperacion);
    DMUsuario.MSInsertarOperacion.ParamByName('Modulo').Value := ObtenerNombreModulo;
    DMUsuario.MSInsertarOperacion.ParamByName('ObjetoComponente').Value := VTMenuObjetoComponente.value ;
    DMUsuario.MSInsertarOperacion.ParamByName('TipoComponente').Value := VTMenuTipoComponente.value;
    DMUsuario.MSInsertarOperacion.ParamByName('Caption').Value := VTMenuCaption.value;
    DMUsuario.MSInsertarOperacion.ExecSQL;

    DMComunUsuario.VTMenu.next;

  end;

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
        //if Item.Parent.Data.ObjetoComponente = DMComunUsuario.VTMenuObjetoComponente.Value then
        begin
          // Agrego los objetos
          DMComunUsuario.VTControl.Append;
          DMComunUsuario.VTControlObjetoComponente.Value := Item.Data.Caption;
          DMComunUsuario.VTControlTipoComponente.Value := 'Control';
          DMComunUsuario.VTControl.Post;
        end;

      end;

    end);

   ActivarTablaVirtual(Self.Name, DMComunUsuario.VTControl, False);
  //inserto
  DMComunUsuario.VTControl.first ;

  while not(DMComunUsuario.VTControl.eof) do
  begin

    VaciarParametros(DMUsuario.MSInsertarOperacion);
    DMUsuario.MSInsertarOperacion.ParamByName('Modulo').Value := ObtenerNombreModulo;
    DMUsuario.MSInsertarOperacion.ParamByName('ObjetoComponente').Value := VTControlObjetoComponente.value ;
    DMUsuario.MSInsertarOperacion.ParamByName('TipoComponente').Value := VTControlTipoComponente.value;
   // DMUsuario.MSInsertarOperacion.ParamByName('Caption').Value := VTControlCaption.value;
    DMUsuario.MSInsertarOperacion.ExecSQL;

    DMComunUsuario.VTControl.next;

  end;


  // Habilito de vuelta
  DMComunUsuario.VTControl.EnableControls;

  // Restauro los eventos
  DMComunUsuario.VTControl.AfterPost := DMComunUsuario.VTAux.AfterPost;





  // Habilito de vuelta
  DMComunUsuario.VTMenu.EnableControls;

  // Restauro los eventos
  DMComunUsuario.VTMenu.AfterPost := DMComunUsuario.VTAux.AfterPost;

  {$ENDIF}
end;



procedure TDMComunUsuario.MSUsuarioBeforeOpen(DataSet: TDataSet);
begin
  AsignarIdOrganizacion(DataSet);
end;

procedure TDMComunUsuario.PermisosCRUD(Dataset: TDataSet);
var
  DatasetUsuario: TMSQuery;
  DatasetVerificarPermiso: TMSQuery;
  QryBorrarPermiso: TMSSQL;
begin

  DatasetUsuario := DMUsuario.MSUsuario;
  DatasetVerificarPermiso := DMUsuario.MSVerificarPermiso;
  QryBorrarPermiso := DMUsuario.MSBorrarPermiso;

      if Dataset.FieldByName('Permitido').Value = True then
      begin

        // Verifico que el menu ya exista en la db
        DatasetVerificarPermiso.Close;
        DatasetVerificarPermiso.Params.ParamByName('IdUsuario').Value := DatasetUsuario.FieldByName('IdUsuario').AsInteger;
        DatasetVerificarPermiso.Params.ParamByName('Modulo').Value := ObtenerNombreModulo;
        DatasetVerificarPermiso.Params.ParamByName('ObjetoComponente').Value := Dataset.FieldByName('ObjetoComponente').Value;
        DatasetVerificarPermiso.Open;


        // En caso que no exista aun el permiso en la base de datos agregarlo
        if DatasetVerificarPermiso.RecordCount = 0 then
        begin
          // Capturo dentro de un bloque try
          try
            if Dataset.FieldByName('TipoComponente').AsString <> '' then
            begin
              // En caso que se trate de un menu padre no hace nada
              if (Dataset.FieldByName('ObjetosHijos').Value > 0) and (Dataset.FieldByName('IdMenuPadre').AsString = '-1') then
              begin
                // O sea si tiene hijos y no tiene padre
                // No pasa nada
              end
              else // en Caso contrario, agrego el registro
                begin
                  DatasetVerificarPermiso.Append;
                  DatasetVerificarPermiso.FieldByName('ObjetoComponente').AsString := Dataset.FieldByName('ObjetoComponente').AsString;
                  DatasetVerificarPermiso.FieldByName('TipoComponente').AsString := Dataset.FieldByName('TipoComponente').AsString;
                  DatasetVerificarPermiso.FieldByName('TipoAcceso').AsString := Dataset.FieldByName('TipoAcceso').AsString;

                  // Cargo la auditoria
                  CargarValoresAuditoria(DatasetVerificarPermiso);

                  // Hago post
                  DatasetVerificarPermiso.Post;

                  {$IFDEF RHMINI}
                  // Hago apply updates en caso de RHmini (usa desconectado)
                  DatasetVerificarPermiso.ApplyUpdates();
                  {$ENDIF}
                end;
            end;
          except
            on E: Exception do
            begin

              //Log(EExcepcion + Self.Name + ' ' + E.Message);

              {$IFDEF WEB}
              MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
              {$ENDIF}

              {$IFDEF DESKTOp}
              MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
              {$ENDIF}

            end;
          end;

        end
        else // En caso que exista el permiso, edito el contenido de las demas propiedades
          begin
            // Capturo dentro de un bloque try
            try
              DatasetVerificarPermiso.Edit;
              // Solo se modifica el tipo de acceso
              DatasetVerificarPermiso.FieldByName('TipoAcceso').AsString := Dataset.FieldByName('TipoAcceso').AsString;

              // Cargo la auditoria
              CargarValoresAuditoria(DatasetVerificarPermiso);

              DatasetVerificarPermiso.Post;

              {$IFDEF RHMINI}
              // Hago apply updates en caso de RHmini (usa desconectado)
              DatasetVerificarPermiso.ApplyUpdates();
              {$ENDIF}

            except
              on E: Exception do
              begin

               // Log(EExcepcion + Self.Name + ' ' + E.Message);

                {$IFDEF WEB}
                MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
                {$ENDIF}

                {$IFDEF DESKTOp}
                MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
                {$ENDIF}
              end;
            end;
          end;

      end
      else
        begin
          // DMUsuario.MSBorrarPermiso.Close;
          QryBorrarPermiso.ParamByName('IdUsuario').AsInteger := DatasetUsuario.FieldByName('IdUsuario').AsInteger;
          QryBorrarPermiso.ParamByName('Modulo').AsString := ObtenerNombreModulo;
          QryBorrarPermiso.ParamByName('ObjetoComponente').AsString := Dataset.FieldByName('ObjetoComponente').Value;
          QryBorrarPermiso.Execute;
        end;

end;


procedure TDMComunUsuario.PermisosOperacionesCRUD(Dataset: TDataSet);
var
  DatasetUsuario: TMSQuery;
  DatasetVerificarPermiso: TMSQuery;
  DatasetInsertarOperacion : TMSQuery;
  QryBorrarPermiso: TMSQuery;
begin

  DatasetUsuario := DMUsuario.MSRol;
  DatasetVerificarPermiso := DMUsuario.MSVerificarOperacion;
  DatasetInsertarOperacion := DMUsuario.MSInsertarRolOperacion;
  QryBorrarPermiso := DMUsuario.MSBorrarOperacion;

      if Dataset.FieldByName('Permitido').Value = True then
      begin

        // Verifico que el menu ya exista en la db
        DatasetVerificarPermiso.Close;
        DatasetVerificarPermiso.Params.ParamByName('IdRol').Value := DatasetUsuario.FieldByName('IdRol').AsInteger;
        DatasetVerificarPermiso.Params.ParamByName('Modulo').Value := ObtenerNombreModulo;
        DatasetVerificarPermiso.Params.ParamByName('ObjetoComponente').Value := Dataset.FieldByName('ObjetoComponente').Value;
        DatasetVerificarPermiso.Open;


        // En caso que no exista aun el permiso en la base de datos agregarlo
        if DatasetVerificarPermiso.RecordCount = 0 then
        begin
          // Capturo dentro de un bloque try
          try
            if Dataset.FieldByName('TipoComponente').AsString <> '' then
            begin
              // En caso que se trate de un menu padre no hace nada
              if (Dataset.FieldByName('ObjetosHijos').Value > 0) and (Dataset.FieldByName('IdMenuPadre').AsString = '-1') then
              begin
                // O sea si tiene hijos y no tiene padre
                // No pasa nada
              end
              else // en Caso contrario, agrego el registro
                begin

                  {DECLARE @IdRol INT = :IdRol,
                  @IdOperacion INT,
                  @UrevUsuario VARCHAR(50) = :UrevUsuario,
                  @ObjetoComponente VARCHAR(250) = :ObjetoComponente,
                  @TipoComponente VARCHAR(30) = :TipoComponente,
                  @Modulo VARCHAR(30) = :Modulo;}
                  //DatasetInsertarOperacion.Append;
                  DatasetInsertarOperacion.ParamByName('ObjetoComponente').AsString := Dataset.FieldByName('ObjetoComponente').AsString;
                  DatasetInsertarOperacion.ParamByName('TipoComponente').AsString := Dataset.FieldByName('TipoComponente').AsString;
                  DatasetInsertarOperacion.ParamByName('IdRol').Value := DatasetUsuario.FieldByName('IdRol').AsInteger;
                  DatasetInsertarOperacion.ParamByName('UrevUsuario').Value := DMUsuario.UsuarioRecord.LoginUsuario;
                  DatasetInsertarOperacion.ParamByName('Modulo').Value := ObtenerNombreModulo;
//                  DatasetInsertarOperacion.ParamByName('TipoAcceso').AsString := Dataset.FieldByName('TipoAcceso').AsString;

                  // Cargo la auditoria
                  CargarValoresAuditoria(DatasetInsertarOperacion);

                  // Hago post
                  DatasetInsertarOperacion.ExecSQL;

                  {$IFDEF RHMINI}
                  // Hago apply updates en caso de RHmini (usa desconectado)
                  DatasetInsertarOperacion.ApplyUpdates();
                  {$ENDIF}
                end;
            end;
          except
            on E: Exception do
            begin

             // Log(EExcepcion + Self.Name + ' ' + E.Message);

              {$IFDEF WEB}
              MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
              {$ENDIF}

              {$IFDEF DESKTOp}
              MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
              {$ENDIF}

            end;
          end;

        end
        else // En caso que exista el permiso, edito el contenido de las demas propiedades
          begin
//            // Capturo dentro de un bloque try
//            try
//              DatasetVerificarPermiso.Edit;
//              // Solo se modifica el tipo de acceso
//              DatasetVerificarPermiso.FieldByName('TipoAcceso').AsString := Dataset.FieldByName('TipoAcceso').AsString;
//
//              // Cargo la auditoria
//              CargarValoresAuditoria(DatasetVerificarPermiso);
//
//              DatasetVerificarPermiso.Post;
//
//              {$IFDEF RHMINI}
//              // Hago apply updates en caso de RHmini (usa desconectado)
//              DatasetVerificarPermiso.ApplyUpdates();
//              {$ENDIF}
//
//            except
//              on E: Exception do
//              begin
//
//                Log(EExcepcion + Self.Name + ' ' + E.Message);
//
//                {$IFDEF WEB}
//                MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
//                {$ENDIF}
//
//                {$IFDEF DESKTOp}
//                MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
//                {$ENDIF}
//              end;
//            end;
          end;

      end
      else
        begin
          // DMUsuario.MSBorrarPermiso.Close;
          QryBorrarPermiso.ParamByName('IdRol').Value := DatasetUsuario.FieldByName('IdRol').AsInteger;
          QryBorrarPermiso.ParamByName('Modulo').AsString := ObtenerNombreModulo;
          QryBorrarPermiso.ParamByName('ObjetoComponente').AsString := Dataset.FieldByName('ObjetoComponente').Value;
          QryBorrarPermiso.Execute;
        end;

end;

procedure TDMComunUsuario.VTControlAfterPost(DataSet: TDataSet);
begin
  case AnsiIndexStr(EnviadoDesdeFrm, ['FrmRol', 'FrmUsuarioPermiso']) of
    0 : // FrmRol
    begin
      PermisosOperacionesCRUD(DataSet);
    end;
    -1 , 1:
    begin
       PermisosCRUD(DataSet);
    end;
  end;
end;


procedure TDMComunUsuario.VTControlCalcFields(DataSet: TDataSet);
begin
  // Valores simplemente para poder ejecutar, sin complicar el codigo CRUD
  VTControlObjetosHijos.Value := 0;
  VTControlIdMenuPadre.Value := '0';
end;


procedure TDMComunUsuario.VTMenuAfterPost(DataSet: TDataSet);
begin
  case AnsiIndexStr(EnviadoDesdeFrm, ['FrmRol', 'FrmUsuarioPermiso']) of
    0 : // FrmRol
    begin
      PermisosOperacionesCRUD(DataSet);
    end;
    -1 , 1:
    begin
       PermisosCRUD(DataSet);
    end;
  end;
end;


procedure TDMComunUsuario.VTMenuCalcFields(DataSet: TDataSet);
begin
  if (VTMenuObjetosHijos.Value = 0) and (VTMenuControlesHijos.Value > 0) then
  begin
    if VTMenuControlesHijosPermitido.Value = 0 then
    begin
      VTMenuIcono.Value := 'S';
    end
    else
    begin
      VTMenuIcono.Value := 'X';
    end;
  end;
end;


procedure TDMComunUsuario.VTMenusBeforePost(DataSet: TDataSet);
begin

end;


{$IFDEF WEB}
initialization
  RegisterModuleClass(TDMComunUsuario);
{$ENDIF}



end.



