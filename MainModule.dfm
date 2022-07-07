object UniMainModule: TUniMainModule
  Theme = 'uni_mac_yosemite'
  TouchTheme = 'material'
  DocumentKeyOptions = [dkDisableBackSpace, dkDisableF5]
  BrowserOptions = [boDisableMouseRightClick, boDisableChromeRefresh]
  MonitoredKeys.Keys = <
    item
    end>
  ServerMessages.UnavailableErrMsg = 'Error de comunicaci'#243'n'
  ServerMessages.LoadingMessage = 'Cargando...'
  ServerMessages.InvalidSessionMessage = 'Sesi'#243'n o sesi'#243'n no v'#225'lida.'
  ServerMessages.TerminateMessage = 'Sesi'#243'n Web finalizada.'
  ApplicationDataModuleOptions.CreateOnDemand = True
  Height = 482
  Width = 664
end
