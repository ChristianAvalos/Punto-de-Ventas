unit DataModuleComunGlobal;

interface

uses
  SysUtils, Classes, Data.DB, MemDS, DBAccess, MSAccess;

type
  TDMComunGlobal = class(TDataModule)
    MSMoneda: TMSQuery;
    MSMonedaIdMoneda: TIntegerField;
    MSMonedaDescripcion: TStringField;
    MSMonedaSimbolo: TStringField;
    MSMonedaISO4217: TStringField;
    DSMoneda: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMComunGlobal: TDMComunGlobal;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule, DataModulePrincipal;

function DMComunGlobal: TDMComunGlobal;
begin
  Result := TDMComunGlobal(UniMainModule.GetModuleInstance(TDMComunGlobal));
end;

initialization
  RegisterModuleClass(TDMComunGlobal);

end.
