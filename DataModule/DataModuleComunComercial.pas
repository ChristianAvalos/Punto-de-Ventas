unit DataModuleComunComercial;

interface

uses
  SysUtils, Classes, Data.DB, MemDS, DBAccess, MSAccess;

type
  TDMComunComercial = class(TDataModule)
    MSPrecio: TMSQuery;
    MSPrecioIdPrecio: TIntegerField;
    MSPrecioDescripcion: TStringField;
    DSPrecio: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMComunComercial: TDMComunComercial;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal;

function DMComunComercial: TDMComunComercial;
begin
  Result := TDMComunComercial(UniMainModule.GetModuleInstance(TDMComunComercial));
end;

initialization
  RegisterModuleClass(TDMComunComercial);

end.
