unit ServerModule;
{$INCLUDE 'compilador.inc'}


interface

uses
  Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication, uIdCustomHTTPServer,
  uniGUITypes;

type
  TUniServerModule = class(TUniGUIServerModule)
  procedure UniGUIServerModuleBeforeInit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, UnitServerModule, UnitVerificarModulo;

function UniServerModule: TUniServerModule;
begin
  Result:=TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
begin
  InitServerModule(Self);
end;
procedure TUniServerModule.UniGUIServerModuleBeforeInit(Sender: TObject);
begin
  // Establezco el puerto
  Port := ObtenerPuertoAplicacion;

  // Exploro solo si es Desktop y Web
  {$IF DEFINED(DEBUG)
  AND
       DEFINED(UNIGUI_VCL)}
    {$IF NOT DEFINED(UNIGUI_ISAPI) AND
     NOT DEFINED(UNIGUI_SERVICE) AND
     NOT DEFINED(HYPER)}
         ExploreWeb(pchar('http://localhost:' + IntToStr(Port)));
    {$ENDIF}
  {$ENDIF}
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
